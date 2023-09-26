Class User.DHCWLStat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WLSTAT_Rowid, SqlTableName = DHC_WLStat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCWLSTItem As User.DHCWLSTItem [ Cardinality = children, Inverse = WLSTITWLSTATParRef ];

/// WLSTAT_Code
Property WLSTATCode As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = WLSTAT_Code ];

/// WLSTAT_Desc
Property WLSTATDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WLSTAT_Desc ];

/// WLSTAT_Date
Property WLSTATDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = WLSTAT_Date ];

/// WLSTAT_Type
Property WLSTATType As %Library.String(MAXLEN = 8, SELECTIVITY = "8.3333%", VALUELIST = ",BillGrp||BG,BillSub||BS,ItemMast||IM,ItemCat||IC,TarItem||TM,TarAC||TAC,TarSC||TSC,TarOC||TOC,TarEC||TEC,TarMC||TMC,TarIC||TIC") [ SqlColumnNumber = 5, SqlFieldName = WLSTAT_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLSTAT(0))</SqlIdExpression>
<SQLMap name="DataMasterWLSTAT">
<Data name="WLSTAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLSTAT_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLSTAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLSTAT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCWLSTAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WLSTAT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{WLSTAT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLSTAT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLSTAT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLSTAT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLStatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
