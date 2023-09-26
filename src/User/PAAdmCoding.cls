/// AdmCoding(2073)
Class User.PAAdmCoding Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PA_AdmCoding, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CODChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm Parent Reference
Relationship CODParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmCoding, Required, SqlFieldName = COD_ParRef ];

/// Childsub
Property CODChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),"COD",0)))}, SqlColumnNumber = 2, SqlFieldName = COD_Childsub ];

/// Start Date
Property CODStartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = COD_StartDate ];

/// Start Time
Property CODStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = COD_StartTime ];

/// End Date
Property CODEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = COD_EndDate ];

/// End Time
Property CODEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = COD_EndTime ];

/// Des Ref CareProv
Property CODCareProvDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = COD_CareProv_DR ];

/// Des Ref Bed
Property CODBedDR As PACBed [ SqlColumnNumber = 8, SqlFieldName = COD_Bed_DR ];

/// Des Ref CTLOC
Property CODCTLOCDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = COD_CTLOC_DR ];

/// Des Ref Transaction
Property CODTransactionDR As PAAdmTransaction [ SqlColumnNumber = 10, SqlFieldName = COD_Transaction_DR ];

/// Status
Property CODStatus As %String(DISPLAYLIST = ",NotCoded,PartiallyCoded,Complete,Grouped", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",N,P,C,G") [ SqlColumnNumber = 11, SqlFieldName = COD_Status ];

/// Validation Status
Property CODValidationStatus As %String(DISPLAYLIST = ",Awaiting validation,Errors found,Queries found,Queries and errors found,Ready to generate SMR record,SMR record submitted to ISD", MAXLEN = 28, TRUNCATE = 1, VALUELIST = ",A,E,Q,EQ,V,S") [ SqlColumnNumber = 12, SqlFieldName = COD_ValidationStatus ];

/// Des Ref Ward
Property CODWardDR As PACWard [ SqlColumnNumber = 13, SqlFieldName = COD_Ward_DR ];

Trigger PAAdmCodingafterinsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d insert^SSAUDIT(2073)
}

Trigger PAAdmCodingafterupdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
 d update^SSAUDIT(2073)
}

Trigger PAAdmCodingafterdelete [ Event = DELETE, Order = 1, Time = AFTER ]
{
 d delete^SSAUDIT(2073)
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="COD_Bed_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="COD_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="COD_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="COD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="COD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COD_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="COD_Transaction_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="COD_ValidationStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="COD_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCODLoc1">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODLoc1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{COD_EndTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodDoc1">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODDoc1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_CareProv_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{COD_EndTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodStat1">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODStat1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{COD_EndTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocStatus">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODDocStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COD_CareProv_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEndDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODEndDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{COD_EndTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocStat">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODLocStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COD_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexValStat">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODValStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_ValidationStatus}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{COD_EndTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexStatus">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>COD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COD_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{COD_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>COD_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmCodingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
