Class User.DHCRBCResourceInAppLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRIL_RowID, SqlTableName = DHCRBC_ResourceInAppLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRIL_AppLoc_DR
Property DRILAppLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DRIL_AppLoc_DR ];

/// DRIL_ServiceGroup_DR
Property DRILServiceGroupDR As User.RBCServiceGroup [ SqlColumnNumber = 3, SqlFieldName = DRIL_ServiceGroup_DR ];

/// DRIL_Resource_DR
Property DRILResourceDR As User.RBResource [ SqlColumnNumber = 4, SqlFieldName = DRIL_Resource_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCResourceInAppLoc)</SqlIdExpression>
<SQLMap name="IndexAppLoc">
<Global>^DHCRBCResourceInAppLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APPLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRIL_AppLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRIL_Resource_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRIL_AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRIL_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRIL_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCResourceInAppLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRIL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCResourceInAppLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
