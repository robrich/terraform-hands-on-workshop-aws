import 'dotenv/config';
import { APIGatewayProxyEvent, APIGatewayProxyResultV2 } from 'aws-lambda';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand } from '@aws-sdk/lib-dynamodb';


export interface ApiResult {
  valid: boolean;
  data: unknown;
}

export const dynamoDbQueryHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResultV2<ApiResult>> => {

  let id: string | undefined;
  let valid: boolean = true;
  try {

    // get inputs

    const client = new DynamoDBClient({}); // get config from .env / env vars
    const docClient = DynamoDBDocumentClient.from(client);
    const dynamodbTable = process.env.DYNAMODB_TABLE;
    if (!dynamodbTable) {
      throw new Error('DYNAMODB_TABLE not set');
    }

    id = event.queryStringParameters?.id ?? 'hello-world';

    const command = new GetCommand({
      TableName: dynamodbTable,
      Key: {
        pk: id,
        sk: id
      },
    });

    const response = await docClient.send(command);
    const data = response.Item;
    const valid = response.$metadata.httpStatusCode === 200 && !!data;

    const results: ApiResult = {
      valid,
      data
    }

    // return results
    return {
      statusCode: valid ? 200 : 404,
      body: JSON.stringify(results),
      headers: {
        'Content-Type': 'application/json',
      }
    } as APIGatewayProxyResultV2<ApiResult>;
  } catch (err) {
    const error = err as Error;
    console.error(
      JSON.stringify({
        params: { id },
        err: { message: error.message, stack: error.stack },
      }, null, 2)
    );
    const results: ApiResult = {
      valid: false,
      data: error.message, // TODO: don't leak secrets
    };
    return {
      statusCode: 500,
      body: JSON.stringify(results),
      headers: {
        'Content-Type': 'application/json',
      }
    };
  }
};
