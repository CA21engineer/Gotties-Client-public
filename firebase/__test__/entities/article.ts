import { firestore } from 'firebase';
export const Timestamp = firestore.Timestamp;

interface Article {
  title: string,
  body: string,
  before: string,
  after: string,
  user_id: string,
  category: firestore.DocumentReference,
  created_at: firestore.Timestamp,
  updated_at: firestore.Timestamp,
}

export default Article;