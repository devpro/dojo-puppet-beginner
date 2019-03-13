# DOJO Puppet (beginner)

This repository holds the files needed to show Puppet in action, this part of the Dojo on Puppet for beginners.

Make sure to have seen first the presentation at [slides.com/devprofr/dojo-puppet](https://slides.com/devprofr/dojo-puppet#/).

## Practice

Let's make our hands dirty!

### Requirements

The following tools must be present on your computer (latest version is advised):

- [git](https://git-scm.com/)
- [Docker](https://docs.docker.com/) & [docker-compose](https://docs.docker.com/compose/)

### Exercise 1

#### Pupperware

First step will be to use and learn from [puppetlabs/pupperware](https://github.com/puppetlabs/pupperware).

- Clone the repository
  - Look in particular at `docker-compose.yml` file content

- Launch `DNS_ALT_NAMES=host.example.com docker-compose up -d`
  - You should have the following output:

    > Creating pupperware_puppet_1   ... done  
    > Creating pupperware_postgres_1 ... done  
    > Creating pupperware_puppetdb_1 ... done  

- You can enter the puppet master container and execute some commands: `docker exec -it pupperware_puppet_1 bash`
- You can also easily execute puppet commands on the puppet master:
  - Get Puppet version: `DNS_ALT_NAMES=host.example.com bin/puppet --version`
  - Get some configuration value: `DNS_ALT_NAMES=host.example.com bin/puppet config print autosign --section master`
- And finally execute [pupperserver commands](https://puppet.com/docs/puppetserver/6.2/subcommands.html):
  - Display the [Ruby packages (Gems)](https://rubygems.org/) used by the pupper server: `DNS_ALT_NAMES=host.example.com bin/puppetserver gem list`

- When you're done, make sure to clean everything: `docker-compose down`

#### Alpine

Second step is to use this puppet master on clients through the Puppet agent, on an [Alpine](https://www.alpinelinux.org/) OS.

Documentation:

- [Using Puppet with Alpine Linux](https://puppet.com/blog/using-puppet-alpine-linux)
  - Issue with missing components [fpm is broken on Alpine 3.8](https://github.com/jordansissel/fpm/issues/1534)
- [Docker image](https://docs.docker.com/samples/library/alpine/)
- [puppet-in-docker/puppet-agent-alpine/Dockerfile](https://github.com/puppetlabs/puppet-in-docker/blob/master/puppet-agent-alpine/Dockerfile)

Steps (from exercise_1 folder):

- `docker-compose up -d --build`
- Open [localhost:8056](http://localhost:8056/) to check nginx is running (with a nice 404 ^^)
- `docker exec -it dojo_puppet_alpine bash`
  - `facter --version`
  - `facter os`
  - `puppet agent --verbose --onetime --no-daemonize --summarize`
  - `puppet resource file /et`
  - `puppet resource package`
- `docker-compose down`

## References

- [devprofr/knowledge-base](https://dev.azure.com/devprofr/knowledge-base/_wiki/wikis/knowledge-base.wiki?wikiVersion=GBwikiMaster&pagePath=%2FInfrastructure%2FPuppet&pageId=182)
- [devpro/puppet-training-beginner](https://github.com/devpro/puppet-training-beginner)
- [devpro.github.io/puppet/cheatsheet](https://devpro.github.io/puppet/cheatsheet.html)
