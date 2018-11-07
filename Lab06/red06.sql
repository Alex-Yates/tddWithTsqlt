-- LAB 2: Testing a table structure
---------------------------------------------------------------------------------------------

exec tSQLt.NewTestClass @ClassName = N'AcceleratorInsertTestResult'; -- nvarchar(max)
go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorInsertTestResult].[Test InsertTestResult inserts a row of test data correctly]
as

-- ASSEMBLE
if object_id('[AcceleratorInsertTestResult].[expected]') is not null
    drop table [AcceleratorInsertTestResult].[expected];
if object_id('[AcceleratorInsertTestResult].[actual]') is not null
    drop table [AcceleratorInsertTestResult].[actual];
exec tSQLt.FakeTable 'Accelerator.TestResults';


declare @Id           int            = 1
      , @Date         datetime2      = getdate()
      , @NumParticles int            = 2
      , @AverageX     decimal(10, 2) = 2.3
      , @AverageY     decimal(10, 2) = 4.1
      , @NumColours   int            = 5
      , @HiggsBoson   bit            = 1;

select @Id           as [Id]
     , @Date         as [Date]
     , @NumParticles as [NumParticles]
     , @AverageX     as [AverageX]
     , @AverageY     as [AverageY]
     , @NumColours   as [NumColours]
     , @HiggsBoson   as [HiggsBoson]
into [AcceleratorInsertTestResult].[expected];


-- ACT
exec Accelerator.InsertTestResult @Id = @Id
                                , @Date = @Date
                                , @NumParticles = @NumParticles
                                , @AverageX = @AverageX
                                , @AverageY = @AverageY
                                , @NumColours = @NumColours
                                , @HiggsBoson = @HiggsBoson;

-- ASSERT

select top 1
       [Id]
     , [Date]
     , [NumParticles]
     , [AverageX]
     , [AverageY]
     , [NumColours]
     , [HiggsBoson]
into [AcceleratorInsertTestResult].[actual]
from Accelerator.TestResults;

exec tSQLt.AssertEqualsTable '[AcceleratorInsertTestResult].[expected]'
                           , '[AcceleratorInsertTestResult].[actual]';


go

---------------------------------------------------------------------------------------------

exec tSQLt.RunTestClass 'AcceleratorInsertTestResult';
go
