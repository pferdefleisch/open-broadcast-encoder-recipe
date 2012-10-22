#
# Cookbook Name:: open_broadcast_encoder
# Recipe:: default
#
# Copyright 2012, Aaron Cruz (aaron@aaroncruz.com)
#
# All rights reserved - Do Not Redistribute
#

# Dependencies
%w(libtwolame-dev libzvbi0 libzvbi-dev libzvbi-common).each do |lib|
  package lib do
    action :install
  end
end

### FDK-AAC
name  = 'fdk-aac'
owner = 'kierank'

git "Git #{name}" do
  repository "git://github.com/#{owner}/#{name}.git"
  reference 'master'
  destination "#{node[:obe][:git][:directory]}/#{name}"
  action :export
end

bash "Install #{name}" do
  cmd = <<-COMMAND
    cd #{node[:obe][:git][:directory]}/#{name}
    make distclean
    autoreconf -i && LDFLAGS="-I#{node[:obe][:prefix]}/include" CFLAGS="-L#{node[:obe][:prefix]}/lib" ./configure --prefix=#{node[:obe][:prefix]}
    make -j5
    make install
  COMMAND
  Chef::Log.info("COMMAND: #{cmd}")
  code cmd
end

# LIBAV
name  = 'libav-obe-dev2'
owner = 'kierank'

git "Git #{name}" do
  repository "git://github.com/#{owner}/#{name}.git"
  reference 'master'
  destination "#{node[:obe][:git][:directory]}/#{name}"
  action :export
end

bash "Install #{name}" do
  cmd = <<-COMMAND
    cd #{node[:obe][:git][:directory]}/#{name}
    make distclean
    LDFLAGS="-L#{node[:obe][:prefix]}/lib" CFLAGS="-I#{node[:obe][:prefix]}/include" ./configure --prefix=#{node[:obe][:prefix]} --enable-gpl --enable-nonfree --enable-libfdk-aac --disable-swscale-alpha --disable-avdevice
    make -j5
    make install
  COMMAND
  Chef::Log.info("COMMAND: #{cmd}")
  code cmd
end
#
## LIBX264
name  = 'x264-obe'
owner = 'kierank'

git "Git #{name}" do
  repository "git://github.com/#{owner}/#{name}.git"
  reference 'master'
  destination "#{node[:obe][:git][:directory]}/#{name}"
  action :export
end

bash "Install #{name}" do
  cmd = <<-COMMAND
    cd #{node[:obe][:git][:directory]}/#{name}
    make distclean
    LDFLAGS="-I#{node[:obe][:prefix]}/include" CFLAGS="-L#{node[:obe][:prefix]}/lib"./configure --prefix=#{node[:obe][:prefix]}
    make -j5
    make install-lib-static
  COMMAND
  Chef::Log.info("COMMAND: #{cmd}")
  code cmd
end

# LIBMPEGTS
name  = 'libmpegts'
owner = 'kierank'

git "Git #{name}" do
  repository "git://github.com/#{owner}/#{name}.git"
  reference 'master'
  destination "#{node[:obe][:git][:directory]}/#{name}"
  action :export
end

bash "Install #{name}" do
  cmd = <<-COMMAND
    cd #{node[:obe][:git][:directory]}/#{name}
    make distclean
    LDFLAGS="-I#{node[:obe][:prefix]}/include" CFLAGS="-L#{node[:obe][:prefix]}/lib"./configure --prefix=#{node[:obe][:prefix]}
    make -j5
    make install
  COMMAND
  Chef::Log.info("COMMAND: #{cmd}")
  code cmd
end

# Open Broadcast Encoder
name  = 'broadcastencoder'
owner = 'kierank'

git "Git #{name}" do
  repository "git://github.com/#{owner}/#{name}.git"
  reference node[:obe][:git][:branch]
  destination "#{node[:obe][:git][:directory]}/#{name}"
  action :export
end

bash "Install #{name}" do
  cmd = <<-COMMAND
    cd #{node[:obe][:git][:directory]}/#{name}
    make distclean
    LDFLAGS="-L#{node[:obe][:prefix]}/lib" CFLAGS="-I#{node[:obe][:prefix]}/include" ./configure --prefix=#{node[:obe][:prefix]}
    make -j5
    make install
  COMMAND
  Chef::Log.info("COMMAND: #{cmd}")
  code cmd
end
