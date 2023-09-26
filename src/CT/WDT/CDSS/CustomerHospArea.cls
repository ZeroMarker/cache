/// Creator:谷雪萍
/// CreatDate:2022-01-20
/// Description：医院院区子表
/// Table：CT_WDT_CDSS.CustomerHospArea
Class CT.WDT.CDSS.CustomerHospArea Extends (%Persistent, User.Abstract)
{

Relationship ParRef As CT.WDT.CDSS.CustomerHosp [ Cardinality = parent, Inverse = ChildExt ];

/// 院区代码
Property HospAreaCode As %String;

/// 院区名称
Property HospAreaDesc As %String;

/// 开始日期
Property StartDate As %Date;

/// 截止日期
Property EndDate As %Date;

Index DescIndex On (ParRef As Exact, HospAreaDesc As Exact);

Index CodeIndex On (ParRef As Exact, HospAreaCode As Exact);

Storage Default
{
<Data name="CustomerHospAreaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospAreaCode</Value>
</Value>
<Value name="3">
<Value>HospAreaDesc</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExt")</DataLocation>
<DefaultData>CustomerHospAreaDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.CustomerHospC("ChildExt")</IdLocation>
<IndexLocation>^CT.WDT.CDSS.CustomerHospAreaI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.CustomerHospAreaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
