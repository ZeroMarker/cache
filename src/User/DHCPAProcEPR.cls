/// DHC_PA_ProcEPR
Class User.DHCPAProcEPR Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROCE_RowId, SqlTableName = DHC_PA_ProcEPR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PROCEChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PA_Process Parent Reference
Relationship PROCEParref As User.DHCPAProcess [ Cardinality = parent, Inverse = ChildDHCPAProcEPR, Required, SqlFieldName = PROCE_Parref ];

/// PROCE_ChildSub
Property PROCEChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCProc($p(%d(0),$c(1),1),"E",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PROCE_ChildSub ];

/// PROCE_EPRItem_DR
Property PROCEEPRItemDR As User.DHCPAProcCodeEPR [ SqlColumnNumber = 3, SqlFieldName = PROCE_EPRItem_DR ];

/// PROCE_Adm_DR
Property PROCEAdmDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROCE_Adm_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PROCE_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROCE_EPRItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCProc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PA_Process.PROC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PROCE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PA_Process.PROC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"E"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PROCE_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCProc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PA_Process.PROC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PROCE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EPRAdm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PROCE_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PROCE_Parref}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PROCE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcEPRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
