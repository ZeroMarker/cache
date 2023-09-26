/// Text Result History(2278)
Class User.OETextResultHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_TextResultHistory, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HISChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOETextResultHistSection As OETextResultHistSection [ Cardinality = children, Inverse = HSParRef ];

/// OE_TextResult Parent Reference
Relationship HISParRef As OETextResult [ Cardinality = parent, Inverse = ChildOETextResultHistory, Required, SqlFieldName = HIS_ParRef ];

/// Childsub
Property HISChildsub As %Float [ InitialExpression = {$i(^OETR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HIS",0))}, SqlColumnNumber = 2, SqlFieldName = HIS_Childsub ];

/// Date
Property HISDate As %Date [ SqlColumnNumber = 3, SqlFieldName = HIS_Date ];

/// Time
Property HISTime As %Time [ SqlColumnNumber = 4, SqlFieldName = HIS_Time ];

/// Des Ref User
Property HISUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = HIS_User_DR ];

/// Clinically Significant
Property HISClinicallySignificant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = HIS_ClinicallySignificant ];

/// HIS_ResStat_DR
Property HISResStatDR As OECResultStatus [ SqlColumnNumber = 7, SqlFieldName = HIS_ResStat_DR ];

/// Des Ref CTCP
Property HISCTCPDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = HIS_CTCP_DR ];

/// Des Ref TextResultType
Property HISTextResultTypeDR As OECTextResultType [ SqlColumnNumber = 9, SqlFieldName = HIS_TextResultType_DR ];

/// Date Verified
Property HISDateVerified As %Date [ SqlColumnNumber = 10, SqlFieldName = HIS_DateVerified ];

/// TimeVerified
Property HISTimeVerified As %Time [ SqlColumnNumber = 11, SqlFieldName = HIS_TimeVerified ];

/// UserVerified
Property HISUserVerifiedDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = HIS_UserVerified_DR ];

/// DateRead
Property HISDateRead As %Date [ SqlColumnNumber = 13, SqlFieldName = HIS_DateRead ];

/// Name
Property HISName As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = HIS_Name ];

/// TimeRead
Property HISTimeRead As %Time [ SqlColumnNumber = 15, SqlFieldName = HIS_TimeRead ];

/// Des Ref User Read
Property HISUserReadDR As SSUser [ SqlColumnNumber = 16, SqlFieldName = HIS_UserRead_DR ];

/// SuppressPrint
Property HISSuppressPrint As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = HIS_SuppressPrint ];

/// ImpressionDR
Property HISImpressionDR As OECImpression [ SqlColumnNumber = 18, SqlFieldName = HIS_ImpressionDR ];

/// DateUpdated
Property HISDateUpdated As %Date [ SqlColumnNumber = 19, SqlFieldName = HIS_DateUpdated ];

/// TimeUpdated
Property HISTimeUpdated As %Time [ SqlColumnNumber = 20, SqlFieldName = HIS_TimeUpdated ];

/// Des Ref UserUpdated
Property HISUserUpdatedDR As SSUser [ SqlColumnNumber = 21, SqlFieldName = HIS_UserUpdated_DR ];

/// Des Ref Action
Property HISActionDR As OECAction [ SqlColumnNumber = 22, SqlFieldName = HIS_Action_DR ];

/// ResultComments
Property HISResultComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = HIS_ResultComments, SqlListType = subnode ];

/// ExternalResultStatus
Property HISExternalResultStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = HIS_ExternalResultStatus ];

/// TestSetComments
Property HISTestSetComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = HIS_TestSetComments, SqlListType = subnode ];

/// Des Ref UserUnread
Property HISUserUnreadDR As SSUser [ SqlColumnNumber = 26, SqlFieldName = HIS_UserUnread_DR ];

/// DateUnread
Property HISDateUnread As %Date [ SqlColumnNumber = 27, SqlFieldName = HIS_DateUnread ];

/// TimeUnread
Property HISTimeUnread As %Time [ SqlColumnNumber = 28, SqlFieldName = HIS_TimeUnread ];

/// Des Ref LastUpdateHospital
Property HISLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 29, SqlFieldName = HIS_LastUpdateHospital_DR ];

/// ResultFlags
Property HISResultFlags As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = HIS_ResultFlags ];

/// Des Ref CareProviderReported
Property HISCareProviderReportedDR As CTCareProv [ SqlColumnNumber = 31, SqlFieldName = HIS_CareProviderReported_DR ];

/// Des Ref UserTranscribed
Property HISUserTranscribedDR As SSUser [ SqlColumnNumber = 32, SqlFieldName = HIS_UserTranscribed_DR ];

/// Questionnaire
Property HISQuestionnaire As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = HIS_Questionnaire ];

/// Des Ref CPVerified
Property HISCPVerifiedDR As CTCareProv [ SqlColumnNumber = 34, SqlFieldName = HIS_CPVerified_DR ];

/// Des Ref ReasonSuppResult
Property HISReasonSuppResultDR As OECReasonSuppltryResult [ SqlColumnNumber = 35, SqlFieldName = HIS_ReasonSuppResult_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OETextResultHistory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OETextResultHistory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OETextResultHistory).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OETextResultHistory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OETextResultHistory).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OETextResultHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>259</ExtentSize>
<Property name="HISActionDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISCPVerifiedDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISCTCPDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISCareProviderReportedDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISChildsub">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="HISClinicallySignificant">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HISDate">
<Selectivity>1.6393%</Selectivity>
</Property>
<Property name="HISDateRead">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISDateUnread">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISDateUpdated">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISDateVerified">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISExternalResultStatus">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISImpressionDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISLastUpdateHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISName">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISParRef">
<Selectivity>1.5152%</Selectivity>
</Property>
<Property name="HISQuestionnaire">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISReasonSuppResultDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISResStatDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISResultComments">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISResultFlags">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISSuppressPrint">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HISTestSetComments">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISTextResultTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISTime">
<Selectivity>0.4149%</Selectivity>
</Property>
<Property name="HISTimeRead">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISTimeUnread">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISTimeUpdated">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISTimeVerified">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISUserDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="HISUserReadDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISUserTranscribedDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISUserUnreadDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISUserUpdatedDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HISUserVerifiedDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="HIS_Action_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HIS_CPVerified_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="HIS_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HIS_CareProviderReported_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="HIS_ClinicallySignificant">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HIS_DateRead">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HIS_DateUnread">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="HIS_DateUpdated">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HIS_DateVerified">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HIS_ExternalResultStatus">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="HIS_ImpressionDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HIS_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="HIS_Name">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HIS_Questionnaire">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="HIS_ReasonSuppResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="HIS_ResStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HIS_ResultComments">
<Node>"RC"</Node>
</Data>
<Data name="HIS_ResultFlags">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HIS_SuppressPrint">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HIS_TestSetComments">
<Node>"TS"</Node>
</Data>
<Data name="HIS_TextResultType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HIS_TimeRead">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HIS_TimeUnread">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="HIS_TimeUpdated">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HIS_TimeVerified">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HIS_UserRead_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HIS_UserTranscribed_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="HIS_UserUnread_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="HIS_UserUpdated_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="HIS_UserVerified_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HIS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^OETR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_TextResult.TR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_TextResult.TR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HIS_RowId</SqlRowIdName>
<StreamLocation>^User.OETextResultHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
