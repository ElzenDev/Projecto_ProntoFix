const app = require('./app');
const { port } = require('./config/env');
const db = require('./config/db');
async function start() {
    try{
        await db.query('SELECT 1');
        console.log('MySQL Turned on...');
        app.listen(port, ()=> console.log(`API running on http://localhost:${port}`))
    }
    catch(err){
        console.error('Error while running the sever:', err );
        process.exit(1);
    }
}
start();