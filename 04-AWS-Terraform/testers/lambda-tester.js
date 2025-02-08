import dotenv from 'dotenv/config';
import axios from 'axios';


// TODO: set environment variables in .env
const api_gateway_url = process.env.my_gateway_url; // in .env

const dynamo_pk = 'mypk'; // <-- TODO: set this to match what you set in fargate


main();
async function main() {
  await callLambda(dynamo_pk);
}

async function callLambda(jwt, id) {
  const url = `${api_gateway_url}?id=${encodeURIComponent(id)}`;
  try {
    const res = await axios.get(url, {
      headers: {
        'Authorization': `Bearer ${jwt}`,
        'User-Agent': 'Node/20.0' // No user-agent? API Gateway returns 401.
      }
    });
    console.log('Response:', res.data);
  } catch (err) {
    console.error('Error:', {message: err.message, url, status: err.response?.status, response: err.response?.data});
  }
}
