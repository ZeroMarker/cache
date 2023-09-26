/// 质控月报数据
Class dbo.QCMonReportData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MonReportData ]
{

/// Foreign Key FKQCMonReportDataMonReportDR created via DDL
ForeignKey FKQCMonReportDataMonReportDR(MonReportDR) References dbo.QCMonReport(PKQCMONREPORT) [ SqlName = FK_QCMonReportDataMonReportDR ];

/// DDL Primary Key Specification
Index PKQCMONREPORTDATA On RowID [ PrimaryKey, SqlName = PK_QC_MONREPORTDATA, Type = index, Unique ];

Index IndexMaster On (MonReportDR, LevelNo) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 月报
Property MonReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 浓度
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 质控品批号
Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 所有结果总数
Property AllResSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 在控结果总数
Property InResSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 靶值
Property Mean As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// 标准差
Property SD As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 目标CV
Property TargetCV As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

/// 本月所有数据均值
Property MonAllMean As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// 本月所有数据标准差
Property MonAllSD As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// 本月所有数据CV%
Property MonAllCV As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 13 ];

/// 本月在控均值
Property MonInMean As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 14 ];

/// 本月在控标准差
Property MonInSD As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 15 ];

/// 本月在控CV
Property MonInCV As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 16 ];

/// 累计所有结果总数
Property AccAllSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 累计所有结果均值
Property AccAllMean As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 18 ];

/// 累计所有结果标准差
Property AccAllSD As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 累计所有结果CV
Property AccAllCV As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 20 ];

/// 累计在控结果总数
Property AccInSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 累计在控均值
Property AccInMean As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 22 ];

/// 累计在控标准差
Property AccInSD As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 23 ];

/// 累计在控CV
Property AccInCV As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 24 ];

/// 是否在控
Property IsControl As %Library.Boolean [ SqlColumnNumber = 25 ];

/// 设定CV
Property CV As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="QCMonReportDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MonReportDR</Value>
</Value>
<Value name="3">
<Value>LevelNo</Value>
</Value>
<Value name="4">
<Value>LotNo</Value>
</Value>
<Value name="5">
<Value>AllResSum</Value>
</Value>
<Value name="6">
<Value>InResSum</Value>
</Value>
<Value name="7">
<Value>Mean</Value>
</Value>
<Value name="8">
<Value>SD</Value>
</Value>
<Value name="9">
<Value>TargetCV</Value>
</Value>
<Value name="10">
<Value>MonAllMean</Value>
</Value>
<Value name="11">
<Value>MonAllSD</Value>
</Value>
<Value name="12">
<Value>MonAllCV</Value>
</Value>
<Value name="13">
<Value>MonInMean</Value>
</Value>
<Value name="14">
<Value>MonInSD</Value>
</Value>
<Value name="15">
<Value>MonInCV</Value>
</Value>
<Value name="16">
<Value>AccAllSum</Value>
</Value>
<Value name="17">
<Value>AccAllMean</Value>
</Value>
<Value name="18">
<Value>AccAllSD</Value>
</Value>
<Value name="19">
<Value>AccAllCV</Value>
</Value>
<Value name="20">
<Value>AccInSum</Value>
</Value>
<Value name="21">
<Value>AccInMean</Value>
</Value>
<Value name="22">
<Value>AccInSD</Value>
</Value>
<Value name="23">
<Value>AccInCV</Value>
</Value>
<Value name="24">
<Value>IsControl</Value>
</Value>
<Value name="25">
<Value>CV</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMonReportDataD</DataLocation>
<DefaultData>QCMonReportDataDefaultData</DefaultData>
<IdLocation>^dbo.QCMonReportDataD</IdLocation>
<IndexLocation>^dbo.QCMonReportDataI</IndexLocation>
<StreamLocation>^dbo.QCMonReportDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
