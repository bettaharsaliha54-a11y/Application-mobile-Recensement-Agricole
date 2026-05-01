import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile/models/exploitation.dart';
import 'package:mobile/models/exploitant.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'communes_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      _database = await databaseFactory.openDatabase(
        'rga_census_v7.db',
        options: OpenDatabaseOptions(
          version: 3,
          onCreate: _createDB,
          onUpgrade: _onUpgrade,
          onConfigure: (db) async {
            await db.execute('PRAGMA foreign_keys = ON');
          },
        ),
      );
    } else {
      _database = await _initDB('rga_census_v7.db');
    }
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE users (
      id INTEGER PRIMARY KEY, email TEXT, nom_fr TEXT, nom_ar TEXT, 
      prenom_fr TEXT, prenom_ar TEXT, password_hash TEXT, status INTEGER
    )''');

    await db.execute(
      'CREATE TABLE wilayas (id INTEGER PRIMARY KEY, code TEXT, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE communes (id INTEGER PRIMARY KEY, wilaya_id INTEGER, nom_fr TEXT, nom_ar TEXT)',
    );

    // Reference Tables
    await db.execute(
      'CREATE TABLE sexe (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE niveau_instruction (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE formation_agricole (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE type_assurance (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE nature_exploitant (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE statut_juridique (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE type_activite (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE mode_exploitation (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE statut_terre (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE source_energie (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE vocation_agricole (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );
    await db.execute(
      'CREATE TABLE type_accessibilite (id INTEGER PRIMARY KEY, nom_fr TEXT, nom_ar TEXT)',
    );

    await db.execute('''CREATE TABLE exploitants (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      nom_fr TEXT, nom_ar TEXT, prenom_fr TEXT, prenom_ar TEXT,
      sexe_id INTEGER, annee_naissance INTEGER,
      adresse TEXT, telephone TEXT, email TEXT,
      nin TEXT, nis TEXT, num_carte_fellah TEXT,
      niveau_instruction_id INTEGER, formation_agricole_id INTEGER,
      type_assurance_id INTEGER, num_securite_sociale TEXT,
      nature_exploitant_id INTEGER, nb_coexploitants INTEGER,
      issu_famille_agricole INTEGER, est_exploitant_principal INTEGER,
      inscrit_chambre_agri INTEGER, inscrit_capa INTEGER, inscrit_unpa INTEGER,
      inscrit_chambre_artisanat INTEGER, inscrit_chambre_commerce INTEGER,
      beneficie_dispositif_social INTEGER,
      is_completed INTEGER DEFAULT 0,
      is_synced INTEGER DEFAULT 0,
      census_date TEXT,
      census_json TEXT
    )''');

    await db.execute('''CREATE TABLE exploitations (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      exploitant_id INTEGER, 
      nom_exploitation_ar TEXT, nom_exploitation_fr TEXT,
      wilaya_id INTEGER, commune_id INTEGER, 
      district_ar TEXT, district_fr TEXT,
      latitude REAL, longitude REAL,
      acces_reseau_electrique INTEGER DEFAULT 0, 
      acces_reseau_telephonique INTEGER DEFAULT 0,
      type_telephone_id INTEGER,
      acces_internet INTEGER DEFAULT 0,
      internet_agri INTEGER DEFAULT 0,
      eac_concession INTEGER DEFAULT 0,
      nb_exploitants_eac INTEGER DEFAULT 0,
      logement_occupant INTEGER DEFAULT 0,
      nb_menages INTEGER DEFAULT 1,
      statut_juridique_id INTEGER,
      activite_exploitation_id INTEGER,
      superficie_batie REAL,
      superficie_non_batie REAL,
      superficie_exploitee REAL,
      nb_puits INTEGER DEFAULT 0,
      mode_irrigation_id INTEGER,
      has_hangar INTEGER DEFAULT 0,
      has_stable INTEGER DEFAULT 0,
      has_cold_room INTEGER DEFAULT 0,
      ouvriers_permanents INTEGER DEFAULT 0,
      ouvriers_saisonniers INTEGER DEFAULT 0,
      assistance_technique INTEGER DEFAULT 0,
      vocation TEXT,
      accessibilite TEXT,
      code TEXT,
      FOREIGN KEY (exploitant_id) REFERENCES exploitants (id) ON DELETE CASCADE
    )''');

    await _seedData(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // إضافة العمود المفقود في المستثمرات
      try {
        await db.execute(
          'ALTER TABLE exploitations ADD COLUMN activite_exploitation_id INTEGER',
        );
      } catch (e) {
        debugPrint("Column already exists or error adding: $e");
      }
      // حذف حساب المدير
      await db.delete('users', where: 'id = ?', whereArgs: [2]);
    }
  }
  Future<void> _seedData(Database db) async {
    // 👤 حسابات الدخول (Offline)
    await db.insert('users', {
      'id': 1,
      'email': 'recenseur@agri.dz',
      'password_hash': 'R.Agri26',
      'nom_fr': 'Recenseur',
      'nom_ar': 'محصي',
      'prenom_fr': 'Agricole',
      'prenom_ar': 'فلاحي',
      'status': 1,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // 🇩🇿 جميع الـ 58 ولاية كاملة
    final List<List<dynamic>> wilayas = [
      [1, '01', 'Adrar', 'أدرار'],
      [2, '02', 'Chlef', 'الشلف'],
      [3, '03', 'Laghouat', 'الأغواط'],
      [4, '04', 'Oum El Bouaghi', 'أم البواقي'],
      [5, '05', 'Batna', 'باتنة'],
      [6, '06', 'Béjaïa', 'بجاية'],
      [7, '07', 'Biskra', 'بسكرة'],
      [8, '08', 'Béchar', 'بشار'],
      [9, '09', 'Blida', 'البليدة'],
      [10, '10', 'Bouira', 'البويرة'],
      [11, '11', 'Tamanrasset', 'تمنراست'],
      [12, '12', 'Tébessa', 'تبسة'],
      [13, '13', 'Tlemcen', 'تلمسان'],
      [14, '14', 'Tiaret', 'تيارت'],
      [15, '15', 'Tizi Ouzou', 'تيزي وزو'],
      [16, '16', 'Alger', 'الجزائر'],
      [17, '17', 'Djelfa', 'الجلفة'],
      [18, '18', 'Jijel', 'جيجل'],
      [19, '19', 'Sétif', 'سطيف'],
      [20, '20', 'Saïda', 'سعيدة'],
      [21, '21', 'Skikda', 'سكيكدة'],
      [22, '22', 'Sidi Bel Abbès', 'سيدي بلعباس'],
      [23, '23', 'Annaba', 'عنابة'],
      [24, '24', 'Guelma', 'قالمة'],
      [25, '25', 'Constantine', 'قسنطينة'],
      [26, '26', 'Médéa', 'المدية'],
      [27, '27', 'Mostaganem', 'مستغانم'],
      [28, '28', 'M\'Sila', 'المسيلة'],
      [29, '29', 'Mascara', 'معسكر'],
      [30, '30', 'Ouargla', 'ورقلة'],
      [31, '31', 'Oran', 'وهران'],
      [32, '32', 'El Bayadh', 'البيض'],
      [33, '33', 'Illizi', 'إليزي'],
      [34, '34', 'Bordj Bou Arréridj', 'برج بوعريريج'],
      [35, '35', 'Boumerdès', 'بومرداس'],
      [36, '36', 'El Tarf', 'الطارف'],
      [37, '37', 'Tindouf', 'تندوف'],
      [38, '38', 'Tissemsilt', 'تيسمسيلت'],
      [39, '39', 'El Oued', 'الوادي'],
      [40, '40', 'Khenchela', 'خنشلة'],
      [41, '41', 'Souk Ahras', 'سوق أهراس'],
      [42, '42', 'Tipaza', 'تيبازة'],
      [43, '43', 'Mila', 'ميلة'],
      [44, '44', 'Aïn Defla', 'عين الدفلى'],
      [45, '45', 'Naâma', 'النعامة'],
      [46, '46', 'Aïn Témouchent', 'عين تموشنت'],
      [47, '47', 'Ghardaïa', 'غرداية'],
      [48, '48', 'Relizane', 'غليزان'],
      [49, '49', 'Timimoun', 'تيميمون'],
      [50, '50', 'Bordj Badji Mokhtar', 'برج باجي مختار'],
      [51, '51', 'Ouled Djellal', 'أولاد جلال'],
      [52, '52', 'Béni Abbès', 'بني عباس'],
      [53, '53', 'In Salah', 'عين صالح'],
      [54, '54', 'In Guezzam', 'عين قزام'],
      [55, '55', 'Touggourt', 'تقرت'],
      [56, '56', 'Djanet', 'جانت'],
      [57, '57', 'El M\'Ghair', 'المغير'],
      [58, '58', 'El Menia', 'المنيعة'],
    ];
    for (var w in wilayas)
      await db.insert('wilayas', {
        'id': w[0],
        'code': w[1],
        'nom_fr': w[2],
        'nom_ar': w[3],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    // 📍 جميع بلديات الجزائر الـ 58 ولاية
    for (var c in allCommunesData) {
      await db.insert('communes', {
        'id': c[0],
        'wilaya_id': c[1],
        'nom_fr': c[2],
        'nom_ar': c[3],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Reference Tables Seeding
    final sexes = [
      [1, 'Masculin', 'ذكر'],
      [2, 'Féminin', 'أنثى'],
    ];
    for (var s in sexes)
      await db.insert('sexe', {
        'id': s[0],
        'nom_fr': s[1],
        'nom_ar': s[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final instructions = [
      [1, 'Aucun (Ignorant)', 'بدون (أمي)'],
      [2, 'Alphabétisation', 'محو الأمية'],
      [3, 'Primaire', 'ابتدائي'],
      [4, 'Moyen', 'متوسط'],
      [5, 'Secondaire', 'ثانوي'],
      [6, 'Technique', 'تقني'],
      [7, 'Supérieur (Universitaire)', 'جامعي (عالي)'],
      [8, 'Coranique', 'قرآني'],
    ];
    for (var i in instructions)
      await db.insert('niveau_instruction', {
        'id': i[0],
        'nom_fr': i[1],
        'nom_ar': i[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final formations = [
      [1, 'Aucune', 'بدون تدريب'],
      [2, 'Brevet de Technicien', 'شهادة تقني'],
      [3, 'Technicien Supérieur', 'تقني سامي'],
      [4, 'CPA', 'شهادة التأهيل المهني'],
      [5, 'Ingénieur', 'مهندس'],
      [6, 'CAPA', 'شهادة الكفاءة المهنية'],
      [7, 'FAD', 'التكوين عن بعد'],
      [8, 'LMD', 'ل م د'],
      [9, 'Vétérinaire', 'بيطري'],
    ];
    for (var f in formations)
      await db.insert('formation_agricole', {
        'id': f[0],
        'nom_fr': f[1],
        'nom_ar': f[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final assurances = [
      [1, 'Assurance Sociale', 'ضمان اجتماعي'],
      [2, 'Assurance Privée', 'تأمين خاص'],
      [3, 'Aucune', 'بدون تأمين'],
    ];
    for (var a in assurances)
      await db.insert('type_assurance', {
        'id': a[0],
        'nom_fr': a[1],
        'nom_ar': a[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final natures = [
      [1, 'Individuel', 'فردي'],
      [2, 'Collectif', 'جماعي'],
    ];
    for (var n in natures)
      await db.insert('nature_exploitant', {
        'id': n[0],
        'nom_fr': n[1],
        'nom_ar': n[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final statuts = [
      [1, 'Propriétaire', 'مالك'],
      [2, 'Locataire', 'مستأجر'],
      [3, 'Concessionnaire', 'صاحب امتياز'],
      [4, 'EAC', 'مستثمرة فلاحية جماعية'],
      [5, 'EAI', 'مستثمرة فلاحية فردية'],
      [6, 'Associé', 'شريك'],
    ];
    for (var s in statuts)
      await db.insert('statut_juridique', {
        'id': s[0],
        'nom_fr': s[1],
        'nom_ar': s[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final vocations = [
      [1, 'Végétale', 'نباتي'],
      [2, 'Animale', 'حيواني'],
      [3, 'Mixte', 'مختلط'],
    ];
    for (var v in vocations)
      await db.insert('vocation_agricole', {
        'id': v[0],
        'nom_fr': v[1],
        'nom_ar': v[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final accessibilites = [
      [1, 'Route Nationale', 'طريق وطني'],
      [2, 'Route Wilaya', 'طريق ولاية'],
      [3, 'Piste Carrossable', 'مسلك مهيأ'],
      [4, 'Piste Non Carrossable', 'مسلك غير مهيأ'],
      [5, 'Accès Difficile', 'وصول صعب'],
    ];
    for (var a in accessibilites)
      await db.insert('type_accessibilite', {
        'id': a[0],
        'nom_fr': a[1],
        'nom_ar': a[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    final energies = [
      [1, 'Réseau Electrique', 'شبكة الكهرباء'],
      [2, 'Groupe Electروجين', 'مولد كهربائي'],
      [3, 'Energie Solaire', 'طاقة شمسية'],
      [4, 'Autre', 'أخرى'],
    ];
    for (var e in energies)
      await db.insert('source_energie', {
        'id': e[0],
        'nom_fr': e[1],
        'nom_ar': e[2],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

    // 🌱 المستثمرين (Demo Data)
    final exploitantsList = [
      {
        'id': 1,
        'nom_ar': 'بن علي',
        'nom_fr': 'Benali',
        'prenom_ar': 'أحمد',
        'prenom_fr': 'Ahmed',
        'nin': '197503150012345',
        'telephone': '0550123456',
      },
      {
        'id': 2,
        'nom_ar': 'قاسي',
        'nom_fr': 'Kaci',
        'prenom_ar': 'فاطمة',
        'prenom_fr': 'Fatima',
        'nin': '198207220045678',
        'telephone': '0660456789',
      },
      {
        'id': 3,
        'nom_ar': 'بوزيد',
        'nom_fr': 'Bouzid',
        'prenom_ar': 'محمد',
        'prenom_fr': 'Mohamed',
        'nin': '196811100078912',
        'telephone': '0550789123',
      },
      {
        'id': 4,
        'nom_ar': 'زروقي',
        'nom_fr': 'Zerrouki',
        'prenom_ar': 'سميرة',
        'prenom_fr': 'Samira',
        'nin': '199005050012222',
        'telephone': '0670122223',
      },
    ];
    for (var e in exploitantsList)
      await db.insert(
        'exploitants',
        e,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    // 🚜 مزارعهم (Demo Data)
    final exploitationsList = [
      {
        'id': 1,
        'exploitant_id': 1,
        'nom_exploitation_ar': 'مزرعة بن علي',
        'nom_exploitation_fr': 'Ferme Benali',
        'district_ar': 'المنطقة الفلاحية الشمالية',
        'district_fr': 'Zone Agricole Nord',
        'wilaya_id': 1,
        'commune_id': 1,
        'vocation': 'Végétale',
        'accessibilite': 'Nationale',
      },
      {
        'id': 2,
        'exploitant_id': 2,
        'nom_exploitation_ar': 'مستثمرة قاسي',
        'nom_exploitation_fr': 'Exploitation Kaci',
        'district_ar': 'منطقة السوقر',
        'district_fr': 'Zone de Sougueur',
        'wilaya_id': 14,
        'commune_id': 460,
        'vocation': 'Animale',
        'accessibilite': 'Wilaya',
      },
      {
        'id': 3,
        'exploitant_id': 3,
        'nom_exploitation_ar': 'مزرعة بوزيد',
        'nom_exploitation_fr': 'Ferme Bouzid',
        'district_ar': 'سهل فرندة',
        'district_fr': 'Plaine de Frenda',
        'wilaya_id': 14,
        'commune_id': 471,
        'vocation': 'Mixte',
        'accessibilite': 'Piste',
      },
      {
        'id': 4,
        'exploitant_id': 4,
        'nom_exploitation_ar': 'مستثمرة زروقي',
        'nom_exploitation_fr': 'Exploitation Zerrouki',
        'district_ar': 'المهدية الشرقية',
        'district_fr': 'Mahdia Est',
        'wilaya_id': 14,
        'commune_id': 445,
        'vocation': 'Végétale',
        'accessibilite': 'Accès',
      },
    ];
    for (var exp in exploitationsList)
      await db.insert(
        'exploitations',
        exp,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  // --- دوال التحكم بالبيانات بدون أي مساس بها ---

  Future<List<Exploitant>> readAllExploitants() async {
    final db = await instance.database;
    final res = await db.query('exploitants', orderBy: 'id DESC');
    return res.map((j) => Exploitant.fromMap(j)).toList();
  }

  Future<List<Exploitation>> readAllExploitations() async {
    final db = await instance.database;
    // جلب المستثمرات مع تصفية التي تم إكمال إحصائها
    final res = await db.rawQuery('''
      SELECT e.* FROM exploitations e
      LEFT JOIN exploitants ex ON e.exploitant_id = ex.id
      WHERE ex.id IS NULL OR ex.is_completed = 0 OR ex.is_completed IS NULL
      ORDER BY e.id DESC
    ''');
    return res.map((j) => Exploitation.fromMap(j)).toList();
  }

  Future<int> createExploitant(Exploitant e) async {
    final db = await instance.database;
    final map = e.toMap();
    final allowed = [
      'id',
      'nom_fr',
      'nom_ar',
      'prenom_fr',
      'prenom_ar',
      'sexe_id',
      'annee_naissance',
      'adresse',
      'telephone',
      'email',
      'nin',
      'nis',
      'num_carte_fellah',
      'niveau_instruction_id',
      'formation_agricole_id',
      'type_assurance_id',
      'num_securite_sociale',
      'nature_exploitant_id',
      'nb_coexploitants',
      'issu_famille_agricole',
      'est_exploitant_principal',
      'inscrit_chambre_agri',
      'inscrit_capa',
      'inscrit_unpa',
      'inscrit_chambre_artisanat',
      'inscrit_chambre_commerce',
      'beneficie_dispositif_social',
      'is_completed',
      'census_date',
    ];
    map.removeWhere((k, v) => !allowed.contains(k));
    return await db.insert('exploitants', map);
  }

  Future<Exploitation?> getExploitationByExploitentId(int exploitantId) async {
    final db = await instance.database;
    final res = await db.query(
      'exploitations',
      where: 'exploitant_id = ?',
      whereArgs: [exploitantId],
      limit: 1,
    );
    if (res.isNotEmpty) {
      return Exploitation.fromMap(res.first);
    }
    return null;
  }

  Future<int> createExploitation(Exploitation e) async {
    final db = await instance.database;
    final map = e.toMap();
    final allowed = [
      'id',
      'exploitant_id',
      'nom_exploitation_ar',
      'nom_exploitation_fr',
      'wilaya_id',
      'commune_id',
      'district_ar',
      'district_fr',
      'latitude',
      'longitude',
      'acces_reseau_electrique',
      'acces_reseau_telephonique',
      'type_telephone_id',
      'acces_internet',
      'internet_agri',
      'eac_concession',
      'nb_exploitants_eac',
      'logement_occupant',
      'nb_menages',
      'statut_juridique_id',
      'activite_exploitation_id',
      'superficie_batie',
      'superficie_non_batie',
      'superficie_exploitee',
      'nb_puits',
      'mode_irrigation_id',
      'has_hangar',
      'has_stable',
      'has_cold_room',
      'ouvriers_permanents',
      'ouvriers_saisonniers',
      'assistance_technique',
      'vocation',
      'accessibilite',
      'code',
    ];
    map.removeWhere((k, v) => !allowed.contains(k));
    return await db.insert('exploitations', map);
  }

  Future<int> deleteExploitant(int id) async {
    final db = await instance.database;
    // حذف المستثمرة المرتبطة أولاً لضمان عدم بقاء بيانات يتيمة
    await db.delete(
      'exploitations',
      where: 'exploitant_id = ?',
      whereArgs: [id],
    );
    return await db.delete('exploitants', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteExploitation(int id) async {
    final db = await instance.database;
    return await db.delete('exploitations', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> readAllWilayas() async {
    final db = await instance.database;
    return await db.query('wilayas', orderBy: 'id ASC');
  }

  Future<List<Map<String, dynamic>>> readCommunesByWilaya(int wilayaId) async {
    final db = await instance.database;
    return await db.query(
      'communes',
      where: 'wilaya_id = ?',
      whereArgs: [wilayaId],
    );
  }

  Future<int> updateExploitantIdentity(
    int id, {
    String? nomAr,
    String? prenomAr,
    String? nomFr,
    String? prenomFr,
    String? nin,
    String? tel,
  }) async {
    final db = await instance.database;
    final Map<String, dynamic> data = {};
    if (nomAr != null) data['nom_ar'] = nomAr;
    if (prenomAr != null) data['prenom_ar'] = prenomAr;
    if (nomFr != null) data['nom_fr'] = nomFr;
    if (prenomFr != null) data['prenom_fr'] = prenomFr;
    if (nin != null) data['nin'] = nin;
    if (tel != null) data['telephone'] = tel;

    if (data.isEmpty) return 0;
    return await db.update(
      'exploitants',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAsCompleted(int id, String date, String json) async {
    final db = await instance.database;

    // 1. Perform update
    final res = await db.update(
      'exploitants',
      {'is_completed': 1, 'census_date': date, 'census_json': json},
      where: 'id = ?',
      whereArgs: [id],
    );

    // 2. Immediate verification read
    final verify = await db.query(
      'exploitants',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (verify.isNotEmpty) {
      debugPrint(
        "🔍 DB Verification after save (ID $id): is_completed = ${verify.first['is_completed']}, date = ${verify.first['census_date']}",
      );
    }

    debugPrint(
      "✅ DB Update: markAsCompleted(id: $id) -> Result: $res (1 means success)",
    );
    return res;
  }

  Future<int> markAsSynced(int id) async {
    final db = await instance.database;
    return await db.update(
      'exploitants',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getCompletedNotSynced() async {
    final db = await instance.database;
    return await db.query(
      'exploitants',
      where: 'is_completed = 1 AND is_synced = 0',
    );
  }

  Future<List<Map<String, dynamic>>> readReferenceTable(String table) async {
    final db = await instance.database;
    try {
      return await db.query(table);
    } catch (e) {
      return [];
    }
  }

  static bool _isSeeded = false;

  Future<void> forceSeed() async {
    final db = await instance.database;

    // 👤 تحديث كلمة المرور للحسابات الافتراضية (يحدث في كل مرة لضمان التزامن)
    await db.insert('users', {
      'id': 1,
      'email': 'recenseur@agri.dz',
      'password_hash': 'R.Agri26',
      'nom_fr': 'Recenseur',
      'nom_ar': 'محصي',
      'prenom_fr': 'Agricole',
      'prenom_ar': 'فلاحي',
      'status': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // حذف حساب المدير إذا كان موجوداً
    await db.delete('users', where: 'id = ?', whereArgs: [2]);

    if (_isSeeded) return;

    // 🌱 إجبار قاعدة البيانات على الاحتفاظ دائماً بهؤلاء المستثمرين الأربعة
    final exploitantsList = [
      {
        'id': 1,
        'nom_ar': 'بن علي',
        'nom_fr': 'Benali',
        'prenom_ar': 'أحمد',
        'prenom_fr': 'Ahmed',
        'nin': '197503150012345',
        'telephone': '0550123456',
      },
      {
        'id': 2,
        'nom_ar': 'قاسي',
        'nom_fr': 'Kaci',
        'prenom_ar': 'فاطمة',
        'prenom_fr': 'Fatima',
        'nin': '198207220045678',
        'telephone': '0660456789',
      },
      {
        'id': 3,
        'nom_ar': 'بوزيد',
        'nom_fr': 'Bouzid',
        'prenom_ar': 'محمد',
        'prenom_fr': 'Mohamed',
        'nin': '196811100078912',
        'telephone': '0550789123',
      },
      {
        'id': 4,
        'nom_ar': 'زروقي',
        'nom_fr': 'Zerrouki',
        'prenom_ar': 'سميرة',
        'prenom_fr': 'Samira',
        'nin': '199005050012222',
        'telephone': '0670122223',
      },
    ];
    for (var e in exploitantsList) {
      await db.insert(
        'exploitants',
        e,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // 📍 التأكد من وجود الولايات والبلديات (مرة واحدة فقط لتسريع التطبيق)
    final checkW = await db.query('wilayas', limit: 1);
    if (checkW.isEmpty) {
      await _seedData(db);
    } else {
      final checkC = await db.query('communes', limit: 1);
      if (checkC.isEmpty) {
        await db.transaction((txn) async {
          for (var c in allCommunesData) {
            await txn.insert('communes', {
              'id': c[0],
              'wilaya_id': c[1],
              'nom_fr': c[2],
              'nom_ar': c[3],
            }, conflictAlgorithm: ConflictAlgorithm.ignore);
          }
        });
      }
    }
    _isSeeded = true;
  }
}
