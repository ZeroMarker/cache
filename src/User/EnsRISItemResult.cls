/// 检查报告子表，保存测值
Class User.EnsRISItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, SqlRowIdPrivate, SqlTableName = Ens_RISItemResult ]
{

/// DDL Primary Key Specification
Index RISItemResultPKey On RISIRRowID [ PrimaryKey, Type = index, Unique ];

Index IndexReportItem On (RISIRReportID, RISIRItemCode) [ SqlName = Index_ReportItem, Type = index, Unique ];

ForeignKey FKRISITEMRESULTREFERENCEREPORTID(RISIRReportID) References User.EnsRISReportResult(RISREPORTPKey) [ SqlName = FK_RISITEMRESULT_REFERENCE_REPORTID ];

/// 序列ID
Property RISIRRowID As %Library.Integer [ InitialExpression = {$I(^Busi.ENS.EnsRISItemResultC)}, Required, SqlColumnNumber = 2, SqlFieldName = RISIR_RowID ];

/// 报告ID
Property RISIRReportID As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ Required, SqlColumnNumber = 3, SqlFieldName = RISIR_ReportID ];

/// 患者ID
Property RISIRPatientID As User.PAPatMas [ Required, SqlColumnNumber = 4, SqlFieldName = RISIR_PatientID ];

/// 就诊号
Property RISIRVisitNumber As User.PAAdm [ Required, SqlColumnNumber = 5, SqlFieldName = RISIR_VisitNumber ];

/// 检查项目代码
Property RISIRItemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 6, SqlFieldName = RISIR_ItemCode ];

/// 检查项目名称
Property RISIRItemDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ Required, SqlColumnNumber = 7, SqlFieldName = RISIR_ItemDesc ];

/// 结果 
Property RISIRResult As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = RISIR_Result ];

/// 参考范围
Property RISIRRanges As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = RISIR_Ranges ];

/// 参考值高值
Property RISIRHigh As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 10, SqlFieldName = RISIR_High ];

/// 参考值低值
Property RISIRLow As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 11, SqlFieldName = RISIR_Low ];

/// 参考值单位
Property RISIRUnit As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 12, SqlFieldName = RISIR_Unit ];

Storage Default
{
<Data name="EnsRISItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RISIRRowID</Value>
</Value>
<Value name="3">
<Value>RISIRReportID</Value>
</Value>
<Value name="4">
<Value>RISIRPatientID</Value>
</Value>
<Value name="5">
<Value>RISIRVisitNumber</Value>
</Value>
<Value name="6">
<Value>RISIRItemCode</Value>
</Value>
<Value name="7">
<Value>RISIRItemDesc</Value>
</Value>
<Value name="8">
<Value>RISIRResult</Value>
</Value>
<Value name="9">
<Value>RISIRRanges</Value>
</Value>
<Value name="10">
<Value>RISIRHigh</Value>
</Value>
<Value name="11">
<Value>RISIRLow</Value>
</Value>
<Value name="12">
<Value>RISIRUnit</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsRISItemResultD</DataLocation>
<DefaultData>EnsRISItemResultDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsRISItemResultD</IdLocation>
<IndexLocation>^Busi.ENS.EnsRISItemResultI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsRISItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
