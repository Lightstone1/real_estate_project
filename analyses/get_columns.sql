select
    table_name,
    column_name,
    data_type,
    is_nullable
from real_estate_raw_db.information_schema.columns
where table_schema = 'REAL_ESTATE'
  and table_name in (
    'ACCM_COMPLETION_UPDATE','AGENCIES','AGENTS','CITIES','CLIENTS',
    'PAYMENT_DETAILS','PROPERTIES','PROPERTY_TYPES','REGIONS','TRANSACTIONS'
  )
order by table_name, ordinal_position