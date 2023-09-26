/// OE HL7 Messages(1837)
Class User.OEHL7Messages Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_HL7Messages, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1769;

/// Link ID
Property HL7LinkID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HL7_LinkID ];

/// Reg No
Property HL7RegNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7_RegNo ];

/// External Request No
Property HL7ExtRequestNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HL7_ExtRequestNo ];

/// Patient Name
Property HL7PatName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HL7_PatName ];

/// Patient DOB
Property HL7PatDOB As %Date [ SqlColumnNumber = 6, SqlFieldName = HL7_PatDOB ];

/// Sex
Property HL7Sex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HL7_Sex ];

/// Test Code
Property HL7TestCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = HL7_TestCode ];

/// Date Received
Property HL7DateReceived As %Date [ SqlColumnNumber = 9, SqlFieldName = HL7_DateReceived ];

/// Time Received
Property HL7TimeReceived As %Time [ SqlColumnNumber = 10, SqlFieldName = HL7_TimeReceived ];

/// Des Ref User
Property HL7UserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = HL7_User_DR ];

/// Date Acknowledged
Property HL7DateAcknow As %Date [ SqlColumnNumber = 12, SqlFieldName = HL7_DateAcknow ];

/// Time Acknowledged
Property HL7TimeAcknow As %Time [ SqlColumnNumber = 13, SqlFieldName = HL7_TimeAcknow ];

/// Reason For Failure
Property HL7ReasonForFailure As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = HL7_ReasonForFailure ];

/// Filler Number
Property HL7FillerNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = HL7_FillerNumber ];

/// File
Property HL7File As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = HL7_File ];

/// Record
Property HL7Record As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = HL7_Record ];

/// Upload No
Property HL7UploadNo As %Float [ SqlColumnNumber = 18, SqlFieldName = HL7_UploadNo ];

/// Event Message Type
Property HL7MessageType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = HL7_MessageType ];

/// Version
Property HL7Version As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = HL7_Version ];

/// Key Value1
Property HL7KeyValue1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = HL7_KeyValue1 ];

/// Key Value2
Property HL7KeyValue2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = HL7_KeyValue2 ];

/// Key Value3
Property HL7KeyValue3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = HL7_KeyValue3 ];

/// Des Ref to SS_HL7Trace
Property HL7TraceDR As SSHL7Trace [ SqlColumnNumber = 24, SqlFieldName = HL7_Trace_DR ];

/// Acknowledged
Property HL7Acknowledged As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 25, SqlFieldName = HL7_Acknowledged ];

/// ConnectedToEnsemble
Property HL7ConnectedToEnsemble As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = HL7_ConnectedToEnsemble ];

/// Rejection Type
Property HL7RejectionType As %String(DISPLAYLIST = ",Notification,Rejection", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",N,R") [ SqlColumnNumber = 27, SqlFieldName = HL7_RejectionType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEHL7Messages).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEHL7Messages","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEHL7Messages).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEHL7Messages","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEHL7Messages).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEHL7Messages","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEHL7Messages).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEHL7Messages","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEHL7Messages).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEHL7Messages","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1769</ExtentSize>
<Property name="HL7Acknowledged">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7ConnectedToEnsemble">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7DateAcknow">
<Selectivity>6.6655%</Selectivity>
</Property>
<Property name="HL7DateReceived">
<Selectivity>2.3798%</Selectivity>
</Property>
<Property name="HL7ExtRequestNo">
<Selectivity>7.1422%</Selectivity>
</Property>
<Property name="HL7File">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="HL7FillerNumber">
<Selectivity>7.1422%</Selectivity>
</Property>
<Property name="HL7KeyValue1">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="HL7KeyValue2">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="HL7KeyValue3">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="HL7LinkID">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="HL7MessageType">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="HL7PatDOB">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="HL7PatName">
<Selectivity>3.1701%</Selectivity>
</Property>
<Property name="HL7ReasonForFailure">
<Selectivity>1.3046%</Selectivity>
</Property>
<Property name="HL7Record">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="HL7RegNo">
<Selectivity>3.4044%</Selectivity>
</Property>
<Property name="HL7RejectionType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7Sex">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="HL7TestCode">
<Selectivity>16.6666%</Selectivity>
</Property>
<Property name="HL7TimeAcknow">
<Selectivity>1.0514%</Selectivity>
</Property>
<Property name="HL7TimeReceived">
<Selectivity>0.1479%</Selectivity>
</Property>
<Property name="HL7TraceDR">
<Selectivity>0.2126%</Selectivity>
</Property>
<Property name="HL7UploadNo">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="HL7UserDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="HL7Version">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^OEHL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HL7_Acknowledged">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HL7_ConnectedToEnsemble">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="HL7_DateAcknow">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HL7_DateReceived">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HL7_ExtRequestNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7_File">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HL7_FillerNumber">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HL7_KeyValue1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="HL7_KeyValue2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="HL7_KeyValue3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="HL7_LinkID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HL7_MessageType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HL7_PatDOB">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HL7_PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7_ReasonForFailure">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HL7_Record">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HL7_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7_RejectionType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="HL7_Sex">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HL7_TestCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HL7_TimeAcknow">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HL7_TimeReceived">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HL7_Trace_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="HL7_UploadNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HL7_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HL7_Version">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^OEHL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HL7_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{HL7_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAcknowledged">
<Global>^OEHLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>HL7_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Acknow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({HL7_LinkID})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7_Acknowledged}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HL7_DateReceived}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HL7_TimeReceived}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HL7_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkDate">
<Condition>1</Condition>
<Global>^OEHLi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HL7_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LinkDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({HL7_LinkID})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7_DateReceived}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HL7_UploadNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HL7_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkID">
<Global>^OEHLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>HL7_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LinkID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({HL7_LinkID})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRego">
<Global>^OEHLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>HL7_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RegNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({HL7_RegNo})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRejectionType">
<Global>^OEHLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>HL7_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RejType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({HL7_LinkID})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7_RejectionType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HL7_DateReceived}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HL7_TimeReceived}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HL7_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HL7_RowId</SqlRowIdName>
<StreamLocation>^User.OEHL7MessagesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
