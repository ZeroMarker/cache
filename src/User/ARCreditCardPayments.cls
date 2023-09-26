/// AR Credit card Payments(1771)
Class User.ARCreditCardPayments Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_CreditCardPayments, StorageStrategy = SQLStorage ]
{

/// Amount
Property CARDAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = CARD_Amount ];

/// Des Ref Card
Property CARDCardDR As ARCBankCardType [ SqlColumnNumber = 6, SqlFieldName = CARD_Card_DR ];

/// Date
Property CARDDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CARD_Date ];

/// Time
Property CARDTime As %Time [ SqlColumnNumber = 3, SqlFieldName = CARD_Time ];

/// Des Ref User
Property CARDUserDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = CARD_User_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCreditCardPayments).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCreditCardPayments","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCreditCardPayments).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCreditCardPayments","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCreditCardPayments).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCreditCardPayments","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCreditCardPayments).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCreditCardPayments","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCreditCardPayments).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCreditCardPayments","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="CARDAmount">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CARDCardDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CARDDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CARDTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CARDUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^AR("CARD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CARD_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CARD_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CARD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CARD_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CARD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CARD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CARD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CARD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CARD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CARD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CARD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CARD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CARD_RowId</SqlRowIdName>
<StreamLocation>^User.ARCreditCardPaymentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
