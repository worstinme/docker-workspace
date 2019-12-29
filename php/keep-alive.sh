#!/usr/bin/env bash

SLEEP_DELAY="${SLEEP_DELAY:-1}";

STDOUT="${STDOUT:-/proc/1/fd/1}";
STDERR="${STDERR:-/proc/1/fd/2}";

trap "echo SIGHUP" HUP
trap "echo Shutting down; exit" TERM

while :; do
  sleep "$SLEEP_DELAY";
done;
