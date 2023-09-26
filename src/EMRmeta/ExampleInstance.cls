Class EMRmeta.ExampleInstance Extends (%Persistent, %XML.Adaptor)
{

Index CategorySeqence On (CategoryID, Seqence);

Index TemplateID On TemplateID;

Index IdxUserIDDocID On (UserID, EMRDocID);

Index IdxUserIDDocIDSeq On (UserID, EMRDocID, Seqence);

/// 目录ID
Property CategoryID As %Integer;

/// 范例名称
Property Name As %String(TRUNCATE = 1);

/// 名称简拼
Property JianpinName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 顺序
Property Seqence As %Integer;

/// 模板ID
Property TemplateID As %String;

/// DOCID
Property EMRDocID As %String;

/// CategoryID
Property EMRCategoryID As %String;

/// 编辑器类型
Property DocumentType As %String;

/// 模板类型
Property ChartItemType As %String;

/// 文档特性 0单文档显示 1多个文档连续显示
Property DocumentCharacteristic As %String(TRUNCATE = 1);

/// 病历ID
Property InstanceID As %String;

/// 创建者UserID
Property UserID As %String;

/// 是否有效
Property Status As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 分享为科室模板的科室ID，多个以^拼接
Property ShareLocID As %String(MAXLEN = 99999, TRUNCATE = 1);

/// 标题代码
Property TitleCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ExampleInstanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Seqence</Value>
</Value>
<Value name="5">
<Value>TemplateID</Value>
</Value>
<Value name="6">
<Value>InstanceID</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>JianpinName</Value>
</Value>
<Value name="10">
<Value>EMRDocID</Value>
</Value>
<Value name="11">
<Value>EMRCategoryID</Value>
</Value>
<Value name="12">
<Value>DocumentType</Value>
</Value>
<Value name="13">
<Value>ChartItemType</Value>
</Value>
<Value name="14">
<Value>DocumentCharacteristic</Value>
</Value>
<Value name="15">
<Value>CreateDate</Value>
</Value>
<Value name="16">
<Value>CreateTime</Value>
</Value>
<Value name="17">
<Value>ShareLocID</Value>
</Value>
<Value name="18">
<Value>TitleCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ExampleInstanceD</DataLocation>
<DefaultData>ExampleInstanceDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ExampleInstanceD</IdLocation>
<IndexLocation>^DHCEMRM.ExampleInstanceI</IndexLocation>
<StreamLocation>^DHCEMRM.ExampleInstanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
