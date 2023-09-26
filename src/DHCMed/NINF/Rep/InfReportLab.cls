/// 名称: DHCMed.NINF.Rep.InfReportLab
/// 描述: 医院感染报告 病原学检验
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportLab Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildLab ];

/// 数据来源
/// 指向检验医嘱   格式:"OEITEM:OE_OrdItem.RowID"
Property DataSource As %String(TRUNCATE = 1);

/// 检验医嘱 指向ARC_ItemMast
Property ArcimID As %String(TRUNCATE = 1);

/// 检验医嘱名称
Property ArcimDesc As %String(TRUNCATE = 1);

/// 检验标本("NINFInfSpecimen")
Property Specimen As DHCMed.SS.Dictionary;

/// 感染部位
Property InfectionPos As DHCMed.NINF.Dic.InfPosition;

/// 送检日期
Property SubmissionDate As %Date;

/// 检验方法("NINFInfAssayMethod")
Property AssayMethod As DHCMed.SS.Dictionary;

/// 病原学检验("NINFInfPathogenTest")
Property PathogenTest As DHCMed.SS.Dictionary;

/// 检验结果(病原体)
Property TestResults As list Of DHCMed.NINF.Rep.InfReportLabPy;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       DHCMed.NINF.Rep.InfReportLab.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportLab
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportLab).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportLab).Update()
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Set CHR4=$p(aSeparate,",",4)
	Set CHR5=$p(aSeparate,",",5)
	Quit:(CHR1="")||(CHR2="")||(CHR3="")||(CHR4="")||(CHR5="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportLab).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportLab).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	
	Set obj.DataSource=$p(aInput,CHR1,3)
	Set obj.ArcimID=$p(aInput,CHR1,4)
	Set obj.ArcimDesc=$p(aInput,CHR1,5)
	Set obj.Specimen=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,6))
	Set obj.InfectionPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById($p(aInput,CHR1,7))
	Set obj.SubmissionDate=$p(aInput,CHR1,8)
	Set obj.AssayMethod=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,9))
	Set obj.PathogenTest=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,10))
	
	Set TestResults=$p(aInput,CHR1,11)
	While (obj.TestResults.Count()>0) {
		Do obj.TestResults.RemoveAt(1)
	}
	Set TestRstLB=""
	For ind=1:1:$length(TestResults,CHR2) {
		Set TestRst=$p(TestResults,CHR2,ind)
		Continue:($listfind(TestRstLB,TestRst)>0)
		Set TestRstLB=TestRstLB_$lb(TestRst)
		Set objTestRst=##class(DHCMed.NINF.Rep.InfReportLabPy).GetObj(TestRst,CHR3_","_CHR4_","_CHR5)
		Continue:'$IsObject(objTestRst)
		Do obj.TestResults.Insert(objTestRst)
	}
	
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
/// Description:  删除医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       DHCMed.NINF.Rep.InfReportLab.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportLab).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportLab).%DeleteId(aId)
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
<Value>ArcimID</Value>
</Value>
<Value name="3">
<Value>ArcimDesc</Value>
</Value>
<Value name="4">
<Value>DataSource</Value>
</Value>
<Value name="5">
<Value>Specimen</Value>
</Value>
<Value name="6">
<Value>InfectionPos</Value>
</Value>
<Value name="7">
<Value>SubmissionDate</Value>
</Value>
<Value name="8">
<Value>AssayMethod</Value>
</Value>
<Value name="9">
<Value>PathogenTest</Value>
</Value>
<Value name="10">
<Value>TestResults</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Lab")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Lab")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"Lab")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportLabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
