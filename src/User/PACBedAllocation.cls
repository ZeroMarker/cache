/// PAC Bed Allocation(1321)
Class User.PACBedAllocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BedAllocation, StorageStrategy = SQLStorage ]
{

/// Number of Beds
Property BALLBeds As %Float [ Required, SqlColumnNumber = 4, SqlFieldName = BALL_Beds ];

/// Des Ref to CTLOC
Property BALLCTLOCDR As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = BALL_CTLOC_DR ];

/// Date
Property BALLDate As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = BALL_Date ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACBedAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedAllocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACBedAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedAllocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACBedAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedAllocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACBedAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedAllocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACBedAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedAllocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("BALL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BALL_Beds">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BALL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BALL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BALL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BALL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BALL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BALL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BALL_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BALL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BALL_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedAllocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
