Class User.DHCAntiConsultDocInfo Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock, SqlTableName = DHC_Anti_ConsultDocInfo ]
{

/// 科室
Property ConLocDR As %Library.String;

/// 医护人员
Property ConDocDr As %Library.String;

/// 是否有效
Property ConActive As %Boolean;

Index ConLocDR On ConLocDR;

Storage Default
{
<Data name="DHCAntiConsultDocInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConLocDR</Value>
</Value>
<Value name="3">
<Value>ConDocDr</Value>
</Value>
<Value name="4">
<Value>ConActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntiConsultDocInfoD</DataLocation>
<DefaultData>DHCAntiConsultDocInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAntiConsultDocInfoD</IdLocation>
<IndexLocation>^User.DHCAntiConsultDocInfoI</IndexLocation>
<StreamLocation>^User.DHCAntiConsultDocInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
