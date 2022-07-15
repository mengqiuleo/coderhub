CREATE TABLE IF NOT EXISTS `user`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL UNIQUE,
	password VARCHAR(50) NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

# test
INSERT INTO user (name, password) VALUES ('zs',123456);


ALTER TABLE `user` ADD `avatar_url` VARCHAR(200);

CREATE TABLE IF NOT EXISTS `moment`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(1000) NOT NULL,
	user_id INT NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES user(id)
);

#test
SELECT
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id',u.id, 'name',u.name) author
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
WHERE m.id = 1;





CREATE TABLE IF NOT EXISTS `comment`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(1000) NOT NULL,
	moment_id INT NOT NULL,
	user_id INT NOT NULL,
	comment_id INT DEFAULT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY(moment_id) REFERENCES moment(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(comment_id) REFERENCES comment(id) ON DELETE CASCADE ON UPDATE CASCADE
);

#test
SELECT
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id',u.id, 'name',u.name) author,
	(SELECT COUNT(*) FROM comment c WHERE c.moment_id = m.id) commentCount,
	(SELECT COUNT(*) FROM moment_label ml WHERE ml.moment_id = m.id) labelCount
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LIMIT 0, 10;



#test1111
SELECT
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id',u.id, 'name',u.name) author,
	JSON_ARRAYAGG(
		JSON_OBJECT('id',c.id, 'content',c.content, 'commentId',c.comment_id, 'createTime', c.createAt,
								'user',JSON_OBJECT('id',cu.id,'name',cu.name))
	) comments,
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = 1
GROUP BY m.id;

#test2
SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id', u.id, 'name', u.name) author,
	IF(COUNT(l.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', l.id, 'name', l.name)
	),NULL) labels,
	(SELECT IF(COUNT(c.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id, 'createTime', c.createAt,
								'user', JSON_OBJECT('id', cu.id, 'name', cu.name))
	),NULL) FROM comment c LEFT JOIN user cu ON c.user_id = cu.id WHERE m.id = c.moment_id) comments
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = 1
GROUP BY m.id;




CREATE TABLE IF NOT EXISTS `label`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(10) NOT NULL UNIQUE,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `moment_label`(
	moment_id INT NOT NULL,
	label_id INT NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(moment_id, label_id),
	FOREIGN KEY (moment_id) REFERENCES moment(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (label_id) REFERENCES label(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `avatar`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	filename VARCHAR(255) NOT NULL UNIQUE,
	mimetype VARCHAR(30),
	size INT,
	user_id INT,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS `file`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	filename VARCHAR(100) NOT NULL UNIQUE,
	mimetype VARCHAR(30),
	size INT,
	moment_id INT,
	user_id INT,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (moment_id) REFERENCES moment(id) ON DELETE CASCADE ON UPDATE CASCADE
);


SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id', u.id, 'name', u.name) author,
	(SELECT COUNT(*) FROM comment c WHERE c.moment_id = m.id) commentCount,
	(SELECT COUNT(*) FROM moment_label ml WHERE ml.moment_id = m.id) labelCount,
	(SELECT JSON_ARRAYAGG(CONCAT('http://localhost:8000/moment/images/', file.filename)) 
	FROM file WHERE m.id = file.moment_id) images
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LIMIT 0, 10;


SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id', u.id, 'name', u.name, 'avatarUrl', u.avatar_url) author,
	IF(COUNT(l.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', l.id, 'name', l.name)
	),NULL) labels,
	(SELECT IF(COUNT(c.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id, 'createTime', c.createAt,
								'user', JSON_OBJECT('id', cu.id, 'name', cu.name, 'avatarUrl', cu.avatar_url))
	),NULL) FROM comment c LEFT JOIN user cu ON c.user_id = cu.id WHERE m.id = c.moment_id) comments,
	(SELECT JSON_ARRAYAGG(CONCAT('http://localhost:8000/moment/images/', file.filename)) 
	FROM file WHERE m.id = file.moment_id) images
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = 1
GROUP BY m.id;


SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id', u.id, 'name', u.name, 'avatarUrl', u.avatar_url) author,
	IF(COUNT(l.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', l.id, 'name', l.name)
	), NULL) labels,
	(SELECT IF(COUNT(c.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id, 'createTime', c.createAt,
								'user', JSON_OBJECT('id', cu.id, 'name', cu.name, 'avatarUrl', u.avatar_url))
	), NULL) FROM comment c LEFT JOIN user cu ON c.user_id = cu.id WHERE c.moment_id = m.id) comments,
	(SELECT JSON_ARRAYAGG(CONCAT('http://localhost:', '8888/moment/images/', filename)) 
					FROM file WHERE m.id = file.moment_id) images
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = 1
GROUP BY m.id;


SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	IF(COUNT(l.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', l.id, 'name', l.name)
	),NULL) labels
FROM moment m
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = 1
GROUP BY m.id, ml.moment_id

LEFT JOIN (SELECT DISTINCT id lid, name lname FROM label) l ON ml.label_id = lid


SELECT 
	m.id, m.content, m.comment_id commendId, m.createAt createTime,
	JSON_OBJECT('id', u.id, 'name', u.name)
FROM comment m
LEFT JOIN user u ON u.id = m.user_id
WHERE moment_id = 1;



SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id', u.id, 'name', u.name) user,
	IF(COUNT(l.id),JSON_ARRAYAGG(JSON_OBJECT('id', l.id, 'name', l.name)), NULL) labels,
	(SELECT COUNT(*) FROM comment WHERE comment.moment_id = m.id) commentCount,
	IF(COUNT(c.id),JSON_ARRAYAGG(
		JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id, 
								'user', JSON_OBJECT('id', cu.id, 'name', cu.name))), NULL) comments
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN comment c ON c.moment_id = m.id
LEFT JOIN user cu ON c.user_id = cu.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = 1
GROUP BY c.moment_id, m.id HAVING m.id = 1;


SELECT 
	m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
	JSON_OBJECT('id', u.id, 'name', u.name) user,
	(SELECT COUNT(*) FROM moment_label WHERE moment_label.moment_id = m.id) labelCount,
	(SELECT COUNT(*) FROM comment WHERE comment.moment_id = m.id) commentCount
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
GROUP BY m.id
LIMIT 0, 10;

INSERT INTO moment (content, user_id) VALUES ('��Ȼ�ٿ��������� �ҵ����� ʼ����һ', 1);
INSERT INTO moment (content, user_id) VALUES ('������ʱ����Ҳ�ã���Ҳ�ã�������һ�ı����ߡ������Ҳ������š����ǿ������ν����ҡ������硣���뽨��������ĳ��֮�ϲ��ܳ����ĵ��ӵĺ�ƽ���������������Σ������Ƕ�֮��ȴ�Ǵ���֮�ã�����ʱ�������Խ���׶񣬳��������������Ŀ���ĸ����ȥ�����綼���޷��ı�ġ����������������ν�ġ���ҡ������޷��ı�ġ����ǣ�������˵�Լ�ֻ������������', 1);
INSERT INTO moment (content, user_id) VALUES ('��Ҫ�������㲻��Ҫ��������Ҫ�������㲻��į��֪΢����ֻϣ���㣬���߹���ҹ���Ǹ�ʱ������Ҫ��ǿ��ѡ��һ���ˡ�', 3);
INSERT INTO moment (content, user_id) VALUES ('If you shed tears when you miss the sun, you also miss the stars.�������ʧȥ��̫�������ᣬ��ô��Ҳ��ʧȥȺ���ˡ�', 1);
INSERT INTO moment (content, user_id) VALUES ('�������������Ҷ��������㣬��Сʱ������������һ�����ӣ�ΰ��ʱ���������ڸ�ɽ�����', 2);
INSERT INTO moment (content, user_id) VALUES ('ĳһ�죬ͻȻ���֣����������·���޹ء�', 4);
INSERT INTO moment (content, user_id) VALUES ('�޶�Ŀ�ģ���ʹ������ü�ࡣ', 2);
INSERT INTO moment (content, user_id) VALUES ('�������ļ��ϣ�̫�ں����˶��ڷ������Ƶ�������������ɲ�����', 4);
INSERT INTO moment (content, user_id) VALUES ('һ��������ӵ��һ�����룬��һ������ȥ��ǿ������û����Ϣ�ĵط��������ﶼ�������ˡ�', 2);
INSERT INTO moment (content, user_id) VALUES ('�������ģ��������顣��η�����������������ˣ����á�', 3);
INSERT INTO moment (content, user_id) VALUES ('�������ҵģ���������˵���һ���ģ����ҾͲ�Ҫ�ˡ�', 3);
INSERT INTO moment (content, user_id) VALUES ('���µĿ�ͷ�����������ʷ���ᣬ⧲����������µĽ�������������������䣬���һ����', 2);
INSERT INTO moment (content, user_id) VALUES ('�㲻Ը���ֻ�����˵���Ҳ�Ը������һ�����䡣�ǵģ�Ϊ�˱���������������һ�п�ʼ��', 2);
INSERT INTO moment (content, user_id) VALUES ('�������ʶ��ǰ���ң�Ҳ�����ԭ�����ڵ��ҡ�', 4);
INSERT INTO moment (content, user_id) VALUES ('ÿһ��������������ӣ����Ƕ������Ĺ�����', 2);
INSERT INTO moment (content, user_id) VALUES ('����Եǳ���κ����', 2);
INSERT INTO moment (content, user_id) VALUES ('��֮���� �������� �������� һέ�Ժ�', 3);
INSERT INTO moment (content, user_id) VALUES ('�����Ļ�֮Ѥ�ã�������Ҷ֮������', 3);
INSERT INTO moment (content, user_id) VALUES ('�𰸺ܳ�����׼����һ����ʱ�����ش���׼��Ҫ������', 4);
INSERT INTO moment (content, user_id) VALUES ('��Ϊ���������Դȱ�����Ϊ���ã����Կ��ݡ�', 4);
INSERT INTO moment (content, user_id) VALUES ('�������������ĵ���ȴ�Ծɹ�������һ����', 1);
INSERT INTO moment (content, user_id) VALUES ('����������������ᣬ�����׹���ʱ��ֻ��ѡ���������ȥ��', 2);

