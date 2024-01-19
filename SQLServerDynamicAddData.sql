/*
	#Japanese
	テーブルに指定した件数分ダミーデータを動的に追加します。「Require Input Parameters」に条件を指定してください。
	データ追加中に主キー重複エラーが発生した場合は想定内エラーのため再度実行してください。
	文字列（char、varchar、nchar、nvarchar）項目の最大文字列8000文字以上のSQL文の実行は出来ません。（項目の大きいテーブルが該当します。）

	@DataAddCount：追加したいデータ件数
	@TableName：追加したいテーブル名
	@TestFlg：動作確認フラグ。実行の確認には「0」、データ追加を実際に行いたい場合は、「1」を設定

	#English Follow
	Dynamically adds dummy data for the specified number of items to the table. Please specify the conditions in "Require Input Parameters".
	If a primary key duplication error occurs while adding data, please try again as it is an expected error.
	SQL statements with a string (char, varchar, nchar, nvarchar) item that has a maximum string of 8000 characters or more cannot be executed. (This applies to tables with large items.)

	@DataAddCount: Number of data items you want to add
	@TableName: table name you want to add
	@TestFlg: Operation check flag. Set "0" to confirm execution, and "1" if you want to actually add data.
*/
BEGIN TRANSACTION

-- Require Input Parameters
DECLARE @DataAddCount AS bigint = 10
DECLARE @TableName AS varchar(255) = 'Menu'
DECLARE @TestFlg AS int = 1
-- Require Input Parameters

DECLARE @TableDtName AS varchar(255) = @TableName + '_Dt'
DECLARE @val_name AS varchar(255) = ''
DECLARE @val_column_id AS int = 0
DECLARE @val_user_type_id AS varchar(255) = ''
DECLARE @val_max_length int = 0
DECLARE @val_precision AS int = 0
DECLARE @val_scale AS int = 0
DECLARE @i AS bigint = 0
DECLARE @ExecCmd AS varchar(max) = ''
DECLARE @CharSet AS varchar(255) = '''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!"#$%&()-=^~\|@`[{;+:*]},<.>/?_'''
DECLARE @CharCount AS int = 0
DECLARE @TmpTbl AS table
(
	val_name varchar(255) null,
	val_column_id int null,
	val_user_type_id varchar(255) null,
	val_max_length int null,
	val_precision int null,
	val_scale int null
)

EXEC('DROP TABLE IF EXISTS ' + @TableDtName)
EXEC('SELECT TOP 0 * INTO ' + @TableDtName + ' FROM ' + @TableName)
DECLARE cs CURSOR LOCAL FOR 
SELECT
	C.name,
	C.column_id,
	TYPE_NAME(C.user_type_id) AS user_type_id,
	C.max_length,
	C.precision,
	C.scale
FROM sys.tables T
INNER JOIN sys.columns C
ON T.object_id = C.object_id
WHERE T.name = @TableName
ORDER BY C.column_id
OPEN cs
FETCH NEXT FROM cs
INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO @TmpTbl
	SELECT @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale
	FETCH NEXT FROM cs 
	INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale
END
CLOSE cs
DEALLOCATE cs

WHILE @i < @DataAddCount
BEGIN
	SET @i = @i + 1
	DECLARE cs CURSOR LOCAL FOR
	SELECT
	val_name,val_column_id,val_user_type_id,val_max_length,val_precision,val_scale
	FROM @TmpTbl
	ORDER BY val_column_id
	OPEN cs
	FETCH NEXT FROM cs
	INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @val_column_id = 1
			SET @ExecCmd = 'INSERT INTO ' + @TableDtName + ' VALUES('
		ELSE
			SET @ExecCmd = @ExecCmd + ','

		IF @val_user_type_id = 'bigint'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 999999999999999999 AS bigint)'
		IF @val_user_type_id = 'binary'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 99999 AS binary)'
		IF @val_user_type_id = 'bit'
			SET @ExecCmd = @ExecCmd + 'CAST(0 AS bit)'
		IF @val_user_type_id = 'char' OR @val_user_type_id = 'nchar' OR @val_user_type_id = 'nvarchar' OR @val_user_type_id = 'varchar'
		BEGIN
			IF @val_max_length = -1
			BEGIN
				SET @CharCount = 1
				SET @ExecCmd = @ExecCmd + 'SUBSTRING(' + @CharSet + ',CONVERT(int,CEILING(RAND() * ' + STR(LEN(@CharSet)) + ')),255)'
			END
			IF @val_max_length <> -1
			BEGIN
				WHILE @CharCount < @val_max_length - 1
				BEGIN
					SET @CharCount = @CharCount + 1
					SET @ExecCmd = @ExecCmd + 'SUBSTRING(' + @CharSet + ',CONVERT(int,CEILING(RAND() * ' + STR(LEN(@CharSet)) + ')),1) + '
				END
				BEGIN
					SET @CharCount = 1
					SET @ExecCmd = @ExecCmd + 'SUBSTRING(' + @CharSet + ',CONVERT(int,CEILING(RAND() * ' + STR(LEN(@CharSet)) + ')),1)'
				END
			END
		END
		IF @val_user_type_id = 'datetime'
			SET @ExecCmd = @ExecCmd + 'GETDATE()'
		IF @val_user_type_id = 'datetimeoffset'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS datetimeoffset)'
		IF @val_user_type_id = 'decimal'
			IF @val_precision = 0 AND @val_scale = 0
				SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 999999999999999 AS decimal)'
			ELSE
			BEGIN
				IF @val_scale = 0
					SET @ExecCmd = @ExecCmd + 'CAST(RAND() * ' + STR(@val_precision) + 'AS decimal(' + STR(@val_precision) + ',' + STR(@val_scale) + '))'
				ELSE
				BEGIN
					IF @val_precision <= 9
						SET @ExecCmd = @ExecCmd + 'CAST(RAND() * ' + STR(@val_precision) + ' AS decimal(' + STR(@val_precision) + ',' + STR(@val_scale) + '))'
					ELSE
						SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 9999 AS decimal(' + STR(@val_precision) + ',' + STR(@val_scale) + '))'
				END
			END
		IF @val_user_type_id = 'float'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 9999 AS float)'
		IF @val_user_type_id = 'image'
			SET @ExecCmd = @ExecCmd + 'CAST(NULL AS image)'
		IF @val_user_type_id = 'int'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 2147483646 AS int)'
		IF @val_user_type_id = 'smallint'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 32766 AS smallint)'
		IF @val_user_type_id = 'sql_variant'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 9999999999999 AS sql_variant)'
		IF @val_user_type_id = 'sysname'
			SET @ExecCmd = @ExecCmd + 'CAST(NULL AS sysname)'
		IF @val_user_type_id = 'tinyint'
			SET @ExecCmd = @ExecCmd + 'CAST(FLOOR(RAND() * 9) AS tinyint)'
		IF @val_user_type_id = 'uniqueidentifier'
			SET @ExecCmd = @ExecCmd + 'CAST(NULL AS uniqueidentifier)'
		IF @val_user_type_id = 'varbinary'
			SET @ExecCmd = @ExecCmd + 'CAST(NULL AS varbinary)'
		FETCH NEXT FROM cs
		INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale
	END
	SET @ExecCmd = @ExecCmd + ')'
	CLOSE cs
	DEALLOCATE cs
	BEGIN TRY
		EXEC(@ExecCmd)
	END TRY
	BEGIN CATCH
		PRINT 'ERROR_NUMBER : ' + STR(ERROR_NUMBER())
		PRINT 'ERROR_SEVERITY : ' + STR(ERROR_SEVERITY())
		PRINT 'ERROR_STATE : ' + STR(ERROR_STATE())
		PRINT 'ERROR_MESSAGE : ' + ERROR_MESSAGE()
	END CATCH
	PRINT @i
	PRINT @ExecCmd
END

BEGIN TRY
	EXEC('INSERT INTO ' + @TableName + ' SELECT * FROM ' + @TableDtName)
	EXEC('SELECT * FROM ' + @TableDtName)
END TRY
BEGIN CATCH
	PRINT 'ERROR_NUMBER : ' + STR(ERROR_NUMBER())
	PRINT 'ERROR_SEVERITY : ' + STR(ERROR_SEVERITY())
	PRINT 'ERROR_STATE : ' + STR(ERROR_STATE())
	PRINT 'ERROR_MESSAGE : ' + ERROR_MESSAGE()
END CATCH
IF @TestFlg = 0
	ROLLBACK TRANSACTION
IF @TestFlg = 1
BEGIN
	EXEC('DROP TABLE ' + @TableDtName)
	COMMIT TRANSACTION
END