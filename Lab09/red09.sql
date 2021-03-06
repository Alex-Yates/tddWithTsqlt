-- LAB 9: Testing a sproc that calls another sproc

---------------------------------------------------------------------------------------------

exec tSQLt.NewTestClass 'AcceleratorRunTest';
go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorRunTest].[test RunTest correctly calculates average X and Y values with three particles]
as
-- ASSEMBLE

exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec tSQLt.FakeTable @TableName = N'Particle'      -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec tSQLt.FakeTable @TableName = N'Color'         -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec [TestDataBuilder].[ColorBuilder];

exec [TestDataBuilder].[ParticleBuilder] @id = 1, @X = 2.0, @Y = 5.0;
exec [TestDataBuilder].[ParticleBuilder] @id = 2, @X = 2.5, @Y = 5.0;
exec [TestDataBuilder].[ParticleBuilder] @id = 3, @X = 3.0, @Y = 2.0;

declare @expectedX NVARCHAR(20);
set @expectedX = 2.50;
declare @expectedY NVARCHAR(20);
set @expectedY = 4.00;

exec tSQLt.SpyProcedure @ProcedureName = N'Accelerator.InsertTestResult';

-- ACT

exec Accelerator.RunTest

-- ASSERT

declare @actualX NVARCHAR(20);
set @actualX =
(
    select top (1) AverageX from Accelerator.InsertTestResult_SpyProcedureLog
);
declare @actualY NVARCHAR(20);
set @actualY =
(
    select top (1) AverageY from Accelerator.InsertTestResult_SpyProcedureLog
);

declare @Xmsg nvarchar(20);
set @Xmsg = N'Expected X value of 2.5 but was ' + @actualX;
declare @Ymsg nvarchar(200);
set @Ymsg = N'Expected Y value of 4.0 but was ' + @actualY;

if @expectedX <> @actualX
begin
    exec tSQLt.Fail @Message0 = @Xmsg;
end;
exec tSQLt.AssertEquals @Expected = @expectedY
                      , @Actual = @actualY
                      , @Message = @Ymsg;

go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorRunTest].[test RunTest correctly calculates num of colors if all colors present]
as

-- ASSEMBLE

exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec tSQLt.FakeTable @TableName = N'Particle'      -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec tSQLt.FakeTable @TableName = N'Color'         -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec [TestDataBuilder].[ColorBuilder] @id = 1, @ColorName = "Red";
exec [TestDataBuilder].[ColorBuilder] @id = 2, @ColorName = "White";
exec [TestDataBuilder].[ColorBuilder] @id = 3, @ColorName = "Blue";

exec [TestDataBuilder].[ParticleBuilder] @id = 1, @ColorId = 1;
exec [TestDataBuilder].[ParticleBuilder] @id = 2, @ColorId = 2;
exec [TestDataBuilder].[ParticleBuilder] @id = 3, @ColorId = 1;
exec [TestDataBuilder].[ParticleBuilder] @id = 4, @ColorId = 3;

declare @ExpectedNumColours int;
set @ExpectedNumColours = 3;

exec tSQLt.SpyProcedure @ProcedureName = N'Accelerator.InsertTestResult';

-- ACT

exec Accelerator.RunTest

-- ASSERT

declare @ActualNumColours int;
set @ActualNumColours =
(
    select top (1) NumColours from Accelerator.InsertTestResult_SpyProcedureLog
);

exec tSQLt.AssertEquals @Expected = @ExpectedNumColours
                      , @Actual = @ActualNumColours;

go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorRunTest].[test RunTest correctly calculates num of colors if not all colors present]
as

-- ASSEMBLE

exec tSQLt.FakeTable @TableName = N'TestResults'   -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec tSQLt.FakeTable @TableName = N'Particle'      -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec tSQLt.FakeTable @TableName = N'Color'         -- nvarchar(max)
                   , @SchemaName = N'Accelerator'; -- nvarchar(max)

exec [TestDataBuilder].[ColorBuilder] @id = 1, @ColorName = "Red";
exec [TestDataBuilder].[ColorBuilder] @id = 2, @ColorName = "White";
exec [TestDataBuilder].[ColorBuilder] @id = 3, @ColorName = "Blue";

exec [TestDataBuilder].[ParticleBuilder] @id = 1, @ColorId = 1;
exec [TestDataBuilder].[ParticleBuilder] @id = 3, @ColorId = 1;
exec [TestDataBuilder].[ParticleBuilder] @id = 4, @ColorId = 3;

declare @ExpectedNumColours int;
set @ExpectedNumColours = 2;

exec tSQLt.SpyProcedure @ProcedureName = N'Accelerator.InsertTestResult';

-- ACT

exec Accelerator.RunTest

-- ASSERT

declare @ActualNumColours int;
set @ActualNumColours =
(
    select top (1) NumColours from Accelerator.InsertTestResult_SpyProcedureLog
);

exec tSQLt.AssertEquals @Expected = @ExpectedNumColours
                      , @Actual = @ActualNumColours;

go



---------------------------------------------------------------------------------------------

-- exec tSQLt.RunTestClass 'AcceleratorRunTest'; GO

