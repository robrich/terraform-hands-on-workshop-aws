import { Request, Response } from 'express';


export default async function get(req: Request, res: Response) {
  res.send('Hello from the Terraform container!');
}
