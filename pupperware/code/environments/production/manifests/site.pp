node default {
  notify { 'site default message':
    message => 'Puppet Configuration Management: Default Node'
  }
}

# TODO: add your laptop computer name
node 'xxxx.domain.com' {
  file { '/home/hello.txt':
    ensure => file,
  }
  -> file_line { 'file_content':
    line => 'File created and maintained by Puppet!',
    path => '/home/hello.txt'
  }
}
