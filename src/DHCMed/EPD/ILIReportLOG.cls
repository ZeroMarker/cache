/// 名称：DHCMed.EPD.ILIReportLOG
/// 描述：日志信息
/// 编写者：yk
/// 编写日期：2016-03-18
Class DHCMed.EPD.ILIReportLOG Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.EPD.ERReportILI [ Cardinality = parent, Inverse = ChildLOG ];

/// 状态
Property ERStatus As DHCMed.SS.Dictionary;

/// 科室
Property ERLoc As %String;

/// 操作人
Property ERUser As %String;

/// 日期
Property ERDate As %Date;

/// 时间
Property ERTime As %Time;

/// 处置意见
Property EROpinion As %String(MAXLEN = 100);

/// Creator：     YK
/// CreatDate：   2016-03-18
/// Description:  根据ID取日志信息
/// Table：       DHCMed.EPD.ILIReportLOG
/// Input：       ID:    DHCMed.EPD.ILIReportLOG.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ILIReportLOG).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.EPD.ILIReportLOG
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.EPD.ILIReportLOG).%ExistsId(+id) return
	set obj=##Class(DHCMed.EPD.ILIReportLOG).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     YK
/// CreatDate：   2016-03-18
/// Description:  更新日志信息
/// Table：       DHCMed.EPD.ILIReportLOG
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ILIReportLOG).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.EPD.ILIReportLOG).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.EPD.ERReportILI).GetObjById(RepID)
	
	Set StatusCode=$p(aInput,separete,2)
	Set obj.ERStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ERReportStatus",StatusCode,1)
	Set obj.ERLoc=$p(aInput,separete,3)
	Set obj.ERUser=$p(aInput,separete,4)
	Set obj.ERDate=$p(aInput,separete,5)
	Set obj.ERTime=$p(aInput,separete,6)
	Set obj.EROpinion=$p(aInput,separete,7)
	
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
<Data name="ILIReportLOGDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ERStatus</Value>
</Value>
<Value name="3">
<Value>ERLoc</Value>
</Value>
<Value name="4">
<Value>ERUser</Value>
</Value>
<Value name="5">
<Value>ERDate</Value>
</Value>
<Value name="6">
<Value>ERTime</Value>
</Value>
<Value name="7">
<Value>EROpinion</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildLOG")</DataLocation>
<DefaultData>ILIReportLOGDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.ERReportILIC("ChildLOG")</IdLocation>
<IndexLocation>^DHCMed.EPD.ILIReportLOGI</IndexLocation>
<StreamLocation>^DHCMed.EPD.ILIReportLOGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
