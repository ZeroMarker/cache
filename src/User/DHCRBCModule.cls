Class User.DHCRBCModule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRM_RowID, SqlTableName = DHCRBC_Module, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBCModuleFunction As User.DHCRBCModuleFunction [ Cardinality = children, Inverse = DRSFParRef ];

/// DRM_Code
Property DRMCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRM_Code ];

/// DRM_Name
Property DRMName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRM_Name ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Module"))</SqlIdExpression>
<SQLMap name="MasterDataindex">
<Data name="DRM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRM_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Module"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCModuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
