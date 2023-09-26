Class dbo.RPMixPanel Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MixPanel, StorageStrategy = Default ]
{

/// Foreign Key FKRPMixPanelWorkGroupMachine created via DDL
ForeignKey FKRPMixPanelWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RPMixPanelWorkGroupMachine ];

/// Foreign Key FKRPMixPanelAuthUser created via DDL
ForeignKey FKRPMixPanelAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPMixPanelAuthUser ];

/// Foreign Key FKMixPanelAddUser created via DDL
ForeignKey FKMixPanelAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MixPanelAddUser ];

/// Foreign Key FKMixPanelTestPanel created via DDL
ForeignKey FKMixPanelTestPanel(TestPanelDR) References dbo.BTTestPanel(PKBTTestPanel) [ SqlName = FK_MixPanelTestPanel ];

Index IndexMaster On (WorkGroupMachineDR, AddDate, TestPanelDR, PanelNo, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexPanelNo On (PanelNo, AddDate) [ SqlName = Index_PanelNo, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

/// DDL Primary Key Specification
Index PKRPMixPanel On RowID [ PrimaryKey, SqlName = PK_RP_MixPanel, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 检测板号
Property PanelNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

/// 使用次数
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 检测板类型
Property TestPanelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 登记时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 登记用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 行数
Property RowSum As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 10 ];

/// 列数
Property ColSum As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 11 ];

/// 状态 1：登记，2：排样；3：审核,4 完成排样
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 4) [ SqlColumnNumber = 12 ];

/// 审核日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 审核时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 审核者  
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPMixPanelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>PanelNo</Value>
</Value>
<Value name="5">
<Value>OrderNo</Value>
</Value>
<Value name="6">
<Value>TestPanelDR</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>RowSum</Value>
</Value>
<Value name="10">
<Value>ColSum</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>AuthDate</Value>
</Value>
<Value name="13">
<Value>AuthTime</Value>
</Value>
<Value name="14">
<Value>AuthUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMixPanelD</DataLocation>
<DefaultData>RPMixPanelDefaultData</DefaultData>
<IdLocation>^dbo.RPMixPanelD</IdLocation>
<IndexLocation>^dbo.RPMixPanelI</IndexLocation>
<StreamLocation>^dbo.RPMixPanelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
