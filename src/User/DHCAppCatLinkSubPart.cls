Class User.DHCAppCatLinkSubPart Extends %Persistent [ ProcedureBlock, SqlRowIdName = ACLSP_RowID, SqlTableName = DHC_AppCatLinkSubPart, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ACLPChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表ID DHC_AppCatLinkPart Parent Reference ACLP_Cat_ParRef
Relationship ACLPCatParRef As User.DHCAppCatLinkPart [ Cardinality = parent, Inverse = ChildDHCAppCatLinkPart, Required, SqlFieldName = ACLP_Cat_ParRef ];

/// 子表Sub ACLP_ChildSub
Property ACLPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ACLP_ChildSub ];

/// 子部位 ACLP_SubPart_Dr
Property ACLPSubPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = ACLP_SubPart_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="ACLP_SubPart_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppArcCat.AC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_AppCatLinkPart.ACLP_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ACLP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AppCatLinkPart.ACLP_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACLP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppCatLinkSubPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
