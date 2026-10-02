-- ============================================================
-- À exécuter UNE SEULE FOIS dans Supabase : SQL Editor → New query → coller → Run
--
-- Ce script ne touche à AUCUNE des tables/colonnes déjà créées : il ne fait
-- qu'ajouter les colonnes nécessaires à la synchronisation avec l'application PC.
--
-- Si une ligne affiche une erreur du type "column ... does not exist" ou
-- "relation ... does not exist", c'est que le nom d'une table ou d'une colonne
-- chez vous diffère légèrement de celui utilisé ici (pilotes, epreuves,
-- epreuve_parametres, bareme_points, inscriptions_epreuve, resultats) :
-- copiez l'erreur exacte, on ajustera le script ensemble.
-- ============================================================

-- "uuid" = identifiant stable partagé entre tous les ordinateurs (contrairement à "id",
--          qui recommence à 1 sur chaque appareil et ne peut donc pas servir à faire
--          correspondre les lignes entre eux).
-- "updated_at" = date de dernière modification, utilisée pour savoir, quand deux
--          ordinateurs ont modifié la même ligne, laquelle garder.

alter table public.pilotes
  add column if not exists uuid uuid not null default gen_random_uuid(),
  add column if not exists updated_at timestamptz not null default now();

alter table public.epreuves
  add column if not exists uuid uuid not null default gen_random_uuid(),
  add column if not exists updated_at timestamptz not null default now();

alter table public.epreuve_parametres
  add column if not exists uuid uuid not null default gen_random_uuid(),
  add column if not exists updated_at timestamptz not null default now();

alter table public.bareme_points
  add column if not exists uuid uuid not null default gen_random_uuid(),
  add column if not exists updated_at timestamptz not null default now();

alter table public.inscriptions_epreuve
  add column if not exists uuid uuid not null default gen_random_uuid(),
  add column if not exists updated_at timestamptz not null default now();

alter table public.resultats
  add column if not exists uuid uuid not null default gen_random_uuid(),
  add column if not exists updated_at timestamptz not null default now();

-- Seule "epreuves" a besoin d'une contrainte d'unicité sur "uuid" : c'est la seule table
-- sans identifiant "naturel" déjà unique pour fusionner les doublons entre appareils
-- (les pilotes se fusionnent par numéro de licence, les résultats/inscriptions par
-- couple pilote+épreuve — ces contraintes existent déjà chez vous).
alter table public.epreuves
  add constraint epreuves_uuid_key unique (uuid);

-- Autorise l'application (clé publique "anon") à lire et écrire. Simplification volontaire
-- pour un outil interne au club : la clé anon est intégrée à l'application, donc toute
-- personne possédant le fichier de configuration peut lire/écrire la base. Pour une sécurité
-- renforcée plus tard, il faudra passer par un petit serveur intermédiaire plutôt que
-- d'exposer la clé directement — à en reparler si besoin.
alter table public.pilotes enable row level security;
alter table public.epreuves enable row level security;
alter table public.epreuve_parametres enable row level security;
alter table public.bareme_points enable row level security;
alter table public.inscriptions_epreuve enable row level security;
alter table public.resultats enable row level security;

create policy "acces_total_pilotes" on public.pilotes for all using (true) with check (true);
create policy "acces_total_epreuves" on public.epreuves for all using (true) with check (true);
create policy "acces_total_epreuve_parametres" on public.epreuve_parametres for all using (true) with check (true);
create policy "acces_total_bareme_points" on public.bareme_points for all using (true) with check (true);
create policy "acces_total_inscriptions_epreuve" on public.inscriptions_epreuve for all using (true) with check (true);
create policy "acces_total_resultats" on public.resultats for all using (true) with check (true);
