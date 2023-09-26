Class dbo.BTRGSupplierBind Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_SupplierBind, StorageStrategy = Default ]
{

Index IndexReagentGroup On (ReagentGroupDR, SupplierDR) [ SqlName = Index_ReagentGroup, Type = index, Unique ];

Index IndexSupplier On (SupplierDR, ReagentGroupDR) [ SqlName = Index_Supplier, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTRGSUPPLIERBIND On RowID [ PrimaryKey, SqlName = PK_BTRG_SupplierBind, Type = index, Unique ];

ForeignKey FKRGSupplierBindReagentGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_SupplierBind_ReagentGroup ];

ForeignKey FKRGSupplierBindSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_SupplierBind_Supplier ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTRGBillTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="3">
<Value>SupplierDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGSupplierBindD</DataLocation>
<DefaultData>BTRGSupplierBindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGSupplierBindD</IdLocation>
<IndexLocation>^dbo.BTRGSupplierBindI</IndexLocation>
<StreamLocation>^dbo.BTRGSupplierBindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
