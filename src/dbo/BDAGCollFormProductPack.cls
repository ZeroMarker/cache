///     
Class dbo.BDAGCollFormProductPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGCollFormProductPack, StorageStrategy = Default ]
{

/// Foreign Key FKAGCollFormProductPack created via DDL
ForeignKey FKAGCollFormProductPack(AGCollectFormProductDR) References dbo.BDAGCollFormProduct(PKBDAGCOLLFORMPRODUCT) [ SqlName = FK_AGCollFormProductPack ];

/// Foreign Key FKAGCollFormProductPackAddUser created via DDL
ForeignKey FKAGCollFormProductPackAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormProductPack_AddUser ];

/// Foreign Key FKAGCollFormProductPackEndUser created via DDL
ForeignKey FKAGCollFormProductPackEndUser(EndCollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormProductPack_EndUser ];

/// Foreign Key FKAGCollFormProductPackStartUser created via DDL
ForeignKey FKAGCollFormProductPackStartUser(StartCollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormProductPack_StartUser ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexMaster On (AGCollectFormProductDR, PackNum) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStartCollDate On StartCollDate [ SqlName = Index_StartCollDate, Type = index ];

Index IndexStartCollectUser On (StartCollectUserDR, StartCollDate) [ SqlName = Index_StartCollectUser, Type = index ];

Index IndexPackBarcode On (PackBarcode, PackNum) [ SqlName = Index_PackBarcode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDAGCOLLFORMPRODUCTPACK On RowID [ PrimaryKey, SqlName = PK_BD_AGCOLLFORMPRODUCTPACK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGCollectFormProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property Volume As %Library.Float [ SqlColumnNumber = 6 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property StartCollDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property StartCollTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property StartCollectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property EndCollDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property EndCollTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property EndCollectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property IsStockIn As %Library.Boolean [ SqlColumnNumber = 16 ];

Property RealVolume As %Library.Float [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BDAGCollFormProductPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGCollectFormProductDR</Value>
</Value>
<Value name="3">
<Value>PackNum</Value>
</Value>
<Value name="4">
<Value>PackBarcode</Value>
</Value>
<Value name="5">
<Value>Volume</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>StartCollDate</Value>
</Value>
<Value name="10">
<Value>StartCollTime</Value>
</Value>
<Value name="11">
<Value>StartCollectUserDR</Value>
</Value>
<Value name="12">
<Value>EndCollDate</Value>
</Value>
<Value name="13">
<Value>EndCollTime</Value>
</Value>
<Value name="14">
<Value>EndCollectUserDR</Value>
</Value>
<Value name="15">
<Value>IsStockIn</Value>
</Value>
<Value name="16">
<Value>RealVolume</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGCollFormProductPackD</DataLocation>
<DefaultData>BDAGCollFormProductPackDefaultData</DefaultData>
<IdLocation>^dbo.BDAGCollFormProductPackD</IdLocation>
<IndexLocation>^dbo.BDAGCollFormProductPackI</IndexLocation>
<StreamLocation>^dbo.BDAGCollFormProductPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
