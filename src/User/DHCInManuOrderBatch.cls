Class User.DHCInManuOrderBatch Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MOBAT_RowID, SqlTableName = DHC_InManuOrder_Batch, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MOBATChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_InManuOrder_Batch Parent Reference
Relationship MOBATParRef As User.DHCInManuOrder [ Cardinality = parent, Inverse = ChildDHCInManuOrderBatch, Required, SqlFieldName = MOBAT_ParRef ];

/// MOBAT_Childsub
Property MOBATChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MOBAT_Childsub ];

/// MOBAT_Inclb_Dr
Property MOBATInclbDr As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = MOBAT_Inclb_Dr ];

/// MOBAT_CtUom_Dr
Property MOBATCtUomDr As User.CTUOM [ SqlColumnNumber = 4, SqlFieldName = MOBAT_CtUom_Dr ];

/// MOBAT_Qty
Property MOBATQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MOBAT_Qty ];

/// MOBAT_Sp
Property MOBATSp As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MOBAT_Sp ];

/// MOBAT_SpAmount
Property MOBATSpAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = MOBAT_SpAmount ];

/// MOBAT_BuomQty
Property MOBATBuomQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = MOBAT_BuomQty ];

/// MOBAT_Rp
Property MOBATRp As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = MOBAT_Rp ];

/// MOBAT_RpAmount
Property MOBATRpAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = MOBAT_RpAmount ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="MOBAT_BuomQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MOBAT_CtUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MOBAT_Inclb_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MOBAT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MOBAT_Rp">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MOBAT_RpAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MOBAT_Sp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MOBAT_SpAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InManuOrder.INMAN_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MOBAT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_InManuOrder.INMAN_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MOBAT_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrderInci">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_InManuOrder.INMAN_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MOBAT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_InManuOrder.INMAN_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{MOBAT_Inclb_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MOBAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MOBAT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCInManuOrderBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
