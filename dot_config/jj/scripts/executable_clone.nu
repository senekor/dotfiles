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

  let short_host = $host | shorten_host

  let repo_url = $"git@($host):($owner)/($repo)"
  let destination = $"($env.HOME)/repos/($short_host)/($owner)/($repo)"

  let plain_git_repo = $jj_block_list | any { |elem| $elem == $repo }

  if $plain_git_repo {
    git clone $repo_url $destination ...$rest
  } else {
    # Suppress an annoying warning where jj clone picks up trunk() revset
    # alias from current repo and complains if that doesn't match the trunk of
    # the repo being cloned. Other users probably don't experience this often
    # because they only run `jj git clone` in directories which aren't already
    # a repo. I do this because this script puts the repo in a predetermined
    # location anyway.
    cd ~
    jj git clone --colocate $repo_url $destination ...$rest
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

def shorten_host []: string -> string {
  # use second-to-last fragment of domain as short_host
  # git.buenzli.dev -> buenzli
  # github.com      -> github
  # github.zhaw.ch  -> zhaw
  $in | split row "." | reverse | get 1
}
