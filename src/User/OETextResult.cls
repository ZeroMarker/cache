/// OE Text Result(1393)
Class User.OETextResult Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_TextResult, StorageStrategy = SQLStorage ]
{

Relationship ChildOETextResultSection As OETextResultSection [ Cardinality = children, Inverse = SECParRef ];

Relationship ChildOETextResultHistory As OETextResultHistory [ Cardinality = children, Inverse = HISParRef ];

/// Des Ref OEORD
Property TROEORDDR As OEOrder [ SqlColumnNumber = 2, SqlFieldName = TR_OEORD_DR ];

/// Des Ref Result Status
Property TRResStatDR As OECResultStatus [ SqlColumnNumber = 3, SqlFieldName = TR_ResStat_DR ];

/// Des Ref CTCP
Property TRCTCPDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = TR_CTCP_DR ];

/// Des Ref TextResultType
Property TRTextResultTypeDR As OECTextResultType [ SqlColumnNumber = 5, SqlFieldName = TR_TextResultType_DR ];

/// Date Created
Property TRDateCreated As %Date [ SqlColumnNumber = 6, SqlFieldName = TR_DateCreated ];

/// Time Created
Property TRTimeCreated As %Time [ SqlColumnNumber = 7, SqlFieldName = TR_TimeCreated ];

/// Des Ref SSUser
Property TRUserCreated As SSUser [ SqlColumnNumber = 8, SqlFieldName = TR_UserCreated ];

/// Date Verified
Property TRDateVerified As %Date [ SqlColumnNumber = 9, SqlFieldName = TR_DateVerified ];

/// Time Verified
Property TRTimeVerified As %Time [ SqlColumnNumber = 10, SqlFieldName = TR_TimeVerified ];

/// Des Ref User
Property TRUserVerified As SSUser [ SqlColumnNumber = 11, SqlFieldName = TR_UserVerified ];

/// Name
Property TRName As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = TR_Name ];

/// Date Read
Property TRDateRead As %Date [ SqlColumnNumber = 13, SqlFieldName = TR_DateRead ];

/// Time Read
Property TRTimeRead As %Time [ SqlColumnNumber = 14, SqlFieldName = TR_TimeRead ];

/// Des Ref User Read
Property TRUserReadDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = TR_UserRead_DR ];

/// Suppress Print
Property TRSuppressPrint As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = TR_SuppressPrint ];

/// Impression DR
Property TRImpressionDR As OECImpression [ SqlColumnNumber = 17, SqlFieldName = TR_ImpressionDR ];

/// Date Updated
Property TRDateUpdated As %Date [ SqlColumnNumber = 18, SqlFieldName = TR_DateUpdated ];

/// Time Updated
Property TRTimeUpdated As %Time [ SqlColumnNumber = 19, SqlFieldName = TR_TimeUpdated ];

/// Des Ref UserUpdated
Property TRUserUpdatedDR As SSUser [ SqlColumnNumber = 20, SqlFieldName = TR_UserUpdated_DR ];

/// Des Ref Action
Property TRActionDR As OECAction [ SqlColumnNumber = 21, SqlFieldName = TR_Action_DR ];

/// Result Comments
Property TRResultComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = TR_ResultComments, SqlListType = subnode ];

/// External Result Status
Property TRExternalResultStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = TR_ExternalResultStatus ];

/// TestSetComments
Property TRTestSetComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = TR_TestSetComments, SqlListType = subnode ];

/// Des Ref UserUnread
Property TRUserUnreadDR As SSUser [ SqlColumnNumber = 25, SqlFieldName = TR_UserUnread_DR ];

/// Date Unread
Property TRDateUnread As %Date [ SqlColumnNumber = 26, SqlFieldName = TR_DateUnread ];

/// TimeUnread
Property TRTimeUnread As %Time [ SqlColumnNumber = 27, SqlFieldName = TR_TimeUnread ];

/// ClinicallySignificant
Property TRClinicallySignificant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = TR_ClinicallySignificant ];

/// Des Ref LastUpdateHospital
Property TRLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 29, SqlFieldName = TR_LastUpdateHospital_DR ];

/// Result Flags
Property TRResultFlags As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = TR_ResultFlags ];

/// Des Ref CareProviderReported
Property TRCareProviderReportedDR As CTCareProv [ SqlColumnNumber = 31, SqlFieldName = TR_CareProviderReported_DR ];

/// Des Ref UserTranscribed
Property TRUserTranscribedDR As SSUser [ SqlColumnNumber = 32, SqlFieldName = TR_UserTranscribed_DR ];

/// Questionnaire
Property TRQuestionnaire As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = TR_Questionnaire ];

/// Des Ref CPVerified
Property TRCPVerifiedDR As CTCareProv [ SqlColumnNumber = 34, SqlFieldName = TR_CPVerified_DR ];

/// Des Ref ReasonSuppResult
Property TRReasonSuppResultDR As OECReasonSuppltryResult [ SqlColumnNumber = 35, SqlFieldName = TR_ReasonSuppResult_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OETextResult).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResult","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OETextResult).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResult","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OETextResult).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResult","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OETextResult).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResult","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OETextResult).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResult","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResult","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>364</ExtentSize>
<Property name="TRActionDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRCPVerifiedDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="TRCTCPDR">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="TRCareProviderReportedDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="TRClinicallySignificant">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRDateCreated">
<Selectivity>0.7813%</Selectivity>
</Property>
<Property name="TRDateRead">
<Selectivity>2.3810%</Selectivity>
</Property>
<Property name="TRDateUnread">
<Selectivity>2.9412%</Selectivity>
</Property>
<Property name="TRDateUpdated">
<Selectivity>1.2821%</Selectivity>
</Property>
<Property name="TRDateVerified">
<Selectivity>1.2048%</Selectivity>
</Property>
<Property name="TRExternalResultStatus">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="TRImpressionDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TRLastUpdateHospitalDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="TRName">
<Selectivity>0.6803%</Selectivity>
</Property>
<Property name="TROEORDDR">
<Selectivity>0.9709%</Selectivity>
</Property>
<Property name="TRQuestionnaire">
<Selectivity>2.2727%</Selectivity>
</Property>
<Property name="TRReasonSuppResultDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="TRResStatDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="TRResultComments">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="TRResultFlags">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="TRSuppressPrint">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRTestSetComments">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="TRTextResultTypeDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TRTimeCreated">
<Selectivity>0.2857%</Selectivity>
</Property>
<Property name="TRTimeRead">
<Selectivity>1.3514%</Selectivity>
</Property>
<Property name="TRTimeUnread">
<Selectivity>1.5385%</Selectivity>
</Property>
<Property name="TRTimeUpdated">
<Selectivity>0.5556%</Selectivity>
</Property>
<Property name="TRTimeVerified">
<Selectivity>0.5263%</Selectivity>
</Property>
<Property name="TRUserCreated">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TRUserReadDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="TRUserTranscribedDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="TRUserUnreadDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TRUserUpdatedDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TRUserVerified">
<Selectivity>12.5000%</Selectivity>
</Property>
<SqlIdExpression>$i(^OETR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TR_Action_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TR_CPVerified_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="TR_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TR_CareProviderReported_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="TR_ClinicallySignificant">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="TR_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TR_DateRead">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TR_DateUnread">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TR_DateUpdated">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TR_DateVerified">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TR_ExternalResultStatus">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TR_ImpressionDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TR_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="TR_Name">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TR_OEORD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TR_Questionnaire">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="TR_ReasonSuppResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="TR_ResStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TR_ResultComments">
<Node>"RC"</Node>
</Data>
<Data name="TR_ResultFlags">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="TR_SuppressPrint">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TR_TestSetComments">
<Node>"TS"</Node>
</Data>
<Data name="TR_TextResultType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TR_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TR_TimeRead">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TR_TimeUnread">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="TR_TimeUpdated">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TR_TimeVerified">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TR_UserCreated">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TR_UserRead_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TR_UserTranscribed_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="TR_UserUnread_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TR_UserUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TR_UserVerified">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^OETR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateCreated">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRESDateCreated"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_DateCreated}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateVerified">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRESDateVerif"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_DateVerified}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotRead">
<Condition>{TR_DateRead}=""</Condition>
<ConditionFields>TR_DateRead,TR_ResStat_DR</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TextNotRead"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_OEORD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^OETR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_OEORD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRead">
<Condition>{TR_DateRead}</Condition>
<ConditionFields>TR_DateRead</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TextRead"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_OEORD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResStat">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_OEORD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_ResStat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TR_RowId</SqlRowIdName>
<StreamLocation>^User.OETextResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
