import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi{
  
//credentials for gsheets
  static const _credentials = r'''
    {
      "type": "service_account",
      "project_id": "diploma-gsheets",
      "private_key_id": "039156a6dd0909efb49cf3f28ff2e48e422d20dd",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDBteflvStHNQwX\n3iICFwG8sRLxGctszHgUWLiqBGe4lZk87b2HgflnBVwwY87glDUpcPA0DRodopkY\nkGKVCHb0n/cT4oxElhDocFodvGUXebjUTiYWgCzvbRywwqrYcSqSron8NiORPzX3\nX/ii1QWeFGwwnv4oFD/UjWTWPykkBDekJhm8WM0Ar1iAonL9Xe7/dE1Fuda4cZlm\nuiHE+U3fnJkjgb2QBapZdXMlBadWukZg8jZTTwdB6wKY0KCNImw9DC0JA50p9UWv\n4rbYFjTWzIlEy7JCyqBxJumMvT/BEXdz2V2iNgDSV5rVd6QU2kgRKP1dPesdXQR/\nU1/whv9RAgMBAAECggEACE/Bz326aafBCRUi6GwMSwheA7JTpCtxy42y/riJqsXg\neVjKFRJinSUBu6HMsp4pWcnaxKD7SeI8J22qjTJ7yCtE8rl5w0edGhwYAcafn849\nO/7Oa5C8XNmVrY/svLS+WuTaTtQT2puXuTGI/ZOeVhYSPlPUG+wigQBAH2E+Zqkk\na3hLFsO5bGyHijU5w+1R4eNj/R4wr6PuH2ZOHK7C4bOPMrWGfvhZX5+o9usb7G5g\nQJMyLKgQnIEnEg6JhYYnA/fbCH3EhyXlsVnyvf9TgZdElQcwGRFbS7t8BGEa+s9H\nceIk1PCPbK/Un5c+7RhhGQbu5REARepf0Bw1f+SucQKBgQD6tPymBJk7bIxu7xH0\ncsTpc91VvMPQO+11x8zMBvCu6aHKFIi9VTAZ5ppl+/h58QOJobOFbm9pMN+c65El\nfu+Z8nyLI5Qq8Dkcvmnc9HZouJzC0J0Yyy7mLRc/DGsbImo4uJmKj15Q+YxgkHM1\nE1ItVnhm40I1YH7inFre4kK4xwKBgQDFzN3W2nNxhQc9cFtUjw0Fnguweo+Ir85E\nF2xJdAfuqxsi+LGEX1rQLZKIAnHKBnXbETrMlUi+D21kqADieDJofl+nsOyfTBYH\ngnAaWWvzXO7CDpqmjbBzhVsRkbKzvWaVqIhodcP9TExiA9iBi/koEy0irPlnLeDj\nY+ENPt1fJwKBgDSeZeSGVI7nUnY6ER+oMvH4knzbOJHs8gLlY3NzBXMAsCdUtfpe\n9dCJ2OAMyXL2hdKOMLqRmiqOynAJ9RXUlX9PKJqfZgq5DpOc12U7ndqO3L/6vu4k\nPvyqfBWMirJQP9EV1YwCWT5Pkgn2Z2e9XWMMogqeKhg/34G6ZUwgWvajAoGAX0hq\n7N7akaq1bCE9vaQTb8tMcjz3+65EvIRUA6ZDU/NU5SnLyaptgq8RUTdsPReTmm3Y\nV0jqe7POzJgppO6lybRmu878jVgHnKJ3AhplaBwyX4TNdsH2aA+raPE4lmD8k8dV\nvoxMVy5z9RtJJk6ZPXbPXU7Z7ZwqIx+v/8NyvC0CgYEA2oDG67EeKx1HA4aiCQAH\nObC+Jnd/jr75WU2FCCslsNliauys3pGe+RDKHlytuSdX0iA5cLVLFidMPUY//7XL\nv5Zs8YdKyW678hhxXhmBA9Cbt/Fo3vgYEEf5HnyhzSbMEuf6Xhc62XUsoHP8d0w5\nPfMzFbxvzvbcBPsWGref5c4=\n-----END PRIVATE KEY-----\n",
      "client_email": "diploma-gsheets@diploma-gsheets.iam.gserviceaccount.com",
      "client_id": "109247598903233692605",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/diploma-gsheets%40diploma-gsheets.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
    ''';
  static final _spreadsheetId = '1QOXXb7XRtx2EQ1GBAkPIeNO8DvVh4oLJED9b5ltsK_0';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async{
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }
//count the number of notes
  static Future countRows() async{
    while((await _worksheet!.values.value(column: 1, row: numberOfTransactions+1)) != ''){
      numberOfTransactions++;
    }
    loadTransactions();
  }


//laod existing notes form the spreadsheet
  static Future loadTransactions() async{
    if(_worksheet == null) return;

    for (int i=1;i<numberOfTransactions; i++){
      final String transactionName = await _worksheet!.values.value(column:1, row: i+1);
      final String transactionAmount = await _worksheet!.values.value(column:2, row: i+1);
      final String transactionType = await _worksheet!.values.value(column:3, row: i+1);

      if(currentTransactions.length < numberOfTransactions){
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    //stopping circular loading indicator
    loading = false;
  }

  static Future insert(String name, String amount, bool _isIncome) async{
    if(_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income':'expense'
    ]);
  }
}