/// AR Outstanding Payment(1306)
Class User.AROutstandPayment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_OutstandPayment, StorageStrategy = SQLStorage ]
{

/// Des Ref ARPBL
Property OUTPARPBLDR As ARPatientBill [ SqlColumnNumber = 4, SqlFieldName = OUTP_ARPBL_DR ];

/// Des Ref to PAADM
Property OUTPCurrAdmDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = OUTP_CurrAdm_DR ];

/// Des Ref to PAADM
Property OUTPPayAdmDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = OUTP_PayAdm_DR ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.AROutstandPayment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.AROutstandPayment","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.AROutstandPayment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.AROutstandPayment","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.AROutstandPayment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.AROutstandPayment","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.AROutstandPayment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.AROutstandPayment","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.AROutstandPayment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.AROutstandPayment","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="OUTPARPBLDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OUTPCurrAdmDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OUTPPayAdmDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^AR("OUTP",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="OUTP_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OUTP_CurrAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OUTP_PayAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OUTP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OUTP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBill">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OUTP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARPBL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OUTP_ARPBL_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OUTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCurrAdm">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OUTP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CurrAdm"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OUTP_CurrAdm_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OUTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OUTP_RowId</SqlRowIdName>
<StreamLocation>^User.AROutstandPaymentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
