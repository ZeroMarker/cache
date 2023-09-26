Class User.DHCCRMFUSLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SL_RowId, SqlTableName = DHC_CRM_FUSLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SLChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_CRM_FUSubject Parent Reference
Relationship SLParRef As User.DHCCRMFUSubject [ Cardinality = parent, Inverse = ChildDHCCRMFUSLoc, Required, SqlFieldName = SL_ParRef ];

Property SLChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCCRMFUS($p(%d(0),$c(1),1),"FUSL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SL_ChildSub ];

/// SL_ChildSub
/// 代码
Property SLCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = SL_Code ];

/// 名称
Property SLDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = SL_Desc ];

/// 科室
Property SLLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = SL_Loc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCCRMFUSL">
<Data name="SL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCRMFUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_CRM_FUSubject.FUS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_FUSubject.FUS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFUSLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
