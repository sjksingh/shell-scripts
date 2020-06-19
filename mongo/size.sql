db.getMongo().getDBNames().forEach(function(d) {
var curr_db = db.getSiblingDB(d);
var total_size = 0;
curr_db.getCollectionNames().forEach(function(coll) {
var coll_size =
curr_db.getCollection(coll).stats().storageSize;
total_size = total_size + coll_size;
});
print(d + ": " + total_size/(1024*1024));
});;
