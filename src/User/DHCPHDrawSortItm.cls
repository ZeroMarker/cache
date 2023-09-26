Class User.DHCPHDrawSortItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDWSI_RowID, SqlTableName = DHC_PHDrawSortItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On PHDWSIChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表 Parent Reference
Relationship PHDWSIPHDWSParref As User.DHCPHDrawSort [ Cardinality = parent, Inverse = ChildDHCPHDrawSortItm, Required, SqlFieldName = PHDWSI_PHDWS_Parref ];

/// PHDWSI_ChildSub
Property PHDWSIChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPHDWSORT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = PHDWSI_ChildSub ];

/// 顺序号
Property PHDWSISN As %Library.Numeric [ SqlColumnNumber = 3, SqlFieldName = PHDWSI_SN ];

/// 货位号
Property PHDWSIIncsbDr As User.INCStkBin [ SqlColumnNumber = 4, SqlFieldName = PHDWSI_Incsb_Dr ];

/// 库存项
Property PHDWSIInciDr As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = PHDWSI_Inci_Dr ];

/// 货位号
Property PHDWSIBinCode As %String [ SqlColumnNumber = 6, SqlFieldName = PHDWSI_BinCode ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHDWSI_BinCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDWSI_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDWSI_Incsb_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDWSI_SN">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHDWSORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDrawSort.PHDWS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHDWSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDrawSort.PHDWS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHDWSI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCPHDWSORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHDrawSort.PHDWS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHDWSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDWSI_Inci_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDWSI_PHDWS_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDWSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncsb">
<Global>^DHCPHDWSORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHDrawSort.PHDWS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHDWSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHDINCSB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDWSI_Incsb_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDWSI_PHDWS_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDWSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCPHDrawSortItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
