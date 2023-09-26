/// RB Event(2292)
Class User.RBEvent Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_Event, StorageStrategy = SQLStorage ]
{

Relationship ChildRBEventPatient As RBEventPatient [ Cardinality = children, Inverse = PATParRef ];

Relationship ChildRBEventCPFacilitator As RBEventCPFacilitator [ Cardinality = children, Inverse = CPFParRef ];

Relationship ChildRBEventCPAttender As RBEventCPAttender [ Cardinality = children, Inverse = CPATParRef ];

Relationship ChildRBEventTimes As RBEventTimes [ Cardinality = children, Inverse = TIMEParRef ];

Relationship ChildRBEventDocuments As RBEventDocuments [ Cardinality = children, Inverse = SDParRef ];

/// Number
Property EVNumber As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EV_Number ];

/// Status
Property EVStatus As %String(DISPLAYLIST = ",Initial,Booked,Transfer,Cancel,Done", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",I,B,T,X,D") [ SqlColumnNumber = 3, SqlFieldName = EV_Status ];

/// Name
Property EVName As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EV_Name ];

/// Des Ref Event Type
Property EVTypeDR As RBCEventType [ SqlColumnNumber = 5, SqlFieldName = EV_Type_DR ];

/// ClientType
Property EVClientType As %String(DISPLAYLIST = ",Client,Clinician,Client and Clinician,Health Promotion", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",CLT,CLN,CLC,HP") [ SqlColumnNumber = 6, SqlFieldName = EV_ClientType ];

/// Des Ref Method Of Conduct
Property EVMethodOfConductDR As RBCMethodOfConduct [ SqlColumnNumber = 7, SqlFieldName = EV_MethodOfConduct_DR ];

/// Des Ref CTCP
Property EVAdministratorDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = EV_Administrator_DR ];

/// Duration
Property EVDuration As %Float [ SqlColumnNumber = 9, SqlFieldName = EV_Duration ];

/// Venue
Property EVVenue As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = EV_Venue ];

/// Max Number Of Participants
Property EVMaxNumberOfParticipants As %Float [ SqlColumnNumber = 11, SqlFieldName = EV_MaxNumberOfParticipants ];

/// Charge
Property EVCharge As %Float [ SqlColumnNumber = 12, SqlFieldName = EV_Charge ];

/// Preparation Time
Property EVPreparationTime As %Time [ SqlColumnNumber = 13, SqlFieldName = EV_PreparationTime ];

/// Predicted Travel Time
Property EVPredictedTravelTime As %Time [ SqlColumnNumber = 14, SqlFieldName = EV_PredictedTravelTime ];

/// Predicted Review Time
Property EVPredictedReviewTime As %Time [ SqlColumnNumber = 15, SqlFieldName = EV_PredictedReviewTime ];

/// Des Ref RBResource
Property EVRBResourceDR As RBResource [ SqlColumnNumber = 16, SqlFieldName = EV_RBResource_DR ];

/// Venue Address1
Property EVVenueAddress1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = EV_VenueAddress1 ];

/// Venue Address2
Property EVVenueAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = EV_VenueAddress2 ];

/// Venue Phone
Property EVVenuePhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = EV_VenuePhone ];

/// Venue Fax
Property EVVenueFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = EV_VenueFax ];

/// Des Ref ConsultCategory
Property EVConsultCategoryDR As OECConsultCateg [ SqlColumnNumber = 21, SqlFieldName = EV_ConsultCategory_DR ];

/// Des Ref ClientSource
Property EVClientSourceDR As PACSourceOfReferral [ SqlColumnNumber = 22, SqlFieldName = EV_ClientSource_DR ];

/// ClientSourceDesc
Property EVClientSourceDesc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = EV_ClientSourceDesc ];

/// AttendeeFemaleNo
Property EVAttendeeFemaleNo As %Float [ SqlColumnNumber = 24, SqlFieldName = EV_AttendeeFemaleNo ];

/// AttendeeMaleNo
Property EVAttendeeMaleNo As %Float [ SqlColumnNumber = 25, SqlFieldName = EV_AttendeeMaleNo ];

/// Des Ref EventSubType
Property EVEventSubTypeDR As RBCEventSubType [ SqlColumnNumber = 26, SqlFieldName = EV_EventSubType_DR ];

/// Client Source Organisation
Property EVClientSourceOrgDR As PACNonGovOrg [ SqlColumnNumber = 27, SqlFieldName = EV_ClientSourceOrg_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBEvent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEvent","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBEvent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEvent","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBEvent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEvent","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBEvent).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEvent","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBEvent).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEvent","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBEV(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="EV_Administrator_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EV_AttendeeFemaleNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EV_AttendeeMaleNo">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="EV_Charge">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EV_ClientSourceDesc">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="EV_ClientSourceOrg_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="EV_ClientSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EV_ClientType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EV_ConsultCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EV_Duration">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EV_EventSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="EV_MaxNumberOfParticipants">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EV_MethodOfConduct_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EV_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EV_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EV_PredictedReviewTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EV_PredictedTravelTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EV_PreparationTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EV_RBResource_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EV_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EV_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EV_Venue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EV_VenueAddress1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EV_VenueAddress2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EV_VenueFax">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EV_VenuePhone">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^RBEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{EV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmin">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Admin"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EV_Administrator_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexClientType">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CLType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EV_ClientType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMethOfConduct">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MethOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EV_MethodOfConduct_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EV_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EV_Number})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Stat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EV_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EV_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EV_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
