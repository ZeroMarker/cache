/// DHC_PAC_BedStatusChange
Class User.DHCPACBedStatusChange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STAT_RowId, SqlTableName = DHC_PAC_BedStatusChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (STATWardDr, STATBedChildsub, STATChildsub) [ IdKey, PrimaryKey, Unique ];

/// STAT_Ward_Dr
Property STATWardDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = STAT_Ward_Dr ];

/// STAT_Bed_Childsub
Property STATBedChildsub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = STAT_Bed_Childsub ];

/// STAT_Childsub
Property STATChildsub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = STAT_Childsub ];

/// STAT_PAADM_Dr
Property STATPAADMDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = STAT_PAADM_Dr ];

/// STAT_CTLOC_Dr
Property STATCTLOCDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = STAT_CTLOC_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="STAT_CTLOC_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="STAT_PAADM_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Global>^PAWARDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STAT_Ward_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>STAT_Bed_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>STAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{STAT_Ward_Dr}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STAT_Bed_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^PAWARDA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STAT_Ward_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>STAT_Bed_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>STAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STAT_PAADM_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STAT_Ward_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAT_Bed_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{STAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPACBedStatusChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
