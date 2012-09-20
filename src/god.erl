%% Author: temcha
%% Created: 20 сент. 2012
%% Description: TODO: Add description to god
-module(god).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([create/0, born_creature/1]).

%%
%% API Functions
%%

create() ->
	turtle:die(),
	turtle:born(),
	turtle:hold(world:generate(10, 10)),
	a_day_of_creatures().

%%
%% Local Functions
%%

a_day_of_creatures() ->
	born_creature(10).

born_creature(0) ->
	ok;
born_creature({X, Y}) ->
	erlang:spawn(fun() -> creature:born(X, Y) end);
born_creature(N) ->
	CellX = random:uniform(10),
	CellY = random:uniform(10),
	erlang:spawn(fun() -> creature:born(CellX, CellY) end),
	born_creature(N - 1).
