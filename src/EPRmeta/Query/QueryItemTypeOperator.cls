/// 查询项目类型允许的操作符
Class EPRmeta.Query.QueryItemTypeOperator Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property OperatorID As %Integer [ Required ];

Property QueryItemTypeID As %Integer [ Required ];

Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Storage Default
{
<Data name="QueryItemTypeOperatorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperatorID</Value>
</Value>
<Value name="3">
<Value>QueryItemTypeID</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryItemTypeOperatorD</DataLocation>
<DefaultData>QueryItemTypeOperatorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryItemTypeOperatorD</IdLocation>
<IndexLocation>^DHCEPRM.QueryItemTypeOperatorI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryItemTypeOperatorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
