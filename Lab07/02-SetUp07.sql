-- LAB 7: Testing a SELECT sproc

---------------------------------------------------------------------------------------------

create procedure [AcceleratorGetTestResults].[SetUp]
as
if object_id('[AcceleratorGetTestResults].[expected]') is not null
    drop table [AcceleratorGetTestResults].[expected];
if object_id('[AcceleratorGetTestResults].[actual]') is not null
    drop table [AcceleratorGetTestResults].[actual];

create table [AcceleratorGetTestResults].[Expected]
(
    [Id] int not null primary key
  , [Date] datetime2 not null
        default getdate()
  , [NumParticles] int not null
  , [AverageX] decimal(10, 2) not null
  , [AverageY] decimal(10, 2) not null
  , [NumColours] int not null
  , [HiggsBoson] bit not null
);

create table [AcceleratorGetTestResults].[Actual]
(
    [Id] int not null primary key
  , [Date] datetime2 not null
        default getdate()
  , [NumParticles] int not null
  , [AverageX] decimal(10, 2) not null
  , [AverageY] decimal(10, 2) not null
  , [NumColours] int not null
  , [HiggsBoson] bit not null
);

exec tSQLt.FakeTable 'Accelerator.TestResults';
