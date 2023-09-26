Class User.DHCINReqItmEvaluation Extends (%Persistent, User.Abstract) [ SqlRowIdName = EVL_RowId, SqlTableName = DHC_INReqItm_Evaluation, StorageStrategy = SqlStorate ]
{

Property EVLINRQIDR As User.INReqItm [ SqlColumnNumber = 2, SqlFieldName = EVL_INRQI_DR ];

Property EVLINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = EVL_INCI_DR ];

Property EVLGrade As %Numeric [ SqlColumnNumber = 4, SqlFieldName = EVL_Grade ];

Property EVLDescription As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EVL_Description ];

Property EVLSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = EVL_SSUSR_DR ];

Property EVLDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = EVL_Date ];

Property EVLTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = EVL_Time ];

Storage SqlStorate
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINRQIEVL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EVL_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EVL_Description">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EVL_Grade">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EVL_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EVL_INRQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EVL_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EVL_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINRQIEVL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EVL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{EVL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCIDate">
<Global>^DHCINRQIEVL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EVL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{EVL_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EVL_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{EVL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINRQI">
<Global>^DHCINRQIEVL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EVL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{EVL_INRQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EVL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EVL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINReqItmEvaluationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINRQIEVL)
	s oldI = +$g(^mdata("DHCINREQITMEVALUATION"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINRQIEVL = maxI
	s ^mdata("DHCINREQITMEVALUATION") = maxI
}

}
