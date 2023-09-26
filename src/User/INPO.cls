/// IN Purchase Order(1091)
Class User.INPO Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = IN_PO, StorageStrategy = SQLStorage ]
{

Relationship ChildINPOItm As INPOItm [ Cardinality = children, Inverse = INPO ];

/// Purchase Order No
Property INPONo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ InitialExpression = "0", Required, SqlColumnNumber = 2, SqlFieldName = INPO_No ];

/// Des Ref to APCVM
Property INPOAPCVMDR As APCVendor [ Required, SqlColumnNumber = 3, SqlFieldName = INPO_APCVM_DR ];

/// Date of Purchase Order
Property INPODate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 4, SqlFieldName = INPO_Date ];

/// Des Ref to CTCUR
Property INPOCTCURDR As CTCurrency [ Required, SqlColumnNumber = 5, SqlFieldName = INPO_CTCUR_DR ];

/// Exchange Rate
Property INPOExRate As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 6, SqlComputeCode = { s {INPO_ExRate}=$s({INPO_Date}="":"",{INPO_CTCUR_DR}="":"",1:($$COFO06^at1091({INPO_Date},{INPO_CTCUR_DR},{INPO_ExRate})))
}, SqlComputed, SqlComputeOnChange = (INPODate, INPOCTCURDR), SqlFieldName = INPO_ExRate ];

/// Handling Charges
Property INPOHandChg As %Float(MAXVAL = 99999999, MINVAL = 0) [ InitialExpression = 0.00, Required, SqlColumnNumber = 7, SqlFieldName = INPO_HandChg ];

/// Des Ref to SSUSR
Property INPOSSUSRDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",1))}, SqlColumnNumber = 8, SqlFieldName = INPO_SSUSR_DR ];

/// Remarks
Property INPORemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = INPO_Remarks, SqlListType = SUBNODE ];

/// PO Approved
Property INPOApproved As %String(DISPLAYLIST = ",Yes,No,Partialy", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",Y,N,P") [ SqlColumnNumber = 10, SqlFieldName = INPO_Approved ];

/// PO Completed
Property INPOCompleted As %String(DISPLAYLIST = ",Yes,No,Partialy", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",Y,N,P") [ SqlColumnNumber = 11, SqlFieldName = INPO_Completed ];

/// Des Ref to INPO_Reference
Property INPOReferenceDR As INCPOReference [ SqlColumnNumber = 12, SqlFieldName = INPO_Reference_DR ];

/// TransDate
Property INPOTransDate As %Date [ SqlColumnNumber = 13, SqlFieldName = INPO_TransDate ];

/// TransTime
Property INPOTransTime As %Time [ SqlColumnNumber = 14, SqlFieldName = INPO_TransTime ];

/// DateNeeded
Property INPODateNeeded As %Date [ SqlColumnNumber = 15, SqlFieldName = INPO_DateNeeded ];

/// User Completed
Property INPOUserCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INPO_UserCompleted ];

/// Des Ref User
Property INPOUserCompletedDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = INPO_UserCompleted_DR ];

/// Des Ref CreditTerm
Property INPOCreditTermDR As INCCreditTerms [ SqlColumnNumber = 18, SqlFieldName = INPO_CreditTerm_DR ];

/// User Last Updated
Property INPOUserUpdatedDR As SSUser [ SqlColumnNumber = 19, SqlFieldName = INPO_UserUpdated_DR ];

/// Cancelled
Property INPOCancelled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = INPO_Cancelled ];

/// FullFilled
Property INPOFullFilled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INPO_FullFilled ];

/// Des Ref UserCancFullFilled
Property INPOUserCancFullFilledDR As SSUser [ SqlColumnNumber = 22, SqlFieldName = INPO_UserCancFullFilled_DR ];

/// DateCancelFullFilled
Property INPODateCancelFullFilled As %Date [ SqlColumnNumber = 23, SqlFieldName = INPO_DateCancelFullFilled ];

/// TimeCancelFullFilled
Property INPOTimeCancelFullFilled As %Time [ SqlColumnNumber = 24, SqlFieldName = INPO_TimeCancelFullFilled ];

/// Des Ref ReasonCancFullFilled
Property INPOReasonCancFullFilledDR As INCPOCancFullFillReason [ SqlColumnNumber = 25, SqlFieldName = INPO_ReasonCancFullFilled_DR ];

Property INPOPlatSend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = INPO_PlatSend ];

/// 医共体子医院订单id
Property INPODHCMId As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INPO_DHCMId ];

/// 医共体主院订单ids
Property INPOMianDHCMId As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INPO_MianDHCMId ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INPO).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPO","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INPO).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPO","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INPO).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPO","OnBeforeDelete")
 d VALDEL^at1091
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INPO).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPO","OnBeforeUpdate")
 d VALUPD^at1091
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPO","OnBeforeInsert")
 //d VALINS^at1091
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INPO).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPO","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INPO(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INPO_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPO_Approved">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPO_CTCUR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPO_Cancelled">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INPO_Completed">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPO_CreditTerm_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPO_DHCMId">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INPO_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPO_DateCancelFullFilled">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INPO_DateNeeded">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPO_ExRate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPO_FullFilled">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INPO_HandChg">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPO_MianDHCMId">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INPO_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPO_PlatSend">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INPO_ReasonCancFullFilled_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INPO_Reference_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPO_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INPO_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPO_TimeCancelFullFilled">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INPO_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPO_TransTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPO_UserCancFullFilled_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INPO_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPO_UserCompleted_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INPO_UserUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^INPO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_PO}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproved">
<Condition>$$approve^at1091({INPO_Approved})=1</Condition>
<ConditionFields>INPO_Approved</ConditionFields>
<Global>^INPO</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Appr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPO_Approved}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCompleted">
<Condition>$$complete^at1091({INPO_Completed})=1</Condition>
<ConditionFields>INPO_Completed</ConditionFields>
<Global>^INPO</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Compl"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPO_Completed}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDHCMId">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HDCM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPO_DHCMId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPO_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateNeeded">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateNeed"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPO_DateNeeded}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INPO_No})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPO_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IN_PO</SqlRowIdName>
<StreamLocation>^User.INPOS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
