import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';


console.log('DYNAMODB_TABLE', process.env.DYNAMODB_TABLE);

export const dbClient = new DynamoDBClient();
export const docClient = DynamoDBDocumentClient.from(dbClient);

export const DYNAMODB_TABLE = process.env.DYNAMODB_TABLE;
if (!DYNAMODB_TABLE) {
  throw new Error('DYNAMODB_TABLE not set');
}
