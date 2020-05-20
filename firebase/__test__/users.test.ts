import * as firebase from '@firebase/testing';
import { projectID, rules, authenticatedApp, adminApp, Auth } from './firestore_test.util';

describe('articles document test', () => {
  beforeAll(async () => {
    await firebase.loadFirestoreRules({ projectId: projectID, rules })
  });

  beforeEach(async () => {
    await firebase.clearFirestoreData({ projectId: projectID })
  });

  afterAll(async () => {
    await Promise.all(firebase.apps().map((app: any) => app.delete()))
  });

  test('ログインユーザーは自分の情報が見れる', async () => {
    const admin = adminApp();
    const user = await admin.collection('users').add({});
    const auth: Auth = {
      uid: user.id,
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertSucceeds(db.collection('users').doc(user.id).get());
  });

  test('ログインユーザー以外の情報は見れない', async () => {
    const admin = adminApp();
    const user = await admin.collection('users').add({});
    const user2 = await admin.collection('users').add({});
    const auth: Auth = {
      uid: user.id,
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertFails(db.collection('users').doc(user2.id).get());
  });

  test('ログインしているユーザーなら作成できる', async () => {
    const auth: Auth = {
      uid: 'abc123',
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertSucceeds(db.collection('users').add({}));
  });

  test('ログインしているユーザーでも更新できない', async () => {
    const admin = adminApp();
    const user = await admin.collection('users').add({});
    const auth: Auth = {
      uid: user.id,
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertFails(db.collection('users').doc(user.id).update({}));
  });

  test('ログインしているユーザーなら削除できる', async () => {
    const admin = adminApp();
    const user = await admin.collection('users').add({});
    const auth: Auth = {
      uid: user.id,
      email: '',
    }
    const db = authenticatedApp(auth);
    firebase.assertSucceeds(db.collection('users').doc(user.id).delete());
  });

  describe('like_users test', () => {
    test('ログインユーザーのドキュメントのサブコレクションの場合読める', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const db = authenticatedApp(auth);
      firebase.assertSucceeds((db.collection('users').doc(user.id).collection('like_articles').get()));
    });

    test('ログインユーザーのドキュメントのサブコレクションでない場合読めない', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const user2 = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const db = authenticatedApp(auth);
      firebase.assertFails(db.collection('users').doc(user2.id).collection('like_articles').get());
    });

    test('ログインユーザーのドキュメントのサブコレクションの場合作成できる', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const db = authenticatedApp(auth);
      firebase.assertSucceeds(db.collection('users').doc(user.id).collection('like_articles').add({}));
    });

    test('ログインユーザーのドキュメントのサブコレクションでない場合作成できない', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const user2 = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const db = authenticatedApp(auth);
      firebase.assertFails(db.collection('users').doc(user2.id).collection('like_articles').get());
    });

    test('ログインユーザーのドキュメントのサブコレクションでも更新できない', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const likeArticle = await admin.collection('users').doc(user.id).collection('like_articles').add({});
      const db = authenticatedApp(auth);
      firebase.assertFails(db.collection('users').doc(user.id).collection('like_articles').doc(likeArticle.id).update({}));
    });

    test('ログインユーザーのドキュメントのサブコレクションの場合削除できる', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const likeArticle = await admin.collection('users').doc(user.id).collection('like_articles').add({});
      const db = authenticatedApp(auth);
      firebase.assertSucceeds(db.collection('users').doc(user.id).collection('like_articles').doc(likeArticle.id).delete());
    });

    test('ログインユーザーのドキュメントのサブコレクションでない場合削除できない', async () => {
      const admin = adminApp();
      const user = await admin.collection('users').add({});
      const user2 = await admin.collection('users').add({});
      const auth: Auth = {
        uid: user.id,
        email: '',
      }
      const likeArticle = await admin.collection('users').doc(user.id).collection('like_articles').add({});
      const db = authenticatedApp(auth);
      firebase.assertFails(db.collection('users').doc(user2.id).collection('like_articles').doc(likeArticle.id).delete());
    });
  });
});