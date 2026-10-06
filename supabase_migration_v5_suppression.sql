-- ============================================================
-- À exécuter UNE SEULE FOIS dans Supabase (SQL Editor → New query → coller → Run).
--
-- Jusqu'ici, "Supprimer" dans l'application supprimait vraiment la ligne. Résultat : la
-- synchronisation ne pouvait pas faire la différence entre "cette ligne a été supprimée sur
-- un appareil" et "cette ligne est nouvelle, créée sur un autre appareil" — une épreuve
-- supprimée puis synchronisée réapparaissait, reçue depuis Supabase.
--
-- Ce script ajoute une colonne "supprime" (suppression "douce") : supprimer une fiche la
-- marque supprimée au lieu de l'effacer, et cette marque se synchronise comme n'importe
-- quelle autre modification.
-- ============================================================

alter table public.pilotes add column if not exists supprime boolean not null default false;
alter table public.epreuves add column if not exists supprime boolean not null default false;
alter table public.utilisateurs add column if not exists supprime boolean not null default false;
