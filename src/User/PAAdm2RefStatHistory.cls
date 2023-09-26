/// Adm2RefStatHistory(2498)
Class User.PAAdm2RefStatHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2RefStatHistory, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REFHISChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm2 Parent Reference
Relationship REFHISParRef As PAAdm2 [ Cardinality = parent, Inverse = ChildPAAdm2RefStatHistory, Required, SqlFieldName = REFHIS_ParRef ];

/// Childsub
Property REFHISChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REFHIS",0))}, SqlColumnNumber = 2, SqlFieldName = REFHIS_Childsub ];

/// Date
Property REFHISDate As %Date [ SqlColumnNumber = 3, SqlFieldName = REFHIS_Date ];

/// Time
Property REFHISTime As %Time [ SqlColumnNumber = 4, SqlFieldName = REFHIS_Time ];

/// Des Ref ReferralStatus
Property REFHISReferralStatusDR As PACReferralStatus [ SqlColumnNumber = 5, SqlFieldName = REFHIS_ReferralStatus_DR ];

/// Des Ref ReferralPriority
Property REFHISReferralPriorityDR As PACReferralPriority [ SqlColumnNumber = 6, SqlFieldName = REFHIS_ReferralPriority_DR ];

/// Des Ref UserUpdated
Property REFHISUserUpdatedDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = REFHIS_UserUpdated_DR ];

/// DateUpdated
Property REFHISDateUpdated As %Date [ SqlColumnNumber = 8, SqlFieldName = REFHIS_DateUpdated ];

/// Time Updated
Property REFHISTimeUpdated As %Time [ SqlColumnNumber = 9, SqlFieldName = REFHIS_TimeUpdated ];

/// Des Ref CTHospital
Property REFHISHospitalUpdatedDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = REFHIS_HospitalUpdated_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdm2RefStatHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2RefStatHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdm2RefStatHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2RefStatHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdm2RefStatHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2RefStatHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdm2RefStatHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2RefStatHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdm2RefStatHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2RefStatHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="REFHIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REFHIS_DateUpdated">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REFHIS_HospitalUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REFHIS_ReferralPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REFHIS_ReferralStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REFHIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REFHIS_TimeUpdated">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REFHIS_UserUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REFHIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REFHIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REFHIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REFHIS_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2RefStatHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
