import { Pool } from 'pg';

const connection = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'valex',
  password: '1510',
  port: 5432
})


export default connection;