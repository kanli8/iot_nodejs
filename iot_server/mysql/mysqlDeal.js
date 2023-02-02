var mysql = require('mysql');

const pool = mysql.createPool({
    host: "127.0.0.1",
    port: 15306,
    user: "root",
    password: "keanmysql",
    database: "iot",
    connectionLimit: 3
});

// https://www.runoob.com/nodejs/nodejs-mysql.html

/* 回调写法 */
const doSQLonCallback = (sql, params, callback) => {
    let res;
    pool.getConnection(function (err, connection) {
        if (err) throw err;

        connection.query(sql, params, function (error, results, fields) {
            if (error) throw error;
            callback(results, fields);
            // error will be an Error if one occurred during the query
            // results will contain the results of the query
            // fields will contain information about the returned results fields (if any)
        });
        connection.release();


    });
}

const getMySQLConnection = function () {

    return new Promise((resolve, reject) => {
        pool.getConnection(function (err, connection) {
            if (err) return reject(err);;
            resolve(connection);
        });


    })

}

/* 供类JAVA 调用 */
const innerdoSQL = async (sql, params) => {
    var connection = await getMySQLConnection();
    return new Promise(function (resolve, reject) {
        connection.query(sql, params, function (err, rows, fields) {
            // Call reject on error states,
            // call resolve with results
            if (err) {
                console.log("mysql err:::"+err);
                connection.release();
                reject(err);
            } else {
                connection.release();
                // console.log(rows);
                resolve(rows);
            }

        });
    });
    //end promise exec sql 
}

const doSQL = async (sql, params) => {

    try {
        let result = await innerdoSQL(sql, params);
        return result
        // return result ;
    } catch (error) {
        // 处理异常
        // console.log(error);
        throw error;
    }
};


/**
 * 建表
 * @param {string} sql 
 */
const create = async (sql) => {
    try {
        const result = await innerdoSQL(sql);
        console.log('Table created.', result);
        return result;
    } catch (error) {
        console.log("CREATE ERROR - ", sql, error)
        throw error;
    }
}

/**
 * 删表
 * @param {string} tableName 
 */
const drop = async (tableName) => {
    const sql = `DROP TABLE IF EXISTS ${tableName}`;
    try {
        const result = await innerdoSQL(sql);
        console.log('Table dropped.', result);
        return result;
    } catch (error) {
        console.log("DROP ERROR - ", sql, error)
        throw error;
    }
}

/**
 * 新增数据
 * @param {string} tableName 
 * @param {array} columns e.g ['id', 'name', 'create_time', 'update_time']
 * @param {array} params  e.g [1, 'my name', 1625553954100, 1625553954100]
 */
const insert = async (tableName, columns, addSqlParams) => {
    var valuesStatement = [];
    for (let i = 0; i < columns.length; i++) {
        valuesStatement.push('?')
    }
    let addSql = `INSERT INTO ${tableName} (${columns.join(',')}) VALUES (${valuesStatement.join(',')})`;
    console.log("Insert - sql ", addSql, addSqlParams);
    try {
        const result = await innerdoSQL(addSql, addSqlParams);
        console.log('Insert completed.', result);
        return result;
    } catch (error) {
        console.log("INSERT ERROR - ", addSql, addSqlParams, error)
        throw error;
    }
}

/**
 * 更新数据
 * @param {string} tableName 
 * @param {object} params 
 * @param {object} target 
 */
const update = async (tableName, params, target) => {
    const setStatement = [];
    const statementValues = [];
    for (const key in params) {
        if (params.hasOwnProperty(key)) {
            const value = params[key];
            setStatement.push(`${key}=?`);
            statementValues.push(value);
        }
    }

    const whereStatement = [];
    for (const key in target) {
        if (target.hasOwnProperty(key)) {
            const value = target[key];
            whereStatement.push(`${key}=?`);
            statementValues.push(value);
        }
    }
    const sql = `UPDATE ${tableName} SET ${setStatement.join(',\n')} WHERE ${whereStatement.join(' and ')}`;

    try {
        const result = await innerdoSQL(sql, statementValues);
        console.log('Update completed.', result);
        return result;
    } catch (error) {
        console.error("UPDATE ERROR - ", sql, statementValues, error)
        throw error;
    }
}

/**
 * 删除数据
 * @param {string} tableName 
 * @param {object} where 
 */
const delete_ = async (tableName, where) => {
    const whereStatement = [];
    const statementValues = [];
    for (const key in where) {
        if (where.hasOwnProperty(key)) {
            const value = where[key];
            whereStatement.push(`${key}=?`);
            statementValues.push(value);
        }
    }
    const sql = `DELETE FROM ${tableName} WHERE ${whereStatement.join(' and ')}`;

    try {
        const result = await innerdoSQL(sql, statementValues);
        console.log('Update completed.', result);
        return result;
    } catch (error) {
        console.error("UPDATE ERROR - ", sql, statementValues, error)
        throw error;
    }
}

/**
 * 
 * @param {string} tableName 
 * @param {array} columns e.g. ['id', 'name']
 * @param {object} where e.g. {id: 1, name: "name"}
 * @param {object} orders e.g {id: 'desc', name: 'asc'}
 * @param {array} limit e.g. [0, 10]
 */
const select = async (tableName, columns, where, orders, limit) => {
    const sqls = [];
    sqls.push(`SELECT ${columns && columns.join(',') || '*'} FROM ${tableName}`);

    const whereStatement = [];
    const statementValues = [];
    if (where) {
        for (const key in where) {
            if (where.hasOwnProperty(key)) {
                const value = where[key];
                whereStatement.push(`${key}=?`);
                statementValues.push(value);
            }
        }
        sqls.push(`WHERE ${whereStatement.join(' and ')}`);
    }

    if (orders) {
        const orderStatement = [];
        for (const key in orders) {
            if (orders.hasOwnProperty(key)) {
                const direction = orders[key];
                orderStatement.push(`${key} ${direction === 'desc' && 'DESC' || 'ASC'}`)
            }
        }
        sqls.push(`ORDER BY ${orderStatement.join(' , ')}`)
    }
    if (limit && limit.length <= 2) {
        sqls.push(`LIMIT ${limit.join(' , ')}`)
    }
    const sql = sqls.join('\n');

    // return {sql, statementValues};
    try {
        const result = await innerdoSQL(sql, statementValues);
        console.log('Select - .', result);
        return result;
    } catch (error) {
        console.error("SELECT ERROR - ", sql, tableName, columns, where, orders, limit, error)
        throw error;
    }
}

module.exports = {
    create,
    drop,
    insert,
    update,
    delete: delete_,
    select: select,
    doSQLonCallback,
    doSQL
}








