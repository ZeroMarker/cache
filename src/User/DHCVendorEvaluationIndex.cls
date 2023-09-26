Class User.DHCVendorEvaluationIndex Extends (%Persistent, User.Abstract) [ SqlRowIdName = VEI_RowId, SqlTableName = DHC_VendorEvaluationIndex, StorageStrategy = SQLStorage ]
{

Property VEICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VEI_Code ];

Property VEIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VEI_Desc ];

Property VEIWeight As %Float [ SqlColumnNumber = 4, SqlFieldName = VEI_Weight ];

/// 系统指标标志
Property VEISySIndex As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = VEI_SySIndex ];

/// 备注
Property VEIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VEI_Remarks ];

/// 分数是否可编辑标志
Property VEIScoreEdited As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = VEI_ScoreEdited ];

/// 计算规则
Property VEICalculationRules As %Library.String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = VEI_CalculationRules ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVEI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VEI_CalculationRules">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VEI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VEI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VEI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VEI_ScoreEdited">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VEI_SySIndex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VEI_Weight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCVEI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VEI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VEI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VEI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVendorEvaluationIndexS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVEI)
	s oldI = +$g(^mdata("DHCVENEVALINDEX"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVEI = maxI
	s ^mdata("DHCVENEVALINDEX") = maxI
}

Parameter EXTENTSIZE = 250;

}
