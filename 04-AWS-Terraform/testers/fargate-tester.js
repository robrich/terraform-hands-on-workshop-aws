import dotenv from 'dotenv/config';
import axios from 'axios';


// TODO: set environment variables in .env
const alb_url = process.env.alb_url; // in .env

const dynamo_pk = 'mypk'; // <-- TODO: set this to what ever you want
const some_obj = { // <-- TODO: set this to what ever you want
  "foo": "bar",
  "a": 2,
  "bool": true
};


main();
async function main() {
  await getHomepage();
  await update(dynamo_pk, some_obj);
  await get(dynamo_pk);
  await getAll();
}

async function getHomepage() {
  const url = `${alb_url}/`;
  try {
    const res = await axios.get(url, {
      headers: {
        'User-Agent': 'Node/20.0' // No user-agent? API Gateway returns 401.
      }
    });
    console.log('Response:', res.data);
  } catch (err) {
    console.error('Error:', {message: err.message, url, status: err.response?.status, response: err.response?.data});
  }
}

async function get(id) {
  const url = `${alb_url}/${encodeURIComponent(id)}`;
  try {
    const res = await axios.get(url, {
      headers: {
        'User-Agent': 'Node/20.0' // No user-agent? API Gateway returns 401.
      }
    });
    console.log('Response:', res.data);
  } catch (err) {
    console.error('Error:', {message: err.message, url, status: err.response?.status, response: err.response?.data});
  }
}

async function update(id, body) {
  const url = `${alb_url}/${encodeURIComponent(id)}`;
  try {
    const res = await axios.post(url, body, {
      headers: {
        'User-Agent': 'Node/20.0' // No user-agent? API Gateway returns 401.
      }
    });
    console.log('Response:', res.data);
  } catch (err) {
    console.error('Error:', {message: err.message, url, status: err.response?.status, response: err.response?.data});
  }
}

async function getAll() {
  const url = `${alb_url}`;
  try {
    const res = await axios.get(url, {
      headers: {
        'User-Agent': 'Node/20.0' // No user-agent? API Gateway returns 401.
      }
    });
    console.log('Response:', JSON.stringify(res.data, null, 2));
  } catch (err) {
    console.error('Error:', {message: err.message, url, status: err.response?.status, response: err.response?.data});
  }
}
