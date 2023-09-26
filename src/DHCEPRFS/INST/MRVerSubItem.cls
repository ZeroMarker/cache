Class DHCEPRFS.INST.MRVerSubItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MRVerItemID As %String(TRUNCATE = 1);

Property MRItemID As %String(TRUNCATE = 1);

/// 存储医嘱号等唯一ID
Property Remark1 As %String(MAXLEN = 200, TRUNCATE = 1);

Property Remark2 As %String(TRUNCATE = 1);

Property Remark3 As %String(TRUNCATE = 1);

Property Remark4 As %String(TRUNCATE = 1);

Property Remark5 As %String(TRUNCATE = 1);

Property TotCount As %Integer;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property FileSubUniqueID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 媒体类型，为空表示PDF文档，OTHER表示不分类，MP3，MP4等
Property MRItemMediaType As %String(TRUNCATE = 1);

Relationship TheMRVerSubItemDetail As DHCEPRFS.INST.MRVerSubItemDetail [ Cardinality = children, Inverse = TheMRVerSubItem ];

Index IdxMain On (MRVerItemID, FileSubUniqueID) [ Unique ];

Index IdxMRVerItemID On (MRVerItemID, Remark1);

Storage Default
{
<Data name="MRVerSubItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRVerItemID</Value>
</Value>
<Value name="3">
<Value>MRItemID</Value>
</Value>
<Value name="4">
<Value>Remark1</Value>
</Value>
<Value name="5">
<Value>Remark2</Value>
</Value>
<Value name="6">
<Value>Remark3</Value>
</Value>
<Value name="7">
<Value>Remark4</Value>
</Value>
<Value name="8">
<Value>Remark5</Value>
</Value>
<Value name="9">
<Value>TotCount</Value>
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
<Value>FileSubUniqueID</Value>
</Value>
<Value name="15">
<Value>MRItemMediaType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRVerSubItemD</DataLocation>
<DefaultData>MRVerSubItemDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.MRVerSubItemD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRVerSubItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRVerSubItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
