/// Patient Counters        (PCNT,5006)
Class User.PACPatCnt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_PatCnt, StorageStrategy = SQLStorage ]
{

/// Anaesthesia Counter
Property PCNTAnaestCnt As %Float [ SqlColumnNumber = 9, SqlFieldName = PCNT_AnaestCnt ];

/// In Patient Counter
Property PCNTIPCnt As %Float [ SqlColumnNumber = 2, SqlFieldName = PCNT_IPCnt ];

/// Out Patient Counter
Property PCNTOPCnt As %Float [ SqlColumnNumber = 3, SqlFieldName = PCNT_OPCnt ];

/// Operation Counter
Property PCNTOperCnt As %Float [ SqlColumnNumber = 10, SqlFieldName = PCNT_OperCnt ];

/// QUE1 Counter
Property PCNTQUE1Cnt As %Float [ SqlColumnNumber = 8, SqlFieldName = PCNT_QUE1Cnt ];

/// PA_PatCnt Row ID
Property PCNTRowID As %Float [ Required, SqlFieldName = PCNT_RowID ];

Index RowIDBasedIDKeyIndex On PCNTRowID [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACPatCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACPatCnt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACPatCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACPatCnt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACPatCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACPatCnt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACPatCnt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACPatCnt","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACPatCnt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACPatCnt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PCNTAnaestCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="PCNTIPCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="PCNTOPCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="PCNTOperCnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="PCNTQUE1Cnt">
<Selectivity>1</Selectivity>
</Property>
<Property name="PCNTRowID">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMapPCNT">
<Data name="PCNT_AnaestCnt">
<Node>"ANA"</Node>
</Data>
<Data name="PCNT_IPCnt">
<Node>"I"</Node>
</Data>
<Data name="PCNT_OPCnt">
<Node>"O"</Node>
</Data>
<Data name="PCNT_OperCnt">
<Node>"OPER"</Node>
</Data>
<Data name="PCNT_QUE1Cnt">
<Node>"Q1"</Node>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCNT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PCNT_RowID}</Expression>
<StartValue>0</StartValue>
<StopValue>0</StopValue>
</Subscript>
<Subscript name="2">
<Expression>"CNT"</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PCNT_RowID</SqlRowIdName>
<StreamLocation>^User.PACPatCntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
