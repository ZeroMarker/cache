///     
Class dbo.BDPackFreezerLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackFreezerLog, StorageStrategy = Default ]
{

/// Foreign Key FKPackFreezerLogAddUser created via DDL
ForeignKey FKPackFreezerLogAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackFreezerLog_AddUser ];

/// Foreign Key FKPackFreezerLogPack created via DDL
ForeignKey FKPackFreezerLogPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_PackFreezerLog_Pack ];

Index IndexMaster On (PackDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackFreezerLog On RowID [ PrimaryKey, SqlName = PK_BD_PackFreezerLog, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OPType As %Library.SmallInt [ Required, SqlColumnNumber = 7 ];

Property FreezerId As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 8 ];

Property FreezerLoc As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDPackFreezerLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>OPType</Value>
</Value>
<Value name="8">
<Value>FreezerId</Value>
</Value>
<Value name="9">
<Value>FreezerLoc</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackFreezerLogD</DataLocation>
<DefaultData>BDPackFreezerLogDefaultData</DefaultData>
<IdLocation>^dbo.BDPackFreezerLogD</IdLocation>
<IndexLocation>^dbo.BDPackFreezerLogI</IndexLocation>
<StreamLocation>^dbo.BDPackFreezerLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
