Class DHCEPRFS.INST.MRVerItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MRVersionID As %String(TRUNCATE = 1);

Property MRItemID As %String(TRUNCATE = 1);

Property TotCount As %Integer;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property FileUniqueID As %String(TRUNCATE = 1);

/// 存储平台注册等唯一ID
Property Remark1 As %String(TRUNCATE = 1);

Property Remark2 As %String(TRUNCATE = 1);

Property Remark3 As %String(TRUNCATE = 1);

Property Remark4 As %String(TRUNCATE = 1);

Property Remark5 As %String(TRUNCATE = 1);

/// 目前这个时间是用来记录"监狱系统"的各项完成日期
Property DateFlag As %Date;

/// 目前这个时间是用来记录"监狱系统"的各项完成时间
Property TimeFlag As %Time;

/// 媒体类型，为空表示PDF文档，OTHER表示不分类，MP3，MP4等
Property MRItemMediaType As %String(TRUNCATE = 1);

/// 用来标识是否删除项
/// Y--是  N或""--不是
Property DeleteFlag As %String(TRUNCATE = 1);

Relationship TheMRVerItemDetail As DHCEPRFS.INST.MRVerItemDetail [ Cardinality = children, Inverse = TheMRVerItem ];

Index IdxMain On (MRVersionID, MRItemID) [ Unique ];

Storage Default
{
<Data name="MRVerItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRVersionID</Value>
</Value>
<Value name="3">
<Value>MRItemID</Value>
</Value>
<Value name="4">
<Value>TotCount</Value>
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
<Value>Remark1</Value>
</Value>
<Value name="10">
<Value>Remark2</Value>
</Value>
<Value name="11">
<Value>Remark3</Value>
</Value>
<Value name="12">
<Value>Remark4</Value>
</Value>
<Value name="13">
<Value>Remark5</Value>
</Value>
<Value name="14">
<Value>FileUniqueID</Value>
</Value>
<Value name="15">
<Value>DateFlag</Value>
</Value>
<Value name="16">
<Value>TimeFlag</Value>
</Value>
<Value name="17">
<Value>MRItemMediaType</Value>
</Value>
<Value name="18">
<Value>DeleteFlag</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRVerItemD</DataLocation>
<DefaultData>MRVerItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRVerItemD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRVerItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRVerItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
