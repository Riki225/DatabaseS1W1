USE RIKIDB;

DROP PROCEDURE MULTIPLY;
GO
CREATE PROCEDURE MULTIPLY
    @VAR1 INT = 2,
    @VAR2 INT = 3 AS
BEGIN
SELECT CONCAT('The product of ', @VAR1, ' and ',@VAR2);
END;

EXEC MULTIPLY;

DROP FUNCTION [ADD];

CREATE FUNCTION [ADD] (@VAR1 INT, @VAR2 INT) RETURNS NVARCHAR(30) AS
BEGIN
    RETURN @VAR1+@VAR2;
END;

BEGIN 
    DECLARE @VAR1 INT, @VAR2 INT;
    SET @VAR1 = 1;
    SET @VAR2 = 2;
    SELECT CONCAT('The sum of ', @VAR1, ' and ', @VAR2, ' is ', dbo.[ADD](@VAR1,@VAR2));
END;

/*Account(AcctNo, Fname, Lname, CreditLimit, Balance) 
Log(OrigAcct, LogDateTime, RecAcct, Amount) 
Foreign Key (OrigAcct) References Account (AcctNo) 
Foreign Key (RecAcct) References Account (AcctNo*/

CREATE TABLE Account(
    AcctNo INT,
    Fname NVARCHAR(30),
    Lname NVARCHAR(30),
    CreditLimit INT,
    Balance MONEY,
    PRIMARY KEY (AcctNo)
)

CREATE TABLE Log(
    OrigAcct INT,
    LogDateTime DATETIME,
    RecAcct INT,
    Amount MONEY,
    PRIMARY KEY (OrigAcct, LogDateTime),
    FOREIGN KEY (OrigAcct) REFERENCES Account (AcctNo),
    FOREIGN KEY (RecAcct) REFERENCES Account (AcctNo)
)

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'

INSERT INTO Account(AcctNo, Fname, Lname, CreditLimit, Balance) VALUES
(1, 'Riki', 'Choi', 50, 30),
(2, 'Daniel', 'Brass', 50, 25),
(3, 'Justin', 'Lam', 50, 20);

DROP TABLE Account;
DROP TABLE Log;

SELECT * FROM Account;

SELECT * FROM Log;

/*Write a stored procedure that takes 3 parameters, a from acct number, a to acct number and an 
amount.
The procedure should: 
a. Update the from account so its balance is reduced by the amount (note the check constaint 
on this will fail if the account doesn have enough credit / funds) 
b. Update the to account so its balance is increased by the amount 
c. Log the transfer by inserting the from account, to account, current datetime and amount 
into the log table.*/
GO
CREATE PROCEDURE BANK_TRANSACTION
    @FromAcctNo INT,
    @ToAcctNo INT,
    @Amount MONEY
AS
BEGIN
    UPDATE Account
    SET Balance = Balance - @Amount
    WHERE AcctNo = @FromAcctNo

    UPDATE Account
    SET Balance = Balance + @Amount
    WHERE AcctNo = @ToAcctNo

    INSERT INTO Log (OrigAcct, LogDateTime, RecAcct, Amount)
    VALUES (@FromAcctNo, SYSDATETIME(), @ToAcctNo, @Amount);
END;

DROP PROCEDURE BANK_TRANSACTION;

EXEC BANK_TRANSACTION @FromAcctNo = 1, @ToAcctNo = 3, @Amount = 10;

SELECT * FROM Account;
SELECT * FROM Log;