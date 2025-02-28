//! BuenzliGit init - callable via jj bgi
//!
//! A simple function for initializing repositories.

use std::{
    env::*,
    fs::*,
    io::{Read, Write},
};

fn main() {
    let mut repo = args().nth(1).unwrap_or_else(prompt_for_repo);

    if !repo.contains('/') {
        repo = format!("{}/repos/buenzli/remo/{}", var("HOME").unwrap(), repo);
    }
    create_dir_all(&repo).unwrap();
    set_current_dir(&repo).unwrap();
    repo = repo.rsplit_once('/').unwrap().1.into();

    sh("jj git init --colocate").run(None);
    sh("jj git remote add origin")
        .arg(format!("buenzli:remo/{repo}"))
        .run(None);
    sh("jj config set --repo revset-aliases.'trunk()' present(main@origin)").run(None);

    let dir = current_dir().unwrap().to_str().unwrap().to_string();

    sh("wl-copy").run(Some(dir.to_string()));
    println!("path copied to clipboard");
}

fn prompt_for_repo() -> String {
    println!("Enter the name / path of the repo (empty for playground):");
    let line = read_line();
    if line.is_empty() {
        return "jj-play".into();
    }
    line
}

//                                                                            //
// -------------------------------- sh utils -------------------------------- //
//                                                                            //

fn sh(program: &str) -> std::process::Command {
    let mut iter = program.split_whitespace();
    let mut cmd = std::process::Command::new(iter.next().unwrap());
    for arg in iter {
        cmd.arg(arg);
    }
    cmd
}

fn read_line() -> String {
    let mut buf = String::new();
    std::io::stdin().read_line(&mut buf).unwrap();
    buf.pop(); // newline
    buf
}

#[allow(unused)]
trait CommandExt {
    /// run to completion, return stdout.
    /// optionally supply stdin.
    fn run(&mut self, stdin: Option<String>) -> String;
    /// spawn command and wait for it to complete.
    /// std streams are inherited.
    fn spawn_wait(&mut self) -> std::process::ExitStatus;
}
impl CommandExt for std::process::Command {
    fn run(&mut self, stdin: Option<String>) -> String {
        self.stdin(std::process::Stdio::piped())
            .stdout(std::process::Stdio::piped())
            .stderr(std::process::Stdio::piped());
        let mut child = self.spawn().unwrap();
        if let Some(stdin) = stdin {
            let mut child_stdin = child.stdin.take().unwrap();
            child_stdin.write_all(stdin.as_bytes()).unwrap();
        }
        let mut child_stdout = child.stdout.take().unwrap();

        let status = child.wait().unwrap();

        let mut stdout = String::new();
        child_stdout.read_to_string(&mut stdout).unwrap();
        assert!(status.success());

        if stdout.ends_with('\n') {
            stdout.pop();
        }
        stdout
    }

    fn spawn_wait(&mut self) -> std::process::ExitStatus {
        self.spawn().unwrap().wait().unwrap()
    }
}
