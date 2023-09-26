/// Admission Counters      (ACNT,5007)
Class User.PAAdmCnt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmCnt, StorageStrategy = SQLStorage ]
{

/// Emergency Counter
Property ACNTEMCnt As %Float [ SqlColumnNumber = 4, SqlFieldName = ACNT_EMCnt ];

/// In Patient Counter
Property ACNTIPCnt As %Float [ SqlColumnNumber = 2, SqlFieldName = ACNT_IPCnt ];

/// Out Patient Counter
Property ACNTOPCnt As %Float [ SqlColumnNumber = 3, SqlFieldName = ACNT_OPCnt ];

/// Pre Admission Counter
Property ACNTPACnt As %Float [ SqlColumnNumber = 11, SqlFieldName = ACNT_PACnt ];

/// PA_AdmCnt Row ID
Property ACNTRowID As %Float [ Required, SqlFieldName = ACNT_RowID ];

Index RowIDBasedIDKeyIndex On ACNTRowID [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCnt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCnt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCnt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmCnt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCnt","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmCnt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCnt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ACNTEMCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACNTIPCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACNTOPCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACNTPACnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACNTRowID">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="ACNT_EMCnt">
<Node>"E"</Node>
</Data>
<Data name="ACNT_IPCnt">
<Node>"I"</Node>
</Data>
<Data name="ACNT_OPCnt">
<Node>"O"</Node>
</Data>
<Data name="ACNT_PACnt">
<Node>"P"</Node>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACNT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ACNT_RowID}</Expression>
<StartValue>0</StartValue>
<StopValue>0</StopValue>
</Subscript>
<Subscript name="2">
<Expression>"CNT"</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ACNT_RowID</SqlRowIdName>
<StreamLocation>^User.PAAdmCntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
