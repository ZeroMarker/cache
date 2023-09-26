Class dbo.BDSupplierProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_SupplierProduct, StorageStrategy = Default ]
{

ForeignKey FKBDSupliProSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BD_Pack_Supplier ];

Index IndexSeqNum On (SupplierDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

Index IndexMaster On (SupplierDR, ProductCode) [ SqlName = Index_Master, Type = index ];

Index PKBDBLOODSUPPLIERRODUCT On RowID [ PrimaryKey, SqlName = PK_BD_BLOODSUPPLIERRODUCT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property ProductCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property ProductName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ Required, SqlColumnNumber = 5 ];

Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property BldTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property PackVolume As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property ProductType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BDSupplierProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierDR</Value>
</Value>
<Value name="3">
<Value>ProductCode</Value>
</Value>
<Value name="4">
<Value>ProductName</Value>
</Value>
<Value name="5">
<Value>Units</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>BldTypeDR</Value>
</Value>
<Value name="9">
<Value>PackVolume</Value>
</Value>
<Value name="10">
<Value>ProductType</Value>
</Value>
</Data>
<DataLocation>^dbo.BDSupplierProductD</DataLocation>
<DefaultData>BDSupplierProductDefaultData</DefaultData>
<IdLocation>^dbo.BDSupplierProductD</IdLocation>
<IndexLocation>^dbo.BDSupplierProductI</IndexLocation>
<StreamLocation>^dbo.BDSupplierProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
