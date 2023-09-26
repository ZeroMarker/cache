/// Decimal Conversion Factor
Class User.PHAINDeciConFac Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PINDCF_RowID, SqlTableName = PHAIN_DeciConFac, StorageStrategy = SQLStorage ]
{

/// PINDCF_FrDeci
Property PINDCFFrDeci As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PINDCF_FrDeci ];

/// PINDCF_ToDeci
Property PINDCFToDeci As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PINDCF_ToDeci ];

/// PINDCF_FacVal
Property PINDCFFacVal As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PINDCF_FacVal ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.DCF(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PINDCF_FacVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PINDCF_FrDeci">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINDCF_ToDeci">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.IN.DCF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PINDCF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PINDCF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PINDCF_RowID</SqlRowIdName>
<StreamLocation>^User.PHAINDeciConFacS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
