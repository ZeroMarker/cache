Class EPRmeta.CodeTable.CodeTable Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock ]
{

Index IdxLocCode On LocCode;

/// trakcare的 科室代码
Property LocCode As %String(TRUNCATE = 1);

/// trakcare的 科室描述
Property LocDesc As %String(TRUNCATE = 1);

/// 病案室的 科室代码
Property LocCodeBA As %String(TRUNCATE = 1);

/// 病案室的 科室描述
Property LocDescBA As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CodeTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocCode</Value>
</Value>
<Value name="3">
<Value>LocCodeBA</Value>
</Value>
<Value name="4">
<Value>LocDesc</Value>
</Value>
<Value name="5">
<Value>LocDescBA</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CodeTable.CodeTableD</DataLocation>
<DefaultData>CodeTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CodeTable.CodeTableD</IdLocation>
<IndexLocation>^DHCEPRM.CodeTable.CodeTableI</IndexLocation>
<StreamLocation>^DHCEPRM.CodeTable.CodeTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
