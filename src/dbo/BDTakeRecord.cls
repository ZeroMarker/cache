/// BDTakeRecord
Class dbo.BDTakeRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecord, StorageStrategy = Default ]
{

/// Foreign Key FKBDTRecordAddUser created via DDL
ForeignKey FKBDTRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_AddUser ];

/// Foreign Key FKBDTRecordCancleUser created via DDL
ForeignKey FKBDTRecordCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_CancleUser ];

/// Foreign Key FKBDTRecordCheckUser created via DDL
ForeignKey FKBDTRecordCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_CheckUser ];

/// Foreign Key FKBDTRecordCheckUser created via DDL
ForeignKey FKBDTRecordAnalgUser(AnalgUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_AnalgUser ];

/// Foreign Key FKBDTRecordCheckUser created via DDL
ForeignKey FKBDTRecordSurgeonUser(SurgeonUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_SurgeonUser ];

/// Foreign Key FKBDTRecordLocation created via DDL
ForeignKey FKBDTRecordLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_TRecord_Location ];

/// Foreign Key FKBDTRecordReqForm created via DDL
ForeignKey FKBDTRecordReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_TRecord_ReqForm ];

ForeignKey FKBDTRecordWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_TRecord_WorkGroup ];

ForeignKey FKBDTRecordReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_ReceiveUser ];

ForeignKey FKBDTRecordNotice(NoticeDR) References dbo.BDNotice(PKBDNOTICE) [ SqlName = FK_BD_TRecord_Notice ];

ForeignKey FKBDTRecordTakeUser(TakeUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRecord_TakeUser ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexCancelDate On CancelDate [ SqlName = Index_CancleDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexLocation On LocationDR [ SqlName = Index_Location, Type = index ];

Index IndexMaster On RecordNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRequestForm On ReqFormDR [ SqlName = Index_RequestForm, Type = index ];

Index IndexReceiveDate On ReceiveDate [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, ReceiveDate) [ SqlName = Index_WorkGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKBDTAKERECORD On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORD, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 记录单号  
Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 输血申请单  
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核人  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 取血科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 取消日期  
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 取消时间  
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 取消人  
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 取血人  
Property TakeUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 术中出血量  
Property OutVolume As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 输血地点  
Property TransLocation As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 18 ];

/// 状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 19 ];

/// 是否打印  {1:true,0:false}
Property IsPrinted As %Library.Boolean [ SqlColumnNumber = 20 ];

/// 是否取血  {1:true,0:false}
Property IsTaked As %Library.Boolean [ SqlColumnNumber = 21 ];

/// AnalgUserDR  
Property AnalgUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// SurgeonUse  
Property SurgeonUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 取血电话  
Property TakeTel As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 24 ];

/// 特殊原因  
Property SpecialReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 25 ];

/// 其他原因  
Property OtherReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 26 ];

/// 记录类型  
Property RecordType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 27 ];

/// 接收工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 输血科接收日期
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 接收时间
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 接收用户
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 取血通知
Property NoticeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 取消或拒收说明
Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 33 ];

/// 取血用户
Property TakeUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 取血用户接收日期
Property TakeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 取血用户接收时间
Property TakeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 可耐受最大失血量  
Property MaxVolume As %Library.Float [ SqlColumnNumber = 37 ];

/// 实际失血量  
Property RealVolume As %Library.Float [ SqlColumnNumber = 38 ];

/// 累计发血量  
Property UseVolume As %Library.Float [ SqlColumnNumber = 39 ];

/// 心率
Property HeartRate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// 脉搏
Property Pulse As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 41 ];

/// 呼吸
Property BreathRate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 42 ];

/// 体温
Property BodyTemp As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 43 ];

/// 体温
Property Pressure As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 44 ];

/// SpO2(%)
Property SpO2 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 45 ];

/// HGB
Property HGB As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 46 ];

Storage Default
{
<Data name="BDTakeRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordNo</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>CheckDate</Value>
</Value>
<Value name="8">
<Value>CheckTime</Value>
</Value>
<Value name="9">
<Value>CheckUserDR</Value>
</Value>
<Value name="10">
<Value>LocationDR</Value>
</Value>
<Value name="11">
<Value>CancelDate</Value>
</Value>
<Value name="12">
<Value>CancelTime</Value>
</Value>
<Value name="13">
<Value>CancelUserDR</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
<Value name="15">
<Value>TakeUser</Value>
</Value>
<Value name="16">
<Value>OutVolume</Value>
</Value>
<Value name="17">
<Value>TransLocation</Value>
</Value>
<Value name="18">
<Value>Status</Value>
</Value>
<Value name="19">
<Value>IsPrinted</Value>
</Value>
<Value name="20">
<Value>IsTaked</Value>
</Value>
<Value name="21">
<Value>AnalgUserDR</Value>
</Value>
<Value name="22">
<Value>SurgeonUserDR</Value>
</Value>
<Value name="23">
<Value>TakeTel</Value>
</Value>
<Value name="24">
<Value>SpecialReason</Value>
</Value>
<Value name="25">
<Value>OtherReason</Value>
</Value>
<Value name="26">
<Value>RecordType</Value>
</Value>
<Value name="27">
<Value>WorkGroupDR</Value>
</Value>
<Value name="28">
<Value>ReceiveDate</Value>
</Value>
<Value name="29">
<Value>ReceiveTime</Value>
</Value>
<Value name="30">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="31">
<Value>NoticeDR</Value>
</Value>
<Value name="32">
<Value>CancelRemark</Value>
</Value>
<Value name="33">
<Value>CarryUserDR</Value>
</Value>
<Value name="34">
<Value>TakeUserDR</Value>
</Value>
<Value name="35">
<Value>TakeDate</Value>
</Value>
<Value name="36">
<Value>TakeTime</Value>
</Value>
<Value name="37">
<Value>MaxVolume</Value>
</Value>
<Value name="38">
<Value>RealVolume</Value>
</Value>
<Value name="39">
<Value>UseVolume</Value>
</Value>
<Value name="40">
<Value>HeartRate</Value>
</Value>
<Value name="41">
<Value>Pulse</Value>
</Value>
<Value name="42">
<Value>BreathRate</Value>
</Value>
<Value name="43">
<Value>BodyTemp</Value>
</Value>
<Value name="44">
<Value>Pressure</Value>
</Value>
<Value name="45">
<Value>SpO2</Value>
</Value>
<Value name="46">
<Value>HGB</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordD</DataLocation>
<DefaultData>BDTakeRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDTakeRecordD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
