# SQLServerのテーブルに自動的にダミーデータを追加します。
## サンプル実行結果 - Sample Execution Results
![SampleResult](https://github.com/nakm2021/SQLServerDynamicAddDummyData/assets/79841952/b9134703-badd-455a-bb66-7f815138c4a8)
### ＊＊＊Japanese＊＊＊
### まずは、「SQLServerDynamicAddDummyData.sql」をSSMS（SqlServerManagementStudio）で開いて下さい。
### テーブルに指定した件数分ダミーデータを動的に追加します。「Require Input Parameters」に条件を指定してください。
### データ追加中に主キー重複エラーが発生した場合は想定内エラーのため再度実行してください。
### 
### @DataAddCount：追加したいデータ件数
### @TableName：追加したいテーブル名
### @TestFlg：動作確認フラグ。実行の確認には「0」、データ追加を実際に行いたい場合は、「1」を設定
### 
### ***English Follow***
### First, open "SQLServerDynamicAddDummyData.sql" in SSMS (SqlServerManagementStudio).
### Dynamically adds dummy data for the specified number of items to the table. Please specify the conditions in "Require Input Parameters".
### If a primary key duplication error occurs while adding data, please try again as it is an expected error.### 
### @DataAddCount: Number of data items you want to add
### @TableName: table name you want to add
### @TestFlg: Operation check flag. Set "0" to confirm execution, and "1" if you want to actually add data.
