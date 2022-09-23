use [master]
go

if object_id('tempdb.dbo.#ltResult', 'u') is not null
  drop table #ltResult
  
create table #ltResult
(
  [db] nvarchar(100) not null,
  [object_name] nvarchar(100) not null,
)

if object_id('tempdb.dbo.#ltDataBases', 'u') is not null
  drop table #ltDataBases
  
create table #ltDataBases
(
  [db_name] nvarchar(500) not null
)

set nocount on

--insert into #ltDataBases select 'Extro'
--insert into #ltDataBases select 'Extro_Config'

insert into #ltDataBases
select distinct 
  db.name
from 
  sys.databases db
where 
  db.state not in (6) -- not offline 
/*select 
  name
from 
  dbo.sysdatabases
where 
  name not in ('CallCenter', 'dba_tasks', 'HabraDW', 'SulpakSite', 'WEBSHOP_BAK', 'AlserMassSender')*/

set nocount off

declare
  @database_name nvarchar(50)

declare cur cursor --local fast_forward 
for 
  select 
    db.[db_name] 
  from 
    #ltDataBases db
open cur
fetch next from cur into @database_name
while @@FETCH_STATUS = 0 
begin 
  
  exec('
    -- print ''' + @database_name + '''
  
    insert into #ltResult
    select 
      r.ROUTINE_CATALOG,
      r.ROUTINE_NAME
    from
      [' + @database_name + '].information_schema.routines r
    where  
      --r.ROUTINE_TYPE in (''PROCEDURE'', ''FUNCTION'', ''TRIGGER'') and 
      r.ROUTINE_DEFINITION like ''%BasketOrdersAddInfo%''
  ')
 
 
  fetch next from cur into @database_name
                         
end 
close cur
deallocate cur

select 
  *
from
  #ltResult as lr with (nolock)
--where 
  --lr.db not in ('WEBSHOP_BAK')
order by 
  lr.[db],
  lr.[object_name]
  
  
-- UPDATED QUERY
/*
select o.name, o.type_desc 
from 
  sys.sql_modules as sm with(nolock)
  inner join sys.objects as o with(nolock) on o.[object_id] = sm.[object_id]
where 
  sm.definition like '%BasketOrders4SendSMS%'
order by
  2, 1
  
  */








  select 
      r.ROUTINE_CATALOG,
      r.ROUTINE_NAME,
	  r.ROUTINE_TYPE
    from
      [WebProject].information_schema.routines r
    where  
      --r.ROUTINE_TYPE in (''PROCEDURE'', ''FUNCTION'', ''TRIGGER'') and 
      r.ROUTINE_DEFINITION like '%BasketOrders4SendSMS%'




	  select * from DeliveryContactsInfo s (nolock) where s.DeliveryTimeEnd is not null




	  SELECT 
	                bo.SaleTypeId, 
	                u.UserRNN,
	                bo.DeliveryGuid, bo.RemainsMotionDocumentGuid,
                    bo.Id as BasketOrderId, dci.Surname, dci.FirstName, dci.SecondName, dci.BirthDay,
                    dci.IsMarried, dci.Sex, dci.AdditionalInfo, dci.PostCode, dci.Region, dci.City,
                    dci.District, dci.Street, dci.HouseNumber, dci.Corpus, dci.Building,
                    dci.FlatNumber, dci.RegionPrefix, dci.StreetPrefix, 
                    COALESCE(dci.Phone, bo.Phone) AS Phone, COALESCE(dci.Phone2, bo.Phone2) AS Phone2,
                    dci.Email, dci.Approach, dci.Intercom, dci.ApproachCode, dci.Floor, dci.Lift, dci.RNN,
                    dci.DeliveryDate, dci.DeliveryRangeId, dci.DeliveryTime, dci.DeliveryTimeEnd ,dci.Latitude, dci.Longitude , dci.DeliveryPoint
                FROM dbo.BasketOrders bo (NOLOCK) 
                LEFT JOIN dbo.Users u (NOLOCK)  ON u.UserId = bo.UserId
                LEFT JOIN dbo.DeliveryContactsInfo dci (NOLOCK) ON dci.BasketOrderId = bo.Id
                WHERE bo.Id = 7402262