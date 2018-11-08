-- LAB 08: Testing a where clause in a sproc

create procedure Accelerator.FoundHiggsBoson
(@returnValue bit = 0 out)
as
declare @numHiggsBosoms int;
set @numHiggsBosoms =
(
    select count(*) from Accelerator.TestResults where HiggsBoson = 1
);
if @numHiggsBosoms > 0
    set @returnValue = 1;
return @returnValue;
go

-----------------------------------------------------------------------------------

exec tSQLt.RunTestClass 'AcceleratorFoundHiggsBoson';
go
