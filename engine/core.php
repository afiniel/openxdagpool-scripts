<?php

// __ROOT__ constant defined as current script directory is used to construct various paths
define('__ROOT__', __DIR__);

// first command line argument is always the script name that was executed (core.php, etc)
// we need at least the second "operation" argument, without it, print help instead
if ($argc < 2)
	usage();

// make sure this program internally runs in UTC timezone
date_default_timezone_set('UTC');

// read current config
$config = require_once __DIR__ . '/config.php';

// map command line "operation" argument to controller class name
$map = ['livedata' => 'LiveDataController', 'fastdata' => 'FastDataController', 'blocks' => 'BlocksController', 'balance' => 'BalanceController'];
$controller = $map[$argv[1]] ?? null;

// if we were unable to map the "operation" argument to controller, print usage and exit
if (!$controller) {
	echo "Invalid operation.\n";
	usage();
}

// autoload any class in the App namespace from __DIR__/src
spl_autoload_register(function ($class) {
	$class = explode('\\', $class);
	if ($class[0] == 'App')
		$class[0] = 'src';

	$file = __DIR__ . '/' . implode('/', $class) . '.php';
	if (!@file_exists($file)) {
		echo "Class not found: " . $file . "\n";
		debug_print_backtrace();
		die("\n");
	}

	require_once $file;
});

// check if mandatory config values are present
if (!isset($config['base_dir']) || !isset($config['current_xdag_file']))
	die("Config key 'base_dir' or 'current_xdag_file' is missing.\n");

// current_xdag_file defaults to CURRENT_XDAG
// file contents (1 or 2) mark current (active) XDAG daemon folder, e.g. xdag1 or xdag2
$current_xdag = @file_get_contents($config['base_dir'] . '/' . $config['current_xdag_file']);
if (!preg_match('/^[0-9]+$/', $current_xdag))
	die("current_xdag_file doesn't contain positive integer (check config.php).\n");

// socket file used in Xdag commandStream socket_connect($socket, $this->socket_file)
// which is a AF_UNIX IPC method
// to write/read file through socket used for inter-process data communication
$socket_file = $config['base_dir'] . '/xdag' . $current_xdag . '/client/unix_sock.dat';

// use Xdag class by default, or switch to XdagLocal for local development without a running XDAG daemon
if (isset($config['xdag_class']) && $config['xdag_class'] == 'XdagLocal') {
	$xdag = new App\Xdag\XdagLocal($socket_file);
	$xdag->setVersion($config['xdag_version'] ?? '0.2.5');
} else {
	$xdag = new App\Xdag\Xdag($socket_file);
}

// construct controller class to be executed and inject application config and Xdag class
$controller = "App\\Controllers\\$controller";
$controller = new $controller($config, $xdag);

// prepare arguments for controller's index method
$args = $argv;
// discard "script name" command line argument as it is not used throughout the code
array_shift($args);
// discard "operation" command line argument as it was already parsed
array_shift($args);

// execute controller's "index" method with leftover command line arguments
call_user_func_array([$controller, 'index'], $args);

// function prints usage information (help) and exits the program
function usage()
{
	die("Usage: php " . basename(__FILE__, '.php') . " operation [args, ...]
operation
	livedata
	- prints live data (designed to be run every minute) either as
	- JSON or human readable text file, prints the state, stats, pool,
	- net conn commands and current system time including time zone

	fastdata
	- prints fast data (designed to be run every 5 minutes), currently
	- prints the miners command as JSON or human readable text file
	- and current system time including time zone

	balance
	- retrieves address balance, output is always JSON

	blocks
	- inspects new found blocks, exports one fully processed found block
	- or one already exported invalidated blocks based on arguments

livedata args:
	human-readable
	- if given, prints live data in human readable format (raw text file),
	- otherwise prints JSON

fastdata args:
	human-readable
	- if given, prints fast data in human readable format (raw text file),
	- otherwise prints JSON

balance args:
	{address}
	- xdag address to retrieve balance for

blocks args:
	gather
	- gathers new pool blocks (10000) using the 'account' or 'minedblocks'
	- command. Designed to be run every minute.
	gatherAll
	- gathers new pool blocks (all) using the 'account' or 'minedblocks'
	- command. Designed to be run once a day.
	inspect
	- inspects newly imported pool blocks. Designed to be run every minute.
	inspectAll
	- reprocesses each already inspected pool block. Validates previously
	- invalidated blocks if required, also invalidates previously
	- validated blocks if required. Designed to be run once a day.
	export
	- exports oldest unexported fully processed and validated found block.
	- Can be called any time, if operation is currently locked, a proper
	- JSON status will be set, and the client should retry the call in
	- that case.
	exportInvalidated
	- exports one unexported previously exported but now invalidated block.
	- Can be called any time, if operation is currently locked, a proper
	- JSON status will be set, and the client should retry the call in
	- that case.
	resetExport
	- resets export of all already exported valid blocks. For debugging
	- purposes only, or when re-importing OpenXDAGPool database.
	resetExportInvalidated
	- resets export of all invalidated blocks. For debugging purposes
	- only, or when re-importing OpenXDAGPool database.
	summary
	- prints a JSON summary of the database. For debugging purposes only.
	startFresh
	- remove all accounts and blocks from the core storage and start
	- fresh. For debugging purposes only.
");
}

// debugging function to "dump and die", useful for development purposes
function dd()
{
	foreach (func_get_args() as $arg) {
		var_dump($arg);
		echo "\n";
	}

	die("\n");
}

