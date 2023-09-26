Class User.DHCSYD Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCSYD_Rowid, SqlTableName = DHC_SYD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCSYD_EndDate
Property DHCSYDEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DHCSYD_EndDate ];

/// DHCSYD_OEORD_Dr
Property DHCSYDOEORDDr As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DHCSYD_OEORD_Dr ];

/// DHCSYD_OEORD_Parref
Property DHCSYDOEORDParref As User.OEOrder [ SqlColumnNumber = 9, SqlFieldName = DHCSYD_OEORD_Parref ];

/// DHCSYD_STDate
Property DHCSYDSTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCSYD_STDate ];

/// DHCSYD_STTime
Property DHCSYDSTTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DHCSYD_STTime ];

/// DHCSYD_SeqNo
Property DHCSYDSeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCSYD_SeqNo ];

/// DHCSYD_Status
Property DHCSYDStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCSYD_Status ];

/// DHCSYD_StopDate
Property DHCSYDStopDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCSYD_StopDate ];

/// DHCSYD_Stoptime
Property DHCSYDStopTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DHCSYD_StopTime ];

/// DHCSYD_StopUser
Property DHCSYDStopUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCSYD_StopUser ];

/// DHCSYD_Type
Property DHCSYDType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCSYD_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSYD)</SqlIdExpression>
<SQLMap name="DHCSYDDATA">
<Data name="DHCSYD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCSYD_OEORD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCSYD_OEORD_Parref">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCSYD_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSYD_STDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCSYD_STTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCSYD_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCSYD_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCSYD_StopDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCSYD_StopTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCSYD_StopUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCSYD_Type">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCSYD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCSYD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DHCSYDOEORDPARREF">
<Global>^DHCSYD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCSYD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"OEORDPARREF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_OEORD_Parref}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCSYDOeord">
<Global>^DHCSYD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCSYD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"OEORD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_OEORD_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCSYDi">
<Global>^DHCSYD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCSYD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"StDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_STDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_OEORD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCSYD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSYDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
