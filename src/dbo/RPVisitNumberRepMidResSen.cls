/// 中间报告药敏
Class dbo.RPVisitNumberRepMidResSen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRepMidResSen, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberRepMidResSen created via DDL
ForeignKey FKVisitNumberRepMidResSen(VisitNumberRepMidResDR) References dbo.RPVisitNumberRepMidRes(PKRPVISITNUMBERREPMIDRES) [ SqlName = FK_VisitNumberRepMidResSen ];

/// Foreign Key FKVisitNumberRepMidResSenAnt created via DDL
ForeignKey FKVisitNumberRepMidResSenAnt(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_VisitNumberRepMidResSenAnt ];

/// Foreign Key FKAntibioticsClassDR created via DDLAntibioticsClassDR
ForeignKey FKAntibioticsClassDR(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = PK_BTAntibioticsClass ];

/// Foreign Key FKVisitNumberRepMidResSenRes created via DDL
ForeignKey FKVisitNumberRepMidResSenRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_VisitNumberRepMidResSenRes ];

Index IndexAntRes On (VisitNumberRepMidResDR, AntibioticsDR) [ SqlName = Index_AntRes, Type = index, Unique ];

Index IndexSequence On (VisitNumberRepMidResDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPMIDRESSEN On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPMIDRESSEN, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告结果  
Property VisitNumberRepMidResDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 实验方法  {1:KB,2:MIC,3:ETEST,0:其他}
Property SenMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

/// 结果值  
Property SenValue As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 药敏结果  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// I折点范围  
Property IRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// S折点范围  
Property SRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// R折点范围  
Property RRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// AntibioticsClassDR  
Property AntibioticsClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// CheckType  
Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 13 ];

/// PromptType  
Property PromptType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 14 ];

/// Prompt  
Property Prompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 15 ];

/// SDDRanges  
Property SDDRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// MachSensitivityDR  
Property MachSensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 是否报告  {1:true,0:false}
Property Reported As %Library.Boolean [ SqlColumnNumber = 18 ];

/// 专家规则ID  
Property ExpertRuleID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RPVisitNumberRepMidResSenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberRepMidResDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>SenMethod</Value>
</Value>
<Value name="5">
<Value>SenValue</Value>
</Value>
<Value name="6">
<Value>SensitivityDR</Value>
</Value>
<Value name="7">
<Value>IRanges</Value>
</Value>
<Value name="8">
<Value>SRanges</Value>
</Value>
<Value name="9">
<Value>RRanges</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>AntibioticsClassDR</Value>
</Value>
<Value name="12">
<Value>CheckType</Value>
</Value>
<Value name="13">
<Value>PromptType</Value>
</Value>
<Value name="14">
<Value>Prompt</Value>
</Value>
<Value name="15">
<Value>SDDRanges</Value>
</Value>
<Value name="16">
<Value>MachSensitivityDR</Value>
</Value>
<Value name="17">
<Value>Reported</Value>
</Value>
<Value name="18">
<Value>ExpertRuleID</Value>
</Value>
<Value name="19">
<Value>AuthDate</Value>
</Value>
<Value name="20">
<Value>AuthTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepMidResSenD</DataLocation>
<DefaultData>RPVisitNumberRepMidResSenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberRepMidResSenD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepMidResSenI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepMidResSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
