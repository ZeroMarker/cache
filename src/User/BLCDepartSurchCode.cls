/// BLC Depart Surcharge Code(1195)
Class User.BLCDepartSurchCode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_DepartSurchCode, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property DEPSCCTLOCDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = DEPSC_CTLOC_DR ];

/// Date From
Property DEPSCDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DEPSC_DateFrom ];

/// Date To
Property DEPSCDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DEPSC_DateTo ];

/// Fixed Amt
Property DEPSCFixedAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = DEPSC_FixedAmt ];

/// % Charge
Property DEPSCPerc As %Float [ SqlColumnNumber = 5, SqlFieldName = DEPSC_Perc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCDepartSurchCode).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCDepartSurchCode","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCDepartSurchCode).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCDepartSurchCode","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCDepartSurchCode).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCDepartSurchCode","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCDepartSurchCode).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCDepartSurchCode","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCDepartSurchCode).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCDepartSurchCode","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="DEPSCCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEPSCDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEPSCDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEPSCFixedAmt">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEPSCPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("DEPSC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DEPSC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEPSC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEPSC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEPSC_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEPSC_Perc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DEPSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEPSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEPSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DEPSC_RowId</SqlRowIdName>
<StreamLocation>^User.BLCDepartSurchCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
