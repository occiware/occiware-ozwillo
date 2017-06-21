// If and only if replicaSet status has not been set up yet
if (rs.status().startupStatus === 3) {
    db = db.getSiblingDB('admin');

    rs.initiate();
    print("RS status after initiate :");
    printjson(rs.status());
    // Wait for 5s, then execute
    setTimeout(function(){
        print("RS status after initiate +5s :");
        printjson(rs.status());
        // Using IP since studio can not yet --add-host in both ways using links
        // If ozwillo-mongo-1 has IP adress 172.17.0.2, if you did
        // rs.add("172.17.0.2:27017"), it would raise error 13433 exception: can
        // not find self in new replset config.
        rs.add("ozwillo-mongo-2:27017");
        rs.add("ozwillo-mongo-3:27017");
        print("RS status after adding ozwillo-mongo-2/3 :");
        printjson(rs.status());

        // Replaces the docker-gen of this host by ip :
        // https://sebastianvoss.com/docker-mongodb-sharded-cluster.html
        cfg = rs.conf();
        cfg.members[0].host = "ozwillo-mongo-1:27017";
        print("RS status after changing cfg.members[0].host to ozwillo-mongo-1 :");
        printjson(rs.status());
        // Prevents ozwillo-mongo-2 from becoming master :
        // (so that it can be targeted as custom secondary by an LDDatabaseLink
        // without risk) :
        // https://docs.mongodb.com/v2.6/tutorial/configure-secondary-only-replica-set-member/
        cfg.members[1].priority = 0;
        print("RS status after changing cfg.members[1].priority to ozwillo-mongo-1 :");
        printjson(rs.status());
        rs.reconfig(cfg);
        rs.status();
        print("Final RS status :");
        printjson(rs.status());
        // check if rs.status() says all other replica are SECONDARY
    }, 5000);
}
