Class User.DHCRequSystem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DHC_PBP_Rowid, SqlTableName = DHC_RequSystem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCPBPChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_RequeType Parent Reference
Relationship DHCPBPParRef As User.DHCRequeType [ Cardinality = parent, Inverse = ChildDHCRequSystem, Required, SqlFieldName = DHC_PBP_ParRef ];

Relationship ChildDHCRequSysItem As User.DHCRequSysItem [ Cardinality = children, Inverse = DHCPBIParRef ];

/// DHC_PBP_Childsub
Property DHCPBPChildsub As %Library.Numeric(MINVAL = 1, SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHC_PBP_Childsub ];

/// DHC_PBP_Desc
Property DHCPBPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHC_PBP_Desc ];

/// DHC_PBP_Flag
Property DHCPBPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHC_PBP_Flag ];

/// DHC_PBP_No
Property DHCPBPNo As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHC_PBP_No ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DHC_PBP_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHC_PBP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHC_PBP_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHC_PBP_No">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHC_PBP_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_PBP_Rowid">
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
<Field>DHC_PBP_Childsub</Field>
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
<Expression>{DHC_PBP_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRequSystemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
