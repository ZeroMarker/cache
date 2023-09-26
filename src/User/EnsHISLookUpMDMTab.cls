Class User.EnsHISLookUpMDMTab Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_HISLookUpMDMTab ]
{

/// HIS和MDM对照表ID InitialExpression = {$I(^Config.ENS.EnsHISLookUpMDMTabC)}
Property EHLMTableID As %Library.String(COLLATION = "EXACT", MAXLEN = 32767) [ InitialExpression = {$I(^Config.ENS.EnsHISLookUpMDMTabC)}, Required, SqlColumnNumber = 2, SqlFieldName = EHLM_TableID ];

/// HIS表代码
Property EHLMHISTableCode As %Library.String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlColumnNumber = 3, SqlFieldName = EHLM_HISTableCode ];

/// MDM表代码
Property EHLMMDMTableCode As %Library.String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlColumnNumber = 4, SqlFieldName = EHLM_MDMTableCode ];

/// 备注
Property EHLMRemarks As %Library.String(COLLATION = "EXACT", MAXLEN = 32767) [ SqlColumnNumber = 5, SqlFieldName = EHLM_Remarks ];

/// 创建日期
Property EHLMCreatDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = EHLM_CreatDate ];

/// 创建时间
Property EHLMCreatTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = EHLM_CreatTime ];

/// 最后更新日期
Property EHLMUpdateDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = EHLM_UpdateDate ];

/// 最后更新时间
Property EHLMUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = EHLM_UpdateTime ];

/// 描述
Property EHLMDescription As %Library.String [ SqlColumnNumber = 10, SqlFieldName = EHLM_Description ];

Index IndexEHLMTable On EHLMTableID [ PrimaryKey, Type = index, Unique ];

Index IndexMHTabcode On (EHLMMDMTableCode, EHLMHISTableCode) [ Type = index ];

Storage Default
{
<Data name="EnsHISLookUpMDMTabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHLMTableID</Value>
</Value>
<Value name="3">
<Value>EHLMHISTableCode</Value>
</Value>
<Value name="4">
<Value>EHLMMDMTableCode</Value>
</Value>
<Value name="5">
<Value>EHLMRemarks</Value>
</Value>
<Value name="6">
<Value>EHLMCreatDate</Value>
</Value>
<Value name="7">
<Value>EHLMCreatTime</Value>
</Value>
<Value name="8">
<Value>EHLMUpdateDate</Value>
</Value>
<Value name="9">
<Value>EHLMUpdateTime</Value>
</Value>
<Value name="10">
<Value>EHLMDescription</Value>
</Value>
</Data>
<DataLocation>^Config.ENS.EnsHISLookUpMDMTabD</DataLocation>
<DefaultData>EnsHISLookUpMDMTabDefaultData</DefaultData>
<IdLocation>^Config.ENS.EnsHISLookUpMDMTabD</IdLocation>
<IndexLocation>^Config.ENS.EnsHISLookUpMDMTabI</IndexLocation>
<StreamLocation>^Config.ENS.EnsHISLookUpMDMTabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
