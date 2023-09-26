/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：知识点映射明细表
/// Table：User.MKBKLMappingDetail
Class User.MKBKLMappingDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTPD_RowId, SqlTableName = MKB_KLMappingDetail ]
{

/// 列值
Property MKBKMDValue As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBKMD_Value ];

/// 知识点映射字段表DR
Property MKBKMDKMBaseFieldDr As User.MKBKLMappingBaseField [ SqlColumnNumber = 3, SqlFieldName = MKBKMD_KMBaseField_Dr ];

/// 行号
Property MKBKMDRowNum As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBKMD_RowNum ];

/// 知识点映射表DR
Property MKBKMDKMBaseDr As User.MKBKLMappingBase [ SqlColumnNumber = 5, SqlFieldName = MKBKMD_KMBase_Dr ];

/// 映射字段表索引
Index FieldDrIndex On MKBKMDKMBaseFieldDr As Exact;

/// 值索引
Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);

/// 行号索引
Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);

/// Base表索引
Index BaseIndex On MKBKMDKMBaseDr As Exact;

Storage Default
{
<Data name="MKBKLMappingDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBKMDValue</Value>
</Value>
<Value name="3">
<Value>MKBKMDKMBaseFieldDr</Value>
</Value>
<Value name="4">
<Value>MKBKMDRowNum</Value>
</Value>
<Value name="5">
<Value>MKBKMDKMBaseDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBKLMappingDetailD</DataLocation>
<DefaultData>MKBKLMappingDetailDefaultData</DefaultData>
<IdLocation>^User.MKBKLMappingDetailD</IdLocation>
<IndexLocation>^User.MKBKLMappingDetailI</IndexLocation>
<StreamLocation>^User.MKBKLMappingDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
