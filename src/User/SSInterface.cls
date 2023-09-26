/// Interface(2304)
Class User.SSInterface Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Interface, StorageStrategy = SQLStorage ]
{

/// Code
Property INTCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INT_Code ];

/// Description
Property INTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INT_Desc ];

/// Interface Type
Property INTInterfaceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = INT_InterfaceType ];

/// Data Direction
Property INTDataDirection As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INT_DataDirection ];

/// Data Type
Property INTDataType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INT_DataType ];

/// Logging Level
Property INTLoggingLevel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = INT_LoggingLevel ];

/// Des Ref Update User
Property INTUpdateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = INT_UpdateUser_DR ];

/// Update Date
Property INTUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = INT_UpdateDate ];

/// Update Time
Property INTUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = INT_UpdateTime ];

/// External Host Name
Property INTExternalHostName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INT_ExternalHostName ];

/// External Host Port
Property INTExternalHostPort As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = INT_ExternalHostPort ];

/// Connection Type
Property INTConnectionType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INT_ConnectionType ];

/// Time Wait Before Connect
Property INTTimeWaitBeforeConnect As %Float [ SqlColumnNumber = 14, SqlFieldName = INT_TimeWaitBeforeConnect ];

/// Time Wait Before Send
Property INTTimeWaitBeforeSend As %Float [ SqlColumnNumber = 15, SqlFieldName = INT_TimeWaitBeforeSend ];

/// Time Wait For Response
Property INTTimeWaitForResponse As %Float [ SqlColumnNumber = 16, SqlFieldName = INT_TimeWaitForResponse ];

/// Time Wait For Complete
Property INTTimeWaitForComplete As %Float [ SqlColumnNumber = 17, SqlFieldName = INT_TimeWaitForComplete ];

/// File Name
Property INTFileName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = INT_FileName ];

/// File Directory
Property INTFileDirectory As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = INT_FileDirectory ];

/// File Polling Interval
Property INTFilePollingInterval As %Float [ SqlColumnNumber = 20, SqlFieldName = INT_FilePollingInterval ];

/// File Multi Records
Property INTFileMultiRecords As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INT_FileMultiRecords ];

/// File Action
Property INTFileAction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = INT_FileAction ];

/// File Move Directory
Property INTFileMoveDirectory As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = INT_FileMoveDirectory ];

/// Cache Script
Property INTCacheScript As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = INT_CacheScript ];

/// Des Ref HL7
Property INTHL7DR As SSHL7 [ SqlColumnNumber = 25, SqlFieldName = INT_HL7_DR ];

/// Action on no response after message is sent
Property INTActionOnNoResponse As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = INT_ActionOnNoResponse ];

/// Max. No. of response timeouts allowed
Property INTMaxResponse As %Float [ SqlColumnNumber = 27, SqlFieldName = INT_MaxResponse ];

/// Action on max. no. of responses timeouts
Property INTActionOnMaxResponse As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = INT_ActionOnMaxResponse ];

/// Action on NAK response
Property INTActionOnNAKResponse As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = INT_ActionOnNAKResponse ];

/// Max. No. of NAK responses allowed
Property INTMaxNAKsResp As %Float [ SqlColumnNumber = 30, SqlFieldName = INT_MaxNAKsResp ];

/// Action on max. No. of NAK responses
Property INTActionOnMaxNAKsResp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = INT_ActionOnMaxNAKsResp ];

/// Max. No. of NAK send retries
Property INTMaxNAKSend As %Float [ SqlColumnNumber = 32, SqlFieldName = INT_MaxNAKSend ];

/// Action on max. No. of NAK send retries
Property INTActionOnMaxNAKSend As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = INT_ActionOnMaxNAKSend ];

/// Max. No. of read timeouts allowed
Property INTMaxRead As %Float [ SqlColumnNumber = 34, SqlFieldName = INT_MaxRead ];

/// Action on max. No. of read timeouts
Property INTActionOnMaxRead As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = INT_ActionOnMaxRead ];

/// Email Notification From
Property INTEmailNotificationFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = INT_EmailNotificationFrom ];

/// Email Notification To
Property INTEmailNotificationTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = INT_EmailNotificationTo ];

/// Unix OS used
Property INTUnixOS As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = INT_UnixOS ];

/// Time Wait Port Connect
Property INTTimeWaitPortConnect As %Float [ SqlColumnNumber = 39, SqlFieldName = INT_TimeWaitPortConnect ];

/// Time Wait Client Connect
Property INTTimeWaitClientConnect As %Float [ SqlColumnNumber = 40, SqlFieldName = INT_TimeWaitClientConnect ];

/// Time Wait Client Send
Property INTTimeWaitClientSend As %Float [ SqlColumnNumber = 41, SqlFieldName = INT_TimeWaitClientSend ];

/// Max Number Records Per File Outbound
Property INTNumRecordsPerFile As %Float [ SqlColumnNumber = 42, SqlFieldName = INT_NumRecordsPerFile ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSInterface).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterface","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSInterface).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterface","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSInterface).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterface","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSInterface).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterface","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSInterface).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterface","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterface","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="INTActionOnMaxNAKSend">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTActionOnMaxNAKsResp">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTActionOnMaxRead">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTActionOnMaxResponse">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTActionOnNAKResponse">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTActionOnNoResponse">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTCacheScript">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="INTCode">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="INTConnectionType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTDataDirection">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTDataType">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTDesc">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="INTEmailNotificationFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTEmailNotificationTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTExternalHostName">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="INTExternalHostPort">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="INTFileAction">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTFileDirectory">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="INTFileMoveDirectory">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTFileMultiRecords">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTFileName">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTFilePollingInterval">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTHL7DR">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="INTInterfaceType">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTLoggingLevel">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTMaxNAKSend">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTMaxNAKsResp">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTMaxRead">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTMaxResponse">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTNumRecordsPerFile">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitBeforeConnect">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitBeforeSend">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitClientConnect">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitClientSend">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitForComplete">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitForResponse">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTTimeWaitPortConnect">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTUnixOS">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTUpdateDate">
<Selectivity>5.5556%</Selectivity>
</Property>
<Property name="INTUpdateTime">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="INTUpdateUserDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^SST("INT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INT_ActionOnMaxNAKSend">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INT_ActionOnMaxNAKsResp">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INT_ActionOnMaxRead">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INT_ActionOnMaxResponse">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INT_ActionOnNAKResponse">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INT_ActionOnNoResponse">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INT_CacheScript">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INT_ConnectionType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INT_DataDirection">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INT_DataType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INT_EmailNotificationFrom">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INT_EmailNotificationTo">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INT_ExternalHostName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INT_ExternalHostPort">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INT_FileAction">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INT_FileDirectory">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INT_FileMoveDirectory">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INT_FileMultiRecords">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INT_FileName">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INT_FilePollingInterval">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INT_HL7_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INT_InterfaceType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INT_LoggingLevel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INT_MaxNAKSend">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INT_MaxNAKsResp">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INT_MaxRead">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INT_MaxResponse">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INT_NumRecordsPerFile">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INT_TimeWaitBeforeConnect">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INT_TimeWaitBeforeSend">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INT_TimeWaitClientConnect">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INT_TimeWaitClientSend">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INT_TimeWaitForComplete">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INT_TimeWaitForResponse">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INT_TimeWaitPortConnect">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INT_UnixOS">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INT_RowId</SqlRowIdName>
<StreamLocation>^User.SSInterfaceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
