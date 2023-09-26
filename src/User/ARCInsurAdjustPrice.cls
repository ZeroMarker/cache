/// ARC Insurance Adjustment Price(1411
Class User.ARCInsurAdjustPrice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_InsurAdjustPrice, StorageStrategy = SQLStorage ]
{

/// % Adjustment
Property IAPAdjust As %Float(MAXVAL = 100, MINVAL = -100) [ Required, SqlColumnNumber = 6, SqlFieldName = IAP_Adjust ];

/// Des Ref BillGrp
Property IAPBillGrpDR As ARCBillGrp [ SqlColumnNumber = 5, SqlFieldName = IAP_BillGrp_DR ];

/// Date From
Property IAPDateFrom As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = IAP_DateFrom ];

/// DateTo
Property IAPDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = IAP_DateTo ];

/// Des Ref InsType
Property IAPInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = IAP_InsType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsurAdjustPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAdjustPrice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsurAdjustPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAdjustPrice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsurAdjustPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAdjustPrice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsurAdjustPrice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAdjustPrice","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsurAdjustPrice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAdjustPrice","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("IAP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IAP_Adjust">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IAP_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IAP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IAP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IAP_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IAP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IAP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IAP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>IAP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IAP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IAP_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IAP_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IAP_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{IAP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IAP_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsurAdjustPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
