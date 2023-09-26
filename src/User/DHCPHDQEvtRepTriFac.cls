Class User.DHCPHDQEvtRepTriFac Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DQERTF_RowID, SqlTableName = DHC_PHDQEvtRepTriFac, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DQERTFChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHDrgQuaEvtReport Parent Reference DQERTF_DQER_Parref
Relationship DQERTFDQERParref As User.DHCPHDrgQuaEvtReport [ Cardinality = parent, Inverse = ChildDHCPHDQEVTREPTRIFAC, Required, SqlFieldName = DQERTF_DQER_Parref ];

/// DQERTF_ChildSub
Property DQERTFChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DQERTF_ChildSub ];

/// DQERTF_DQETF_DR 
Property DQERTFDQETFDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DQERTF_DQETF_DR ];

/// DQERTF_ETFDesc
Property DQERTFETFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DQERTF_ETFDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DQERTF_DQETF_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DQERTF_ETFDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDQER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDrgQuaEvtReport.DQER_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DQERTF_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHDrgQuaEvtReport.DQER_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DQERTF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DQERTF_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDQEvtRepTriFacS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
