-- =====================================================================
-- PUNTO DE VENTA · Rectoría del Templo de la Cruz
-- Actualización: FONDO DE CAJA INICIAL
-- Se ejecuta UNA vez en SQL Editor ▸ Run. No borra ni cambia ventas, gastos, cortes ni apartados.
--
-- Cómo funciona:
--   · Cada día se registra con cuánto efectivo abre la caja (un fondo por día; se puede corregir).
--   · El fondo NO es venta ni ingreso: solo se suma para saber cuánto efectivo debe haber en caja.
--   · El corte guarda el fondo del día: efectivo en caja = fondo + ventas en efectivo − gastos en efectivo.
-- =====================================================================

create table if not exists public.fondos (
  dia             date primary key,
  monto           numeric(12,2) not null check (monto >= 0),
  usuario         text not null,
  registro        text not null,
  registrado_por  uuid references auth.users(id) on delete set null,
  ts              timestamptz not null default now(),
  veces           integer not null default 1
);
alter table public.fondos enable row level security;
revoke all on public.fondos from anon;
revoke insert, update, delete, truncate on public.fondos from authenticated;
grant select on public.fondos to authenticated;
do $$ begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'fondos' and policyname = 'leer_fondos') then
    create policy leer_fondos on public.fondos for select to authenticated using (public.es_activo());
  end if;
end $$;

-- El corte guarda el fondo de ese día (vacío = no se registró fondo)
alter table public.cortes add column if not exists fondo numeric(12,2);

-- Registrar o corregir el fondo de un día (hoy o hasta 7 días atrás)
create or replace function public.registrar_fondo(p_dia date, p_monto numeric)
returns public.fondos language plpgsql security definer set search_path = public as $$
declare
  v_yo  public.perfiles%rowtype;
  v_hoy date := (now() at time zone 'America/Mexico_City')::date;
  v_m   numeric(12,2);
  v_r   public.fondos;
begin
  select * into v_yo from public.perfiles where id = auth.uid() and activo;
  if not found then raise exception 'Tu sesión terminó. Vuelve a entrar.' using errcode = '28000'; end if;
  if p_dia is null or p_dia > v_hoy then raise exception 'No se puede registrar el fondo de un día que todavía no llega.'; end if;
  if p_dia < v_hoy - 7 then raise exception 'Solo se puede registrar el fondo de hasta 7 días atrás.'; end if;
  v_m := round(p_monto, 2);
  if v_m is null or v_m < 0 or v_m > 1000000 then raise exception 'El monto del fondo no es válido.'; end if;
  insert into public.fondos (dia, monto, usuario, registro, registrado_por, ts)
  values (p_dia, v_m, v_yo.usuario, v_yo.nombre, auth.uid(), now())
  on conflict (dia) do update set
    monto = excluded.monto, usuario = excluded.usuario, registro = excluded.registro,
    registrado_por = excluded.registrado_por, ts = excluded.ts, veces = public.fondos.veces + 1
  returning * into v_r;
  return v_r;
end $$;
revoke execute on function public.registrar_fondo(date, numeric) from public, anon;
grant execute on function public.registrar_fondo(date, numeric) to authenticated;

-- Corte del día: igual que antes, y además guarda el fondo de caja de ese día
create or replace function public.hacer_corte(p_dia date)
returns public.cortes language plpgsql security definer set search_path = public as $$
declare v_nombre text; v_r public.cortes;
begin
  select nombre into v_nombre from public.perfiles where id = auth.uid() and activo;
  if v_nombre is null then raise exception 'Tu sesión terminó. Vuelve a entrar.' using errcode = '28000'; end if;
  if p_dia is null or p_dia > (now() at time zone 'America/Mexico_City')::date then
    raise exception 'No se puede hacer el corte de un día que todavía no llega.'; end if;
  insert into public.cortes (dia, ventas, canceladas, total, efectivo, transferencia, tarjeta,
                             egresos, egresos_efectivo, n_egresos, fondo, ultimo_folio, hecho_por, hecho_en)
  select p_dia,
         count(*) filter (where estado = 'ok'),
         count(*) filter (where estado = 'cancelada'),
         coalesce(sum(total) filter (where estado = 'ok'), 0),
         coalesce(sum(total) filter (where estado = 'ok' and metodo = 'efectivo'), 0),
         coalesce(sum(total) filter (where estado = 'ok' and metodo = 'transferencia'), 0),
         coalesce(sum(total) filter (where estado = 'ok' and metodo = 'tarjeta'), 0),
         (select coalesce(sum(monto), 0) from public.egresos where dia = p_dia and estado = 'ok'),
         (select coalesce(sum(monto), 0) from public.egresos where dia = p_dia and estado = 'ok' and metodo = 'efectivo'),
         (select count(*) from public.egresos where dia = p_dia and estado = 'ok'),
         (select monto from public.fondos where dia = p_dia),
         max(folio), v_nombre, now()
    from public.ventas where dia = p_dia
  on conflict (dia) do update set
    ventas = excluded.ventas, canceladas = excluded.canceladas, total = excluded.total,
    efectivo = excluded.efectivo, transferencia = excluded.transferencia, tarjeta = excluded.tarjeta,
    egresos = excluded.egresos, egresos_efectivo = excluded.egresos_efectivo, n_egresos = excluded.n_egresos,
    fondo = excluded.fondo,
    ultimo_folio = excluded.ultimo_folio, hecho_por = excluded.hecho_por, hecho_en = excluded.hecho_en,
    veces = public.cortes.veces + 1
  returning * into v_r;
  return v_r;
end $$;
revoke execute on function public.hacer_corte(date) from public, anon;
grant execute on function public.hacer_corte(date) to authenticated;

select 'fondo de caja listo' as resultado,
       (select count(*) from public.ventas) as ventas_intactas,
       (select count(*) from public.cortes) as cortes_intactos;
