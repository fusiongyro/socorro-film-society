-- tconst	averageRating	numVotes
create table titleRatings (
    tconst varchar primary key references titleBasics(tconst),
    averageRating numeric(2,1) not null,
    numVotes integer not null
);

\copy titleRatings from 'title.ratings.tsv' with (headrer true)

