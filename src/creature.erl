%% Author: temcha
%% Created: 19 сент. 2012
%% Description: TODO: Add description to creature
-module(creature).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([born/2]).

%%
%% API Functions
%%

born(X, Y) ->
	settle_or_run(where_am_i({X, Y})).
	
%%
%% Local Functions
%%

where_am_i({X, Y}) ->
	{X, Y, Temp, Creature} = turtle:get_cell(X,Y).

settle_or_run({X, Y, Temp, none}) ->
	settle({X, Y, Temp, none});
settle_or_run(State) ->
	{X, Y,_ , _} = State,
	move_to(available_cells(X, Y), State ).

available_cells(X, Y) ->
	{X + 1, Y + 1}.

move_to(Coord, State) ->
	leave(State),
	enter(where_am_i(Coord), State).

settle(State) ->
	ok.

leave(State) ->
	ok.

%%----------------------------------------
%% Enter to cell 
%% Creature should die of fight or settle
%%----------------------------------------

enter({X, Y, Temp, none}, State) ->
	ok;
enter(Coord, State) ->
	ok.