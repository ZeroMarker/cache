Class User.DHCPEStationWait Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STW_RowId, SqlTableName = DHC_PE_StationWait, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEStationWait";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On STWChildSub [ IdKey, PrimaryKey, Unique ];

/// STW_ChildSub
Property STWChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCPEST($p(%d(0),$c(1),1),"Wait",0))}, Required, SqlColumnNumber = 2, SqlFieldName = STW_ChildSub ];

/// STW_IADM_DR
Property STWIADMDR As User.DHCPEIADM [ SqlColumnNumber = 3, SqlFieldName = STW_IADM_DR ];

/// DHC_PE_Station Parent Reference
Relationship STWParRef As User.DHCPEStation [ Cardinality = parent, Inverse = ChildDHCPEStationWait, Required, SqlFieldName = STW_ParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPESTW">
<Data name="STW_IADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>STW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Wait"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STW_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEStationWaitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
