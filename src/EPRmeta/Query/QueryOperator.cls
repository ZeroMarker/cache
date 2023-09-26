/// 查询操作符字典表
Class EPRmeta.Query.QueryOperator Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCode On Code [ Unique ];

/// 操作类型代码
Property Code As %String(TRUNCATE = 1) [ Required ];

/// 操作类型名称
Property Name As %String(TRUNCATE = 1) [ Required ];

/// 是否有效
Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="QueryOperatorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryOperatorD</DataLocation>
<DefaultData>QueryOperatorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryOperatorD</IdLocation>
<IndexLocation>^DHCEPRM.QueryOperatorI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryOperatorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
