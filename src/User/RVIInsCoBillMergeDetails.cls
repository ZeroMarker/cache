/// RVI InsCoBill Merge Details(1375)
Class User.RVIInsCoBillMergeDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCoBillMergeDetails, StorageStrategy = SQLStorage ]
{

/// Des Ref to ARCOS
Property MDARCOSDR As ARCOrdSets [ SqlColumnNumber = 4, SqlFieldName = MD_ARCOS_DR ];

/// Amt Received
Property MDAmtReceived As %Float [ SqlColumnNumber = 14, SqlFieldName = MD_AmtReceived ];

/// Charge Code
Property MDChargeCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MD_ChargeCode ];

/// Childsub
Property MDChildsub As %Float [ InitialExpression = {$i(^RVI($p(%d(0),$c(1)),"MD",0))}, SqlColumnNumber = 2, SqlFieldName = MD_Childsub ];

/// Cut Amt
Property MDCutAmt As %Float [ SqlColumnNumber = 19, SqlFieldName = MD_CutAmt ];

/// Cut Days
Property MDCutDays As %Float [ SqlColumnNumber = 12, SqlFieldName = MD_CutDays ];

/// Cut Qty
Property MDCutQty As %Float [ SqlColumnNumber = 11, SqlFieldName = MD_CutQty ];

/// Daily Qty
Property MDDailyQty As %Float [ SqlColumnNumber = 8, SqlFieldName = MD_DailyQty ];

/// Date
Property MDDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MD_Date ];

/// Days
Property MDDays As %Float [ SqlColumnNumber = 9, SqlFieldName = MD_Days ];

/// Ins Amount
Property MDInsAmount As %Float [ SqlColumnNumber = 10, SqlFieldName = MD_InsAmount ];

/// Merge Comment
Property MDMergeComment As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MD_MergeComment ];

/// Des Ref PAADM
Property MDPAADMDR As PAAdm [ SqlColumnNumber = 18, SqlFieldName = MD_PAADM_DR ];

/// RVI_InsCompanyBill Parent Reference
Relationship MDParRef As RVIInsCompanyBill [ Cardinality = parent, Inverse = ChildRVIInsCoBillMergeDetails, Required, SqlFieldName = MD_ParRef ];

/// Des Ref Reason For Cut
Property MDReasonForCutDR As RVCReasonCutNFMI [ SqlColumnNumber = 15, SqlFieldName = MD_ReasonForCut_DR ];

/// Reclaim Amt
Property MDReclaimAmt As %Float [ SqlColumnNumber = 13, SqlFieldName = MD_ReclaimAmt ];

/// Status
Property MDStatus As %String(DISPLAYLIST = ",Merged,Cut,Paid", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",M,C,P") [ SqlColumnNumber = 17, SqlFieldName = MD_Status ];

/// Des Ref to BillSubGroup
Property MDSubGroupDR As ARCBillSub [ SqlColumnNumber = 3, SqlFieldName = MD_SubGroup_DR ];

/// Unit Price
Property MDUnitPrice As %Float [ SqlColumnNumber = 7, SqlFieldName = MD_UnitPrice ];

Index RowIDBasedIDKeyIndex On MDChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillMergeDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillMergeDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillMergeDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillMergeDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillMergeDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillMergeDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCoBillMergeDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillMergeDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCoBillMergeDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillMergeDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="MD_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_AmtReceived">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MD_ChargeCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_CutAmt">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MD_CutDays">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MD_CutQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MD_DailyQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MD_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MD_Days">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MD_InsAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MD_MergeComment">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MD_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MD_ReasonForCut_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MD_ReclaimAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MD_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MD_SubGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MD_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCoBillMergeDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
