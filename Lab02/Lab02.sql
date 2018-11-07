-- LAB 2: Your first test
---------------------------------------------------------------------------------------

-- Create a new test class
EXEC tsqlt.NewTestClass @ClassName = N'IsTsqltInstalled' -- nvarchar(max)
GO

---------------------------------------------------------------------------------------

-- Create your first test
CREATE PROCEDURE [IsTsqltInstalled].[Test Assert 1 equals 1]

AS
    EXEC tsqlt.AssertEquals @Expected = 1, -- sql_variant
                            @Actual = 1,   -- sql_variant
                            @Message = N'Someone broke maths?'    -- nvarchar(max)
    
GO

---------------------------------------------------------------------------------------

-- Run your test
EXEC tsqlt.RunTestClass @TestClassName = N'IsTsqltInstalled'
GO
