Class User.DHCMedDeathBook Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDB_Rowid, SqlTableName = DHC_MedDeathBook, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedDeathBSub As User.DHCMedDeathBSub [ Cardinality = children, Inverse = MDBSParRef ];

/// MDB_Type_DR
Property MDBTypeDR As User.DHCMedDictory [ SqlColumnNumber = 2, SqlFieldName = MDB_Type_DR ];

/// MDB_NOFrom
Property MDBNOFrom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MDB_NOFrom ];

/// MDB_NOTo
Property MDBNOTo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MDB_NOTo ];

/// MDB_NONow
Property MDBNONow As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MDB_NONow ];

/// MDB_FinalFlag
Property MDBFinalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MDB_FinalFlag ];

/// MDB_Date
Property MDBDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MDB_Date ];

/// MDB_Time
Property MDBTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MDB_Time ];

/// MDB_User_DR
Property MDBUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = MDB_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDB)</SqlIdExpression>
<SQLMap name="DataMasteMap">
<Data name="MDB_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MDB_FinalFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDB_NOFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDB_NONow">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDB_NOTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDB_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MDB_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDB_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMDB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MDB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MDB_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCMDB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TYPEDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDB_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDB_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeFlag">
<Global>^DHCMDB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TYPEFLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDB_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDB_FinalFlag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDeathBookS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
