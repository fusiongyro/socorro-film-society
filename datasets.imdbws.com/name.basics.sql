-- schema for the name.basics table
create table nameBasics (
    nconst varchar primary key,
	primaryName varchar,
	birthYear int,
	deathYear int,
	primaryProfession varchar,
	knownForTitles varchar
);

\copy nameBasics from 'name.basics.tsv' with (header true)

-- set up the primary professions enum
create type profession as enum (
    'accountant',
    'actor',
    'actress',
    'animation_department',
    'archive_footage',
    'archive_sound',
    'art_department',
    'art_director',
    'assistant',
    'assistant_director',
    'camera_department',
    'casting_department',
    'casting_director',
    'choreographer',
    'cinematographer',
    'composer',
    'costume_department',
    'costume_designer',
    'director',
    'editor',
    'editorial_department',
    'electrical_department',
    'executive',
    'legal',
    'location_management',
    'make_up_department',
    'manager',
    'miscellaneous',
    'music_artist',
    'music_department',
    'podcaster',
    'producer',
    'production_department',
    'production_designer',
    'production_manager',
    'publicist',
    'script_department',
    'set_decorator',
    'sound_department',
    'soundtrack',
    'special_effects',
    'stunts',
    'talent_agent',
    'transportation_department',
    'visual_effects',
    'writer'
);

-- now we want to extract the primaryProfession and knownForTitles into arrays
alter table nameBasics alter column primaryProfession type profession[] using regexp_split_to_array(primaryProfession, ',')::profession[];
alter table nameBasics alter column knownForTitles type varchar[] using regexp_split_to_array(knownForTitles, ',');

-- create an index on their name
create index nameBasics_primaryName_idx on nameBasics(primaryName);

