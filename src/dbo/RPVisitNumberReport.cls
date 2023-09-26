/// 检验报告
Class dbo.RPVisitNumberReport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReport, StorageStrategy = Default ]
{

Index IndexAcceptDate On (WorkGroupMachineDR, AcceptDate, AssayNo) [ SqlName = Index_AcceptDate, Type = index ];

Index IndexUploadDate On (WorkGroupMachineDR, UploadDate) [ SqlName = Index_UploadDate, Type = index ];

Index IndexAccessionNo On (AccessionNo, WorkGroupMachineDR) [ SqlName = Index_AccessionNo, Type = index ];

Index IndexAuthDate On (WorkGroupMachineDR, AuthDate) [ SqlName = Index_AuthDate, Type = index ];

Index IndexEntryDate On (WorkGroupMachineDR, EntryDate) [ SqlName = Index_EntryDate, Type = index ];

Index IndexEpisodeNo On (TransmitDate, WorkGroupMachineDR, EpisodeNo) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexMicNo On (WorkGroupMachineDR, EpisodeNo, TransmitDate) [ SqlName = Index_MicNo, Type = index ];

Index IndexReAuthDate On (WorkGroupMachineDR, ReAuthDate) [ SqlName = Index_ReAuthDate, Type = index ];

Index IndexReportID On (VisitNumberDR, WorkGroupMachineDR, OrderNo) [ SqlName = Index_ReportID, Type = index, Unique ];

Index IndexResultID On (TransmitDate, WorkGroupMachineDR, AssayNo) [ SqlName = Index_ResultID, Type = index ];

Index IndexStatus On (WorkGroupMachineDR, Status) [ SqlName = Index_Status, Type = index ];

Index IndexStatusDate On (WorkGroupMachineDR, Status, TransmitDate) [ SqlName = Index_StatusDate, Type = index ];

Index IndexCompareReportDR On CompareReportDR [ SqlName = Index_CompareReportDR, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORT, Type = index, Unique ];

/// Foreign Key FKVisitNumberReport created via DDL
ForeignKey FKVisitNumberReport(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberReport ];

/// Foreign Key FKVisitNumberReportAcceptUser created via DDL
ForeignKey FKVisitNumberReportAcceptUser(AcceptUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportAcceptUser ];

/// Foreign Key FKVisitNumberReportAuthUser created via DDL
ForeignKey FKVisitNumberReportAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportAuthUser ];

/// Foreign Key FKVisitNumberReportSaveUser created via DDL
ForeignKey FKVisitNumberReportSaveUser(SaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportSaveUser ];

/// Foreign Key FKVisitNumberReportDiscardUser created via DDL
ForeignKey FKVisitNumberReportDiscardUser(DiscardUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportDiscardUser ];

/// Foreign Key FKVisitNumberReportDoctor created via DDL
ForeignKey FKVisitNumberReportDoctor(FirstReadDoctorDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_VisitNumberReportDoctor ];

/// Foreign Key FKVisitNumberReportEntryUser created via DDL
ForeignKey FKVisitNumberReportEntryUser(EntryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportEntryUser ];

/// Foreign Key FKVisitNumberReportReAuthUser created via DDL
ForeignKey FKVisitNumberReportReAuthUser(ReAuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportReAuthUser ];

/// Foreign Key FKVisitNumberReportReAuthUser created via DDL
ForeignKey FKVisitNumberReportSendUser(SendUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportSendUser ];

/// Foreign Key FKVisitNumberReportInspectUser created via DDL
ForeignKey FKVisitNumberReportInspectUser(InspectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportInspectUser ];

/// Foreign Key FKVisitNumberReportWorkGroup created via DDL
ForeignKey FKVisitNumberReportWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_VisitNumberReportWorkGroup ];

ForeignKey FKVisitNumberReportComReport(CompareReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportComReport ];

ForeignKey FKVisitNumberRepExtLaboratory(ExtLaboratoryDR) References dbo.BTExtLaboratory(PKBTEXTLABORATORY) [ SqlName = FK_VisitNumberRepExtLaboratory ];

/// Foreign Key FKVisitNumberReportReAuthUser created via DDL
ForeignKey FKVisitNumberReportArchiveUser(ArchiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportArchiveUser ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 传输日期  
Property TransmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 检测号(流水号/条码  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 7 ];

/// 细菌鉴定号  
Property AccessionNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 流水号  
Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 核收日期  
Property AcceptDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 核收时间  
Property AcceptTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 核收者  
Property AcceptUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 上机日期  
Property UploadDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 上机时间  
Property UploadTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 检测日期  
Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 检测时间  
Property AssayTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 初审日期  
Property EntryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 初审时间  
Property EntryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 初审者  
Property EntryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 审核日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 审核时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 审核者  
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 报告状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 4) [ SqlColumnNumber = 23 ];

/// 重审日期  
Property ReAuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 重审时间  
Property ReAuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 重审者  
Property ReAuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 是否自动审核  {1:true,0:false}
Property AutoAuth As %Library.Boolean [ SqlColumnNumber = 27 ];

/// 是否数字签名  {1:true,0:false}
Property DigitSign As %Library.Boolean [ SqlColumnNumber = 28 ];

/// 签名字符串  
Property DigitSignString As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 29 ];

/// 签名时间戳  
Property DigitSignTime As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 30 ];

/// 是否打印  {1:true,0:false}
Property Printed As %Library.Boolean [ SqlColumnNumber = 31 ];

/// 是否阅读  {1:true,0:false}
Property Readed As %Library.Boolean [ SqlColumnNumber = 32 ];

/// 首次阅读日期  
Property FirstReadDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 首次阅读时间  
Property FirstReadTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 首次阅读医生  
Property FirstReadDoctorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 报告类型  
Property ReportClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 36 ];

/// 作废日期  
Property DiscardDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 作废时间  
Property DiscardTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 作废者  
Property DiscardUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

/// 作废原因  
Property DisCardNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 40 ];

/// 报告主评价  
Property MajorConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 600) [ SqlColumnNumber = 41 ];

/// 报告次评价  
Property MinorConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 42 ];

/// 复查号  
Property ReAssayNumber As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 43 ];

/// 报告类型 枚举 {N:普通,P:特殊,X:文本}
Property ReportType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 44 ];

/// 拆分标志  
Property SplitStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 45 ];

/// RackNo  
Property RackNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 46 ];

/// IsPositive  {1:true,0:false}
Property IsPositive As %Library.Boolean [ SqlColumnNumber = 47 ];

/// 附加处理是否完成  {1:true,0:false}
Property ExtraFinished As %Library.Boolean [ SqlColumnNumber = 48 ];

/// 报告说明  
Property ReportRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 49 ];

/// 结果报警信息  
Property ResultWarned As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 50 ];

/// 上个仪器名称  
Property LastMachineLName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 51 ];

/// RedoFlag  {1:true,0:false}	//复查标识
Property RedoFlag As %Library.Boolean [ SqlColumnNumber = 52 ];

/// OperateFlag  {1:true,0:false}
Property OperateFlag As %Library.Boolean [ SqlColumnNumber = 53 ];

/// 创建类型  
Property AddType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 54 ];

/// CancelFlag  {1:true,0:false}
Property CancelFlag As %Library.Boolean [ SqlColumnNumber = 55 ];

/// 保存日期  
Property SaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 56 ];

/// 保存时间  
Property SaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

/// 保存人  
Property SaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 58 ];

///       
Property SelfPrintDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 59 ];

/// 对比报告主键
Property CompareReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 60 ];

/// 检测内容
Property TestContent As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 61 ];

/// 检测方法  
Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 62 ];

/// 检测结论  
Property TestConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 63 ];

/// 发送日期  
Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

/// 发送时间  
Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

/// 发送人  
Property SendUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 66 ];

/// 发送人  
Property Sended As %Library.Boolean [ SqlColumnNumber = 67 ];

/// 归档日期  
Property ArchiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 68 ];

/// 归档时间  
Property ArchiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

/// 归档人
Property ArchiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

/// 是否归档
Property Archived As %Library.Boolean [ SqlColumnNumber = 71 ];

/// 是否镜检
Property IsManualExam As %Library.Boolean [ SqlColumnNumber = 72 ];

/// 第三方机构  
Property ExtLaboratoryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 73 ];

/// 报告解读内容
Property ResultSummary As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 74 ];

/// 检验者  
Property InspectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 75 ];

/// 检验开始日期
Property InspectSttDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 76 ];

/// 检验开始时间  
Property InspectSttTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 77 ];

/// 检验结束日期
Property InspectEndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 78 ];

/// 检验结束时间  
Property InspectEndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 79 ];

Storage Default
{
<Data name="RPVisitNumberReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>TransmitDate</Value>
</Value>
<Value name="4">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>OrderNo</Value>
</Value>
<Value name="6">
<Value>AssayNo</Value>
</Value>
<Value name="7">
<Value>AccessionNo</Value>
</Value>
<Value name="8">
<Value>EpisodeNo</Value>
</Value>
<Value name="9">
<Value>AcceptDate</Value>
</Value>
<Value name="10">
<Value>AcceptTime</Value>
</Value>
<Value name="11">
<Value>AcceptUserDR</Value>
</Value>
<Value name="12">
<Value>UploadDate</Value>
</Value>
<Value name="13">
<Value>UploadTime</Value>
</Value>
<Value name="14">
<Value>AssayDate</Value>
</Value>
<Value name="15">
<Value>AssayTime</Value>
</Value>
<Value name="16">
<Value>EntryDate</Value>
</Value>
<Value name="17">
<Value>EntryTime</Value>
</Value>
<Value name="18">
<Value>EntryUserDR</Value>
</Value>
<Value name="19">
<Value>AuthDate</Value>
</Value>
<Value name="20">
<Value>AuthTime</Value>
</Value>
<Value name="21">
<Value>AuthUserDR</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
<Value name="23">
<Value>ReAuthDate</Value>
</Value>
<Value name="24">
<Value>ReAuthTime</Value>
</Value>
<Value name="25">
<Value>ReAuthUserDR</Value>
</Value>
<Value name="26">
<Value>AutoAuth</Value>
</Value>
<Value name="27">
<Value>DigitSign</Value>
</Value>
<Value name="28">
<Value>DigitSignString</Value>
</Value>
<Value name="29">
<Value>DigitSignTime</Value>
</Value>
<Value name="30">
<Value>Printed</Value>
</Value>
<Value name="31">
<Value>Readed</Value>
</Value>
<Value name="32">
<Value>FirstReadDate</Value>
</Value>
<Value name="33">
<Value>FirstReadTime</Value>
</Value>
<Value name="34">
<Value>FirstReadDoctorDR</Value>
</Value>
<Value name="35">
<Value>ReportClass</Value>
</Value>
<Value name="36">
<Value>DiscardDate</Value>
</Value>
<Value name="37">
<Value>DiscardTime</Value>
</Value>
<Value name="38">
<Value>DiscardUserDR</Value>
</Value>
<Value name="39">
<Value>DisCardNotes</Value>
</Value>
<Value name="40">
<Value>MajorConclusion</Value>
</Value>
<Value name="41">
<Value>MinorConclusion</Value>
</Value>
<Value name="42">
<Value>ReAssayNumber</Value>
</Value>
<Value name="43">
<Value>ReportType</Value>
</Value>
<Value name="44">
<Value>SplitStatus</Value>
</Value>
<Value name="45">
<Value>RackNo</Value>
</Value>
<Value name="46">
<Value>IsPositive</Value>
</Value>
<Value name="47">
<Value>ExtraFinished</Value>
</Value>
<Value name="48">
<Value>ReportRemark</Value>
</Value>
<Value name="49">
<Value>ResultWarned</Value>
</Value>
<Value name="50">
<Value>LastMachineLName</Value>
</Value>
<Value name="51">
<Value>RedoFlag</Value>
</Value>
<Value name="52">
<Value>OperateFlag</Value>
</Value>
<Value name="53">
<Value>AddType</Value>
</Value>
<Value name="54">
<Value>CancelFlag</Value>
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
<Value>SelfPrintDate</Value>
</Value>
<Value name="59">
<Value>CompareReportDR</Value>
</Value>
<Value name="60">
<Value>TestContent</Value>
</Value>
<Value name="61">
<Value>TestMethod</Value>
</Value>
<Value name="62">
<Value>TestConclusion</Value>
</Value>
<Value name="63">
<Value>SendDate</Value>
</Value>
<Value name="64">
<Value>SendTime</Value>
</Value>
<Value name="65">
<Value>SendUserDR</Value>
</Value>
<Value name="66">
<Value>Sended</Value>
</Value>
<Value name="67">
<Value>ArchiveDate</Value>
</Value>
<Value name="68">
<Value>ArchiveTime</Value>
</Value>
<Value name="69">
<Value>ArchiveUserDR</Value>
</Value>
<Value name="70">
<Value>Archived</Value>
</Value>
<Value name="71">
<Value>IsManualExam</Value>
</Value>
<Value name="72">
<Value>ExtLaboratoryDR</Value>
</Value>
<Value name="73">
<Value>ResultSummary</Value>
</Value>
<Value name="74">
<Value>InspectUserDR</Value>
</Value>
<Value name="75">
<Value>InspectSttDate</Value>
</Value>
<Value name="76">
<Value>InspectSttTime</Value>
</Value>
<Value name="77">
<Value>InspectEndDate</Value>
</Value>
<Value name="78">
<Value>InspectEndTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportD</DataLocation>
<DefaultData>RPVisitNumberReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
