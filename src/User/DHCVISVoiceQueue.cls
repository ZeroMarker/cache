/// Voice Call Queue
Class User.DHCVISVoiceQueue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_QueueID, SqlTableName = DHC_VIS_VoiceQueue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Client RowID
Property VISClientID As User.DHCVISVoiceClient [ SqlColumnNumber = 2, SqlFieldName = VIS_ClientID ];

/// Server RowID
Property VISServerID As User.DHCVISVoiceServer [ SqlColumnNumber = 3, SqlFieldName = VIS_ServerID ];

/// Client Name
Property VISClientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VIS_ClientName ];

/// Server Name
Property VISServerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VIS_ServerName ];

/// Voice Conent
Property VISVoiceContent As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VIS_VoiceContent ];

/// Voice Call State
Property VISState As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = VIS_State ];

/// Voice Type
Property VISType As %Library.String(DISPLAYLIST = ",Adm,Blood,Durg,Lis,Physical,RIS,UIS,Wait,Treat,EIS", MAXLEN = 8, SELECTIVITY = "9.0909%", VALUELIST = ",A,B,D,L,P,R,U,W,T,E") [ SqlColumnNumber = 8, SqlFieldName = VIS_Type ];

/// Voice Call Queue Date
Property VISCreatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = VIS_CreatDate ];

/// Voice Queue Creat Time
Property VISCreatTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = VIS_CreatTime ];

/// Voice Creat User
Property VISCreatUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = VIS_CreatUser ];

/// Update Voice Server RowID
Property VISUpdateServerID As User.DHCVISVoiceServer [ SqlColumnNumber = 12, SqlFieldName = VIS_UpdateServerID ];

/// Queue Update Date
Property VISUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = VIS_UpdateDate ];

/// Queue Update Time 
Property VISUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = VIS_UpdateTime ];

/// Every Date Queue Number
Property VISQueueNo As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = VIS_QueueNo ];

/// Sound Left Or Right
Property VISSound As %Library.String(DISPLAYLIST = ",Left,Right,Default", MAXLEN = 7, SELECTIVITY = "25.0000%", VALUELIST = ",L,R,LR") [ SqlColumnNumber = 16, SqlFieldName = VIS_Sound ];

/// Repeat  flag
Property VISRepeat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = VIS_Repeat ];

/// VIS_ZHScreenStr
Property VISZHScreenStr As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = VIS_ZHScreenStr ];

/// VIS_CKScreenStr
Property VISCKScreenStr As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = VIS_CKScreenStr ];

/// VIS_Note
Property VISNote As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = VIS_Note ];

/// VIS_WaitList
Property VISWaitList As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = VIS_WaitList ];

/// Show State
Property VISShowState As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = VIS_ShowState ];

/// VIS_DocInfo
Property VISDocInfo As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = VIS_DocInfo ];

/// VIS_PatID
Property VISPatID As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = VIS_PatID ];

/// VIS_Note1
Property VISNoteF As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = VIS_NoteF ];

/// VIS_Note2
Property VISNoteS As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = VIS_NoteS ];

/// VIS_Note3
Property VISNoteT As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = VIS_NoteT ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISQueue)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_CKScreenStr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="VIS_ClientID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_ClientName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VIS_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VIS_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="VIS_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VIS_DocInfo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="VIS_Note">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="VIS_NoteF">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="VIS_NoteS">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="VIS_NoteT">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="VIS_PatID">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="VIS_QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIS_Repeat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VIS_ServerID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VIS_ServerName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VIS_ShowState">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="VIS_Sound">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VIS_State">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VIS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="VIS_UpdateServerID">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="VIS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="VIS_VoiceContent">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VIS_WaitList">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="VIS_ZHScreenStr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCVISQueue</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClientID">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClientID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ClientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateUser">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_CreatUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateServerQueueNo">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateServerNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_QueueNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateServerShowState">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateServerShowState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_ShowState}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateServerState">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateServerState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_State}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTypeState">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTypeSate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_CreatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_State}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatID">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_PatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerID">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_ServerID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeSateDate">
<Global>^DHCVISQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>VIS_QueueID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeStateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_State}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VIS_CreatDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VIS_QueueID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISVoiceQueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
