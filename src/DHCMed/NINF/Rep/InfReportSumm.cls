/// 名称: DHCMed.NINF.Rep.InfReportSumm
/// 描述: 医院感染报告 摘要信息
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportSumm Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildSumm ];

/// 感染类型("NINFInfectionType") 医院感染/社区感染
Property InfectionType As DHCMed.SS.Dictionary;

/// 疾病转归("NINFInfDiseasePrognosis")
Property DiseasePrognosis As DHCMed.SS.Dictionary;

/// 与死亡关系("NINFInfDeathRelation")
Property DeathRelation As DHCMed.SS.Dictionary;

/// 诊断依据
Property DiagnosisBasis As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 感染性疾病病程
Property DiseaseCourse As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 易感因素("NINFInfInfFactors")
Property InfFactors As list Of DHCMed.SS.Dictionary;

/// 侵入性操作("NINFInfInvasiveOper")
Property InvasiveOperation As list Of DHCMed.SS.Dictionary;

/// 入住ICU("NINFInfICUBoolean")(是/否)
Property ICUBoolean As DHCMed.SS.Dictionary;

/// ICU科室("NINFInfICULocation")
Property ICULocation As DHCMed.SS.Dictionary;

/// 手术("NINFInfOprBoolean")(是/否)
Property OprBoolean As DHCMed.SS.Dictionary;

/// 病原学检验("NINFInfLabBoolean")(是/否)
Property LabBoolean As DHCMed.SS.Dictionary;

/// 使用抗菌药物("NINFInfAntiBoolean")(是/否)
Property AntiBoolean As DHCMed.SS.Dictionary;

/// 不良反应("NINFInfAdverseReaction")(有/无)
Property AdverseReaction As DHCMed.SS.Dictionary;

/// 二重感染("NINFInfSuperinfection")(有/无)
Property Superinfection As DHCMed.SS.Dictionary;

/// 新生儿出生体重(KG)
Property BornWeight As %String(TRUNCATE = 1);

/// 新生儿出生体重("NINFInfNICUBornWeight")
Property BornWeightCat As DHCMed.SS.Dictionary;

/// 转科记录 指向PA_AdmTransaction
Property TransID As %String(TRUNCATE = 1);

/// 转入科室 指向CT_Loc
Property TransLoc As %String(TRUNCATE = 1);

/// 入科来源 指向CT_Loc
Property TransFromLoc As %String(TRUNCATE = 1);

/// 出科去向 指向CT_Loc
Property TransToLoc As %String(TRUNCATE = 1);

/// 转入日期
Property TransInDate As %Date;

/// 转出日期
Property TransOutDate As %Date;

/// 转出ICU时状态(带管情况)("NINFICUOutICUStatus")
Property OutICUStatus As list Of DHCMed.SS.Dictionary;

/// 转出ICU48小时内状态(带管情况)("NINFICUOutICU48Status")
Property OutICU48Status As list Of DHCMed.SS.Dictionary;

/// 系统症状
Property SystemSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 局部症状/体征
Property LocalSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

/// Add By LiYang 2014-04-09
/// Apache II评分
Property ApacheIIScore As %String(MAXLEN = 100, TRUNCATE = 1);

/// 易感因素备注
Property InfFactorsTxt As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 侵入性操作备注
Property InvasiveOperTxt As %String(MAXLEN = 1000, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       DHCMed.NINF.Rep.InfReportSumm.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportSumm
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportSumm).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportSumm).Update("18^^3299^^^^3358^^3332^^^^^^^^147||1^6^^^^^^^^^4123","^,!")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportSumm).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportSumm).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	
	Set obj.DiseasePrognosis=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,3))
	Set obj.DeathRelation=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,4))
	Set obj.DiagnosisBasis=$p(aInput,CHR1,5)
	Set obj.DiseaseCourse=$p(aInput,CHR1,6)
	Set InfFactors=$p(aInput,CHR1,7)
	While (obj.InfFactors.Count()>0) {
		Do obj.InfFactors.RemoveAt(1)
	}
	Set InfFactorLB=""
	For ind=1:1:$length(InfFactors,CHR2) {
		Set InfFactor=$p(InfFactors,CHR2,ind)
		Continue:($listfind(InfFactorLB,InfFactor)>0)
		Set InfFactorLB=InfFactorLB_$lb(InfFactor)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(InfFactor)
		Continue:'$IsObject(objDic)
		Do obj.InfFactors.Insert(objDic)
	}
	Set InvasiveOpers=$p(aInput,CHR1,8)
	While (obj.InvasiveOperation.Count()>0) {
		Do obj.InvasiveOperation.RemoveAt(1)
	}
	Set InvasiveOperLB=""
	For ind=1:1:$length(InvasiveOpers,CHR2) {
		Set InvasiveOper=$p(InvasiveOpers,CHR2,ind)
		Continue:($listfind(InvasiveOperLB,InvasiveOper)>0)
		Set InvasiveOperLB=InvasiveOperLB_$lb(InvasiveOper)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(InvasiveOper)
		Continue:'$IsObject(objDic)
		Do obj.InvasiveOperation.Insert(objDic)
	}
	Set obj.ICUBoolean=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,9))
	Set obj.ICULocation=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,10))
	Set obj.OprBoolean=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,11))
	Set obj.LabBoolean=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,12))
	Set obj.AntiBoolean=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,13))
	Set obj.AdverseReaction=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,14))
	Set obj.Superinfection=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,15))
	Set obj.BornWeight=$p(aInput,CHR1,16)  //新生儿体重（数值）
	
	Set obj.TransID=$p(aInput,CHR1,17)
	Set obj.TransLoc=$p(aInput,CHR1,18)
	Set obj.TransFromLoc=$p(aInput,CHR1,19)
	Set obj.TransToLoc=$p(aInput,CHR1,20)
	Set obj.TransInDate=$p(aInput,CHR1,21)
	Set obj.TransOutDate=$p(aInput,CHR1,22)
	Set OutICUStatuss=$p(aInput,CHR1,23)
	While (obj.OutICUStatus.Count()>0) {
		Do obj.OutICUStatus.RemoveAt(1)
	}
	Set OutICUStatusLB=""
	For ind=1:1:$length(OutICUStatuss,CHR2) {
		Set OutICUStatus=$p(OutICUStatuss,CHR2,ind)
		Continue:($listfind(OutICUStatusLB,OutICUStatus)>0)
		Set OutICUStatusLB=OutICUStatusLB_$lb(OutICUStatus)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(OutICUStatus)
		Continue:'$IsObject(objDic)
		Do obj.OutICUStatus.Insert(objDic)
	}
	Set OutICU48Statuss=$p(aInput,CHR1,24)
	While (obj.OutICU48Status.Count()>0) {
		Do obj.OutICU48Status.RemoveAt(1)
	}
	Set OutICU48StatusLB=""
	For ind=1:1:$length(OutICU48Statuss,CHR2) {
		Set OutICU48Status=$p(OutICU48Statuss,CHR2,ind)
		Continue:($listfind(OutICU48StatusLB,OutICU48Status)>0)
		Set OutICU48StatusLB=OutICU48StatusLB_$lb(OutICU48Status)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(OutICU48Status)
		Continue:'$IsObject(objDic)
		Do obj.OutICU48Status.Insert(objDic)
	}
	Set obj.SystemSymptom=$p(aInput,CHR1,25)
	Set obj.LocalSymptom=$p(aInput,CHR1,26)
	Set obj.BornWeightCat=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,27))  //新生儿体重（字典）
	Set obj.InfectionType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,28))  //感染类型（字典）

	//Add By LiYang 2014-04-09 增加ApacheII评分
	Set obj.ApacheIIScore=$p(aInput,CHR1,29)
	
	//add by zf 2017-07-25 增加易感因素和侵害性操作备注
	Set obj.InfFactorsTxt=$p(aInput,CHR1,30)
	Set obj.InvasiveOperTxt=$p(aInput,CHR1,31)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  删除医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       DHCMed.NINF.Rep.InfReportSumm.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportSumm).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportSumm).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseasePrognosis</Value>
</Value>
<Value name="3">
<Value>DeathRelation</Value>
</Value>
<Value name="4">
<Value>DiagnosisBasis</Value>
</Value>
<Value name="5">
<Value>DiseaseCourse</Value>
</Value>
<Value name="6">
<Value>InfFactors</Value>
</Value>
<Value name="7">
<Value>InvasiveOperation</Value>
</Value>
<Value name="8">
<Value>ICULocation</Value>
</Value>
<Value name="9">
<Value>ICUBoolean</Value>
</Value>
<Value name="10">
<Value>OprBoolean</Value>
</Value>
<Value name="11">
<Value>LabBoolean</Value>
</Value>
<Value name="12">
<Value>AntiBoolean</Value>
</Value>
<Value name="13">
<Value>AdverseReaction</Value>
</Value>
<Value name="14">
<Value>Superinfection</Value>
</Value>
<Value name="15">
<Value>BornWeight</Value>
</Value>
<Value name="16">
<Value>TransID</Value>
</Value>
<Value name="17">
<Value>TransLoc</Value>
</Value>
<Value name="18">
<Value>TransFromLoc</Value>
</Value>
<Value name="19">
<Value>TransToLoc</Value>
</Value>
<Value name="20">
<Value>TransInDate</Value>
</Value>
<Value name="21">
<Value>TransOutDate</Value>
</Value>
<Value name="22">
<Value>OutICUStatus</Value>
</Value>
<Value name="23">
<Value>OutICU48Status</Value>
</Value>
<Value name="24">
<Value>LocalSymptom</Value>
</Value>
<Value name="25">
<Value>SystemSymptom</Value>
</Value>
<Value name="26">
<Value>BornWeightCat</Value>
</Value>
<Value name="27">
<Value>InfectionType</Value>
</Value>
<Value name="28">
<Value>ApacheIIScore</Value>
</Value>
<Value name="29">
<Value>InfFactorsTxt</Value>
</Value>
<Value name="30">
<Value>InvasiveOperTxt</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Summ")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Summ")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"Summ")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportSummS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
