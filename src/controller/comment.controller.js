const CommentService = require('../service/comment.service')

class CommentController {
  async create(ctx,next){
    const { momentId, content } = ctx.request.body
    const { id } = ctx.user

    const result = await CommentService.create(momentId,content,id)
    console.log('发表评论成功！')
    ctx.body = result
  }

  async reply(ctx,next){
    const { momentId, content } = ctx.request.body
    const { commentId } = ctx.params
    const { id } = ctx.user
    const result = await CommentService.reply(momentId,content,id,commentId)
    console.log("对别人的评论进行评论~")
    ctx.body = result
  }

  async update(ctx,next){
    const { commentId } = ctx.params
    const { content } = ctx.request.body
    const result = await CommentService.update(commentId,content)
    console.log("修改评论成功")
    ctx.body = result
  }

  async remove(ctx,next){
    const { commentId } = ctx.params
    const result = await CommentService.remove(commentId)
    ctx.body = result
  }
}

module.exports = new CommentController()