create table [Accelerator].[TestResults]
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