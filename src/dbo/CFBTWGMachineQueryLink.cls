Class dbo.CFBTWGMachineQueryLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBT_WGMachineQueryLink ]
{

Index IndexMaster On (WGMachineQueryDR, LinkType, LinkDataID) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBBRPHospital created via DDL
ForeignKey FKCFBTWGMachineQueryDR(WGMachineQueryDR) References dbo.CFBTWGMachineQuery(PKCFBTWGMACHINEQUERY) [ SqlName = FK_CFBT_WGMachineQueryDR ];

/// DDL Primary Key Specification
Index PKCFBTWGMACHINEQUERYLINK On RowID [ PrimaryKey, SqlName = PK_CFBT_WGMACHINEQUERYLINK, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 查询组主键  
Property WGMachineQueryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 关联类型
Property LinkType As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 关联类型数据主键
Property LinkDataID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="CFBTWGMachineQueryLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WGMachineQueryDR</Value>
</Value>
<Value name="3">
<Value>LinkType</Value>
</Value>
<Value name="4">
<Value>LinkDataID</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBTWGMachineQueryLinkD</DataLocation>
<DefaultData>CFBTWGMachineQueryLinkDefaultData</DefaultData>
<IdLocation>^dbo.CFBTWGMachineQueryLinkD</IdLocation>
<IndexLocation>^dbo.CFBTWGMachineQueryLinkI</IndexLocation>
<StreamLocation>^dbo.CFBTWGMachineQueryLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
