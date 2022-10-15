module main

import os
import cli
import chalk
import spinner

struct ExecuteCommand {
	command string
	filter  string
	sort    bool = true
}

fn main() {
	mut cmd := cli.Command{
		name: 'gw'
		description: 'Where is my commit?\nUsage:\ngw search -help\ngw diff -help'
		version: '1.1.1'
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
		default_value: ['']
		description: 'Containing branch name that you want to filter'
	})

	search_cmd.add_flag(cli.Flag{
		flag: .string
		name: 'tag'
		abbrev: 't'
		default_value: ['']
		description: 'Containing tag name that you want to filter'
	})

	mut diff_cmd := cli.Command{
		name: 'diff'
		description: 'Shows the commits between 2 tags'
		usage: '<tag1> <tag2>'
		required_args: 2
		execute: diff
	}

	cmd.add_command(search_cmd)
	cmd.add_command(diff_cmd)
	cmd.setup()
	cmd.parse(os.args)
}

fn search(cli_command cli.Command) ? {
	branch := cli_command.flags.get_string('branch') or {
		panic('Failed to get `branch` flag: $err')
	}
	tag := cli_command.flags.get_string('tag') or { panic('Failed to get `tag` flag: $err') }
	message := cli_command.args[0]

	println('Searching for ${chalk.style(message, 'bold')} in branches ${chalk.style(branch,
		'bold')} and tags ${chalk.style(tag, 'bold')}')
	branches := search_branches(message, branch)
	tags := search_tag(message, tag)
	println(chalk.fg('Branches:', 'green'))
	for b in branches {
		println(b)
	}
	println(chalk.fg('Tags:', 'green'))
	for t in tags {
		println(t)
	}
}

fn search_branches(commit_message string, branch string) []string {
	git_command := '
		for sha1 in `git log --oneline --all --grep "$commit_message" | cut -d" " -f1`
        do
                git branch -r --contains \$sha1 | xargs -I {} echo {} "(\$sha1)"
        done
		'
	return execute_command(ExecuteCommand{ command: git_command, filter: branch })
}

fn search_tag(commit_message string, tag string) []string {
	git_command := '
		for sha1 in `git log --oneline --all --grep "$commit_message" | cut -d" " -f1`
        do
                git tag --contains \$sha1 | xargs -I {} echo {} "(\$sha1)"
        done
		'
	return execute_command(ExecuteCommand{ command: git_command, filter: tag })
}

fn diff(cli_command cli.Command) ? {
	tag1 := cli_command.args[0]
	tag2 := cli_command.args[1]

	git_command := 'git log --oneline ${tag1}..$tag2'
	diff_commits := execute_command(ExecuteCommand{ command: git_command, filter: '', sort: false })

	for d in diff_commits {
		commit_id := d.all_before(' ')
		commit_message := d.after_char(` `)
		println('${chalk.fg(commit_id, 'green')} $commit_message')
	}
}

fn execute_command(execute_command ExecuteCommand) []string {
	mut sp := spinner.Spinner{}
	sp.start()
	mut s := []string{}
	mut cmd := os.Command{
		path: execute_command.command
		redirect_stdout: true
	}
	cmd.start() or { panic('Failed to start git command: $err') }
	for !cmd.eof {
		line := cmd.read_line().trim_space()
		if line.len > 0 && line.contains(execute_command.filter) {
			s << line
		}
	}
	cmd.close() or { panic('Failed to stop git command: $err') }
	if execute_command.sort {
		s.sort()
	}
	sp.stop()
	return s
}
