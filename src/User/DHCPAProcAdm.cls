/// DHC_PA_ProcAdm
Class User.DHCPAProcAdm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROCA_RowId, SqlTableName = DHC_PA_ProcAdm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On PROCAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PA_Process Parent Reference
Relationship PROCAParref As User.DHCPAProcess [ Cardinality = parent, Inverse = ChildDHCPAProcAdm, Required, SqlFieldName = PROCA_Parref ];

/// PROCA_ChildSub
Property PROCAChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCProc($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PROCA_ChildSub ];

/// PROCA_Adm_DR
Property PROCAAdmDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PROCA_Adm_DR ];

/// PROCA_UpdateDate
Property PROCAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PROCA_UpdateDate ];

/// PROCA_UpdateTime
Property PROCAUpdateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PROCA_UpdateTime ];

/// PROCA_UpdateUser_DR
Property PROCAUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PROCA_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PROCA_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROCA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROCA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROCA_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCProc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PA_Process.PROC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PROCA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PA_Process.PROC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PROCA_ChildSub}</Expression>
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
<Field>PROCA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROCA_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PA_Process.PROC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROCA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
