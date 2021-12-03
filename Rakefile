desc "Publicar en GitHub los apuntes"
task :default => [ :pushhtml ] do # trabajamos en la rama curso2021
  sh "git ci -am '2020-2021' && git push -u origin main"
end

desc "sytws: bundle exec jekyll serve --watch"
task :serve do
  sh "bundle exec jekyll serve --future --watch --port 8080 --host 0.0.0.0"
end

desc "sytws: serve raw html from ../website. Use: rake 'rawserve[<portnumber>]' otherwise a random port will be chosen"
task :rawserve, [:port] => [:b] do |t, args|
  sh "http-server ../website -c-1 --port #{ args[:port] or Integer(1000+9000*rand())}"
end 


desc "local: bundle exec jekyll serve --watch"
task :ls do
  sh "bundle exec jekyll serve --host 0.0.0.0 --future --watch --port 8080"
end

desc "local serve drafts: bundle exec jekyll serve  --drafts --watch --incremental"
task :lsd do 
  sh "bundle exec jekyll serve --future --drafts --watch --incremental --port 8082"
end

desc "build"
task :b do
  sh "bundle exec jekyll build --future  -d ../website"
end

desc "build and watch"
task :bw do
  sh "bundle exec jekyll build --watch --future  -d ../website -s ."
end

task :pushhtml => [ :b ] do
  sh "./scripts/build-and-push.sh"
end

desc "sytws: build and run with http-server -p 8080 -a 10.6.128.216"
task :bss do
  sh "bundle exec jekyll build"
  sh "cd _site &&  http-server -p 8080 -a 10.6.128.216"
end

require 'html-proofer'
desc "test links in the build web site"
task :test do
  sh "git pull origin main"
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true, 
    :disable_external => true, 
    :empty_alt_ignore => true,
    :file_ignore => [ %r{categories} ]
  }
  HTMLProofer.check_directory("./_site", options).run
end
