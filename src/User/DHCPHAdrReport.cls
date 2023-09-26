Class User.DHCPHAdrReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRR_RowID, SqlTableName = DHC_PHAdrReport, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHADRREPDIAG As User.DHCPHAdrRepDiag [ Cardinality = children, Inverse = ADRRDADRRParref ];

Relationship ChildDHCPHADRREPIMPINFO As User.DHCPHAdrRepImpInfo [ Cardinality = children, Inverse = ADRRIADRRParref ];

Relationship ChildDHCPHADRREPDRUGITM As User.DHCPHAdrRepDrugItm [ Cardinality = children, Inverse = ADRRDIADRRParref ];

Relationship ChildDHCPHADRREPPROC As User.DHCPHAdrRepProc [ Cardinality = children, Inverse = ADRRPADRRParref ];

Relationship ChildDHCPHADRREPAUDIT As User.DHCPHAdrRepAudit [ Cardinality = children, Inverse = ADRRAADRRParref ];

Relationship ChildDHCPHADRREPEVENT As User.DHCPHAdrRepEvent [ Cardinality = children, Inverse = ADRREADRRParref ];

/// ADRR_Code
Property ADRRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADRR_Code ];

/// ADRR_Date
Property ADRRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ADRR_Date ];

/// ADRR_Priority
Property ADRRPriority As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 4, SqlFieldName = ADRR_Priority ];

/// ADRR_RepType
Property ADRRRepType As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 5, SqlFieldName = ADRR_RepType ];

/// ADRR_DeptType
Property ADRRDeptType As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 6, SqlFieldName = ADRR_DeptType ];

/// ADRR_DeptElse
Property ADRRDeptElse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ADRR_DeptElse ];

/// ADRR_PatID
Property ADRRPatID As User.PAPatMas [ SqlColumnNumber = 8, SqlFieldName = ADRR_PatID ];

/// ADRR_PatName
Property ADRRPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ADRR_PatName ];

/// ADRR_PatSex
Property ADRRPatSex As User.CTSex [ SqlColumnNumber = 10, SqlFieldName = ADRR_PatSex ];

/// ADRR_PatAge
Property ADRRPatAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ADRR_PatAge ];

/// ADRR_PatDOB
Property ADRRPatDOB As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = ADRR_PatDOB ];

/// ADRR_PatNation
Property ADRRPatNation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ADRR_PatNation ];

/// ADRR_PatWeight
Property ADRRPatWeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ADRR_PatWeight ];

/// ADRR_PatContact
Property ADRRPatContact As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ADRR_PatContact ];

/// ADRR_PatMedNo
Property ADRRPatMedNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ADRR_PatMedNo ];

/// ADRR_EventHistory
Property ADRREventHistory As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 17, SqlFieldName = ADRR_EventHistory ];

/// ADRR_EventHistDesc
Property ADRREventHistDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ADRR_EventHistDesc ];

/// ADRR_EventFamily
Property ADRREventFamily As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 19, SqlFieldName = ADRR_EventFamily ];

/// ADRR_EventFamiDesc
Property ADRREventFamiDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ADRR_EventFamiDesc ];

/// ADRR_ADRE_Dr
Property ADRRADREDr As User.DHCPHAdrEvent [ SqlColumnNumber = 21, SqlFieldName = ADRR_ADRE_Dr ];

/// ADRR_DateOccu
Property ADRRDateOccu As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = ADRR_DateOccu ];

/// ADRR_Result
Property ADRRResult As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 23, SqlFieldName = ADRR_Result ];

/// ADRR_ResultDesc
Property ADRRResultDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = ADRR_ResultDesc ];

/// ADRR_DateResult
Property ADRRDateResult As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = ADRR_DateResult ];

/// ADRR_TimeResult
Property ADRRTimeResult As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = ADRR_TimeResult ];

/// ADRR_StopResultt
Property ADRRStopResultt As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 27, SqlFieldName = ADRR_StopResultt ];

/// ADRR_TakingAgain
Property ADRRTakingAgain As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 28, SqlFieldName = ADRR_TakingAgain ];

/// ADRR_EffectOfTreatment
Property ADRREffectOfTreatment As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 29, SqlFieldName = ADRR_EffectOfTreatment ];

/// ADRR_CommentOfUser
Property ADRRCommentOfUser As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 30, SqlFieldName = ADRR_CommentOfUser ];

/// ADRR_UserOfReport
Property ADRRUserOfReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = ADRR_UserOfReport ];

/// ADRR_CommentOfDept
Property ADRRCommentOfDept As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 32, SqlFieldName = ADRR_CommentOfDept ];

/// ADRR_DeptOfReport
Property ADRRDeptOfReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ADRR_DeptOfReport ];

/// ADRR_Telephone
Property ADRRTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ADRR_Telephone ];

/// ADRR_CareerOfRepUser
Property ADRRCareerOfRepUser As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 35, SqlFieldName = ADRR_CareerOfRepUser ];

/// ADRR_CareerOfRepElse
Property ADRRCareerOfRepElse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = ADRR_CareerOfRepElse ];

/// ADRR_EmailOfRepUser
Property ADRREmailOfRepUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = ADRR_EmailOfRepUser ];

/// ADRR_LocOfReporter
Property ADRRLocOfReporter As User.CTLoc [ SqlColumnNumber = 38, SqlFieldName = ADRR_LocOfReporter ];

/// ADRR_ProTitleOfReporter
Property ADRRProTitleOfReporter As User.CTCarPrvTp [ SqlColumnNumber = 39, SqlFieldName = ADRR_ProTitleOfReporter ];

/// ADRR_PosOfReporter
Property ADRRPosOfReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = ADRR_PosOfReporter ];

/// ADRR_Wishes
Property ADRRWishes As User.DHCPHAdrWishes [ SqlColumnNumber = 41, SqlFieldName = ADRR_Wishes ];

/// ADRR_DeptName
Property ADRRDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = ADRR_DeptName ];

/// ADRR_DeptContacts
Property ADRRDeptContacts As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = ADRR_DeptContacts ];

/// ADRR_DeptTel
Property ADRRDeptTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = ADRR_DeptTel ];

/// ADRR_Remark
Property ADRRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = ADRR_Remark ];

/// ADRR_CurStatus_DR
Property ADRRCurStatusDR As User.DHCPHAdrStatus [ SqlColumnNumber = 46, SqlFieldName = ADRR_CurStatus_DR ];

/// ADRR_RepNew
Property ADRRRepNew As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = ADRR_RepNew ];

/// ADRR_DamSit
Property ADRRDamSit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = ADRR_DamSit ];

/// ADRR_RetReason
Property ADRRRetReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = ADRR_RetReason ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRR_ADRE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ADRR_CareerOfRepElse">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ADRR_CareerOfRepUser">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ADRR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRR_CommentOfDept">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ADRR_CommentOfUser">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ADRR_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ADRR_DamSit">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ADRR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRR_DateOccu">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ADRR_DateResult">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ADRR_DeptContacts">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ADRR_DeptElse">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADRR_DeptName">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ADRR_DeptOfReport">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ADRR_DeptTel">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ADRR_DeptType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADRR_EffectOfTreatment">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ADRR_EmailOfRepUser">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ADRR_EventFamiDesc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADRR_EventFamily">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADRR_EventHistDesc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADRR_EventHistory">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADRR_LocOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ADRR_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADRR_PatContact">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADRR_PatDOB">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADRR_PatID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADRR_PatMedNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADRR_PatName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADRR_PatNation">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADRR_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADRR_PatWeight">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADRR_PosOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ADRR_Priority">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADRR_ProTitleOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ADRR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ADRR_RepNew">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ADRR_RepType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADRR_Result">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ADRR_ResultDesc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ADRR_RetReason">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ADRR_StopResultt">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ADRR_TakingAgain">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ADRR_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ADRR_TimeResult">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ADRR_UserOfReport">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ADRR_Wishes">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADRR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatID">
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADRR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatientID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRR_PatID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
