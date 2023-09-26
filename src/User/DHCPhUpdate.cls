Class User.DHCPhUpdate Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUP_Rowid, SqlTableName = DHCPhUpdate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHUP_Date
Property PHUPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHUP_Date ];

/// PHUP_Inci_dr
Property PHUPIncidr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHUP_Inci_dr ];

/// PHUP_QtyLK
Property PHUPQtyLK As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHUP_QtyLK ];

/// PHUP_QtyTrak
Property PHUPQtyTrak As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHUP_QtyTrak ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHUP)</SqlIdExpression>
<SQLMap name="phupdateindex">
<Global>^DHCPHUPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHUP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHUP_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHUP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phupincindex">
<Global>^DHCPHUPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHUP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHUP_Inci_dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHUP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phupmaster">
<Data name="PHUP_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUP_Inci_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUP_QtyLK">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUP_QtyTrak">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHUP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHUP_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhUpdateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
