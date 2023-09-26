/// OE Order Item Result(1290)
Class User.OEOrdResult Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdResult, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RESChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOEOrdResultCodes As OEOrdResultCodes [ Cardinality = children, Inverse = CODParRef ];

Relationship ChildOEOrdResultDelivery As OEOrdResultDelivery [ Cardinality = children, Inverse = DELParREf ];

/// OE_OrdItem Parent Reference
Relationship RESParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdResult, Required, SqlFieldName = RES_ParRef ];

/// Childsub
Property RESChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"RES",0))}, SqlColumnNumber = 2, SqlFieldName = RES_Childsub ];

/// Des Ref ResultStatus
Property RESResStatDR As OECResultStatus [ SqlColumnNumber = 3, SqlFieldName = RES_ResStat_DR ];

/// File Name
Property RESFileName As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RES_FileName ];

/// User Created
Property RESUserCreated As SSUser [ SqlColumnNumber = 5, SqlFieldName = RES_UserCreated ];

/// User Verified
Property RESUserVerified As SSUser [ SqlColumnNumber = 6, SqlFieldName = RES_UserVerified ];

/// Date Created
Property RESDateCreated As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = RES_DateCreated ];

/// Date Verified
Property RESDateVerified As %Date [ SqlColumnNumber = 8, SqlFieldName = RES_DateVerified ];

/// Time Created
Property RESTimeCreated As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = RES_TimeCreated ];

/// Time Verified
Property RESTimeVerified As %Time [ SqlColumnNumber = 10, SqlFieldName = RES_TimeVerified ];

/// Name
Property RESName As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = RES_Name ];

/// Des Ref CTCP (Doctor Entered)
Property RESCTCPDR As CTCareProv [ SqlColumnNumber = 12, SqlFieldName = RES_CTCP_DR ];

/// Text
Property RESText As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = RES_Text, SqlListType = SUBNODE ];

/// Result Type
Property RESType As %String(DISPLAYLIST = ",Word,DICOM,Voice", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",W,D,V") [ SqlColumnNumber = 14, SqlFieldName = RES_Type ];

/// Archive
Property RESArchive As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = RES_Archive ];

/// DICOM Series Modality
Property RESDICOMSeriesModality As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = RES_DICOM_SeriesModality ];

/// DICOM Patient ID
Property RESDICOMPatientID As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlComputeCode = { s {RES_DICOM_PatientID}=$$CO17^at1290({RES_ParRef})
}, SqlComputed, SqlFieldName = RES_DICOM_PatientID, Transient ];

/// DICOM Study Accession No
Property RESDICOMStudyAccessionNo As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = RES_DICOM_StudyAccessionNo ];

/// DICOM Study Instance UID
Property RESDICOMStudyInstanceUID As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = RES_DICOM_StudyInstanceUID ];

/// DICOM Study ID
Property RESDICOMStudyID As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = RES_DICOM_StudyID ];

/// DICOM Series Number
Property RESDICOMSeriesNumber As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = RES_DICOM_SeriesNumber ];

/// DICOM Series Instance UID
Property RESDICOMSeriesInstanceUID As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = RES_DICOM_SeriesInstanceUID ];

/// DICOM SOP InstanceUID (unique id for image)
Property RESDICOMSOPInstanceUID As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = RES_DICOM_SOPInstanceUID ];

/// Delivery Date
Property RESDeliveryDate As %Date [ SqlColumnNumber = 24, SqlFieldName = RES_DeliveryDate ];

/// Des Ref Priority
Property RESPriorityDR As OECPriority [ SqlColumnNumber = 26, SqlComputeCode = { s {RES_Priority_DR}=$$CO26^at1290({RES_ParRef})
}, SqlComputed, SqlFieldName = RES_Priority_DR, Transient ];

/// Delivery Time
Property RESDeliveryTime As %Time [ SqlColumnNumber = 27, SqlFieldName = RES_DeliveryTime ];

/// Des Ref RecDep
Property RESRecDepDR As CTLoc [ SqlColumnNumber = 28, SqlComputeCode = { s {RES_RecDep_DR}=$$CO28^at1290({RES_ParRef})
}, SqlComputed, SqlFieldName = RES_RecDep_DR, Transient ];

/// Tag
Property RESTag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = RES_Tag ];

/// Override Path
Property RESOverridePath As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = RES_OverridePath ];

/// Date Read
Property RESDateRead As %Date [ SqlColumnNumber = 31, SqlFieldName = RES_DateRead ];

/// Time Read
Property RESTimeRead As %Time [ SqlColumnNumber = 32, SqlFieldName = RES_TimeRead ];

/// Des Ref UserRead
Property RESUserReadDR As SSUser [ SqlColumnNumber = 33, SqlFieldName = RES_UserRead_DR ];

/// Description
Property RESDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = RES_Desc ];

/// Des Ref NonSTDRepIssReason
Property RESNonSTDRepIssReasonDR As OECNonSTDRepIssReason [ SqlColumnNumber = 35, SqlFieldName = RES_NonSTDRepIssReason_DR ];

/// Report Not Expected
Property RESReportNotExpected As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = RES_ReportNotExpected ];

/// Abnormal
Property RESAbnormal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = RES_Abnormal ];

/// Des Ref UserUnread
Property RESUserUnreadDR As SSUser [ SqlColumnNumber = 38, SqlFieldName = RES_UserUnread_DR ];

/// Date Unread
Property RESDateUnread As %Date [ SqlColumnNumber = 39, SqlFieldName = RES_DateUnread ];

/// Time Unread
Property RESTimeUnread As %Time [ SqlColumnNumber = 40, SqlFieldName = RES_TimeUnread ];

/// Des Ref CPReported
Property RESCPReportedDR As CTCareProv [ SqlColumnNumber = 41, SqlFieldName = RES_CPReported_DR ];

/// Des Ref CPVerified
Property RESCPVerifiedDR As CTCareProv [ SqlColumnNumber = 42, SqlFieldName = RES_CPVerified_DR ];

/// LastUpdateDate
Property RESLastUpdateDate As %Date [ SqlColumnNumber = 43, SqlFieldName = RES_LastUpdateDate ];

/// LastUpdateTime
Property RESLastUpdateTime As %Time [ SqlColumnNumber = 44, SqlFieldName = RES_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property RESLastUpdateUserDR As SSUser [ SqlColumnNumber = 45, SqlFieldName = RES_LastUpdateUser_DR ];

/// LastUpdateHospital
Property RESLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 46, SqlFieldName = RES_LastUpdateHospital_DR ];

/// Des Ref UserTranscribed
Property RESUserTranscribedDR As SSUser [ SqlColumnNumber = 47, SqlFieldName = RES_UserTranscribed_DR ];

/// VoiceLength
Property RESVoiceLength As %Float [ SqlColumnNumber = 48, SqlFieldName = RES_VoiceLength ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdResult","OnAfterDelete")
 d Table^HL7Outbound("OEOrdResult",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 if '$d(%session),$d(%d(5)) s gUserRowId=$g(%d(5))
 d ##Class(User.OEOrdResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdResult","OnAfterInsert")
 d ##Class(web.OEOrdResult).SetParentResultStatus($g(%d(0)))
 d Table^HL7Outbound("OEOrdResult",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 if '$d(%session),$d(%d(45)) s gUserRowId=$g(%d(45))
 d ##Class(User.OEOrdResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdResult","OnAfterUpdate")
 d ##Class(web.OEOrdResult).SetParentResultStatus($g(%d(0)))
 d Table^HL7Outbound("OEOrdResult",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdResult).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdResult","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdResult).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdResult","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1274</ExtentSize>
<Property name="RESAbnormal">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESArchive">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESCPReportedDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESCPVerifiedDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESCTCPDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RESChildsub">
<Selectivity>6.2437%</Selectivity>
</Property>
<Property name="RESDICOMPatientID">
<Selectivity>0.2797%</Selectivity>
</Property>
<Property name="RESDICOMSOPInstanceUID">
<Selectivity>9.9999%</Selectivity>
</Property>
<Property name="RESDICOMSeriesInstanceUID">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESDICOMSeriesModality">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESDICOMSeriesNumber">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESDICOMStudyAccessionNo">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RESDICOMStudyID">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RESDICOMStudyInstanceUID">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RESDateCreated">
<Selectivity>0.8642%</Selectivity>
</Property>
<Property name="RESDateRead">
<Selectivity>9.0906%</Selectivity>
</Property>
<Property name="RESDateUnread">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESDateVerified">
<Selectivity>4.5130%</Selectivity>
</Property>
<Property name="RESDeliveryDate">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESDeliveryTime">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESDesc">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="RESFileName">
<Selectivity>0.1458%</Selectivity>
</Property>
<Property name="RESLastUpdateDate">
<Selectivity>3.1169%</Selectivity>
</Property>
<Property name="RESLastUpdateHospitalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESLastUpdateTime">
<Selectivity>2.4455%</Selectivity>
</Property>
<Property name="RESLastUpdateUserDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESName">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="RESNonSTDRepIssReasonDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESOverridePath">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESParRef">
<Selectivity>0.2797%</Selectivity>
</Property>
<Property name="RESPriorityDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RESRecDepDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="RESReportNotExpected">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESResStatDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RESTag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESText">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESTimeCreated">
<Selectivity>0.1748%</Selectivity>
</Property>
<Property name="RESTimeRead">
<Selectivity>2.8004%</Selectivity>
</Property>
<Property name="RESTimeUnread">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESTimeVerified">
<Selectivity>3.7842%</Selectivity>
</Property>
<Property name="RESType">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RESUserCreated">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESUserReadDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESUserTranscribedDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="RESUserUnreadDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="RESUserVerified">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RESVoiceLength">
<Selectivity>99.9994%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RES_Abnormal">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="RES_Archive">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RES_CPReported_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="RES_CPVerified_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="RES_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RES_DICOM_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RES_DICOM_SOPInstanceUID">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RES_DICOM_SeriesInstanceUID">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RES_DICOM_SeriesModality">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RES_DICOM_SeriesNumber">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RES_DICOM_StudyAccessionNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RES_DICOM_StudyID">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RES_DICOM_StudyInstanceUID">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RES_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RES_DateRead">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RES_DateUnread">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="RES_DateVerified">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RES_DeliveryDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RES_DeliveryTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RES_Desc">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="RES_FileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RES_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="RES_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="RES_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="RES_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="RES_Name">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RES_NonSTDRepIssReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="RES_OverridePath">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RES_ReportNotExpected">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="RES_ResStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RES_Tag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RES_Text">
<Node>"TXT"</Node>
</Data>
<Data name="RES_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RES_TimeRead">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RES_TimeUnread">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="RES_TimeVerified">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RES_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RES_UserCreated">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RES_UserRead_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="RES_UserTranscribed_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="RES_UserUnread_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="RES_UserVerified">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RES_VoiceLength">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAbnormRes">
<Condition>{RES_Abnormal}["Y"</Condition>
<ConditionFields>RES_Abnormal</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AbnormRes"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccesNo">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccessNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_DICOM_StudyAccessionNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDICOMTag">
<Condition>{RES_Tag}["Y"</Condition>
<ConditionFields>RES_Tag,RES_FileName</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DICOM_Tag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_FileName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateCreated">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_DateCreated}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateVerif">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RESDateVerif"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_DateVerified}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DelDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RES_DeliveryDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_Priority_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFileName">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FileName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_FileName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotArchive">
<Condition>$p({RES_Type},$c(1))="D",{RES_Archive}=""</Condition>
<ConditionFields>RES_Type,RES_Archive</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>30</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DICOM_NotArchive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_FileName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotRead">
<Condition>{RES_DateRead}=""</Condition>
<ConditionFields>RES_DateRead,RES_ResStat_DR</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotRead"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRead">
<Condition>{RES_DateRead}</Condition>
<ConditionFields>RES_DateRead</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WordRead"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResStat">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RES_ResStat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSOPInstanceUID">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SOPInsUID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RES_DICOM_SOPInstanceUID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RES_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
