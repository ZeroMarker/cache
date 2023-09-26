///     
Class dbo.BTWorkGroupTSGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupTSGroup ]
{

/// Foreign Key FKBTWorkGroupTSGroupWorkGroupDR created via DDL
ForeignKey FKBTWorkGroupTSGroupWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTWorkGroupTSGroupWorkGroupDR ];

Index IndexMaster On (WorkGroupDR, Code) [ SqlName = IndexMaster, Type = index ];

Index IndexCode On (WorkGroupDR, Code, Type) [ SqlName = IndexCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPTSGROUP On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPTSGROUP, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

// 1:工作组医嘱统计分组，其他的后期扩展

Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTWorkGroupTSGroupDefaultData">
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
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupTSGroupD</DataLocation>
<DefaultData>BTWorkGroupTSGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTWorkGroupTSGroupD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupTSGroupI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupTSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
