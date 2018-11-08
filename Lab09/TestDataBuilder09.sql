-- Lab 9: Testing a sproc that calls another sproc
-- Adding TestDataBuild objects

if object_id(N'[TestDataBuilder].[ParticleBuilder]', 'P') > 0
    drop procedure [TestDataBuilder].[ParticleBuilder];
go

create procedure [TestDataBuilder].[ParticleBuilder]
(
    @Id int = 0
  , @X decimal(10, 2) = 0.0
  , @Y decimal(10, 2) = 0.0
  , @Value nvarchar(max) = ''
  , @ColorId int = NULL
  , @ErrorMessageOut nvarchar(2000) = '' out
)
as
begin

    if @ColorId is null
        set @ColorId =
    (
        select min(Id) from Accelerator.Color
    )   ;
    declare @ReturnValue int;
    set @ReturnValue = 0;

    begin try
        --!
        --! We assume that this table already exists at this point, probably
        --! created by [ExceptionReaderTests].[SetUp] which gets called by tSQLt
        --! automatically before each test in the ExceptionReaderTests class
        --!
        insert [Accelerator].[Particle]
        (
            Id
          , X
          , Y
          , Value
          , ColorId
        )
        values
        (@Id, @X, @Y, @Value, @ColorId);
    end try
    begin catch
        --!
        --! If we get any kind of exception, report back in a way that will cause tSQLt
        --! to fail whatever test this is with some useful information
        --!
        set @ReturnValue = error_number();
        set @ErrorMessageOut
            = '[TestDataBuilder].[ParticleBuilder] ERROR: ' + coalesce(error_message(), 'No Error Message');

        exec tSQLt.Fail @ErrorMessageOut;
    end catch;

    return (@ReturnValue);
end;
go

---------------------------------------------------------------------------------------------

if object_id(N'[TestDataBuilder].[ColorBuilder]', 'P') > 0
    drop procedure [TestDataBuilder].[ColorBuilder];
go

create procedure [TestDataBuilder].[ColorBuilder]
(
    @Id int = 0
  , @ColorName nvarchar(max) = "Blue"
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
        insert [Accelerator].[Color]
        (
            Id
          , ColorName
        )
        values
        (@Id, @ColorName);
    end try
    begin catch
        --!
        --! If we get any kind of exception, report back in a way that will cause tSQLt
        --! to fail whatever test this is with some useful information
        --!
        set @ReturnValue = error_number();
        set @ErrorMessageOut
            = '[TestDataBuilder].[ColorBuilder] ERROR: ' + coalesce(error_message(), 'No Error Message');

        exec tSQLt.Fail @ErrorMessageOut;
    end catch;

    return (@ReturnValue);
end;
go

