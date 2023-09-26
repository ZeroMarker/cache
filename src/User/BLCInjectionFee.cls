/// BLC Injection Fee(1199)
Class User.BLCInjectionFee Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_InjectionFee, StorageStrategy = SQLStorage ]
{

/// Des Ref BillSubGr
Property INFEEBillSubGrDR As ARCBillSub [ SqlColumnNumber = 6, SqlFieldName = INFEE_BillSubGr_DR ];

/// Date From
Property INFEEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = INFEE_DateFrom ];

/// Date To
Property INFEEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = INFEE_DateTo ];

/// Des REf InsType_DR
Property INFEEInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 2, SqlFieldName = INFEE_InsType_DR ];

/// MaxNumberToPay
Property INFEEMaxNumberToPay As %Float [ SqlColumnNumber = 7, SqlFieldName = INFEE_MaxNumberToPay ];

/// Patient Type
Property INFEEPatientType As %String(DISPLAYLIST = ",In Patient,Out Patient", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 5, SqlFieldName = INFEE_PatientType ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCInjectionFee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCInjectionFee","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCInjectionFee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCInjectionFee","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCInjectionFee).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCInjectionFee","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCInjectionFee).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCInjectionFee","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCInjectionFee).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCInjectionFee","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="INFEEBillSubGrDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INFEEDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INFEEDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INFEEInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INFEEMaxNumberToPay">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INFEEPatientType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("INFEE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INFEE_BillSubGr_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INFEE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INFEE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INFEE_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INFEE_MaxNumberToPay">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INFEE_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INFEE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INFEE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INFEE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INFEE_RowId</SqlRowIdName>
<StreamLocation>^User.BLCInjectionFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
