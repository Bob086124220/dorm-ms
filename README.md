# 高校公寓管理系统

## 一、项目介绍

本项目是一个基于传统 **SSM (Spring + Spring MVC + MyBatis)** 架构的高校公寓管理系统。系统采用分层架构设计，提供管理员、宿管、学生三种角色的权限控制，涵盖了楼栋管理、房间床位管理、入住调宿、报修、晚归及访客登记等核心业务模块。

**技术栈：**
- 后端：Spring + Spring MVC + MyBatis
- 数据库：MySQL (Druid连接池)
- 前端：JSP + JavaScript
- 项目管理：Maven

---

## 二、如何开发

### 2.1 配置文件配置

项目的配置文件位于 `src/main/resources` 目录下，开发前需完成以下配置：

1. **数据库连接配置**  
   复制`src/main/resources/config/jdbc.properties.example`到`jdbc.properties`，修改为本地数据库连接信息：
   
   ```properties
   jdbc.driver=com.mysql.cj.jdbc.Driver
   jdbc.url=jdbc:mysql://localhost:3306/dorm_ms?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
   jdbc.username=root
   jdbc.password=你的数据库密码
   ```
   
2. **数据源与持久层配置**  
   
   - `spring/spring-dao.xml`：已配置 Druid 数据源及 MyBatis `SqlSessionFactory`，会自动加载上述 `jdbc.properties`。
   - `mybatis/mybatis-config.xml`：MyBatis 全局配置。
   - `mapper/**/*.xml`：SQL映射文件存放目录。
   
3. **Service与事务配置**  
   - `spring/spring-service.xml`：已开启 `@Transactional` 注解驱动及 AOP 代理，Service 层方法可直接使用注解控制事务。

4. **Spring MVC与拦截器配置**  
   - `spring/spring-mvc.xml`：配置了 JSP 视图解析器（前缀 `/WEB-INF/jsp/`，后缀 `.jsp`）、Jackson日期格式及静态资源放行。
   - **拦截器**：已配置登录拦截（排除 `/login`, `/static/**` 等）及基于路径（`/admin/**`, `/dorm/**`, `/student/**`）的权限拦截器。

### 2.2 运行配置（Tomcat设置）

本项目为传统 Web 工程，需要配置 Tomcat 运行：

1. **添加本地 Tomcat**  
   在 IDEA 中通过 `Run/Debug Configurations` 添加本地 Tomcat Server（9.x版本）。

   中文页面：右上角编辑配置 -> 添加 -> tomcat服务器：本地 -> 选择tomcat路径
   
2. **部署 Artifact**  
   选择部署 `dorm-ms:war exploded`，并将 Application context 修改为`/dorm-ms`。

   中文页面：部署tab栏->应用程序上下文
   
3. **JDK 与端口**  
   确保 JDK 版本匹配（推荐 JDK 8+），配置 Tomcat HTTP 端口（默认 8080）。

4. **启动访问**  
   运行 Tomcat，根据 `web.xml` 中的欢迎页配置，访问 `http://localhost:8080/dorm-ms` 将自动跳转至 `login.jsp` 登录页。

---

## 三、如何测试

### 3.1 初始化数据库

1. **创建数据库和表结构**

   使用 `dormitory_management.sql` 创建数据库和所有表：

   ```bash
   mysql -u root -p < dormitory_management.sql
   ```

   或在 MySQL 客户端中执行：

   ```sql
   source /path/to/dormitory_management.sql;
   ```

2. **添加测试数据**

   使用 `test.sql` 插入测试数据（用户、楼栋、房间、床位等）：

   ```bash
   mysql -u root -p dormitory_management < test.sql
   ```

3. **清理数据（可选）**

   使用 `clear.sql` 清空所有业务数据（保留表结构）：

   ```bash
   mysql -u root -p dormitory_management < clear.sql
   ```

### 3.2 测试账号

| 角色 | 用户名      | 默认密码   | 说明 |
|------|----------|--------|------|
| 管理员 | admin  | 123456 | 系统管理员 |
| 宿管 | suguan1  | 123456 | 负责楼栋1 |
| 宿管 | suguan2  | 123456 | 负责楼栋2 |
| 学生 | 20220001 | 123456 | 测试学生1 |
| 学生 | 20220002 | 123456 | 测试学生2 |
| 学生 | 20220003 | 123456 | 测试学生3 |


### 3.3 测试流程建议

1. **基础功能测试**
   - 使用 admin 账号登录，测试用户管理、楼栋管理、房间管理、床位管理
   - 使用 suguan1 账号登录，测试入住办理、报修处理、晚归登记、访客登记
   - 使用 20220001 账号登录，测试查看个人信息、提交报修、查看晚归记录

2. **业务流程测试**
   - 入住流程：管理员创建学生 → 办理入住 → 学生查看住宿信息
   - 报修流程：学生提交报修 → 宿管接单 → 宿管完结 → 学生查看结果
   - 调宿流程：学生提交申请 → 管理员/宿管审批 → 查看床位变更
   - 访客流程：宿管录入访客 → 宿管确认离开

3. **权限隔离测试**
   - 学生访问 `/admin/**` 路径应返回403
   - 宿管访问 `/admin/**` 路径应返回403
   - 学生访问 `/dorm/**` 路径应返回403

---

## 四、其他项

### 3.1 项目结构
```text
src/main/java/com/huuc/dormitory
├── common          # 公共组件（统一返回结果、异常、AOP日志等）
├── controller      # 控制层（按角色划分为 admin, dorm, student）
├── dao             # MyBatis Mapper 接口
├── dto             # 数据传输对象
├── entity          # 数据库实体类
├── interceptor     # 权限与登录拦截器
├── service         # 业务逻辑层
└── vo              # 视图展示对象
```

### 3.2 核心业务模块
- **用户认证与权限**：基于 Session 和拦截器链实现角色隔离。
- **宿舍基础信息**：楼栋、房间、床位的树状结构管理。
- **入住与调宿**：支持入住、退宿、调宿申请与审批流。
- **日常运维**：报修处理、晚归登记、访客登记管理。
- **操作审计**：通过自定义 `@OperLog` 注解与 AOP 切面记录业务操作日志。

### 3.3 编码规范
开发时请遵循项目 `docs/规范-xxxx.md` 中的规定，重点关注：
- 分层调用约束（Controller -> Service -> DAO）。
- 异常处理规范（使用 `BusinessException`）。
- 禁止硬编码与魔法数字。