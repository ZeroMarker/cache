Class User.DHCPHAdvItm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHAI_RowID, SqlTableName = DHC_PHAdvItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHAIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdvice Parent Reference
Relationship PHAIPHAParref As User.DHCPHAdvice [ Cardinality = parent, Inverse = ChildDHCPHAdvItm, Required, SqlFieldName = PHAI_PHA_Parref ];

/// PHAI_ChildSub
Property PHAIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHAI_ChildSub ];

/// PHAI_OEORI_DR  用户
Property PHAIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = PHAI_OEORI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHAI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdvice.PHA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdvice.PHA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOeoriDR">
<Global>^DHCPHAD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHAdvice.PHA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHAdvice.PHA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdvItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
