/*
	#Japanese
	テーブルに指定した件数分ダミーデータを動的に追加します。「Require Input Parameters」に条件を指定してください。
	データ追加中に主キー重複エラーが発生した場合は想定内エラーのため再度実行してください。

	@DataAddCount：追加したいデータ件数
	@TableName：追加したいテーブル名
	@TestFlg：動作確認フラグ。実行の確認には「0」、データ追加を実際に行いたい場合は、「1」を設定

	#English Follow
	Dynamically adds dummy data for the specified number of items to the table. Please specify the conditions in "Require Input Parameters".
	If a primary key duplication error occurs while adding data, please try again as it is an expected error.

	@DataAddCount: Number of data items you want to add
	@TableName: table name you want to add
	@TestFlg: Operation check flag. Set "0" to confirm execution, and "1" if you want to actually add data.

	MIT License

	Copyright (c) 2024 Nakamoto Masakuni

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/
BEGIN TRANSACTION

-- Require Input Parameters
DECLARE @DataAddCount AS bigint = 100
DECLARE @TableName AS varchar(255) = 'MST_Customer'
DECLARE @TestFlg AS int = 1
-- Require Input Parameters

DECLARE @val_name AS varchar(255) = ''
DECLARE @val_column_id AS int = 0
DECLARE @val_user_type_id AS varchar(255) = ''
DECLARE @val_max_length int = 0
DECLARE @val_precision AS int = 0
DECLARE @val_scale AS int = 0
DECLARE @val_is_identity AS int = 0
DECLARE @val_is_nullable AS int = 0
DECLARE @i AS bigint = 0
DECLARE @ExecCmd AS varchar(max) = ''
DECLARE @CharSet AS varchar(255) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!"#$%&()-=^~\|@`[{;+:*]},<.>/?_ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｬｭｮ'
DECLARE @CharDoubleByteSet AS varchar(max) = 'ぁぃぅぇぉがぎぐげござじずぜぞっだぢづでどばびぶべぼぱぴぷぺぽゃゅょゐゑをゎんアイウエオァィゥェォヴカキクケコガギグゲゴヵヶサシスセソザジズゼゾタチツテトッダヂヅデドナニヌネノハヒフヘホバビブベボパピプペポマミムメモヤユヨャュョラリルレロワヰヱヲヮン０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ　、。，．・：；？！゛゜´｀¨＾￣＿ヽ〃仝〆〇‐／＼～∥｜…‥‘“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪†‡¶◯ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡㍻〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼∮∑∟⊿一乙丁七九了二人入八刀力十又乃丈三上下丸久亡凡刃勺千及口土士夕大女子寸小山川工己干弓才万与之也巳不中丹乏屯互五井仁仏今介元内公六冗凶分切刈匁化匹区升午厄友反円天太夫孔少尺幻弔引心戸手支収文斗斤方日月木止比毛氏水火父片牛犬王欠予双丑允巴且世丘丙主付仕仙他代令以兄冊冬凹凸出刊功加包北半占去古句召可史右司囚四圧外央失奴写尼左巧巨市布平幼広庁必打払斥未本札正母民永氷汁犯玄玉甘生用田由甲申白皮皿目矛矢石示礼穴立台旧処号弁込辺卯只叶弘旦汀交仰仲件任企伏伐休仮伝充兆先光全両共再刑列劣匠印危叫各合吉同名后吏吐向回吸因団在地壮多好如妃妄存字宅宇守安寺州帆年式忙成扱收旨早旬曲会有朱机朽朴次死毎気汚江池汗灰灯争当百尽竹米糸缶羊羽老考耳肉肌自至舌舟色芝芋虫血行衣西弐巡迅丞亘亙亥亦伊伍伎凪匡圭庄旭汐乱亜来伯伴伸伺似位但低住佐何作佛克児兵冷初判別利助努労励却即卵君否含呈呉吹告吟困囲図坂均坊坑壱壯寿妊妙妥妨孝完対尾尿局岐希床序廷弟形役忌忍志忘快応我戒戻扶批技抄抑投抗折抜択把改攻更材杉村条束求決汽沈没沖沢災状狂男町社秀私究系声肖肝臣良花芳芸見角言谷豆貝売赤走足身車辛迎近返邦医里防余体麦亨伶伽佑冴冶吾呂宏李杏杜汰沙玖甫芙芹辰邑那酉乳事亞享京佳使例侍供依価侮併來免兒具典到制刷券刺刻効劾卒卓協卷参叔取受周味呼命和固国坪垂夜奉奇奔妹姉妻始姓季委学定宜宗官宙実宝尚居屈届岩岸岳岬幸底店府延弦往彼征径怖忠性怪念房所承抱抵押拙拍拒拓拘抽招拝担拡拠拐披抹拔拂放昇明易昔昆服杯東松板析林枚果枝枢枠欧歩武殴毒河沸油治沼況泊泌法波沿泣注泳泥泡炊炎炉爭版牧物画的盲直知祈祉空突並者肥肩肪肯育肢舎苗若苦英茂茎芽表迭迫述金長門邸邪阻附雨青非斉侃侑尭奈孟弥怜於旺昴昌朋欣苑茉茄茅虎迪采阿乗亭侯侵便係促俗保信俊冠則削前勅勇南卑巻卸厘厚単咲哀品型城垣奏契姻姿威弧客宣室封専屋峠峡帝帥幽度建待律後怒思怠急恒恆恨悔恬挟拷拾持指挑拜叙政故施星映春昨是昼冒枯柄架某染柔査柱柳栄段泉洋洗津活派海浄浅洪洞炭為牲狩狭独珍甚界畑疫発皇皆盆相盾省看砂研砕祖祝神秋科秒窃紀約紅糾級県美耐肺胃背胎胞胆臭茶草荒荘虐衷要計訂変負貞赴軌軍迷追退送逃逆郊郎重限面革音風飛食首香点亮勁哉奎宥彦柊柚柾洲洵洸玲眉祐耶胡胤茜虹衿郁乘修俳俵倣倉個倍倒候借値倫倹俸兼凍准剖剛剤剣勉匿原員哲唆唐唇埋夏娘姫娯娠孫宮宰害宴家容宵射将展峰峽島差師席帯座庫庭弱徐徒従恐恋恭悦恥恩息悟恵悩扇振捕捜挿挙敏料旅既時書朕朗校株核根格栽桃案桑梅桜桟栓帰殉殊残殺氣流浦浮浪浴浸消涙浜泰烈特狹班珠畔留畜畝疾病疲症益真眞眠砲破祥祕秘租秩称笑粉粋紋納純紙紛素紡索翁耕耗胴胸能脂脅脈致航般荷華莊蚊蚕衰被討訓託記財貢起軒辱透逐途通速造連逓逝郡配酒酌針陛院陣除降陥隻飢馬骨高鬼党竜倖倭凌唄啄峻恕悌拳晃晋晏晟朔栗栞桂桐浩矩秦紗紘莉莞赳隼乾偏停健側偶偽偵剰副動勘務唯唱商問啓喝圈國域執培基堂堀婚婆婦宿寂寄密尉將專崇崩崎巣帳常帶庶庸康張強彩彫得從患悪悼情惜惨悠捨掃掛措授排描採掘探接控推掲据教救敗斜断旋族曹晝望械條欲殻液涼淑淡深混清添渇渉渋済涯渓淨猛猟率現球理瓶産略異盛盗眼眺票祭移窓窒章笛符第粒粗粘累紺細紹終組紳経翌習粛脳脚脱船舶菊菌菓菜著虚蛍蛇術袋規視訟訪設許訳豚貧貨販貫責赦軟転逮週進逸部郭郵都郷酔釈野釣閉陪陰陳陵陶険陸隆陷雪頂魚鳥麻黄黒斎偲寅崚彗彪彬惇惟捷捺晨梓梢梧梨毬淳渚爽猪琢皐眸笙笹紬絃脩菖菫萌袈鹿亀傍備偉傘割創剩勝募勤博善喚喜喪喫單圏堤堪報堅場塔塁堕塀塚奥婿媒富寒尊尋就属帽幅幾廃廊弾御復循悲惑愉慌惰惡惠扉掌提揚換握揮援揺搭敢散敬晩普景晴暁晶暑替最朝期棋棒森棺植検極棚棟欺款殖減渡測港湖湯滋温湿満湾渦焼無焦然煮営爲猶琴番畳疎痘痛痢登盜短硝硫硬税程童筆等筋筒答策粧結絶絡絞紫給統絵着腕脹落葉葬蛮衆街裁裂裕補装覚評訴詐診詔詞詠証象貴買貸費貯貿賀超越距軸軽遂遇遊運遍過道達遅都酢量鈍開閑間陽隊階随隅雄集雇雲雰順項飲飯黑歯凱喬媛嵐巽惣敦斐智椋椎欽渥猪湧琳瑛皓禄稀竣絢翔萩葵遥須催傑債傷傾働僧傳勢勧嗣嘆園塊塑塗墓夢奨奧嫁嫌寝寛幕幹廉微慎愼慨想愁意愚愛感慈戦損搬携搾摂搖搜数新暇暖暗業楽棄楼歳殿源準溶滅滑滞漢滝溝漠煙照煩献猿痴盟睡督碁碎碑禍福禁禅稚節絹継続罪置署群義聖腹腰腸艇蒸蓄虜虞裏裸褐裝解触該試詩詰話詳誇誠誉豊賃資賄賊跳跡践路載較辞農遠遣違酪酬鈴鉛鉄鉱鉢隔雅零雷電靴預頒頑飼飾飽塩鼓嵩嵯暉椰椿楊楓楠滉瑚瑞瑶睦禎祿稔稜舜蒔蒼蓉蓮裟詢靖頌鳩像僚僕僞團境増墨塾奬奪嫡察寧寢壽層彰徳徴慢態慕慣憎摘旗暮暦構模概様歌歴漁漆漸滴漂漫漏演漬滯獄疑盡磁福種稲端管箇算精粹維綱網綿緑綠緒練総罰聞腐膜與複製語誤誌誓説認誘読豪踊遭適遮酵酷酸銀銃銑銅銘銭閣閥関際障隠雑雌需静領駆駅駄髪魂鳴鼻齊嘉暢榛槙樺漱熊爾瑠瑳碧碩綜綸綺綾緋翠聡肇蔦輔颯魁鳳億儀價儉劇劍勲噴器嘱墜墳增審寮導履幣廣弊彈影徹德憤慰慶憂戯撮撤摩撲撃敵敷暴暫標横権槽樂樣歓潔潤澄潮潜潟澁熟盤監確稿穂稼稻窮窯箱範緩線編締緊縄緖罷舗舞蔵衝褒課請談調論誕諸諾謁賓賜賠賦質賞賛賣趣踏輪輩輝遷遺遵選醉鋭鋳閲震霊養餓駐髮魅黙凜嬉慧憧槻毅熙璃蕉蝶誼諄諒遼醇駒黎儒凝勳壇墾壁壊壌奮嬢憲憶憾憩懐戰擁操整曇曉機橋樹橫激濁濃燃燒燈獲獣磨積穏築篤糖縛縦縫緯繁縣膨興薪薦薄薫薬融衡衛衞親諮謀諭謡諸賢頼輸還避鋼錯錘錠録錬隣險隷靜頭館默龍叡橘澪燎蕗錦鮎黛償優厳嚇懇應戲擬擦檢濯濕燥爵犠環療矯礁禪穗縮績繊縱翼聴薰覧謙講謝謹謠謄購轄醜鍛霜頻鮮齢嶺彌曙檀燦瞭瞳磯霞鞠駿鴻壘懲曜濫癖癒瞬礎穫簡糧織繕繭藥藝藏職臨藩襟観贈鎖鎭難雜額顔題類顕翻騎騒験闘燿穣藍藤鎌雛鯉麿壞懷瀬瀨爆獸璽繰臓羅藻覇識譜警鏡離霧韻願髄鯨鶏麗艶蘭鯛鵬嚴孃懸欄競籍議護譲醸鐘響騰騷巌耀馨攝櫻纎艦躍露顧飜魔鷄鶴疊聽臟襲覽鑄驚穰鑑顯驗巖讓釀鷹麟廳あ挨曖宛い畏萎椅彙茨咽淫う鬱え怨縁お岡臆俺か苛寡牙瓦楷潰諧崖蓋骸柿顎括葛釜韓玩き毀畿臼嗅巾僅く惧串窟け詣憬稽隙桁鍵舷こ股孤錮勾梗喉乞傲穀頃痕さ挫塞埼柵刹拶斬し恣摯餌嫉腫呪袖羞蹴昭拭尻芯腎す裾せ凄醒脊戚煎羨腺詮箋膳そ狙遡曽痩踪捉遜た唾堆戴誰綻ち緻酎貼嘲捗鎮つ爪て諦溺塡と妬賭栃頓貪丼な謎鍋に匂ね熱捻のは罵剝箸氾汎阪斑ひ膝肘猫ふ阜訃膚覆へ蔽餅璧蔑ほ哺簿蜂貌頰勃ま昧枕末み蜜むめ冥麺もや闇ゆ喩よ妖瘍沃ら拉辣り慄侶慮るれろ賂弄籠麓わ脇鯏鯵鯇鮑魦鯔鯆鰯鮇鯎鱓鰻鱏鱛鰕鰧鰍鰹鱟魳鰈鮍鱚鯒鮗鮴鮭鯯鯖鮫鱵鰆鯢鱪鯱鮊鯳鱸鯐鮬鰖鰱鮹魛鱈鱘鱅鰌鯰鰊鮸鯊鰣鰰魬鱧鮠鰚鰉鯷鮃鰭鱶鰒鮒鰤鮪鱒鮲鯧鯥鰘鰙鰐'
DECLARE @CharCount AS int = 0
DECLARE @Char AS varchar(2) = ''
DECLARE @TmpTbl AS table
(
	val_name varchar(255) null,
	val_column_id int null,
	val_user_type_id varchar(255) null,
	val_max_length int null,
	val_precision int null,
	val_scale int null,
	val_is_identity int null,
	val_is_nullable int null
)
DECLARE cs CURSOR LOCAL FOR 
SELECT
	C.name,
	C.column_id,
	TYPE_NAME(C.user_type_id) AS user_type_id,
	C.max_length,
	C.precision,
	C.scale,
	C.is_identity,
	C.is_nullable
FROM sys.tables T
INNER JOIN sys.columns C
ON T.object_id = C.object_id
WHERE T.name = @TableName
ORDER BY C.column_id
OPEN cs
FETCH NEXT FROM cs
INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO @TmpTbl
	SELECT @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
	FETCH NEXT FROM cs 
	INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
END
CLOSE cs
DEALLOCATE cs

WHILE @i < @DataAddCount
BEGIN
	SET @i = @i + 1
	DECLARE cs CURSOR LOCAL FOR
	SELECT
	val_name,val_column_id,val_user_type_id,val_max_length,val_precision,val_scale,val_is_identity,val_is_nullable
	FROM @TmpTbl
	ORDER BY val_column_id
	OPEN cs
	FETCH NEXT FROM cs
	INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @val_column_id = 1
		BEGIN
			SET @ExecCmd = 'INSERT INTO ' + @TableName + ' VALUES('
			IF @val_is_identity = 1
			BEGIN
				FETCH NEXT FROM cs
				INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
			END
		END
		ELSE
			SET @ExecCmd = @ExecCmd + ','
		IF @val_is_identity = 1
		BEGIN
			FETCH NEXT FROM cs
			INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
		END
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
				SELECT @Char = SUBSTRING(@CharSet,CONVERT(int,CEILING(RAND() * LEN(@CharSet))),255)
				SET @ExecCmd = @ExecCmd + @Char
			END
			IF @val_max_length <> -1
			BEGIN
				SET @ExecCmd = @ExecCmd + ''''
				IF @val_user_type_id = 'nchar' OR @val_user_type_id = 'nvarchar'
					SET @val_max_length = ROUND(@val_max_length / 2,0)
				WHILE @CharCount < @val_max_length - 1
				BEGIN
					IF @val_user_type_id = 'nchar' OR @val_user_type_id = 'nvarchar'
						SELECT @Char = CAST(SUBSTRING(@CharDoubleByteSet,CONVERT(int,CEILING(RAND() * LEN(@CharDoubleByteSet))),1) AS varchar)
					ELSE
						SELECT @Char = SUBSTRING(@CharSet,CONVERT(int,CEILING(RAND() * LEN(@CharSet))),1)
					SET @CharCount = @CharCount + 1
					SET @ExecCmd = @ExecCmd + @Char
				END
				BEGIN
					IF @val_user_type_id = 'nchar' OR @val_user_type_id = 'nvarchar'
						SELECT @Char = CAST(SUBSTRING(@CharDoubleByteSet,CONVERT(int,CEILING(RAND() * LEN(@CharDoubleByteSet))),1) AS varchar)
					ELSE
						SELECT @Char = SUBSTRING(@CharSet,CONVERT(int,CEILING(RAND() * LEN(@CharSet))),1)
					SET @CharCount = 1
					SET @ExecCmd = @ExecCmd + @Char + ''''
				END
			END
		END
		IF @val_user_type_id = 'datetime'
			SET @ExecCmd = @ExecCmd + 'GETDATE()'
		IF @val_user_type_id = 'datetimeoffset'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS datetimeoffset)'
		IF @val_user_type_id = 'decimal' OR @val_user_type_id = 'numeric'
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
			SET @ExecCmd = @ExecCmd + 'CAST(CAST(RAND() * 9999 AS varchar) AS image)'
		IF @val_user_type_id = 'int'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 2147483646 AS int)'
		IF @val_user_type_id = 'smallint'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 32766 AS smallint)'
		IF @val_user_type_id = 'sql_variant'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 9999999999999 AS sql_variant)'
		IF @val_user_type_id = 'sysname'
			SET @ExecCmd = @ExecCmd + 'TYPE_NAME(1)'
		IF @val_user_type_id = 'tinyint'
			SET @ExecCmd = @ExecCmd + 'CAST(FLOOR(RAND() * 9) AS tinyint)'
		IF @val_user_type_id = 'uniqueidentifier'
			SET @ExecCmd = @ExecCmd + 'NEWID()'
		IF @val_user_type_id = 'varbinary'
			SET @ExecCmd = @ExecCmd + 'CAST(CAST(RAND() * 9999 AS varchar) AS varbinary)'
		IF @val_user_type_id = 'money'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 922337203685477.5806  AS money)'
		IF @val_user_type_id = 'smallmoney'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 214748.3646 AS smallmoney)'
		IF @val_user_type_id = 'real'
			SET @ExecCmd = @ExecCmd + 'CAST(RAND() * 999999.9999 AS real)'
		IF @val_user_type_id = 'date'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS date)'
		IF @val_user_type_id = 'datetime2'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS datetime2)'
		IF @val_user_type_id = 'smalldatetime'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS smalldatetime)'
		IF @val_user_type_id = 'time'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS time)'
		IF @val_user_type_id = 'timestamp'
			SET @ExecCmd = @ExecCmd + 'CAST(GETDATE() AS timestamp)'
		IF @val_user_type_id = 'text'
			SET @ExecCmd = @ExecCmd + 'CAST(CAST(RAND() * 9999 AS varchar) AS text)'
		IF @val_user_type_id = 'ntext'
			SET @ExecCmd = @ExecCmd + 'CAST(CAST(RAND() * 9999 AS varchar) AS ntext)'
		IF @val_user_type_id = 'geography'
			SET @ExecCmd = @ExecCmd + 'geography::Point(CAST(RAND() * 90 AS float),CAST(RAND() * 90 AS float), (SELECT TOP 1 spatial_reference_id FROM sys.spatial_reference_systems))'
		IF @val_user_type_id = 'geometry'
			SET @ExecCmd = @ExecCmd + 'geometry::STGeomFromText(''POLYGON ((0 0, ' + CAST(CAST(RAND() * 150 AS int) AS varchar) + ' 0, ' + CAST(CAST(RAND() * 150 AS int) AS varchar) + ' 150, 0 150, 0 0))'', RAND() * 9999)'
		IF @val_user_type_id = 'hierarchyid'
			SET @ExecCmd = @ExecCmd + 'CAST(''/''+ CAST(CAST(RAND() * 99 AS int) AS varchar) + ''/'' + CAST(CAST(RAND() * 99 AS int) AS varchar) + ''/'' AS hierarchyid)'
		IF @val_user_type_id = 'xml'
		BEGIN
			IF @val_is_nullable <> 1
				RAISERROR (15600, -1, -1, 'xml型はNULL許容型に変更してください。(Change the xml type to a nullable type.)');
			ELSE
				SET @ExecCmd = @ExecCmd + 'NULL'
		END
		FETCH NEXT FROM cs
		INTO @val_name,@val_column_id,@val_user_type_id,@val_max_length,@val_precision,@val_scale,@val_is_identity,@val_is_nullable
	END
	SET @ExecCmd = @ExecCmd + ')'
	CLOSE cs
	DEALLOCATE cs
	BEGIN TRY
		BEGIN TRANSACTION
			EXEC(@ExecCmd)
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		PRINT 'ERROR_NUMBER : ' + STR(ERROR_NUMBER())
		PRINT 'ERROR_SEVERITY : ' + STR(ERROR_SEVERITY())
		PRINT 'ERROR_STATE : ' + STR(ERROR_STATE())
		PRINT 'ERROR_MESSAGE : ' + ERROR_MESSAGE()
		PRINT N'--- 実行SQL文 (Executable SQL Statement) ---'
		PRINT @ExecCmd
		PRINT N'--------------------------------------------'
		ROLLBACK TRANSACTION;
		THROW;
	END CATCH
	PRINT N'--- 処理件数と実行SQL文 (Processing count and execution SQL statement) ---'
	PRINT @i
	PRINT @ExecCmd
	PRINT N'--------------------------------------------------------------------------'
END
IF @TestFlg = 0
	ROLLBACK TRANSACTION
IF @TestFlg = 1
BEGIN
	PRINT '                                                                         '
	PRINT ' ■■■■      ■     ■      ■■■■       ■■■■      ■■■■■      ■■■■       ■■■■  '
	PRINT ' ■   ■     ■     ■     ■   ■■     ■   ■■     ■          ■   ■      ■   ■ '
	PRINT ' ■         ■     ■    ■          ■           ■          ■          ■     '
	PRINT '  ■■■      ■     ■    ■          ■           ■■■■■       ■■■        ■■■  '
	PRINT '     ■     ■     ■    ■          ■           ■              ■          ■ '
	PRINT '　■   ■　    ■■   ■■    ■     ■    ■     ■     ■         ■■   ■      ■   ■ '
	PRINT ' ■   ■      ■   ■      ■   ■      ■   ■      ■■■■■■     ■   ■      ■   ■ '
	PRINT '  ■■■■       ■■■        ■■■        ■■■                   ■■■■       ■■■■ '
	COMMIT TRANSACTION
END