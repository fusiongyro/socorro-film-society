create type category as enum (
    'actor',
    'actress',
    'archive_footage',
    'archive_sound',
    'casting_director',
    'cinematographer',
    'composer',
    'director',
    'editor',
    'producer',
    'production_designer',
    'self',
    'writer'
);


create table titlePrincipals (
    tconst varchar references titleBasics(tconst),
	ordering int,
	nconst varchar references nameBasics(nconst),
	category category,
	job varchar,
	characters varchar,
    primary key (tconst, nconst, ordering)
);

\copy titlePrincipals from 'title.principals.tsv' with (header true);

create index titlePrincipals_tconst_idx on titlePrincipals(tconst);
create index titlePrincipals_nconst_idx on titlePrincipals(nconst);

