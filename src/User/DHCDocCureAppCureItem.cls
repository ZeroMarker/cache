/// 治疗申请单中治疗项目
Class User.DHCDocCureAppCureItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCAC_RowId, SqlTableName = DHC_DocCureAppCureItem, StorageStrategy = SQLStorge ]
{

Parameter EXTENTSIZE = 250;

/// Relationship ChildDHCDocCureAppArrive As User.DHCDocCureAppArrive [ Cardinality = children, Inverse = DCAAParRef ];
/// Relationship ChildDHCDocCureRecode As User.DHCDocCureRecode [ Cardinality = children, Inverse = DCRParRef ];
Index RowIDBasedIDKeyIndex On DCACChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DCACParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureAppCureItem, Required, SqlFieldName = DCAC_ParRef ];

/// DCAC_ChildSub
Property DCACChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure(+%d(0),"CureItem",0))}, SqlColumnNumber = 2, SqlFieldName = DCAC_ChildSub ];

/// DCAC_OEORI_DR  治疗项目医嘱ID
Property DCACOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DCAC_OEORI_DR ];

Storage SQLStorge
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCAC_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCAC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CureItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCureApp">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CureApp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAC_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocCureAppCureItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
