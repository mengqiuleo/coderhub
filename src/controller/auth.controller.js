const jwt = require('jsonwebtoken')
const { PRIVATE_KEY } = require('../app/config')

class AuthController {
  async login(ctx,next) {
    console.log(ctx.user)
    const {id,name} = ctx.user
    const token = jwt.sign({id,name},PRIVATE_KEY,{
      expiresIn: 60 * 60 * 24 * 24,
      algorithm: 'RS256'
    })

    // const { name } = ctx.request.body
    ctx.body = {
      id,
      name,
      token
    }
    console.log('登录成功~')
  }

  async success(ctx,next) {
    ctx.body = '授权成功~'
  }
}

module.exports = new AuthController()