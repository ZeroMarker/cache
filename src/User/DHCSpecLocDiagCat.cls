Class User.DHCSpecLocDiagCat Extends %Persistent [ SqlTableName = DHC_SpecLocDiagCat ]
{

Index IndexCode On Code [ Unique ];

/// 表单分类代码
Property Code As %String(TRUNCATE = 1);

/// 表单分类名称
Property Name As %String(TRUNCATE = 1);

/// 是否激活
Property Active As %String(TRUNCATE = 1);

/// 授权科室ID
Property AuthLoc As %String(MAXLEN = 999, TRUNCATE = 1);

Storage Default
{
<Data name="DHCSpecLocDiagCatDefaultData">
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
<Value>Active</Value>
</Value>
<Value name="5">
<Value>AuthLoc</Value>
</Value>
</Data>
<DataLocation>^User.DHCSpecLocDiagCatD</DataLocation>
<DefaultData>DHCSpecLocDiagCatDefaultData</DefaultData>
<IdLocation>^User.DHCSpecLocDiagCatD</IdLocation>
<IndexLocation>^User.DHCSpecLocDiagCatI</IndexLocation>
<StreamLocation>^User.DHCSpecLocDiagCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
