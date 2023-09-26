/// 报告PDF文件
Class dbo.RPVisitNumberReportFile Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportFile ]
{

Index IndexVisitNumber On (VisitNumberID, VisitNumberReportID) [ SqlName = Index_VisitNumber, Type = index ];

Index IndexMater On VisitNumberReportID [ SqlName = Index_Mater, Type = index, Unique ];

Index IndexDate On (AddDate, AddTime, VisitNumberID, VisitNumberReportID) [ SqlName = Index_Date, Type = index ];

/// DDL Primary Key Specification
Index PKRPREPORTFILEPATH On RowID [ PrimaryKey, SqlName = PK_RP_REPORTFILEPATH, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本主键  
Property VisitNumberID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 报告主键  
Property VisitNumberReportID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// PDF路径  
Property PDFPath As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 图片路径  
Property ImgPath As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

// 0:检验内部，1：外部接口回传

/// 添加类型  {0:检验内部,1:外部接口回传}
Property CreateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

/// 初审人  
Property EntryUserName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

/// 审核人  
Property AuthUserName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// SourceIP  
Property SourceIP As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

///       
Property FileHash As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="RPVisitNumberReportFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberID</Value>
</Value>
<Value name="3">
<Value>VisitNumberReportID</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>PDFPath</Value>
</Value>
<Value name="7">
<Value>ImgPath</Value>
</Value>
<Value name="8">
<Value>CreateType</Value>
</Value>
<Value name="9">
<Value>EntryUserName</Value>
</Value>
<Value name="10">
<Value>AuthUserName</Value>
</Value>
<Value name="11">
<Value>SourceIP</Value>
</Value>
<Value name="12">
<Value>FileHash</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportFileD</DataLocation>
<DefaultData>RPVisitNumberReportFileDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberReportFileD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportFileI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
