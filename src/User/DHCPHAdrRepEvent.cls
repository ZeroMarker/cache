Class User.DHCPHAdrRepEvent Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRE_RowID, SqlTableName = DHC_PHAdrRepEvent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRREChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADRRE_ADRR_Parref
Relationship ADRREADRRParref As User.DHCPHAdrReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPEVENT, Required, SqlFieldName = ADRRE_ADRR_Parref ];

/// ADRRE_ChildSub
Property ADRREChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRRE_ChildSub ];

/// ADRRE_ADRE_DR 
Property ADRREADREDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRRE_ADRE_DR ];

/// ADRRE_Desc
Property ADRREDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADRRE_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRRE_ADRE_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRRE_Desc">
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
<Field>ADRRE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrReport.ADRR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADRRE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRRE_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrRepEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
