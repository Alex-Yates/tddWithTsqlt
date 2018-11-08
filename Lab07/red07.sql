-- LAB 7: Testing a SELECT sproc
---------------------------------------------------------------------------------------------


create procedure [AcceleratorGetTestResults].[test proc GetTestResults correctly returns correct values]
as
begin

    --! Create a row that we can retrieve and store the expected result row in a single step.
    --! Still need to populate all columns with different values so we can test result set
    --! column order
    exec [AcceleratorGetTestResults].[Make_TestResult_ResultRowAndExpectedRow] @Id = 23
                                                                                  , @Date = '2018-01-01 00:00:00.000000'
                                                                                  , @NumParticles = 54
                                                                                  , @AverageX = 4.2
                                                                                  , @AverageY = 8.0
                                                                                  , @NumColours = 12
                                                                                  , @HiggsBoson = 1;

    --! Exercise (and record what the results actually look like)
    --! Take advantage of the fact that SQL Server is bright enough to
    --! skip the IDENTITY column on [actual] so we don't need a column list
    insert [AcceleratorGetTestResults].[actual]
    exec [Accelerator].[GetTestResults];
    declare @expectedRowCount int;
    set @expectedRowCount = 1;
    declare @actualRowCount int;
    set @actualRowCount =
    (
        select count(*) from [AcceleratorGetTestResults].[actual]
    );
    --! Assert
    exec tSQLt.AssertEquals @expectedRowCount
                          , @actualRowCount
                          , 'The number of rows returned is incorrect';
    exec tSQLt.AssertEqualsTable '[AcceleratorGetTestResults].[expected]'
                               , '[AcceleratorGetTestResults].[actual]'
                               , 'The column order in the result set is incorrect';
end;
---------------------------------------------------------------------------------------------

exec tSQLt.RunTestClass 'AcceleratorGetTestResults';
go
