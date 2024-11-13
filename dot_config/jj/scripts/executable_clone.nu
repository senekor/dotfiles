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
  let parsed = if $repo_url =~ "http(s)?://" {
    let parsed_http = (
      $repo_url
      | parse "{http}://{domain}/{owner}/{repo}"
      | get 0
    )
    {
      short_host: $"git@($parsed_http.domain)"
      owner: $parsed_http.owner,
      repo: $parsed_http.repo,
    }
  } else {
    (
      $repo_url
      | parse "{short_host}:{owner}/{repo}"
      | get 0
    )
  }
  let owner = $parsed.owner
  let repo = $parsed.repo | str replace --regex '\.git$' ""

  let known_hosts = (
    open ~/.ssh/config
    | split row "\n\n"
    | parse --regex '^Host (?<short_host>\w+)\s*User git\s*HostName (?<host>\S+)'
  )
  let matched_host = (
    $known_hosts
    | where { $in.short_host == $parsed.short_host }
    | get 0?
  )
  let host = if $matched_host != null {
    $matched_host.host
  } else {
    $parsed.short_host | parse "git@{host}" | get 0.host
  }

  let repo_url = $"git@($host):($owner)/($repo)"

  cd ~/repos

  if ($jj_block_list | any { |elem| $elem == $repo }) {
    git clone $repo_url ...$rest
    cd $repo
    return
  }

  jj git clone --colocate $repo_url ...$rest

  cd $repo

  let default_email = (open ~/.config/jj/config.toml | get user.email)
  if $host == github.zhaw.ch {
    if ($default_email != senk@zhaw.ch) {
      jj config set --repo user.email senk@zhaw.ch
      jj describe --reset-author --no-edit
    }
  } else if ($default_email != remo@buenzli.dev) {
    jj config set --repo user.email remo@buenzli.dev
    jj describe --reset-author --no-edit
  }
}