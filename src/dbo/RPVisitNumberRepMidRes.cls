/// 中间报告结果
Class dbo.RPVisitNumberRepMidRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRepMidRes, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberRepMidRes created via DDL
ForeignKey FKVisitNumberRepMidRes(VisitNumberRepMidDR) References dbo.RPVisitNumberRepMid(PKRPVISITNUMBERREPMID) [ SqlName = FK_VisitNumberRepMidRes ];

/// Foreign Key FKVisitNumberRepMidResTC created via DDL
ForeignKey FKVisitNumberRepMidResTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_VisitNumberRepMidResTC ];

/// Foreign Key FKVisitNumberRepMidResMi created via DDL
ForeignKey FKVisitNumberRepMidResMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_VisitNumberRepMidResMi ];

/// Foreign Key FKVisitNumberRepMidResOrg created via DDL
ForeignKey FKVisitNumberRepMidResOrg(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_VisitNumberRepMidResOrg ];

// Index IndexMidReportItem On (VisitNumberRepMidDR, OrderNo) [ SqlName = Index_MidReportItem, Type = index, Unique ];

Index IndexMidReportTCItem On (VisitNumberRepMidDR, TestCodeDR) [ SqlName = IndexMidReportTCItem, Type = index, Unique ];

Index IndexMidReportOrderNo On (VisitNumberRepMidDR, OrderNo) [ SqlName = IndexMidReportOrderNo, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPMIDRES On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPMIDRES, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 预报告  
Property VisitNumberRepMidDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 定性结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 补充结果  
Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 其他结果  
Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 异常提示  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 9 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

/// 范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 11 ];

/// 检测方法  
Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 细菌  
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPVisitNumberRepMidResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberRepMidDR</Value>
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
<Value>AbFlag</Value>
</Value>
<Value name="9">
<Value>Unit</Value>
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
<Value>OrganismDR</Value>
</Value>
<Value name="14">
<Value>OrderNo</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepMidResD</DataLocation>
<DefaultData>RPVisitNumberRepMidResDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberRepMidResD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepMidResI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepMidResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
