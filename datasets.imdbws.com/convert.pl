:- use_module(library(csv)).
:- use_module(library(debug)).
:- use_module(library(format)).
:- use_module(library(lists)).
:- use_module(library(lambda)).
:- use_module(library(pio)).
:- use_module(library(reif)).

% tconst	titleType	primaryTitle	originalTitle	isAdult	startYear	endYear	runtimeMinutes	genres
% tt0000001	short	Carmencita	Carmencita	0	1894	\N	1	Documentary,Short
% tt0000002	short	Le clown et ses chiens	Le clown et ses chiens	0	1892	\N	5	Animation,Short
% tt0000003	short	Poor Pierrot	Pauvre Pierrot	0	1892	\N	5	Animation,Comedy,Romance
% tt0000004	short	Un bon bock	Un bon bock	0	1892	\N	12	Animation,Short
% tt0000005	short	Blacksmith Scene	Blacksmith Scene	0	1893	\N	1	Short
% tt0000006	short	Chinese Opium Den	Chinese Opium Den	0	1894	\N	1	Short
% tt0000007	short	Corbett and Courtney Before the Kinetograph	Corbett and Courtney Before the Kinetograph	0	1894	\N	1	Short,Sport
% tt0000008	short	Edison Kinetoscopic Record of a Sneeze	Edison Kinetoscopic Record of a Sneeze	0	1894	\N	1	Documentary,Short
% tt0000009	movie	Miss Jerry	Miss Jerry	0	1894	\N	45	Romance

table_definition(title, ["tconst"-atom, "titleType"-atom, "primaryTitle"-string, "originalTitle"-string, "isAdult"-boolean, "startYear"-int, "endYear"-int, "runtimeMinutes"-int, "genres"-string]).


read_titles(Table) :-
	phrase_from_file(parse_csv(Frame, [token_separator('\t')]), 'title-short.tsv'),
	convert_table(title, Frame, Table).

convert_table(TableName, frame(_Header, Lines), Table) :-
	table_definition(TableName, Definition),
	maplist(\Line^Row^convert_row(TableName, Definition, Line, Row), Lines, Table).

convert_row(TableName, Columns, Cells, Record) :-
	maplist(\Column^Cell^Field^convert_cell(Column, Cell, Field), Columns, Cells, Fields),
	Record =.. [TableName|Fields].

convert_cell(_, "\\N", null) :- !.
convert_cell(_Name-string, String, String).
convert_cell(_Name-atom, String, Atom) :- atom_chars(Atom, String).
convert_cell(_Name-boolean, Number, Boolean) :- =(Number, 1, Boolean).
convert_cell(_Name-int, Number, Number).

setup_database :-
	once(read_titles(Table)),
	maplist(\Title^assertz(Title), Table).

write_database :-
	listing_file(title/9, 'titles.pl').

listing_file(Predicate, Filename) :-
	current_output(StdOut),
	open(Filename, write, TitleFile),
	set_output(TitleFile),
	listing(Predicate),
	set_output(StdOut),
	close(TitleFile).
