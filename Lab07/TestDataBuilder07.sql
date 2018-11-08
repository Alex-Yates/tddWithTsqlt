-- Lab 7: Testing a SELECT sproc
-- Adding TestDataBuild objects

create SCHEMA TestDataBuilder;
go

IF OBJECT_ID(N'[TestDataBuilder].[TestResultBuilder]', 'P') > 0
	DROP PROCEDURE [TestDataBuilder].[TestResultBuilder];
GO

CREATE PROCEDURE [TestDataBuilder].[TestResultBuilder]
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
        insert [Accelerator].[TestResults]
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
            = '[TestDataBuilder].[TestResultBuilder] ERROR: '
              + coalesce(error_message(), 'No Error Message');

        exec tSQLt.Fail @ErrorMessageOut;
    end catch;

    return (@ReturnValue);
end;
go