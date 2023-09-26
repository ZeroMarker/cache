Class User.DHCStkLocUserStkCat Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SUSC_RowId, SqlTableName = DHC_StkLocUserStkCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SUSCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkLocStkCat Parent Reference
Relationship SLSCSUSCParref As User.DHCStkLocStkCat [ Cardinality = parent, Inverse = ChildDHCStkLocUserStkCat, Required, SqlFieldName = SUSC_SLSC_Parref ];

/// SUSC_ChildSub
Property SUSCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SUSC_ChildSub ];

/// SUSC_SSUSR_DR
Property SUSCSSUSRDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SUSC_SSUSR_DR ];

/// SUSC_Active
Property SUSCActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SUSC_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexUser">
<Global>^DHCSLSC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkLocStkCat.SLSC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SUSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUSC_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkLocStkCat.SLSC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapData">
<Data name="SUSC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUSC_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSLSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkLocStkCat.SLSC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SUSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkLocStkCat.SLSC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SUSC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkLocUserStkCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
