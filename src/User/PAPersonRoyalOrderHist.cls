/// PersonRoyalOrderHistory(2667)
Class User.PAPersonRoyalOrderHist Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonRoyalOrderHist, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HISChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PersonRoyalOrder Parent Reference
Relationship HISParRef As PAPersonRoyalOrder [ Cardinality = parent, Inverse = ChildPAPersonRoyalOrderHist, Required, SqlFieldName = HIS_ParRef ];

/// Childsub
Property HISChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RO",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"HIS",0))}, SqlColumnNumber = 2, SqlFieldName = HIS_Childsub ];

/// Date
Property HISDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 3, SqlFieldName = HIS_Date ];

/// Time
Property HISTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 4, SqlFieldName = HIS_Time ];

/// Des Ref User
Property HISUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = HIS_User_DR ];

/// OPValidPeriod
Property HISOPValidPeriod As %Float [ SqlColumnNumber = 6, SqlFieldName = HIS_OPValidPeriod ];

/// OPDateValidFrom
Property HISOPDateValidFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = HIS_OPDateValidFrom ];

/// OPDateValidTo
Property HISOPDateValidTo As %Date [ SqlColumnNumber = 8, SqlFieldName = HIS_OPDateValidTo ];

/// IPValidPeriod
Property HISIPValidPeriod As %Float [ SqlColumnNumber = 9, SqlFieldName = HIS_IPValidPeriod ];

/// IPDateValidFrom
Property HISIPDateValidFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = HIS_IPDateValidFrom ];

/// IPDateValidTo
Property HISIPDateValidTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = HIS_IPDateValidTo ];

/// ReasonForChange
Property HISReasonForChange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = HIS_ReasonForChange ];

/// PaysUntil
Property HISPaysUntil As %Float [ SqlColumnNumber = 13, SqlFieldName = HIS_PaysUntil ];

/// AmtUsed
Property HISAmtUsed As %Float [ SqlColumnNumber = 14, SqlFieldName = HIS_AmtUsed ];

/// IPValidPeriodUnits
Property HISIPValidPeriodUnits As %String(DISPLAYLIST = ",Days,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 15, SqlFieldName = HIS_IPValidPeriodUnits ];

/// OPValidPeriodUnits
Property HISOPValidPeriodUnits As %String(DISPLAYLIST = ",Days,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 16, SqlFieldName = HIS_OPValidPeriodUnits ];

/// Status
Property HISStatus As %String(DISPLAYLIST = ",Active for All Episodes,Expired for All Epiosodes,Active for Inpatients,Active for Outpatients,Expired for Inpatients,Expired for Outpatients,Expired,Active,On Hold,Cancelled", MAXLEN = 25, TRUNCATE = 1, VALUELIST = ",AA,EA,AI,AO,EI,EO,E,A,H,C") [ SqlColumnNumber = 17, SqlFieldName = HIS_Status ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrderHist).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderHist","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrderHist).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderHist","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrderHist).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderHist","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonRoyalOrderHist).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrderHist","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonRoyalOrderHist).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.r","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="HIS_AmtUsed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HIS_IPDateValidFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HIS_IPDateValidTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HIS_IPValidPeriod">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HIS_IPValidPeriodUnits">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HIS_OPDateValidFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HIS_OPDateValidTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HIS_OPValidPeriod">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HIS_OPValidPeriodUnits">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HIS_PaysUntil">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HIS_ReasonForChange">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HIS_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HIS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PersonRoyalOrder.ROYAL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>HIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_PersonRoyalOrder.ROYAL_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"HIS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HIS_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonRoyalOrderHistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
