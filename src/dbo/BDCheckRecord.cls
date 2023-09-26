/// 	血液寄存单
Class dbo.BDCheckRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_CheckRecord ]
{

/// Foreign Key FKBDCheckRecordLocationDR created via DDL
ForeignKey FKBDCheckRecordLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BDCheckRecordLocationDR ];

/// Foreign Key FKBDCheckRecordAddUserDR created via DDL
ForeignKey FKBDCheckRecordAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDCheckRecordAddUserDR ];

/// Foreign Key FKBDCheckRecordWorkGroupDR created via DDL
ForeignKey FKBDCheckRecordWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BDCheckRecordWorkGroupDR ];

/// DDL Primary Key Specification
Index PKBDCHECKRECORD On RowID [ PrimaryKey, SqlName = PK_BD_CHECKRECORD, Type = index, Unique ];

Index IndexMaster On CheckNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 寄存单号
Property CheckNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 寄存原因
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 寄存科室
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 寄存日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 寄存时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 寄存用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckNo</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>LocationDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDCheckRecordD</DataLocation>
<DefaultData>BDCheckRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDCheckRecordD</IdLocation>
<IndexLocation>^dbo.BDCheckRecordI</IndexLocation>
<StreamLocation>^dbo.BDCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
