Class dbo.STQITItemTATDetails Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = ST_QITItemTATDetails ]
{

/// Foreign Key FKRPVisitNumberTCRepeatBTTestCode created via DDL
ForeignKey FKSTQITItemTATDetailsSTQITItemTAT(QITItemTATDR) References dbo.STQITItemTAT(PKSTQITItemTAT) [ SqlName = FK_ST_QITItemTATDetails_ST_QITItemTAT ];

Index IndexMaster On (QITItemTATDR, ReportDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTimeValue On (QITItemTATDR, TimeValue) [ SqlName = Index_TimeValue, Type = index ];

/// DDL Primary Key Specification
Index PKSTQISpecTATDetails On RowID [ PrimaryKey, SqlName = PK_ST_QISpecTATDetails, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ Identity, Required, SqlColumnNumber = 2 ];

/// 汇总表主键
Property QITItemTATDR As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ SqlColumnNumber = 3 ];

/// 检验前存VisitNumberDR,检验后存ReportDR
Property ReportDR As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ Required, SqlColumnNumber = 4 ];

/// 具体时间差(秒)
Property TimeValue As %Library.Float [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="STQITItemTATDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QITItemTATDR</Value>
</Value>
<Value name="3">
<Value>ReportDR</Value>
</Value>
<Value name="4">
<Value>TimeValue</Value>
</Value>
</Data>
<DataLocation>^dbo.STQITItemTATDetailsD</DataLocation>
<DefaultData>STQITItemTATDetailsDefaultData</DefaultData>
<IdLocation>^dbo.STQITItemTATDetailsD</IdLocation>
<IndexLocation>^dbo.STQITItemTATDetailsI</IndexLocation>
<StreamLocation>^dbo.STQITItemTATDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
