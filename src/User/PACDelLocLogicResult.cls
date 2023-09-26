/// PAC Deliv Loc Logic for result(1701
Class User.PACDelLocLogicResult Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DelLocLogicResult, StorageStrategy = SQLStorage ]
{

/// Date From
Property DELLOGDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = DELLOG_DateFrom ];

/// Date To
Property DELLOGDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = DELLOG_DateTo ];

/// Des Ref DeliveryLoc
Property DELLOGDeliveryLocDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = DELLOG_DeliveryLoc_DR ];

/// Des Ref CTLOC
Property DELLOGEpisLocDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = DELLOG_EpisLoc_DR ];

/// Des Ref InsType
Property DELLOGInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = DELLOG_InsType_DR ];

/// Des Ref CTLOC
Property DELLOGRecLocDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = DELLOG_RecLoc_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACDelLocLogicResult).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDelLocLogicResult","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACDelLocLogicResult).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDelLocLogicResult","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACDelLocLogicResult).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDelLocLogicResult","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACDelLocLogicResult).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDelLocLogicResult","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACDelLocLogicResult).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDelLocLogicResult","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("DELLOG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DELLOG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DELLOG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DELLOG_DeliveryLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DELLOG_EpisLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DELLOG_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DELLOG_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DELLOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DELLOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DELLOG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DELLOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DELLOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DELLOG_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DELLOG_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DELLOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DELLOG_RowId</SqlRowIdName>
<StreamLocation>^User.PACDelLocLogicResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
