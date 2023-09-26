/// 质控月报告
Class dbo.QCMonReport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MonReport ]
{

/// Foreign Key FKQCMonReportMaterialDR created via DDL
ForeignKey FKQCMonReportMaterialDR(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_QCMonReportMaterialDR ];

/// Foreign Key FKQCMonReportMachineDR created via DDL
ForeignKey FKQCMonReportMachineDR(MachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QCMonReportMachineDR ];

/// Foreign Key FKQCMonReportTestCodeDR created via DDL
ForeignKey FKQCMonReportTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCMonReportTestCodeDR ];

/// Foreign Key FKQCMonReportAddUserDR created via DDL
ForeignKey FKQCMonReportAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportAddUserDR ];

/// Foreign Key FKQCMonReportWorkGroupDR created via DDL
ForeignKey FKQCMonReportWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_QCMonReportWorkGroupDR ];

/// Foreign Key FKQCMonReportCheckUserDR created via DDL
ForeignKey FKQCMonReportCheckUserDR(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportCheckUserDR ];

/// Foreign Key FKQCMonReportGPCheckUserDR created via DDL
ForeignKey FKQCMonReportGPCheckUserDR(GPCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportGPCheckUserDR ];

/// Foreign Key FKQCMonReportQCCheckUserDR created via DDL
ForeignKey FKQCMonReportQCCheckUserDR(QCCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportQCCheckUserDR ];

/// Foreign Key FKQCMonReportReturnUserDR created via DDL
ForeignKey FKQCMonReportReturnUserDR(ReturnUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportReturnUserDR ];

/// Foreign Key FKQCMonReportFileUserDR created via DDL
ForeignKey FKQCMonReportFileUserDR(FileUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportFileUserDR ];

/// DDL Primary Key Specification
Index PKQCMONREPORT On RowID [ PrimaryKey, SqlName = PK_QC_MONREPORT, Type = index, Unique ];

Index IndexMaster On (MaterialDR, MachineDR, TestCodeDR, StartDate, EndDate) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMachine On (MachineDR, AddDate) [ SqlName = Index_Machine, Type = index ];

Index IndexMaterial On (MaterialDR, AddDate) [ SqlName = Index_Material, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexFileDate On FileDate [ SqlName = Index_FileDate, Type = index ];

Index IndexReturnDate On ReturnDate [ SqlName = Index_ReturnDate, Type = index ];

Index IndexGPCheckDate On GPCheckDate [ SqlName = Index_GPCheckDate, Type = index ];

Index IndexGPCheckUser On (GPCheckUserDR, GPCheckDate) [ SqlName = Index_GPCheckUser, Type = index ];

Index IndexQCCheckDate On QCCheckDate [ SqlName = Index_QCCheckDate, Type = index ];

Index IndexQCCheckUser On (QCCheckUserDR, QCCheckDate) [ SqlName = Index_QCCheckUser, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 仪器
Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 开始日期
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 结束日期
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 月评价
Property Evaluation As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 8 ];

/// 月小结
Property Summary As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 9 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 添加人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

/// 审核日期
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 审核时间
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 审核人
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 审核说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 17 ];

/// 组长审核日期
Property GPCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 组长审核时间
Property GPCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 组长审核人
Property GPCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 组长审核说明
Property GPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 21 ];

/// 负责人审核日期
Property QCCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 负责人审核时间
Property QCCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 负责人审核人
Property QCCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 负责人审核说明
Property QCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 25 ];

/// 图片路径
Property PICFile As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 26 ];

/// 退回日期
Property ReturnDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 退回时间
Property ReturnTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Property ReturnUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 退回人
Property ReturnRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 30 ];

/// 归档日期
Property FileDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 归档时间
Property FileTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Property FileUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 归档人
Property PDFFile As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 34 ];

/// 归档状态{"10","创建","20":"提交审批","30":"组长审批","40":"完成","11":"组长退回","12":"质控员退回"}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 35 ];

Storage Default
{
<Data name="QCMonReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>MachineDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>Evaluation</Value>
</Value>
<Value name="8">
<Value>Summary</Value>
</Value>
<Value name="9">
<Value>AddDate</Value>
</Value>
<Value name="10">
<Value>AddTime</Value>
</Value>
<Value name="11">
<Value>AddUserDR</Value>
</Value>
<Value name="12">
<Value>WorkGroupDR</Value>
</Value>
<Value name="13">
<Value>CheckDate</Value>
</Value>
<Value name="14">
<Value>CheckTime</Value>
</Value>
<Value name="15">
<Value>CheckUserDR</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
<Value name="17">
<Value>GPCheckDate</Value>
</Value>
<Value name="18">
<Value>GPCheckTime</Value>
</Value>
<Value name="19">
<Value>GPCheckUserDR</Value>
</Value>
<Value name="20">
<Value>GPRemark</Value>
</Value>
<Value name="21">
<Value>QCCheckDate</Value>
</Value>
<Value name="22">
<Value>QCCheckTime</Value>
</Value>
<Value name="23">
<Value>QCCheckUserDR</Value>
</Value>
<Value name="24">
<Value>QCRemark</Value>
</Value>
<Value name="25">
<Value>PICFile</Value>
</Value>
<Value name="26">
<Value>ReturnDate</Value>
</Value>
<Value name="27">
<Value>ReturnTime</Value>
</Value>
<Value name="28">
<Value>ReturnUserDR</Value>
</Value>
<Value name="29">
<Value>ReturnRemark</Value>
</Value>
<Value name="30">
<Value>FileDate</Value>
</Value>
<Value name="31">
<Value>FileTime</Value>
</Value>
<Value name="32">
<Value>FileUserDR</Value>
</Value>
<Value name="33">
<Value>PDFFile</Value>
</Value>
<Value name="34">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMonReportD</DataLocation>
<DefaultData>QCMonReportDefaultData</DefaultData>
<IdLocation>^dbo.QCMonReportD</IdLocation>
<IndexLocation>^dbo.QCMonReportI</IndexLocation>
<StreamLocation>^dbo.QCMonReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
