import { ScanCommand } from '@aws-sdk/lib-dynamodb';
import type { Request, Response } from 'express';
import type { ApiResult } from '../../types/api-result';
import { DYNAMODB_TABLE, dbClient } from '../../data/dynamo-repository';


export default async function get(req: Request, res: Response) {
  let data: any = [];
  let lastEvaluatedKey;
  do {
    const cmd: ScanCommand = new ScanCommand({
      TableName: DYNAMODB_TABLE
    });
    const items = await dbClient.send(cmd);
    data.push(items.Items);
    lastEvaluatedKey = items.LastEvaluatedKey;
  } while (typeof lastEvaluatedKey !== 'undefined');

  const results: ApiResult = {
    valid: true,
    data
  };
  res.json(results);
};
