Class EPRmeta.Quality.QualityOrderInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxDictionaryID On DictionaryID;

Index IdxOrderDictionaryID On (OrderID, DictionaryID) [ Unique ];

Property OrderID As %String(TRUNCATE = 1);

Property OrderName As %String(TRUNCATE = 1);

Property DictionaryID As %String(TRUNCATE = 1);

Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0);

/// ModifyDate: 2012-07-17
/// ModifyDesc:	将医嘱按名称排序
Query SELECTALL() As %Library.SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityOrder_SELECTALL, SqlProc ]
{
	SELECT o.%Id, o.OrderID, o.OrderName, o.DictionaryID, d.Name DictionaryName,o.IsActive, o.ResumeText
	FROM EPRmeta_Quality.QualityOrderInfo o
	INNER JOIN EPRmeta_Quality.QualityDictionary d
	ON d.ID = o.DictionaryID
	ORDER BY d.Name,o.OrderID
}

Storage Default
{
<Data name="QualityOrderInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderID</Value>
</Value>
<Value name="3">
<Value>OrderName</Value>
</Value>
<Value name="4">
<Value>DictionaryID</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityOrderD</DataLocation>
<DefaultData>QualityOrderInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityOrderD</IdLocation>
<IndexLocation>^DHCEPRM.QualityOrderI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// Desc:       初始化低风险病种诊断
///            (需要现在质控维护程序——》基础字典维护——》医嘱类型中维护 代码：LowRisk 描述：低风险诊断)
/// Creator:    hky
/// CreateDate: 2022-11-15
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EPRmeta.Quality.QualityOrderInfo).InitLowRiskDiseases()
ClassMethod InitLowRiskDiseases()
{
	s ret=0
	s LowRiskDicID=$o(^DHCEPRM.QualityDicI("IdxCode","LowRisk",""))
	q:(LowRiskDicID="") ret
	q:($d(^DHCEPRM.QualityOrderI("IdxDictionaryID"," "_LowRiskDicID))=10) ret
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','A18','其他器官的结核','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','B00','疱疹病毒[单纯疱疹]感染','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','B02','带状疱疹','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','B08','其他以皮肤和粘膜损害为特征的病毒性感染，不可归类在他处者','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','B18','慢性病毒性肝炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','C73','甲状腺恶性肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D13','消化系统其他和不明确部位的良性肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D16','骨和关节软骨良性肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D17','良性脂肪瘤样肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D18','血管瘤和淋巴管瘤，任何部位','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D24','乳房良性肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D25','子宫平滑肌瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D27','卵巢良性肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D36','其他和未特指部位的良性肿瘤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D50','缺铁性贫血','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','D69','紫癜和其他出血性情况','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','E05','甲状腺毒症（甲状腺功能亢进症）','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','E07','甲状腺的其他疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','E10','胰岛素依赖型糖尿病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','E11','非胰岛素依赖型糖尿病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','G40','癫痫','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','G45','短暂性大脑缺血性发作和相关的综合征','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H02','眼睑的其他疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H1l','结膜的其他疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H25','老年性白内障','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H26','其他白内障','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H33','视网膜脱离和断裂','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H40','青光眼','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H81','前庭功能疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','H91','其他听觉丧失','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I10','特发性（原发性）高血压','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I20','心绞痛','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I47','阵发性心动过速','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I70','动脉粥样硬化','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I80','静脉炎和血栓性静脉炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I83','下肢静脉曲张','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I84','痔','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I86','其他部位的静脉曲张','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','I87','静脉的其他疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J04','急性喉炎和气管炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J06','多发性和未特指部位的急性上呼吸道感染','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J20','急性支气管炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J21','急性细支气管炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J32','慢性鼻窦炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J33','鼻息肉','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J34','鼻和鼻窦的其他疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J35','扁桃体和腺样体慢性疾病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J38','声带和喉疾病，不可归类在他处者','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J40','支气管炎，未特指为急性或慢性','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','J45','哮喘','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K11','涎腺疾病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K12','口炎和有关损害','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K21','胃-食管反流性疾病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K22','食管的其他疾病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K25','胃溃疡','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K29','胃炎和十二指肠炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K31','胃和十二指肠的其他疾病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K35','急性阑尾炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K40','腹股沟疝','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K52','其他非感染性胃肠炎和结肠炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K60','肛门及直肠区的裂和瘘','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K61','肛门和直肠区脓肿','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K63','肠的其他疾病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','K80','胆石症','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','L08','皮肤和皮下组织其他局部感染','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M06','其他类风湿性关节炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M13','其他关节炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M17','膝关节病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M47','脊椎关节强硬','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M48','其他脊椎病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M51','其他椎间盘疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M79','其他软组织疾患，不可归类在他处者','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','M87','骨坏死','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N02','复发性和持续性血尿','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N04','肾病综合征','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N10','急性肾小管-间质肾炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N13','梗阻性和反流性尿路病','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N20','肾和输尿管结石','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N40','前列腺增生','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N43','鞘膜积液和精子囊肿','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N45','睾丸炎和附睾炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N80','子宫内膜异位症','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','N83','卵巢、输卵管和阔韧带的非炎性疾患','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O00','异位妊娠','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O02','受孕的其他异常产物','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O20','妊娠早期出血','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O26','为主要与妊娠有关的其他情况给予的孕产妇医疗','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O35','为已知或可疑胎儿异常和损害给予的孕产妇医疗','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O36','为其他已知或可疑的胎儿问题给予的孕产妇医疗','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O42','胎膜早破','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O47','假临产','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O60','早产','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O69','产程和分娩并发脐带并发症','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O80','单胎顺产','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O82','经剖宫产术的单胎分娩','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','O99','可归类在他处的孕产妇的其他疾病并发于妊娠、分娩和产褥期','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','P23','先天性肺炎','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','P59','其他和未特指原因所致的新生儿黄疸','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','P91','新生儿的其他大脑障碍','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','Q35','腭裂','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','R42','头晕和眩晕','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','R56','惊厥，不可归类在他处者','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S00','头部浅表损伤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S22','肋骨、胸骨和胸部脊柱骨折','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S42','肩和上臂骨折','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S52','前臂骨折','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S62','在腕和手水平的骨折','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S82','小腿（包括踝）骨折','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','S83','膝关节和韧带脱位、扭伤和劳损','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','T14','身体未特指部位的损伤','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','T18','消化道内异物','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','Z34','正常妊娠监督','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','Z47','其他矫形外科的随诊医疗','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','Z48','其他手术的随诊医疗','1'))
	&sql(INSERT INTO EPRmeta_Quality.QualityOrderInfo d(d.DictionaryID,d.IsActive,d.OrderID,d.OrderName,d.ResumeText) VALUES (:LowRiskDicID,'Y','Z51','其他医疗照顾','1'))
}

}
