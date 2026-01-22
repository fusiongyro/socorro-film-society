-- First section deals with the title basics relation, which is the primary relation
-- which everything else hooks up to
create type titleType as enum (
    'movie',
    'short',
    'titleType',
    'tvEpisode',
    'tvMiniSeries',
    'tvMovie',
    'tvPilot',
    'tvSeries',
    'tvShort',
    'tvSpecial',
    'video',
    'videoGame'
);

create type genre as enum (
    'Action',
    'Adult',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'Film-Noir',
    'Game-Show',
    'genres',
    'History',
    'Horror',
    'Music',
    'Musical',
    'Mystery',
    'News',
    'Reality-TV',
    'Romance',
    'Sci-Fi',
    'Short',
    'Sport',
    'Talk-Show',
    'Thriller',
    'War',
    'Western'
);

create table titleBasics (
    tconst varchar primary key,
	titleType titleType,
	primaryTitle varchar,
	originalTitle varchar,
	isAdult boolean,
	startYear integer,
	endYear integer,
	runtimeMinutes integer,
	genres varchar
);

\copy titleBasics from title.basics.tsv with (header true);

-- correct the genres to be our enum
alter table titleBasics alter column genres type genre[] using regexp_split_to_array(genres, ',')::genre[];

-- establish the general title query index / view
create index titleBasics_nonadult_movie_idx on titleBasics(primaryTitle) where titleType = 'movie' and not isAdult;

create view movieBasics as
select * from titleBasics where titleType = 'movie' and not isAdult;

-- 
