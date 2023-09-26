Class User.DHCPHAdrRepImpInfo Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRI_RowID, SqlTableName = DHC_PHAdrRepImpInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRRIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADRRI_ADRR_Parref
Relationship ADRRIADRRParref As User.DHCPHAdrReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPIMPINFO, Required, SqlFieldName = ADRRI_ADRR_Parref ];

/// ADRRI_ChildSub
Property ADRRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRRI_ChildSub ];

/// ADRRI_ADRII_DR 
Property ADRRIADRIIDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRRI_ADRII_DR ];

/// ADRRI_ImpInfo
Property ADRRIImpInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADRRI_ImpInfo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRRI_ADRII_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRRI_ImpInfo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdrReport.ADRR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADRRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrReport.ADRR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADRRII"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrRepImpInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
