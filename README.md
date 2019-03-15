# DOJO Puppet (beginner)

Demonstration material following the presentation at [slides.com/devprofr/dojo-puppet](https://slides.com/devprofr/dojo-puppet#/).

## Practice

Let's make our hands dirty!

### Requirements

The following tools must be present on your computer (latest versions are advised):

- [git](https://git-scm.com/)
- [Docker](https://docs.docker.com/) & [docker-compose](https://docs.docker.com/compose/)

### Pupperware (official repo)

First step is to use [puppetlabs/pupperware](https://github.com/puppetlabs/pupperware). You'll have a working Puppet master instance with a PuppetDb.

- Clone & explore the repository
  - Look in particular at `docker-compose.yml` file content

- Launch the containers with `DNS_ALT_NAMES=host.example.com docker-compose up -d`
  - You should have the following output:

    > Creating pupperware_puppet_1   ... done  
    > Creating pupperware_postgres_1 ... done  
    > Creating pupperware_puppetdb_1 ... done  

- You can enter the puppet master container: `docker exec -it pupperware_puppet_1 bash`
- You can also execute puppet commands on the puppet master:
  - Get Puppet version: `DNS_ALT_NAMES=host.example.com bin/puppet --version`
  - Get some configuration value: `DNS_ALT_NAMES=host.example.com bin/puppet config print autosign --section master`
- And finally execute [pupperserver commands](https://puppet.com/docs/puppetserver/6.2/subcommands.html):
  - Display the [Ruby packages (Gems)](https://rubygems.org/) used by the pupper server: `DNS_ALT_NAMES=host.example.com bin/puppetserver gem list`

- When you're done, make sure to clean everything: `docker-compose down`

### Pupperware (local files)

Some changes were needed to make Pupperware work for this demonstration, so we're going to work with our own files.

- Change directory to `pupperware` folder
- Copy `docker-compose.override.yml.dist` into `docker-compose.override.yml` and review/edit the file (beware of issues on Windows with folder volume mapping...)
  - It is important `code` volume is correctly mappped/synced between your hard drive and  docker
- Start the containers: `DNS_ALT_NAMES=host.example.com docker-compose up --build`
- Run the pre-requisites from the container: `docker exec -it pupperware_puppet_1 bash`

  ```bash
  gem install r10k
  cd /etc/puppetlabs/code/environments/production
  r10k puppetfile install -v
  ```

- Clean the containers: `docker-compose down`

Assuming you have the local puppermaster working (see local Pupperware section), it's time to have a server on wich we install and run the Puppet Agent.

### Alpine

We'll start with an [Alpine](https://www.alpinelinux.org/) OS.

#### Puppet-on-Alpine documentation

- [Using Puppet with Alpine Linux](https://puppet.com/blog/using-puppet-alpine-linux)
  - Issue with missing components [fpm is broken on Alpine 3.8](https://github.com/jordansissel/fpm/issues/1534)
- [Docker image](https://docs.docker.com/samples/library/alpine/)
- [puppet-in-docker/puppet-agent-alpine/Dockerfile](https://github.com/puppetlabs/puppet-in-docker/blob/master/puppet-agent-alpine/Dockerfile)

#### Steps to use Puppet agent on Alpine container

- Change directory to `alpine-latest` folder
- Start the containers: `docker-compose up -d --build`
- Open [localhost:8056](http://localhost:8056/) to check nginx is running (with a nice 404 ^^)
- Enter the container: `docker exec -it dojo_puppet_alpine bash`
  - `puppet agent --verbose --onetime --no-daemonize --summarize`
  - `facter --version`
  - `facter os`
  - `puppet resource file /etc`
  - `puppet resource package`
- Clean the containers: `docker-compose down`

From the puppetserver you can run the command to see that certificate that has been added for the Alpine container: `puppetserver ca list --all`. You'll see a certificate such as `94293290483b.home`, this one was generated.

If you want to clean the certificates:

- Run `puppet ssl clean` from the puppet agent
- Run `puppetserver ca clean --certname 94293290483b.home,8ec2c38c523d.home,ab4101aafc92.home` from the puppet server

Once you have the ca name you can replace it in `manifests/site.pp` file and see a new file will be created ;)

## Go further

- [devprofr/knowledge-base](https://dev.azure.com/devprofr/knowledge-base/_wiki/wikis/knowledge-base.wiki?wikiVersion=GBwikiMaster&pagePath=%2FInfrastructure%2FPuppet&pageId=182)
- [devpro/puppet-training-beginner](https://github.com/devpro/puppet-training-beginner)
- [devpro.github.io/puppet/cheatsheet](https://devpro.github.io/puppet/cheatsheet.html)
