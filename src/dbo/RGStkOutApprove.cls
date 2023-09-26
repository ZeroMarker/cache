///     
Class dbo.RGStkOutApprove Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkOutApprove, StorageStrategy = Default ]
{

/// Foreign Key FKRGStkOutApproveJunior created via DDL
ForeignKey FKRGStkOutApproveJunior(JuniorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkOutApprove_Junior ];

/// Foreign Key FKRGStkOutApproveSenior created via DDL
ForeignKey FKRGStkOutApproveSenior(SeniorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkOutApprove_Senior ];

/// Foreign Key FKRGStkOutApproveStkOut created via DDL
ForeignKey FKRGStkOutApproveStkOut(StkOutDR) References dbo.RGStkOut(PKRGSTKOUT) [ SqlName = FK_RG_StkOutApprove_StkOut ];

Index IndexStkOut On StkOutDR [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRGStkOutApprove On RowID [ PrimaryKey, SqlName = PK_RG_StkOutApprove, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StkOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property JuniorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property JuniorAdvance As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property JuniorPassed As %Library.Boolean [ SqlColumnNumber = 7 ];

Property JuniorDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property JuniorTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property SeniorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SeniorAdvance As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

Property SeniorPassed As %Library.Boolean [ SqlColumnNumber = 12 ];

Property SeniorDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property SeniorTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RGStkOutApproveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>StkOutDR</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>JuniorDR</Value>
</Value>
<Value name="6">
<Value>JuniorAdvance</Value>
</Value>
<Value name="7">
<Value>JuniorPassed</Value>
</Value>
<Value name="8">
<Value>JuniorDate</Value>
</Value>
<Value name="9">
<Value>JuniorTime</Value>
</Value>
<Value name="10">
<Value>SeniorDR</Value>
</Value>
<Value name="11">
<Value>SeniorAdvance</Value>
</Value>
<Value name="12">
<Value>Seniorpassed</Value>
</Value>
<Value name="13">
<Value>SeniorDate</Value>
</Value>
<Value name="14">
<Value>SeniorTime</Value>
</Value>
<Value name="15">
<Value>SeniorPassed</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkOutApproveD</DataLocation>
<DefaultData>RGStkOutApproveDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkOutApproveD</IdLocation>
<IndexLocation>^dbo.RGStkOutApproveI</IndexLocation>
<StreamLocation>^dbo.RGStkOutApproveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
