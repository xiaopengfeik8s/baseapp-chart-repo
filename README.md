# 阿里云OSS文件上传服务

## 项目概述
这是一个基于Python Flask的文件上传服务，通过Web界面实现文件上传到阿里云OSS存储。具有邀请码验证、文件访问控制等安全特性，支持本地开发和生产环境的不同配置模式。

## 主要特性
- 邀请码登录控制
  - IP黑名单机制（3次错误自动拉黑）
  - Session有效期控制（生产环境1小时，开发环境24小时）
  - 基于IP的会话绑定（生产环境）
  
- 文件上传功能
  - 支持任意类型文件上传
  - 文件权限控制（私有/公开读）
  - 自动生成下载链接
  - 私有文件签名URL（1小时有效）
  - 公开文件永久URL
  - 实时上传进度显示
  - 邮箱地址验证

- 安全特性（生产环境）
  - HTTPS强制开启
  - Cookie安全属性
  - Session防篡改
  - Referrer来源检查
  - XSS防护头
  - 点击劫持防护
  - CSRF防护
  - 内容安全策略（CSP）
  - X-Content-Type-Options
  - X-Frame-Options
  - X-XSS-Protection

## 环境要求
- Python 3.10+
- 阿里云OSS账号和密钥
- Docker 20.10+ (可选)
- Docker Compose 2.0+ (可选)
- Kubernetes 1.23+ (可选)

## 快速开始

### 本地开发环境

1. 克隆仓库
   ```bash
   git clone <repository-url>
   cd ossupload
   ```

2. 安装依赖
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # 或 .\venv\Scripts\activate  # Windows
   pip install -r requirements.txt
   ```

3. 配置环境变量
   ```bash
   export OSS_ACCESS_KEY_ID=your_key_id
   export OSS_ACCESS_KEY_SECRET=your_key_secret
   export INVITE_CODE=your_invite_code
   export AUTHORIZED_EMAILS=user1@example.com,user2@example.com
   ```

4. 运行应用
   ```bash
   python app.py
   ```
   访问 http://localhost/ossupload

### 生产环境部署

1. 构建Docker镜像
   ```bash
   docker build -t ossupload:latest .
   ```

2. 使用Docker Compose部署
   ```bash
   docker-compose up -d
   ```

3. 部署到Kubernetes
   ```bash
   # 创建命名空间
   kubectl create namespace devops

   # 创建secret
   kubectl create secret generic ossupload-secret \
     --from-literal=OSS_ACCESS_KEY_ID=your_key_id \
     --from-literal=OSS_ACCESS_KEY_SECRET=your_key_secret \
     --from-literal=INVITE_CODE=your_invite_code \
     --from-literal=SECRET_KEY=your_secret_key \
     --from-literal=AUTHORIZED_EMAILS=user1@example.com,user2@example.com \
     -n devops

   # 部署应用
   kubectl apply -f manifests/
   ```

## 使用指南

### 1. 登录流程
1. 访问应用首页，自动跳转到登录页
2. 输入正确的邀请码
3. 登录成功后可进行文件上传
   - 注意：生产环境下session有效期为1小时
   - 如果更换IP需要重新登录
   - 登录失败3次后IP将被加入黑名单

### 2. 文件上传
1. 选择要上传的文件
2. 输入授权邮箱地址
3. 选择文件访问权限
   - 私有：生成1小时有效的签名URL
   - 公开读：生成永久访问URL
4. 点击上传按钮
5. 在弹窗中获取下载链接

上传流程说明：
- 文件上传前会验证邮箱地址是否在授权列表中
- 上传进度实时显示
- 支持大文件分块上传
- 上传完成后自动设置文件权限

### 3. 权限说明
- 私有文件
  - 下载链接1小时有效
  - 需要通过签名URL访问
  - 适合敏感文件
- 公开文件
  - 永久有效链接
  - 任何人都可以访问
  - 适合公开分享

## 目录结构
```
ossupload/
├── app.py              # 主应用程序
├── templates/          # HTML模板
│   ├── login.html     # 登录页面
│   ├── index.html     # 上传页面
│   └── coming-soon/   # 即将上线页面
│       └── index.html
├── static/            # 静态文件
├── manifests/         # K8s配置文件
│   ├── deployment.yaml
│   └── ingress.yaml
├── config.py          # 配置文件
└── requirements.txt   # Python依赖
```

## 环境变量说明

| 变量名 | 必需 | 说明 | 示例 |
|--------|------|------|------|
| OSS_ACCESS_KEY_ID | 是 | 阿里云访问密钥ID | LTAI4Gxxxx |
| OSS_ACCESS_KEY_SECRET | 是 | 阿里云访问密钥密码 | Hj2bxxxx |
| INVITE_CODE | 是 | 系统访问邀请码 | your-code |
| SECRET_KEY | 是(生产) | Flask session密钥 | random-string |
| FLASK_ENV | 否 | 环境标识(production/development) | production |
| MAX_FILE_SIZE | 否 | 最大文件上传大小（MB） | 100 |
| SESSION_TIMEOUT | 否 | Session超时时间（秒） | 3600 |
| URL_PREFIX | 否 | 应用URL前缀 | /ossupload |
| AUTHORIZED_EMAILS | 是 | 授权邮箱列表（逗号分隔） | user1@example.com,user2@example.com |

## 开发环境 vs 生产环境

| 特性 | 开发环境 | 生产环境 |
|------|----------|----------|
| Session时长 | 24小时 | 1小时 |
| Cookie安全 | 否 | 是 |
| IP绑定 | 否 | 是 |
| Referrer检查 | 否 | 是 |
| 安全头 | 否 | 是 |
| HTTPS | 可选 | 必需 |
| 密钥轮换 | 否 | 24小时自动轮换 |

## 常见问题

1. **上传失败**
   - 检查OSS配置是否正确
   - 确认文件大小是否超限
   - 验证bucket权限设置
   - 检查邮箱地址是否在授权列表中

2. **登录问题**
   - 确认邀请码正确性
   - 检查IP是否被加入黑名单
   - 确认session未过期
   - 检查IP地址是否变更

3. **下载链接失效**
   - 私有文件链接仅1小时有效
   - 检查文件是否已被删除
   - 确认OSS bucket状态

## 安全建议
1. 定期更换邀请码
2. 使用复杂的SECRET_KEY
3. 及时清理过期文件
4. 监控异常登录尝试
5. 定期检查访问日志
6. 定期更新授权邮箱列表
7. 生产环境启用所有安全头

## 部署安全建议

### SECRET_KEY 配置
必须在生产环境中设置强密钥：

## 贡献指南
欢迎提交PR或Issue！

## 许可证
MIT License
