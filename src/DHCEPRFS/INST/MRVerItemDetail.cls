Class DHCEPRFS.INST.MRVerItemDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DetailNum As %Integer;

Property FileMasterID As %String(TRUNCATE = 1);

Property FileMasterPath As %String(MAXLEN = 200, TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property Flag As %String(TRUNCATE = 1);

Property TotCount As %Integer;

Property FileDetailUniqueID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 用来标识是否删除项
/// Y--是  N或""--不是
Property DeleteFlag As %String(TRUNCATE = 1);

Relationship TheMRVerItem As DHCEPRFS.INST.MRVerItem [ Cardinality = parent, Inverse = TheMRVerItemDetail ];

Index IdxMain On (TheMRVerItem, DetailNum) [ Unique ];

Storage Default
{
<Data name="MRVerItemDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailNum</Value>
</Value>
<Value name="3">
<Value>FileMasterID</Value>
</Value>
<Value name="4">
<Value>FileMasterPath</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>ModifyDate</Value>
</Value>
<Value name="8">
<Value>ModifyTime</Value>
</Value>
<Value name="9">
<Value>Flag</Value>
</Value>
<Value name="10">
<Value>TotCount</Value>
</Value>
<Value name="11">
<Value>FileDetailUniqueID</Value>
</Value>
<Value name="12">
<Value>DeleteFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheMRVerItemDetail")</DataLocation>
<DefaultData>MRVerItemDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("TheMRVerItemDetail")</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRVerItemDetailI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRVerItemDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
