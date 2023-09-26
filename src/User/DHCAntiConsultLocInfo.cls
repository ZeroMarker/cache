Class User.DHCAntiConsultLocInfo Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock, SqlTableName = DHC_Anti_ConsultLocInfo ]
{

/// 科室
Property ANTLocDR As %String;

/// 科室代码
Property ANTLocCode As %String;

/// 是否是会诊科室
Property ANTIsConLoc As %Boolean;

/// 是否是特殊会诊科室
Property ANTIsSpecConLoc As %Boolean;

/// 是否有效
Property ANTActive As %Boolean;

Index ANTLoc On ANTLocDR;

Storage Default
{
<Data name="DHCAntiConsultLocInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ANTLocDR</Value>
</Value>
<Value name="3">
<Value>ANTLocCode</Value>
</Value>
<Value name="4">
<Value>ANTIsConLoc</Value>
</Value>
<Value name="5">
<Value>ANTIsSpecConLoc</Value>
</Value>
<Value name="6">
<Value>ANTActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntiConsultLocInfoD</DataLocation>
<DefaultData>DHCAntiConsultLocInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAntiConsultLocInfoD</IdLocation>
<IndexLocation>^User.DHCAntiConsultLocInfoI</IndexLocation>
<StreamLocation>^User.DHCAntiConsultLocInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
