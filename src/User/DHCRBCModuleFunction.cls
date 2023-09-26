Class User.DHCRBCModuleFunction Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRSF_RowID, SqlTableName = DHCRBC_Module_Function, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DRSFChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRBC_Module Parent Reference
Relationship DRSFParRef As User.DHCRBCModule [ Cardinality = parent, Inverse = ChildDHCRBCModuleFunction, Required, SqlFieldName = DRSF_ParRef ];

/// Child subscript
Property DRSFChildSub As %Library.Float [ InitialExpression = {$i(^DHCRBC("DHCRBCMODULEFUNCTION"))}, Required, SqlColumnNumber = 2, SqlFieldName = DRSF_ChildSub ];

/// DRSF_Code
Property DRSFCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRSF_Code ];

/// DRSF_Desc
Property DRSFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRSF_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DRSF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRSF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRBC_Module.DRM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DRSF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ModuleFunction"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRBC_Module.DRM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRSF_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCModuleFunctionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
