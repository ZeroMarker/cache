///     
Class dbo.OTPowerInterfaceLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_PowerInterfaceLog ]
{

Index IndexMaster On busId [ SqlName = Index_Master, Type = index ];

Index IndexFlowId On (flowId, busId) [ SqlName = Index_IndexFlowId, Type = index ];

Index IndexAddDate On (addDate, addTime) [ SqlName = Index_AddDate, Type = index ];

/// DDL Primary Key Specification
Index PKOTPOWERINTERFACELOG On RowID [ PrimaryKey, SqlName = PK_OT_POWERINTERFACELOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property busId As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 3 ];

Property appCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property userCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property addDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property addTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property itemCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

Property beforeVal As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

Property afterVal As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

Property status As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 11 ];

Property errMsg As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 12 ];

Property data As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Property Items As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 14 ];

Property flowId As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 15 ];

Property isApproved As %Library.Boolean [ SqlColumnNumber = 16 ];

Property approvedDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property approvedTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="OTPowerInterfaceLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>busId</Value>
</Value>
<Value name="3">
<Value>appCode</Value>
</Value>
<Value name="4">
<Value>userCode</Value>
</Value>
<Value name="5">
<Value>addDate</Value>
</Value>
<Value name="6">
<Value>addTime</Value>
</Value>
<Value name="7">
<Value>itemCode</Value>
</Value>
<Value name="8">
<Value>beforeVal</Value>
</Value>
<Value name="9">
<Value>afterVal</Value>
</Value>
<Value name="10">
<Value>status</Value>
</Value>
<Value name="11">
<Value>errMsg</Value>
</Value>
<Value name="12">
<Value>data</Value>
</Value>
<Value name="13">
<Value>Items</Value>
</Value>
<Value name="14">
<Value>flowId</Value>
</Value>
<Value name="15">
<Value>isApproved</Value>
</Value>
<Value name="16">
<Value>approvedDate</Value>
</Value>
<Value name="17">
<Value>approvedTime</Value>
</Value>
</Data>
<DataLocation>^dbo.OTPowerInterfaceLogD</DataLocation>
<DefaultData>OTPowerInterfaceLogDefaultData</DefaultData>
<IdLocation>^dbo.OTPowerInterfaceLogD</IdLocation>
<IndexLocation>^dbo.OTPowerInterfaceLogI</IndexLocation>
<StreamLocation>^dbo.OTPowerInterfaceLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
