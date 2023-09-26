/// 消毒包的分类
Class User.CSSDPackageClass Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageClass ]
{

Property CSSDPCPackCalssName As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CSSDPC_PackClassName ];

Property CSSDPCPackClassCode As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CSSDPC_PackClassCode ];

Property CSSDPCBusinessProcess As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CSSDPC_BusinessProcess ];

/// 可用状态:Y-可用,N-停用; 名称上有Not字样,不要纠结
Property CSSDPCNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 5, SqlFieldName = CSSDPC_NotUseFlag ];

Index CSSDPCPackCalssNameIndex On CSSDPCPackCalssName As Exact;

Index CSSDPCPackClassCodeIndex On CSSDPCPackClassCode As Exact;

Storage Default
{
<Data name="CSSDPackageClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPCPackCalssName</Value>
</Value>
<Value name="3">
<Value>CSSDPCPackClassCode</Value>
</Value>
<Value name="4">
<Value>CSSDPCBusinessProcess</Value>
</Value>
<Value name="5">
<Value>CSSDPCNotUseFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageClassD</DataLocation>
<DefaultData>CSSDPackageClassDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageClassD</IdLocation>
<IndexLocation>^User.CSSDPackageClassI</IndexLocation>
<StreamLocation>^User.CSSDPackageClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
