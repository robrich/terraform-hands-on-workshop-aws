import 'dotenv/config';
import type { Request, Response, NextFunction } from 'express';
import type { ApiResult } from '../types/api-result';

export default function (err: Error, req: Request, res: Response, next: NextFunction) {
  if (!err) {
    next();
    return;
  }
  const error = err as Error;
  console.error(
    'GLOBAL ERROR: '+
    JSON.stringify({
      req: { url: req.url, method: req.method, body: req.body, query: req.query, params: req.params },
      err: { message: error.message, stack: error.stack },
    }, null, 2)
  );
  const result: ApiResult = {
    valid: false,
    data: 'global error: '+err.message, // TODO: don't leak secrets
  };
  res.status(500).send(JSON.stringify(result));
}
