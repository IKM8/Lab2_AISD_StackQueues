PROGRAM StackQueues;
{
  PascalABC.NET 4.0
  Группа ПС-21. Габдуллин Марат
  2 Лабораторная работа
  Вариант 15.
  Организовать в основной памяти с помощью указателей стек из очередей.
  Обеспечить операции ведения очереди из вершины стека, расширения и
  сокращения стека, выдачи содержимого стека (9).
  Источники:
}

TYPE
  QPtr = ^QNode;
  QNode = RECORD
            Key: CHAR;
            Next: QPtr;
          END;

  Queue = RECORD
            Head, Tail: QPtr;
          END;

  SPtr = ^SNode;
  SNode = RECORD
            Q: Queue;
            Next: SPtr;
          END;

VAR
  Top: SPtr;
  FileName, Line: STRING;
  Ans, Ch: CHAR;
  I: INTEGER;
  Again: BOOLEAN;

{ делает очередь пустой }
PROCEDURE MakeEmpty(VAR Q: Queue);
BEGIN
  Q.Head := NIL;
  Q.Tail := NIL;
END;

{ ставит элемент в конец очереди }
PROCEDURE Enqueue(VAR Q: Queue; C: CHAR);
VAR
  P: QPtr;
BEGIN
  NEW(P);
  P^.Key := C;
  P^.Next := NIL;
  IF Q.Head = NIL THEN
    Q.Head := P
  ELSE
    Q.Tail^.Next := P;
  Q.Tail := P;
END;

{ извлекает элемент из начала очереди }
FUNCTION Dequeue(VAR Q: Queue; VAR C: CHAR): BOOLEAN;
VAR
  P: QPtr;
BEGIN
  IF Q.Head = NIL THEN
    Dequeue := FALSE
  ELSE
  BEGIN
    C := Q.Head^.Key;
    P := Q.Head;
    Q.Head := Q.Head^.Next;
    IF Q.Head = NIL THEN
      Q.Tail := NIL;
    DISPOSE(P);
    Dequeue := TRUE;
  END;
END;

{ очищает очередь }
PROCEDURE ClearQueue(VAR Q: Queue);
VAR
  P: QPtr;
BEGIN
  WHILE Q.Head <> NIL DO
  BEGIN
    P := Q.Head;
    Q.Head := Q.Head^.Next;
    DISPOSE(P);
  END;
  Q.Tail := NIL;
END;

{ расширение стека: новая пустая очередь на вершину }
PROCEDURE PushStack;
VAR
  P: SPtr;
BEGIN
  NEW(P);
  MakeEmpty(P^.Q);
  P^.Next := Top;
  Top := P;
END;

{ сокращение стека: убрать верхнюю очередь }
PROCEDURE PopStack;
VAR
  P: SPtr;
BEGIN
  IF Top <> NIL THEN
  BEGIN
    P := Top;
    Top := Top^.Next;
    ClearQueue(P^.Q);
    DISPOSE(P);
  END;
END;

{ выдача содержимого стека }
PROCEDURE ShowStack;
VAR
  S: SPtr;
  Q: QPtr;
BEGIN
  IF Top = NIL THEN
    WRITELN('Стек пуст.')
  ELSE
  BEGIN
    S := Top;
    WHILE S <> NIL DO
    BEGIN
      WRITE('Очередь: ');
      Q := S^.Q.Head;
      WHILE Q <> NIL DO
      BEGIN
        WRITE(Q^.Key, ' ');
        Q := Q^.Next;
      END;
      WRITELN;
      S := S^.Next;
    END;
  END;
END;

{ загрузка начальных очередей из файла: каждая строка - одна очередь }
PROCEDURE LoadFromFile(FileName: STRING);
VAR
  F: TEXT;
  S: STRING;
  J: INTEGER;
BEGIN
  ASSIGN(F, FileName);
  TRY
    RESET(F);
  EXCEPT
    WRITELN('Не удалось открыть файл!');
    HALT(1);
  END;

  WHILE NOT EOF(F) DO
  BEGIN
    READLN(F, S);
    PushStack;
    FOR J := 1 TO LENGTH(S) DO
      Enqueue(Top^.Q, S[J]);
  END;
  CLOSE(F);
END;

BEGIN
  Top := NIL;

  WRITE('Введите имя входного файла: ');
  READLN(FileName);
  LoadFromFile(FileName);

  Again := TRUE;
  WHILE Again DO
  BEGIN
    WRITELN;
    WRITELN('1 - добавить элемент в очередь на вершине стека');
    WRITELN('2 - извлечь элемент из очереди на вершине стека');
    WRITELN('3 - расширить стек (добавить пустую очередь)');
    WRITELN('4 - сократить стек (убрать верхнюю очередь)');
    WRITELN('5 - показать содержимое стека');
    WRITELN('6 - выход');
    WRITE('Ваш выбор: ');
    READLN(Ans);

    IF Ans = '1' THEN
    BEGIN
      IF Top = NIL THEN
        WRITELN('Стек пуст, сначала расширьте его.')
      ELSE
      BEGIN
        WRITE('Введите строку: ');
        READLN(Line);
        FOR I := 1 TO LENGTH(Line) DO
          Enqueue(Top^.Q, Line[I]);
      END;
    END
    ELSE IF Ans = '2' THEN
    BEGIN
      IF Top = NIL THEN
        WRITELN('Стек пуст.')
      ELSE IF Dequeue(Top^.Q, Ch) THEN
        WRITELN('Извлечён элемент: ', Ch)
      ELSE
        WRITELN('Очередь на вершине пуста.');
    END
    ELSE IF Ans = '3' THEN
      PushStack
    ELSE IF Ans = '4' THEN
    BEGIN
      IF Top = NIL THEN
        WRITELN('Стек пуст.')
      ELSE
        PopStack;
    END
    ELSE IF Ans = '5' THEN
      ShowStack
    ELSE IF Ans = '6' THEN
      Again := FALSE
    ELSE
      WRITELN('Неверный выбор.');
  END;

  { очистка памяти }
  WHILE Top <> NIL DO
    PopStack;
END.
