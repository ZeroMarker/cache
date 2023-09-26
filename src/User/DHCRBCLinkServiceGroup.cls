Class User.DHCRBCLinkServiceGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLSG_ROWID, SqlTableName = DHCRBC_LinkServiceGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DDLSG_GroupID
Property DLSGGroupID As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DLSG_GroupID ];

/// DLSG_ServiceGroupID
Property DLSGServiceGroupID As User.RBCServiceGroup [ SqlColumnNumber = 3, SqlFieldName = DLSG_ServiceGroupID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCLinkServiceGroup("LinkGroup"))</SqlIdExpression>
<SQLMap name="IndexServericeGroup">
<Global>^DHCRBCLinkServiceGroupi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLSG_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Index-ServiceGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLSG_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLSG_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DLSG_GroupID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLSG_ServiceGroupID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCLinkServiceGroup</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DLSG_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LinkGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLSG_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLinkServiceGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
