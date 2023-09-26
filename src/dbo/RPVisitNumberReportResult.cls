/// 报告结果
Class dbo.RPVisitNumberReportResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportResult, StorageStrategy = Default ]
{

Index IndexAdmItem On (AdmNo, TestCodeDR, AuthDate, AuthTime) [ SqlName = Index_AdmItem, Type = index ];

Index IndexPatientItem On (RegNo, TestCodeDR, AuthDate, AuthTime) [ SqlName = Index_PatientItem, Type = index ];

Index IndexMachine On (MachineParameterDR, TestCodeDR, AuthDate) [ SqlName = Index_Machine, Type = index ];

Index IndexReportItem On (VisitNumberReportDR, TestCodeDR) [ SqlName = Index_ReportItem, Type = index, Unique ];

Index IndexTestSet On (VisitNumberReportDR, TestSetDR, TestCodeDR) [ SqlName = Index_TestSet, Type = index, Unique ];

Index IndexPatientAssayItem On (RegNo, TestCodeDR, AssayDate, AssayTime) [ SqlName = Index_PatientAssayItem, Type = index ];

Index IndexTestCode On (AuthDate, TestCodeDR) [ SqlName = Index_TestCode, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTRESULT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTRESULT, Type = index, Unique ];

/// Foreign Key FKVisitNumberReportResult created via DDL
ForeignKey FKVisitNumberReportResult(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportResult ];

/// Foreign Key FKVisitNumberReportResultMachine created via DDL
ForeignKey FKVisitNumberReportResultMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_VisitNumberReportResultMachine ];

/// Foreign Key FKVisitNumberReportResultMethod created via DDL
ForeignKey FKVisitNumberReportResultMethod(MethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_VisitNumberReportResultMethod ];

/// Foreign Key FKVisitNumberReportResultTC created via DDL
ForeignKey FKVisitNumberReportResultTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_VisitNumberReportResultTC ];

/// Foreign Key FKVisitNumberReportResultUser created via DDL
ForeignKey FKVisitNumberReportResultUser(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportResultUser ];

/// RowID  
Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 定性结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 6 ];

/// 扩展结果  
Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 其它结果  
Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

/// 结果说明(细菌备注)  
Property ResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

/// 异常提示  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 10 ];

/// 结果类别(0普通,1  {1:普通,0:危急}
Property ResClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 11 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 13 ];

/// 检测方法  
Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 检测者  
Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 检测日期  
Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 检测时间  
Property AssayTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 显示序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 检测状态  {1:创建,2:上传,3:结果,4:复查,0:其他}
Property AssayStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 20 ];

/// 复查次数  
Property ReAssayNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 专家规则  
Property ExpertRule As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ SqlColumnNumber = 22 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 23 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 24 ];

/// 审核日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 审核时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 复查号  
Property ReAssayNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 27 ];

/// 多耐菌  {1:true,0:false}
Property MultipleResistant As %Library.Boolean [ SqlColumnNumber = 28 ];

/// 所在组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 1：不让医生看检验界面看
/// 是否报告  {1:true,0:false}
Property IsNotReport As %Library.Boolean [ SqlColumnNumber = 30 ];

/// 是否必填  {1:true,0:false}
Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 31 ];

/// 标本组合套  
Property RPVisitNumberTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 操作类型  
Property OperateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 33 ];

/// 多耐菌群  
Property MultipleResChild As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 34 ];

/// 1:不让打印
/// 是否允许打印  {1:true,0:false}
Property IsNotAllowPrint As %Library.Boolean [ SqlColumnNumber = 35 ];

/// 打印顺序 20200327
Property PrintSeq As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 交叉检测项目关联的其他医嘱项目组合套ID 20200327
Property OthTestSetIDs As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 37 ];

/// 稀释倍数
Property DilCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 38 ];

/// 结果互认标记(0:不互认，1:区域性互认，2：全市，3：全省，4：全国)
Property ShareFlag As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 39 ];

Storage Default
{
<Data name="RPVisitNumberReportResultDefaultData">
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
<Value>Result</Value>
</Value>
<Value name="5">
<Value>TextRes</Value>
</Value>
<Value name="6">
<Value>ExtraRes</Value>
</Value>
<Value name="7">
<Value>OtherRes</Value>
</Value>
<Value name="8">
<Value>ResNoes</Value>
</Value>
<Value name="9">
<Value>AbFlag</Value>
</Value>
<Value name="10">
<Value>ResClass</Value>
</Value>
<Value name="11">
<Value>Unit</Value>
</Value>
<Value name="12">
<Value>RefRanges</Value>
</Value>
<Value name="13">
<Value>MethodDR</Value>
</Value>
<Value name="14">
<Value>MachineParameterDR</Value>
</Value>
<Value name="15">
<Value>OperateUserDR</Value>
</Value>
<Value name="16">
<Value>AssayDate</Value>
</Value>
<Value name="17">
<Value>AssayTime</Value>
</Value>
<Value name="18">
<Value>Sequence</Value>
</Value>
<Value name="19">
<Value>AssayStatus</Value>
</Value>
<Value name="20">
<Value>ReAssayNum</Value>
</Value>
<Value name="21">
<Value>ExpertRule</Value>
</Value>
<Value name="22">
<Value>RegNo</Value>
</Value>
<Value name="23">
<Value>AdmNo</Value>
</Value>
<Value name="24">
<Value>AuthDate</Value>
</Value>
<Value name="25">
<Value>AuthTime</Value>
</Value>
<Value name="26">
<Value>ReAssayNumber</Value>
</Value>
<Value name="27">
<Value>MultipleResistant</Value>
</Value>
<Value name="28">
<Value>TestSetDR</Value>
</Value>
<Value name="29">
<Value>IsNotReport</Value>
</Value>
<Value name="30">
<Value>IsMandatory</Value>
</Value>
<Value name="31">
<Value>RPVisitNumberTestSetDR</Value>
</Value>
<Value name="32">
<Value>OperateType</Value>
</Value>
<Value name="33">
<Value>MultipleResChild</Value>
</Value>
<Value name="34">
<Value>IsNotAllowPrint</Value>
</Value>
<Value name="35">
<Value>PrintSeq</Value>
</Value>
<Value name="36">
<Value>OthTestSetIDs</Value>
</Value>
<Value name="37">
<Value>DilCode</Value>
</Value>
<Value name="38">
<Value>ShareFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportResultD</DataLocation>
<DefaultData>RPVisitNumberReportResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportResultD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportResultI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
