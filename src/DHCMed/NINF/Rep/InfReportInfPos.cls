/// 名称: DHCMed.NINF.Rep.InfReportInfPos
/// 描述: 医院感染报告 感染信息
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportInfPos Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildInfPos ];

/// 数据来源
/// 指向临床诊断   格式:"MRD:MR_Diagnos.RowID"
/// 指向电子病历   格式:"EPR:模板单元代码"
Property DataSource As %String(TRUNCATE = 1);

/// 感染部位
Property InfPos As DHCMed.NINF.Dic.InfPosition;

/// 感染日期
Property InfDate As %Date;

/// 感染结束日期 Add By LiYang 2013-05-18
Property InfEndDate As %Date;

/// 感染转归 Add By LiYang 2013-05-19
Property InfEndResult As DHCMed.SS.Dictionary;

/// 感染诊断
Property InfDiag As DHCMed.NINF.Dic.InfDiagnose;

/// 感染诊断子分类
Property InfDiagCat As DHCMed.SS.Dictionary;

/// 侵入性操作
Property InfPosOpr As list Of DHCMed.NINF.Rep.InfReportInfPosOpr;

/// 诊断依据
Property DiagnosisBasis As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 感染性疾病病程
Property DiseaseCourse As %String(MAXLEN = 1000, TRUNCATE = 1);

Index IndexInfDate On (InfDate, ParRef);

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 感染信息
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReportInfPos.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportInfPos
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportInfPos).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 感染信息
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportInfPos).Update()
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Quit:(CHR1="")||(CHR2="")||(CHR3="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportInfPos).%New()
		
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportInfPos).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	
	Set obj.DataSource=$p(aInput,CHR1,3)
	Set obj.InfPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById($p(aInput,CHR1,4))
	Set obj.InfDate=$p(aInput,CHR1,5)
	Set obj.InfDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById($p(aInput,CHR1,6))
	Set InfPosOprs=$p(aInput,CHR1,7)
	While (obj.InfPosOpr.Count()>0) {
		Do obj.InfPosOpr.RemoveAt(1)
	}
	Set InfPosOprLB=""
	For ind=1:1:$length(InfPosOprs,CHR2) {
		Set InfPosOpr=$p(InfPosOprs,CHR2,ind)
		Continue:($listfind(InfPosOprLB,InfPosOpr)>0)
		Set InfPosOprLB=InfPosOprLB_$lb(InfPosOpr)
		Set objInfPosOpr=##class(DHCMed.NINF.Rep.InfReportInfPosOpr).GetObj(InfPosOpr,CHR3)
		Continue:'$IsObject(objInfPosOpr)
		Do obj.InfPosOpr.Insert(objInfPosOpr)
	}
	Set obj.InfEndDate=$p(aInput,CHR1,8) // 感染结束日期
	Set obj.InfEndResult=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,9)) //感染转归
	Set obj.DiagnosisBasis=$p(aInput,CHR1,10)
	Set obj.DiseaseCourse=$p(aInput,CHR1,11)
	Set obj.InfDiagCat=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,12)) //感染诊断子分类
	
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
/// Description:  删除医院感染报告 感染信息
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReportInfPos.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportInfPos).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportInfPos).%DeleteId(aId)
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
<Value>DataSource</Value>
</Value>
<Value name="3">
<Value>InfPos</Value>
</Value>
<Value name="4">
<Value>InfDate</Value>
</Value>
<Value name="5">
<Value>InfDiag</Value>
</Value>
<Value name="6">
<Value>InfPosOpr</Value>
</Value>
<Value name="7">
<Value>InfEndDate</Value>
</Value>
<Value name="8">
<Value>InfEndResult</Value>
</Value>
<Value name="9">
<Value>DiagnosisBasis</Value>
</Value>
<Value name="10">
<Value>DiseaseCourse</Value>
</Value>
<Value name="11">
<Value>InfDiagCat</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("InfPos")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("InfPos")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"InfPos")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportInfPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
