
const {MongoClient, ObjectId} = require('mongodb');

const uri =
  "mongodb://192.168.128.157:17018/?poolSize=3&writeConcern=majority";
const dbName = 'simCloud';




const MongoClientOptions = {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}

// const client = new MongoClient(uri, MongoClientOptions);

// https://github.com/sadller/chitchat-nodejs/blob/962691f79c2f4ddea02fed8f88d568ee2eacf428/src/db/dbOperations.js
/**
 * 创建集合
 * @param {string} collectionName 
 */
const createCollection = async (collectionName) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.createCollection(collectionName);
        console.log(`Collection created : ${collectionName}`);
    } catch (err) {
        console.log(err);
        throw err;
    } finally {
        if (conn != null) conn.close();
    }
}

const renameCollection = async (fromCollection, toCollection) => {
    // const conn = await MongoClient.connect(uri, MongoClientOptions);
    // const database = conn.db(dbName);
    // const res = await database.renameCollection(collectionName, newCollectionName);
    // console.log('表重命名', res);
    // return res;
    // fromCollection: string,
    // toCollection: string,
    return businessRun(async (database) => {
        const res = await database.renameCollection(fromCollection, toCollection)
        console.log('表重命名', res);
        return res;
    })
}

/**
 * 删除集合
 * @param {string} collectionName 
 */
const dropCollection = async(collectionName) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).drop();
        console.log(`Collection dropped : ${collectionName}`);
        return res;
    } catch (err) {
        console.error(err);
        throw err
    } finally {
        if (conn != null) conn.close();
    }
}

/**
 * 插入数据
 * @param {string} collectionName 
 * @param {*} doc 
 */
const insertOne = async (collectionName, doc) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).insertOne(doc);
        return res.ops;
    } catch (err) {
        console.log(err);
        throw err
    } finally {
        if (conn != null) conn.close();
    }
}

/**
 * 插入多条数据
 * @param {string} collectionName 
 * @param {array} doc 
 */
const insertMany = async (collectionName, doc) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).insertMany(doc);
        console.log("插入的文档数量为: " + res.insertedCount);
        return res.ops;
    } catch (err) {
        console.log(err);
        throw err
    } finally {
        if (conn != null) conn.close();
    }
}

/**
 * 更新一条数据
 * @param {string} collectionName 
 * @param {*} query 
 * @param {*} update e.g. {$set: { "url" : "https://www.runoob.com" }};
 */
const updateOne = async (collectionName, query, update) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).updateOne(query, update);
        return res;
    } catch (err) {
        console.log(err);
        throw err
    } finally {
        if (conn != null) conn.close();
    }
}

const updateById = async (collectionName, id, doc) => {
    return businessRun(async (database) => {
        const whereObj = { _id: ObjectId(id) }
        const updateObj = {  $set: doc }
        delete doc._id;
        const res = await database.collection(collectionName).updateOne(whereObj, updateObj);
        return res.result;
    });
}

/**
 * 
 * @param {function} businessExcutor an async function
 */
const businessRun = async (businessExcutor) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        res = await businessExcutor(database)
        return res;
    } catch (error) {
        console.log(err);
        throw err
    } finally {
        if (conn != null) conn.close();
    }
}

/**
 * 更新多条数据
 * @param {string} collectionName 
 * @param {*} query 
 * @param {*} update e.g. {$set: { "url" : "https://www.runoob.com" }};
 */
const updateMany = async (collectionName, query, update) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).updateMany(query, update);
        return res;
    } catch (err) {
        console.log(err);
        throw err
    } finally {
        if (conn != null) conn.close();
    }
}

/**
 * 查询数据
 * @param {string} collectionName 
 * @param {object} query 查询条件
 * @param {object} projection 查询的列定义。
 */
const findOne = async (collectionName, query, projection=null) => {
    let conn = null;
    try{
        conn = await MongoClient.connect(uri, MongoClientOptions)
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).findOne(query,{projection});
        return res;
    }catch(err){
        console.log(err);
        throw err;
    } finally {
        if (conn != null) conn.close();
    }
}

const findById = async(collectionName, id) => {
    return businessRun(async (database) => {
        const whereObj = {_id: ObjectId(id)};
        return await database.collection(collectionName).findOne(whereObj);
    })
}

/**
 * 查询数据
 * @param {string} collectionName 
 * @param {object} query 查询条件
 * @param {object} projection 查询的列定义。
 *  The fields to return in the query. 
 *  Object of fields to either include or exclude (one of, not both),
 *  {'a':1, 'b': 1} or {'a': 0, 'b': 0}
 * @param {number} limit 查询数量
 * @param {number} skip 查询起始位置
 */
const find = async (collectionName, query, projection=null, limit=0, skip=0) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).find(query, { projection })
                                .limit(limit)
                                .skip(skip)
                                .sort({ "timestamp": -1 }) // 排序，1升序，-1降序
                                .toArray();
        return res;
    } catch (err) {
        console.log(err);
        throw err;
    } finally {
        if (conn != null) conn.close();
    }
}

const finAll = async function (collectionName) {
    return businessRun(async (database) => {
        return await database.collection(collectionName).find({}).sort({ "timestamp": -1 }).toArray();
    });
}

const findPage = async function (collectionName, query, projection, pageSize, pageNum) {
    const excutor = async (database) => {
        const limit = pageSize;
        const skip = pageNum && pageNum > 0 ? pageSize * (pageNum - 1) : 0;
        return await database.collection(collectionName)
                                .find(query, { projection })
                                .limit(limit)
                                .skip(skip)
                                .sort({ "timestamp": -1 })
                                .toArray();
    }

    return businessRun(excutor);
}

const count = async (collectionName, query) => {
    let conn = null;
    try {
        conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).find(query).count();
        return res;
    } catch (err) {
        console.log(err);
        throw err;
    } finally {
        if(conn != null) conn.close();
    }
}

/**
 * 删除一条数据
 * @param {string} collectionName 
 * @param {object} query 
 */
const deleteOne = async (collectionName, query) => {
    console.log(collectionName, query)
    let conn = null;
    try{
        conn = await MongoClient.connect(uri, MongoClientOptions)
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).deleteOne(query);
        console.log(res.result.n + " 条文档被删除");
        return res.result;
    } catch(err) {
        console.log(err);
        throw err;
    } finally {
        if (conn != null) conn.close();
    }
}

const deleteByObjectId = async (collectionName, _id) => {
    return deleteOne(collectionName, {_id: ObjectId(_id)});
}

/**
 * 删除多条数据
 * @param {string} collectionName 
 * @param {object} query 
 */
const deleteMany = async (collectionName, query) => {
    let conn = null;
    try{
        conn = await MongoClient.connect(uri, MongoClientOptions)
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).deleteMany(query);
        console.log(res.result.n + " 条文档被删除");
        return res.result.n;
    } catch(err) {
        console.log(err);
        throw err;
    } finally {
        if (conn != null) conn.close();
    }
}

const doMongoDbQuery = async (tableName) => {
  try {
    // Connect the client to the server
    let dbo = await client.connect();
    // Establish and verify connection
    //await client.db("admin").command({ ping: 1 });
    //console.log("Connected successfully to server");
    const database = client.db("admin");
    const users = database.collection("user");
    const query = { username: "iammongo" };
     const options = {
      // sort matched documents in descending order by rating
      sort: { rating: -1 },
      // Include only the `title` and `imdb` fields in the returned document
      projection: { _id: 0, username: 1, password: 1 },
    };

    const user = await users.findOne(query, options);
    return user ;
  
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}


const doMongoDbFindOne = async (tableName,query,options) => {
  try {
    // Connect the client to the server
    let dbo = await client.connect();
    // Establish and verify connection
    //await client.db("admin").command({ ping: 1 });
    //console.log("Connected successfully to server");
    const database = client.db("admin");
    const users = database.collection("user");
    const query = { username: "iammongo" };
     const options = {
      // sort matched documents in descending order by rating
      sort: { rating: -1 },
      // Include only the `title` and `imdb` fields in the returned document
      projection: { _id: 0, username: 1, password: 1 },
    };

    const user = await users.findOne(query, options);
    return user ;
  
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}

const doMongoDbFindMore = async (tableName) => {
  try {
    // Connect the client to the server
    let dbo = await client.connect();
    // Establish and verify connection
    //await client.db("admin").command({ ping: 1 });
    //console.log("Connected successfully to server");
    const database = client.db("admin");
    const users = database.collection("user");
    const query = { username: "iammongo" };
     const options = {
      // sort matched documents in descending order by rating
      sort: { rating: -1 },
      // Include only the `title` and `imdb` fields in the returned document
      projection: { _id: 0, username: 1, password: 1 },
    };

    const user = await users.findOne(query, options);
    return user ;
  
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}

const aggregate = async (collectionName, pipeline=[], options) => {
    let conn = null;
    try {
        let conn = await MongoClient.connect(uri, MongoClientOptions);
        const database = conn.db(dbName);
        const res = await database.collection(collectionName).aggregate(pipeline, options).toArray();
        return res;
    } catch (err) {
        console.log(err);
        throw err;
    } finally {
        if (conn != null) conn.close();
    }

    // let conn = null;
    // try {
    //     conn = await MongoClient.connect(uri, MongoClientOptions);
    //     const database = conn.db(dbName);
    //     const res = await database.collection(collectionName).aggregate(pipeline).toArray();
    //     return res;
    // } catch (err) {
    //     console.log(err);
    //     throw err;
    // } finally {
    //     if (conn != null) conn.close();
    // }
}



module.exports = {
    createCollection,
    renameCollection,
    dropCollection,
    insertOne,
    insertMany,
    updateOne,
    updateMany,
    updateById,
    findOne,
    findById,
    find,
    finAll,
    findPage,
    count,
    deleteByObjectId,
    deleteOne,
    deleteMany,
    doMongoDbQuery,
    doMongoDbFindOne,
    doMongoDbFindMore,
    ObjectId,
    aggregate
}