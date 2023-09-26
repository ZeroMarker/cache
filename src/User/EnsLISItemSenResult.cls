/// 药敏结果表
Class User.EnsLISItemSenResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = Ens_LISItemSenResult ]
{

ForeignKey FKRESULTIDREFERENCELISITEMSEN(LISISRResultID) References User.EnsLISItemResult(LISITEMRESULTPKey) [ SqlName = FK_RESULT_REFERENCE_LISITEMSEN ];

/// ForeignKey FKANTIREFERENCELISITEMSEN(LISISRAntibioticsCode) References dbo.BTAntibiotics(IndexCode) [ SqlName = FK_ANTI_REFERENCE_LISITEMSEN ];
/// DDL Primary Key Specification 
Index PKHIPUSERLISITEMSENRESULT On (LISISRResultID, LISISRAntibioticsCode) [ PrimaryKey, SqlName = PK_HIPUSERLISITEMSENRESULT, Type = index, Unique ];

/// DDL Primary Key Specification 
Index IndexSequence On (LISISRResultID, LISISRShowSeq) [ SqlName = IndexSequence, Type = index ];

/// 细菌结果ID
Property LISISRResultID As %Library.Integer [ Required, SqlColumnNumber = 2, SqlFieldName = LISISR_ResultID ];

/// 抗生素代码
Property LISISRAntibioticsCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 3, SqlFieldName = LISISR_AntibioticsCode ];

/// 抗生素名称
Property LISISRAntibioticsDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = LISISR_AntibioticsDesc ];

/// 结果值
Property LISISRResult As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 5, SqlFieldName = LISISR_Result ];

/// 药敏结果代码
Property LISISRSensitivityCode As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = LISISR_SensitivityCode ];

/// 药敏结果名称
Property LISISRSensitivityDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = LISISR_SensitivityDesc ];

/// I折点范围
Property LISISRIRanges As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 8, SqlFieldName = LISISR_IRanges ];

/// S折点范围
Property LISISRSRanges As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 9, SqlFieldName = LISISR_SRanges ];

/// R折点范围
Property LISISRRRanges As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 10, SqlFieldName = LISISR_RRanges ];

/// 显示序号
Property LISISRShowSeq As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = LISISR_ShowSeq ];

/// 试验方法
Property LISISRMethod As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 12, SqlFieldName = LISISR_Method ];

/// 建议
Property LISISRSuggestion As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 13, SqlFieldName = LISISR_Suggestion ];

/// 药敏结果标志
Property LISISRFlag As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 14, SqlFieldName = LISISR_Flag ];

/// 抗生素级别ID
Property LISISRAntibioticsClassID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 15, SqlFieldName = LISISR_AntibioticsClassID ];

/// 抗生素级别名称
Property LISISRAntibioticsClassDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 16, SqlFieldName = LISISR_AntibioticsClassDesc ];

/// 时间戳日期
Property LISISRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 17, SqlFieldName = LISISR_UpdateDate ];

/// 时间戳时间
Property LISISRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 18, SqlFieldName = LISISR_UpdateTime ];

/// 药敏结果单位
Property LISISRUnit As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = LISISR_Unit ];

Storage Default
{
<Data name="EnsLISItemSenResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LISISRResultID</Value>
</Value>
<Value name="3">
<Value>LISISRAntibioticsCode</Value>
</Value>
<Value name="4">
<Value>LISISRAntibioticsDesc</Value>
</Value>
<Value name="5">
<Value>LISISRResult</Value>
</Value>
<Value name="6">
<Value>LISISRSensitivityCode</Value>
</Value>
<Value name="7">
<Value>LISISRSensitivityDesc</Value>
</Value>
<Value name="8">
<Value>LISISRIRanges</Value>
</Value>
<Value name="9">
<Value>LISISRSRanges</Value>
</Value>
<Value name="10">
<Value>LISISRRRanges</Value>
</Value>
<Value name="11">
<Value>LISISRShowSeq</Value>
</Value>
<Value name="12">
<Value>LISISRMethod</Value>
</Value>
<Value name="13">
<Value>LISISRSuggestion</Value>
</Value>
<Value name="14">
<Value>LISISRFlag</Value>
</Value>
<Value name="15">
<Value>LISISRAntibioticsClassID</Value>
</Value>
<Value name="16">
<Value>LISISRAntibioticsClassDesc</Value>
</Value>
<Value name="17">
<Value>LISISRUpdateDate</Value>
</Value>
<Value name="18">
<Value>LISISRUpdateTime</Value>
</Value>
<Value name="19">
<Value>LISISRUnit</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsLISItemSenResultD</DataLocation>
<DefaultData>EnsLISItemSenResultDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsLISItemSenResultD</IdLocation>
<IndexLocation>^Busi.ENS.EnsLISItemSenResultI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsLISItemSenResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
