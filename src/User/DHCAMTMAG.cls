/// DHC_AMTMAG
Class User.DHCAMTMAG Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_AMTMAG, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On finacrowid [ IdKey, PrimaryKey, Unique ];

/// finac_date
Property finacdate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = finac_date ];

/// finac_loc
Property finacloc As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = finac_loc ];

/// finac_buyer
Property finacbuyer As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = finac_buyer ];

/// finac_amount
Property finacamount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = finac_amount ];

/// finac_stnum
Property finacstnum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = finac_stnum ];

/// finac_ednum
Property finacednum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = finac_ednum ];

/// finac_note
Property finacnote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = finac_note ];

/// finac_user
Property finacupdateusr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = finac_updateusr ];

/// finac_updatedat
Property finacupdatedat As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = finac_updatedat ];

/// invoice purchase using available flag
Property finacavail As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = finac_avail ];

/// finac_time
Property finactime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = finac_time ];

/// finac_serialno
Property finacserialno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = finac_serialno ];

/// finac_title
Property finactitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = finac_title ];

/// finac_comment1
Property finaccomment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = finac_comment1 ];

/// finac_comment2
Property finaccomment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = finac_comment2 ];

/// finac_hospital
Property finachospital As User.CTHospital [ SqlColumnNumber = 17, SqlFieldName = finac_hospital ];

/// DHC_AMTMAG Row ID
Property finacrowid As %Library.Numeric(SCALE = 0, SELECTIVITY = 1) [ InitialExpression = {$i(^mdata("DHCAMTMAG"))}, Required, SqlFieldName = finac_rowid ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="BeginINVABCIdx">
<Global>^DHCAMTMAGi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BINVABC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_loc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_title}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$l({finac_stnum})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{finac_stnum}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="BeginINVIdx">
<Global>^DHCAMTMAGi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BINV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_loc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$l({finac_stnum})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{finac_stnum}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcomment1">
<Global>^DHCAMTMAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>finac_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"comment1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_comment1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcomment2">
<Global>^DHCAMTMAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>finac_rowid</Field>
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
<Expression>{finac_comment2}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextitle">
<Global>^DHCAMTMAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>finac_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"title"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_title}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexavail">
<Global>^DHCAMTMAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>finac_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_avail}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCAMTMAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>finac_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexloc">
<Global>^DHCAMTMAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>finac_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{finac_loc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{finac_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="mastfinacial">
<Data name="finac_amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="finac_avail">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="finac_buyer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="finac_comment1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="finac_comment2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="finac_date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="finac_ednum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="finac_hospital">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="finac_loc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="finac_note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="finac_serialno">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="finac_stnum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="finac_time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="finac_title">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="finac_updatedat">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="finac_updateusr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAMTMAG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>finac_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{finac_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAMTMAGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
