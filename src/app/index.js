const Koa = require('koa')
const bodyParser = require('koa-bodyparser') 
const errorHandle = require('./error_handle')
const useRouters = require('../router/index')

const app = new Koa()

app.use(bodyParser())
useRouters(app)

app.on('error',errorHandle)

module.exports = app