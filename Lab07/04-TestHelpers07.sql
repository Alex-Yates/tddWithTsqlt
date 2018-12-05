-- LAB 7: Testing a SELECT sproc
---------------------------------------------------------------------------------------------

if object_id(N'[AcceleratorGetTestResults].[Make_TestResults_ExpectedRow]', 'P') > 0
    drop procedure [AcceleratorGetTestResults].[Make_TestResults_ExpectedRow];
go

create procedure [AcceleratorGetTestResults].[Make_TestResults_ExpectedRow]
(
    @Id int = 0
  , @Date datetime2 = '1900-01-01 00:00:00.000000'
  , @NumParticles int = 0
  , @AverageX decimal(10, 2) = 0.0
  , @AverageY decimal(10, 2) = 0.0
  , @NumColours int = 0
  , @HiggsBoson bit = 0
  , @ErrorMessageOut nvarchar(2000) = '' out
)
as
begin
    declare @ReturnValue int;
    set @ReturnValue = 0;

    begin try
        --!
        --! We assume that this table already exists at this point, probably
        --! created by [ExceptionReaderTests].[SetUp] which gets called by tSQLt
        --! automatically before each test in the ExceptionReaderTests class
        --!
        insert [AcceleratorGetTestResults].[Expected]
        (
            Id
          , Date
          , NumParticles
          , AverageX
          , AverageY
          , NumColours
          , HiggsBoson
        )
        values
        (@Id, @Date, @NumParticles, @AverageX, @AverageY, @NumColours, @HiggsBoson);
    end try
    begin catch
        --!
        --! If we get any kind of exception, report back in a way that will cause tSQLt
        --! to fail whatever test this is with some useful information
        --!
        set @ReturnValue = error_number();
        set @ErrorMessageOut
            = '[AcceleratorGetTestResults].[Make_TestResults_ResultRow] ERROR: '
              + coalesce(error_message(), 'No Error Message');

        exec tSQLt.Fail @ErrorMessageOut;
    end catch;

    return (@ReturnValue);
end;
go

---------------------------------------------------------------------------------------------

if object_id(N'[AcceleratorGetTestResults].[Make_TestResult_ResultRowAndExpectedRow]', 'P') > 0
    drop procedure [AcceleratorGetTestResults].[Make_TestResult_ResultRowAndExpectedRow];
go

create procedure [AcceleratorGetTestResults].[Make_TestResult_ResultRowAndExpectedRow]
(
    @Id int = 0
  , @Date datetime2 = '1900-01-01 00:00:00.000000'
  , @NumParticles int = 0
  , @AverageX decimal(10, 2) = 0.0
  , @AverageY decimal(10, 2) = 0.0
  , @NumColours int = 0
  , @HiggsBoson bit = 0
  , @ErrorMessageOut nvarchar(2000) = '' out
)
as
begin
    declare @ReturnValue int;
    set @ReturnValue = 0;

    begin try
        --!
        --! Start by creating an original Exception
        --!
        exec @ReturnValue = [TestDataBuilder].[TestResultBuilder] @Id = @Id
                                                                , @Date = @Date
                                                                , @NumParticles = @NumParticles
                                                                , @AverageX = @AverageX
                                                                , @AverageY = @AverageY
                                                                , @NumColours = @NumColours
                                                                , @HiggsBoson = @HiggsBoson
                                                                , @ErrorMessageOut = @ErrorMessageOut out;

        --!
        --! If the first step was successful, add the expected row
        --!
        if @ReturnValue = 0
            exec @ReturnValue = [AcceleratorGetTestResults].[Make_TestResults_ExpectedRow] @Id = @Id
                                                                                         , @Date = @Date
                                                                                         , @NumParticles = @NumParticles
                                                                                         , @AverageX = @AverageX
                                                                                         , @AverageY = @AverageY
                                                                                         , @NumColours = @NumColours
                                                                                         , @HiggsBoson = @HiggsBoson
                                                                                         , @ErrorMessageOut = @ErrorMessageOut out;
    end try
    begin catch
        --!
        --! If we get any kind of exception, report back in a way that will cause tSQLt
        --! to fail whatever test this is with some useful information
        --!
        set @ReturnValue = error_number();
        set @ErrorMessageOut
            = '[AcceleratorGetTestResults].[Make_TestResult_ResultRowAndExpectedRow] ERROR: '
              + coalesce(error_message(), 'No Error Message');

        exec tSQLt.Fail @ErrorMessageOut;
    end catch;

    --! Make sure all steps completed successfully
    if @ReturnValue > 0
        exec tSQLt.Fail @ErrorMessageOut;

    return (@ReturnValue);
end;
go
