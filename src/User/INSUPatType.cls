Class User.INSUPatType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INPAT_RowID, SqlTableName = INSU_PatType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INPAT_PatCode
Property INPATPatCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INPAT_PatCode ];

/// INPAT_PatDesc
Property INPATPatDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INPAT_PatDesc ];

/// INPAT_PatEnable
Property INPATPatEnable As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = INPAT_PatEnable ];

/// INPAT_PatDemo
Property INPATPatDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INPAT_PatDemo ];

/// INPAT_PatSill1
Property INPATPatSill1 As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = INPAT_PatSill1 ];

/// INPAT_PatSill2
Property INPATPatSill2 As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INPAT_PatSill2 ];

/// INPAT_PatSill3
Property INPATPatSill3 As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INPAT_PatSill3 ];

/// INPAT_PatTcSelfP1
Property INPATPatTcSelfP1 As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INPAT_PatTcSelfP1 ];

/// INPAT_PatTcSelfP2
Property INPATPatTcSelfP2 As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INPAT_PatTcSelfP2 ];

/// INPAT_PatJzSelfP1
Property INPATPatJzSelfP1 As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INPAT_PatJzSelfP1 ];

/// INPAT_PatJzSelfP2
Property INPATPatJzSelfP2 As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INPAT_PatJzSelfP2 ];

/// INPAT_PatJzSelfP3
Property INPATPatJzSelfP3 As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INPAT_PatJzSelfP3 ];

/// INPAT_PatTcSelfP3
Property INPATPatTcSelfP3 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INPAT_PatTcSelfP3 ];

/// INPAT_PatFD
Property INPATPatFD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INPAT_PatFD ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINPAT)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INPAT_PatCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPAT_PatDemo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPAT_PatDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPAT_PatEnable">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPAT_PatFD">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPAT_PatJzSelfP1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPAT_PatJzSelfP2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPAT_PatJzSelfP3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPAT_PatSill1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPAT_PatSill2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPAT_PatSill3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPAT_PatTcSelfP1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPAT_PatTcSelfP2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPAT_PatTcSelfP3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCINPAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INPAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INPAT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofCodeDesc">
<Global>^DHCINPAT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPAT_PatCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INPAT_PatDesc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INPAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPatCode">
<Global>^DHCINPAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAT_PatCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INPAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUPatTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
