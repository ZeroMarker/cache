/// 标本信息修改日志
Class dbo.RPVisitNumberInfoModifyLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberInfoModifyLog, StorageStrategy = Default ]
{

/// Foreign Key FKRPVisitNumberInfoModifyHistoryRPVisitNumber created via DDL
ForeignKey FKRPVisitNumberInfoModifyHistoryRPVisitNumber(VisitnumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RP_VisitNumberInfoModifyHistory_RP_VisitNumber ];

/// Foreign Key FKRPVisitNumberInfoModifyHistorySYSUser created via DDL
ForeignKey FKRPVisitNumberInfoModifyHistorySYSUser(ModifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitNumberInfoModifyHistory_SYS_User ];

Index IndexMaster On (VisitnumberDR, ModifyDate, ModifyTime) [ SqlName = IX_RP_VisitNumberInfoModifyLog, Type = index ];

/// DDL Primary Key Specification
Index PKRPVisitNumberInfoModifyHistory On RowID [ PrimaryKey, SqlName = PK_RP_VisitNumberInfoModifyHistory, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitnumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 修改日期  
Property ModifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 修改时间  
Property ModifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// ModifyItem  
Property ModifyItem As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

/// PreContent  
Property PreContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// AfterContent  
Property AfterContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 修改人  
Property ModifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// ModifyClientIP  
Property ModifyClientIP As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 10 ];

Storage Default
{
<Data name="RPVisitNumberInfoModifyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitnumberDR</Value>
</Value>
<Value name="3">
<Value>ModifyDate</Value>
</Value>
<Value name="4">
<Value>ModifyTime</Value>
</Value>
<Value name="5">
<Value>ModifyItem</Value>
</Value>
<Value name="6">
<Value>PreContent</Value>
</Value>
<Value name="7">
<Value>AfterContent</Value>
</Value>
<Value name="8">
<Value>ModifyUserDR</Value>
</Value>
<Value name="9">
<Value>ModifyClientIP</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberInfoModifyLogD</DataLocation>
<DefaultData>RPVisitNumberInfoModifyLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberInfoModifyLogD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberInfoModifyLogI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberInfoModifyLogD</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
