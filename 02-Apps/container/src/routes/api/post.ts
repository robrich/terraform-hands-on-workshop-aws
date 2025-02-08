import { PutCommand } from '@aws-sdk/lib-dynamodb';
import { Request, Response } from 'express';
import type { ApiResult } from '../../types/api-result';
import { DYNAMODB_TABLE, docClient } from '../../data/dynamo-repository';


export default async function post(req: Request, res: Response) {

  const id = req.params.id;
  if (!id) {
    const badResponse: ApiResult = {
      valid: false,
      data: 'Missing id in request params',
    };
    res.status(400).json(badResponse);
    return;
  }

  const data = req.body;
  data.pk = id.toString();
  data.sk = id.toString();

  const command = new PutCommand({
    TableName: DYNAMODB_TABLE,
    Item: data,
  });

  const response = await docClient.send(command);
  const valid = response.$metadata.httpStatusCode === 200 && !!data;

  const results: ApiResult = {
    valid,
    data
  };
  res.json(results);
}
