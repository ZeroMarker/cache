/// 危急值结果
Class dbo.RPVisitNumberPanicResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberPanicResult, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberPanicReportResult created via DDL
ForeignKey FKVisitNumberPanicReportResult(VisitNumberReportPanicDR) References dbo.RPVisitNumberPanicReport(PKRPVISITNUMBERPANICREPORT) [ SqlName = FK_VisitNumberPanicReportResult ];

/// Foreign Key FKVisitNumberPanicReportResultMacine created via DDL
ForeignKey FKVisitNumberPanicReportResultMacine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_VisitNumberPanicReportResultMacine ];

/// Foreign Key FKVisitNumberPanicReportResultMethod created via DDL
ForeignKey FKVisitNumberPanicReportResultMethod(MethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_VisitNumberPanicReportResultMethod ];

/// Foreign Key FKVisitNumberPanicReportResultTC created via DDL
ForeignKey FKVisitNumberPanicReportResultTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_VisitNumberPanicReportResultTC ];

Index IndexAssayDate On (AssayDate, MachineParameterDR) [ SqlName = Index_AssayDate, Type = index ];

Index IndexMaster On (VisitNumberReportPanicDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (VisitNumberReportPanicDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERPANICRESULT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERPANICRESULT, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本危急报告  
Property VisitNumberReportPanicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 定性结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 扩展结果  
Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

/// 其它结果  
Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 结果说明  
Property ResNotes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

/// 异常标志  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 10 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 11 ];

/// 检测方法  
Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 检测日期  
Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 检测时间  
Property AssayTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 显示顺序  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="RPVisitNumberPanicResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportPanicDR</Value>
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
<Value>ResNotes</Value>
</Value>
<Value name="9">
<Value>AbFlag</Value>
</Value>
<Value name="10">
<Value>RefRanges</Value>
</Value>
<Value name="11">
<Value>MethodDR</Value>
</Value>
<Value name="12">
<Value>MachineParameterDR</Value>
</Value>
<Value name="13">
<Value>AssayDate</Value>
</Value>
<Value name="14">
<Value>AssayTime</Value>
</Value>
<Value name="15">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberPanicResultD</DataLocation>
<DefaultData>RPVisitNumberPanicResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberPanicResultD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberPanicResultI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberPanicResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
