/// DHC_AMTDEL 
Class User.DHCAMTDEL Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_AMTDEL, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On delirowid [ IdKey, PrimaryKey, Unique ];

/// deli_comment1
Property delicomment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = deli_comment1 ];

/// deli_comment2
Property delicomment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = deli_comment2 ];

/// deli_date
Property delidate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = deli_date ];

/// deli_endnum
Property deliendnum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = deli_endnum ];

/// deli_flag
Property deliflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = deli_flag ];

/// deli_getor
Property deligetor As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = deli_getor ];

/// deli_curinv
Property delilatestinv As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = deli_latestinv ];

/// deli_loc
/// (DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registration,Login", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L")
Property deliloc As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = deli_loc ];

/// DHC_AMTDEL Row ID
Property delirowid As %Library.Numeric(SCALE = 0, SELECTIVITY = 1) [ InitialExpression = {$i(^mdata("DHCAMTDEL"))}, Required, SqlFieldName = deli_rowid ];

/// deli_stnum
Property delistnum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = deli_stnum ];

/// deli_time
Property delitime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = deli_time ];

/// deli_title
Property delititle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = deli_title ];

/// deli_updatedat
Property deliupdatedat As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = deli_updatedat ];

/// deli_user
Property deliuser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = deli_user ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="Indexcomment1">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Comment1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_comment1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcomment2">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"comment2"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_comment2}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextitle">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Title"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_title}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexavail">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{deli_flag}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{deli_date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexendinvoiceno">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"E"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{deli_endnum}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexgetor">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"G"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{deli_getor}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexloc">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{deli_loc}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexstinvoiceno">
<Global>^DHCAMTDEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{deli_stnum}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="mastdeli">
<Data name="deli_comment1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="deli_comment2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="deli_date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="deli_endnum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="deli_flag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="deli_getor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="deli_latestinv">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="deli_loc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="deli_stnum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="deli_time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="deli_title">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="deli_updatedat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="deli_user">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCAMTDEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>deli_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{deli_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAMTDELS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
