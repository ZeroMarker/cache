/// PA Referral Doctor(1588)
Class User.PAReferralDoctor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ReferralDoctor, StorageStrategy = SQLStorage ]
{

/// Childsub
Property REFDChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REFD",0))}, SqlColumnNumber = 2, SqlFieldName = REFD_Childsub ];

/// Date From
Property REFDDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = REFD_DateFrom ];

/// Date To
Property REFDDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = REFD_DateTo ];

/// PA_PatMas Parent Reference
Relationship REFDParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAReferralDoctor, Required, SqlFieldName = REFD_ParRef ];

/// Des Ref RefDoc
Property REFDRefDocDR As PACRefDoctor [ SqlColumnNumber = 5, SqlFieldName = REFD_RefDoc_DR ];

Index RowIDBasedIDKeyIndex On REFDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 57;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAReferralDoctor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAReferralDoctor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAReferralDoctor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAReferralDoctor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAReferralDoctor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAReferralDoctor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAReferralDoctor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAReferralDoctor","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAReferralDoctor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAReferralDoctor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>57</ExtentSize>
<Property name="REFDChildsub">
<Selectivity>1</Selectivity>
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
<Property name="REFDRefDocDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="REFD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REFD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REFD_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REFD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
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
<SQLMap name="IndexDate">
<Global>^PAPER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>REFD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REFD_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REFD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REFD_RowId</SqlRowIdName>
<StreamLocation>^User.PAReferralDoctorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
