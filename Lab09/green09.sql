CREATE PROCEDURE Accelerator.RunTest

as

-- Maths
declare @Id int = coalesce ((select max(ID) from [Accelerator].[TestResults]) + 1, 666);
declare @date datetime2; set @date = getdate();
declare @numParticles int; set @numParticles = (select count(*) from [Accelerator].[Particle]);
declare @averageX decimal(10,2); set @averageX = (select AVG(X) from [Accelerator].[Particle]);
if @averageX is null
begin
set @averageX = 0
end
declare @averageY decimal(10,2); set @averageY = (select avg(Y) from [Accelerator].[Particle]);
if @averageY is null
begin
set @averageY = 0
end
declare @NumColors int; set @NumColors = (select Count (distinct ColorId) from [Accelerator].[Particle]);
declare @higgsBoson bit; set @higgsBoson = 0;

-- Let's see if we have a Higgs Boson! Those things are pretty rare...
declare @higgsBosonGenerator int; set @higgsBosonGenerator = (SELECT FLOOR(RAND()*(100-1+1))+1);
if @higgsBosonGenerator = 100
begin
set @higgsBoson = 1
end

-- Saving results
exec Accelerator.InsertTestResult @Id = @id                      
                                , @Date = @date 
                                , @NumParticles = @numParticles             
                                , @AverageX = @averageX             
                                , @AverageY = @averageY            
                                , @NumColours = @NumColors              
                                , @HiggsBoson = @higgsBoson           
   
go