Class User.DHCEQMessages Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = M_RowID, SqlTableName = DHC_EQMessages, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// M_Title
Property MTitle As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = M_Title ];

/// M_MessageType
Property MMessageType As %Library.String(DISPLAYLIST = ",普通消息,业务消息,系统消息,公告", MAXLEN = 4, SELECTIVITY = "20.0000%", VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 3, SqlFieldName = M_MessageType ];

/// M_SendType
Property MSendType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = M_SendType ];

/// M_SendMode
Property MSendMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = M_SendMode ];

/// M_SendEmailFlag
Property MSendEmailFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = M_SendEmailFlag ];

/// M_MobileMessageFlag
Property MMobileMessageFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = M_MobileMessageFlag ];

/// M_EmergencyLevelDR
Property MEmergencyLevelDR As User.DHCEQCEmergencyLevel [ SqlColumnNumber = 8, SqlFieldName = M_EmergencyLevelDR ];

/// M_Content
Property MContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = M_Content ];

/// M_Remark
Property MRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = M_Remark ];

/// M_BussType
Property MBussType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = M_BussType ];

/// M_BussID
Property MBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = M_BussID ];

/// M_FromRoleDR
Property MFromRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 13, SqlFieldName = M_FromRoleDR ];

/// M_SourceMessageDR
Property MSourceMessageDR As User.DHCEQMessages [ SqlColumnNumber = 14, SqlFieldName = M_SourceMessageDR ];

/// M_Status
Property MStatus As %Library.String(DISPLAYLIST = ",新增,发送,撤销", MAXLEN = 2, SELECTIVITY = "25.0000%", VALUELIST = ",0,1,2") [ SqlColumnNumber = 15, SqlFieldName = M_Status ];

/// M_SendUserDR
Property MSendUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = M_SendUserDR ];

/// M_SendDate
Property MSendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = M_SendDate ];

/// M_SendTime
Property MSendTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = M_SendTime ];

/// M_RevokeUserDR
Property MRevokeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = M_RevokeUserDR ];

/// M_RevokeDate
Property MRevokeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = M_RevokeDate ];

/// M_RevokeTime
Property MRevokeTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = M_RevokeTime ];

/// M_DealFlag
Property MDealFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = M_DealFlag ];

/// M_DealUserDR
Property MDealUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = M_DealUserDR ];

/// M_DealDate
Property MDealDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = M_DealDate ];

/// M_DealTime
Property MDealTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = M_DealTime ];

/// M_ContactInfo
Property MContactInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = M_ContactInfo ];

/// M_Hold1
Property MHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = M_Hold1 ];

/// M_Hold2
Property MHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = M_Hold2 ];

/// M_Hold3
Property MHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = M_Hold3 ];

/// M_Hold4
Property MHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = M_Hold4 ];

/// M_Hold5
Property MHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = M_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessages("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="M_BussID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="M_BussType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="M_ContactInfo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="M_Content">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="M_DealDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="M_DealFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="M_DealTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="M_DealUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="M_EmergencyLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="M_FromRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="M_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="M_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="M_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="M_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="M_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="M_MessageType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="M_MobileMessageFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="M_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="M_RevokeDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="M_RevokeTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="M_RevokeUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="M_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="M_SendEmailFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="M_SendMode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="M_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="M_SendType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="M_SendUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="M_SourceMessageDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="M_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="M_Title">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQMessages</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{M_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexMessageType">
<Global>^DHCEQMessages</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MessageType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{M_MessageType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{M_BussType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{M_BussID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{M_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessagesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
