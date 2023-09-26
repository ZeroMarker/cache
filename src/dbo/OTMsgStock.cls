/// 业务消息表
Class dbo.OTMsgStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_MsgStock, StorageStrategy = Default ]
{

Index IndexIsSendToCS On (MsgType, IsSendToCS) [ SqlName = Index_IsSendToCS, Type = index ];

Index IndexIsReply On (MsgType, IsReply) [ SqlName = Index_IsReply, Type = index ];

Index IndexIsSendReport On (MsgType, IsSendReport) [ SqlName = Index_IsSendReport, Type = index ];

Index IndexPrint On (MsgType, BllType) [ SqlName = Index_Print, Type = index ];

Index IndexExtra On (MsgType, Extral) [ SqlName = Index_Extral, Type = index ];

Index IndexPerUser On (PerUser, MsgType, AddDate) [ SqlName = Index_PerUser, Type = index ];

Index IndexReceiveDate On (ReceiveDate, MsgType) [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexSendDate On (SendDate, MsgType) [ SqlName = Index_SendDate, Type = index ];

Index IndexSendUser On (SendUser, MsgType) [ SqlName = Index_SendUser, Type = index ];

Index IndexBllType On (BllType, BllID) [ SqlName = Index_BllType, Type = index ];

Index IndexMsgType On (BllID, MsgType) [ SqlName = IndexMsgType, Type = index ];

/// DDL Primary Key Specification
Index PKOTMSGSTOCK On RowID [ PrimaryKey, SqlName = PK_OT_MSGSTOCK, Type = index, Unique ];

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
Property MsgType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 10 ];

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

/// 业务类型  
Property BllType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 业务ID  
Property BllID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

///       
Property IsSendReport As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 19 ];

///       
Property Extral As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 20 ];

///       
Property IsSendToCS As %Library.Boolean [ SqlColumnNumber = 21 ];

/// 确认用户
Property ConfirmUserID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

/// 确认日期  
Property ConfirmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 确认时间  
Property ConfirmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 消息响应代码
Property ResponseStatus As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 25 ];

/// 消息响应内容
Property ResponseContent As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 26 ];

/// 消息响应日期
Property ResponseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 消息响应时间  
Property ResponseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Storage Default
{
<Data name="OTMsgStockDefaultData">
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
<Value name="16">
<Value>BllType</Value>
</Value>
<Value name="17">
<Value>BllID</Value>
</Value>
<Value name="18">
<Value>IsSendReport</Value>
</Value>
<Value name="19">
<Value>Extral</Value>
</Value>
<Value name="20">
<Value>IsSendToCS</Value>
</Value>
<Value name="21">
<Value>ConfirmUserID</Value>
</Value>
<Value name="22">
<Value>ConfirmDate</Value>
</Value>
<Value name="23">
<Value>ConfirmTime</Value>
</Value>
<Value name="24">
<Value>ResponseStatus</Value>
</Value>
<Value name="25">
<Value>ResponseContent</Value>
</Value>
<Value name="26">
<Value>ResponseDate</Value>
</Value>
<Value name="27">
<Value>ResponseTime</Value>
</Value>
</Data>
<DataLocation>^dbo.OTMsgStockD</DataLocation>
<DefaultData>OTMsgStockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.OTMsgStockD</IdLocation>
<IndexLocation>^dbo.OTMsgStockI</IndexLocation>
<StreamLocation>^dbo.OTMsgStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
