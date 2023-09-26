/// 临床发送消息
Class dbo.OTSendClinicMsg Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_SendClinicMsg ]
{

/// Foreign Key FKOTSendClinicMsgLocationDR created via DDL
ForeignKey FKOTSendClinicMsgLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_OTSendClinicMsgLocationDR ];

/// Foreign Key FKOTSendClinicMsgAddUserDR created via DDL
ForeignKey FKOTSendClinicMsgAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OTSendClinicMsgAddUserDR ];

/// Foreign Key FKOTSendClinicMsgWardDR created via DDL
ForeignKey FKOTSendClinicMsgWardDR(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_OTSendClinicMsgWardDR ];

/// DDL Primary Key Specification
Index PKOTSENDCLINICMSG On RowID [ PrimaryKey, SqlName = PK_OT_SENDCLINICMSG, Type = index, Unique ];

Index IndexStatus On (Status, LocationDR, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexLocation On (AddDate, LocationDR, Status) [ SqlName = Index_Location, Type = index ];

Index IndexWard On (AddDate, WardDR, Status) [ SqlName = Index_Ward, Type = index ];

Index IndexAddDate On (AddDate, Status) [ SqlName = Index_AddDate, Type = index ];

Index IndexDataTypeDate On (DataType, AddDate) [ SqlName = Index_DataTypeDate, Type = index ];

Index IndexDataTypeDataID On (DataType, DataID) [ SqlName = Index_DataTypeDataID, Type = index ];

Index IndexLastDate On (LastDate, LocationDR) [ SqlName = Index_LastDate, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 数据类型  {W:危急值,R:拒收,T:取血通知,C:取消报告,M:多耐消息}
Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 3 ];

/// 数据ID  
Property DataID As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

/// 就诊类型  
Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 消息内容  
Property Content As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

/// 状态  {C:创建,S:发送,F:失败}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 9 ];

/// HIS医嘱ID  
Property HISOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 最后更新日期  
Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 最后更新时间  
Property LastTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 处理页面  
Property DealUrl As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 15 ];

/// 处理IP  
Property DealIP As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 16 ];

/// 发送人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

///       
Property DealRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 18 ];

/// 病区
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 处理人      
Property DealUser As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="OTSendClinicMsgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataType</Value>
</Value>
<Value name="3">
<Value>DataID</Value>
</Value>
<Value name="4">
<Value>AdmNo</Value>
</Value>
<Value name="5">
<Value>AdmType</Value>
</Value>
<Value name="6">
<Value>LocationDR</Value>
</Value>
<Value name="7">
<Value>Content</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>HISOrderID</Value>
</Value>
<Value name="10">
<Value>AddDate</Value>
</Value>
<Value name="11">
<Value>AddTime</Value>
</Value>
<Value name="12">
<Value>LastDate</Value>
</Value>
<Value name="13">
<Value>LastTime</Value>
</Value>
<Value name="14">
<Value>DealUrl</Value>
</Value>
<Value name="15">
<Value>DealIP</Value>
</Value>
<Value name="16">
<Value>AddUserDR</Value>
</Value>
<Value name="17">
<Value>DealRemark</Value>
</Value>
<Value name="18">
<Value>WardDR</Value>
</Value>
<Value name="19">
<Value>DealUser</Value>
</Value>
</Data>
<DataLocation>^dbo.OTSendClinicMsgD</DataLocation>
<DefaultData>OTSendClinicMsgDefaultData</DefaultData>
<IdLocation>^dbo.OTSendClinicMsgD</IdLocation>
<IndexLocation>^dbo.OTSendClinicMsgI</IndexLocation>
<StreamLocation>^dbo.OTSendClinicMsgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
