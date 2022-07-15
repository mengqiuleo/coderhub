const momentService = require('../service/moment.service')

class MomentController {
  async create(ctx, next){
    // 1.获取数据(user_id,content)
    const userId = ctx.user.id 
    const content = ctx.request.body.content
    console.log("发布动态：",userId,content) 

    // 2.将数据插入到数据库中
    const result = await momentService.create(userId,content)
    ctx.body = result

  }

  async detail(ctx,next) {
    // 1.获取数据(momentId)
    const momentId = ctx.params.momentId

    // 2.根据Id去查询这条数据
    const result = await momentService.getMomentById(momentId)
    ctx.body = result
  }

  async list(ctx,next){
    // 1.获取数据（offset,size）
    const {offset,size} = ctx.query

    // 2.查询列表
    const result = await momentService.getMomentList(offset,size)
    ctx.body = result
  }

  async update(ctx,next){
    const { momentId } = ctx.params
    const { content } = ctx.request.body
    const { id } = ctx.user

    const result = await momentService.updated(content,momentId)
    console.log("修改内容成功~")
    ctx.body = '修改内容~' + momentId + content + id
  }

  async remove(ctx,next){
    // 1.获取momentId
    const { momentId } = ctx.params

    // 2.删除内容
    const result = await momentService.remove(momentId)

    console.log("删除内容成功~")
    ctx.body = result
  }

  async addLabels(ctx,next){
    // 1.获取标签和动态id
    const { labels } = ctx
    const { momentId } = ctx.params
    
    // 2.添加所有标签
    for(let label of labels){
      // 2.1 判断标签是否已经和动态有关系
      const isExit = await momentService.hasLabel(momentId,label.id)
      if(!isExit){
        await momentService.addLabel(momentId,label.id)
      }
    }
    ctx.body = "给动态添加标签成功~"
  }
}

module.exports = new MomentController()