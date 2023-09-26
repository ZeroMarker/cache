/// 报告图片结果
Class dbo.RPVisitNumberReportImage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportImage, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberReportImage created via DDL
ForeignKey FKVisitNumberReportImage(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportImage ];

/// Foreign Key FKVisitNumberReportImageMachine created via DDL
ForeignKey FKVisitNumberReportImageMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_VisitNumberReportImageMachine ];

Index IndexFileName On (FileName, VisitNumberReportDR) [ SqlName = Index_FileName, Type = index ];

Index IndexMaster On (VisitNumberReportDR, ImageClass, ImageOrder) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTIMAGE On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTIMAGE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 图像类别  
Property ImageClass As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

/// 图像序号  
Property ImageOrder As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 文件名称  
Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 6 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 图像标题  
Property Caption As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 显示系数  
Property DisplayRatio As %Library.Float [ SqlColumnNumber = 9 ];

/// 高度  
Property Height As %Library.Float [ SqlColumnNumber = 10 ];

/// 宽度  
Property Width As %Library.Float [ SqlColumnNumber = 11 ];

/// 显示序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RPVisitNumberReportImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>ImageClass</Value>
</Value>
<Value name="4">
<Value>ImageOrder</Value>
</Value>
<Value name="5">
<Value>FileName</Value>
</Value>
<Value name="6">
<Value>MachineParameterDR</Value>
</Value>
<Value name="7">
<Value>Caption</Value>
</Value>
<Value name="8">
<Value>DisplayRatio</Value>
</Value>
<Value name="9">
<Value>Height</Value>
</Value>
<Value name="10">
<Value>Width</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportImageD</DataLocation>
<DefaultData>RPVisitNumberReportImageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportImageD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportImageI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
