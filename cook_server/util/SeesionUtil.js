var mongodb = require('../mongo/mongoDbDeal');


const getUserInfo = (req)=>{
    //TODO: 从session中获取
    const user = req.session.user;
    console.log('req.session.user', user)
    console.log('req.cookies', req.cookies)
    if(user) {
        return {
            userId: mongodb.ObjectId(user._id),
            userName: user.user_name,
            organize: user.organizeId ? mongodb.ObjectId(user.organizeId) : (req.cookies.orgId ? mongodb.ObjectId(req.cookies.orgId) : null)
        }
    } else if (req.cookies.userId) {
        return {
            userId: mongodb.ObjectId(req.cookies.userId),
            userName: req.cookies.username,
            organize: req.cookies.orgId ? mongodb.ObjectId(req.cookies.orgId) : null
        }
    }
    return {
        userId:mongodb.ObjectId('610794f41a7fdd2b9d19d2c0'),
        userName:'pkc',
        organize:mongodb.ObjectId('6108a38c195a2850a7fcb6d9')

    }
}

module.exports = {
    getUserInfo
}