/// 名称: DHCMed.CD.CRReportLOG
/// 描述: 日志信息
/// 编写者：朱飞
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportLOG Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildLOG ];

/// 状态
Property CRStatus As DHCMed.SS.Dictionary;

/// 科室
Property CRLoc As %String;

/// 操作人
Property CRUser As %String;

/// 日期
Property CRDate As %Date;

/// 时间
Property CRTime As %Time;

/// 处置意见
Property CROpinion As %String(MAXLEN = 100);

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-27
/// Description:  根据ID取日志信息
/// Table：       DHCMed.CD.CRReportLOG
/// Input：       ID:    DHCMed.CD.CRReportLOG.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportLOG).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportLOG
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportLOG).%ExistsId(+id) return
	set obj=##Class(DHCMed.CD.CRReportLOG).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-21
/// Description:  更新日志信息
/// Table：       DHCMed.CD.CRReportLOG
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportLOG).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set obj=##class(DHCMed.CD.CRReportLOG).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	
	Set StatusCode=$p(aInput,separete,2)
	Set obj.CRStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRReportStatus",StatusCode,1)
	Set obj.CRLoc=$p(aInput,separete,3)
	Set obj.CRUser=$p(aInput,separete,4)
	Set obj.CRDate=$p(aInput,separete,5)
	Set obj.CRTime=$p(aInput,separete,6)
	Set obj.CROpinion=$p(aInput,separete,7)
	
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRStatus</Value>
</Value>
<Value name="3">
<Value>CRLoc</Value>
</Value>
<Value name="4">
<Value>CRUser</Value>
</Value>
<Value name="5">
<Value>CRDate</Value>
</Value>
<Value name="6">
<Value>CRTime</Value>
</Value>
<Value name="7">
<Value>CROpinion</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LOG")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("LOG")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("LOG")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportLOGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
