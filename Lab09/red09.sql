-- LAB 9: Testing a sproc that calls another sproc

---------------------------------------------------------------------------------------------

exec tSQLt.NewTestClass 'AcceleratorRunTest';
go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorRunTest].[test RunTest correctly calculates average X and Y values with three particles]
as
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

declare @expectedX decimal(10, 2);
set @expectedX = 2.5;
declare @expectedY decimal(10, 2);
set @expectedY = 4.0;

exec tSQLt.SpyProcedure @ProcedureName = N'Accelerator.RunTest';

declare @actualX decimal(10, 2);
set @actualX =
(
    select top (1) X from Accelerator.RunTest_SpyProcedureLog
);
declare @actualY decimal(10, 2);
set @actualY =
(
    select top (1) Y from Accelerator.RunTest_SpyProcedureLog
);

declare @Xmsg nvarchar(200);
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

declare @ExpectedNumColors int;
set @ExpectedNumColors = 3;

exec tSQLt.SpyProcedure @ProcedureName = N'Accelerator.RunTest';

declare @ActualNumColors int;
set @ActualNumColors =
(
    select top (1) NumColors from Accelerator.RunTest_SpyProcedureLog
);

exec tSQLt.AssertEquals @Expected = @ExpectedNumColors
                      , @Actual = @ActualNumColors;

go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorRunTest].[test RunTest correctly calculates num of colors if not all colors present]
as
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

declare @ExpectedNumColors int;
set @ExpectedNumColors = 2;

exec tSQLt.SpyProcedure @ProcedureName = N'Accelerator.RunTest';

declare @ActualNumColors int;
set @ActualNumColors =
(
    select top (1) NumColors from Accelerator.RunTest_SpyProcedureLog
);

exec tSQLt.AssertEquals @Expected = @ExpectedNumColors
                      , @Actual = @ActualNumColors;

go



---------------------------------------------------------------------------------------------

-- exec tSQLt.RunTestClass 'AcceleratorRunTest'; GO

