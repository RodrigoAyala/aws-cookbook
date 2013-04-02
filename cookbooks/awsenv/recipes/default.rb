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
    value node['envs'][var]
  end
end
