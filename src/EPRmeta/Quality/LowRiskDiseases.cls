/// 低风险病种维护表
Class EPRmeta.Quality.LowRiskDiseases Extends %Persistent
{

Index IdxIsActiveICDCode On (IsActive, ICDCode);

Property ICDCode As %String;

Property DiseasesName As %String;

Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Storage Default
{
<Data name="LowRiskDiseasesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICDCode</Value>
</Value>
<Value name="3">
<Value>DiseasesName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityLowRiskDiseasesD</DataLocation>
<DefaultData>LowRiskDiseasesDefaultData</DefaultData>
<IdLocation>^DHCEPRM.QualityLowRiskDiseasesD</IdLocation>
<IndexLocation>^DHCEPRM.QualityLowRiskDiseasesI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityLowRiskDiseasesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// Desc:       初始化报告类型字典表
/// Creator:    hky
/// CreateDate: 2021-11-12
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EPRmeta.Quality.LowRiskDiseases).InitLowRiskDiseases()
ClassMethod InitLowRiskDiseases()
{
	//&sql(DELETE FROM EPRmeta_Quality.LowRiskDiseases)
	k ^DHCEPRM.QualityLowRiskDiseasesD
	k ^DHCEPRM.QualityLowRiskDiseasesI
	k ^DHCEPRM.QualityLowRiskDiseasesS
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('A18','其他器官的结核','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('B00','疱疹病毒[单纯疱疹]感染','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('B02','带状疱疹','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('B08','其他以皮肤和粘膜损害为特征的病毒性感染，不可归类在他处者','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('B18','慢性病毒性肝炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('C73','甲状腺恶性肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D13','消化系统其他和不明确部位的良性肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D16','骨和关节软骨良性肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D17','良性脂肪瘤样肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D18','血管瘤和淋巴管瘤，任何部位','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D24','乳房良性肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D25','子宫平滑肌瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D27','卵巢良性肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D36','其他和未特指部位的良性肿瘤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D50','缺铁性贫血','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('D69','紫癜和其他出血性情况','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('E05','甲状腺毒症（甲状腺功能亢进症）','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('E07','甲状腺的其他疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('E10','胰岛素依赖型糖尿病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('E11','非胰岛素依赖型糖尿病','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('G40','癫痫','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('G45','短暂性大脑缺血性发作和相关的综合征','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H02','眼睑的其他疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H1l','结膜的其他疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H25','老年性白内障','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H26','其他白内障','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H33','视网膜脱离和断裂','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H40','青光眼','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H81','前庭功能疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('H91','其他听觉丧失','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I10','特发性（原发性）高血压','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I20','心绞痛','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I47','阵发性心动过速','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I70','动脉粥样硬化','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I80','静脉炎和血栓性静脉炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I83','下肢静脉曲张','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I84','痔','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I86','其他部位的静脉曲张','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('I87','静脉的其他疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J04','急性喉炎和气管炎','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J06','多发性和未特指部位的急性上呼吸道感染','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J20','急性支气管炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J21','急性细支气管炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J32','慢性鼻窦炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J33','鼻息肉','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J34','鼻和鼻窦的其他疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J35','扁桃体和腺样体慢性疾病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J38','声带和喉疾病，不可归类在他处者','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J40','支气管炎，未特指为急性或慢性','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('J45','哮喘','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K11','涎腺疾病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K12','口炎和有关损害','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K21','胃-食管反流性疾病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K22','食管的其他疾病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K25','胃溃疡','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K29','胃炎和十二指肠炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K31','胃和十二指肠的其他疾病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K35','急性阑尾炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K40','腹股沟疝','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K52','其他非感染性胃肠炎和结肠炎','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K60','肛门及直肠区的裂和瘘','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K61','肛门和直肠区脓肿','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K63','肠的其他疾病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('K80','胆石症','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('L08','皮肤和皮下组织其他局部感染','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M06','其他类风湿性关节炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M13','其他关节炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M17','膝关节病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M47','脊椎关节强硬','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M48','其他脊椎病','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M51','其他椎间盘疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M79','其他软组织疾患，不可归类在他处者','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('M87','骨坏死','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N02','复发性和持续性血尿','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N04','肾病综合征','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N10','急性肾小管-间质肾炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N13','梗阻性和反流性尿路病','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N20','肾和输尿管结石','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N40','前列腺增生','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N43','鞘膜积液和精子囊肿','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N45','睾丸炎和附睾炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N80','子宫内膜异位症','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('N83','卵巢、输卵管和阔韧带的非炎性疾患','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O00','异位妊娠','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O02','受孕的其他异常产物','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O20','妊娠早期出血','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O26','为主要与妊娠有关的其他情况给予的孕产妇医疗','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O35','为已知或可疑胎儿异常和损害给予的孕产妇医疗','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O36','为其他已知或可疑的胎儿问题给予的孕产妇医疗','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O42','胎膜早破','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O47','假临产','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O60','早产','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O69','产程和分娩并发脐带并发症','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O80','单胎顺产','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O82','经剖宫产术的单胎分娩','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('O99','可归类在他处的孕产妇的其他疾病并发于妊娠、分娩和产褥期','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('P23','先天性肺炎','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('P59','其他和未特指原因所致的新生儿黄疸','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('P91','新生儿的其他大脑障碍','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('Q35','腭裂','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('R42','头晕和眩晕','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('R56','惊厥，不可归类在他处者','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S00','头部浅表损伤','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S22','肋骨、胸骨和胸部脊柱骨折','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S42','肩和上臂骨折','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S52','前臂骨折','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S62','在腕和手水平的骨折','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S82','小腿（包括踝）骨折','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('S83','膝关节和韧带脱位、扭伤和劳损','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('T14','身体未特指部位的损伤','Y'))
	
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('T18','消化道内异物','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('Z34','正常妊娠监督','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('Z47','其他矫形外科的随诊医疗','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('Z48','其他手术的随诊医疗','Y'))
	&sql(INSERT INTO EPRmeta_Quality.LowRiskDiseases d(d.ICDCode,d.DiseasesName,d.IsActive) VALUES ('Z51','其他医疗照顾','Y'))
}

}
