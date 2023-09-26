/// Configuration for RT     (RTCF,660)
Class User.CFRT Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_RT, StorageStrategy = SQLStorage ]
{

Relationship ChildCFRTHospMRType As CFRTHospMRType [ Cardinality = children, Inverse = MRTYPEParRef ];

/// Whether is single or multiple volumn
Property RTCFVolumnFlag As %String(DISPLAYLIST = ",Single,Multiple", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",S,M") [ SqlColumnNumber = 2, SqlFieldName = RTCF_VolumnFlag ];

/// No of medical record
Property RTCFNoMR As %String(DISPLAYLIST = ",One,Two", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 3, SqlFieldName = RTCF_NoMR ];

/// Expected Days of Use
Property RTCFExpectDayOfUse As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 4, SqlFieldName = RTCF_ExpectDayOfUse ];

/// Default Home Location (Des Ref CTLOC)
Property RTCFDefaultHomeLocDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = RTCF_DefaultHomeLoc_DR ];

/// Auto Transfer to next request on return
Property RTCFAutoTransfer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RTCF_AutoTransfer ];

/// Description
Property RTCFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = RTCF_Description ];

/// Last Update Date
Property RTCFUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = RTCF_UpdateDate ];

/// Last Update Time
Property RTCFUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = RTCF_UpdateTime ];

/// Last Update User
Property RTCFUpdateUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 10, SqlFieldName = RTCF_UpdateUser_DR ];

/// Deaprtment Need to Acknowledge their MR
Property RTCFAcknowledgeRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = RTCF_AcknowledgeRequired ];

/// Logon Department is MRO (cannot modify)
Property RTCFLogonDeptIsMRO As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = RTCF_LogonDeptIsMRO ];

/// Can Modify Logon Department ?
Property RTCFModifyLogonDept As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = RTCF_ModifyLogonDept ];

/// Interface with PA module
Property RTCFPAinterface As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = RTCF_PAinterface ];

/// MR No Policy
Property RTCFMRNoPolicy As %String(DISPLAYLIST = ",Patient ID,Patient No,System Generate", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",I,P,S") [ SqlColumnNumber = 15, SqlFieldName = RTCF_MRNoPolicy ];

/// Des Ref to MRecordParts
Property RTCFInPatientVolumeDR As RTCMRecordParts [ SqlColumnNumber = 16, SqlFieldName = RTCF_InPatientVolume_DR ];

/// Des Ref to MRecord Parts
Property RTCFOutPatientVolumeDR As RTCMRecordParts [ SqlColumnNumber = 17, SqlFieldName = RTCF_OutPatientVolume_DR ];

/// Des Ref RequestReason
Property RTCFRequestReasonAPPTDR As RTCReasonRequest [ SqlColumnNumber = 18, SqlFieldName = RTCF_RequestReason_APPT_DR ];

/// Automatically Print MR BarCode
Property RTCFPrintMRBarCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = RTCF_PrintMRBarCode ];

/// Print MR Request Slip
Property RTCFPrintMRRequestSlip As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = RTCF_PrintMRRequestSlip ];

/// Des Ref MainMRType
Property RTCFMainMRTypeDR As RTCMRecordType [ SqlColumnNumber = 21, SqlFieldName = RTCF_MainMRType_DR ];

/// Des Ref MRVolume
Property RTCFMainMRVolumeDR As RTCMRecordTypeVolumes [ SqlColumnNumber = 22, SqlFieldName = RTCF_MainMRVolume_DR ];

/// Desfault Number of Days To Get MR
Property RTCFDaysToGetMR As %Float [ SqlColumnNumber = 23, SqlFieldName = RTCF_DaysToGetMR ];

/// Bypass Department Medical Records
Property RTCFBypassDepartMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = RTCF_BypassDepartMR ];

/// Resolution
Property RTCFResolution As %Float [ SqlColumnNumber = 25, SqlFieldName = RTCF_Resolution ];

/// Scanned Image Type
Property RTCFScannedImageType As %String(DISPLAYLIST = ",Black and White,Gray scale,4bit,Gray scale,8bit,Palet,4bit,Palet,8bit,RGB,24bit,BGR,24bit", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6,7") [ SqlColumnNumber = 26, SqlFieldName = RTCF_ScannedImageType ];

/// AutoPrintRequest
Property RTCFAutoPrintRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = RTCF_AutoPrintRequest ];

/// Default Reason for WL Requests
Property RTCFDefaultReasonWLRequest As RTCReasonRequest [ SqlColumnNumber = 28, SqlFieldName = RTCF_DefaultReasonWLRequest ];

/// Ask for Request Details
Property RTCFAskReqDetails As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = RTCF_AskReqDetails ];

/// Des Ref RequestReasonAdm
Property RTCFRequestReasonAdmDR As RTCReasonRequest [ SqlColumnNumber = 30, SqlFieldName = RTCF_RequestReasonAdm_DR ];

/// Show Message For ResearchReq
Property RTCFShowMessageForResearchReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = RTCF_ShowMessageForResearchReq ];

/// Default Reason for ED Requests
Property RTCFDefaultReasEDRequest As RTCReasonRequest [ SqlColumnNumber = 32, SqlFieldName = RTCF_DefaultReasEDRequest ];

/// Inactivate RTVolume on Merging
Property RTCFInactivateRTVolumeMerg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = RTCF_InactivateRTVolumeMerg ];

/// ApptHoldCancelsMRReq
Property RTCFApptHoldCancelsMRReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = RTCF_ApptHoldCancelsMRReq ];

/// ViewRequestDefaultLoc
Property RTCFViewRequestDefaultLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = RTCF_ViewRequestDefaultLoc ];

/// CreateNextVol
Property RTCFCreateNextVol As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = RTCF_CreateNextVol ];

/// ViewAllVolumes
Property RTCFViewAllVolumes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = RTCF_ViewAllVolumes ];

/// OnlyInactMRNLogHospMerg
Property RTCFOnlyInactMRNLogHospMerg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = RTCF_OnlyInactMRNLogHospMerg ];

/// Mark MRN Inactive Upon Patient Merge
Property RTCFMarkMRNInactivePatMerge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = RTCF_MarkMRNInactivePatMerge ];

/// Don't Display unverif Msg on move to home loc
Property RTCFNoShowUVMsgOnMoveMRToHomeLo As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = RTCF_NoShowUVMsgOnMoveMRToHomeLoc ];

/// Auto MR Request To New Volume
Property RTCFAutoMRRequestToNewVolume As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = RTCF_AutoMRRequestToNewVolume ];

/// Disable VB Auto Request
Property RTCFDisableVBAutoRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = RTCF_DisableVBAutoRequest ];

/// ReturnMRTHomeFirst
Property RTCFReturnMRTHomeFirst As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = RTCF_ReturnMRTHomeFirst ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFRT).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRT","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFRT).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRT","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFRT).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRT","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFRT).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRT","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRT","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFRT).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRT","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("RT",0))</SqlIdExpression>
<SQLMap name="DataMasterCFRT">
<Data name="RTCF_AcknowledgeRequired">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RTCF_ApptHoldCancelsMRReq">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="RTCF_AskReqDetails">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="RTCF_AutoMRRequestToNewVolume">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="RTCF_AutoPrintRequest">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RTCF_AutoTransfer">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTCF_BypassDepartMR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RTCF_CreateNextVol">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="RTCF_DaysToGetMR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RTCF_DefaultHomeLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTCF_DefaultReasEDRequest">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="RTCF_DefaultReasonWLRequest">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="RTCF_Description">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTCF_DisableVBAutoRequest">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="RTCF_ExpectDayOfUse">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTCF_InPatientVolume_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RTCF_InactivateRTVolumeMerg">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="RTCF_LogonDeptIsMRO">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RTCF_MRNoPolicy">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RTCF_MainMRType_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RTCF_MainMRVolume_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RTCF_MarkMRNInactivePatMerge">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="RTCF_ModifyLogonDept">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RTCF_NoMR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTCF_NoShowUVMsgOnMoveMRToHomeLoc">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="RTCF_OnlyInactMRNLogHospMerg">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="RTCF_OutPatientVolume_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RTCF_PAinterface">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RTCF_PrintMRBarCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RTCF_PrintMRRequestSlip">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RTCF_RequestReasonAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="RTCF_RequestReason_APPT_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RTCF_Resolution">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RTCF_ReturnMRTHomeFirst">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="RTCF_ScannedImageType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RTCF_ShowMessageForResearchReq">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="RTCF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTCF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RTCF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RTCF_ViewAllVolumes">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="RTCF_ViewRequestDefaultLoc">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="RTCF_VolumnFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RTCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RTCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFRTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
