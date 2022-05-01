module main
import os
import cli

fn main() {
	mut cmd := cli.Command{
		name: 'gs'
		description: 'Where is my commit?\nUsage: gs search -help'
		version: '1.0.0'
	}
	mut search_cmd := cli.Command{
		name: 'search'
		description: 'Searches the commit message in branches and tags'
		usage: '<commit message>'
		required_args: 1
		execute: search
	}
	search_cmd.add_flag(cli.Flag{
		flag: .string
		name: 'branch'
		abbrev: 'b'
		default_value: ['x-maintenance']
		description: 'Containing branch name that you want to filter'
	})

	search_cmd.add_flag(cli.Flag{
		flag: .string
		name: 'tag'
		abbrev: 't'
		default_value: ['xl-release-']
		description: 'Containing tag name that you want to filter'
	})

	cmd.add_command(search_cmd)
	cmd.setup()	
	cmd.parse(os.args)
}

fn search(cli_command cli.Command) ? {
		branch := cli_command.flags.get_string('branch') or { panic('Failed to get `branch` flag: $err') }
	tag := cli_command.flags.get_string('tag') or { panic('Failed to get `tag` flag: $err') }
	message := cli_command.args[0]

	branches:= search_branches(message, branch)
	tags := search_tag(message, tag)
	println(branches)
	println(tags)
}

fn search_branches(commit_message string, branch string) string {
	git_command :='
		for sha1 in `git log --oneline --all --grep "$commit_message" | cut -d" " -f1`
        do
                git branch -r --contains \$sha1
        done
		'
	return execute_command(git_command, branch)
}

fn search_tag(commit_message string, tag string) string {
	git_command :='
		for sha1 in `git log --oneline --all --grep "$commit_message" | cut -d" " -f1`
        do
                git tag --contains \$sha1
        done
		'
	return execute_command(git_command, tag)
}

fn execute_command(command string, filter string) string {
	mut s := ''
	mut cmd := os.Command{
		path: command
		redirect_stdout: true
	}
	cmd.start() or { panic('Failed to start git command: $err') }
	for !cmd.eof {
		line := cmd.read_line().trim_space()
		if line.len > 0 && line.contains(filter) {
			s += '$line\n'
		}
	}
	cmd.close() or { panic('Failed to stop git command: $err') }
	return s
}