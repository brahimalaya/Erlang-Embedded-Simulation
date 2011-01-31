-module(led_stub).
-behaviour(gen_fsm).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_port/2]).

%% ------------------------------------------------------------------
%% gen_fsm Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_event/3,
         handle_sync_event/4, handle_info/3, terminate/3, code_change/4
        ]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_port(PortName, PortSettings) ->
    stub:start_port(?MODULE, PortName, PortSettings).

%% ------------------------------------------------------------------
%% gen_fsm Function Definitions
%% ------------------------------------------------------------------

init(Args) ->
    {ok, off}.

on({command, turn_on}, State) ->
    {next_state, on, State};
on({command, turn_off}, State) ->
    {next_state, off, State}.

off({command, turn_on}, State) ->
    {next_state, on, State};
off({command, turn_off}, State) ->
    {next_state, off, State}.

handle_event(_Event, StateName, State) ->
  {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
  {reply, ok, StateName, State}.

handle_info({_Pid, {command, turn_on}}, _StateName, State) ->
    {next_state, on, State};
handle_info({_Pid, {command, turn_off}}, _StateName, State) ->
    {next_state, off, State};
handle_info({Pid, {command, brightness}}, StateName, State) ->
    Pid ! StateName,
    {next_state, on, State};
handle_info({Pid, {command, is_on}}, on, State) ->
    Pid ! true,
    {next_state, on, State};
handle_info({Pid, {command, is_on}}, off, State) ->
    Pid ! false,
    {next_state, on, State};
handle_info({Pid, {command, is_off}}, on, State) ->
    Pid ! false,
    {next_state, on, State};
handle_info({Pid, {command, is_off}}, off, State) ->
    Pid ! true,
    {next_state, on, State}.

terminate(_Reason, _StateName, _State) ->
  ok.

code_change(_OldVsn, StateName, State, _Extra) ->
  {ok, StateName, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
