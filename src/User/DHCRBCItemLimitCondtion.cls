Class User.DHCRBCItemLimitCondtion Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIBPL_ROWID, SqlTableName = DHCRBC_ItemLimitCondtion, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DIBPL_ARCItmMast_DR
Property DIBPLARCItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DIBPL_ARCItmMast_DR ];

/// DIBPL_ApplicationField_ID
Property DIBPLApplicationFieldID As User.DHCRBCApplicationField [ SqlColumnNumber = 3, SqlFieldName = DIBPL_ApplicationField_ID ];

/// DIBL_ApplicationFieldValue
Property DIBLApplicationFieldValue As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DIBL_ApplicationFieldValue ];

/// DIPL_BookTime
Property DIBPLBookTime As %Library.String(DISPLAYLIST = ",Today,NextDay,Never,Now", MAXLEN = 7, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",T,ND,NV,N") [ SqlColumnNumber = 5, SqlFieldName = DIBPL_BookTime ];

/// DIBPL_Reqire
Property DIBPLReqire As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DIBPL_Reqire ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItemLimitCondtion)</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="DIBL_ApplicationFieldValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIBPL_ARCItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIBPL_ApplicationField_ID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIBPL_BookTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIBPL_Reqire">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBCItemLimitCondtion</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DIBPL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIBPL_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemLimitCondtionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
