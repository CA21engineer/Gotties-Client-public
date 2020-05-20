import * as firebase from '@firebase/testing';
import { projectID, rules, authenticatedApp, Auth, adminApp } from './firestore_test.util';

describe('category document test', () => {
  beforeAll(async () => {
    await firebase.loadFirestoreRules({ projectId: projectID, rules })
  });

  afterEach(async () => {
    await firebase.clearFirestoreData({ projectId: projectID })
  });

  afterAll(async () => {
    await Promise.all(firebase.apps().map((app: any) => app.delete()))
  });

  it('認証してないユーザーでもcategoryを取得できる', async () => {
    const db = authenticatedApp(undefined);
    firebase.assertSucceeds((db.collection('category').get()));
  });

  it('認証ユーザーでかつタイトルがあれば登録できる', async () => {
    const auth: Auth = {
      uid: 'abc123',
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertSucceeds(db.collection('category').add({
      title: 'title',
    }));
  });

  it('タイトルがないと登録できない', async () => {
    const auth: Auth = {
      uid: 'abc123',
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertFails(db.collection('category').add({}));
  });

  it('認証ユーザーでない場合登録できない', async () => {
    const db = authenticatedApp(undefined);
    firebase.assertFails(db.collection('category').add({
      title: 'title',
    }));
  });
  
  it('認証ユーザーでかつタイトルがあれば更新できる', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'abc123',
      email: '',
    }
    const category = await admin.collection('category').add({
      title: 'title',
      reading: 're',
    });
    const db = authenticatedApp(auth);
    await db.collection('category').doc(category.id).update({});
    firebase.assertSucceeds(db.collection('category').doc(category.id).update({
      title: 'a'
    }));
  });

  it('認証ユーザーでない場合更新できない', async () => {
    const admin = adminApp();
    const category = await admin.collection('category').add({
      title: 'title',
    });
    const db = authenticatedApp(undefined);
    firebase.assertFails(db.collection('category').doc(category.id).update({
      title: 'title_updated',
      reading: 'reading',
    }));
  });

  it('タイトルがないと更新できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'abc123',
      email: '',
    }
    const category = await admin.collection('category').add({
      title: 'title'
    });
    const db = authenticatedApp(auth);
    firebase.assertFails(db.collection('category').doc(category.id).update({
    }));
  });

  it('削除できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'abc123',
      email: '',
    }
    const category = await admin.collection('category').add({
      title: 'title',
    });
    const db = authenticatedApp(undefined);
    firebase.assertFails(db.collection('category').doc(category.id).delete());
  });
});