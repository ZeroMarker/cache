/// 短信消息
Class dbo.OTMsgMSM Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_MsgMSM ]
{

/// Foreign Key FKOTMsgMSMAddUserDR created via DDL
ForeignKey FKOTMsgMSMAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OTMsgMSMAddUserDR ];

/// 供任务推送查询
Index IndexAddDate On (MsgType, AddDate, IsSend) [ SqlName = Index_AddDate, Type = index ];

/// 供业务判断有没有消息
Index IndexMaster On (MsgType, BllID) [ SqlName = Index_Master, Type = index ];

/// 供按用户统计
Index IndexAddUser On (MsgType, AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

/// DDL Primary Key Specification
Index PKOTMSGMSM On RowID [ PrimaryKey, SqlName = PK_OT_MSGMSM, Type = index, Unique ];

/// 主键
Property RowID As %Library.Numeric(MAXVAL = 2147483647, MINVAL = -2147483648, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 添加人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 发送日期
Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 发送时间
Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 模板用户电话
Property PerUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 消息类型，铺短信，危急值这些
Property MsgType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 9 ];

/// 消息内容
Property Msg As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 10 ];

/// 是否已发送
Property IsSend As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 业务类型
Property BllType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 业务主键
Property BllID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="OTMsgMSMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AddDate</Value>
</Value>
<Value name="3">
<Value>AddTime</Value>
</Value>
<Value name="4">
<Value>AddUserDR</Value>
</Value>
<Value name="5">
<Value>SendDate</Value>
</Value>
<Value name="6">
<Value>SendTime</Value>
</Value>
<Value name="7">
<Value>PerUser</Value>
</Value>
<Value name="8">
<Value>MsgType</Value>
</Value>
<Value name="9">
<Value>Msg</Value>
</Value>
<Value name="10">
<Value>IsSend</Value>
</Value>
<Value name="11">
<Value>BllType</Value>
</Value>
<Value name="12">
<Value>BllID</Value>
</Value>
</Data>
<DataLocation>^dbo.OTMsgMSMD</DataLocation>
<DefaultData>OTMsgMSMDefaultData</DefaultData>
<IdLocation>^dbo.OTMsgMSMD</IdLocation>
<IndexLocation>^dbo.OTMsgMSMI</IndexLocation>
<StreamLocation>^dbo.OTMsgMSMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
