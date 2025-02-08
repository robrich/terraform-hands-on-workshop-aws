import 'dotenv/config';
import express from 'express';
import morgan from 'morgan';
import { json } from 'body-parser';
import homeRouter from './routes/home/router';
import apiRouter from './routes/api/router';
import errorHandler from './middlewares/error-handler';

let port = parseInt(process.env.NODE_PORT ?? '', 10);
if (!port || isNaN(port)) {
  port = 3000;
}

const app = express();

app.use(morgan('dev'));
app.use(json());

app.use('/', homeRouter);
app.use('/api', apiRouter);
app.use(errorHandler);

app.listen(port, () => {
  console.log(`Server is running at http://+:${port}`);
});
