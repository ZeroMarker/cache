/// 细菌耐药分析结果表
Class User.EnsLISItemResRst Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = LISIRR_RowID, SqlRowIdPrivate, SqlTableName = Ens_LISItemResRst ]
{

Index LISITEMRESULTRSTPKey On LISIRRRowID [ PrimaryKey, Type = index, Unique ];

Index LISIRResultSeqIndex On (LISIRRResultID, LISIRRShowSeq) [ SqlName = Index_ResultSeq, Type = index ];

Index LISIRUpdateDateTimeIndex On (LISIRRUpdateDate, LISIRRUpdateTime);

Index IndexResultRstItem On (LISIRRResultID, LISIRRItemCode) [ SqlName = Index_ResultRstItem, Type = index, Unique ];

ForeignKey FKLISITEMRESULTRSTREFERENCERESULTID(LISIRRResultID) References User.EnsLISItemResult(LISITEMRESULTPKey) [ SqlName = FK_LISITEMRESULTRST_REFERENCE_RESULTID ];

/// ForeignKey FKLISITEMRESRSTREFERENCERSTITEMCODE(LISIRRItemCode) References dbo.BTMCResistanceItem(IndexCode) [ SqlName = FK_LISITEMRESRST_REFERENCE_RSTITEMCODE ];
/// 序列ID
Property LISIRRRowID As %Library.Integer [ InitialExpression = {$I(^Busi.ENS.EnsLISItemResRstC)}, Required, SqlColumnNumber = 2, SqlFieldName = LISIRR_RowID ];

/// 结果ID
Property LISIRRResultID As %Library.Integer [ SqlColumnNumber = 3, SqlFieldName = LISIRR_ResultID ];

/// 耐药项目代码
Property LISIRRItemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4, SqlFieldName = LISIRR_ItemCode ];

/// 耐药项目名称
Property LISIRRItemDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 5, SqlFieldName = LISIRR_ItemDesc ];

/// 结果
Property LISIRRResult As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 6, SqlFieldName = LISIRR_Result ];

/// 序号
Property LISIRRShowSeq As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 7, SqlFieldName = LISIRR_ShowSeq ];

/// 时间戳日期
Property LISIRRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 8, SqlFieldName = LISIRR_UpdateDate ];

/// 时间戳时间
Property LISIRRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 9, SqlFieldName = LISIRR_UpdateTime ];

Storage Default
{
<Data name="EnsLISItemResRstDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LISIRRRowID</Value>
</Value>
<Value name="3">
<Value>LISIRRResultID</Value>
</Value>
<Value name="4">
<Value>LISIRRItemCode</Value>
</Value>
<Value name="5">
<Value>LISIRRItemDesc</Value>
</Value>
<Value name="6">
<Value>LISIRRResult</Value>
</Value>
<Value name="7">
<Value>LISIRRShowSeq</Value>
</Value>
<Value name="8">
<Value>LISIRRUpdateDate</Value>
</Value>
<Value name="9">
<Value>LISIRRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsLISItemResRstD</DataLocation>
<DefaultData>EnsLISItemResRstDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsLISItemResRstD</IdLocation>
<IndexLocation>^Busi.ENS.EnsLISItemResRstI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsLISItemResRstS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
