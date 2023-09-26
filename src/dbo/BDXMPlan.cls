/// BDXMPlan
Class dbo.BDXMPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_XMPlan, StorageStrategy = Default ]
{

/// Foreign Key FKBDXMPlanAddUser created via DDL
ForeignKey FKBDXMPlanAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_XMPlan_AddUser ];

/// Foreign Key FKBDXMPlanLastResult created via DDL
ForeignKey FKBDXMPlanLastResult(XMLastResultDR) References dbo.BBXMLastResult(PKBBXMLASTRESULT) [ SqlName = FK_BD_XMPlan_LastResult ];

/// Foreign Key FKBDXMPlanMachineParameter created via DDL
ForeignKey FKBDXMPlanMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BD_XMPlan_MachineParameter ];

/// Foreign Key FKBDXMPlanMajorXMConclusion created via DDL
ForeignKey FKBDXMPlanMajorXMConclusion(MajorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BD_XMPlan_MajorXMConclusion ];

/// Foreign Key FKBDXMPlanMajorXMDepict created via DDL
ForeignKey FKBDXMPlanMajorXMDepict(MajorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BD_XMPlan_MajorXMDepict ];

/// Foreign Key FKBDXMPlanMajorXMResult created via DDL
ForeignKey FKBDXMPlanMajorXMResult(MajorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BD_XMPlan_MajorXMResult ];

/// Foreign Key FKBDXMPlanMethod created via DDL
ForeignKey FKBDXMPlanMethod(XMMethodDR) References dbo.BBXMMethod(PKBBXMMETHOD) [ SqlName = FK_BD_XMPlan_Method ];

/// Foreign Key FKBDXMPlanMinorXMConclusion created via DDL
ForeignKey FKBDXMPlanMinorXMConclusion(MinorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BD_XMPlan_MinorXMConclusion ];

/// Foreign Key FKBDXMPlanMinorXMDepict created via DDL
ForeignKey FKBDXMPlanMinorXMDepict(MinorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BD_XMPlan_MinorXMDepict ];

/// Foreign Key FKBDXMPlanMinorXMResult created via DDL
ForeignKey FKBDXMPlanMinorXMResult(MinorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BD_XMPlan_MinorXMResult ];

/// Foreign Key FKBDXMPlanPack created via DDL
ForeignKey FKBDXMPlanPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_XMPlan_Pack ];

/// Foreign Key FKBDXMPlanReq created via DDL
ForeignKey FKBDXMPlanReq(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_XMPlan_Req ];

/// Foreign Key FKBDXMPlanXMCheckUser created via DDL
ForeignKey FKBDXMPlanXMCheckUser(XMCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_XMPlan_XMCheckUser ];

ForeignKey FKBDXMPlanTransaction(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_BD_XMPlan_Transaction ];

ForeignKey FKUploadMachineParameter(UploadMachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_Upload_MachineParameter ];

ForeignKey FKBDXMPlanExtInstitution(ExtTestInstitutionDR) References dbo.BDTestInstitution(PKBDTESTINSTITUTION) [ SqlName = FK_BD_XMPlan_ExtInstitution ];

ForeignKey FKBDXMPlanVerifyUser(VerifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_XMPlan_VerifyUser ];

ForeignKey FKBDXMPlanCrtBloodGroup(CrtBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_XMPlan_CrtBloodGroup ];

ForeignKey FKBDXMPlanChkBloodGroup(ChkBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_XMPlan_ChkBloodGroup ];

/// Foreign Key FKBDRFPProduct created via DDL
ForeignKey FKBDRFPProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BD_XMPlan_Product ];

ForeignKey FKBDXMPlanSaveUser(SaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_XMPlan_SaveUser ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexMaster On (ReqFormDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexSampleNo On SampleNo [ SqlName = Index_SampleNo, Type = index ];

Index IndexXMCheckDate On XMCheckDate [ SqlName = Index_XMCheckDate, Type = index ];

Index IndexXMPlanNo On XMPlanNo [ SqlName = Index_XMPlanNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDXMPLAN On RowID [ PrimaryKey, SqlName = PK_BD_XMPLAN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单  
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋编号  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 标本号  
Property SampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

/// 血袋编码  
Property PackBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 增加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 增加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 增加用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 主侧现象id  
Property MajorXMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 主侧现象描述  
Property MajorXMDepictStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 主侧结果id  
Property MajorXMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 主侧结构描述  
Property MajorXMResultStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 主侧结论id  
Property MajorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 湖策结论描述  
Property MajorXMConclusionStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// 次侧现象id  
Property MinorXMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 次侧现象描述  
Property MinorXMDepictStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 次侧结果id  
Property MinorXMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 次侧结果描述  
Property MinorXMResultStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 次侧结论ID  
Property MinorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 次侧结论描述  
Property MinorXMConclusionStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 交叉配血方法  
Property XMMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 交叉配血最终结果id  
Property XMLastResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 交叉配血最终结果描述  
Property XMLastResultStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 25 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 26 ];

/// 配血单号  
Property XMPlanNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 27 ];

/// 配血单审核日期  
Property XMCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 配血单审核时间  
Property XMCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 配血单审核人  
Property XMCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 配血是否完成  {1:true,0:false}
Property IsFinished As %Library.Boolean [ SqlColumnNumber = 31 ];

/// 是否发送取血通知  {1:true,0:false}
Property IsNoticed As %Library.Boolean [ SqlColumnNumber = 32 ];

/// 是否发血  {1:true,0:false}
Property IsIssued As %Library.Boolean [ SqlColumnNumber = 33 ];

/// 操作类型   
Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 复检血型  
Property CheckBloodGroupRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 35 ];

/// 复检血型表型  
Property CheckBloodPhenotype As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 36 ];

/// 抗体筛查结果  
Property AntibodyScreenRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 37 ];

/// 上传仪器主键  
Property UploadMachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 是否疑难配血  {1:true,0:false}
Property IsBldDifficult As %Library.Boolean [ SqlColumnNumber = 39 ];

/// 疑难配血描述  
Property BldDifficultDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 40 ];

///       
Property IsExternal As %Library.Boolean [ SqlColumnNumber = 41 ];

///       
Property ExtTestInstitutionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 42 ];

///       
Property ExtXMDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 43 ];

///       
Property ExtXMTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 44 ];

///       
Property ExtXMEntryUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 45 ];

///       
Property ExtXMAuthUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 46 ];

/// 是否校验  {1:true,0:false}
Property IsVerify As %Library.Boolean [ SqlColumnNumber = 47 ];

/// 校验日期  
Property VerifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 48 ];

/// 校验时间  
Property VerifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 49 ];

/// 校验人  
Property VerifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

/// 配血计划血型组
Property CrtBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 51 ];

/// 配血Rh表型
Property CrtRhPhenotype As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 52 ];

/// 配血审核血型组
Property ChkBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

/// 申请血产品  
Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

/// 状态 {10：登记，15：上机，20：配血审核，21：取消配血，25：取血通知，30：发血，31：取消发血}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 55 ];

/// 保存日期  
Property SaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 56 ];

/// 保存时间  
Property SaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

/// 保存人  
Property SaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 58 ];

/// 直抗实验结果
Property DATest As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 59 ];

/// 自身对照实验结果
Property SCTest As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 60 ];

/// 是否终止取血默认否 {1:true,0:false}
Property IsStop As %Library.Boolean [ SqlColumnNumber = 61 ];

Storage Default
{
<Data name="BDXMPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>SampleNo</Value>
</Value>
<Value name="5">
<Value>PackBarcode</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>MajorXMDepictDR</Value>
</Value>
<Value name="10">
<Value>MajorXMDepictStr</Value>
</Value>
<Value name="11">
<Value>MajorXMResultDR</Value>
</Value>
<Value name="12">
<Value>MajorXMResultStr</Value>
</Value>
<Value name="13">
<Value>MajorXMConclusionDR</Value>
</Value>
<Value name="14">
<Value>MajorXMConclusionStr</Value>
</Value>
<Value name="15">
<Value>MinorXMDepictDR</Value>
</Value>
<Value name="16">
<Value>MinorXMDepictStr</Value>
</Value>
<Value name="17">
<Value>MinorXMResultDR</Value>
</Value>
<Value name="18">
<Value>MinorXMResultStr</Value>
</Value>
<Value name="19">
<Value>MinorXMConclusionDR</Value>
</Value>
<Value name="20">
<Value>MinorXMConclusionStr</Value>
</Value>
<Value name="21">
<Value>MachineParameterDR</Value>
</Value>
<Value name="22">
<Value>XMMethodDR</Value>
</Value>
<Value name="23">
<Value>XMLastResultDR</Value>
</Value>
<Value name="24">
<Value>XMLastResultStr</Value>
</Value>
<Value name="25">
<Value>Remark</Value>
</Value>
<Value name="26">
<Value>XMPlanNo</Value>
</Value>
<Value name="27">
<Value>XMCheckDate</Value>
</Value>
<Value name="28">
<Value>XMCheckTime</Value>
</Value>
<Value name="29">
<Value>XMCheckUserDR</Value>
</Value>
<Value name="30">
<Value>IsFinished</Value>
</Value>
<Value name="31">
<Value>IsNoticed</Value>
</Value>
<Value name="32">
<Value>IsIssued</Value>
</Value>
<Value name="33">
<Value>TransactionDR</Value>
</Value>
<Value name="34">
<Value>CheckBloodGroupRes</Value>
</Value>
<Value name="35">
<Value>CheckBloodPhenotype</Value>
</Value>
<Value name="36">
<Value>AntibodyScreenRes</Value>
</Value>
<Value name="37">
<Value>UploadMachineParameterDR</Value>
</Value>
<Value name="38">
<Value>IsBldDifficult</Value>
</Value>
<Value name="39">
<Value>BldDifficultDesc</Value>
</Value>
<Value name="40">
<Value>IsExternal</Value>
</Value>
<Value name="41">
<Value>ExtTestInstitutionDR</Value>
</Value>
<Value name="42">
<Value>ExtXMDate</Value>
</Value>
<Value name="43">
<Value>ExtXMTime</Value>
</Value>
<Value name="44">
<Value>ExtXMEntryUser</Value>
</Value>
<Value name="45">
<Value>ExtXMAuthUser</Value>
</Value>
<Value name="46">
<Value>IsVerify</Value>
</Value>
<Value name="47">
<Value>VerifyDate</Value>
</Value>
<Value name="48">
<Value>VerifyTime</Value>
</Value>
<Value name="49">
<Value>VerifyUserDR</Value>
</Value>
<Value name="50">
<Value>CrtBloodGroupDR</Value>
</Value>
<Value name="51">
<Value>CrtRhPhenotype</Value>
</Value>
<Value name="52">
<Value>ChkBloodGroupDR</Value>
</Value>
<Value name="53">
<Value>ReqProductDR</Value>
</Value>
<Value name="54">
<Value>Status</Value>
</Value>
<Value name="55">
<Value>SaveDate</Value>
</Value>
<Value name="56">
<Value>SaveTime</Value>
</Value>
<Value name="57">
<Value>SaveUserDR</Value>
</Value>
<Value name="58">
<Value>DATest</Value>
</Value>
<Value name="59">
<Value>SCTest</Value>
</Value>
<Value name="60">
<Value>IsStop</Value>
</Value>
</Data>
<DataLocation>^dbo.BDXMPlanD</DataLocation>
<DefaultData>BDXMPlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDXMPlanD</IdLocation>
<IndexLocation>^dbo.BDXMPlanI</IndexLocation>
<StreamLocation>^dbo.BDXMPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
