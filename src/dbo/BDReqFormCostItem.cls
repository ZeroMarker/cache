/// BDReqFormCostItem
Class dbo.BDReqFormCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFCostIAddUser created via DDL
ForeignKey FKBDRFCostIAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCostI_AddUser ];

/// Foreign Key FKBDRFCostICancelUser created via DDL
ForeignKey FKBDRFCostICancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCostI_CancelUser ];

/// Foreign Key FKBDRFCostICostItem created via DDL
ForeignKey FKBDRFCostICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BD_RFCostI_CostItem ];

/// Foreign Key FKBDRFCostIExecUser created via DDL
ForeignKey FKBDRFCostIExecUser(ExecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCostI_ExecUser ];

/// Foreign Key FKBDRFCostIIssueRecord created via DDL
ForeignKey FKBDRFCostIIssueRecord(IssueRecordDR) References dbo.BDIssueRecord(PKBDISSUERECORD) [ SqlName = FK_BD_RFCostI_IssueRecord ];

/// Foreign Key FKBDRFCostIPack created via DDL
ForeignKey FKBDRFCostIPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_RFCostI_Pack ];

/// Foreign Key FKBDRFCostIReqForm created via DDL
ForeignKey FKBDRFCostIReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFCostI_ReqForm ];

/// Foreign Key FKBDRFCostIXMPlan created via DDL
ForeignKey FKBDRFCostIXMPlan(XMPlanDR) References dbo.BDXMPlan(PKBDXMPLAN) [ SqlName = FK_BD_RFCostI_XMPlan ];

/// Foreign Key FKBBRPCIReqProduct created via DDL
ForeignKey FKBBRPCIReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPCI_ReqProduct ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDRFPBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_RFP_BloodGroup ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDRFCostITestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BD_RFCostI_TestSet ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexExecDate On ExecDate [ SqlName = Index_ExecDate, Type = index ];

Index IndexIssueRecord On IssueRecordDR [ SqlName = Index_IssueRecord, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

Index IndexXMPlan On XMPlanDR [ SqlName = Index_XMPlan, Type = index ];

Index IndexHISOrderID On HISOrderID [ SqlName = Index_HISOrderID, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQFORMCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMCOSTITEM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 输血申请单  
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 费用类型  
Property CostType As %Library.SmallInt [ Required, SqlColumnNumber = 4 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 价格  
Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 6 ];

/// 数量  
Property Quantity As %Library.Float [ Required, SqlColumnNumber = 7 ];

/// 实付金额  
Property PayAmount As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 8 ];

/// 增加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 增加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 增加人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 执行日期  
Property ExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 执行时间  
Property ExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 执行用户  
Property ExecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 取消日期  
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 取消时间  
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 取消用户  
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 状态  
Property ItemStatus As %Library.SmallInt [ Required, SqlColumnNumber = 18 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

/// 血袋编号  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 配血计划  
Property XMPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 发血单  
Property IssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 是否发送成功  {1:true,0:false}
Property IsSended As %Library.Boolean [ SqlColumnNumber = 23 ];

/// 申请血产品  
Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 血型  
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 医嘱id  
Property HISOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 26 ];

/// 医保类型  
Property MedicalInsuranceType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 项目组合套   
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 加工方式{辐照：FZ,去白：QB，洗涤：XD}
Property HandleWay As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 29 ];

Storage Default
{
<Data name="BDReqFormCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>CostType</Value>
</Value>
<Value name="4">
<Value>CostItemDR</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>PayAmount</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>AddUserDR</Value>
</Value>
<Value name="11">
<Value>ExecDate</Value>
</Value>
<Value name="12">
<Value>ExecTime</Value>
</Value>
<Value name="13">
<Value>ExecUserDR</Value>
</Value>
<Value name="14">
<Value>CancelDate</Value>
</Value>
<Value name="15">
<Value>CancelTime</Value>
</Value>
<Value name="16">
<Value>CancelUserDR</Value>
</Value>
<Value name="17">
<Value>ItemStatus</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
<Value name="19">
<Value>PackDR</Value>
</Value>
<Value name="20">
<Value>XMPlanDR</Value>
</Value>
<Value name="21">
<Value>IssueRecordDR</Value>
</Value>
<Value name="22">
<Value>IsSended</Value>
</Value>
<Value name="23">
<Value>ReqProductDR</Value>
</Value>
<Value name="24">
<Value>BloodGroupDR</Value>
</Value>
<Value name="25">
<Value>HISOrderID</Value>
</Value>
<Value name="26">
<Value>MedicalInsuranceType</Value>
</Value>
<Value name="27">
<Value>TestSetDR</Value>
</Value>
<Value name="28">
<Value>HandleWay</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormCostItemD</DataLocation>
<DefaultData>BDReqFormCostItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormCostItemD</IdLocation>
<IndexLocation>^dbo.BDReqFormCostItemI</IndexLocation>
<StreamLocation>^dbo.BDReqFormCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
