/// 名称: DHCMed.CR.PO.FormVer
/// 描述: 自定义表单布局版本
/// 编写者：wuqk
/// 编写日期: 2012-12-18
Class DHCMed.CR.PO.FormVer Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock ]
{

Relationship Form As DHCMed.CR.PO.Form [ Cardinality = parent, Inverse = Versions ];

Property htmlLayout As %Library.GlobalCharacterStream;

Property djLayout As %Library.GlobalCharacterStream;

Property Version As %Integer;

Property IsPublished As %Boolean;

Property PublishDate As %Date;

Index CurrentVersion On Form [ Data = Version ];

/// Creator：     wuqk
/// CreatDate：   2012-12-18
/// Description:  根据ID取布局版本信息
/// Table：       DHCMed.CR.PO.FormVer
/// Input：       ID:    DHCMed.CR.PO.FormVer.ID
/// Return：      返回obj
/// w ##class(DHCMed.CR.PO.FormVer).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CR.PO.FormVer
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CR.PO.FormVer).%ExistsId(id) return
	set obj=##Class(DHCMed.CR.PO.FormVer).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="FormVerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>htmlLayout</Value>
</Value>
<Value name="3">
<Value>djLayout</Value>
</Value>
<Value name="4">
<Value>Version</Value>
</Value>
<Value name="5">
<Value>IsPublished</Value>
</Value>
<Value name="6">
<Value>PublishDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Versions")</DataLocation>
<DefaultData>FormVerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Versions")</IdLocation>
<IndexLocation>^DHCMed.CR.PO.FormI("Versions")</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.FormVerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
