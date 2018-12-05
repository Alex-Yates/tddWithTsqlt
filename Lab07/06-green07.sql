-- LAB 7: Testing a SELECT sproc
---------------------------------------------------------------------------------------------


create procedure Accelerator.GetTestResults
as
select Id
     , Date
     , NumParticles
     , AverageX
     , AverageY
     , NumColours
     , HiggsBoson
from Accelerator.TestResults;
go

---------------------------------------------------------------------------------------------

exec tSQLt.RunTestClass 'AcceleratorGetTestResults';
go
