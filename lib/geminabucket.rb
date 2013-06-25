require "rubygems/remote_fetcher"
require "geminabucket/version"
require "geminabucket/remote_fetcher"


Gem::RemoteFetcher.fetcher = Geminabucket::RemoteFetcher.new

