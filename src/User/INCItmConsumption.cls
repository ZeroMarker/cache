/// INC Item Consumption(1387)
Class User.INCItmConsumption Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmConsumption, StorageStrategy = SQLStorage ]
{

/// Amount
Property CONSAmount As %Float [ SqlColumnNumber = 6, SqlFieldName = CONS_Amount ];

/// Month
Property CONSMonth As %Float [ SqlColumnNumber = 3, SqlFieldName = CONS_Month ];

/// INC_Itm Parent Reference
Relationship CONSParRef As INCItm [ Cardinality = parent, Inverse = ChildINCItmConsumption, Required, SqlFieldName = CONS_ParRef ];

/// Qty
Property CONSQty As %Float [ SqlColumnNumber = 5, SqlFieldName = CONS_Qty ];

/// Type
Property CONSType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CONS_Type ];

/// Year
Property CONSYear As %Float [ SqlColumnNumber = 2, SqlFieldName = CONS_Year ];

Index RowIDBasedIDKeyIndex On (CONSType, CONSYear, CONSMonth) [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 113;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmConsumption).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmConsumption","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmConsumption).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmConsumption","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmConsumption).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmConsumption","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmConsumption).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmConsumption","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmConsumption).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INCItmConsumption","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>113</ExtentSize>
<Property name="CONSAmount">
<Selectivity>2.7778%</Selectivity>
</Property>
<Property name="CONSMonth">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="CONSParRef">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="CONSQty">
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="CONSType">
<Selectivity>2.9412%</Selectivity>
</Property>
<Property name="CONSYear">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CONS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONS_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CONS_Type</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>CONS_Year</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>CONS_Month</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CONS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONS_Year}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CONS_Month}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONS_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmConsumptionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
