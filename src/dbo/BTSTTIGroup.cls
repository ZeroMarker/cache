Class dbo.BTSTTIGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTST_TIGroup ]
{

/// Foreign Key FKWorkGroupDepart created via DDL
ForeignKey FKBTSTTIGroupDepart(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_BTSTTIGroupDepart ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBTSTTIGroup On RowID [ PrimaryKey, SqlName = PK_BTST_TIGroup, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 分钟
Property TATVal As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 分钟
Property TATValIn As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 科室
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTSTTIGroupDefaultData">
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
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>TATVal</Value>
</Value>
<Value name="7">
<Value>TATValIn</Value>
</Value>
<Value name="8">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSTTIGroupD</DataLocation>
<DefaultData>BTSTTIGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTSTTIGroupD</IdLocation>
<IndexLocation>^dbo.BTSTTIGroupI</IndexLocation>
<StreamLocation>^dbo.BTSTTIGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
