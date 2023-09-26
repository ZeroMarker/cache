Class User.DHCStkMonSumTransLoc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = SUMTL_RowId, SqlTableName = DHC_StkMonSum_TransLoc, StorageStrategy = SqlStorage1 ]
{

/// SUMTL_SM_DR
Property SUMTLSMDR As User.DHCStkMon [ SqlColumnNumber = 2, SqlFieldName = SUMTL_SM_DR ];

/// SUMTL_Type
Property SUMTLType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SUMTL_Type ];

/// SUMTL_RelaLoc_DR
Property SUMTLRelaLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = SUMTL_RelaLoc_DR ];

/// SUMTL_StkCat_DR
Property SUMTLStkCatDR As User.INCStkCat [ SqlColumnNumber = 5, SqlFieldName = SUMTL_StkCat_DR ];

/// SUMTL_SCG_DR
Property SUMTLSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 6, SqlFieldName = SUMTL_SCG_DR ];

/// SUMTL_RpAmt
Property SUMTLRpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SUMTL_RpAmt ];

/// SUMTL_SpAmt
Property SUMTLSpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SUMTL_SpAmt ];

/// SUMTL_RelaOrg
Property SUMTLRelaOrg As %Library.String [ SqlColumnNumber = 9, SqlFieldName = SUMTL_RelaOrg ];

Storage SqlStorage1
{
<SqlIdExpression>$i(^DHCSMSum("SUMTL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SUMTL_RelaLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUMTL_RelaOrg">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUMTL_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SUMTL_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUMTL_SM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUMTL_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUMTL_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUMTL_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSMSum</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SUMTL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"SUMTL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{SUMTL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMon">
<Global>^DHCSMSum</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SUMTL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"SUMTL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Mon"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUMTL_SM_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SUMTL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonSumTransLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
