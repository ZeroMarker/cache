/// 配液收费规则子表,收取规则
Class User.PHAPIVASFeeRuleLink Extends (%Persistent, User.Abstract) [ SqlTableName = PHAPIVAS_FeeRuleLink, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PFRLChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PFRLPFRParRef As User.PHAPIVASFeeRule [ Cardinality = parent, Inverse = ChildPHAPIVASFeeRuleLink, Required, SqlFieldName = PFRL_PFR_ParRef ];

Property PFRLChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PFRL_ChildSub ];

Property PFRLArcimDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = PFRL_Arcim_DR ];

Property PFRLQty As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = PFRL_Qty ];

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PFRL_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PFRL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.PIVAS.FeeRule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAPIVAS_FeeRule.PFR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PFRL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAPIVAS_FeeRule.PFR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PFRL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PFRL_RowID</SqlRowIdName>
<StreamLocation>^User.PHAPIVASFeeRuleLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
