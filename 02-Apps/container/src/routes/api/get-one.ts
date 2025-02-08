import {  GetCommand } from '@aws-sdk/lib-dynamodb';
import { Request, Response } from 'express';
import type { ApiResult } from '../../types/api-result';
import { DYNAMODB_TABLE, docClient } from '../../data/dynamo-repository';


export default async function getOne(req: Request, res: Response) {

  const id = req.params.id;
  if (!id) {
    const badResponse: ApiResult = {
      valid: false,
      data: 'Missing id in request params',
    };
    res.status(400).json(badResponse);
    return;
  }

  const command = new GetCommand({
    TableName: DYNAMODB_TABLE,
    Key: {
      pk: id.toString(),
      sk: id.toString()
    },
  });

  const response = await docClient.send(command);
  let data: any | undefined = response.Item;
  const valid = response.$metadata.httpStatusCode === 200 && !!data;

  const results: ApiResult = {
    valid,
    data
  };
  res.json(results);
}
