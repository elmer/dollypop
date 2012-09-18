# this reads database_*.yml files in /etc/dollypop and turns them into facts
# eg 
# database_drupal.yml
# ---
# name: drupaldb
# user: drupaluser
# password: secret
#
# will create facts
# database_drupal_name: drupaldb
# database_drupal_user: drupaluser
# database_drupal_password: secret
#
# database_wp.yml
# ---
# name: wordpress
# user: wp_user
# password: s3cr3t
#
# will create facts
# database_wp_name: wordpress
# database_wp_user: wp_user
# database_wp_password: s3cr3t
#
# and finally it creates
#
# databases: database_drupal,database_wp
#
require "yaml"

data_files = Dir["/etc/dollypop/database_*.yml"]

databases = [ ]

data_files.each do |file|
  next if File.directory?(file)
  file_name = File.basename(file)
  prefix = file_name.split(".").first.sub(/^database_/,'')
  databases << prefix

  file_contents = YAML.load_file(file)
  file_contents.each_pair do |k,v|
    Facter.debug("K=#{k}")
    Facter.add("database_#{prefix}_#{k}") do
      setcode { v }
    end
  end
end

unless databases.empty?
  Facter.add("databases") do
    setcode { databases.join }
  end
end


