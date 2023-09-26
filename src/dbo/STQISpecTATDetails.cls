Class dbo.STQISpecTATDetails Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = ST_QISpecTATDetails ]
{

/// Foreign Key FKRPVisitNumberTCRepeatBTTestCode created via DDL
ForeignKey FKSTQISpecTATDetailsSTQISpecTAT(QISpecTATDR) References dbo.STQISpecTAT(PKSTQISpecTAT) [ SqlName = FK_ST_QISpecTATDetails_ST_QISpecTAT ];

Index IndexMaster On (QISpecTATDR, ReportDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTimeValue On (QISpecTATDR, TimeValue) [ SqlName = Index_TimeValue, Type = index ];

/// DDL Primary Key Specification
Index PKSTQISpecTATDetails On RowID [ PrimaryKey, SqlName = PK_ST_QISpecTATDetails, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ Identity, Required, SqlColumnNumber = 2 ];

/// 汇总表主键
Property QISpecTATDR As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ SqlColumnNumber = 3 ];

/// 检验前存VisitNumberDR,检验后存ReportDR
Property ReportDR As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ Required, SqlColumnNumber = 4 ];

/// 具体时间差(秒)
Property TimeValue As %Library.Float [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="STQISpecTATDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QISpecTATDR</Value>
</Value>
<Value name="3">
<Value>ReportDR</Value>
</Value>
<Value name="4">
<Value>TimeValue</Value>
</Value>
</Data>
<DataLocation>^dbo.STQISpecTATDetailsD</DataLocation>
<DefaultData>STQISpecTATDetailsDefaultData</DefaultData>
<IdLocation>^dbo.STQISpecTATDetailsD</IdLocation>
<IndexLocation>^dbo.STQISpecTATDetailsI</IndexLocation>
<StreamLocation>^dbo.STQISpecTATDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
