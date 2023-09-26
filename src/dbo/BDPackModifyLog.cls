///     
Class dbo.BDPackModifyLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackModifyLog, StorageStrategy = Default ]
{

Index IndexMaster On (PackDR, ModifyDate, ModifyTime) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackModifyLog On RowID [ PrimaryKey, SqlName = PK_BD_PackModifyLog, Type = index, Unique ];

/// Foreign Key FKPackModifyLogBDPack created via DDL
ForeignKey FKPackModifyLogBDPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_PackModifyLog_BDPack ];

/// Foreign Key FKPackModifyLogUser created via DDL
ForeignKey FKPackModifyLogUser(ModifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackModifyLog_User ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ModifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ModifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ModifyItem As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property PreContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property AfterContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property ModifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property ModifyClientIP As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDPackModifyLogDefaultData">
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
<Value>ModifyDate</Value>
</Value>
<Value name="5">
<Value>ModifyTime</Value>
</Value>
<Value name="6">
<Value>ModifyItem</Value>
</Value>
<Value name="7">
<Value>PreContent</Value>
</Value>
<Value name="8">
<Value>AfterContent</Value>
</Value>
<Value name="9">
<Value>ModifyUserDR</Value>
</Value>
<Value name="10">
<Value>ModifyClientIP</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackModifyLogD</DataLocation>
<DefaultData>BDPackModifyLogDefaultData</DefaultData>
<IdLocation>^dbo.BDPackModifyLogD</IdLocation>
<IndexLocation>^dbo.BDPackModifyLogI</IndexLocation>
<StreamLocation>^dbo.BDPackModifyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
