-----
supabase-storage
supabase/storage-api:v0.10.0

存储模块

Supabase Storage Middleware
A scalable, light-weight object storage service.

Read this post on why we decided to build a new object storage service.

Uses Postgres as it's datastore for storing metadata
Authorization rules are written as Postgres Row Level Security policies
Integrates with S3 as the storage backend (with more in the pipeline!)
Extremely lightweight and performant

------
supabase-meta
supabase/postgres-meta:v0.29.0  

权限管理API

postgres-meta
A RESTful API for managing your Postgres. Fetch tables, add roles, and run queries (and more).


------

supabase-rest
postgrest/postgrest:v9.0.1 

数据库Rest api

PostgREST serves a fully RESTful API from any existing PostgreSQL database. It provides a cleaner, more standards-compliant, faster API than you are likely to write from scratch.

--------

supabase/realtime
supabase-realtime

Listens to changes in a PostgreSQL Database and broadcasts them over WebSockets.

实时监听数据库编号




--------

supabase-auth   
supabase/gotrue:v2.10.0 

鉴权系统

GoTrue - User management for APIs
Coverage Status

GoTrue is a small open-source API written in golang, that can act as a self-standing API service for handling user registration and authentication for JAM projects.

It's based on OAuth2 and JWT and will handle user signup, authentication and custom user data.


--------


supabase-db
supabase/postgres:14.1.0.21

postgres 数据库 +定制加了很多插件

Postgres + goodies
Unmodified Postgres with some useful plugins. Our goal with this repo is not to modify Postgres, but to provide some of the most common extensions with a one-click install.




---------
supabase-studio
supabase/studio

后台管理系统


------

supabase-kong
kong

网关
------

