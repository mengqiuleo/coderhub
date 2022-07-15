const connection = require('../app/database')

class UserService {
  async create(user){
    const { name, password } = user

    //将user存储到数据库中
    const statement = `INSERT INTO user (name, password) VALUES (?, ?);`;
    const result = await connection.execute(statement, [name, password])
    console.log('将用户数据保存到数据库中：',user)

    return result[0];
  }

  async getUserByName(name){
    const statement = `SELECT * FROM user WHERE name = ?;`
    const result = await connection.execute(statement,[name])

    return result[0]
  }
}

module.exports = new UserService()