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
-export([born/0, hold/1, get_cell/2]).

%%
%% API Functions
%%

%%---------------------------
%% Init Db schema
%%---------------------------
born() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(cells, [{attributes, record_info(fields, cell)}]),
	ok.

%%---------------------------
%% Store the World
%%---------------------------
hold(World) ->
	lists:foreach(fun(Cell) -> store_cell(Cell) end, World),
	ok.
%%
%% Local Functions
%%

store_cell({X, Y, Temp}) ->
	Cell = #cell{x=X, y=Y, temp=Temp, creature=none},
	Fun = fun() ->
		 	mnesia:write(Cell)
		  end,
	mnesia:transaction(Fun).

get_cell(X, Y) ->
	Fun = 
        fun() ->
            mnesia:match_object({cells,X , Y, '_', '_' } )
        end,
    {atomic, Results} = mnesia:transaction( Fun),
    Results.
	