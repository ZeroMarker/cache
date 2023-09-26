Class User.DHCEQCUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = U_RowID, SqlTableName = DHC_EQCUser, StorageStrategy = SQLStorage ]
{

Index ULoginNameUnqIdx1 On ULoginName [ Unique ];

Parameter EXTENTSIZE = 250;

/// U_ActiveFlag
Property UActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = U_ActiveFlag ];

/// U_Code
Property UCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = U_Code ];

/// U_CreateDate
Property UCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = U_CreateDate ];

/// U_CreateTime
Property UCreateTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = U_CreateTime ];

/// U_CreateUserDR
Property UCreateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = U_CreateUserDR ];

/// U_DateFrom
Property UDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = U_DateFrom ];

/// U_DateLastLogin
Property UDateLastLogin As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = U_DateLastLogin ];

/// U_DateTo
Property UDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = U_DateTo ];

/// U_DefaultLocDR
Property UDefaultLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = U_DefaultLocDR ];

/// U_Email
Property UEmail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = U_Email ];

/// U_ExID
Property UExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = U_ExID ];

/// U_ExType
Property UExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = U_ExType ];

/// U_Fax
Property UFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = U_Fax ];

/// U_GroupDR
Property UGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = U_GroupDR ];

/// U_Hold1
Property UHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = U_Hold1 ];

/// U_Hold2
Property UHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = U_Hold2 ];

/// U_Hold3
Property UHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = U_Hold3 ];

/// U_Hold4
Property UHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = U_Hold4 ];

/// U_Hold5
Property UHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = U_Hold5 ];

/// U_LastUpdateDate
Property ULastUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = U_LastUpdateDate ];

/// U_LastUpdateTime
Property ULastUpdateTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = U_LastUpdateTime ];

/// U_LeaderDR
Property ULeaderDR As User.DHCEQCUser [ SqlColumnNumber = 17, SqlFieldName = U_LeaderDR ];

/// U_LoginName
Property ULoginName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = U_LoginName ];

/// U_LogoinPassword
Property ULogoinPassword As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = U_LogoinPassword ];

/// U_MobilePhone
Property UMobilePhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = U_MobilePhone ];

/// U_Name
Property UName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = U_Name ];

/// U_OfficePhone
Property UOfficePhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = U_OfficePhone ];

/// U_OrganizeID
Property UOrganizeID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = U_OrganizeID ];

/// U_OrganizeType
Property UOrganizeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = U_OrganizeType ];

/// U_PasswordChanged
Property UPasswordChanged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = U_PasswordChanged ];

/// U_QQ
Property UQQ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = U_QQ ];

/// U_Sex
Property USex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = U_Sex ];

/// U_TimeLastLogin
Property UTimeLastLogin As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = U_TimeLastLogin ];

/// U_UserType
Property UUserType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = U_UserType ];

/// U_WeChat
Property UWeChat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = U_WeChat ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCUser",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="U_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="U_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="U_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="U_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="U_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="U_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="U_DateLastLogin">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="U_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="U_DefaultLocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="U_Email">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="U_ExID">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="U_ExType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="U_Fax">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="U_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="U_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="U_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="U_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="U_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="U_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="U_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="U_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="U_LeaderDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="U_LoginName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="U_LogoinPassword">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="U_MobilePhone">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="U_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="U_OfficePhone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="U_OrganizeID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="U_OrganizeType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="U_PasswordChanged">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="U_QQ">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="U_Sex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="U_TimeLastLogin">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="U_UserType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="U_WeChat">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>U_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCUser"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{U_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>U_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ExID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{U_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{U_ExID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{U_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>U_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{U_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{U_GroupDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{U_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexULoginName">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>U_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ULoginName"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{U_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({U_LoginName})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{U_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
