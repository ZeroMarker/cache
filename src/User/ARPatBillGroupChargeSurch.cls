/// AR PatBillGroupCharge Surchar(1286)
Class User.ARPatBillGroupChargeSurch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillGroupChargeSurch, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SURChildsub As %Float [ InitialExpression = {$i(^ARPBL($p(%d(0),"||"),"BGRP",$p(%d(0),"||",2),"ITM",$p(%d(0),"||",3),"SUR",0))}, SqlColumnNumber = 2, SqlFieldName = SUR_Childsub ];

/// Description
Property SURDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SUR_Desc ];

/// Govt Share
Property SURGovtShare As %Float [ SqlColumnNumber = 12, SqlFieldName = SUR_GovtShare ];

/// Handicapped Assoc Share
Property SURHandicappedAssocShare As %Float [ SqlColumnNumber = 13, SqlFieldName = SUR_HandicappedAssocShare ];

/// Ins Co Share
Property SURInsCoShare As %Float [ SqlColumnNumber = 11, SqlFieldName = SUR_InsCoShare ];

/// No of Days
Property SURNoDays As %Float [ SqlColumnNumber = 5, SqlFieldName = SUR_NoDays ];

/// AR_PatBillGroupCharges Parent Reference
Relationship SURParRef As ARPatBillGroupCharges [ Cardinality = parent, Inverse = ChildARPatBillGroupChargeSurch, Required, SqlFieldName = SUR_ParRef ];

/// Patient Share
Property SURPatientShare As %Float [ SqlColumnNumber = 10, SqlFieldName = SUR_PatientShare ];

/// Qty/Day
Property SURQtyDay As %Float [ SqlColumnNumber = 4, SqlFieldName = SUR_QtyDay ];

/// Surcharge Discount Type
Property SURSurchDiscountType As %Float [ SqlColumnNumber = 7, SqlFieldName = SUR_SurchDiscountType ];

/// Des Ref to Surcharge Code
Property SURSurchargeDR As ARCSurchargeCode [ SqlColumnNumber = 3, SqlFieldName = SUR_Surcharge_DR ];

/// Total Amt
Property SURTotalAmt As %Float [ SqlColumnNumber = 9, SqlComputeCode = { s {SUR_TotalAmt}={SUR_NoDays}*{SUR_QtyDay}*{SUR_UnitPrice}
}, SqlComputed, SqlFieldName = SUR_TotalAmt, Transient ];

/// Unit Price
Property SURUnitPrice As %Float [ SqlColumnNumber = 8, SqlFieldName = SUR_UnitPrice ];

Index RowIDBasedIDKeyIndex On SURChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroupChargeSurch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillGroupChargeSurch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroupChargeSurch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillGroupChargeSurch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroupChargeSurch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillGroupChargeSurch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillGroupChargeSurch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillGroupChargeSurch","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillGroupChargeSurch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillGroupChargeSurch","OnBeforeUpdate")
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
<Data name="SUR_HandicappedAssocShare">
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
<Data name="SUR_Surcharge_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUR_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SUR_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>AR_PatBillGroupCharges.ITM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillGroupCharges.ITM_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"SUR"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUR_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillGroupChargeSurchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
