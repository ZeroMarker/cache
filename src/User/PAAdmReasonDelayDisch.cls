/// PA Adm Reason Delay Discharge(1956
Class User.PAAdmReasonDelayDisch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmReasonDelayDisch, StorageStrategy = SQLStorage ]
{

/// Childsub
Property READELChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"READEL",0))}, SqlColumnNumber = 2, SqlFieldName = READEL_Childsub ];

/// Date
Property READELDate As %Date [ SqlColumnNumber = 3, SqlFieldName = READEL_Date ];

/// PA_Adm Parent Reference
Relationship READELParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmReasonDelayDisch, Required, SqlFieldName = READEL_ParRef ];

/// Des Ref Reason
Property READELReasonDR As PACReasonDelayDischarge [ SqlColumnNumber = 5, SqlFieldName = READEL_Reason_DR ];

/// Time
Property READELTime As %Time [ SqlColumnNumber = 4, SqlFieldName = READEL_Time ];

/// UpdateDate
Property READELUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = READEL_UpdateDate ];

/// UpdateTime
Property READELUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = READEL_UpdateTime ];

/// Des Ref UpdateUser
Property READELUpdateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = READEL_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property READELUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = READEL_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On READELChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmReasonDelayDisch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReasonDelayDisch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmReasonDelayDisch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReasonDelayDisch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmReasonDelayDisch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReasonDelayDisch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmReasonDelayDisch).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReasonDelayDisch","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmReasonDelayDisch).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmReasonDelayDisch","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="READEL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="READEL_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="READEL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="READEL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="READEL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="READEL_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="READEL_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>READEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"READEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{READEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>READEL_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmReasonDelayDischS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
