/// 名称: DHCMed.CD.CRReportBZQT
/// 描述: 备注（其他）信息
/// 编写者：朱飞
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportBZQT Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildBZQT ];

/// 字段代码
Property CRCode As %String;

/// 内容说明
Property CRDesc As %String;

/// 值
Property CRValue As %String;

Index IndexCode On (ParRef, CRCode) [ Unique ];

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-15
/// Description:  根据ID取表信息
/// Table：       DHCMed.CD.CRReportBZQT
/// Input：       ID:    DHCMed.CD.CRReportBZQT.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportBZQT).GetByPaCode("26","CRQTZY")
ClassMethod GetByPaCode(ParRef As %String, Code As %String) As %String
{
	new (ParRef,Code)
	set return=""
	quit:(ParRef="")||(Code="") return
	
	Set SubID=$o(^DHCMed.CD.CRReportI("BZQT","IndexCode",ParRef," "_Code,0))
	Quit:SubID="" return
	Set obj=##Class(DHCMed.CD.CRReportBZQT).GetObjById(ParRef_"||"_SubID)
	Quit:'$IsObject(obj) return
	Set return=obj.CRValue
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-15
/// Description:  根据ID取表信息
/// Table：       DHCMed.CD.CRReportBZQT
/// Input：       ID:    DHCMed.CD.CRReportBZQT.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportBZQT).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportBZQT
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportBZQT).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportBZQT).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-15
/// Description:  更新表信息
/// Table：       DHCMed.CD.CRReportBZQT
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportBZQT).Update("26^CRQTZY^其他职业^BBB","^")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set Code=$p(aInput,separete,2)
	Set SubID=$o(^DHCMed.CD.CRReportI("BZQT","IndexCode",Parref," "_Code,0))
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportBZQT).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportBZQT).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set obj.CRCode=$p(aInput,separete,2)
	Set obj.CRDesc=$p(aInput,separete,3)
	Set obj.CRValue=$p(aInput,separete,4)
	
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
<Value>CRCode</Value>
</Value>
<Value name="3">
<Value>CRDesc</Value>
</Value>
<Value name="4">
<Value>CRValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("BZQT")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("BZQT")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("BZQT")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportBZQTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
