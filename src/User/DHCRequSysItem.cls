Class User.DHCRequSysItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DHC_PBI_Rowid, SqlTableName = DHC_RequSysItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCPBIChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_RequSystem Parent Reference
Relationship DHCPBIParRef As User.DHCRequSystem [ Cardinality = parent, Inverse = ChildDHCRequSysItem, Required, SqlFieldName = DHC_PBI_ParRef ];

/// DHC_PBI_Childsub
Property DHCPBIChildsub As %Library.Numeric(MINVAL = 1, SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHC_PBI_Childsub ];

/// DHC_PBI_ARCIMDR
Property DHCPBIARCIMDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DHC_PBI_ARCIMDR ];

/// DHC_PBI_No
Property DHCPBINo As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHC_PBI_No ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DHC_PBI_ARCIMDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHC_PBI_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHC_PBI_No">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHC_PBI_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_PBI_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCREQSYS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_RequeType.REQType_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_RequSystem.DHC_PBP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_PBI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_RequeType.REQType_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_RequSystem.DHC_PBP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PBI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRequSysItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
