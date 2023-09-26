/// SetTop From
Class User.DHCVISTopFrom Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FromRowID, SqlTableName = DHC_VIS_TopFrom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SetTop From Code
Property FromCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// SetTop From Desc 
Property FromDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// From Global ID
Property GlobalID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// From HeatBeat
Property HeartBeat As %Library.Float [ SqlColumnNumber = 5 ];

/// From Backgroup Picture
Property BGPicture As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// From Style
Property FromStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// From Note
Property FromNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// From Update User
Property UpdateUser As User.SSUser [ SqlColumnNumber = 9 ];

/// From Update Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10 ];

/// From Update Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 11 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISTopFrom)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BGPicture">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FromCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FromDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FromNote">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FromStyle">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GlobalID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HeartBeat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCVISTopFrom</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FromRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{FromRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISTopFromS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
