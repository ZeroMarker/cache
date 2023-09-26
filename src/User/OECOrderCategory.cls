/// Order Category(ORCAT,1216)
Class User.OECOrderCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OEC_OrderCategory, StorageStrategy = SQLStorage ]
{

Relationship ChildOECOrdCatRecLoc As OECOrdCatRecLoc [ Cardinality = children, Inverse = RLParRef ];

Relationship ChildOECOrdCatQuestion As OECOrdCatQuestion [ Cardinality = children, Inverse = QUESParRef ];

Relationship ChildOECOrdCatPregnBrFdAlert As OECOrdCatPregnBrFdAlert [ Cardinality = children, Inverse = PBAParRef ];

/// Code
Property ORCATCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORCAT_Code ];

/// Description
Property ORCATDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORCAT_Desc ];

/// Repeat In Order
Property ORCATRepeatInOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 4, SqlFieldName = ORCAT_RepeatInOrder ];

/// Order Sequence No
Property ORCATOrderSeqNo As %Float [ SqlColumnNumber = 5, SqlFieldName = ORCAT_OrderSeqNo ];

/// Icon Name
Property ORCATIconName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ORCAT_IconName ];

/// Icon Priority
Property ORCATIconPriority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ORCAT_IconPriority ];

/// Des Ref Questionnaire
Property ORCATQuestionnaireDR As SSUserDefWindow [ SqlColumnNumber = 8, SqlFieldName = ORCAT_Questionnaire_DR ];

/// Hours Result Overdue
Property ORCATHrsResultOverdue As %Float [ SqlColumnNumber = 9, SqlFieldName = ORCAT_HrsResultOverdue ];

/// Icon to show Appointments made for order(s)
Property ORCATIconApptsMade As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ORCAT_IconApptsMade ];

/// Icon to show orders exceeded time ovdue resul
Property ORCATIconResultOverdue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ORCAT_IconResultOverdue ];

/// Counter Type DR
Property ORCATCounterTypeDR As PACCounterType [ SqlColumnNumber = 12, SqlFieldName = ORCAT_CounterTypeDR ];

/// Only Show Icon Before End Date
Property ORCATShowIconBeforeEndDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ORCAT_ShowIconBeforeEndDate ];

/// Don't Show Icon AfterExcecution
Property ORCATNoShowIconAfterExcecut As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ORCAT_NoShowIconAfterExcecut ];

/// Icon to Display After Execution
Property ORCATIconDisplayAfterExec As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORCAT_IconDisplayAfterExec ];

/// Des Ref OCGroup
Property ORCATOCGroupDR As OECOrderCategoryGroup [ SqlColumnNumber = 16, SqlFieldName = ORCAT_OCGroup_DR ];

/// PrescrExpDays
Property ORCATPrescrExpDays As %Float [ SqlColumnNumber = 17, SqlFieldName = ORCAT_PrescrExpDays ];

/// PrescrRepeatDays
Property ORCATPrescrRepeatDays As %Float [ SqlColumnNumber = 18, SqlFieldName = ORCAT_PrescrRepeatDays ];

/// IV Expiry
Property ORCATIVExpiry As %Float [ SqlColumnNumber = 19, SqlFieldName = ORCAT_IVExpiry ];

/// Do not D/C on Admission Discharge
Property ORCATDoNotDCOnAdmDisch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = ORCAT_DoNotDCOnAdmDisch ];

/// Do Not D/C on Admission Cancel
Property ORCATDoNotDCOnAdmCancel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = ORCAT_DoNotDCOnAdmCancel ];

/// PhoneOrderReviewTime
Property ORCATPhoneOrderReviewTime As %Float [ SqlColumnNumber = 22, SqlFieldName = ORCAT_PhoneOrderReviewTime ];

/// ApplyBatchPricing
Property ORCATApplyBatchPricing As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = ORCAT_ApplyBatchPricing ];

Index ORCATCodeUnqIdx1 On ORCATCode;

Index ORCATDescUnqIdx2 On ORCATDesc;

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECOrderCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECOrderCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECOrderCategory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderCategory","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECOrderCategory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderCategory","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderCategory","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECOrderCategory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderCategory","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEC("ORCAT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ORCAT_ApplyBatchPricing">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ORCAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORCAT_CounterTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ORCAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORCAT_DoNotDCOnAdmCancel">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ORCAT_DoNotDCOnAdmDisch">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ORCAT_HrsResultOverdue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ORCAT_IVExpiry">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ORCAT_IconApptsMade">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ORCAT_IconDisplayAfterExec">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ORCAT_IconName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORCAT_IconPriority">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ORCAT_IconResultOverdue">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ORCAT_NoShowIconAfterExcecut">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ORCAT_OCGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ORCAT_OrderSeqNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ORCAT_PhoneOrderReviewTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ORCAT_PrescrExpDays">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ORCAT_PrescrRepeatDays">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ORCAT_Questionnaire_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ORCAT_RepeatInOrder">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORCAT_ShowIconBeforeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORCAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ORCAT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORCAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ORCAT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORCAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORCAT_OCGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORCAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORCAT_RowId</SqlRowIdName>
<StreamLocation>^User.OECOrderCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
