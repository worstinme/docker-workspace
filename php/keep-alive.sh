#!/bin/sh

SLEEP_DELAY="${SLEEP_DELAY:-1}";

STDOUT="${STDOUT:-/proc/1/fd/1}";
STDERR="${STDERR:-/proc/1/fd/2}";

trap "echo SIGHUP" HUP
trap "echo Shutting down; exit" TERM

# Install dependencies
echo "[ Info ] Load composer dependencies";
echo "[ Info ] composer install --prefer-dist --no-scripts --working-dir=/var/www";
composer install --prefer-dist --no-scripts --working-dir=/var/www > ${STDOUT} 2> ${STDERR} 3> ${STDERR};

# Execute commands
if [[ $1 ]]; then
COMMAND="${1:-echo 'command ticked'}";
echo "[ Info ] Command to execute: \"$COMMAND\"";
echo '[ Info ] Press [CTRL+C] to stop';
${COMMAND} > ${STDOUT} 2> ${STDERR};
fi

if [[ $2 ]]; then
COMMAND2="${2:-echo 'command ticked'}";
sleep 10;
echo "[ Info ] Command to execute: \"$COMMAND2\"";
echo '[ Info ] Press [CTRL+C] to stop';
${COMMAND2} > ${STDOUT} 2> ${STDERR};
fi

if [[ $3 ]]; then
COMMAND3="${3:-echo 'command ticked'}";
echo "[ Info ] Command to execute: \"$COMMAND3\"";
echo '[ Info ] Press [CTRL+C] to stop';
${COMMAND3} > ${STDOUT} 3> ${STDERR};
fi

while :; do
  sleep "$SLEEP_DELAY";
done;
