Class User.DHCCardBathInvPrt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_CardBathInvPrt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CardType
Property CardType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// CardNo
Property CardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// CardSerialNo
Property CardSerialNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// PatName
Property PatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// PatientID
Property PatientID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// PayType
Property PayType As %Library.String(MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,R") [ SqlColumnNumber = 7 ];

/// PayAmount
Property PayAmount As %Library.Float [ SqlColumnNumber = 8 ];

/// UserID
Property UserID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// AddDate
Property AddDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 10 ];

/// AddTime
Property AddTime As %Library.Time [ SqlColumnNumber = 11 ];

/// HandinFlag
Property HandinFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// HandinDate
Property HandinDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 13 ];

/// HandinTime
Property HandinTime As %Library.Time [ SqlColumnNumber = 14 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCardBathInvPrt)</SqlIdExpression>
<SQLMap name="DataDHCCardBathInvPrt">
<Data name="AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CardNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CardSerialNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CardType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HandinFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PatientID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PayAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PayType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UserID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCardBathInvPrt</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCardNo">
<Global>^DHCCardBathInvPrt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CardNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CardNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCardSerialNo">
<Global>^DHCCardBathInvPrt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CardSerialNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CardSerialNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCCardBathInvPrt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AddDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexHnadinDate">
<Global>^DHCCardBathInvPrt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"HandinDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HandinDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPatientID">
<Global>^DHCCardBathInvPrt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatientID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PatientID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUserID">
<Global>^DHCCardBathInvPrt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UserID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCardBathInvPrtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
