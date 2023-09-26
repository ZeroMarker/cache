Class User.DHCEQCostAllotDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CAD_RowID, SqlTableName = DHC_EQCostAllotDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CAD_SourceType
Property CADSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CAD_SourceType ];

/// CAD_SourceID
Property CADSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CAD_SourceID ];

/// CAD_LocDR
Property CADLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CAD_LocDR ];

/// CAD_RateOrWorkLoadNum
Property CADRateOrWorkLoadNum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CAD_RateOrWorkLoadNum ];

/// CAD_Amount
Property CADAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = CAD_Amount ];

/// CAD_Hold1
Property CADHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CAD_Hold1 ];

/// CAD_Hold2
Property CADHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CAD_Hold2 ];

/// CAD_Hold3
Property CADHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CAD_Hold3 ];

/// CAD_Hold4
Property CADHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CAD_Hold4 ];

/// CAD_Hold5
Property CADHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CAD_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCostAllotDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CAD_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CAD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CAD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CAD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CAD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CAD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CAD_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CAD_RateOrWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CAD_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CAD_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCostAllotDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CAD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CAD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQCostAllotDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CAD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CAD_SourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CAD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCostAllotDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
