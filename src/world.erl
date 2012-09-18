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
	World = dict:new(),
	generate_line(SizeY, SizeX, World).

%%
%% Local Functions
%%

generate_line(0, Size, World) ->
	generate_cell(Size, 0, World),
	io:format("~n");
generate_line(Num, Size, World) ->
	generate_cell(Size, Num, World),
	io:format("~n"),
	generate_line(Num - 1, Size, World).


generate_cell(0, LineNum, World) ->
	Val = random:uniform(100),
	dict:append({0, LineNum}, Val, World),
	io:format("~3w ", [Val]),
	Val;
generate_cell(Num, LineNum, World) ->
	OldVal = generate_cell(Num - 1, LineNum, World),
	Val = OldVal + random:uniform(20) - 10,
	dict:append({Num, LineNum}, Val, World),
	io:format("~3w ", [Val]),
	Val.

					   