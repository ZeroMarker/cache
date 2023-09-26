/// RTC MRecord Parts(1144)
Class User.RTCMRecordParts Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_MRecordParts, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property PARTCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = PART_CTLOC_DR ];

/// Code
Property PARTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PART_Code ];

/// Description
Property PARTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PART_Desc ];

Index PARTCodeUnqIdx1 On PARTCode [ Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCMRecordParts).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordParts","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCMRecordParts).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordParts","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCMRecordParts).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordParts","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCMRecordParts).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordParts","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCMRecordParts).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTCMRecordParts","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PARTCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PARTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PARTDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^RTC("PART",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PART_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PART_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PART_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PART_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PART"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PART_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PART_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PART"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PART_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PART_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PART_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PART"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PART_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PART_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PART_RowId</SqlRowIdName>
<StreamLocation>^User.RTCMRecordPartsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
