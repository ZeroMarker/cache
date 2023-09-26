Class User.DHCPEPreGTOrdItemTarItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGTOIT_RowId, SqlTableName = DHC_PE_PreGTOrdItemTarItem, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreGTOrdItemTarItem";

Index RowIDBasedIDKeyIndex On PGTOITChildSub [ IdKey, PrimaryKey, Unique ];

/// PGTOIT_ChildSub
Property PGTOITChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreGADM(+%d(0),"Team",$p($p(%d(0),$c(1)),"||",2),"ORDITEM",$p($p(%d(0),$c(1)),"||",3),"TarItem",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PGTOIT_ChildSub ];

/// DHC_PE_PreIOrdItem Parent Reference
Relationship PGTOITParRef As User.DHCPEPreGTOrdItem [ Cardinality = parent, Inverse = ChildDHCPEPreGTOrdItemTarItem, Required, SqlFieldName = PGTOIT_ParRef ];

/// PGTOIT_TarItemDR
Property PGTOITTarItemDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = PGTOIT_TarItemDR ];

/// PGTOIT_Qty
Property PGTOITQty As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = PGTOIT_Qty ];

/// PGTOIT_Price
Property PGTOITPrice As %Library.Numeric [ SqlColumnNumber = 5, SqlFieldName = PGTOIT_Price ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PGTOIT_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGTOIT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGTOIT_TarItemDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>{DHC_PE_PreGADM.PGADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Team"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PE_PreGTeam.PGT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ORDITEM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_PreGTOrdItem.PGTOI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarItem"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PGTOIT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreGTOrdItemTarItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
