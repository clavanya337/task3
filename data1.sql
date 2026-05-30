Enter password: *******
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 18
Server version: 8.0.46 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show database;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'database' at line 1
mysql> use train;
Database changed
mysql> select * from Users;
+---------+---------------+---------------------+-------------+-------------------+
| user_id | full_name     | email               | city        | registration_date |
+---------+---------------+---------------------+-------------+-------------------+
|       1 | Alice Johnson | alice@example.com   | New York    | 2024-12-01        |
|       2 | Bob Smith     | bob@example.com     | Los Angeles | 2024-12-05        |
|       3 | Charlie Lee   | charlie@example.com | Chicago     | 2024-12-10        |
|       4 | Diana King    | diana@example.com   | New York    | 2025-01-15        |
|       5 | Ethan Hunt    | ethan@example.com   | Los Angeles | 2025-02-01        |
+---------+---------------+---------------------+-------------+-------------------+
5 rows in set (0.09 sec)

mysql> select * from Events;
+----------+-------------------------------+---------------------------------------+-------------+---------------------+---------------------+-----------+--------------+
| event_id | title                         | description                           | city        | start_date          | end_date            | status    | organizer_id |
+----------+-------------------------------+---------------------------------------+-------------+---------------------+---------------------+-----------+--------------+
|        1 | Tech Innovators Meetup        | A meetup for tech enthusiasts.        | New York    | 2025-06-10 10:00:00 | 2025-06-10 16:00:00 | upcoming  |            1 |
|        2 | AI & ML Conference            | Conference on AI and ML advancements. | Chicago     | 2025-05-15 09:00:00 | 2025-05-15 17:00:00 | completed |            3 |
|        3 | Frontend Development Bootcamp | Hands-on training on frontend tech.   | Los Angeles | 2025-07-01 10:00:00 | 2025-07-03 16:00:00 | upcoming  |            2 |
+----------+-------------------------------+---------------------------------------+-------------+---------------------+---------------------+-----------+--------------+
3 rows in set (0.01 sec)

mysql> select * from Sessions;
+------------+----------+-------------------+---------------+---------------------+---------------------+
| session_id | event_id | title             | speaker_name  | start_time          | end_time            |
+------------+----------+-------------------+---------------+---------------------+---------------------+
|          1 |        1 | Opening Keynote   | Dr. Tech      | 2025-06-10 10:00:00 | 2025-06-10 11:00:00 |
|          2 |        1 | Future of Web Dev | Alice Johnson | 2025-06-10 11:15:00 | 2025-06-10 12:30:00 |
|          3 |        2 | AI in Healthcare  | Charlie Lee   | 2025-05-15 09:30:00 | 2025-05-15 11:00:00 |
|          4 |        3 | Intro to HTML5    | Bob Smith     | 2025-07-01 10:00:00 | 2025-07-01 12:00:00 |
+------------+----------+-------------------+---------------+---------------------+---------------------+
4 rows in set (0.01 sec)

mysql> select * from Registrations;
+-----------------+---------+----------+-------------------+
| registration_id | user_id | event_id | registration_date |
+-----------------+---------+----------+-------------------+
|               1 |       1 |        1 | 2025-05-01        |
|               2 |       2 |        1 | 2025-05-02        |
|               3 |       3 |        2 | 2025-04-30        |
|               4 |       4 |        2 | 2025-04-28        |
|               5 |       5 |        3 | 2025-06-15        |
+-----------------+---------+----------+-------------------+
5 rows in set (0.00 sec)

mysql> select registration_date,count(*) as registration
    -> from registrations
    -> ^C
mysql> select registration_date,count(*) as total_users
    -> from Users
    -> group by registration_date;
+-------------------+-------------+
| registration_date | total_users |
+-------------------+-------------+
| 2024-12-01        |           1 |
| 2024-12-05        |           1 |
| 2024-12-10        |           1 |
| 2025-01-15        |           1 |
| 2025-02-01        |           1 |
+-------------------+-------------+
5 rows in set (0.04 sec)

mysql> select e.title,count(*) as Session
    -> from Events
    -> join Sessions on e.event_id = s.event_id
    -> group by e.event_id
    -> order by Session desc
    -> limit 1;
ERROR 1054 (42S22): Unknown column 'e.title' in 'field list'
mysql> select e.title,count(*) as Sessions
    -> from events e
    -> join sessions on e.event_id = s.event_id
    -> group by e.event_id
    -> order by Sessions desc
    -> limit 1;
ERROR 1054 (42S22): Unknown column 's.event_id' in 'on clause'
mysql> select e.title,count(*) as Sessions
    -> from events e
    -> join Sessions s on e.event_id = s.event_id
    -> group by e.event_id
    -> order by Sessions desc
    -> limit 1;
+------------------------+----------+
| title                  | Sessions |
+------------------------+----------+
| Tech Innovators Meetup |        2 |
+------------------------+----------+
1 row in set (0.03 sec)

mysql> select e.title from Events
    -> join Sessions s on e.event_id = s.event_id
    -> where^C
mysql> select e.title from events
    -> left join Sessions s on e.event_id = s.event_id
    -> where Session_id is NULL;
ERROR 1054 (42S22): Unknown column 'e.title' in 'field list'
mysql> select e.title from events
    -> ^C
mysql> select e.title from events e
    -> left join Sessions s on e.event_id = s.event_id
    -> where Session_id is NULL;
Empty set (0.02 sec)

mysql> select e.title,avg(timestamp(minute,start_time,end_time)) as time_dur
    -> from events e
    -> ^C
mysql> select e.title, avg(timestamp(minute,s.start_time,s.end_time)) as avg_dur
    -> from Events e
    -> join Sessions s on e.event_id = s.event_id
    -> group by e.event_id,e.title;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ',s.end_time)) as avg_dur
from Events e
join Sessions s on e.event_id = s.event_i' at line 1
mysql> select e.title, avg(timestampdiff(minute,s.start_time,s.end_time)) as avg_dur
    -> from Events e
    -> join Sessions s on e.event_id = s.event_id
    -> group by e.event_id,e.title;
+-------------------------------+----------+
| title                         | avg_dur  |
+-------------------------------+----------+
| Tech Innovators Meetup        |  67.5000 |
| AI & ML Conference            |  90.0000 |
| Frontend Development Bootcamp | 120.0000 |
+-------------------------------+----------+
3 rows in set (0.05 sec)

mysql> SELECT MONTH(registration_date) AS month,
    ->        COUNT(*) AS total_registrations
    -> FROM Registrations
    -> WHERE registration_date >= CURDATE() - INTERVAL 12 MONTH
    -> GROUP BY MONTH(registration_date)
    -> ORDER BY month;
+-------+---------------------+
| month | total_registrations |
+-------+---------------------+
|     6 |                   1 |
+-------+---------------------+
1 row in set (0.02 sec)

mysql> SELECT user_id,
    ->        event_id,
    ->        COUNT(*) AS duplicate_count
    -> FROM Registrations
    -> GROUP BY user_id, event_id
    -> HAVING COUNT(*) > 1;
Empty set (0.21 sec)

mysql>