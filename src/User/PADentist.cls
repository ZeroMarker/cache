/// PA Dentist(2130)
Class User.PADentist Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Dentist, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DENTChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DENT",0))}, SqlColumnNumber = 2, SqlFieldName = DENT_Childsub ];

/// Date From
Property DENTDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DENT_DateFrom ];

/// Date To
Property DENTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DENT_DateTo ];

/// PA_PatMas Parent Reference
Relationship DENTParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPADentist, Required, SqlFieldName = DENT_ParRef ];

/// Des Ref RefDocClinic
Property DENTRefDocClinicDR As PACRefDoctorClinic [ SqlColumnNumber = 6, SqlFieldName = DENT_RefDocClinic_DR ];

/// Des Ref RefDoc
Property DENTRefDocDR As PACRefDoctor [ SqlColumnNumber = 5, SqlFieldName = DENT_RefDoc_DR ];

/// Update Date
Property DENTUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DENT_UpdateDate ];

/// Des Ref UpdateHospital
Property DENTUpdateHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = DENT_UpdateHospital_DR ];

/// Update Time
Property DENTUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DENT_UpdateTime ];

/// Des Ref UpdateUser
Property DENTUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = DENT_UpdateUser_DR ];

Index RowIDBasedIDKeyIndex On DENTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 24;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADentist).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADentist","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADentist).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADentist","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADentist).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADentist","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADentist).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADentist","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADentist).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADentist","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>24</ExtentSize>
<Property name="DENTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTRefDocClinicDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTRefDocDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="DENTUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="DENT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DENT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DENT_RefDocClinic_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DENT_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DENT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DENT_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DENT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DENT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DENT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DENT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DENT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAPER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DENT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DENT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DENT_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DENT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DENT_RowId</SqlRowIdName>
<StreamLocation>^User.PADentistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
