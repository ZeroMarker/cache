/// 配液收费规则子表,判断规则
Class User.PHAPIVASFeeRuleItm Extends (%Persistent, User.Abstract) [ SqlTableName = PHAPIVAS_FeeRuleItm, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PFRIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PFRIPFRParRef As User.PHAPIVASFeeRule [ Cardinality = parent, Inverse = ChildPHAPIVASFeeRuleItm, Required, SqlFieldName = PFRI_PFR_ParRef ];

Property PFRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PFRI_ChildSub ];

/// 类型
Property PFRIType As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PFRI_Type ];

/// 类型与值关系
Property PFRIOperate As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PFRI_Operate ];

/// 类型值
Property PFRITypeValue As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PFRI_TypeValue ];

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PFRI_Operate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PFRI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PFRI_TypeValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.PIVAS.FeeRule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAPIVAS_FeeRule.PFR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PFRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAPIVAS_FeeRule.PFR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PFRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PFRI_RowID</SqlRowIdName>
<StreamLocation>^User.PHAPIVASFeeRuleItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
