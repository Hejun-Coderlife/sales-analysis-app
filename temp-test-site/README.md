# temp-test-site（同源会话联调）

本目录为**静态 HTML**，需由 `server.js` 通过 `express.static` 挂在 **`/frontend`** 下访问，才能与真实后端 **同源**（`fetch` 携带 `sales.sid` Cookie，并满足 `/api` 的 `Origin`/`Referer` 校验）。

## 服务端依据（对照仓库）

- 端口：`process.env.PORT` 或 **`3000`**（见 `server.js` 中 `const port = process.env.PORT || 3000`）。
- 静态目录：`app.use("/frontend", express.static(path.join(__dirname, "frontend"), …))`。
- 健康检查（无需登录）：**`GET /api/v2/health`** → JSON 形如 `{ ok: true, service: "analytics-v2", … }`（若设置 `DISABLE_V2_API=1`，整段 `/api/v2` 会返回 503，含 health）。
- 登录：**`POST /api/auth/login`**，JSON 体 **`{ "username": "…", "password": "…" }`**，成功时 `Set-Cookie: sales.sid=…`。
- 当前用户（需已登录）：**`GET /api/auth/me`**。

## 使用步骤

### 1. 启动真实后端（在「内容哈希」那份仓库里）

```bash
cd /path/to/sales-analysis-app-<hash>
npm install
npm start
```

默认日志会出现：`Server running at http://localhost:3000`（若设置了 `PORT` 则端口不同）。

### 2. 把本目录挂进该仓库的 `frontend/temp-test-site`

**推荐：符号链接**（本脚本在 `sales-analysis-app-main` 的 `temp-test-site` 内）：

```bash
cd /Users/hejun/Desktop/sales-analysis-app-main/temp-test-site
chmod +x ./link-into-frontend.sh
./link-into-frontend.sh /path/to/sales-analysis-app-<hash>/frontend
```

会在目标仓库生成：`…/frontend/temp-test-site` → 指向本目录。

**备选：复制整个目录**到 `…/frontend/temp-test-site`（无 symlink 时）。

### 3. 浏览器打开（请用 http，不要用 `file://`）

将 `PORT` 换成你实际启动的端口（默认 **3000**）：

- 冒烟页：**`http://localhost:PORT/frontend/temp-test-site/smoke.html`**
- 入口说明：**`http://localhost:PORT/frontend/temp-test-site/index.html`**

若服务端配置了 **`PUBLIC_BASE_URL`**，请用与之一致的 **主机名** 访问（否则带 `Origin` 的 `POST /api/*` 可能被拒绝并返回 `跨站请求被拒绝`）。

## 文件说明

| 文件 | 说明 |
|------|------|
| `smoke.html` | 同源请求 `/api/v2/health`、`POST /api/auth/login`、`GET /api/auth/me`，错误展示在页面上 |
| `index.html` | 简短说明与跳转链接 |
| `link-into-frontend.sh` | 将本目录链到任意仓库的 `frontend/temp-test-site` |
