Class User.DHCPEPreIOrdItemTarItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIOIT_RowId, SqlTableName = DHC_PE_PreIOrdItemTarItem, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIOrdItemTarItem";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PIOITChildSub [ IdKey, PrimaryKey, Unique ];

/// PIOIT_ChildSub
Property PIOITChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreIADM(+%d(0),"ORDITEM",$p($p(%d(0),$c(1)),"||",2),"TarItem",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PIOIT_ChildSub ];

/// DHC_PE_PreIOrdItem Parent Reference
Relationship PIOITParRef As User.DHCPEPreIOrdItem [ Cardinality = parent, Inverse = ChildDHCPEPreIOrdItemTarItem, Required, SqlFieldName = PIOIT_ParRef ];

/// PIOIT_TarItemDR
Property PIOITTarItemDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = PIOIT_TarItemDR ];

/// PIOIT_Qty
Property PIOITQty As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = PIOIT_Qty ];

/// PIOIT_Price
Property PIOITPrice As %Library.Numeric [ SqlColumnNumber = 5, SqlFieldName = PIOIT_Price ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PIOIT_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIOIT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIOIT_TarItemDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEPreIADM</Global>
<Subscript name="1">
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PE_PreIOrdItem.PIOI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TarItem"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIOIT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIOrdItemTarItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
