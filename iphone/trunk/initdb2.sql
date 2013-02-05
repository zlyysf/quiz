DROP TABLE IF EXISTS packageDef;
DROP TABLE IF EXISTS groupDef;
DROP TABLE IF EXISTS quizDef;
DROP TABLE IF EXISTS groupRun;
DROP TABLE IF EXISTS quizRun;
DROP TABLE IF EXISTS user;

CREATE TABLE packageDef (name TEXT PRIMARY KEY, seq INTEGER, locked INTEGER, price REAL);
CREATE TABLE groupDef (grpkey TEXT PRIMARY KEY, name TEXT, pkgkey TEXT, seqInPkg INTEGER, awardCoin INTEGER, awardScore INTEGER);
CREATE TABLE groupRun (grpkey TEXT PRIMARY KEY, locked INTEGER, passed INTEGER, gotScoreSum INTEGER, answerRightMax INTEGER);
CREATE TABLE quizDef (quizkey TEXT PRIMARY KEY, grpkey TEXT, pkgkey TEXT, questionWord TEXT, answerPic TEXT);
CREATE TABLE quizRun (quizkey TEXT PRIMARY KEY, haveAwardCoin INTEGER, haveAwardScore INTEGER);
CREATE TABLE user (name TEXT PRIMARY KEY, totalScore INTEGER, totalCoin INTEGER);

INSERT INTO packageDef (name, seq, locked, price) VALUES ('apparel t1',1,0,0);
INSERT INTO packageDef (name, seq, locked, price) VALUES ('shoe t2',2,0,0);

INSERT INTO groupDef (grpkey, name, pkgkey, seqInPkg, awardCoin, awardScore) VALUES ('apparel t1:group 1', 'group 1', 'apparel t1', 1, 1,100);
INSERT INTO groupDef (grpkey, name, pkgkey, seqInPkg, awardCoin, awardScore) VALUES ('apparel t1:group 2', 'group 2', 'apparel t1', 2, 1,100);
INSERT INTO groupDef (grpkey, name, pkgkey, seqInPkg, awardCoin, awardScore) VALUES ('shoe t2:group 1', 'group 1', 'shoe t2', 1, 1,100);
INSERT INTO groupDef (grpkey, name, pkgkey, seqInPkg, awardCoin, awardScore) VALUES ('shoe t2:group 2', 'group 2', 'shoe t2', 2, 1,100);

INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('apparel t1:7 For All Mankind', 'apparel t1:group 1', 'apparel t1',  '7 For All Mankind', 'apparel t1/group 1/7 For All Mankind.jpg');
INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('apparel t1:Abercrombie & Fitch', 'apparel t1:group 1', 'apparel t1',  '7Abercrombie & Fitch', 'apparel t1/group 1/Abercrombie & Fitch.jpg');

INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('apparel t1:Al Wissam', 'apparel t1:group 2', 'apparel t1',  'Al Wissam', 'apparel t1/group 2/Al Wissam.jpg');
INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('apparel t1:Alden', 'apparel t1:group 2', 'apparel t1',  'Alden', 'apparel t1/group 2/Alden.jpg');

INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('shoe t2:Arc''Teryx Salomon', 'shoe t2:group 1', 'shoe t2',  'Arc''Teryx Salomon', 'shoe t2/group 1/Arc''Teryx Salomon.jpg');
INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('shoe t2:Arthur Galan', 'shoe t2:group 1', 'shoe t2',  'Arthur Galan', 'shoe t2/group 1/Arthur Galan.jpg');

INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('shoe t2:Bearpaw', 'shoe t2:group 2', 'shoe t2',  'Bearpaw', 'shoe t2/group 2/Bearpaw.jpg');
INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('shoe t2:Beauty Express', 'shoe t2:group 2', 'shoe t2',  'Beauty Express', 'shoe t2/group 2/Beauty Express.jpg');

INSERT INTO user (name, totalScore, totalCoin) VALUES ('u1',0,0);