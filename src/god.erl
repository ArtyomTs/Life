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
-export([create/0]).

%%
%% API Functions
%%

create() ->
	turtle:die(),
	turtle:born(),
	turtle:hold(world:generate(10, 10)).

%%
%% Local Functions
%%

