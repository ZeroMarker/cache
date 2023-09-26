Class dbo.RPWGMachineEpis Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_WGMachineEpis, StorageStrategy = Default ]
{

Index IndexMaster On (WGMachineGroupDR, OPDate) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPWGMACHINEEPISROWID On RowID [ PrimaryKey, SqlName = PK_RP_WGMACHINEEPISROWID, Type = index, Unique ];

/// Foreign Key FKVisitNumberCarryUser created via DDL
ForeignKey FKRPWGMachineEpisUser(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPWGMachineEpisUser ];

/// Foreign Key FKVisitNumberCarryUser created via DDL
ForeignKey FKRPWGWGMachineGroupDR(WGMachineGroupDR) References dbo.BTWGMachineGroup(PKBTWGMACHINEGROUPROWID) [ SqlName = FK_RPWGWGMachineGroupDR ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组  
Property WGMachineGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property OPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 开始号  
Property NumStart As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 数量  
Property NumSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 结束号  
Property NumEnd As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 更新者  
Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="RPWGMachineEpisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WGMachineGroupDR</Value>
</Value>
<Value name="3">
<Value>OPDate</Value>
</Value>
<Value name="4">
<Value>NumStart</Value>
</Value>
<Value name="5">
<Value>NumSum</Value>
</Value>
<Value name="6">
<Value>NumEnd</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>UpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPWGMachineEpisD</DataLocation>
<DefaultData>RPWGMachineEpisDefaultData</DefaultData>
<IdLocation>^dbo.RPWGMachineEpisD</IdLocation>
<IndexLocation>^dbo.RPWGMachineEpisI</IndexLocation>
<StreamLocation>^dbo.RPWGMachineEpisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
