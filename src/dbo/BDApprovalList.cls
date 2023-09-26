/// BDApprovalList
Class dbo.BDApprovalList Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ApprovalList, StorageStrategy = Default ]
{

/// Foreign Key FKBDALAddUser created via DDL
ForeignKey FKBDALAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AL_AddUser ];

/// Foreign Key FKBDALApproveUser created via DDL
ForeignKey FKBDALApproveUser(ApproveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AL_ApproveUser ];

/// Foreign Key FKBDALType created via DDL
ForeignKey FKBDALType(ApprovalTypeDR) References dbo.BBApprovalType(PKBBAPPROVALTYPE) [ SqlName = FK_BD_AL_Type ];

/// Foreign Key FKBDALAddUser created via DDL
ForeignKey FKBDALDeptApproveUser(DeptApproveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AL_DeptApproveUser ];

/// Foreign Key FKBDALAddUser created via DDL
ForeignKey FKBDALHeadCheckUser(HeadCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AL_HeadCheckUser ];

/// Foreign Key FKBDALAddUser created via DDL
ForeignKey FKBDALAdmDoctor(AdmDoctorDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_BD_AL_BTDoctor ];

/// Foreign Key FKBDALAddUser created via DDL
ForeignKey FKBDALFillUser(FillUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AL_FillUser ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexApproveDate On ApproveDate [ SqlName = Index_ApproveDate, Type = index ];

Index IndexMaster On ApprovalNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexDeptApproveDate On DeptApproveDate [ SqlName = Index_DeptApproveDate, Type = index ];

Index IndexFillDate On FillDate [ SqlName = Index_FillDate, Type = index ];

Index IndexHeadCheckDate On HeadCheckDate [ SqlName = Index_HeadCheckDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDAPPROVALLIST On RowID [ PrimaryKey, SqlName = PK_BD_APPROVALLIST, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 审批单号  
Property ApprovalNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 审批单类型  
Property ApprovalTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 审批日期  
Property ApproveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审批时间  
Property ApproveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审批用户  
Property ApproveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 审批模块  
Property ApproveModle As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 审批类型  
Property ApproveType As %Library.SmallInt [ Required, SqlColumnNumber = 12 ];

/// 审批意见  
Property ApprovOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

/// 业务单据列表  
Property ReqList As %Library.String(COLLATION = "Exact", MAXLEN = 160) [ SqlColumnNumber = 14 ];

/// 是否打印  {1:true,0:false}
Property IsPrinted As %Library.Boolean [ SqlColumnNumber = 15 ];

/// 是否成功发送  {1:true,0:false}
Property IsSended As %Library.Boolean [ SqlColumnNumber = 16 ];

/// 申请原因  
Property ApprovalReason As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

/// 输血科审批日期  
Property DeptApproveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 输血科审批时间  
Property DeptApproveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 输血科审批用户  
Property DeptApproveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 输血科审批意见  
Property DeptApprovOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

/// 患者主管医生  
Property AdmDoctorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 填写日期  
Property FillDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 填写时间  
Property FillTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 填写用户  
Property FillUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 超量原因  
Property ExcessRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 26 ];

/// 科主任审核日期  
Property HeadCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 科主任审核时间  
Property HeadCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 科主任审核用户  
Property HeadCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 科主任审核说明  
Property HeadCheckRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 30 ];

Storage Default
{
<Data name="BDApprovalListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApprovalNo</Value>
</Value>
<Value name="3">
<Value>ApprovalTypeDR</Value>
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
<Value>ApproveDate</Value>
</Value>
<Value name="8">
<Value>ApproveTime</Value>
</Value>
<Value name="9">
<Value>ApproveUserDR</Value>
</Value>
<Value name="10">
<Value>ApproveModle</Value>
</Value>
<Value name="11">
<Value>ApproveType</Value>
</Value>
<Value name="12">
<Value>ApprovOpinion</Value>
</Value>
<Value name="13">
<Value>ReqList</Value>
</Value>
<Value name="14">
<Value>IsPrinted</Value>
</Value>
<Value name="15">
<Value>IsSended</Value>
</Value>
<Value name="16">
<Value>ApprovalReason</Value>
</Value>
<Value name="17">
<Value>DeptApproveDate</Value>
</Value>
<Value name="18">
<Value>DeptApproveTime</Value>
</Value>
<Value name="19">
<Value>DeptApproveUserDR</Value>
</Value>
<Value name="20">
<Value>DeptApprovOpinion</Value>
</Value>
<Value name="21">
<Value>AdmDoctorDR</Value>
</Value>
<Value name="22">
<Value>FillDate</Value>
</Value>
<Value name="23">
<Value>FillTime</Value>
</Value>
<Value name="24">
<Value>FillUserDR</Value>
</Value>
<Value name="25">
<Value>ExcessRemark</Value>
</Value>
<Value name="26">
<Value>HeadCheckDate</Value>
</Value>
<Value name="27">
<Value>HeadCheckTime</Value>
</Value>
<Value name="28">
<Value>HeadCheckUserDR</Value>
</Value>
<Value name="29">
<Value>HeadCheckRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDApprovalListD</DataLocation>
<DefaultData>BDApprovalListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDApprovalListD</IdLocation>
<IndexLocation>^dbo.BDApprovalListI</IndexLocation>
<StreamLocation>^dbo.BDApprovalListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
