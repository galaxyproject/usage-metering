#!/usr/bin/env python3

"""
This script is loosely based on https://github.com/galaxyproject/bioblend/blob/main/docs/examples/run_imported_workflow.py

Copyright 2021 The Galaxy Project. All rights reserved.

"""

import bioblend.galaxy
import yaml
import json
import sys
import os

from pprint import pprint

VERSION='1.0.0'

BOLD = '\033[1m'
CLEAR = '\033[0m'

# Default value for the Galaxy server URL.  This can be overriden with an
# environment variable or on the command line
GALAXY_SERVER = 'https://benchmarking.usegvl.org/initial/galaxy/'

# Your Galaxy API key.  This can be specified in an environment variable or
# on the command line.
API_KEY = None

# The directory where the workflow invocation data will be saved.
INVOCATIONS_DIR = 'invocations'


def workflows():
    """
	List all the workflows available on the server.
	"""
    global API_KEY, GALAXY_SERVER

    gi = bioblend.galaxy.GalaxyInstance(url=GALAXY_SERVER, key=API_KEY)
    print(f"Connected to {GALAXY_SERVER}")
    wflows = gi.workflows.get_workflows(published=True)  # name='imported: Benchmarking RNA-seq Cloud Costs')
    print(f"Found {len(wflows)} workflows")
    for wf in wflows:
        print(f"Name: {wf['name']}")
        print(f"ID: {wf['id']}")
        wf_info = gi.workflows.show_workflow(wf['id'])
        inputs = wf_info['inputs']
        for index in range(len(inputs)):
            print(f"Input {index}: {inputs[str(index)]['label']}")
        print()


def run(args):
    """
    Run a workflow using the configuration specified in the args

    :param args: a list containing the config file as the first (and only) element
    :type list:
    :return:
    """
    global API_KEY, GALAXY_SERVER

    if len(args) == 0:
        print('ERROR: No workflow configuration was specified')
        sys.exit(1)

    name = args[0]
    if not os.path.isfile(name):
        print(f'ERROR: Could not find {name}')
        sys.exit(1)

    if os.path.exists(INVOCATIONS_DIR):
        if not os.path.isdir(INVOCATIONS_DIR):
            print('ERROR: Can not save invocation status, directory name in use.')
            sys.exit(1)
    else:
        os.mkdir(INVOCATIONS_DIR)

    with open(name, 'r') as stream:
        try:
            config = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)

    gi = bioblend.galaxy.GalaxyInstance(url=GALAXY_SERVER, key=API_KEY)
    print(f"Connected to {GALAXY_SERVER}")

    workflow = config['workflow_id']
    inputs = {}
    for spec in config['inputs']:
        input = gi.workflows.get_workflow_inputs(workflow, spec['name'])
        if input is None or len(input) == 0:
            print('ERROR: Invalid input specification')
            sys.exit(1)
        inputs[input[0]] = {'id': spec['dataset_id'], 'src': 'hda'}

    if 'output_history_name' in config:
        print(f"Saving output to a history named {config['output_history_name']}")
        invocation = gi.workflows.invoke_workflow(workflow, inputs=inputs, history_name=config['output_history_name'])
    else:
        invocation = gi.workflows.invoke_workflow(workflow, inputs=inputs)

    pprint(invocation)

    output_path = os.path.join(INVOCATIONS_DIR, invocation['id'] + '.json')
    with open(output_path, 'w') as f:
        json.dump(invocation, f, indent=4)
        print(f"Wrote {output_path}")


def histories(args):
    """
    List all the public histories available on the Galaxy server.

    :param args:
    :type list:
    :return:
    """
    global API_KEY, GALAXY_SERVER
    gi = bioblend.galaxy.GalaxyInstance(url=GALAXY_SERVER, key=API_KEY)
    print(f"Connected to {GALAXY_SERVER}")
    if len(args) > 0:
        history_list = gi.histories.get_histories(name=args[0])
    else:
        history_list = gi.histories.get_published_histories()

    if history_list is None or len(history_list) == 0:
        print("ERROR: history not found!")
        return

    for history in history_list:
        # print(f"ID: {history['id']} Name: {history['name']}")
        print(f"{history['id']} - {history['name']}")
        for dataset in gi.histories.show_history(history['id'], contents=True, details='none'):
            if not dataset['deleted']:
                state = dataset['state'] if 'state' in dataset else 'Unknown'
                print(f"\t{dataset['id']} - {dataset['name']} ({state})")
        print()


def status(args):
    """
    Display that status of workflow invocations.

    :param args:
    :return:
    """
    global API_KEY, GALAXY_SERVER
    gi = bioblend.galaxy.GalaxyInstance(url=GALAXY_SERVER, key=API_KEY)
    print(f"Connected to {GALAXY_SERVER}")
    # invocations = gi.invocations.get_invocations()
    if len(args) == 0:
        invocations = gi.invocations.get_invocations()
        print('ID\t\t\tWORKFLOW\t\tHISTORY\t\t\tSTATE')
        for invocation in invocations:
            print(f"{invocation['id']}\t{invocation['workflow_id']}\t{invocation['history_id']}\t{invocation['state']}")
    elif args[0] == 'jobs':
        if len(args) != 2:
            print(f"{bold('ERROR:')} no invocation ID provided.")
            print(f"{bold('USAGE:')} ./workflow.py status job <invocation id>")
            return
        else:
            report = gi.invocations.get_invocation_step_jobs_summary(args[1])
            pprint(report)
    elif args[0] == 'summary':
        if len(args) != 2:
            print(f"{bold('ERROR:')} no invocation ID provided.")
            print(f"{bold('USAGE:')} ./workflow.py status summary <invocation id>")
            return
        else:
            report = gi.invocations.get_invocation_summary(args[1])
            pprint(report)
    else:
        report = gi.invocations.get_invocation_report(args[0])
        pprint(report)


def bold(text):
    """
    Wraps the text in ANSI control sequences to generate bold text in the terminal.

    :param text: the text to be made bold
    :type str:
    :return: the original string wrapped in ANSI control sequences
    """
    return f"{BOLD}{text}{CLEAR}"


def help():
    print(f"""
{bold("SYNOPSIS")}
    Run workflows on remote Galaxy instances.

{bold("USAGE")}
    ./workflow.py [-k KEY] [-s SERVER] [COMMAND...]

{bold("OPTIONS")}
    {bold("-k")}|{bold("--key")} GALAXY_API_KEY
        Specify the Galaxy API for the remote server
    {bold("-s")}|{bold("--server")}
        The URL for the remote Galaxy server

{bold("COMMANDS")}
    {bold("wf")}|{bold("workflows")}
        List all public workflows and their inputs
    {bold("hist")}|{bold("histories")}
        List all public histories and their datasets
    {bold("st")}|{bold("status")} <invocation_id>
        If the {bold("invocation_id")} is specified then the invocation report for that workflow
        invocation is returned.  Otherwise lists all the workflow invocations on 
        the server
    {bold("run")} <configuration.yml>
        Run the workflow specified in the {bold("configuration.yml")} file.
    {bold('version')}
        Print the version number and exit
    {bold("help")}|{bold("-h")}|{bold("--help")}
        Prints this help screen

{bold("EXAMPLES")}
    ./workflow.py run configs/paired-dna.yml
    ./workflow.py st da4e6f496166d13f

Please see https://github.com/ksuderman/bioblend-scripts#readme for full documentation.

""")


def main():
    global API_KEY, GALAXY_SERVER
    value = os.environ.get('GALAXY_SERVER')
    if value is not None:
        GALAXY_SERVER = value

    value = os.environ.get('API_KEY')
    if value is not None:
        API_KEY = value

    commands = list()
    index = 1
    while index < len(sys.argv):
        arg = sys.argv[index]
        index += 1
        if arg in ['-k', '--key']:
            API_KEY = sys.argv[index]
            index += 1
        elif arg in ['-s', '--server']:
            GALAXY_SERVER = sys.argv[index]
            index += 1
        else:
            commands.append(arg)

    if len(commands) == 0:
        help()
        sys.exit(0)
    command = commands.pop(0)
    if command in ['-h', '--help', 'help']:
        help()
    elif command in ['hist', 'histories']:
        histories(commands)
    elif command in ['wf', 'workflows']:
        workflows()
    elif command == 'run':
        run(commands)
    elif command in ['st', 'status']:
        status(commands)
    elif command in ['-v', '--version', 'version']:
        print(f"    Galaxy Workflow Runner v{VERSION}")
        print(f"    Copyright 2021 The Galaxy Project. All Rights Reserved.")
    else:
        print(f'\n{bold("ERROR:")} Unknown command {bold("{command}")}')
        help()


if __name__ == '__main__':
    main()

# Dead code kept for reference only below this point

def rna_seq():
    """
	048a970701a6dc44 - gencode.v38.annotation.gtf.gz (ok)
	ca5081d2c8f1088a - SRR14916263 (fastq-dump) uncompressed (ok)
	d65ad3947f73925d - SRR14916263 (fastq-dump) (ok)
	3947ba9ca107312f - gencode.v38.transcripts.fa.gz (ok)

	ID: eea1d48bdaa84118
	Input 0: Reference FASTA
	Input 1: GTF
	Input 2: FASTA Dataset
	"""
    print('rna_seq')
    GTF = '048a970701a6dc44'
    FASTA_DATA = 'ca5081d2c8f1088a'
    FASTA_REF = '3947ba9ca107312f'

    WORKFLOW_ID = 'eea1d48bdaa84118'

    global API_KEY, GALAXY_SERVER
    # parser = argparse.ArgumentParser(description='Run Galaxy workflows')
    # parser.add_argument('-s', '--server', required=False, help='the Galaxy server URL.')
    # parser.add_argument('-a', '--api-key', required=False, help='your Galaxy API key')
    # args = parser.parse_args(argv)
    # if args.server is not None:
    # 	GALAXY_SERVER = args.server
    # if args.api_key is not None:
    # 	API_KEY = args.api_key
    #
    # if API_KEY is None:
    # 	print("ERROR: You have not specified a Galaxy API key")
    # 	sys.exit(1)

    gi = bioblend.galaxy.GalaxyInstance(url=GALAXY_SERVER, key=API_KEY)

    fasta_ref = gi.workflows.get_workflow_inputs(WORKFLOW_ID, 'Reference FASTA')[0]
    fasta_data = gi.workflows.get_workflow_inputs(WORKFLOW_ID, 'FASTA Dataset')[0]
    gtf = gi.workflows.get_workflow_inputs(WORKFLOW_ID, 'GTF')[0]

    inputs = {
        fasta_data: {'id': FASTA_DATA, 'src': 'hda'},
        fasta_ref: {'id': FASTA_REF, 'src': 'hda'},
        gtf: {'id': GTF, 'src': 'hda'}
    }
    result = gi.workflows.invoke_workflow(WORKFLOW_ID, inputs=inputs)
    pprint(result)


