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
-export([born/0, hold/1]).

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
	lists:foreach(store_cell, dict:to_list(World)),
	ok.
%%
%% Local Functions
%%

store_cell({{X, Y}, Temp}) ->
	Cell = #cell{x=X, y=Y, temp=Temp, creature=none},
	Fun = fun() ->
		 	mnesia:write(Cell)
		  end,
	mnesia:transaction(Fun).
	