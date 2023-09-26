/// 报告结果日志
Class dbo.RPVisitNumberReportResLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportResLog, StorageStrategy = Default ]
{

Index IndexMaster On (VisitNumberReportDR, TestCodeDR, AuthDate, AuthTime) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPVisitNumberReportResLog On RowID [ PrimaryKey, SqlName = PK_RP_VisitNumberReportResLog, Type = index ];

/// Foreign Key FKRPVisitNumberReportResLogBTMIMachineParameter created via DDL
ForeignKey FKRPVisitNumberReportResLogBTMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_RP_VisitNumberReportResLog_BTMI_MachineParameter ];

/// Foreign Key FKRPVisitNumberReportResLogBTTestCode created via DDL
ForeignKey FKRPVisitNumberReportResLogBTTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_RP_VisitNumberReportResLog_BT_TestCode ];

/// Foreign Key FKRPVisitNumberReportResLogBTTestMethod created via DDL
ForeignKey FKRPVisitNumberReportResLogBTTestMethod(MethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_RP_VisitNumberReportResLog_BT_TestMethod ];

/// Foreign Key FKRPVisitNumberReportResLogBTWorkGroupMachine created via DDL
ForeignKey FKRPVisitNumberReportResLogBTWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RP_VisitNumberReportResLog_BT_WorkGroupMachine ];

/// Foreign Key FKRPVisitNumberReportResLogRPVisitNumberReport created via DDL
ForeignKey FKRPVisitNumberReportResLogRPVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RP_VisitNumberReportResLog_RP_VisitNumberReport ];

/// Foreign Key FKRPVisitNumberReportResLogSYSUser created via DDL
ForeignKey FKRPVisitNumberReportResLogSYSUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitNumberReportResLog_SYS_User ];

/// Foreign Key FKRPVisitNumberReportResLogSYSUser1 created via DDL
ForeignKey FKRPVisitNumberReportResLogSYSUser1(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitNumberReportResLog_SYS_User1 ];

/// RowID  
Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 审核日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 审核时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 审核者  
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 检测号(流水号/条码  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

/// 细菌鉴定号  
Property AccessionNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 传输日期  
Property TransmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

/// 定性结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 扩展结果  
Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14 ];

/// 其它结果  
Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 结果说明(细菌备注)  
Property ResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 16 ];

/// 异常提示  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 17 ];

/// 结果类别  {1:危急,0:普通}
Property ResClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 18 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 20 ];

/// 检测方法  
Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 检测者  
Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 检测日期  
Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 检测时间  
Property AssayTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 显示序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 检验状态  {1:创建,2:上传,3:结果,4:上传,0:其他}
Property AssayStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 27 ];

/// 复查次数  
Property ReAssayNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 专家规则  
Property ExpertRule As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ SqlColumnNumber = 29 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 30 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 31 ];

/// 复查号  
Property ReAssayNumber As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 32 ];

/// 多耐菌  {1:true,0:false}
Property MultipleResistant As %Library.Boolean [ SqlColumnNumber = 33 ];

/// 项目组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

// 1：不让医生看检验界面看

/// IsNotReport  {1:true,0:false}
Property IsNotReport As %Library.Boolean [ SqlColumnNumber = 35 ];

/// IsMandatory  {1:true,0:false}
Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 36 ];

/// 标本组合套  
Property RPVisitNumberTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 操作类型  
Property OperateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 38 ];

/// MultipleResChild  
Property MultipleResChild As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 39 ];

// 1:不让打印

/// 是否允许打印  {1:true,0:false}
Property IsNotAllowPrint As %Library.Boolean [ SqlColumnNumber = 40 ];

/// 打印顺序 20200327
Property PrintSeq As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 交叉检测项目关联的其他医嘱项目组合套ID 20200327
Property OthTestSetIDs As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 42 ];

/// 稀释倍数
Property DilCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 43 ];

Storage Default
{
<Data name="RPVisitNumberReportResLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>AuthDate</Value>
</Value>
<Value name="5">
<Value>AuthTime</Value>
</Value>
<Value name="6">
<Value>AuthUserDR</Value>
</Value>
<Value name="7">
<Value>AssayNo</Value>
</Value>
<Value name="8">
<Value>AccessionNo</Value>
</Value>
<Value name="9">
<Value>TransmitDate</Value>
</Value>
<Value name="10">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="11">
<Value>Result</Value>
</Value>
<Value name="12">
<Value>TextRes</Value>
</Value>
<Value name="13">
<Value>ExtraRes</Value>
</Value>
<Value name="14">
<Value>OtherRes</Value>
</Value>
<Value name="15">
<Value>ResNoes</Value>
</Value>
<Value name="16">
<Value>AbFlag</Value>
</Value>
<Value name="17">
<Value>ResClass</Value>
</Value>
<Value name="18">
<Value>Unit</Value>
</Value>
<Value name="19">
<Value>RefRanges</Value>
</Value>
<Value name="20">
<Value>MethodDR</Value>
</Value>
<Value name="21">
<Value>MachineParameterDR</Value>
</Value>
<Value name="22">
<Value>OperateUserDR</Value>
</Value>
<Value name="23">
<Value>AssayDate</Value>
</Value>
<Value name="24">
<Value>AssayTime</Value>
</Value>
<Value name="25">
<Value>Sequence</Value>
</Value>
<Value name="26">
<Value>AssayStatus</Value>
</Value>
<Value name="27">
<Value>ReAssayNum</Value>
</Value>
<Value name="28">
<Value>ExpertRule</Value>
</Value>
<Value name="29">
<Value>RegNo</Value>
</Value>
<Value name="30">
<Value>AdmNo</Value>
</Value>
<Value name="31">
<Value>ReAssayNumber</Value>
</Value>
<Value name="32">
<Value>MultipleResistant</Value>
</Value>
<Value name="33">
<Value>TestSetDR</Value>
</Value>
<Value name="34">
<Value>IsNotReport</Value>
</Value>
<Value name="35">
<Value>IsMandatory</Value>
</Value>
<Value name="36">
<Value>RPVisitNumberTestSetDR</Value>
</Value>
<Value name="37">
<Value>OperateType</Value>
</Value>
<Value name="38">
<Value>MultipleResChild</Value>
</Value>
<Value name="39">
<Value>IsNotAllowPrint</Value>
</Value>
<Value name="40">
<Value>PrintSeq</Value>
</Value>
<Value name="41">
<Value>OthTestSetIDs</Value>
</Value>
<Value name="42">
<Value>DilCode</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportResLogD</DataLocation>
<DefaultData>RPVisitNumberReportResLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportResLogD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportResLogI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportResLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
