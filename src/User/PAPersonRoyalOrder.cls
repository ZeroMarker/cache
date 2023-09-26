/// PersonRoyalOrder(2607)
Class User.PAPersonRoyalOrder Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonRoyalOrder, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ROYALChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPersonRoyalOrderExemp As PAPersonRoyalOrderExemp [ Cardinality = children, Inverse = EXEMPParRef ];

Relationship ChildPAPersonRoyalOrderHist As PAPersonRoyalOrderHist [ Cardinality = children, Inverse = HISParRef ];

/// PA_Person Parent Reference
Relationship ROYALParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonRoyalOrder, Required, SqlFieldName = ROYAL_ParRef ];

/// Childsub
Property ROYALChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RO",0))}, SqlColumnNumber = 2, SqlFieldName = ROYAL_Childsub ];

/// DateValidFrom
Property ROYALDateValidFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = ROYAL_DateValidFrom ];

/// DateValidTo
Property ROYALDateValidTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ROYAL_DateValidTo ];

/// PaysUntil
Property ROYALPaysUntil As %Float [ SqlColumnNumber = 5, SqlFieldName = ROYAL_PaysUntil ];

/// Des Ref Payor
Property ROYALPayorDR As ARCInsuranceType [ SqlColumnNumber = 6, SqlFieldName = ROYAL_Payor_DR ];

/// Des Ref Plan
Property ROYALPlanDR As ARCAuxilInsurType [ SqlColumnNumber = 7, SqlFieldName = ROYAL_Plan_DR ];

/// Number
Property ROYALNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ROYAL_Number ];

/// OfficeNo
Property ROYALOfficeNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ROYAL_OfficeNo ];

/// AmtRemain
Property ROYALAmtRemain As %Float [ SqlColumnNumber = 10, SqlFieldName = ROYAL_AmtRemain ];

/// Des Ref RoomType
Property ROYALRoomTypeDR As PACRoomType [ SqlColumnNumber = 11, SqlFieldName = ROYAL_RoomType_DR ];

/// Status
Property ROYALStatus As %String(DISPLAYLIST = ",Active for All Episodes,Expired for All Epiosodes,Active for Inpatients,Active for Outpatients,Expired for Inpatients,Expired for Outpatients,Expired,Active,On Hold,Cancelled", MAXLEN = 25, TRUNCATE = 1, VALUELIST = ",AA,EA,AI,AO,EI,EO,E,A,H,C") [ SqlColumnNumber = 12, SqlFieldName = ROYAL_Status ];

/// Des Ref ReasonChange
Property ROYALReasonChangeDR As PACReasonForChangePatData [ SqlColumnNumber = 13, SqlFieldName = ROYAL_ReasonChange_DR ];

/// ValidPeriod
Property ROYALValidPeriod As %Float [ SqlColumnNumber = 14, SqlFieldName = ROYAL_ValidPeriod ];

/// ValidPeriodUnits
Property ROYALValidPeriodUnits As %String(DISPLAYLIST = ",Days,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 15, SqlFieldName = ROYAL_ValidPeriodUnits ];

/// Comments
Property ROYALComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ROYAL_Comments, SqlListType = SUBNODE ];

/// InpDateValidTo
Property ROYALInpDateValidTo As %Date [ SqlColumnNumber = 17, SqlFieldName = ROYAL_InpDateValidTo ];

/// InpValidPeriod
Property ROYALInpValidPeriod As %Float [ SqlColumnNumber = 18, SqlFieldName = ROYAL_InpValidPeriod ];

/// InpValidPeriodUnits
Property ROYALInpValidPeriodUnits As %String(DISPLAYLIST = ",Days,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 19, SqlFieldName = ROYAL_InpValidPeriodUnits ];

/// InpDateValidFrom
Property ROYALInpDateValidFrom As %Date [ SqlColumnNumber = 20, SqlFieldName = ROYAL_InpDateValidFrom ];

/// AmtUsed
Property ROYALAmtUsed As %Float [ SqlColumnNumber = 21, SqlFieldName = ROYAL_AmtUsed ];

/// Exclusion
Property ROYALExclusion As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = ROYAL_Exclusion ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrder).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrder","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonRoyalOrder).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrder","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 	
 d ##Class(User.PAPersonRoyalOrder).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrder","OnAfterUpdate")
 
 d PAPersonROHistory^CPAPerson1($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonRoyalOrder).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrder","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 

 d ##Class(User.PAPersonRoyalOrder).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonRoyalOrder","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ROYAL_AmtRemain">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ROYAL_AmtUsed">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ROYAL_Comments">
<Node>"REM"</Node>
</Data>
<Data name="ROYAL_DateValidFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ROYAL_DateValidTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ROYAL_Exclusion">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ROYAL_InpDateValidFrom">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ROYAL_InpDateValidTo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ROYAL_InpValidPeriod">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ROYAL_InpValidPeriodUnits">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ROYAL_Number">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ROYAL_OfficeNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ROYAL_Payor_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ROYAL_PaysUntil">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ROYAL_Plan_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ROYAL_ReasonChange_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ROYAL_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ROYAL_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ROYAL_ValidPeriod">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ROYAL_ValidPeriodUnits">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ROYAL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateValidTo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALDateValidTo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROYAL_DateValidTo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParRef">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RoyalPat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROYALDateFrom">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALDateFrom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROYAL_DateValidFrom}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROYALNumber">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALNumber"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({ROYAL_Number})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROYALOfficeNo">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALOfficeNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROYAL_OfficeNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROYALPayorDR">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALPayorDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROYAL_Payor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROYALPlanDR">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALPlanDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROYAL_Plan_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROYALStatus">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ROYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ROYALStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROYAL_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ROYAL_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonRoyalOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
