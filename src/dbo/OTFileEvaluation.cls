Class dbo.OTFileEvaluation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileEvaluation ]
{

/// Foreign Key FKOTFileInfoDR created via DDL
ForeignKey FKOTFileInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileInfoDR ];

/// Foreign Key FKCreateUser created via DDL
ForeignKey FKCreateUser(CreateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CreateUser ];

/// Foreign Key FKSummaryUser created via DDL
ForeignKey FKSummaryUser(SummaryUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_SummaryUser ];

Index IndexMaster On TaskCode [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexSummary On (SummaryDate, SummaryTime, SummaryUser) [ SqlName = Index_Summary, Type = index ];

Index IndexFile On (OTFileInfoDR, CreateDate, CreateTime) [ SqlName = Index_File, Type = index ];

/// DDL Primary Key Specification
Index PKOTFILEEVALUATION On RowID [ PrimaryKey, SqlName = PK_OT_FILEEVALUATION, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 创建日期
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 创建时间
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 创建人
Property CreateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 任务编号
Property TaskCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 任务摘要
Property TaskMaster As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 任务内容
Property TaskContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

/// 开始日期
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 结束日期
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 汇总日期
Property SummaryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 汇总时间
Property SummaryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 汇总人
Property SummaryUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 评审总结
Property SummaryContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

/// 状态(枚举类LQM.ENUM.OTFileStatus)
Property Status As %Library.SmallInt [ SqlColumnNumber = 15 ];

/// 评审结果
Property Result As %Library.SmallInt [ SqlColumnNumber = 16 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 17 ];

/// 文件
Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 修订号
Property NewVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="OTFileEvaluationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>CreateUser</Value>
</Value>
<Value name="5">
<Value>TaskCode</Value>
</Value>
<Value name="6">
<Value>TaskMaster</Value>
</Value>
<Value name="7">
<Value>TaskContent</Value>
</Value>
<Value name="8">
<Value>StartDate</Value>
</Value>
<Value name="9">
<Value>EndDate</Value>
</Value>
<Value name="10">
<Value>SummaryDate</Value>
</Value>
<Value name="11">
<Value>SummaryTime</Value>
</Value>
<Value name="12">
<Value>SummaryUser</Value>
</Value>
<Value name="13">
<Value>SummaryContent</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>Result</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
<Value name="17">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="18">
<Value>NewVersion</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileEvaluationD</DataLocation>
<DefaultData>OTFileEvaluationDefaultData</DefaultData>
<IdLocation>^dbo.OTFileEvaluationD</IdLocation>
<IndexLocation>^dbo.OTFileEvaluationI</IndexLocation>
<StreamLocation>^dbo.OTFileEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
