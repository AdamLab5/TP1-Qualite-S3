-- ============================================================
-- À exécuter UNE SEULE FOIS dans Supabase (SQL Editor → New query → coller → Run),
-- APRÈS avoir déjà exécuté supabase_migration.sql.
--
-- Active la synchronisation des comptes utilisateurs (identifiant, mot de passe haché,
-- rôle, actif/inactif) entre tous les ordinateurs. Choix assumé pour un outil interne
-- au club (voir le commentaire dans SyncService.java) : le mot de passe haché transite
-- et est stocké sur Supabase, comme les autres données.
-- ============================================================

alter table public.utilisateurs add column if not exists updated_at timestamptz not null default now();

alter table public.utilisateurs enable row level security;
create policy "acces_total_utilisateurs" on public.utilisateurs for all using (true) with check (true);
