/// RVI InsCoBillCharge Surcharge(1280)
Class User.RVIInsCoBillChargesSurch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCoBillChargesSurch, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SURChildsub As %Float [ InitialExpression = {$i(^RVI($p(%d(0),"||"),"ITM",$p(%d(0),"||",2),"SUR",0))}, SqlColumnNumber = 2, SqlFieldName = SUR_Childsub ];

/// Description
Property SURDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SUR_Desc ];

/// Govt Share
Property SURGovtShare As %Float [ SqlColumnNumber = 12, SqlFieldName = SUR_GovtShare ];

/// Handicapped Share
Property SURHandicappedShare As %Float [ SqlColumnNumber = 13, SqlFieldName = SUR_HandicappedShare ];

/// Ins Co Share
Property SURInsCoShare As %Float [ SqlColumnNumber = 11, SqlFieldName = SUR_InsCoShare ];

/// No of Days
Property SURNoDays As %Float [ SqlColumnNumber = 5, SqlFieldName = SUR_NoDays ];

/// RVI_InsCoBillCharges Parent Reference
Relationship SURParRef As RVIInsCoBillCharges [ Cardinality = parent, Inverse = ChildRVIInsCoBillChargesSurch, Required, SqlFieldName = SUR_ParRef ];

/// Patient Share
Property SURPatientShare As %Float [ SqlColumnNumber = 10, SqlFieldName = SUR_PatientShare ];

/// Qty/Day
Property SURQtyDay As %Float [ SqlColumnNumber = 4, SqlFieldName = SUR_QtyDay ];

/// Surcharge Discount Type
Property SURSurchDiscountType As %Float [ SqlColumnNumber = 7, SqlFieldName = SUR_SurchDiscountType ];

/// Des Ref Surcharge Code
Property SURSurchargeCodeDR As ARCSurchargeCode [ SqlColumnNumber = 3, SqlFieldName = SUR_SurchargeCode_DR ];

/// Total Amt
Property SURTotalAmt As %Float [ SqlColumnNumber = 9, SqlComputeCode = { s {SUR_TotalAmt}={SUR_QtyDay}*{SUR_NoDays}*{SUR_UnitPrice}
}, SqlComputed, SqlFieldName = SUR_TotalAmt, Transient ];

/// Unit Price
Property SURUnitPrice As %Float [ SqlColumnNumber = 8, SqlFieldName = SUR_UnitPrice ];

Index RowIDBasedIDKeyIndex On SURChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillChargesSurch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillChargesSurch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillChargesSurch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillChargesSurch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillChargesSurch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillChargesSurch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCoBillChargesSurch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillChargesSurch","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCoBillChargesSurch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillChargesSurch","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SUR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUR_GovtShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUR_HandicappedShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SUR_InsCoShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUR_NoDays">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUR_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUR_QtyDay">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUR_SurchDiscountType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUR_SurchargeCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUR_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RVI_InsCoBillCharges.ITM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RVI_InsCoBillCharges.ITM_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SUR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUR_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCoBillChargesSurchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
