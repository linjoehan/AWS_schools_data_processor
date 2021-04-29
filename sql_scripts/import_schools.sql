insert into schools(
  natemis                      ,
  datayear                     ,
  province                     ,
  province_cd                  ,
  institution_name             ,
  status                       ,
  sector                       ,
  type_ped                     ,
  phase_ped                    ,
  specialization               ,
  owner_land                   ,
  owner_buildings              ,
  ex_dept                      ,
  paypoint_no                  ,
  component_no                 ,
  exam_no                      ,
  exam_center                  ,
  new_lat                      ,
  new_long                     ,
  gis_source                   ,
  district_municipality_name   ,
  local_municipality_name      ,
  ward_id                      ,
  sp_code                      ,
  sp_name                      ,
  ei_district                  ,
  ei_circuit                   ,
  addressee                    ,
  township_village             ,
  suburb                       ,
  town_city                    ,
  street_address               ,
  postal_address               ,
  telephone                    ,
  section_21                   ,
  section_21_function          ,
  quintile                     ,
  nas                          ,
  nodal_area                   ,
  registration_date            ,
  no_fee_school                ,
  allocation                   ,
  demarcation_from             ,
  demarcation_to               ,
  old_natemis                  ,
  new_natemis                  ,
  learners                     ,
  educators                    
)
values
%value_string%

on conflict (natemis) do update
set
datayear                    = excluded.datayear                   ,
province                    = excluded.province                   ,
province_cd                 = excluded.province_cd                ,
institution_name            = excluded.institution_name           ,
status                      = excluded.status                     ,
sector                      = excluded.sector                     ,
type_ped                    = excluded.type_ped                   ,
phase_ped                   = excluded.phase_ped                  ,
specialization              = excluded.specialization             ,
owner_land                  = excluded.owner_land                 ,
owner_buildings             = excluded.owner_buildings            ,
ex_dept                     = excluded.ex_dept                    ,
paypoint_no                 = excluded.paypoint_no                ,
component_no                = excluded.component_no               ,
exam_no                     = excluded.exam_no                    ,
exam_center                 = excluded.exam_center                ,
new_lat                     = excluded.new_lat                    ,
new_long                    = excluded.new_long                   ,
gis_source                  = excluded.gis_source                 ,
district_municipality_name  = excluded.district_municipality_name ,
local_municipality_name     = excluded.local_municipality_name    ,
ward_id                     = excluded.ward_id                    ,
sp_code                     = excluded.sp_code                    ,
sp_name                     = excluded.sp_name                    ,
ei_district                 = excluded.ei_district                ,
ei_circuit                  = excluded.ei_circuit                 ,
addressee                   = excluded.addressee                  ,
township_village            = excluded.township_village           ,
suburb                      = excluded.suburb                     ,
town_city                   = excluded.town_city                  ,
street_address              = excluded.street_address             ,
postal_address              = excluded.postal_address             ,
telephone                   = excluded.telephone                  ,
section_21                  = excluded.section_21                 ,
section_21_function         = excluded.section_21_function        ,
quintile                    = excluded.quintile                   ,
nas                         = excluded.nas                        ,
nodal_area                  = excluded.nodal_area                 ,
registration_date           = excluded.registration_date          ,
no_fee_school               = excluded.no_fee_school              ,
allocation                  = excluded.allocation                 ,
demarcation_from            = excluded.demarcation_from           ,
demarcation_to              = excluded.demarcation_to             ,
old_natemis                 = excluded.old_natemis                ,
new_natemis                 = excluded.new_natemis                ,
learners                    = excluded.learners                   ,
educators                   = excluded.educators                   
;