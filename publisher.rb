require "bunny" # don't forget to put gem "bunny" in your Gemfile

conn = Bunny.new(ENV['CLOUDAMQP_ENDPOINT'])
conn.start

ch = conn.create_channel

# get or create exchange
x = ch.fanout("blog.posts")

# get or create queue (note the durable setting)
queue = ch.queue("dashboard.posts", durable: true)

# bind queue to exchange
queue.bind("blog.posts")

x.publish("Hello!", routing_key: queue.name)

conn.close
