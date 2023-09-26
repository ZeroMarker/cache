/// PAC Waiting List Priority(1477)
Class User.PACWaitingListPriority Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WaitingListPriority, StorageStrategy = SQLStorage ]
{

Relationship ChildPACWaitLisPrioritySessType As PACWaitLisPrioritySessType [ Cardinality = children, Inverse = SESSParRef ];

/// Code
Property WLPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = WLP_Code ];

/// Description
Property WLPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = WLP_Desc ];

/// Days
Property WLPDays As %Float [ SqlColumnNumber = 4, SqlFieldName = WLP_Days ];

/// Date From
Property WLPDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = WLP_DateFrom ];

/// Date To
Property WLPDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = WLP_DateTo ];

/// National Code
Property WLPNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = WLP_NationalCode ];

/// Days Not Exceed
Property WLPDaysNotExceed As %Float [ SqlColumnNumber = 8, SqlFieldName = WLP_DaysNotExceed ];

/// Level
Property WLPLevel As %Float [ SqlColumnNumber = 10, SqlFieldName = WLP_Level ];

/// DateToCalcFromInpat
Property WLPDateToCalcFromInpat As %String(DISPLAYLIST = ",on GP Letter,Referral Received,Placed on Waiting List", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",GPL,RR,PWL") [ SqlColumnNumber = 11, SqlFieldName = WLP_DateToCalcFromInpat ];

/// DateToCalcFromOutpat
Property WLPDateToCalcFromOutpat As %String(DISPLAYLIST = ",on GP Letter,Referral Received,Placed on Waiting List", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",GPL,RR,PWL") [ SqlColumnNumber = 12, SqlFieldName = WLP_DateToCalcFromOutpat ];

/// IgnoreDaysForOPDOrder
Property WLPIgnoreDaysForOPDOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = WLP_IgnoreDaysForOPDOrder ];

Index WLPCodeUnqIdx1 On WLPCode [ Unique ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACWaitingListPriority).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListPriority","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACWaitingListPriority).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListPriority","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACWaitingListPriority).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListPriority","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACWaitingListPriority).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListPriority","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACWaitingListPriority).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListPriority","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWaitingListPriority","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="WLPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="WLPDateFrom">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="WLPDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="WLPDateToCalcFromInpat">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="WLPDateToCalcFromOutpat">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="WLPDays">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="WLPDaysNotExceed">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WLPDesc">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="WLPIgnoreDaysForOPDOrder">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WLPLevel">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="WLPNationalCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("WLP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WLP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLP_DateToCalcFromInpat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLP_DateToCalcFromOutpat">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WLP_Days">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLP_DaysNotExceed">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLP_IgnoreDaysForOPDOrder">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WLP_Level">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WLP_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WLP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WLP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLP_RowId</SqlRowIdName>
<StreamLocation>^User.PACWaitingListPriorityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
