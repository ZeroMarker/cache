/// Forms Of Application
Class User.DHCStkSysAFrm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSAF_RowID, SqlTableName = DHC_StkSysAFrm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 500;

Index RowIDBasedIDKeyIndex On SSAFChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCStkSysAFVsfg As User.DHCStkSysAFVsfg [ Cardinality = children, Inverse = SSAFVSSAFParref ];

/// DHC_StkSysApp Parent Reference
Relationship SSAFSSAParref As User.DHCStkSysApp [ Cardinality = parent, Inverse = ChildDHCStkSysAFrm, Required, SqlFieldName = SSAF_SSA_Parref ];

/// Child Sub
Property SSAFChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SSAF_ChildSub ];

/// Form Code
Property SSAFCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SSAF_Code ];

/// Form Desc
Property SSAFDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSAF_Desc ];

Storage SQLStorage
{
<ExtentSize>500</ExtentSize>
<SQLMap name="DataMasterSSAF">
<Data name="SSAF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSAF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SSAF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSAF_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCodeApp">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSAF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AFCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SSAF_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSAF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescApp">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSAF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AFDESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SSAF_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSAF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysAFrmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
