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
	io:format("Creature is borned on the ~w ~w cell~n", [X, Y]),
	settle_or_run(where_am_i({X, Y})).
	
%%
%% Local Functions
%%

%%-----------------------------
%% State of creture is {Cell, Temp}
%% Cell is db record {X, Y, Temp, Creature}
%% Temp is natural temperature for creature
%%-----------------------------

where_am_i({X, Y}) ->
	Result = turtle:get_cell(X,Y),
	io:format("Creature found itself on the ~w cell~n", [Result]),
	Result.

settle_or_run({X, Y, Temp, none}) ->
	State = {{X, Y, Temp, none}, Temp},
	settle(State);
settle_or_run(Cell) ->
	{X, Y, Temp , _} = Cell,
	%% remember natural temp for new creature
	State = {Cell, Temp},
	move_to(random_cell(Cell), State).

random_cell({X, Y, _, _}) ->
	{X + 1, Y + 1}.

move_to(Coord, State) ->
	{OldCell, _} = State,
	leave(OldCell),
	enter(where_am_i(Coord), State).

settle(State) ->
	{Cell, _} = State,
	turtle:settle_creature(Cell, self()),
	reproduce(State),
	rest(),
	move_to(random_cell(Cell), State),
	ok.

%%----------------------------------------
%% Leave the cell.
%% Turtle should remember the cell is empty
%%----------------------------------------
leave(State) ->
	turtle:free_cell(self()),
	ok.

%%----------------------------------------
%% Enter to cell 
%% Creature should die of fight or settle
%%----------------------------------------

enter(NewCell, State) ->
	{NewX, NewY, _, _} = NewCell,
	{{X, Y, Temp, Creature}, Temp} = State,
	NewState = {{NewX, NewY, Temp, Creature}, Temp},
	io:format("Creature on the ~w ~w cell~n", [NewX, NewY]),
	Fate = survive(NewState),
	if
	Fate == live ->
		settle(NewState);
	true ->
		io:format("Creature died~n"),
		ok
	end.

survive(State) ->
	{{_, _, Temp, _}, Ntemp} = State,
	MinTemp = Ntemp - 20,
	MaxTemp = Ntemp + 20,
	if
	Temp > MaxTemp ->
		die;
	Temp < MinTemp ->
		die;
	true ->
		live
	end.

own({X, Y, Temp, none}, State) ->
	ok.

reproduce(State) ->
	ok.

rest() ->
	receive
	after
		1000 ->
			true
	end.