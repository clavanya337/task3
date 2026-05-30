Enter password: *******
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
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
5 rows in set (0.19 sec)

mysql> select * from Events;
+----------+-------------------------------+---------------------------------------+-------------+---------------------+---------------------+-----------+--------------+
| event_id | title                         | description                           | city        | start_date          | end_date            | status    | organizer_id |
+----------+-------------------------------+---------------------------------------+-------------+---------------------+---------------------+-----------+--------------+
|        1 | Tech Innovators Meetup        | A meetup for tech enthusiasts.        | New York    | 2025-06-10 10:00:00 | 2025-06-10 16:00:00 | upcoming  |            1 |
|        2 | AI & ML Conference            | Conference on AI and ML advancements. | Chicago     | 2025-05-15 09:00:00 | 2025-05-15 17:00:00 | completed |            3 |
|        3 | Frontend Development Bootcamp | Hands-on training on frontend tech.   | Los Angeles | 2025-07-01 10:00:00 | 2025-07-03 16:00:00 | upcoming  |            2 |
+----------+-------------------------------+---------------------------------------+-------------+---------------------+---------------------+-----------+--------------+
3 rows in set (0.02 sec)

mysql> select * from Session;
ERROR 1146 (42S02): Table 'train.session' doesn't exist
mysql> select * from Sessions;
+------------+----------+-------------------+---------------+---------------------+---------------------+
| session_id | event_id | title             | speaker_name  | start_time          | end_time            |
+------------+----------+-------------------+---------------+---------------------+---------------------+
|          1 |        1 | Opening Keynote   | Dr. Tech      | 2025-06-10 10:00:00 | 2025-06-10 11:00:00 |
|          2 |        1 | Future of Web Dev | Alice Johnson | 2025-06-10 11:15:00 | 2025-06-10 12:30:00 |
|          3 |        2 | AI in Healthcare  | Charlie Lee   | 2025-05-15 09:30:00 | 2025-05-15 11:00:00 |
|          4 |        3 | Intro to HTML5    | Bob Smith     | 2025-07-01 10:00:00 | 2025-07-01 12:00:00 |
+------------+----------+-------------------+---------------+---------------------+---------------------+
4 rows in set (0.00 sec)

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
5 rows in set (0.01 sec)

mysql> select * from Events
    -> ^C
mysql> -- 2. Show top rated events
mysql>
mysql> select e.title, avg(f.rating) as average_rating
    -> from events e
    -> join feedback f on e.event_id=f.event_id
    -> group by e.event_id
    -> order by average_rating desc;
+------------------------+----------------+
| title                  | average_rating |
+------------------------+----------------+
| AI & ML Conference     |         4.5000 |
| Tech Innovators Meetup |         3.0000 |
+------------------------+----------------+
2 rows in set (0.15 sec)

mysql> select e.title, avg(f.rating) as average_rating
    -> from events e
    -> join feedback f on e.event_id = f.event_id
    -> group by e.event_id,e.title
    -> HAVING COUNT (*)>=10
    -> order by average_rating desc;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '*)>=10
order by average_rating desc' at line 5
mysql> select e.title, avg(f.rating) as average_rating
    -> ^C
mysql> SELECT e.title, AVG(f.rating) AS avg_rating
    -> FROM Events e
    -> JOIN Feedback f ON e.event_id = f.event_id
    -> GROUP BY e.event_id, e.title
    -> HAVING COUNT(*) >= 10
    -> ORDER BY avg_rating DESC;
Empty set (0.01 sec)

mysql> select * from Users
    -> where User_id NOT in(
    -> select user_id from Registrations
    -> where registration_date = CURDATE()- interval 90 day
    -> );
+---------+---------------+---------------------+-------------+-------------------+
| user_id | full_name     | email               | city        | registration_date |
+---------+---------------+---------------------+-------------+-------------------+
|       1 | Alice Johnson | alice@example.com   | New York    | 2024-12-01        |
|       2 | Bob Smith     | bob@example.com     | Los Angeles | 2024-12-05        |
|       3 | Charlie Lee   | charlie@example.com | Chicago     | 2024-12-10        |
|       4 | Diana King    | diana@example.com   | New York    | 2025-01-15        |
|       5 | Ethan Hunt    | ethan@example.com   | Los Angeles | 2025-02-01        |
+---------+---------------+---------------------+-------------+-------------------+
5 rows in set (0.03 sec)

mysql> select e.title from Events
    -> ^C
mysql> select e.title , COUNT(*) as session_count
    -> from Session s
    -> ^C
mysql> select e.title ,COUNT(*) as total_sessions
    -> from event e
    -> join sesssion s on e.event_id = s.event_id
    -> where hour(s.start_time) between 10 and 12
    -> group by e.event_id;
ERROR 1146 (42S02): Table 'train.event' doesn't exist
mysql> select e.title, COUNT(*) as total_sessions
    -> from events e
    -> join sesssion s on e.event_id = s.event_id
    -> where hours(s.start_time) between 10 and 12
    -> group by e.event_id;
ERROR 1146 (42S02): Table 'train.sesssion' doesn't exist
mysql> select e.title, COUNT(*) as total_sessions
    ->     -> from events e
    ->     -> join sesssion s on e.event_id = s.event_id
    ->     -> where hours(s.start_time) between 10 and 12
    -> ^C -> group by e.event_id;
mysql> -- 4. Sessions between 10 AM and 12 PM
mysql>
mysql> select e.title, count(*) as total_sessions
    -> from events e
    -> join sessions s on e.event_id=s.event_id
    -> where hour(s.start_time) between 10 and 12
    -> group by e.event_id;
+-------------------------------+----------------+
| title                         | total_sessions |
+-------------------------------+----------------+
| Tech Innovators Meetup        |              2 |
| Frontend Development Bootcamp |              1 |
+-------------------------------+----------------+
2 rows in set (0.01 sec)

mysql> select u.city,count(*) as registraions
    -> from users u
    -> join registrations r on u.user_id = r.user_id
    -> group by u.city
    -> order by registrantions desc;
ERROR 1054 (42S22): Unknown column 'registrantions' in 'order clause'
mysql> select u.city,count(*) as registrations
    -> from users u
    -> join registrations r on u.user_id = r.user_id
    -> group by u.city
    -> order by registrations desc;
+-------------+---------------+
| city        | registrations |
+-------------+---------------+
| New York    |             2 |
| Los Angeles |             2 |
| Chicago     |             1 |
+-------------+---------------+
3 rows in set (0.05 sec)

mysql> select e.title,count(r.resource_id) as total_resources
    -> from events e
    -> left join resources r on e.event_id = r.event_id
    -> group bye.event_id;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'bye.event_id' at line 4
mysql> select e.title,count(r.resource_id) as total_resources
    -> from events e
    -> left join resources r on e.event_id = r.event_id
    -> group by e.event_id;
+-------------------------------+-----------------+
| title                         | total_resources |
+-------------------------------+-----------------+
| Tech Innovators Meetup        |               1 |
| AI & ML Conference            |               1 |
| Frontend Development Bootcamp |               1 |
+-------------------------------+-----------------+
3 rows in set (0.05 sec)

mysql> select u.full_name,e.title,f.rating,f.comments
    -> from feedback f
    -> join users u on f.user_id=u.user_id
    -> join events e on f.event_id = e.event_id
    -> where f.rating <3;
Empty set (0.01 sec)

mysql> select e.title,count(s.session_id) as session_count
    -> from events e
    -> left join sessions s
    -> on e.event_id = s.event_id
    -> where e.status = 'upcoming'
    -> group by e.event_id;
+-------------------------------+---------------+
| title                         | session_count |
+-------------------------------+---------------+
| Tech Innovators Meetup        |             2 |
| Frontend Development Bootcamp |             1 |
+-------------------------------+---------------+
2 rows in set (0.01 sec)

mysql> select u.full_name,count(e.event_id) as total_events
    -> from users u
    -> join events e
    -> on u.user_id = e.organizer_id
    -> group by u.user_id;
+---------------+--------------+
| full_name     | total_events |
+---------------+--------------+
| Alice Johnson |            1 |
| Bob Smith     |            1 |
| Charlie Lee   |            1 |
+---------------+--------------+
3 rows in set (0.01 sec)

mysql> select e.title from events e
    -> join registrations r on e.event_id = r.event_id
    -> left join feedback f on r.event_id = f.feedback_id
    -> where f.feedback_id is NULL;
Empty set (0.01 sec)

mysql> commit
    -> ;
Query OK, 0 rows affected (0.05 sec)

mysql>