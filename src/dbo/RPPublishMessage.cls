/// 标本发布消息
Class dbo.RPPublishMessage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_PublishMessage ]
{

Index IndexMaster On (RegNo, PublishType, PublishID, CreatDate, CreatTime) [ SqlName = Index_Master, Type = index ];

Index IndexReport On (VisitnumberReportID, PublishType, PublishID, CreatDate, CreatTime) [ SqlName = Index_Report, Type = index ];

Index IndexMessageType On (RegNo, PublishMessageTypeDR) [ SqlName = Index_MessageType, Type = index ];

Index IndexCreatDate On (CreatDate, CreatTime, PublishMessageTypeDR) [ SqlName = Index_CreatDate, Type = index ];

Index PKRPPUBLISHMESSAGE On RowID [ PrimaryKey, SqlName = PK_RP_PUBLISHMESSAGE, Type = index, Unique ];

ForeignKey FKPublishMsgType(PublishMessageTypeDR) References dbo.BTPublishMessageType(PKBTPUBLISHMESSAGETYPE) [ SqlName = FK_PublishMsgType ];

ForeignKey FKRPPublishMessageUserDR(CreatUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPPublishMessageUserDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 消息发出的登记号
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 消息发出的报告
Property VisitnumberReportID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 发布类型:TS：相同医嘱，USR：用户，WGM：工作小组，WG：工作组，LOC：科室，DEP：检验科室，HOS：医院，SYS：系统,REP:当前报告
Property PublishType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 发布类型对应的ID
Property PublishID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 发布消息标记类别（疑难杂症等的标记），实现报告处理右键
Property PublishMessageTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property MsgContent As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 8 ];

Property CreatUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property CreatDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property CreatTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 消息发出的标本
Property VisitnumberID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 标记内容
Property IsReport As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 标记内容
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPPublishMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>VisitnumberReportID</Value>
</Value>
<Value name="4">
<Value>PublishType</Value>
</Value>
<Value name="5">
<Value>PublishID</Value>
</Value>
<Value name="6">
<Value>PublishMessageTypeDR</Value>
</Value>
<Value name="7">
<Value>MsgContent</Value>
</Value>
<Value name="8">
<Value>CreatUserDR</Value>
</Value>
<Value name="9">
<Value>CreatDate</Value>
</Value>
<Value name="10">
<Value>CreatTime</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
<Value name="12">
<Value>VisitnumberID</Value>
</Value>
<Value name="13">
<Value>IsReport</Value>
</Value>
<Value name="14">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPPublishMessageD</DataLocation>
<DefaultData>RPPublishMessageDefaultData</DefaultData>
<IdLocation>^dbo.RPPublishMessageD</IdLocation>
<IndexLocation>^dbo.RPPublishMessageI</IndexLocation>
<StreamLocation>^dbo.RPPublishMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
