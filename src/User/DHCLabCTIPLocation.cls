Class User.DHCLabCTIPLocation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLIL_RowID, SqlTableName = DHC_LabCTIPLocation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DLILLocDR [ IdKey, PrimaryKey, Unique ];

/// DHC_LabCTIP Parent Reference
Relationship DLILParRef As User.DHCLabCTIP [ Cardinality = parent, Inverse = ChildDHCLabCTIPLocation, Required, SqlFieldName = DLIL_ParRef ];

/// DLIL_LocDR
Property DLILLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DLIL_LocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Global>^DHCLabCTIP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LabCTIP.DLIP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DLIL_LocDR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_LabCTIP.DLIP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLIL_LocDR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLabCTIPLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
