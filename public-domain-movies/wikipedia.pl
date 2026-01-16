:- use_module(library(http/http_open)).
:- use_module(library(sgml)).
:- use_module(library(xpath)).

%% Retrieves the list of public domain movies from Wikipedia
wikipedia_public_domain_movies(Title, Year, Director, StudioDistributor, EnteredPublicDomainYear, Reason, Notes) :-
	%% Fetch the website
	http_open("https://en.wikipedia.org/wiki/List_of_films_in_the_public_domain_in_the_United_States", S, []),

	%% Convert to SGML document
	load_html(stream(S), Doc, []),

	%% Parse with XPath
	xpath(Doc, //table(2)//tr, Row),
	xpath(Row, //td(index(1),normalize_space), Title),
	xpath(Row, //td(index(2),normalize_space), Year),
	xpath(Row, //td(index(3),normalize_space), Director),
	xpath(Row, //td(index(4),normalize_space), StudioDistributor),
	xpath(Row, //td(index(5),normalize_space), EnteredPublicDomainYear),
	xpath(Row, //td(index(6),normalize_space), Reason),
	xpath(Row, //td(index(7),normalize_space), Notes).
