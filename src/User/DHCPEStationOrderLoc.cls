/// 【作废】站点项目关联科室
Class User.DHCPEStationOrderLoc Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STORDL_RowId, SqlTableName = DHC_PE_StationOrderLoc, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEStationOrderLoc";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On STORDLChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_StationOrder Parent Reference
Relationship STORDLParRef As User.DHCPEStationOrder [ Cardinality = parent, Inverse = ChildDHCPEStationOrderLoc, Required, SqlFieldName = STORDL_ParRef ];

/// STORDL_ChildSub
Property STORDLChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEST(+%d(0),"O",$p($p(%d(0),$c(1)),"||",2),"STORDL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = STORDL_ChildSub ];

/// 【作废】科室名称 指向CT_Loc
Property STORDLLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = STORDL_Loc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEST">
<Data name="STORDL_Loc_DR">
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
<Field>DHC_PE_StationOrder.STORD_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>STORDL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_StationOrder.STORD_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"STORDL"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{STORDL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEStationOrderLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
