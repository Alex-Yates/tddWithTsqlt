-- LAB 8: Testing a WHERE clause in a SELECT sproc

---------------------------------------------------------------------------------------------

exec tSQLt.NewTestClass 'AcceleratorFoundHiggsBoson';
go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorFoundHiggsBoson].[test FoundHiggsBoson correctly finds a higgs boson if there are two higgs bosons]
as
exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec [TestDataBuilder].[TestResultBuilder] @Id = 1, @HiggsBoson = 1;
exec [TestDataBuilder].[TestResultBuilder] @Id = 2, @HiggsBoson = 1;
exec [TestDataBuilder].[TestResultBuilder] @Id = 3, @HiggsBoson = 0;

declare @expected bit;
set @expected = 1;
declare @actual bit;
exec @actual = [Accelerator].[FoundHiggsBoson];

exec tSQLt.AssertEquals @Expected = @expected, @Actual = @actual;

go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorFoundHiggsBoson].[test FoundHiggsBoson correctly finds a higgs boson if there is only 1 higgs boson]
as
exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec [TestDataBuilder].[TestResultBuilder] @Id = 1, @HiggsBoson = 0;
exec [TestDataBuilder].[TestResultBuilder] @Id = 2, @HiggsBoson = 1;
exec [TestDataBuilder].[TestResultBuilder] @Id = 3, @HiggsBoson = 0;

declare @expected bit;
set @expected = 1;
declare @actual bit;
exec @actual = [Accelerator].[FoundHiggsBoson];

exec tSQLt.AssertEquals @Expected = @expected, @Actual = @actual;

go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorFoundHiggsBoson].[test FoundHiggsBoson correctly returns false if there are test results but no higgs bosons]
as
exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec [TestDataBuilder].[TestResultBuilder] @Id = 1, @HiggsBoson = 0;
exec [TestDataBuilder].[TestResultBuilder] @Id = 2, @HiggsBoson = 0;
exec [TestDataBuilder].[TestResultBuilder] @Id = 3, @HiggsBoson = 0;

declare @expected bit;
set @expected = 0;
declare @actual bit;
exec @actual = [Accelerator].[FoundHiggsBoson];

exec tSQLt.AssertEquals @Expected = @expected, @Actual = @actual;

go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorFoundHiggsBoson].[test FoundHiggsBoson correctly returns false if TestResults is empty]
as
exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)


declare @expected bit;
set @expected = 0;
declare @actual bit;
exec @actual = [Accelerator].[FoundHiggsBoson];

exec tSQLt.AssertEquals @Expected = @expected, @Actual = @actual;

go


---------------------------------------------------------------------------------------------

exec tSQLt.RunTestClass 'AcceleratorFoundHiggsBoson';
go
