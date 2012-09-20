%% Author: temcha
%% Created: 18 сент. 2012
%% Description: TODO: Add description to world
-module(world).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([generate/2]).

%%
%% API Functions
%%

generate(SizeX, SizeY) ->
	generate_line(SizeY, SizeX, []).

%%
%% Local Functions
%%

generate_line(0, Size, World) ->
	{_Val, NewWorld} = generate_cell(Size, 0, World),
	io:format("~n"),
	NewWorld;
generate_line(Num, Size, World) ->
	OldWorld = generate_line(Num - 1, Size, World),
	{_Val, NewWorld} = generate_cell(Size, Num, OldWorld),
	io:format("~n"),
	NewWorld.


generate_cell(0, LineNum, World) ->
	Val = 50 + random:uniform(21) - 11,
	NewWorld = [{0, LineNum, Val} | World],
	io:format("~3w ", [Val]),
	{Val, NewWorld};
generate_cell(Num, LineNum, World) ->
	{OldVal, OldWorld} = generate_cell(Num - 1, LineNum, World),
	Val = OldVal + random:uniform(21) - 11,
	NewWorld = [{Num, LineNum, Val} | OldWorld],
	io:format("~3w ", [Val]),
	{Val, NewWorld}.

					   