require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'
require 'base64'
require 'aescrypt'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      tags: [
        '~FC005',
        '~FC015',
        '~FC023'
      ]
    }
  end
end

namespace :keys do
  desc 'encrypts the needed keys for saving in to source'
  task :encrypt do
    passphrase = ENV['KEYS_PASSPHRASE']
    fail "\nMissing ENV['KEYS_PASSPHRASE'] environment variable\n" unless passphrase
    files = ['.chef/codeship.pem']
    files.each do |file|
      File.open("#{file}.enc", 'w') do |fh|
        puts "encrypting #{file} as #{file}.enc"
        fh.print(AESCrypt.encrypt(File.read(file), passphrase))
      end
    end
  end

  desc 'decrypts the needed keys for pushing to the chef server'
  task :decrypt do
    passphrase = ENV['KEYS_PASSPHRASE']
    fail "\nMissing ENV['KEYS_PASSPHRASE'] environment variable\n" unless passphrase
    files = ['.chef/codeship.pem']
    files.each do |file|
      File.open(file, 'w') do |fh|
        puts "decrypting #{file}.enc as #{file}"
        fh.puts(AESCrypt.decrypt(File.read("#{file}.enc"), passphrase))
      end
    end
  end
end

namespace :knife do
  task :ssl_fetch do
    sh 'knife ssl fetch'
  end
end

namespace :cookbook do
  task :upload do
    sh 'knife cookbook upload remedy'
    sh 'knife cookbook upload remedy -E production'
  end
end

namespace :cookbook do
  task :uploadqa do
    sh 'knife cookbook upload remedy -E qa'
  end
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)
