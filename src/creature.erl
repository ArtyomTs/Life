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
%% 	io:format("Creature found itself on the ~w cell~n", [Result]),
	parse(Result).

parse([]) ->
	hell;
parse([{_, {X, Y}, Temp, Creature} | _ ]) ->
	{X, Y, Temp, Creature}.


settle_or_run({X, Y, Temp, none}) ->
	%% remember natural temp for new creature
	State = {{X, Y, Temp, none}, Temp},
	io:format("Natural temp is ~w~n", [Temp]),
	settle(State);
settle_or_run(Cell) ->
	{X, Y, Temp , _} = Cell,
	%% remember natural temp for new creature
	State = {Cell, Temp},
	move_to(random_cell(Cell), State).

random_cell({X, Y, _, _}) ->
	XStep = random:uniform(3) - 2,
	YStep = random:uniform(3) - 2,
	{X + XStep, Y + YStep}.

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
	{X, Y, _Temp, _Creature} = State,
	turtle:free_cell(X, Y),
	ok.

%%----------------------------------------
%% Enter to cell 
%% Creature should die of fight or settle
%%----------------------------------------

enter(hell, _State) ->
	io:format("Creature died~n"),
	died;
enter(NewCell, State) ->
	{NewX, NewY, Temp, _} = NewCell,
	{{_X, _Y, _Temp, Creature}, NTemp} = State,
	NewState = {{NewX, NewY, Temp, Creature}, NTemp},
	io:format("Creature on the ~w ~w cell~n", [NewX, NewY]),
	survive(fate(NewState), NewState).

survive(die, _State) ->
	io:format("Creature died~n"),
	died;
survive(_Fate, State) ->
	settle(State).

fate(State) ->
	{{_, _, Temp, _}, Ntemp} = State,
	MinTemp = Ntemp - 20,
	MaxTemp = Ntemp + 20,
	io:format("Try to survive with ~w(~w - ~w) in ~w~n", [Ntemp, MinTemp, MaxTemp, Temp]),
	if
	Temp > MaxTemp ->
		Res = die;
	Temp < MinTemp ->
		Res = die;
	true ->
		Res = live
	end,
	Res.

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