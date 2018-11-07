create procedure Accelerator.InsertTestResult
(
    @Id int
  , @Date datetime2
  , @NumParticles int
  , @AverageX decimal(10, 2)
  , @AverageY decimal(10, 2)
  , @NumColours int
  , @HiggsBoson bit
)
as
begin

    insert Accelerator.TestResults
    (
        [Id]
	  , [Date]
      , [NumParticles]
      , [AverageX]
      , [AverageY]
      , [NumColours]
      , [HiggsBoson]
    )
    values
    (@Id, @Date, @NumParticles, @AverageX, @AverageY, @NumColours, @HiggsBoson);

    return;
end;