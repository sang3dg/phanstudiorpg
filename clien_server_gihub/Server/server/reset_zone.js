var redis = require('redis');
var async = require('async');
var redisKey = require('./common/redis_key');
var cfgRedis = require('../server_config/redis.json');
var cfgZone = require('../server_config/zone.json');

var  client = redis.createClient(cfgRedis.globalRedis.port, cfgRedis.globalRedis.ip);
if(cfgRedis.globalRedis.pwd != '') {
    client.auth(cfgRedis.globalRedis.pwd);
}

/**
 * 结束进程
 * @param err 错误码，0表示正常退出
 */
function exit (err) {
    setTimeout(
        function() {
            process.exit(err);
        },
        1000
    );
}

async.waterfall([
    function(callback) { /*  区配置 */
        client.SET(redisKey.keyStringZidSerial, cfgZone.length);

        async.each(cfgZone, function(zone, eachCb) {
            client.HSET(redisKey.keyHashZoneInfo, zone.zid, JSON.stringify(zone), eachCb);
        }, function(err) {
            if(err) {
                console.log('set zone config err: ' + err);
            }
            callback(err);
        });
    }
], function(err) {
    if(err) {
        console.log('Failed.');
    }
    else {
        console.log('Succeed.')
    }
    exit(0);
});

