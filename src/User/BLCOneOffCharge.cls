/// BLC One Off Charges(1196)
Class User.BLCOneOffCharge Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_OneOffCharge, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ONEOFFARCIMDR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ONEOFF_ARCIM_DR ];

/// Date From
Property ONEOFFDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = ONEOFF_DateFrom ];

/// Date To
Property ONEOFFDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = ONEOFF_DateTo ];

/// Name
Property ONEOFFName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ONEOFF_Name ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCOneOffCharge).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCOneOffCharge","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCOneOffCharge).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCOneOffCharge","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCOneOffCharge).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCOneOffCharge","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCOneOffCharge).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCOneOffCharge","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCOneOffCharge).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCOneOffCharge","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ONEOFFARCIMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ONEOFFDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ONEOFFDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ONEOFFName">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("ONEOFF",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ONEOFF_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ONEOFF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ONEOFF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ONEOFF_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ONEOFF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ONEOFF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ONEOFF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ONEOFF_RowId</SqlRowIdName>
<StreamLocation>^User.BLCOneOffChargeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
