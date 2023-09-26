/// BDIssueRecord
Class dbo.BDIssueRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_IssueRecord, StorageStrategy = Default ]
{

/// Foreign Key FKBDIssueRecordCancleUser created via DDL
ForeignKey FKBDIssueRecordCancleUser(CancleUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_IssueRecord_CancleUser ];

/// Foreign Key FKBDIssueRecordIssueUser created via DDL
ForeignKey FKBDIssueRecordIssueUser(IssueUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_IssueRecord_IssueUser ];

/// Foreign Key FKBDIssueRecordLocation created via DDL
ForeignKey FKBDIssueRecordLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_IssueRecord_Location ];

/// Foreign Key FKBDIssueRecordReq created via DDL
ForeignKey FKBDIssueRecordReq(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_IssueRecord_Req ];

/// Foreign Key FKBDIssueRecordTakeRecord created via DDL
ForeignKey FKBDIssueRecordTakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_IssueRecord_TakeRecord ];

/// Foreign Key FKBDIssueRecordIssueUser created via DDL
ForeignKey FKBDIssueRecordIssCheckUser(IssCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_IssueRecord_IssCheckUser ];

/// Foreign Key FKBDIssueRecordRecoverUser created via DDL
ForeignKey FKBDIssueRecordIssRecoverUser(RecoverUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_IssueRecord_IssRecoverUser ];

Index IndexMaster On RecordNo [ SqlName = Index_Master, Type = index ];

Index IndexIssueDate On IssueDate [ SqlName = Index_IssueDate, Type = index ];

Index IndexRecoverDate On RecoverDate [ SqlName = Index_RecoverDate, Type = index ];

Index IndexRecordNo On RecordNo [ SqlName = Index_RecordNo, Type = index, Unique ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

/// DDL Primary Key Specification
Index PKBDISSUERECORD On RowID [ PrimaryKey, SqlName = PK_BD_ISSUERECORD, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 记录单号  
Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 发血日期  
Property IssueDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 发血时间  
Property IssueTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 发血用户  
Property IssueUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

/// 取血单  
Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 取血人  
Property TakeUserName As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 临床用血科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 输血申请单  
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 12 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 13 ];

/// 取消日期  
Property CancleDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 取消时间  
Property CancleTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 取消用户  
Property CancleUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 是否打印  {1:true,0:false}
Property IsPrinted As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 取血人签名文件名
Property SignFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

/// 发血核对用户
Property IssCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 发血方式      
Property IssType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 发血设备id     
Property DeviceID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 发血单交付人      
Property TransUserBeforeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 发血单接收人
Property TransUserAfterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 发血单交接日期   
Property TransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 发血单交接时间 
Property TransTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 发血单回收人
Property RecoverUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

// 发血单回收日期

Property RecoverDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 发血单回收时间
Property RecoverTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 取血说明  
Property TransRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 29 ];

/// 输血类型10手术用血 20非手术用血  
Property TransfusionType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 30 ];

Storage Default
{
<Data name="BDIssueRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordNo</Value>
</Value>
<Value name="3">
<Value>XMPlanDR</Value>
</Value>
<Value name="4">
<Value>IssueDate</Value>
</Value>
<Value name="5">
<Value>IssueTime</Value>
</Value>
<Value name="6">
<Value>IssueUserDR</Value>
</Value>
<Value name="7">
<Value>RegNo</Value>
</Value>
<Value name="8">
<Value>TakeRecordDR</Value>
</Value>
<Value name="9">
<Value>TakeUserName</Value>
</Value>
<Value name="10">
<Value>LocationDR</Value>
</Value>
<Value name="11">
<Value>ReqFormDR</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>CancleDate</Value>
</Value>
<Value name="15">
<Value>CancleTime</Value>
</Value>
<Value name="16">
<Value>CancleUserDR</Value>
</Value>
<Value name="17">
<Value>IsPrinted</Value>
</Value>
<Value name="18">
<Value>SignFileName</Value>
</Value>
<Value name="19">
<Value>IssCheckUserDR</Value>
</Value>
<Value name="20">
<Value>IssType</Value>
</Value>
<Value name="21">
<Value>DeviceID</Value>
</Value>
<Value name="22">
<Value>TransUserBeforeDR</Value>
</Value>
<Value name="23">
<Value>TransUserAfterDR</Value>
</Value>
<Value name="24">
<Value>TransDate</Value>
</Value>
<Value name="25">
<Value>TransTime</Value>
</Value>
<Value name="26">
<Value>RecoverUserDR</Value>
</Value>
<Value name="27">
<Value>RecoverDate</Value>
</Value>
<Value name="28">
<Value>RecoverTime</Value>
</Value>
<Value name="29">
<Value>TransRemark</Value>
</Value>
<Value name="30">
<Value>TransfusionType</Value>
</Value>
</Data>
<DataLocation>^dbo.BDIssueRecordD</DataLocation>
<DefaultData>BDIssueRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDIssueRecordD</IdLocation>
<IndexLocation>^dbo.BDIssueRecordI</IndexLocation>
<StreamLocation>^dbo.BDIssueRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
