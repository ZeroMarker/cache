/// RBC Service Group(1539)
Class User.RBCServiceGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = RBC_ServiceGroup, StorageStrategy = SQLStorage ]
{

Relationship ChildRBCServiceGroupPayors As RBCServiceGroupPayors [ Cardinality = children, Inverse = PAYParREf ];

/// Code
Property SGCode As %String(COLLATION = "AlphaUp", MAXLEN = 5, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SG_Code ];

/// Description
Property SGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SG_Desc ];

/// Preadmission Check
Property SGPreadmissionCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SG_PreadmissionCheck ];

/// Bypass Date Check
Property SGBypassDateCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SG_BypassDateCheck ];

/// Allow Booking After Discharge Date
Property SGAllowBookAfterDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SG_AllowBookAfterDischarge ];

/// Date From
Property SGDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = SG_DateFrom ];

/// Date To
Property SGDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = SG_DateTo ];

/// WeeksSuspensionReview
Property SGWeeksSuspensionReview As %Float [ SqlColumnNumber = 9, SqlFieldName = SG_WeeksSuspensionReview ];

/// DaysForOPDOffer
Property SGDaysForOPDOffer As %Float [ SqlColumnNumber = 10, SqlFieldName = SG_DaysForOPDOffer ];

/// DaysForOPLetterResponse
Property SGDaysForOPLetterResponse As %Float [ SqlColumnNumber = 11, SqlFieldName = SG_DaysForOPLetterResponse ];

/// OffersBeforeIP OPWaitReset
Property SGOffersBeforeIPOPWaitReset As %Float [ SqlColumnNumber = 12, SqlFieldName = SG_OffersBeforeIP_OPWaitReset ];

/// DaysOfferOutcomeChange
Property SGDaysOfferOutcomeChange As %Float [ SqlColumnNumber = 13, SqlFieldName = SG_DaysOfferOutcomeChange ];

Index SGCodeUnqIdx1 On SGCode;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCServiceGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServiceGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCServiceGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServiceGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCServiceGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServiceGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCServiceGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServiceGroup","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCServiceGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServiceGroup","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCServiceGroup","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="SGAllowBookAfterDischarge">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SGBypassDateCheck">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SGCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SGDateFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SGDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SGDaysForOPDOffer">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SGDaysForOPLetterResponse">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SGDaysOfferOutcomeChange">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SGDesc">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="SGOffersBeforeIPOPWaitReset">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SGPreadmissionCheck">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SGWeeksSuspensionReview">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^RBC("SG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SG_AllowBookAfterDischarge">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SG_BypassDateCheck">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SG_DaysForOPDOffer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SG_DaysForOPLetterResponse">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SG_DaysOfferOutcomeChange">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SG_OffersBeforeIP_OPWaitReset">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SG_PreadmissionCheck">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SG_WeeksSuspensionReview">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SG_RowId</SqlRowIdName>
<StreamLocation>^User.RBCServiceGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
