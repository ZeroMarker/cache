/// IP Medication Fee(1198)
Class User.BLCIPMedicatFee Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_IPMedicatFee, StorageStrategy = SQLStorage ]
{

/// Date From
Property IPMFEEDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = IPMFEE_DateFrom ];

/// Date To
Property IPMFEEDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = IPMFEE_DateTo ];

/// Fixed Amt
Property IPMFEEFixedAmt As %Float [ SqlColumnNumber = 3, SqlFieldName = IPMFEE_FixedAmt ];

/// Des Ref InsType_DR
Property IPMFEEInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 2, SqlFieldName = IPMFEE_InsType_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCIPMedicatFee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCIPMedicatFee","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCIPMedicatFee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCIPMedicatFee","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCIPMedicatFee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCIPMedicatFee","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCIPMedicatFee).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCIPMedicatFee","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCIPMedicatFee).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCIPMedicatFee","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="IPMFEEDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IPMFEEDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IPMFEEFixedAmt">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IPMFEEInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("IPMFEE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPMFEE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPMFEE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPMFEE_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPMFEE_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IPMFEE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPMFEE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMFEE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IPMFEE_RowId</SqlRowIdName>
<StreamLocation>^User.BLCIPMedicatFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
