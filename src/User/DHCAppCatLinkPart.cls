Class User.DHCAppCatLinkPart Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACLP_RowID, SqlTableName = DHC_AppCatLinkPart, StorageStrategy = SQLStorage ]
{

/// 主表ID ACLP_Cat_ParRef
Relationship ACLPCatParRef As User.DHCAppArcCat [ Cardinality = parent, Inverse = ChildDHCAPPCATLINKPART, Required, SqlFieldName = ACLP_Cat_ParRef ];

/// 子表Sub ACLP_ChildSub
Property ACLPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ACLP_ChildSub ];

/// 大部位 ACLP_Part_Dr
Property ACLPPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = ACLP_Part_Dr ];

Index RowIDBasedIDKeyIndex On ACLPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCAppCatLinkPart As User.DHCAppCatLinkSubPart [ Cardinality = children, Inverse = ACLPCatParRef ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexCatPart">
<Global>^DHCAPARCCA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>(L3)</Expression>
<Field>DHC_AppArcCat.AC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>(L5)</Expression>
<Field>ACLP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Part"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACLP_Part_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACLP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ACLP_Part_Dr">
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
<Field>ACLP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACLP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppCatLinkPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
