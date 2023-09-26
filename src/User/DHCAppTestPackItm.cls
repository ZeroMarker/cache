Class User.DHCAppTestPackItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ATP_RowID, SqlTableName = DHC_AppTestPackItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ATPIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppTestPack Parent Reference ATPI_ATP_ParRef
Relationship ATPIATPParRef As User.DHCAppTestPack [ Cardinality = parent, Inverse = ChildDHCAPPTestPackItm, Required, SqlFieldName = ATPI_ATP_ParRef ];

/// ATPI_ChildSub
Property ATPIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ATPI_ChildSub ];

/// 子部位id  ATPI_Arc_Dr
Property ATPIArcDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ATPI_Arc_Dr ];

/// 数量  ATPI_Qty
Property ATPIQty As User.DHCAppTestItem [ SqlColumnNumber = 4, SqlFieldName = ATPI_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="ATPI_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATPI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPTP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppTestPack.ATP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ATPI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppTestPack.ATP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATPI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestPackItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
