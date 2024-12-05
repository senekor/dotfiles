#!/usr/bin/env nu

# This is a custom wrapper around jj/git clone.
# It uses jj by default, but git for explicitly blocked repos.
# In addition, it makes sure that the email address is set correctly
# for private and business repos.

let jj_block_list = [
  DISTRAL_ZHAW_Kistler # use of git-lfs
]

def main [
  repo_url: string # the repo to clone
  ...rest: string # additional clone args for jj
] {
  let parsed = $repo_url | any_to_ssh_url
  let host = $parsed.host | resolve_short_host
  let owner = $parsed.owner
  let repo = $parsed.repo | str replace --regex '\.git$' ""

  let repo_url = $"git@($host):($owner)/($repo)"
  let destination = $"($env.HOME)/repos/($host)/($owner)/($repo)"

  let plain_git_repo = $jj_block_list | any { |elem| $elem == $repo }

  if $plain_git_repo {
    git clone $repo_url $destination ...$rest
  } else {
    jj git clone --colocate $repo_url $destination ...$rest
  }

  cd $destination
  cat ../../.gitconfig | save --append .git/config

  if not $plain_git_repo {
    cat ../../jj_config.toml | save --append .jj/repo/config.toml
    jj describe --reset-author --no-edit --quiet
  }
}

def any_to_ssh_url []: string -> record<host: string, owner: string, repo: string> {
  let repo_url = $in
  if $repo_url =~ "http(s)?://" {
    let parsed_http = (
      $repo_url
      | parse "{http}://{domain}/{owner}/{repo}"
      | get 0
    )
    {
      host: $"git@($parsed_http.domain)"
      owner: $parsed_http.owner,
      repo: $parsed_http.repo,
    }
  } else {
    (
      $repo_url
      | parse "{host}:{owner}/{repo}"
      | get 0
    )
  }
}

def resolve_short_host []: string -> string {
  let host = $in
  let known_hosts = (
    open ~/.ssh/config
    | split row "\n\n"
    | parse --regex '^Host (?<short_host>\w+)\s*User git\s*HostName (?<host>\S+)'
  )
  let matched_host = (
    $known_hosts
    | where { $in.short_host == $host }
    | get 0?
  )
  if $matched_host != null {
    $matched_host.host
  } else {
    $host | parse "git@{host}" | get 0.host
  }
}
