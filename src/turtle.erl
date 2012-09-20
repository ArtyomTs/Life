%% Author: temcha
%% Created: 18 сент. 2012
%% Description: TODO: Add description to turtle
-module(turtle).

-include_lib("stdlib/include/qlc.hrl").
-include("turtle.hrl").
%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([born/0, die/0, hold/1, get_cell/2, free_cell/2, settle_creature/2, show_the_world/0]).

%%
%% API Functions
%%

%%---------------------------
%% Init Db schema
%%---------------------------
born() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(cells, [{attributes, record_info(fields, cells)}]).

die() ->
  mnesia:stop(),
  mnesia:delete_schema([node()]).
%%---------------------------
%% Store the World
%%---------------------------
hold(World) ->
	io:format("The World given~n"),
	lists:foreach(fun(Cell) -> store_cell(Cell) end, World),
	ok.
%%
%% Local Functions
%%

store_cell({X, Y, Temp}) ->
%% 	io:format("Storing cell ~w, ~w, ~w~n", [X, Y, Temp]),
	Cell = #cells{coord={X, Y}, temp=Temp, creature=none},
	Fun = fun() ->
		 	    mnesia:write(Cell)
		    end,
	{Res, Message} = mnesia:transaction(Fun),
%% 	io:format("Result = ~w~n", [Message]),
	Res.


get_cell(X, Y) ->
	Fun = 
        fun() ->
            mnesia:match_object({cells, {X, Y}, '_', '_' } )
        end,
    {atomic, Results} = mnesia:transaction(Fun),
	Results.

free_cell(X, Y) ->
  	Fun = fun() ->
    	[P] = mnesia:wread({cells, {X, Y} }),
    	mnesia:write(P#cells{creature=none})
  	end,
	{atomic, Results} = mnesia:transaction(Fun),
	Results.

settle_creature(Data, Pid) ->
	{X, Y, Temp, Creature} = Data,
	Coord = {X, Y},
%% 	io:format("Try to settle at ~w~n", [Coord]),
  	Fun = fun() ->
    	[P] = mnesia:read(cells, Coord, write),
%% 		io:format("Found cell ~w~n", [P]),
%% 		io:format("Try to write Pid ~w~n", [Pid]),
		NewR = P#cells{creature = Pid},
%% 		io:format("Try to write ~w~n", [NewR]),
    	mnesia:write(NewR)
  	end,
	{atomic, Results} = mnesia:transaction(Fun),
	Results.

show_the_world() ->
    mnesia:transaction( 
    fun() ->
        qlc:eval( qlc:q(
            [ X || X <- mnesia:table(cells) ] 
        )) 
    end ).