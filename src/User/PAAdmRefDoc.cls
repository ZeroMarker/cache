/// AdmRefDoc(2095)
Class User.PAAdmRefDoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmRefDoc, StorageStrategy = SQLStorage ]
{

/// Childsub
Property REFDChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REFD",0))}, SqlColumnNumber = 2, SqlFieldName = REFD_Childsub ];

/// Consent
Property REFDConsent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = REFD_Consent ];

/// Date From
Property REFDDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = REFD_DateFrom ];

/// DateTo
Property REFDDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = REFD_DateTo ];

/// PA_Adm Parent Reference
Relationship REFDParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmRefDoc, Required, SqlFieldName = REFD_ParRef ];

/// Des Ref RefDocClinic
Property REFDRefDocClinicDR As PACRefDoctorClinic [ SqlColumnNumber = 6, SqlFieldName = REFD_RefDocClinic_DR ];

/// Des Ref RefDoc
Property REFDRefDocDR As PACRefDoctor [ SqlColumnNumber = 5, SqlFieldName = REFD_RefDoc_DR ];

/// UpdateDate
Property REFDUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = REFD_UpdateDate ];

/// UpdateTime
Property REFDUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = REFD_UpdateTime ];

/// Des Ref UpdateUser
Property REFDUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = REFD_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property REFDUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = REFD_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On REFDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 86;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmRefDoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmRefDoc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmRefDoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmRefDoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmRefDoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmRefDoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmRefDoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmRefDoc","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmRefDoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmRefDoc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>86</ExtentSize>
<Property name="REFDChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDConsent">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="REFDDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDRefDocClinicDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDRefDocDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="REFDUpdateUserHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="REFD_Consent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REFD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REFD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REFD_RefDocClinic_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REFD_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REFD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REFD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REFD_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REFD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REFD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REFD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REFD_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmRefDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
