#
# Cookbook Name:: awsenv
# Recipe:: default
#
# Copyright 2013, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

['RDS_DB_NAME','RDS_USERNAME','RDS_PASSWORD','RDS_HOSTNAME','RDS_PORT','AWS_ACCESS_KEY_ID', 'AWS_SECRET_KEY'].each do |var|
  magic_shell_environment var do
    action :add
    value node['envs'][var]
  end
end

file_contents = "conf = HtmlPod::Application.config
  conf.s3_bucket = #{node['envs']['S3BUCKET']}
  conf.s3_credentials = {
    access_key_id: #{node['envs']['AWS_ACCESS_KEY_ID']},
    secret_key:    #{node['envs']['AWS_SECRET_KEY']}
  }"
resource = file "/srv/www/#{node['envs']['APP']}/current/config/initializers/01_s3.rb" do
  owner "deploy"
  group "root"
  mode "0644"
  content file_contents
  action :nothing
end

resource.run_action(:create)

file_contents = "production:
  adapter: mysql2
  encoding: utf8
  database: #{node['envs']['RDS_DB_NAME']}
  username: #{node['envs']['RDS_USERNAME']}
  password: #{node['envs']['RDS_PASSWORD']}
  host:  #{node['envs']['RDS_HOSTNAME']}
  port:  #{node['envs']['RDS_PORT']}"

resource = file "/srv/www/#{node['envs']['APP']}/shared/config/database.yml" do
  owner "deploy"
  group "root"
  mode "0660"
  content file_contents
  action :nothing
end

resource.run_action(:create)
