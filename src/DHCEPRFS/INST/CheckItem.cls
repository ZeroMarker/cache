Class DHCEPRFS.INST.CheckItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 类别RowID
Property CategoryID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历项目表ID
Property MRItemID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 归档病历项目编码
Property MRItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 归档病历项目名称
Property MRItemName As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 归档病历项目描述
Property MRItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 归档病历项目类型
Property Type As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 7 ];

/// 归档病历项目类型参数
Property TypeParams As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 是否有效
Property IsValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Index IdxCategoryID On CategoryID;

Storage Default
{
<Data name="CheckItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>MRItemID</Value>
</Value>
<Value name="4">
<Value>MRItemCode</Value>
</Value>
<Value name="5">
<Value>MRItemName</Value>
</Value>
<Value name="6">
<Value>MRItemDesc</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>TypeParams</Value>
</Value>
<Value name="9">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckItemD</DataLocation>
<DefaultData>CheckItemDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckItemD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
