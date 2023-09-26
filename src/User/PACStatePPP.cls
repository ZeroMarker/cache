/// State PPP(2119)
Class User.PACStatePPP Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_StatePPP, StorageStrategy = SQLStorage ]
{

/// Code
Property SPPPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SPPP_Code ];

/// Description
Property SPPPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SPPP_Desc ];

/// Start Date
Property SPPPStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SPPP_StartDate ];

/// End Date
Property SPPPEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = SPPP_EndDate ];

/// Des Ref NPPP
Property SPPPNPPPDR As PACNationalPPP [ SqlColumnNumber = 6, SqlFieldName = SPPP_NPPP_DR ];

/// ESIS Reportable
Property SPPPESISReportable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SPPP_ESIS_Reportable ];

/// CT Loc Des ref
Property SPPPCTLocDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = SPPP_CTLoc_DR ];

/// Waiting List Type DR
Property SPPPWLTypeDR As PACWaitingListType [ SqlColumnNumber = 9, SqlFieldName = SPPP_WLType_DR ];

/// Operation Procedure Des Ref
Property SPPPOperProcDR As ORCOperation [ SqlColumnNumber = 10, SqlFieldName = SPPP_OperProcDR ];

/// Episode Type
Property SPPPEpisodeType As %String(DISPLAYLIST = ",Inpatient,Outpatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 11, SqlFieldName = SPPP_EpisodeType ];

/// Waiting List Entry Capacity
Property SPPPWLEntryCapacity As %String(DISPLAYLIST = ",Single,Multiple", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",S,M") [ SqlColumnNumber = 12, SqlFieldName = SPPP_WLEntryCapacity ];

/// Estimated Time
Property SPPPEstTime As %Float [ SqlColumnNumber = 13, SqlFieldName = SPPP_EstTime ];

/// Recovery Type
Property SPPPRecoveryType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SPPP_RecoveryType ];

/// ReviewSuspenDateWeeks
Property SPPPReviewSuspenDateWeeks As %Float [ SqlColumnNumber = 15, SqlFieldName = SPPP_ReviewSuspenDateWeeks ];

/// NewWays
Property SPPPNewWays As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = SPPP_NewWays ];

/// OfferForAnAdm
Property SPPPOfferForAnAdm As %Float [ SqlColumnNumber = 17, SqlFieldName = SPPP_OfferForAnAdm ];

/// DaysForLetterResponse
Property SPPPDaysForLetterResponse As %Float [ SqlColumnNumber = 18, SqlFieldName = SPPP_DaysForLetterResponse ];

/// OffersBeforeIPWaitRest
Property SPPPOffersBeforeIPWaitRest As %Float [ SqlColumnNumber = 19, SqlFieldName = SPPP_OffersBeforeIPWaitRest ];

/// OfferOutComeChanged
Property SPPPOfferOutComeChanged As %Float [ SqlColumnNumber = 20, SqlFieldName = SPPP_OfferOutComeChanged ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACStatePPP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStatePPP","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACStatePPP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStatePPP","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACStatePPP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStatePPP","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACStatePPP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStatePPP","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACStatePPP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStatePPP","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStatePPP","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SPPP",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SPPP_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SPPP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPPP_DaysForLetterResponse">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SPPP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPPP_ESIS_Reportable">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SPPP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPPP_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SPPP_EstTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SPPP_NPPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SPPP_NewWays">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SPPP_OfferForAnAdm">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SPPP_OfferOutComeChanged">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SPPP_OffersBeforeIPWaitRest">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SPPP_OperProcDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SPPP_RecoveryType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SPPP_ReviewSuspenDateWeeks">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SPPP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SPPP_WLEntryCapacity">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SPPP_WLType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SPPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SPPP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SPPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SPPP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SPPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SPPP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPPP_RowId</SqlRowIdName>
<StreamLocation>^User.PACStatePPPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
