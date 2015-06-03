%%% -*-mode:erlang;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
%%% ex: set ft=erlang fenc=utf-8 sts=4 ts=4 sw=4 et:
%%%
%%% Copyright 2015 Panagiotis Papadomitsos. All Rights Reserved.
%%%

-module(gen_rpc_acceptor_sup).
-author("Panagiotis Papadomitsos <pj@ezgr.net>").

%%% Behaviour
-behaviour(supervisor).

%%% Supervisor functions
-export([start_link/0, start_child/2, stop_child/1]).

%%% Supervisor callbacks
-export([init/1]).

%%% ===================================================
%%% Supervisor functions
%%% ===================================================
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(ClientIp, Node) when is_tuple(ClientIp), is_atom(Node) ->
    ok = lager:debug("function=start_child event=starting_new_acceptor client_ip=\"~p\" client_node=\"~s\"", [ClientIp, Node]),
    supervisor:start_child(?MODULE, [ClientIp,Node]).

stop_child(Pid) when is_pid(Pid) ->
    ok = lager:debug("function=stop_child event=stopping_acceptor acceptor_pid=\"~p\"", [Pid]),
    supervisor:terminate_child(?MODULE, Pid).

%%% ===================================================
%%% Supervisor callbacks
%%% ===================================================
init([]) ->
    {ok, {{simple_one_for_one, 100, 1}, [
        {gen_rpc_acceptor, {gen_rpc_acceptor,start_link,[]}, transient, 5000, worker, [gen_rpc_acceptor]}
    ]}}.
