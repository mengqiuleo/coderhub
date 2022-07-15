const errorType = require('../constants/error_types')
const service = require('../service/user.service')
const md5password = require('../utils/password_handle')

//判断是否为空，是否被注册过
const verifyUser = async (ctx,next) => {
  // 1.获取用户名和密码
  const { name, password } = ctx.request.body

  // 2.判断用户名和密码不能为空
  if(!name || !password){
    const error = new Error(errorType.NAME_OR_PASSWORD_IS_REQUIRED)
    return ctx.app.emit('error',error, ctx);
  }

  // 3.判断这次注册的用户名是否已被用过
  const result = await service.getUserByName(name)
  console.log("判断用户是否存在",result)
  if(result.length){
    const error = new Error(errorType.USER_ALREADY_EXISTS)
    return ctx.app.emit('error',error,ctx)
  }
  await next()
}

//密码加密
const handlePassword = async (ctx,next) => {
  const { password } = ctx.request.body
  ctx.request.body.password = md5password(password)

  await next()
}

module.exports = {
  verifyUser,
  handlePassword
}