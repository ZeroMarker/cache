Class User.DHCARCConfine Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ARCCON_Rowid, SqlTableName = DHC_ARCConfine, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ARCCON_ARCITEM_DR
Property ARCCONARCITEMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ARCCON_ARCITEM_DR ];

/// ARCCON_FLAG
Property ARCCONFLAG As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ARCCON_FLAG ];

/// ARCCON_PatType
Property ARCCONPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ARCCON_PatType ];

/// ARCCON_Date
Property ARCCONDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = ARCCON_Date ];

/// ARCCON_Time
Property ARCCONTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ARCCON_Time ];

/// ARCCON_User
Property ARCCONUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ARCCON_User ];

/// ARCCON_Remarks
Property ARCCONRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ARCCON_Remarks ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCARCCON)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="ARCCON_ARCITEM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCCON_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARCCON_FLAG">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCCON_PatType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCCON_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCCON_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCCON_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCCON_User">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCARCCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARCCON_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARCCON_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCITEMDR">
<Global>^DHCARCCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARCCON_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ARCITEMDR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARCCON_ARCITEM_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCCON_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCARCConfineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
