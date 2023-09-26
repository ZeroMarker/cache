/// Desc:       病历引用配置方案
/// Creator:    Candy
/// Createdate: 2015-1-13
Class EMRmeta.QuotationScheme Extends %Persistent
{

/// 目录结构ID
Property DocID As %Integer;

/// 目录结构名称(冗余字段)
Property DocName As %String;

/// 科室ID
Property CTLocID As %Integer;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

/// 是否有效
Property IsActive As %String;

Index IdxCTLocIDDocID On (CTLocID, DocID) [ Unique ];

Storage Default
{
<Data name="QuotationSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocID</Value>
</Value>
<Value name="3">
<Value>DocName</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocDesc</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.QuotationSchemeD</DataLocation>
<DefaultData>QuotationSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.QuotationSchemeD</IdLocation>
<IndexLocation>^DHCEMRM.QuotationSchemeI</IndexLocation>
<StreamLocation>^DHCEMRM.QuotationSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
