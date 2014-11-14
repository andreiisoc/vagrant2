require 'shellwords'

def pass_string
  if node['mysql']['server_root_password'].empty?
    pass_string = ''
  else
    pass_string = '-p' + Shellwords.escape(node['mysql']['server_root_password'])
  end

  pass_string = '-p' + ::File.open('/etc/.mysql_root').read.chomp if ::File.exist?('/etc/.mysql_root')
  pass_string
end