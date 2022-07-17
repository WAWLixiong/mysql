-- 等值查询间隙锁 ================================================
begin;
update m set d=d+1 where id = 7;


commit;
-- --------------------------------------------------
begin;
update t set d=d+1 where id = 7;


commit;
-- --------------------------------------------------
-- 等值查询间隙锁 ================================================

-- 非唯一索引等值锁 ================================================
begin;
select id from m where c = 5 lock in share mode;






commit;
-- --------------------------------------------------
begin;
select id from t where c = 5 lock in share mode;






commit;
-- 非唯一索引等值锁 ================================================
-- 主键索引范围锁 ================================================
begin;
select * from m where id>=10 and id<11 for update;



commit;
-- --------------------------------------------------
begin;
select * from t where id>=10 and id<11 for update;



commit;
-- 主键索引范围锁 ================================================
-- 非唯一索引范围锁 ================================================
begin;
select * from m where c >= 10 and c<11 for update;


commit;
-- --------------------------------------------------
begin;
select * from t where c >= 10 and c<11 for update;


commit;
-- 非唯一索引范围锁 ================================================
-- 唯一索引范围锁 bug ================================================
begin;
select * from m where id>10 and id<=15 for update;


commit;
-- --------------------------------------------------
begin;
select * from t where id>10 and id<=15 for update;


commit;
-- 唯一索引范围锁 bug ================================================
-- 非唯一索引上存在"等值"的例子 ================================================
insert into m values(30,10,30);
begin;
delete from m where c=10; -- 有 (5,10],(10,15)


commit;
-- --------------------------------------------------
insert into t values(30,10,30);
begin;
delete from t where c=10; -- 有 (5,10],(10,15)


commit;
-- 非唯一索引上存在"等值"的例子 ================================================
-- limit 语句加锁 ================================================
insert into m values(30,10,30);
begin;
delete from m where c=10 limit 2;

commit;
-- --------------------------------------------------
insert into t values(30,10,30);
begin;
delete from t where c=10 limit 2;

commit;
-- limit 语句加锁 ================================================
-- 死锁的例子 ================================================
begin;
select id from m where c=10 lock in share mode;

insert into m values(8, 8, 8);
commit;
-- --------------------------------------------------
begin;
select id from t where c=10 lock in share mode;

insert into t values(8, 8, 8); -- 间隙锁与插入的动作有冲突
commit;
-- 死锁的例子 ================================================
