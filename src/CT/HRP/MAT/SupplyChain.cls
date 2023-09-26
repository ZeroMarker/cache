/// 供应链主表
Class CT.HRP.MAT.SupplyChain Extends (%Persistent, User.Abstract) [ SqlTableName = SupplyChain ]
{

Relationship Level As CT.HRP.MAT.SupplyChainLevel [ Cardinality = children, Inverse = SCLParRef ];

Relationship Itm As CT.HRP.MAT.SupplyChainItm [ Cardinality = children, Inverse = SCIParRef ];

/// 编号
Property SCCode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = SC_Code ];

/// 生产厂家
Property SCManfDR As User.PHManufacturer [ Required, SqlColumnNumber = 3, SqlFieldName = SC_Manf_DR ];

/// 供应商
Property SCVendorDR As User.APCVendor [ Required, SqlColumnNumber = 4, SqlFieldName = SC_Vendor_DR ];

/// 备注
Property SCRemarks As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = SC_Remarks ];

Index Manf On SCManfDR As Exact;

Index Vendor On SCVendorDR As Exact;

Index ManfVendor On (SCManfDR As Exact, SCVendorDR As Exact);

Storage Default
{
<Data name="SupplyChainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCCode</Value>
</Value>
<Value name="3">
<Value>SCManfDR</Value>
</Value>
<Value name="4">
<Value>SCVendorDR</Value>
</Value>
<Value name="5">
<Value>SCRemarks</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.SupplyChainD</DataLocation>
<DefaultData>SupplyChainDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.SupplyChainD</IdLocation>
<IndexLocation>^CT.HRP.MAT.SupplyChainI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.SupplyChainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
