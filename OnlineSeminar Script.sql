Use master

IF (Select Count(*) FROM sys.databases where name = 'OnlineSeminar' )>0
Begin 
      Drop database OnlineSeminar
END

  Create database OnlineSeminar

  Use OnlineSeminar
GO

/* 
  Create tables
  */

CREATE TABLE Host
		(HostID             int not null  identity(1,1),
		FirstName           varchar(25),
		LastName            varchar(25),
		MiddleName          varchar(25),
		Primary key (HostID)
		)


CREATE TABLE AddressType
		(AddressTypeID        int  identity(1,1),
		AddressType           varchar(10),
		BillingSameAsMailing  bit default 0,
		Active bit     default 0,
		CreateDate   datetime default getdate()
		Primary key (AddressTypeID)
		)

CREATE TABLE  [MembersAddress]
		(AddressID             int not null identity(1,1),
		AddressLine1          varchar(25),
		AddressLine2          varchar(25),
		City                  varchar(25),
		State                 varchar(25),
		Zip                   varchar(5),
		AddressTypeID         int not null ,
		Primary key  (AddressID),
CONSTRAINT fk_MembersAddress_AddressType foreign key (AddressTypeID) references AddressType (AddressTypeID)
		)

CREATE TABLE Members
       (MemberID       int   identity(1,1),
        FirstName      varchar(35),
        MiddleName     varchar(35),
        LastName       varchar(35),
        Gender         varchar(10),
        BirthDate      datetime,
        AddressID      int not null ,
		Primary key  (MemberID),
CONSTRAINT fk_Members_MembersAddress foreign key (AddressID) references MembersAddress (AddressID)
		)

CREATE TABLE PhoneType
		( PhoneTypeID      int not null identity(1,1),
		 [Name]            varchar(15),
		 Primary key (PhoneTypeID)
		)

CREATE TABLE   MembersPhoneNumber
		(PhoneNumberID            int not null identity(1,1),
		MemberID                 int not null,
		PhoneNumber              varchar(15),
		PhoneTypeID             int not null ,
		Primary key (PhoneNumberID),
CONSTRAINT fk_MembersPhoneNumber_PhoneType foreign key (PhoneTypeID) references PhoneType (PhoneTypeID),
CONSTRAINT fk_MembersPhoneNumber_Members foreign key (MemberID) references Members (MemberID)  
		)

CREATE TABLE   [MembersEmailAddress]
	   (EmailAddressID         int not null  identity(1,1),
		MemberID               int not null ,
		EmailAddress           varchar(25),
		Primary key (EmailAddressID),
CONSTRAINT fk_MembersEmailAddress_Members foreign key (MemberID) references Members (MemberID)
		)

CREATE TABLE MembersPassword
       (PasswordID int not null identity(1,1),
	    MemberID     int not null ,
	    PasswordHash  nvarchar(max),
		Salt         nvarchar(max),
	    ChangeDate   datetime,
	  
CONSTRAINT fk_MembersPassword_Members foreign key (MemberID) references Members (MemberID)
        )
CREATE TABLE   SubscriptionType
		(SubscriptionTypeID    int not null  identity(1,1),
		Subscription          varchar(25),
		Price                 money,
		RenewalAmt            money,
		Primary key (SubscriptionTypeID)
		)

CREATE TABLE   MembersSubscription
		(SubscriptionID          int not null   identity(1,1),
		MemberID                 int not null  ,
		SubscriptionTypeID        int not null   ,
		DateStarted              datetime,
		DateEnd                  datetime null,
		Active                  bit default 0,
		primary Key  ( SubscriptionID),
CONSTRAINT fk_MembersSubscription_Members foreign key (MemberID) references Members (MemberID) ,
CONSTRAINT fk_MembersSubscription_SubscriptionType foreign key (SubscriptionTypeID) references SubscriptionType (SubscriptionTypeID)                           
		)

CREATE TABLE    PaymentType
		(PaymentTypeID        int not null identity(1,1),
		TypeOfPayment        varchar(35),
		Primary key  (PaymentTypeID)
		)

CREATE TABLE   AccountCharges
		(ChargesID     int not null identity(1,1),
		MemberID            int not null ,
		PaymentTypeID       int not null  ,
		ChargeDate          DateTime default getdate(),
		SubscriptionTypeID  int not null,
		Amount              money,
		PostingDate         datetime,
		Primary key (ChargesID),
CONSTRAINT fk_AccountCharges_Members foreign key (MemberID) references Members (MemberID),
CONSTRAINT fk_AccountCharges_PaymentType foreign key (PaymentTypeID) references PaymentType (PaymentTypeID),
CONSTRAINT fk_AccountCharges_SubscriptionType foreign key (SubscriptionTypeID) references SubscriptionType (SubscriptionTypeID),

		)
				
CREATE TABLE   MembersCCType
		(CCTypeID         int not null  identity(1,1),
		CardName         varchar(35),
		Primary key (CCTypeID)
		) 

CREATE TABLE   MembersCCInformation
		(CCID                     int not null identity(1,1),
		MemberID                 int not null  ,
		CardNumber               varchar(30),
		CCTypeID               int not null  ,
		SecurityCode             int,
		ExpirationDate           datetime,
		Primary key (CCID),
CONSTRAINT MembersCCInformation_Members foreign key (MemberID) references Members (MemberID),
CONSTRAINT MembersCCInformation_MembersCCType foreign key (CCTypeID) references MembersCCType (CCTypeID)
		)

CREATE TABLE   MembersCCTransactions
		(TransactionID         int not null identity(1,1),
		CCID                  int  null ,
		MemberID              int not null,
		TransactionDate       datetime,
		TotalCharges          money,
		Results               varchar(25),
		Primary key (TransactionID),
CONSTRAINT fk_MembersCCTransactions_MembersCCInformation foreign key (CCID) references MembersCCInformation (CCID),
CONSTRAINT fk_MembersCCTransactions_Members foreign key (MemberID) references Members (MemberID)
		)

CREATE TABLE MembersNotes
	   (NoteID              int not null identity(1,1),
		MemberID       int not null ,
		Notes               varchar(max),
		Primary key (NoteID),
CONSTRAINT fk_MemberNotes_Members foreign key (MemberID) references Members (MemberID)
		)



CREATE TABLE MembersEvent
	   (EventID             int not null identity (1,1),
		EventDate           datetime,
		EventTitle          varchar(75),
		StatrtTime          datetime,
		EndTime             datetime,
		HostID              int not null ,
		Primary key (EventID),
CONSTRAINT fk_MembersEvent_Host foreign key (HostID) references Host (HostID)
       )

CREATE TABLE  EventAttendance
		(EventID              int not null, 
		MemberID              int not null ,
		Attendance            nvarchar(1),
		Comments              varchar(max),
		Rating                nvarchar(10),
CONSTRAINT fk_EventAttendance_MembersEvent foreign key (EventID) references MembersEvent (EventID),
CONSTRAINT fk_EventAttendance_Members foreign key (MemberID) references Members (MemberID)
		)
		


		/*  inserting data */


/*	INSERT INTO ADDRESSTYPE
*/
INSERT INTO AddressType
        ( [AddressType]) 
VALUES  ( 'Physical'), ('Shipping'), ('Billing')

/* INSER INTO MEMBERSADDRESS
*/
INSERT INTO MembersAddress
       ([AddressLine1],[City],[State],[Zip],[AddressTypeID])
VALUES ('020 New Castle Way',	'Port Washington',	'New York',	'11054',1),('8 Corry Parkway',	'Newton',	'Massachusetts',	'2458',2),
		('39426 Stone Corner Drive',	'Peoria',	'Illinois',	'61605',3),('921 Granby Junction',	'Oklahoma City',	'Oklahoma',	'73173',1),
		('77 Butternut Parkway',	'Saint Paul','	Minnesota',	'55146',1),('821 Ilene Drive',	'Odessa',	'Texas',	'79764',1),
		('1110 Johnson Court',	'Rochester',	'New York',	'14624',2),('6 Canary Hill',	'Tallahassee',	'Florida',	'32309',3),
		('9 Buhler Lane',	'Bismarck',	'North Dakota',	'58505',1),('99 Northwestern Pass',	'Midland',	'Texas',	'79710',2),
		('69 Spenser Hill',	'Provo',	'Utah','84605',3),('3234 Kings Court',	'Tacoma',	'Washington',	'98424',1),
		('3 Lakewood Gardens', 'Circle	Columbia',	'South Carolina',	'29225',1),('198 Muir Parkway',	'Fairfax',	'Virginia',	'22036',1),
		('258 Jenna Drive',	'Pensacola','Florida',	'32520',2)

/* INSERT INTO MEMBERS
*/
INSERT INTO Members
        ([FirstName],[LastName],[MiddleName],[Gender],[BirthDate],[AddressID])
VALUES  ('Otis',	'Brooke',	'Fallon',	'Male',	'6/29/1971',1), ('Katee',	'Virgie',	'Gepp',	'Female',	'4/3/1972',2),
		('Lilla',	'Charmion',	'Eatttok',	'Female',	'12/13/1975',3),('Ddene',	'Shelba',	'Clapperton',	'Female',	'2/19/1997',4),
		('Audrye',	'Agathe',	'Dawks',	'Female',	'2/7/1989',5),('Fredi',	'Melisandra',	'Burgyn',	'Female',	'5/31/1956',6),
		('Dimitri',	'Francisco',	'Bellino',	'Male',	'10/12/1976',7),('Enrico',	'Cleve',	'Seeney',	'Male',	'2/29/1988',8),
		('Marylinda',	'Jenine',	'O Siaghail',	'Female',	'2/6/1965',9),('Luce',	'Codi',	'Kovalski',	'Male',	'3/31/1978',10),
		('Claiborn',	'Shadow',	'Baldinotti',	'Male',	'12/26/1991',11),('Isabelle',	'Betty',	'Glossop',	'Female',	'2/17/1965',12),
		('Davina',	'Lira',	'Wither',	'Female',	'12/16/1957',13),('Panchito',	'Hashim',	'De Gregorio',	'Male',	'10/14/1964',14),
		('Rowen',	'Arvin',	'Birdfield',	'Male',	'1/9/1983',15)


/* INSERT INTO PHONETYPE
*/
INSERT INTO [dbo].[PhoneType]
	        ( [Name])
VALUES    ( 'Home'),('Office'), ('Cellphone')


/* INSERT INTO MEMBERSPHONENUMBER
*/
INSERT INTO MembersPhoneNumber
        ( [MemberID],[PhoneNumber],[PhoneTypeID])
VAlUES  (1 ,'818-873-3863', 3),(2,'503-689-8066',3),(3,'210-426-7426',2),(4,'716-674-1640', 3),(3,'05-415-9419',3),
		(4,'214-650-9837',1),(5,'937-971-1026',1),(6,'407-445-6895',3),(7,'206-484-6850',3),(8,'253-159-6773',1),
		(9,'253-141-4314',1),(10,'412-646-5145',2),(11,'404-495-3676',1),(12,'484-717-6750',3),(13,'915-299-3451',3)

/* INSERT INTO MEMBERSEMAILADDRESS
*/
INSERT INTO MembersEmailAddress
       ([MemberID],[EmailAddress])

VALUES	(1,'bfallon0@artisteer.com'),(2,'vgepp1@nih.gov'),(3,'ceatttok2@google.com.br'),(4,'sclapperton3@mapquest.com'),
		(5,'adawks4@mlb.com'),(6,'mburgyn5@cbslocal.com'),(7,'fbellino6@devhub.com'),(8,'cseeney7@macromedia.com'),
		(9,'josiaghail8@tuttocitta.it'),(10,'ckovalski9@facebook.com'),(11,'sbaldinottia@discuz.net'),(12,'bglossopb@msu.edu'),
		(13,'lwitherc@smugmug.com'),(14,'hdegregoriod@a8.net'),(15,'abirdfielde@over-blog.com')


/* INSERT INTO SUBSCRIPTIONTYPE
*/
INSERT INTO SubscriptionType
        ([Subscription],[Price],[RenewalAmt] )

VALUES  ('2 Year Plan',	$189, $80), ('1 Year Plan',	$99, $45 ),('Quarterly',	$27, $25 ),('Monthly',	$9.99, $15 )


/* INSERT INTO MEMBERSSUBSCRIPTION
*/
INSERT INTO MembersSubscription
        ([MemberID],[SubscriptionTypeID], [DateStarted], [DateEnd] )

VALUES  (1, 2,' 4/7/2017',  NULL), (2, 4, '11/29/2017', NULL),(3, 3, '2/26/17',	NULL),
		(4, 3, '11/5/2017',	NULL),(5, 4, '1/15/2016', NULL),  (6, 2, '3/13/2017',	NULL),
		(7, 4,  '8/9/2017',	NULL),(8, 2, '9/9/2016',	NULL),(9, 2, '11/21/2016',	NULL),
		(10, 4, '12/22/2017',	NULL),(11, 4, '3/19/2017',	NULL),(12, 3 , '4/25/2016',	NULL),
		(13, 2, '3/21/2016',	NULL),(14, 4, '1/27/2017',	NULL),(15, 4, '10/6/2017',	NULL)


/* INSERT INTO PAYMENTTYPE
*/
INSERT INTO PaymentType
        ([TypeOfPayment])
VALUES  ('Paypal'), ('CreditCard'), ('GiftCard')


/* INSERT INTO ACCOUNTCHARGES
*/
INSERT INTO AccountCharges
        ([MemberID], [PaymentTypeID], [ChargeDate],[SubscriptionTypeID] , [Amount],[PostingDate])
		VALUES ( 1, 2,  getdate(), 2, $99,GETDATE()) ,( 2, 2,  getdate(), 2, $99,GETDATE()) ,(3, 2, getdate(), 4, $9.99,GETDATE()),
		(4, 2, getdate(), 1, $189,GETDATE()) ,(5, 2, getdate(), 4, $9.99,GETDATE()) ,(6, 2, getdate(), 2, $99, GETDATE()) ,
		(7 , 2, getdate(), 2, $99, GETDATE()) ,(8, 2, getdate(), 2, $99, GETDATE()) ,(9, 2, getdate(), 2, $99, GETDATE()) ,
		(10,2, getdate(), 2, $99, GETDATE()) ,(11, 2, getdate(), 2, $9.99,GETDATE()),(12, 2, getdate(), 1, $189, GETDATE()),
		(13, 2, getdate(), 2, $99, GETDATE()) ,(14, 2, getdate(), 4, $9.99, GETDATE()) ,(15, 2, getdate(), 4, $9.99, GETDATE()) 


/* INSERT INTO MEMBERSCCTYPE
*/
INSERT INTO MembersCCType
        ([CardName])
VALUES  ('American Express'), ('Visa'), ('JCB'), ('Diners-Club-Carte-Blanche'), ('Master Card')


/* INSERT INTO MEMBERSCCINFORMATION
*/
INSERT INTO MembersCCInformation
        ([MemberID],[CardNumber],[CCTypeID],[SecurityCode],[ExpirationDate])
VALUES  (1,	337941553240515,	1,	515, '9/30/20'),(2,	4041372553875903,	2,  903, '1/30/19'),(3,	4041593962566,	    2,	566, '3/30/19'),
		(4,	3559478087149594,	3,	594, '4/30/19'),(5,	3571066026049076,	3,  766, '6/30/18'),(6,	304236527018794,	4,  879, '5/30/18'),
		(7, 3532950215393858,	3,	858, '2/28/19'),(8,	3569709859937370,	3,  370, '3/30/19'),(9,	3529188090740670,	3,	670, '5/30/19'),
		(10,3530142576111598,	3,	598, '11/30/19'),(11	,5108756299877313,  1,  313, '7/30/18'),(12, 3543168150106220,	3,	220, '6/30/18'),
		(13, 3559166521684728,	3,	728, '10/30/19'),(14, 30414677064054,	4,  544, '6/30/18'),(15, 3542828093985763,	4,	763, '4/30/20')


/* INSERT INTO MEMBERSCCTRANSACTION
*/
INSERT INTO MembersCCTransactions
        ( [MemberID],  [TransactionDate],[TotalCharges],[Results])
VALUES  (5, '01/15/2016','9.99','Approved'),(5, '02/15/2016','9.99','Approved'),(5, '03/15/2016','9.99','Approved'),(13, '03/21/2016','99','Approved'),
(5, '04/15/2016','9.99','Approved'),(13, '04/21/2016','99','Approved'),(12, '04/25/2016','27','Approved'),(5, '05/15/2016','9.99','Approved'),
(5, '06/15/2016','9.99','Approved'),(5, '07/15/2016','9.99','Approved'),(12, '07/25/2016','27','Approved'),(5, '08/15/2016','9.99','Approved'),
(8, '09/09/2016','99','Approved'),(5, '09/15/2016','9.99','Approved'),(5, '10/15/2016','9.99','Approved'),(12, '10/25/2016','27','Approved'),
(5, '11/15/2016','9.99','Approved'),(9, '11/21/2016','99','Approved'),(5, '12/15/2016','9.99','Approved'),(5, '01/15/2017','9.99','Approved'),
(12, '01/25/2017','27','Approved'),(14, '01/27/2017','9.99','Approved'),(5, '02/15/2017','9.99','Approved'),(3, '02/26/2017','27','Approved'),
(14, '02/27/2017','9.99','Approved'),(6, '03/13/2017','99','Approved'),(5, '03/15/2017','9.99','Approved'),(11, '03/19/2017','9.99','Approved'),
(14, '03/27/2017','9.99','Approved'),(1, '04/07/2017','9.99','Approved'),(5, '04/15/2017','9.99','Approved'),(11, '04/19/2017','9.99','Approved'),
(12, '04/25/2017','27','Approved'),(14, '04/27/2017','9.99','Approved'),(1, '05/07/2017','9.99','Approved'),(5, '05/15/2017','9.99','Approved'),
(11, '05/19/2017','9.99','Approved'),(3, '05/26/2017','27','Approved'),(14, '05/27/2017','9.99','Approved'),(1, '06/07/2017','9.99','Declined'),
(1, '06/08/2017','9.99','Approved'),(5, '06/15/2017','9.99','Approved'),(11, '06/19/2017','9.99','Approved'),(14, '06/27/2017','9.99','Approved'),
(1, '07/07/2017','9.99','Approved'),(5, '07/15/2017','9.99','Approved'),(11, '07/19/2017','9.99','Declined'),(11, '07/20/2017','9.99','Approved'),
(12, '07/25/2017','27','Approved'),(14, '07/27/2017','9.99','Approved'),(1, '08/07/2017','9.99','Approved'),(7, '08/09/2017','9.99','Approved'),
(5, '08/15/2017','9.99','Approved'),(11, '08/19/2017','9.99','Approved'),(3, '08/26/2017','27','Approved'),(14, '08/27/2017','9.99','Approved'),
(1, '09/07/2017','9.99','Approved'),(7, '09/09/2017','9.99','Approved'),(8, '09/09/2017','99','Approved'),(5, '09/15/2017','9.99','Approved'),
(11, '09/19/2017','9.99','Approved'),(14, '09/27/2017','9.99','Approved'),(15, '10/06/2017','9.99','Invalid Card'),(1, '10/07/2017','9.99','Approved'),
(7, '10/09/2017','9.99','Approved'),(5, '10/15/2017','9.99','Approved'),(11, '10/19/2017','9.99','Approved'),(12, '10/25/2017','27','Approved'),
(14, '10/27/2017','9.99','Approved'),(4, '11/05/2017','27','Approved'),(1, '11/07/2017','9.99','Approved'),(7, '11/09/2017','9.99','Approved'),
(5, '11/15/2017','9.99','Approved'),(11, '11/19/2017','9.99','Approved'),(3, '11/26/2017','27','Declined'),(3, '11/27/2017','27','Approved'),
(13, '11/27/2017','9.99','Approved'),(2, '11/29/2017','9.99','Approved'),(1, '12/07/2017','9.99','Approved'),(7, '12/09/2017','9.99','Approved'),
(5, '12/15/2017','9.99','Approved'),(11, '12/19/2017','9.99','Approved'),(10, '12/22/2017','9.99','Approved'),(14, '12/27/2017','9.99','Approved'),
(2, '12/29/2017','9.99','Approved'),(1, '01/07/2018','9.99','Approved'),(7, '01/09/2018','9.99','Approved'),(5, '01/15/2018','9.99','Approved'),
(11, '01/19/2018','9.99','Approved'),(10, '01/22/2018','9.99','Approved'),(12, '01/25/2018','27','Approved'),(14, '01/27/2018','9.99','Approved')


/* INSERT INTO MEMBERSNOTES
*/
INSERT INTO MembersNotes
         ([MemberID],[Notes])
VALUES   (1,'eiwjdeiojwneifewde'), (2, 'edjwiedcnoewjdow'),(3,'deicwqpsejdei edjiwei'),(4, 'fcreoicjwinwox'), (5,'cwoudhwqodhwuedc'),
         (6,'cwoeicnhweudxqow'), (7,'cewouxdqudxqo dqouwehd wkehd'), (8, 'dhwed dwieufc wiedo'), (9, 'cowedcnw woeufch'),(10, 'cejowdw'),
		 (11, 'fewo rciwecn'), (12, 'ediwe oweuhdwijed'), (13, 'cfeow rfcieucow'), (14, 'ewdxw cewieu'), (15, 'veve ncifowe')

/* INSERT INTO HOST
*/
 INSERT INTO Host
         ([FirstName],[LastName],[MiddleName])
VALUES   ('Tiffany', 'Watt', 'Smith'), ('Simon', 'Sinek', 'null'), ('Dan', 'Pink', 'null'), ('Elizabeth', 'Gilbert', 'null'),('Andree', 'Cameau', 'null')


/*  INSERT INTO MEMBERSEVENT
*/
INSERT INTO MembersEvent
         ( [EventDate],[EventTitle],[HostID])
VALUES   ('1/12/17', 'The History of Human Emotions',1), ('2/22/17', 'How great Leaders Insfire Action',2), ('3/5/2017', 'The Puzzle Of Motivation', 3), 
         ('4/16/17', 'Your Elusive Creative Genius', 4), ('5/1/17', 'Why Programmers So Smart', 5)

/* INSERT INTO EVENTATTENDANCE
*/
INSERT INTO EventAttendance
         ([EventID],[MemberID],[Attendance])
VALUES   (1,2,'X'),(1,3,'X'),(1,4,'X'),(1,5,'X'),(1,6,'X'),(1,8,'X'),(1,10,'X'),(1,11,'X'),(1,12,'X'),(1,13,'X'),(1,15,'X'),
         (2,3,'X'),(2,4,'X'),(2,5,'X'),(2,7,'X'),(2,8,'X'),(2,9,'X'),(2,10,'X'),(2,11,'X'),(2,12,'X'),(2,14,'X'),(2,15,'X'),
		 (3,1,'X'),(3,2,'X'),(3,3,'X'),(3,4,'X'),(3,5,'X'),(3,6,'X'),(3,7,'X'),(3,8,'X'),(3,9,'X'),(3,12,'X'),(3,14,'X'),(3,15,'X'),
		 (4,1,'X'),(4,2,'X'),(4,4,'X'),(4,5,'X'),(4,6,'X'),(4,7,'X'),(4,8,'X'),(4,9,'X'),(4,12,'X'),(4,14,'X'),(4,15,'X'),
		 (5,2,'X'),(5,4,'X'),(5,5,'X'),(5,13,'X'),(5,14,'X')


/* INSERT INTO MEMBERSPASSWORD
*/
--INSERT INTO MembersPassword
--         ( [MemberID],  [Password],[ChangeDate] )
--VALUES    (1,'hhrdtc', GETDATE()), (2,'12QWERT', GETDATE()),(3,'FMEOPW', GETDATE()),(4,'12QWERT', GETDATE()),(5,'CWE[P', GETDATE()),(6,'12QWERT', GETDATE()),
--(7,'POJUD', GETDATE()),(8,'12QWERT', GETDATE()),(9,'23NOI', GETDATE()),(10,'12QWERT', GETDATE()),
--(11,'KOEW98', GETDATE()),(12,'12QWERT', GETDATE()),(13,'CPOEFK9', GETDATE()),(14,'12QWERT', GETDATE()),(15,'CPEOR', GETDATE())



/* 1. SOLUTION
A view to get a list of members name complete address, phone and email address 
 */                
go
CREATE VIEW MembersContact
AS 
select CONCAT( m.FirstName,'   ',m.LastName) AS [Members Name],
       CONCAT( a.AddressLine1, '   ', a.City,', ', a.State,'  ', a.Zip) AS [Address],  p.PhoneNumber, ea.EmailAddress 
		from Members m
		inner join MembersAddress a
		on m.MemberID = a.AddressID
		inner join MembersPhoneNumber p
		on p.MemberID = m.MemberID
		inner join MembersEmailAddress ea
		on ea.MemberID = m.MemberID

--TEST
--SELECT * FROM [DBO].[MembersContact] 
GO



/* 2. SOLUTION
 Stored procedure to get a list of members and their email address
 ...........*/
                 
CREATE Procedure SPMembersEmailAddress

AS
BEGIN
      
         SELECT  Concat(FirstName,'  ', LastName )as [Name], ea.EmailAddress
		 FROM Members m
		 inner join MembersEmailAddress ea on m.MemberID = ea.MemberID
END
GO
--TEST
--EXECUTE SPmembersEmailAddress  



/* 3. SOLUTION
  TVF FUNCTION  TO FIND A LIST OF MEMBERS WHO HAS BIRTHDAY ON A SPECIFIC MONTH 
 */    

CREATE FUNCTION FnMembersBirthday
(
    @Birthdate datetime
)
RETURNS Table
AS
        RETURN
         SELECT CONCAT(FirstName, ' ', MiddleName) as [Name], CONVERT(VARCHAR(11),BirthDate) AS [Birthday]
		 FROM Members WHERE Month(BirthDate) = @Birthdate
--TEST
--SELECT * FROM  dbo.FNMembersBirthday(2)  



/*   #4 Solution   --NOT COMPLETE
*/
--	select * from MembersSubscription
--	select * from SubscriptionType


--select m.MemberID, Subscription, cast(DateStarted as date) as [Date Joined], Price, RenewalAmt
--from Members m
--inner join MembersSubscription ms
--on ms.MemberID = m.MemberID 
--inner join SubscriptionType st
--on st.SubscriptionTypeID = ms.SubscriptionTypeID
--where Active = 0 



 /* 5. SOLUTION --NOT TESTED
 */
GO
create procedure SpBillCreditCard
(  
    @CardNumber nvarchar(255)
    
)
AS
         --variables
	   DECLARE @CREDITCARD_EXPIRED int =1;
	   DECLARE @NO_ERROR int = 0;
	   DECLARE @GENERIC_ERROR int =555
	   DECLARE @MEmberID int
	   
BEGIN TRY 
	       IF EXISTS (SELECT CardNumber
		              FROM MembersCCInformation c inner join Members m
					  on m.MemberID = c.MemberID
					  WHERE C.ExpirationDate<= GEtdate()
					  AND CardNumber = @CardNumber)
	    BEGIN
	        RETURN @CREDITCARD_EXPIRED
	    END
	       
		    --BILLING CODE

	        RETURN @NO_ERROR;
END TRY
	BEGIN CATCH
	      IF @@Trancount>0
		      Rollback transaction;
			  return @GENERIC_ERROR;
	END CATCH



--/* 6. Solution  --not complete
--*/
--declare @2yearPlan money
--DEclare @1yearPlan money
--declare @Quarterly money
--declare @Monthly money
--set @2yearPlan = (select (price)/24 from SubscriptionType where SubscriptionTypeID =1 )
--set @1yearPlan = (select (Price)/12 from SubscriptionType where SubscriptionTypeID = 2)
--set @Quarterly = (select (price)/3 from SubscriptionType where SubscriptionTypeID = 3)
--set @Monthly = (select price  from SubscriptionType where SubscriptionTypeID = 4)
 
--select MemberID, s.SubscriptionTypeID, Subscription,  price, Price/24 as [monthly payment], DateStarted,
--         DATEADD(year,2, DateStarted) as [renewal date]
--from MembersSubscription m
--inner join SubscriptionType s
--on m.SubscriptionID = s.SubscriptionTypeID
--where s.SubscriptionTypeID =1




/* 7. Solution
	Function to get the count of new members sign up per Month.
*/
GO
 CREATE FUNCTION fnSignUp
 (   @From int,
	@To int
)
RETURNS TABLE
AS
return
        SELECT     count(DateStarted)AS [New Members Sign up] ,max(concat(datename (mm,DateStarted), '-', DATENAME(yyyy,DateStarted)))as [Date]
		FROM    MembersSubscription
		where MONTH(DateStarted) between @From and @To 
		group by  datename (mm,DateStarted), DATENAME(yyyy,DateStarted)
GO    
--TEST
--select *
--from dbo.fnSignUp(1,3)




/* 8. SOLUTION
  Function to count the members who attended per  events 
*/
GO
CREATE FUNCTION FNAttendanceCount
(
       @EventID int
)
RETURNS TABLE
AS
RETURN
		SELECT   max(EventTitle) as [Event Title], max(EventDate) as[Date],COUNT(MemberID) AS [Members Attended]
		FROM EventAttendance a INNER JOIN MembersEvent e ON a.EventID = e.EventID
		WHERE e.EventID = @EventID
--TEST
--SELECT * FROM dbo.FNAttendanceCount(1)


/* 9. SOLUTION 
  Stored procedure to store password secured
*/
GO
CREATE PROCEDURE dbo.SpSecurePaswd
    @MemberID int, 
    @Password NVARCHAR(50), 
    @ChangeDate datetime, 
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
	       DECLARE @salt UNIQUEIDENTIFIER=NEWID()

           INSERT INTO dbo.[MembersPassword] 
		            (MemberID, PasswordHash, Salt, ChangeDate)
           VALUES(@MemberID, HASHBYTES('MD4', @Password+CAST(@salt AS NVARCHAR(36))), @salt, @ChangeDate)

           SET @responseMessage='Created Succesfully'

    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
GO


--execute the stored procedure

DECLARE @responseMessage NVARCHAR(250)

Execute dbo.SpSecurePaswd
          @MemberID= 1,
          @Password= g23id,
          @ChangeDate =' 8/9/17',
          @responseMessage=@responseMessage OUTPUT

--Test 
--SELECT * 
--FROM MembersPassword

/* 10. SOLUTION
*/


/* 11. SOLUTION 
 */



/* 12.  SOLUTION
   Stored Procedure to verify password during login
*/
GO
CREATE PROCEDURE dbo.SpLoginAuthentication
    
	@EmailAddress NVARCHAR (MAX),
    @Password NVARCHAR(50),
    @responseMessage NVARCHAR(250)='' OUTPUT
AS
BEGIN

    DECLARE @MemberID INT

    IF EXISTS (SELECT TOP 1 MemberID FROM [dbo].[MembersEmailAddress] WHERE EmailAddress=@EmailAddress)
    BEGIN
       
	    SET @MemberID=(SELECT ea.MemberID FROM [dbo].[MembersEmailAddress] ea 
		inner join MembersPassword p ON ea.MemberID = p.MemberID
		WHERE EmailAddress=@EmailAddress 
		AND PasswordHash=HASHBYTES('SHA2_512', @Password+CAST(Salt AS NVARCHAR(36))))

       IF(@MemberID IS NULL)
           SET @responseMessage='Incorrect password'
       ELSE 
           SET @responseMessage='User successfully logged in'
		END
		ELSE
      
	   SET @responseMessage='Invalid login'

END
	
Go
	--test
DECLARE	@responseMessage nvarchar(250)

--Correct login and password
EXEC	dbo.SpLoginAuthentication
		@EmailAddress = N'Admin',
		@Password = N'123',
		@responseMessage = @responseMessage OUTPUT

SELECT	@responseMessage as N'@responseMessage'

--Incorrect login
EXEC	dbo.SpLoginAuthentication
		@EmailAddress = N'Admin1', 
		@Password = N'123',
		@responseMessage = @responseMessage OUTPUT

SELECT	@responseMessage as N'@responseMessage'

--Incorrect password
EXEC	dbo.SpLoginAuthentication
		@EmailAddress = N'Admin', 
		@Password = N'1234',
		@responseMessage = @responseMessage OUTPUT

SELECT	@responseMessage as N'@responseMessage'











