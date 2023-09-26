/// 聊天消息
Class dbo.OTChatStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_ChatStock ]
{

Index IndexPerUser On (PerUser, MsgType, AddDate) [ SqlName = Index_PerUser, Type = index ];

Index IndexReceiveDate On (ReceiveDate, MsgType) [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexSendDate On (SendDate, MsgType) [ SqlName = Index_SendDate, Type = index ];

Index IndexSendUser On (SendUser, MsgType) [ SqlName = Index_SendUser, Type = index ];

/// DDL Primary Key Specification
Index PKOTChatStock On RowID [ PrimaryKey, SqlName = PK_OTChatStock, Type = index, Unique ];

Index indexAddDate On (AddDate, MsgType) [ SqlName = index_AddDate, Type = index ];

/// 主键  
Property RowID As %Library.Numeric(MAXVAL = 2147483647, MINVAL = -2147483648, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 添加人  
Property AddUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 发送日期  
Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 发送时间  
Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 发送者  
Property SendUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 目标者  
Property PerUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 通道类型  
Property MsgType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

/// 消息  
Property Msg As %Library.String(COLLATION = "Exact", MAXLEN = 999999999) [ SqlColumnNumber = 11 ];

/// 发送IP  
Property SendIP As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 接收IP  
Property ReveiveIP As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// 是否答复  {1:true,0:false}
Property IsReply As %Library.Boolean [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="OTChatStockDefaultData">
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
<Value>AddUser</Value>
</Value>
<Value name="5">
<Value>SendDate</Value>
</Value>
<Value name="6">
<Value>SendTime</Value>
</Value>
<Value name="7">
<Value>SendUser</Value>
</Value>
<Value name="8">
<Value>PerUser</Value>
</Value>
<Value name="9">
<Value>MsgType</Value>
</Value>
<Value name="10">
<Value>Msg</Value>
</Value>
<Value name="11">
<Value>SendIP</Value>
</Value>
<Value name="12">
<Value>ReceiveDate</Value>
</Value>
<Value name="13">
<Value>ReceiveTime</Value>
</Value>
<Value name="14">
<Value>ReveiveIP</Value>
</Value>
<Value name="15">
<Value>IsReply</Value>
</Value>
</Data>
<DataLocation>^dbo.OTChatStockD</DataLocation>
<DefaultData>OTChatStockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.OTChatStockD</IdLocation>
<IndexLocation>^dbo.OTChatStockI</IndexLocation>
<StreamLocation>^dbo.OTChatStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
