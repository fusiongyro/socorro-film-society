-- tconst	directors	writers
create table titleCrew(
    tconst varchar primary key references titleBasics(tconst),
    directors varchar,
    writers varchar
);

\copy titleCrew from 'title.crew.tsv' with (header true)

alter table titleCrew
  alter column directors type varchar[] using regexp_split_to_array(directors, ',')
  alter column writers type varchar[] using regexp_split_to_array(writers, ',');
