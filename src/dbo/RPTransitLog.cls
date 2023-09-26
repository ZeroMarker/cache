Class dbo.RPTransitLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_TransitLog, StorageStrategy = Default ]
{

Index IndexMaster On (TransitDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

/// DDL Primary Key Specification
Index PKRPTRANSITLOG On RowID [ PrimaryKey, SqlName = PK_RP_TRANSITLOG, Type = index, Unique ];

/// Foreign Key FKLogTransit created via DDL
ForeignKey FKLogTransit(TransitDR) References dbo.RPTransit(PKRPTRANSIT) [ SqlName = FK_LogTransit ];

/// Foreign Key FKLogAddUser created via DDL
ForeignKey FKLogAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_LogAddUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 运送单
Property TransitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 操作日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 操作时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 操作用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 操作类型 1:创建，2：送达，3：接收，4：开箱,5：删除
Property OPType As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 7 ];

/// IP地址
Property IPAddress As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 备注
Property Remark As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPTransitLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransitDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>OPType</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RPTransitLogD</DataLocation>
<DefaultData>RPTransitLogDefaultData</DefaultData>
<IdLocation>^dbo.RPTransitLogD</IdLocation>
<IndexLocation>^dbo.RPTransitLogI</IndexLocation>
<StreamLocation>^dbo.RPTransitLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
