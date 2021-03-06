require 'sneakers' # don't forget to put gem "sneakers" in your Gemfile
require 'sneakers/runner'


class Processor
  include Sneakers::Worker
  # This worker will connect to "dashboard.posts" queue
  # env is set to nil since by default the actuall queue name would be
  # "dashboard.posts_development"
  from_queue "dashboard.posts", env: nil

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes
  def work(raw_post)
    puts "Msg received: " + raw_post
    ack! # we need to let queue know that message was received
  end
end

opts = {
  :amqp => ENV['CLOUDAMQP_ENDPOINT'],
  :vhost => ENV['CLOUDAMQP_PASSWORD'],
  :exchange => 'sneakers',
  :exchange_type => :direct
}

Sneakers.configure(opts)
r = Sneakers::Runner.new([Processor])
r.run
