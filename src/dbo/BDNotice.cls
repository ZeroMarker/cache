/// 取血通知
Class dbo.BDNotice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_Notice, StorageStrategy = Default ]
{

/// Foreign Key FKBDNoticeAddUser created via DDL
ForeignKey FKBDNoticeAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Notice_AddUser ];

/// Foreign Key FKBDNoticeCancelUser created via DDL
ForeignKey FKBDNoticeCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Notice_CancelUser ];

/// Foreign Key FKBDNoticeLocation created via DDL
ForeignKey FKBDNoticeLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_Notice_Location ];

/// Foreign Key FKBDNoticeMsg created via DDL
/// ForeignKey FKBDNoticeMsg(MsgStockDR) References dbo.OTMsgStock(PKOTMSGSTOCK) [ SqlName = FK_BD_Notice_Msg ];
/// Foreign Key FKBDNoticeReceiveUser created via DDL
ForeignKey FKBDNoticeReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Notice_ReceiveUser ];

/// Foreign Key FKBDNoticeWorkGroup created via DDL
ForeignKey FKBDNoticeWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_Notice_WorkGroup ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On AddUserDR [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexCancelDate On CancelDate [ SqlName = Index_CancelDate, Type = index ];

Index IndexMaster On NoticeNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReceiveDate On ReceiveDate [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroupDR On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKBDNOTICE On RowID [ PrimaryKey, SqlName = PK_BD_NOTICE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 通知编号  
Property NoticeNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 增加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 增加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 增加用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 通知科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 通知内容  
Property MsgContent As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// 申请单列表  
Property ReqFormList As %Library.String(COLLATION = "Exact", MAXLEN = 150) [ SqlColumnNumber = 12 ];

/// 提示日期(第一次)  
Property PromptDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 提示时间(第一次)  
Property PromptTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 接收用户  
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 取消日期  
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 取消时间  
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 取消用户  
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 消息  
Property MsgStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 22 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="BDNoticeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NoticeNo</Value>
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
<Value>WorkGroupDR</Value>
</Value>
<Value name="7">
<Value>LocationDR</Value>
</Value>
<Value name="8">
<Value>RegNo</Value>
</Value>
<Value name="9">
<Value>AdmNo</Value>
</Value>
<Value name="10">
<Value>MsgContent</Value>
</Value>
<Value name="11">
<Value>ReqFormList</Value>
</Value>
<Value name="12">
<Value>PromptDate</Value>
</Value>
<Value name="13">
<Value>PromptTime</Value>
</Value>
<Value name="14">
<Value>ReceiveDate</Value>
</Value>
<Value name="15">
<Value>ReceiveTime</Value>
</Value>
<Value name="16">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="17">
<Value>CancelDate</Value>
</Value>
<Value name="18">
<Value>CancelTime</Value>
</Value>
<Value name="19">
<Value>CancelUserDR</Value>
</Value>
<Value name="20">
<Value>MsgStockDR</Value>
</Value>
<Value name="21">
<Value>Status</Value>
</Value>
<Value name="22">
<Value>Remark</Value>
</Value>
<Value name="23">
<Value>LocationDRList</Value>
</Value>
</Data>
<DataLocation>^dbo.BDNoticeD</DataLocation>
<DefaultData>BDNoticeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDNoticeD</IdLocation>
<IndexLocation>^dbo.BDNoticeI</IndexLocation>
<StreamLocation>^dbo.BDNoticeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
