Class DHCEPRFS.INST.MRVerSubItemDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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

Property FileSubDetailUniqueID As %String(MAXLEN = 200, TRUNCATE = 1);

Relationship TheMRVerSubItem As DHCEPRFS.INST.MRVerSubItem [ Cardinality = parent, Inverse = TheMRVerSubItemDetail ];

Index IdxMain On (TheMRVerSubItem, DetailNum) [ Unique ];

Storage Default
{
<Data name="MRVerSubItemDetailDefaultData">
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
<Value>Remark1</Value>
</Value>
<Value name="6">
<Value>Remark2</Value>
</Value>
<Value name="7">
<Value>Remark3</Value>
</Value>
<Value name="8">
<Value>Remark4</Value>
</Value>
<Value name="9">
<Value>Remark5</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
<Value name="12">
<Value>ModifyDate</Value>
</Value>
<Value name="13">
<Value>ModifyTime</Value>
</Value>
<Value name="14">
<Value>Flag</Value>
</Value>
<Value name="15">
<Value>TotCount</Value>
</Value>
<Value name="16">
<Value>FileSubDetailUniqueID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheMRVerSubItemDetail")</DataLocation>
<DefaultData>MRVerSubItemDetailDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.MRVerSubItemC("TheMRVerSubItemDetail")</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRVerSubItemDtlI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRVerSubItemDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
