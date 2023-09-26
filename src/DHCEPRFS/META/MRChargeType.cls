Class DHCEPRFS.META.MRChargeType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 收费类型编码
Property ChargeTypeCode As %String [ Required ];

/// 收费类型名称
Property ChargeTypeName As %String [ Required ];

Index IdxMain On ChargeTypeCode [ Unique ];

Storage Default
{
<Data name="MRChargeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChargeTypeCode</Value>
</Value>
<Value name="3">
<Value>ChargeTypeName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRChargeTypeD</DataLocation>
<DefaultData>MRChargeTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRChargeTypeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRChargeTypeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRChargeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
