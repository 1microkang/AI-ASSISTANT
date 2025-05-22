-- ----------------------------
-- Mock data for t_admins
-- ----------------------------
INSERT INTO `t_admins` (`username`, `password`, `admin_name`, `status`, `create_time`, `update_time`)
VALUES ('super.admin', 'da4c189f916ae0b5aeb59389df4f0df0', 'SuperAdm', 1, '2023-01-15 09:00:00', '2023-01-15 09:00:00'),
       ('editor.user', 'da4c189f916ae0b5aeb59389df4f0df0', 'EditorUsr', 1, '2023-02-10 10:00:00',
        '2023-02-10 10:00:00'),
       ('viewer.role', 'da4c189f916ae0b5aeb59389df4f0df0', 'ViewerRol', 0, '2023-03-05 11:30:00',
        '2023-03-05 11:30:00'),
       ('data.analyst', 'da4c189f916ae0b5aeb59389df4f0df0', 'DataAnalyt', 1, '2023-04-20 14:15:00',
        '2023-04-20 14:15:00'),
       ('system.mgr', 'da4c189f916ae0b5aeb59389df4f0df0', 'SystemMgr', 1, '2023-05-25 16:45:00', '2023-05-25 16:45:00');

-- ----------------------------
-- Mock data for t_ai_intelligent
-- ----------------------------
INSERT INTO `t_ai_intelligent` (`input_message`, `ai_result`, `user_id`, `create_time`, `update_time`)
VALUES ('What is the current time?', 'The current time is [current time].', 201, '2023-06-01 08:30:00',
        '2023-06-01 08:30:05'),
       ('Recommend a fantasy novel.', 'I suggest "The Name of the Wind" by Patrick Rothfuss.', 202,
        '2023-06-02 09:45:00', '2023-06-02 09:45:10'),
       ('How to make a good cup of coffee?',
        'Use fresh beans, grind them just before brewing, and use filtered water at the correct temperature.', 203,
        '2023-06-03 10:15:00', '2023-06-03 10:15:30'),
       ('Explain the concept of photosynthesis.',
        'Photosynthesis is the process used by plants to convert light energy into chemical energy.', 204,
        '2023-06-04 11:00:00', '2023-06-04 11:00:20'),
       ('Tell me something interesting about space.', 'A day on Venus is longer than a year on Venus.', 205,
        '2023-06-05 12:20:00', '2023-06-05 12:20:15');

-- ----------------------------
-- Mock data for t_book_admins
-- ----------------------------
INSERT INTO `t_book_admins` (`username`, `password`, `book_admin_name`, `status`, `email`, `create_time`, `update_time`)
VALUES ('library.head', 'da4c189f916ae0b5aeb59389df4f0df0', 'Head Librarian', 1, 'head.librarian@example.com',
        '2023-01-20 09:00:00', '2023-01-20 09:00:00'),
       ('assistant.lib', 'da4c189f916ae0b5aeb59389df4f0df0', 'Assistant Lib', 1, 'assistant.lib@example.com',
        '2023-02-15 10:30:00', '2023-02-15 10:30:00'),
       ('catalog.mgr', 'da4c189f916ae0b5aeb59389df4f0df0', 'Catalog Manager', 0, 'catalog.mgr@example.com',
        '2023-03-10 11:45:00', '2023-03-10 11:45:00'),
       ('evening.staff', 'da4c189f916ae0b5aeb59389df4f0df0', 'Evening Staff', 1, 'evening.staff@example.com',
        '2023-04-05 17:00:00', '2023-04-05 17:00:00'),
       ('archive.spec', 'da4c189f916ae0b5aeb59389df4f0df0', 'Archive Specialist', 1, 'archive.spec@example.com',
        '2023-05-01 14:00:00', '2023-05-01 14:00:00');

-- ----------------------------
-- Mock data for t_book_rule
-- ----------------------------
INSERT INTO `t_book_rule` (`book_rule_id`, `book_days`, `book_limit_number`, `book_limit_library`, `book_overdue_fee`,
                           `create_time`, `update_time`)
VALUES (201, 30, 10, 'Main Library', 0.25, '2023-01-01 00:00:00', '2023-01-01 00:00:00'),
       (202, 14, 5, 'Branch Library North', 0.50, '2023-01-02 00:00:00', '2023-01-02 00:00:00'),
       (203, 7, 3, 'All Libraries', 1.00, '2023-01-03 00:00:00', '2023-01-03 00:00:00'),
       (204, 21, 7, 'Main Library', 0.30, '2023-01-04 00:00:00', '2023-01-04 00:00:00'),
       (205, 60, 15, 'Research Collection', 0.10, '2023-01-05 00:00:00', '2023-01-05 00:00:00');

-- ----------------------------
-- Mock data for t_book_type
-- ----------------------------
INSERT INTO `t_book_type` (`type_name`, `type_content`, `create_time`, `update_time`)
VALUES ('Science Fiction', 'Fiction based on imagined future scientific or technological advances.',
        '2023-02-01 10:00:00', '2023-02-01 10:00:00'),
       ('Historical Fiction', 'Fiction set in the past, often with historical figures or events.',
        '2023-02-02 10:00:00', '2023-02-02 10:00:00'),
       ('Philosophy',
        'Books exploring fundamental questions about existence, knowledge, values, reason, mind, and language.',
        '2023-02-03 10:00:00', '2023-02-03 10:00:00'),
       ('Programming', 'Books related to computer programming languages and software development.',
        '2023-02-04 10:00:00', '2023-02-04 10:00:00'),
       ('Young Adult', 'Fiction written for readers from 12 to 18 years of age.', '2023-02-05 10:00:00',
        '2023-02-05 10:00:00');

-- ----------------------------
-- Mock data for t_books
-- ----------------------------
INSERT INTO `t_books` (`book_number`, `book_name`, `book_author`, `book_library`, `book_type`, `book_location`,
                       `book_status`, `book_description`, `create_time`, `update_time`)
VALUES (20001, 'Dune', 'Frank Herbert', 'Main Library', 'Science Fiction', 'SF-A1-01', 'Available',
        'Epic science fiction novel set in the distant future.', '2023-03-01 11:00:00', '2023-03-01 11:00:00'),
       (20002, 'The Pillars of the Earth', 'Ken Follett', 'Branch Library North', 'Historical Fiction', 'HF-B2-03',
        'Borrowed', 'A historical novel about the building of a cathedral in medieval England.', '2023-03-02 11:00:00',
        '2023-03-15 14:30:00'),
       (20003, 'Meditations', 'Marcus Aurelius', 'Main Library', 'Philosophy', 'PH-C1-05', 'Available',
        'A series of personal writings by the Roman Emperor Marcus Aurelius.', '2023-03-03 11:00:00',
        '2023-03-03 11:00:00'),
       (20004, 'Python Crash Course', 'Eric Matthes', 'Tech Hub Library', 'Programming', 'PRG-D3-10', 'Available',
        'A hands-on, project-based introduction to programming.', '2023-03-04 11:00:00', '2023-03-04 11:00:00'),
       (20005, 'The Hunger Games', 'Suzanne Collins', 'Main Library', 'Young Adult', 'YA-E2-07', 'Borrowed',
        'A dystopian novel set in a post-apocalyptic nation.', '2023-03-05 11:00:00', '2023-03-20 10:00:00');

-- ----------------------------
-- Mock data for t_books_borrow
-- ----------------------------
INSERT INTO `t_books_borrow` (`card_number`, `book_number`, `borrow_date`, `close_date`, `return_date`, `create_time`,
                              `update_time`)
VALUES (98765432101, 20002, '2023-03-15 14:30:00', '2023-04-14 14:30:00', NULL, '2023-03-15 14:30:00',
        '2023-03-15 14:30:00'),
       (98765432102, 20005, '2023-03-20 10:00:00', '2023-04-03 10:00:00', NULL, '2023-03-20 10:00:00',
        '2023-03-20 10:00:00'),
       (98765432103, 20001, '2023-04-01 09:15:00', '2023-05-01 09:15:00', '2023-04-28 16:00:00', '2023-04-01 09:15:00',
        '2023-04-28 16:00:00'),
       (98765432104, 20003, '2023-04-10 11:30:00', '2023-05-01 11:30:00', NULL, '2023-04-10 11:30:00',
        '2023-04-10 11:30:00'),
       (98765432105, 20004, '2023-04-25 15:00:00', '2023-05-25 15:00:00', '2023-05-20 12:00:00', '2023-04-25 15:00:00',
        '2023-05-20 12:00:00');

-- ----------------------------
-- Mock data for t_chart
-- ----------------------------
INSERT INTO `t_chart` (`name`, `goal`, `chart_data`, `chart_type`, `gen_chart`, `gen_result`, `status`, `exec_message`,
                       `admin_id`, `create_time`, `update_time`, `isDelete`)
VALUES ('User Growth Q1', 'Analyze user registration trend for Q1', '{"Jan":50, "Feb":75, "Mar":120}', 'Bar Chart',
        '{"type":"bar","data":...}', 'Significant user growth observed in March.', 'succeed',
        'Chart generated successfully.', 1, '2023-04-05 10:00:00', '2023-04-05 10:05:00', 0),
       ('Book Genre Popularity', 'Identify most popular book genres', '{"Fiction":1500, "SciFi":800, "History":600}',
        'Pie Chart', '{"type":"pie","data":...}', 'Fiction is the most borrowed genre.', 'succeed',
        'Analysis complete.', 2, '2023-04-06 11:30:00', '2023-04-06 11:35:00', 0),
       ('Website Traffic Sources', 'Determine main sources of website traffic',
        '{"Organic":60, "Referral":25, "Direct":15}', 'Donut Chart', '{"type":"donut","data":...}',
        'Organic search drives most traffic.', 'succeed', 'Data processed.', 1, '2023-04-07 14:00:00',
        '2023-04-07 14:05:00', 0),
       ('Overdue Books Analysis', 'Track number of overdue books per month', '{"Jan":10, "Feb":12, "Mar":8, "Apr":15}',
        'Line Chart', '{"type":"line","data":...}', 'Overdue books peaked in April.', 'running', 'Processing data...',
        3, '2023-05-01 09:00:00', '2023-05-01 09:02:00', 0),
       ('AI Query Types', 'Categorize types of AI queries', '{"Information":70, "Translation":20, "Creative":10}',
        'Bar Chart', '{"type":"bar","data":...}', 'Most AI queries are informational.', 'failed',
        'Error in data aggregation.', 4, '2023-05-02 10:15:00', '2023-05-02 10:17:00', 0);

-- ----------------------------
-- Mock data for t_chat
-- ----------------------------
-- INSERT INTO `t_chat` (`from_id`, `to_id`, `text`, `chat_type`, `create_time`, `update_time`, `message_type`, `role`,
--                       `reply_message`)
-- VALUES (301, 302, 'Hello, how are you?', 1, '2023-07-01 10:00:00', '2023-07-01 10:00:00', 1, 1,
--         'I am fine, thank you!'),
--        (303, NULL, 'Team meeting at 3 PM today in conference room A.', 2, '2023-07-01 11:00:00', '2023-07-01 11:00:00',
--         1, 2, 'Acknowledged.'),
--        (302, 301, 'Can you help me with this book request?', 1, '2023-07-02 14:30:00', '2023-07-02 14:30:00', 1, 1,
--         'Sure, what is the book title?'),
--        (304, 305, 'Regarding the overdue notice for book #10005.', 1, '2023-07-03 09:15:00', '2023-07-03 09:15:00', 1,
--         2, 'Please return it by end of day.'),
--        (306, NULL, 'Library will be closed on Monday for a public holiday.', 2, '2023-07-04 16:00:00',
--         '2023-07-04 16:00:00', 1, 2, 'Noted.');

-- ----------------------------
-- Mock data for t_comment
-- ----------------------------
INSERT INTO `t_comment` (`comment_avatar`, `comment_barrage_style`, `comment_message`, `comment_time`, `create_time`,
                         `update_time`)
VALUES ('http://example.com/avatar1.png', 'top-scroll', 'Great lecture, very informative!', 10, '2023-08-01 10:00:00',
        '2023-08-01 10:00:00'),
       ('http://example.com/avatar2.png', 'fixed-bottom', 'Loved the new library interface!', 15, '2023-08-02 11:30:00',
        '2023-08-02 11:30:00'),
       ('http://example.com/avatar3.png', 'top-scroll', 'Can we have more books on AI?', 20, '2023-08-03 14:15:00',
        '2023-08-03 14:15:00'),
       ('http://example.com/avatar4.png', 'fixed-top', 'The online catalog is very easy to use.', 12,
        '2023-08-04 09:00:00', '2023-08-04 09:00:00'),
       ('http://example.com/avatar5.png', 'bottom-scroll', 'Excellent service from the librarians!', 18,
        '2023-08-05 16:45:00', '2023-08-05 16:45:00');

-- ----------------------------
-- Mock data for t_notice
-- ----------------------------
INSERT INTO `t_notice` (`notice_title`, `notice_content`, `notice_admin_id`, `create_time`, `update_time`)
VALUES ('System Maintenance Scheduled', 'The library system will be down for maintenance on Sunday from 2 AM to 4 AM.',
        1, '2023-09-01 09:00:00', '2023-09-01 09:00:00'),
       ('New Book Arrivals - September',
        'Check out the latest collection of books added this month. List available at the front desk.', 2,
        '2023-09-05 10:30:00', '2023-09-05 10:30:00'),
       ('Holiday Closure Announcement', 'The library will be closed on October 10th for a national holiday.', 1,
        '2023-09-15 14:00:00', '2023-09-15 14:00:00'),
       ('Extended Evening Hours', 'Starting next week, the library will be open until 9 PM on weekdays.', 3,
        '2023-09-20 11:00:00', '2023-09-20 11:00:00'),
       ('Call for Volunteers',
        'We are looking for volunteers for our upcoming book fair. Sign up at the circulation desk.', 2,
        '2023-09-25 16:20:00', '2023-09-25 16:20:00');

-- ----------------------------
-- Mock data for t_user_interface_info
-- ----------------------------
-- INSERT INTO `t_user_interface_info` (`user_id`, `interface_id`, `total_num`, `left_num`, `create_time`, `update_time`)
-- VALUES (201, 1, 100, 50, '2023-01-10 08:00:00', '2023-05-10 10:00:00'),
--        (202, 2, 50, 10, '2023-02-15 09:00:00', '2023-05-01 11:00:00'),
--        (1, 1, 1000, 950, '2023-01-01 00:00:00', '2023-05-12 14:00:00'),
--        (203, 1, 75, 25, '2023-03-20 10:00:00', '2023-04-30 15:00:00'),
--        (4, 2, 200, 180, '2023-04-01 11:00:00', '2023-05-05 16:00:00');

-- ----------------------------
-- Mock data for t_users
-- ----------------------------
INSERT INTO `t_users` (`username`, `password`, `card_name`, `card_number`, `rule_number`, `status`, `create_time`,
                       `update_time`)
VALUES ('john.reader', 'da4c189f916ae0b5aeb59389df4f0df0', 'John Reader', 98765432101, 201, 1, '2023-01-01 12:00:00',
        '2023-01-01 12:00:00'),
       ('jane.student', 'da4c189f916ae0b5aeb59389df4f0df0', 'Jane Student', 98765432102, 202, 1, '2023-01-15 13:00:00',
        '2023-01-15 13:00:00'),
       ('peter.prof', 'da4c189f916ae0b5aeb59389df4f0df0', 'Peter Prof', 98765432103, 203, 0, '2023-02-01 14:00:00',
        '2023-03-01 10:00:00'),
       ('susan.writer', 'da4c189f916ae0b5aeb59389df4f0df0', 'Susan Writer', 98765432104, 201, 1, '2023-02-20 15:00:00',
        '2023-02-20 15:00:00'),
       ('david.research', 'da4c189f916ae0b5aeb59389df4f0df0', 'David Research', 98765432105, 205, 1,
        '2023-03-10 16:00:00', '2023-03-10 16:00:00');

-- ----------------------------
-- Mock data for t_violation
-- ----------------------------
INSERT INTO `t_violation` (`card_number`, `book_number`, `borrow_date`, `close_date`, `return_date`,
                           `violation_message`, `violation_admin_id`, `create_time`, `update_time`)
VALUES (98765432101, 10002, '2023-02-01 10:00:00', '2023-03-01 10:00:00', '2023-03-05 10:00:00',
        'Book returned 4 days late.', 1, '2023-03-05 10:05:00', '2023-03-05 10:05:00'),
       (98765432103, 20001, '2023-01-10 11:00:00', '2023-02-10 11:00:00', '2023-02-20 11:00:00',
        'Book returned 10 days overdue, fine applied.', 2, '2023-02-20 11:05:00', '2023-02-20 11:05:00'),
       (98765432102, 10005, '2023-03-01 14:00:00', '2023-03-15 14:00:00', '2023-03-16 14:00:00',
        'Book returned 1 day late, warning issued.', 1, '2023-03-16 14:05:00', '2023-03-16 14:05:00'),
       (98765432105, 20004, '2023-04-01 09:30:00', '2023-04-15 09:30:00', NULL, 'Book not returned, overdue by 5 days.',
        3, '2023-04-20 09:35:00', '2023-04-20 09:35:00'),
       (98765432104, 10010, '2023-02-15 16:00:00', '2023-03-15 16:00:00', '2023-03-25 16:00:00',
        'Book returned 10 days late, damage reported.', 2, '2023-03-25 16:05:00', '2023-03-25 16:05:00');

SET
FOREIGN_KEY_CHECKS = 1;
