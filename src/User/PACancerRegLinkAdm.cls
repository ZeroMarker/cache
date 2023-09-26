/// Cancer Reg Link Adm(2228)
Class User.PACancerRegLinkAdm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CancerRegLinkAdm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADMChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_CancerReg Parent Reference
Relationship ADMParRef As PACancerReg [ Cardinality = parent, Inverse = ChildPACancerRegLinkAdm, Required, SqlFieldName = ADM_ParRef ];

/// Childsub
Property ADMChildsub As %Float [ InitialExpression = {$i(^PACR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ADM",0))}, SqlColumnNumber = 2, SqlFieldName = ADM_Childsub ];

/// Des Ref PAADM
Property ADMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = ADM_PAADM_DR ];

/// Des Ref Hospital
Property ADMHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = ADM_Hospital_DR ];

/// Des Ref AdmCoding
Property ADMAdmCodingDR As PAAdmCoding [ SqlColumnNumber = 5, SqlFieldName = ADM_AdmCoding_DR ];

/// Des Ref PAADM
Property ADMOPPAADMDR As PAAdm [ SqlColumnNumber = 6, SqlFieldName = ADM_OP_PAADM_DR ];

/// Des Ref Appointment
Property ADMAppointmentDR As RBAppointment [ SqlColumnNumber = 7, SqlFieldName = ADM_Appointment_DR ];

/// UpdateDate
Property ADMUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ADM_UpdateDate ];

/// UpdateTime
Property ADMUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = ADM_UpdateTime ];

/// Des Ref UpdateUser
Property ADMUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = ADM_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property ADMUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = ADM_UpdateUserHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACancerRegLinkAdm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerRegLinkAdm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACancerRegLinkAdm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerRegLinkAdm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACancerRegLinkAdm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerRegLinkAdm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACancerRegLinkAdm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerRegLinkAdm","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACancerRegLinkAdm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACancerRegLinkAdm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADM_AdmCoding_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADM_Appointment_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADM_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADM_OP_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADM_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PACR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_CancerReg.PACR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_CancerReg.PACR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexUpdDate">
<Global>^PACRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_CancerReg.PACR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMUpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADM_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_CancerReg.PACR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADM_RowId</SqlRowIdName>
<StreamLocation>^User.PACancerRegLinkAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
