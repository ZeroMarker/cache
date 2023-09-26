Class User.DHCPHDrgMisReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMR_RowID, SqlTableName = DHC_PHDrgMisReport, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHDRGMISREPDRGITM As User.DHCPHDrgMisRepDrgItm [ Cardinality = children, Inverse = DMRDIDMRParref ];

/// DMR_RepDate
Property DMRRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DMR_RepDate ];

/// DMR_ErrOccDate
Property DMRErrOccDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DMR_ErrOccDate ];

/// DMR_DisErrDate
Property DMRDisErrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DMR_DisErrDate ];

/// DMR_DspToPat
Property DMRDspToPat As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 5, SqlFieldName = DMR_DspToPat ];

/// DMR_PatTaked
Property DMRPatTaked As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 6, SqlFieldName = DMR_PatTaked ];

/// DMR_ErrorLevel
Property DMRErrorLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DMR_ErrorLevel ];

/// DMR_PatID
Property DMRPatID As User.PAPatMas [ SqlColumnNumber = 8, SqlFieldName = DMR_PatID ];

/// DMR_PatName
Property DMRPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DMR_PatName ];

/// DMR_PatSex
Property DMRPatSex As User.CTSex [ SqlColumnNumber = 10, SqlFieldName = DMR_PatSex ];

/// DMR_PatAge
Property DMRPatAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DMR_PatAge ];

/// DMR_PatDOB
Property DMRPatDOB As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DMR_PatDOB ];

/// DMR_PatWeight
Property DMRPatWeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DMR_PatWeight ];

/// DMR_PatContact
Property DMRPatContact As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DMR_PatContact ];

/// DMR_PatMedNo
Property DMRPatMedNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DMR_PatMedNo ];

/// DMR_ICDDesc
Property DMRICDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DMR_ICDDesc ];

/// DMR_HarmRet
Property DMRHarmRet As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DMR_HarmRet ];

/// DMR_HarmRetDesc
Property DMRHarmRetDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DMR_HarmRetDesc ];

/// DMR_DeathDate
Property DMRDeathDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = DMR_DeathDate ];

/// DMR_DeathTime
Property DMRDeathTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DMR_DeathTime ];

/// DMR_Rescue
Property DMRRescue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DMR_Rescue ];

/// DMR_ResMeasDesc
Property DMRResMeasDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DMR_ResMeasDesc ];

/// DMR_RecProc
Property DMRRecProc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DMR_RecProc ];

/// DMR_RepUser
Property DMRRepUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DMR_RepUser ];

/// DMR_DeptOfReporter
Property DMRDeptOfReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DMR_DeptOfReporter ];

/// DMR_ProTitleOfReporter
Property DMRProTitleOfReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DMR_ProTitleOfReporter ];

/// DMR_TelOfReporter
Property DMRTelOfReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DMR_TelOfReporter ];

/// DMR_EmailOfReporter
Property DMREmailOfReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DMR_EmailOfReporter ];

/// DMR_PostCode
Property DMRPostCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DMR_PostCode ];

/// DMR_ErrHappSite
Property DMRErrHappSite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DMR_ErrHappSite ];

/// DMR_ErrHappSiteDesc
Property DMRErrHappSiteDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DMR_ErrHappSiteDesc ];

/// DMR_TriErrUser
Property DMRTriErrUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DMR_TriErrUser ];

/// DMR_TriErrUserDesc
Property DMRTriErrUserDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DMR_TriErrUserDesc ];

/// DMR_DisErrUser
Property DMRDisErrUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DMR_DisErrUser ];

/// DMR_DisErrUserDesc
Property DMRDisErrUserDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DMR_DisErrUserDesc ];

/// DMR_ErrRelUser
Property DMRErrRelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DMR_ErrRelUser ];

/// DMR_ErrRelUserDesc
Property DMRErrRelUserDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = DMR_ErrRelUserDesc ];

/// DMR_DisAndHandMea
Property DMRDisAndHandMea As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DMR_DisAndHandMea ];

/// DMR_ProDrgRelInfo
Property DMRProDrgRelInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = DMR_ProDrgRelInfo ];

/// DMR_DrgRelInfoDesc
Property DMRDrgRelInfoDesc As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = DMR_DrgRelInfoDesc ];

/// DMR_PreSuggest
Property DMRPreSuggest As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = DMR_PreSuggest ];

/// DMR_ErrContent
Property DMRErrContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = DMR_ErrContent ];

/// DMR_TriErrFac
Property DMRTriErrFac As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = DMR_TriErrFac ];

/// DMR_RepCode
Property DMRRepCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = DMR_RepCode ];

/// DMR_ErrHappProcess
Property DMRErrHappProcess As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = DMR_ErrHappProcess ];

/// DMR_CurStatus_DR  -liyarong 2016-09-18
Property DMRCurStatusDr As %Library.String [ SqlColumnNumber = 46, SqlFieldName = DMR_CurStatus_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDMR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DMR_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="DMR_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DMR_DeathTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DMR_DeptOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DMR_DisAndHandMea">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DMR_DisErrDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DMR_DisErrUser">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DMR_DisErrUserDesc">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DMR_DrgRelInfoDesc">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DMR_DspToPat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DMR_EmailOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DMR_ErrContent">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DMR_ErrHappProcess">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="DMR_ErrHappSite">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DMR_ErrHappSiteDesc">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DMR_ErrOccDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMR_ErrRelUser">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DMR_ErrRelUserDesc">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DMR_ErrorLevel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DMR_HarmRet">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DMR_HarmRetDesc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DMR_ICDDesc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DMR_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DMR_PatContact">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DMR_PatDOB">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DMR_PatID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DMR_PatMedNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DMR_PatName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DMR_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DMR_PatTaked">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMR_PatWeight">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DMR_PostCode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DMR_PreSuggest">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DMR_ProDrgRelInfo">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DMR_ProTitleOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DMR_RecProc">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DMR_RepCode">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="DMR_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMR_RepUser">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DMR_ResMeasDesc">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DMR_Rescue">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DMR_TelOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DMR_TriErrFac">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DMR_TriErrUser">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DMR_TriErrUserDesc">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Global>^DHCPHDMR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DMR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DMR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHDMR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DMR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMR_RepDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDrgMisReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
