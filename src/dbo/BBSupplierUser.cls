Class dbo.BBSupplierUser Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SupplierUser ]
{

Index IndexCode On HosCode [ SqlName = Index_HosCode, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

Index IndexMaster On HospitalDR [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBSupplierUser On RowID [ PrimaryKey, SqlName = PK_BB_SupplierUser, Type = index, Unique ];

/// Foreign Key FKLocationHospital created via DDL
ForeignKey FKSupplierUserHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_SupplierUserHospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property HosCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property UserCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property Password As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBSupplierUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>HosCode</Value>
</Value>
<Value name="4">
<Value>UserCode</Value>
</Value>
<Value name="5">
<Value>Password</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSupplierUserD</DataLocation>
<DefaultData>BBSupplierUserDefaultData</DefaultData>
<IdLocation>^dbo.BBSupplierUserD</IdLocation>
<IndexLocation>^dbo.BBSupplierUserI</IndexLocation>
<StreamLocation>^dbo.BBSupplierUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
