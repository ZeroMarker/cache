Class dbo.BDBack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_Back, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BDBack_Location ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackBackUser(BackUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDBack_BackUser ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDBack_ReceiveUser ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BDBack_WorkGroup ];

/// Foreign Key FKBBBPorductTransaction created via DDL
ForeignKey FKBDBackAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDBack_AddUser ];

Index IndexBackNo On BackNo [ SqlName = Index_BackNo, Type = index, Unique ];

Index IndexLocation On (LocationDR, AddDate) [ SqlName = Index_Location, Type = index ];

Index IndexBackDate On (BackDate, BackUserDR) [ SqlName = Index_BackDate, Type = index ];

Index IndexAddDate On (AddDate, AddUserDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, ReceiveDate) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBDBACK On RowID [ PrimaryKey, SqlName = PK_BDBACK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 回收单号
Property BackNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 回收科室
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 回收日期
Property BackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 回收时间
Property BackTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 回收用户
Property BackUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 接收日期
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 接收时间
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 接收用户
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 接收工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 状态1:登记,2:接收
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 13 ];

/// 创建日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

/// 创建时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

/// 创建用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 16 ];

/// 是否打印
Property IsPrint As %Library.Boolean [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BDBackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BackNo</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
<Value name="4">
<Value>BackDate</Value>
</Value>
<Value name="5">
<Value>BackTime</Value>
</Value>
<Value name="6">
<Value>BackUserDR</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>ReceiveDate</Value>
</Value>
<Value name="9">
<Value>ReceiveTime</Value>
</Value>
<Value name="10">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="11">
<Value>WorkGroupDR</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>AddDate</Value>
</Value>
<Value name="14">
<Value>AddTime</Value>
</Value>
<Value name="15">
<Value>AddUserDR</Value>
</Value>
<Value name="16">
<Value>IsPrint</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBackD</DataLocation>
<DefaultData>BDBackDefaultData</DefaultData>
<IdLocation>^dbo.BDBackD</IdLocation>
<IndexLocation>^dbo.BDBackI</IndexLocation>
<StreamLocation>^dbo.BDBackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
