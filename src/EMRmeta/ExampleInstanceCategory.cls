/// Description:范例病历目录
/// Creator:    Candy
/// CreateDate: 2018-3-30
Class EMRmeta.ExampleInstanceCategory Extends (%Persistent, %XML.Adaptor)
{

Index ParentID On ParentID;

Index UserParentSeqence On (UserID, ParentID, Seqence);

/// 目录名称
Property Name As %String(TRUNCATE = 1);

/// 名称简拼
Property JianpinName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 父结点ID 根结点为0
Property ParentID As %Integer;

/// 顺序
Property Seqence As %Integer;

/// 创建者UserID
Property UserID As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 是否有效
Property Status As %String(TRUNCATE = 1);

Index ParentSeqence On (ParentID, Seqence);

Index indSeqence On Seqence;

Storage Default
{
<Data name="ExampleInstanceCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>JianpinName</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Seqence</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ExamInsCategoryD</DataLocation>
<DefaultData>ExampleInstanceCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ExamInsCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.ExamInsCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.ExamInsCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
