const createTableQuestao = '''
  CREATE TABLE questao(
    id INTEGER PRIMARY KEY,
    numero_questao VARCHAR(10),
    pergunta VARCHAR(600),
    resposta VARCHAR(600),
    feedback VARCHAR(600),
    nota VARCHAR(5),
    pratica_id INTEGER 
  )
''';
