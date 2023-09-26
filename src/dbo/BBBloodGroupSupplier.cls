///     
Class dbo.BBBloodGroupSupplier Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodGroupSupplier, StorageStrategy = Default ]
{

/// Foreign Key FKBBBGSGroup created via DDL
ForeignKey FKBBBGSGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BB_BGS_Group ];

/// Foreign Key FKBBBGSSupplier created via DDL
ForeignKey FKBBBGSSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BB_BGS_Supplier ];

Index IndexBarCode On (SupplierDR, BarCode) [ SqlName = Index_BarCode, Type = index ];

Index IndexMaster On (BloodGroupDR, SupplierDR, BarCode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSupplier On (SupplierDR, BloodGroupDR) [ SqlName = Index_Supplier, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODGROUPSUPPLIER On RowID [ PrimaryKey, SqlName = PK_BB_BLOODGROUPSUPPLIER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BarCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property SpecialChar As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property Positions As %Library.String(COLLATION = "Exact", MAXLEN = 11) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBBloodGroupSupplierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodGroupDR</Value>
</Value>
<Value name="3">
<Value>SupplierDR</Value>
</Value>
<Value name="4">
<Value>BarCode</Value>
</Value>
<Value name="5">
<Value>SpecialChar</Value>
</Value>
<Value name="6">
<Value>Positions</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodGroupSupplierD</DataLocation>
<DefaultData>BBBloodGroupSupplierDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodGroupSupplierD</IdLocation>
<IndexLocation>^dbo.BBBloodGroupSupplierI</IndexLocation>
<StreamLocation>^dbo.BBBloodGroupSupplierS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
