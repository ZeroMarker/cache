/// 
Class dbo.PTReportPrint Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrint, StorageStrategy = Default ]
{

/// Foreign Key FKPTReportPrintHospital created via DDL
ForeignKey FKPTReportPrintHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_PT_ReportPrint_Hospital ];

/// Foreign Key FKPTReportPrintPaper created via DDL
ForeignKey FKPTReportPrintPaper(ReportPrintPaperDR) References dbo.PTReportPrintPaper(PKPTREPORTPRINTPAPER) [ SqlName = FK_PT_ReportPrint_Paper ];

/// Foreign Key FKPTItemReportPrint created via DDL
ForeignKey FKPTItemReportPrint(ReportPrintDR) References dbo.PTReportPrint(PKPTREPORTPRINT) [ SqlName = FK_PT_Item_ReportPrint ];

Index IndexReportPrintDR On (ReportPrintDR, EndDate, EndTime) [ SqlName = Index_ReportPrintDR, Type = index ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLargeDef On LargeDef [ SqlName = Index_LargeDef, Type = index ];

Index IndexLeterDef On LeterDef [ SqlName = Index_LeterDef, Type = index ];

Index IndexNextPageDef On NextPageDef [ SqlName = Index_NextPageDef, Type = index ];

Index IndexEnReportDef On EnReportDef [ SqlName = Index_EnReportDef, Type = index ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINT On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 模板代码
Property Code As %Library.String(MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

/// 模板名称
Property Name As %Library.String(MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 模板纸张
Property ReportPrintPaperDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 边距
Property ResultLineSpacing As %Library.Float [ SqlColumnNumber = 6 ];

/// 结果行数
Property ResultRows As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 结果列
Property ResultCols As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 纸张方向
Property PaperLayout As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 10 ];

/// 下边距
Property PaperBottom As %Library.Float [ SqlColumnNumber = 11 ];

/// 左边距
Property PaperLeft As %Library.Float [ SqlColumnNumber = 12 ];

/// 右边距
Property PaperRight As %Library.Float [ SqlColumnNumber = 13 ];

/// 上边距
Property PaperTop As %Library.Float [ SqlColumnNumber = 14 ];

/// 微生物边距
Property MicResultLineSpacing As %Library.Float [ SqlColumnNumber = 15 ];

/// 微生物行数
Property MicResultRows As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 微生物列数
Property MicResultCols As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 边距
Property ArchivesMargin As %Library.Float [ SqlColumnNumber = 18 ];

/// 固定报告
Property FixedReport As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 双列填充类型
Property DoubleColFillType As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 20 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 大于关联
Property LargeDef As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 22 ];

/// 小于关联
Property LeterDef As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 23 ];

/// 下一页关联
Property NextPageDef As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 24 ];

/// 是否按医嘱分组
Property IsGroupByTestSet As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 25 ];

/// 所属工作组
Property WorkGroupID As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 26 ];

/// 异常加粗
Property AbnormalBold As %Library.Boolean [ SqlColumnNumber = 27 ];

/// 英文关联
Property EnReportDef As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 28 ];

/// 代码下一页关联
Property CodeNextPageDef As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 29 ];

/// 代码关联
Property CodeDef As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 30 ];

/// 父模板
Property ReportPrintDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 截止日期  
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 截止时间  
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 截止说明
Property EndRemark As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 34 ];

Storage Default
{
<Data name="PTReportPrintDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ReportPrintPaperDR</Value>
</Value>
<Value name="5">
<Value>ResultLineSpacing</Value>
</Value>
<Value name="6">
<Value>ResultRows</Value>
</Value>
<Value name="7">
<Value>ResultCols</Value>
</Value>
<Value name="8">
<Value>HospitalDR</Value>
</Value>
<Value name="9">
<Value>PaperLayout</Value>
</Value>
<Value name="10">
<Value>PaperBottom</Value>
</Value>
<Value name="11">
<Value>PaperLeft</Value>
</Value>
<Value name="12">
<Value>PaperRight</Value>
</Value>
<Value name="13">
<Value>PaperTop</Value>
</Value>
<Value name="14">
<Value>MicResultLineSpacing</Value>
</Value>
<Value name="15">
<Value>MicResultRows</Value>
</Value>
<Value name="16">
<Value>MicResultCols</Value>
</Value>
<Value name="17">
<Value>ArchivesMargin</Value>
</Value>
<Value name="18">
<Value>FixedReport</Value>
</Value>
<Value name="19">
<Value>DoubleColFillType</Value>
</Value>
<Value name="20">
<Value>Sequence</Value>
</Value>
<Value name="21">
<Value>LargeDef</Value>
</Value>
<Value name="22">
<Value>LeterDef</Value>
</Value>
<Value name="23">
<Value>NextPageDef</Value>
</Value>
<Value name="24">
<Value>IsGroupByTestSet</Value>
</Value>
<Value name="25">
<Value>WorkGroupID</Value>
</Value>
<Value name="26">
<Value>AbnormalBold</Value>
</Value>
<Value name="27">
<Value>EnReportDef</Value>
</Value>
<Value name="28">
<Value>CodeNextPageDef</Value>
</Value>
<Value name="29">
<Value>CodeDef</Value>
</Value>
<Value name="30">
<Value>ReportPrintDR</Value>
</Value>
<Value name="31">
<Value>EndDate</Value>
</Value>
<Value name="32">
<Value>EndTime</Value>
</Value>
<Value name="33">
<Value>EndRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintD</DataLocation>
<DefaultData>PTReportPrintDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.PTReportPrintD</IdLocation>
<IndexLocation>^dbo.PTReportPrintI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
