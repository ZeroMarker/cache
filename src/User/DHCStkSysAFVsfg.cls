Class User.DHCStkSysAFVsfg Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSAFV_RowID, SqlTableName = DHC_StkSysAFVsfg, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000;

Index RowIDBasedIDKeyIndex On SSAFVChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCStkSysAFVProp As User.DHCStkSysAFVProp [ Cardinality = children, Inverse = SSAFVPSSAFVParref ];

/// DHC_StkSysAFrm Parent Reference
Relationship SSAFVSSAFParref As User.DHCStkSysAFrm [ Cardinality = parent, Inverse = ChildDHCStkSysAFVsfg, Required, SqlFieldName = SSAFV_SSAF_Parref ];

/// SSAFV_ChildSub
Property SSAFVChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SSAFV_ChildSub ];

/// SSAFV_Code
Property SSAFVCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SSAFV_Code ];

/// SSAFV_Desc
Property SSAFVDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSAFV_Desc ];

Storage SQLStorage
{
<ExtentSize>1000</ExtentSize>
<SQLMap name="DataMasterSSAFV">
<Data name="SSAFV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSAFV_Desc">
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
<Field>DHC_StkSysAFrm.SSAF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SSAFV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_StkSysAFrm.SSAF_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"FV"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSAFV_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVSCode">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_StkSysAFrm.SSAF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SSAFV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AFVCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_StkSysAFrm.SSAF_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SSAFV_Code})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SSAFV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVSDesc">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_StkSysAFrm.SSAF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SSAFV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AFVDESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkSysAFrm.SSAF_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SSAFV_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SSAFV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysAFVsfgS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
