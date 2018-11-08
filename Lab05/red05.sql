-- LAB 5: Testing a table structure
---------------------------------------------------------------------------------------------

exec tSQLt.NewTestClass @ClassName = N'AcceleratorTestResults'; -- nvarchar(max)
go

---------------------------------------------------------------------------------------------

create procedure [AcceleratorTestResults].[Test TestResults table exists]
as
exec tSQLt.AssertObjectExists 'Accelerator.TestResults';
go

---------------------------------------------------------------------------------------------

alter procedure [AcceleratorTestResults].[Test TestResults table has required cols]
as
if object_id(N'[AcceleratorTestResults].[Expected]') > 0
    drop table [AcceleratorTestResults].[Expected];
create table [AcceleratorTestResults].[Expected]
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

insert [AcceleratorTestResults].[Expected]
(
    [Id]
  , [NumParticles]
  , [AverageX]
  , [AverageY]
  , [NumColours]
  , [HiggsBoson]
)
values
(1, 1, 2.1, 3.5, 6, 0);

insert Accelerator.TestResults
(
    [id]
  , [NumParticles]
  , [AverageX]
  , [AverageY]
  , [NumColours]
  , [HiggsBoson]
)
values
(1, 5, 2.0, 3.2, 2, 1);
exec tSQLt.AssertResultSetsHaveSameMetaData 'SELECT * FROM [AcceleratorTestResults].[Expected]'
                                          , 'SELECT * FROM Accelerator.TestResults';

go

---------------------------------------------------------------------------------------------

exec tSQLt.RunTestClass 'AcceleratorTestResults';
go
