Class dbo.BTReportCollectType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ReportCollectType ]
{

Index IndexCode On (Code, CreateUserDR) [ SqlName = Index_Code, Type = index ];

Index IndexWorkGrpupDR On (WorkGroupDR, Code) [ SqlName = Index_WorkGroupDR, Type = index ];

Index IndexCreateUserDR On (CreateUserDR, Code) [ SqlName = Index_CreateUserDR, Type = index ];

/// Foreign Key FKRPVisitNumberCollectCollectUserDR created via DDL
ForeignKey FKBTREPORTCOLLECTTYPECREATEUSERDR(CreateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BTReportCollectTypeCreateUserDR ];

/// Foreign Key FKRPVisitNumberCollectCollectUserDR created via DDL
ForeignKey FKBTREPORTCOLLECTTYPEWORKGROUP(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTReportCollectTypeWorkGroup ];

/// DDL Primary Key Specification
Index PKBTREPORTCOLLECTTYPE On RowID [ PrimaryKey, SqlName = PK_BT_REPORTCOLLECTTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property IsShare As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTReportCollectTypeDefaultData">
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
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateUserDR</Value>
</Value>
<Value name="6">
<Value>WorkGroupDR</Value>
</Value>
<Value name="7">
<Value>IsShare</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTReportCollectTypeD</DataLocation>
<DefaultData>BTReportCollectTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTReportCollectTypeD</IdLocation>
<IndexLocation>^dbo.BTReportCollectTypeI</IndexLocation>
<StreamLocation>^dbo.BTReportCollectTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
