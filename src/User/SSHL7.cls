/// SS HL7(1987)
Class User.SSHL7 Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7Code [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSHL7Trace As SSHL7Trace [ Cardinality = children, Inverse = HL7MTParRef ];

Relationship ChildSSHL7Queue As SSHL7Queue [ Cardinality = children, Inverse = HL7MQParRef ];

Relationship ChildSSHL7MessageType As SSHL7MessageType [ Cardinality = children, Inverse = HL7MSGParRef ];

Relationship ChildSSHL7PatNumbers As SSHL7PatNumbers [ Cardinality = children, Inverse = HL7PNParRef ];

Relationship ChildSSHL7MessageForwarding As SSHL7MessageForwarding [ Cardinality = children, Inverse = HL7MFParRef ];

Relationship ChildSSHL7Acknowledge As SSHL7Acknowledge [ Cardinality = children, Inverse = HL7ACKParRef ];

Relationship ChildSSHL7OrdNumbers As SSHL7OrdNumbers [ Cardinality = children, Inverse = HL7ONParRef ];

Relationship ChildSSHL7OutboundTables As SSHL7OutboundTables [ Cardinality = children, Inverse = HL7OUTParRef ];

Relationship ChildSSHL7ProcessingRules As SSHL7ProcessingRules [ Cardinality = children, Inverse = HL7PRParRef ];

Relationship ChildSSHL7TextFormatCodes As SSHL7TextFormatCodes [ Cardinality = children, Inverse = HL7TFParRef ];

Relationship ChildSSHL7Query As SSHL7Query [ Cardinality = children, Inverse = HL7QUParRef ];

Relationship ChildSSHL7ResultStatus As SSHL7ResultStatus [ Cardinality = children, Inverse = HL7RSParRef ];

Relationship ChildSSHL7Replay As SSHL7Replay [ Cardinality = children, Inverse = HL7RPParRef ];

Relationship ChildSSHL7MasterFile As SSHL7MasterFile [ Cardinality = children, Inverse = HL7MFDParRef ];

Relationship ChildSSHL7MasterFileMsg As SSHL7MasterFileMsg [ Cardinality = children, Inverse = HL7MFMParRef ];

/// Link Code
Property HL7Code As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7_Code ];

/// Port Range Lower
Property HL7PortRangeLower As %Float [ SqlColumnNumber = 3, SqlFieldName = HL7_PortRangeLower ];

/// Port Range Upper
Property HL7PortRangeUpper As %Float [ SqlColumnNumber = 4, SqlFieldName = HL7_PortRangeUpper ];

/// Delimiters In MSH
Property HL7DelimInMSH As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HL7_DelimInMSH ];

/// Local Application
Property HL7LocalApplication As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HL7_LocalApplication ];

/// Name Of Facility
Property HL7NameOfFacility As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HL7_NameOfFacility ];

/// Remote Application
Property HL7RemoteApplication As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = HL7_RemoteApplication ];

/// Remote Facility Name
Property HL7RemoteFacilityName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HL7_RemoteFacilityName ];

/// Wait Before Send
Property HL7WaitBeforeSend As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = HL7_WaitBeforeSend ];

/// Segment Timeout
Property HL7SegmentTimeout As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = HL7_SegmentTimeout ];

/// Send Processing Mode
Property HL7SendProcessingMode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = HL7_SendProcessingMode ];

/// Received Result Section
Property HL7ReceivedResultSection As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = HL7_ReceivedResultSection ];

/// Verif User Code
Property HL7VerifUserCode As SSUser [ SqlColumnNumber = 14, SqlFieldName = HL7_VerifUserCode ];

/// Send AA ACK if error
Property HL7SendAAACKerror As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = HL7_SendAA_ACK_error ];

/// Mark Results As Read
Property HL7MarkAsRead As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = HL7_MarkAsRead ];

/// Name Fields
Property HL7NameFields As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = HL7_NameFields ];

/// Inbound routine site code
Property HL7RoutineSiteCodeInbound As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = HL7_RoutineSiteCodeInbound ];

/// Outbound routine site code
Property HL7RoutineSiteCodeOutbound As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = HL7_RoutineSiteCodeOutbound ];

/// Default Admission Type
Property HL7DefAdmType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = HL7_DefAdmType ];

/// Default Admission Dept_DR
Property HL7DefAdmDeptDR As CTLoc [ SqlColumnNumber = 21, SqlFieldName = HL7_DefAdmDept_DR ];

/// Default Referring Doctor_Dr
Property HL7DefRefDrDR As PACRefDoctor [ SqlColumnNumber = 22, SqlFieldName = HL7_DefRefDr_DR ];

/// Use MSH App and Fac to extract OrdItem code
Property HL7MSHInboundExtCodeCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = HL7_MSHInboundExtCodeCheck ];

/// Use App and Fac against OrdItem in MSH
Property HL7MSHOutboundExtCodeCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = HL7_MSHOutboundExtCodeCheck ];

/// Device Type
Property HL7DeviceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = HL7_DeviceType ];

/// Sending Application for ACK to inbound msg
Property HL7ACKApplication As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = HL7_ACKApplication ];

/// Line Feed Separator Alternative
Property HL7LineFeedAlternative As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = HL7_LineFeedAlternative ];

/// Sending facility for ACK to inbound msg
Property HL7ACKFacility As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = HL7_ACKFacility ];

/// Date interface started
Property HL7DateStarted As %Date [ SqlColumnNumber = 29, SqlFieldName = HL7_DateStarted ];

/// Version
Property HL7Version As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = HL7_Version ];

/// Date interface stopped
Property HL7DateStopped As %Date [ SqlColumnNumber = 31, SqlFieldName = HL7_DateStopped ];

/// Time interface started
Property HL7TimeStarted As %Time [ SqlColumnNumber = 32, SqlFieldName = HL7_TimeStarted ];

/// Time interface stopped
Property HL7TimeStopped As %Time [ SqlColumnNumber = 33, SqlFieldName = HL7_TimeStopped ];

/// Number of messages since last started
Property HL7MessageCount As %Float [ SqlColumnNumber = 34, SqlFieldName = HL7_MessageCount ];

/// Date of Last Message
Property HL7DateLastMessage As %Date [ SqlColumnNumber = 35, SqlFieldName = HL7_DateLastMessage ];

/// Time of Last Message
Property HL7TimeLastMessage As %Time [ SqlColumnNumber = 36, SqlFieldName = HL7_TimeLastMessage ];

/// Number of days to keep trace
Property HL7DaysTraceKeep As %Float [ SqlColumnNumber = 37, SqlFieldName = HL7_DaysTraceKeep ];

/// Update date
Property HL7UpdateDate As %Date [ SqlColumnNumber = 38, SqlFieldName = HL7_UpdateDate ];

/// Update time
Property HL7UpdateTime As %Time [ SqlColumnNumber = 39, SqlFieldName = HL7_UpdateTime ];

/// Des Ref Hospital
Property HL7UpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 40, SqlFieldName = HL7_UpdateUserHospital_DR ];

/// Des Ref Update user
Property HL7UpdateUserDR As SSUser [ SqlColumnNumber = 41, SqlFieldName = HL7_UpdateUser_DR ];

/// Query Interface
Property HL7QueryInterface As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = HL7_QueryInterface ];

/// Auto start outbound interface
Property HL7AutoStartOutbound As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = HL7_AutoStartOutbound ];

/// ConnectedToEnsemble
Property HL7ConnectedToEnsemble As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = HL7_ConnectedToEnsemble ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.SSHL7).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.SSHL7).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.SSHL7).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.SSHL7).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.SSHL7).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7_ACKApplication">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="HL7_ACKFacility">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="HL7_AutoStartOutbound">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="HL7_ConnectedToEnsemble">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="HL7_DateLastMessage">
<Delimiter>"^"</Delimiter>
<Node>"DATES"</Node>
<Piece>5</Piece>
</Data>
<Data name="HL7_DateStarted">
<Delimiter>"^"</Delimiter>
<Node>"DATES"</Node>
<Piece>1</Piece>
</Data>
<Data name="HL7_DateStopped">
<Delimiter>"^"</Delimiter>
<Node>"DATES"</Node>
<Piece>3</Piece>
</Data>
<Data name="HL7_DaysTraceKeep">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="HL7_DefAdmDept_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HL7_DefAdmType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HL7_DefRefDr_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="HL7_DelimInMSH">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7_DeviceType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="HL7_LineFeedAlternative">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HL7_LocalApplication">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7_MSHInboundExtCodeCheck">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="HL7_MSHOutboundExtCodeCheck">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="HL7_MarkAsRead">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HL7_MessageCount">
<Delimiter>"^"</Delimiter>
<Node>"COUNT"</Node>
<Piece>1</Piece>
</Data>
<Data name="HL7_NameFields">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HL7_NameOfFacility">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HL7_PortRangeLower">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HL7_PortRangeUpper">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7_QueryInterface">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="HL7_ReceivedResultSection">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HL7_RemoteApplication">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HL7_RemoteFacilityName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HL7_RoutineSiteCodeInbound">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HL7_RoutineSiteCodeOutbound">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HL7_SegmentTimeout">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HL7_SendAA_ACK_error">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HL7_SendProcessingMode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HL7_TimeLastMessage">
<Delimiter>"^"</Delimiter>
<Node>"DATES"</Node>
<Piece>6</Piece>
</Data>
<Data name="HL7_TimeStarted">
<Delimiter>"^"</Delimiter>
<Node>"DATES"</Node>
<Piece>2</Piece>
</Data>
<Data name="HL7_TimeStopped">
<Delimiter>"^"</Delimiter>
<Node>"DATES"</Node>
<Piece>4</Piece>
</Data>
<Data name="HL7_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="HL7_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="HL7_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="HL7_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="HL7_VerifUserCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HL7_Version">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="HL7_WaitBeforeSend">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HL7_Code</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{HL7_Code}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
