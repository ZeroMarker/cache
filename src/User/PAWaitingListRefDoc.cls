/// WaitingListRefDoc(2129)
Class User.PAWaitingListRefDoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListRefDoc, StorageStrategy = SQLStorage ]
{

/// Childsub
Property REFDChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REFD",0))}, SqlColumnNumber = 2, SqlFieldName = REFD_Childsub ];

/// Consent
Property REFDConsent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = REFD_Consent ];

/// Date From
Property REFDDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = REFD_DateFrom ];

/// Date To
Property REFDDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = REFD_DateTo ];

/// PA_WaitingList Parent Reference
Relationship REFDParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListRefDoc, Required, SqlFieldName = REFD_ParRef ];

/// Des Ref RefDocClinic
Property REFDRefDocClinicDR As PACRefDoctorClinic [ SqlColumnNumber = 6, SqlFieldName = REFD_RefDocClinic_DR ];

/// Des Ref RefDoc
Property REFDRefDocDR As PACRefDoctor [ SqlColumnNumber = 5, SqlFieldName = REFD_RefDoc_DR ];

Index RowIDBasedIDKeyIndex On REFDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 45;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAWaitingListRefDoc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRefDoc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAWaitingListRefDoc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRefDoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAWaitingListRefDoc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRefDoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAWaitingListRefDoc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRefDoc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAWaitingListRefDoc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRefDoc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>45</ExtentSize>
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
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REFD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
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
<StreamLocation>^User.PAWaitingListRefDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
