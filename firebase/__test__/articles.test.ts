import * as firebase from '@firebase/testing';
import { projectID, rules, authenticatedApp, Auth, adminApp } from './firestore_test.util';
import Article, { Timestamp } from './entities/article';

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

  test('認証してないユーザーでもarticleを取得できる', async () => {
    const db = authenticatedApp(undefined);
    firebase.assertSucceeds(db.collection('articles').get());
  });

  test('新規データが登録できる', async () => {
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await db.collection('category').add({
      title: 'category',
      reading: 'かてごりー',
    });
    const article: Article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertSucceeds(db.collection('articles').add(article));
  });

  test('認証されていないと登録できない', async () => {
    const admin = adminApp();
    const db = authenticatedApp(undefined);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article: Article = {
      title: '',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('タイトルがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article = {
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('タイトルが空だと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article: Article = {
      title: '',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('beforeがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article = {
      title: 'title',
      body: 'body',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('afterがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article = {
      title: 'title',
      body: 'body',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('afterがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article = {
      title: 'title',
      body: 'body',
      before: '',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('user_idがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    const article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('カテゴリーがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    await category.delete();
    const article: Article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('created_atがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    await category.delete();
    const article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('created_atがtimestampでないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    await category.delete();
    const article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: '',
      updated_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('updated_atがないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    await category.delete();
    const article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  test('updated_atがtimestampでないと登録できない', async () => {
    const admin = adminApp();
    const auth: Auth = {
      uid: 'aaa',
      email: 'aaa@example.com',
    }
    const db = authenticatedApp(auth);
    const category = await admin.collection('category').add({
      title: 'category',
      reading: 'かてごりー'
    });
    await category.delete();
    const article = {
      title: 'title',
      body: 'body',
      before: 'before',
      after: 'after',
      user_id: 'user_id',
      category: category,
      created_at: new Timestamp(0, 0),
      updated_at: '',
    }
    firebase.assertFails(db.collection('articles').add(article));
  });

  // test('データが更新できる', async () => {
  //   const auth: Auth = {
  //     uid: 'aaa',
  //     email: 'aaa@example.com',
  //   }
  //   await updateTest(auth, {
  //     updated_at: Timestamp.now(),
  //   }, true);
  // });

  // test('ログインしていない場合更新できない', async () => {
  //   await updateTest(undefined, {
  //     updated_at: Timestamp.now(),
  //   }, false)
  // });

  // test('ログインユーザーのドキュメントでない場合更新できない', async () => {
  //   const auth: Auth = {
  //     uid: 'aaa',
  //     email: 'aaa@example.com',
  //   }
  //   const admin = adminApp();
  //   const db = authenticatedApp(auth);
  //   const category = await admin.collection('category').add({
  //     title: 'category',
  //     reading: 'かてごりー',
  //   });
  //   const article: Article = {
  //     title: 'title',
  //     body: 'body',
  //     before: 'before',
  //     after: 'after',
  //     user_id: auth.uid + 'uid',
  //     category: category,
  //     created_at: new Timestamp(0, 0),
  //     updated_at: new Timestamp(0, 0),
  //   }
  //   const addedArticle = await admin.collection('articles').add(article);
  
  //   firebase.assertFails(db.collection('articles').doc(addedArticle.id).update({
  //     updated_at: Timestamp.now(),
  //   }));
  // });

  // test('ログインユーザーのuidとarticle のuser_idが一致する時のみ削除できる', async () => {
  //   const auth: Auth = {
  //     uid: 'aaa',
  //     email: 'aaa@example.com',
  //   };
  //   const admin = adminApp();
  //   const db = authenticatedApp(auth);

  //   const category = await admin.collection('category').add({
  //     title: 'category',
  //     reading: 'かてごりー',
  //   });
  //   const article: Article = {
  //     title: 'title',
  //     body: 'body',
  //     before: 'before',
  //     after: 'after',
  //     user_id: auth.uid + 'uid',
  //     category: category,
  //     created_at: new Timestamp(0, 0),
  //     updated_at: new Timestamp(0, 0),
  //   }
  //   const addedArticle = await admin.collection('articles').add(article);
  
  //   firebase.assertSucceeds(db.collection('articles').doc(addedArticle.id).delete());
  // });
});

// async function updateTest(auth: Auth | undefined, updateData: any, expectSuccess: boolean) {
//   const admin = adminApp();
//   const db = authenticatedApp(auth);
//   const category = await admin.collection('category').add({
//     title: 'category',
//     reading: 'かてごりー',
//   });
//   const article: Article = {
//     title: 'title',
//     body: 'body',
//     before: 'before',
//     after: 'after',
//     user_id: auth?.uid ?? '',
//     category: category,
//     created_at: new Timestamp(0, 0),
//     updated_at: new Timestamp(0, 0),
//   }
//   const addedArticle = await admin.collection('articles').add(article);

//   const assert = expectSuccess ? firebase.assertSucceeds : firebase.assertFails;
//   assert(db.collection('articles').doc(addedArticle.id).update(updateData));
// }