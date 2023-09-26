/// 排样规则医嘱分堆 表
Class dbo.BTSmartEpisTSGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisTSGroup ]
{

/// Foreign Key FKBTSmartEpisTSGroupWorkGroupDR created via DDL
ForeignKey FKBTSmartEpisTSGroupWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTSmartEpisTSGroupWorkGroupDR ];

Index IndexMaster On (WorkGroupDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNo On (WorkGroupDR, SeqNo) [ SqlName = Index_SeqNo, Type = index ];

/// DDL Primary Key Specification
Index PKBTSmartEpisTSGroup On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisTSGroup, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 显示顺序
Property SeqNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTSmartEpisTSGroupDefaultData">
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
<Value>SeqNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisTSGroupD</DataLocation>
<DefaultData>BTSmartEpisTSGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisTSGroupD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisTSGroupI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisTSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
