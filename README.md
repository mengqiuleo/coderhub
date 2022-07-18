
文件目录：
```
coderhub
├─ .gitignore
├─ package-lock.json
├─ package.json
├─ src
│  ├─ app
│  │  ├─ config.js
│  │  ├─ database.js
│  │  ├─ error_handle.js
│  │  ├─ index.js
│  │  └─ keys //jwt的公钥和私钥
│  │     ├─ private.key
│  │     └─ public.key
│  ├─ constants
│  │  └─ error_types.js
│  ├─ controller
│  │  ├─ auth.controller.js
│  │  ├─ comment.controller.js
│  │  ├─ label.controller.js
│  │  ├─ moment.controller.js
│  │  └─ user.controller.js
│  ├─ main.js
│  ├─ middleware
│  │  ├─ auth.middleware.js
│  │  ├─ label.middleware.js
│  │  └─ user.middleware.js
│  ├─ router
│  │  ├─ auth.router.js
│  │  ├─ comment.router.js
│  │  ├─ index.js
│  │  ├─ label.router.js
│  │  ├─ moment.router.js
│  │  └─ user.router.js
│  ├─ service //数据库相关操作
│  │  ├─ auth.service.js
│  │  ├─ comment.service.js
│  │  ├─ label.service.js
│  │  ├─ moment.service.js
│  │  └─ user.service.js
│  └─ utils
│     └─ password_handle.js
├─ table.sql //数据库查询语句
└─ table.sql.bak

```

- main.js是项目的入口
- 我们会在 main.js 中引入 app/index.js，我们在 index.js 中注册一些内置模块，并且引入路由
- app/database.js 中是用koa连接数据库
- app/error_handle.js 统一定义了一些返回错误的状态码
- app/config.js 中存放了一些配置文件，并且会用到根目录下的 .env 文件
- controller, middleware, router 中存放了每个功能模块的控制器，中间件，路由
- service文件夹存放数据库的操作



该项目是按照功能划分的。

对于每一个router，首先调用对应的中间件，判断是否有权限(在中间件里面，我们可能会调用数据库操作进行查询)，然后调用控制器，执行要实现的功能。



