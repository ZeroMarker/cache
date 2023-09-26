Class User.DHCPHCNTSWAY Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PWAY_RowID, SqlTableName = DHC_PHCNTSWAY, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PWAY_Code
Property PWAYCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PWAY_Code ];

/// PWAY_Desc
Property PWAYDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PWAY_Desc ];

/// PWAY_Active
Property PWAYActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PWAY_Active ];

/// PWAY_QueryDays
Property PWAYQueryDays As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PWAY_QueryDays ];

/// PWAY_ReSaveFlag
Property PWAYReSaveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PWAY_ReSaveFlag ];

Relationship ChildDHCPHCNTSWAYITM As DHCPHCNTSWAYITM [ Cardinality = children, Inverse = PWAYIParref ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCWAY)</SqlIdExpression>
<SQLMap name="DataDHCPCWAY">
<Data name="PWAY_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PWAY_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PWAY_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PWAY_QueryDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PWAY_ReSaveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPCWAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PWAY_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PWAY_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPCWAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PWAY_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PWAY_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PWAY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSWAYS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
