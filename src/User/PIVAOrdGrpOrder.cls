Class User.PIVAOrdGrpOrder Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POGO_RowID, SqlTableName = PIVA_OrdGrpOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On POGOChildSub [ IdKey, PrimaryKey, Unique ];

/// PIVA_OrdGrp Parent Reference
Relationship POGOPOGParref As User.PIVAOrdGrp [ Cardinality = parent, Inverse = ChildPIVAOrdGrpOrder, Required, SqlFieldName = POGO_POG_Parref ];

/// POGI_ChildSub
Property POGOChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = POGO_ChildSub ];

/// POGO_OEORI_Dr
Property POGOOEORIDr As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = POGO_OEORI_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="POGO_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POGO_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOeori">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>POGO_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POGO_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POGO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrdGrpOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
