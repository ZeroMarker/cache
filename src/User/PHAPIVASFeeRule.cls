/// 配液收费规则
Class User.PHAPIVASFeeRule Extends %Persistent [ SqlTableName = PHAPIVAS_FeeRule, StorageStrategy = CacheSQLStorage ]
{

Relationship ChildPHAPIVASFeeRuleItm As User.PHAPIVASFeeRuleItm [ Cardinality = children, Inverse = PFRIPFRParRef ];

Relationship ChildPHAPIVASFeeRuleLink As User.PHAPIVASFeeRuleLink [ Cardinality = children, Inverse = PFRLPFRParRef ];

/// 规则名称
Property PFRDesc As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PFR_Desc ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.PIVAS.FeeRule)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PFR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.PHA.PIVAS.FeeRule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PFR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PFR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PFR_RowID</SqlRowIdName>
<StreamLocation>^User.PHAPIVASFeeRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.PIVAS.FeeRule)
	s oldI = +$g(^mdata("^CF.PHA.PIVAS.FeeRule"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.PIVAS.FeeRule = maxI
	s ^mdata("^CF.PHA.PIVAS.FeeRule") = maxI
}

}
