Class User.DHCStkLocGrpItm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_StkLocGrpItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SLGIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCStkLocGroup Parent Reference
Relationship SLGISLGParref As DHCStkLocGroup [ Cardinality = parent, Inverse = ChildDHCStkLocGrpItm, Required, SqlFieldName = SLGI_SLG_Parref ];

/// SLGI_ChildSub
Property SLGIChildSub As %Float [ SqlColumnNumber = 2, SqlFieldName = SLGI_ChildSub ];

/// SLGI_Loc_DR
Property SLGILocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = SLGI_Loc_DR ];

/// SLGI_LocDesc
Property SLGILocDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SLGI_LocDesc ];

/// SLGI_Type
Property SLGIType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SLGI_Type ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexLoc">
<Global>^DHCSLG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkLocGroup.SLG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SLGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SLGI_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkLocGroup.SLG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SLGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SLGI_LocDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLGI_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLGI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSLG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkLocGroup.SLG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SLGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkLocGroup.SLG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SLGI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SLGI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStkLocGrpItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
