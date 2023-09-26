Class dbo.BTTestCodeQry Extends %Persistent [ ClassType = persistent, SqlTableName = BT_TestCodeQry ]
{

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

ForeignKey FKTestCodeQryWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BT_TestCodeQry_WorkGroup ];

ForeignKey FKTestCodeQryUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BT_TestCodeQry_User ];

Index IndexCode On (WorkGroupDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexUser On (UserDR, Code) [ SqlName = Index_User, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, UserDR) [ SqlName = Index_WorkGroup, Type = index ];

Index PKBTTESTCODEQry On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODEQry, Type = index, Unique ];

Storage Default
{
<Data name="BTTestCodeQryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeQryD</DataLocation>
<DefaultData>BTTestCodeQryDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeQryD</IdLocation>
<IndexLocation>^dbo.BTTestCodeQryI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeQryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
