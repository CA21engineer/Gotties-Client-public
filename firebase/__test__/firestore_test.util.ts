import { firestore } from 'firebase';
import fs from 'fs';
import * as firebase from '@firebase/testing';

export interface Auth {
  uid: string,
  email: string,
}

export const projectID = 'gotties-homehack';
const databaseName = 'gotties-homehack';
export const rules = fs.readFileSync('./firestore.rules', 'utf8');
export const authenticatedApp: (auth: Auth | undefined) => firestore.Firestore = (auth) => {
  return firebase.initializeTestApp({ projectId: projectID, databaseName, auth }).firestore();
}
export const adminApp: () => firestore.Firestore = () => firebase.initializeAdminApp({ projectId: projectID }).firestore();