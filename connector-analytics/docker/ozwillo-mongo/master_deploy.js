use admin
rs.initiate()
// Using IP since studio can not yet --add-host in both ways using links
// If ozwillo-mongo-1 has IP adress 172.17.0.2, if you did rs.add("172.17.0.2:27017"), it would raise error 13433 exception: can not find self in new replset config.
rs.add("172.17.0.3:27017")
rs.add("172.17.0.4:27017")
cfg = rs.conf()
// Replaces the docker-gen of this host by ip https://sebastianvoss.com/docker-mongodb-sharded-cluster.html
cfg.members[0].host = "172.17.0.2:27017"
// Prevents ozwillo-mongo-2 from becoming master :
// (so that it can be targeted as custom secondary by an LDDatabaseLink without risk)
// https://docs.mongodb.com/v2.6/tutorial/configure-secondary-only-replica-set-member/
cfg.members[1].priority = 0
rs.reconfig(cfg)
rs.status()
// check if rs.status() says all other replica are SECONDARY
