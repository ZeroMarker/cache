Class User.DHCEQUseContext Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQUseContext, StorageStrategy = SQLStorage ]
{

/// UC_BenefitSummaryDR
Property UCBenefitSummaryDR As SSUser [ SqlColumnNumber = 2, SqlFieldName = UC_BenefitSummaryDR ];

/// UC_EquipDR
Property UCEquipDR As DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = UC_EquipDR ];

/// UC_Year
Property UCYear As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UC_Year ];

/// UC_Month
Property UCMonth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UC_Month ];

/// UC_ExpectedSatis
Property UCExpectedSatis As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UC_ExpectedSatis ];

/// UC_ActualSatis
Property UCActualSatis As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UC_ActualSatis ];

/// UC_PatientSatis
Property UCPatientSatis As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UC_PatientSatis ];

/// UC_NewFunction
Property UCNewFunction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UC_NewFunction ];

/// UC_SpecialService
Property UCSpecialService As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UC_SpecialService ];

/// UC_OtherSocial
Property UCOtherSocial As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UC_OtherSocial ];

/// UC_GraduateNum
Property UCGraduateNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = UC_GraduateNum ];

/// UC_StaffNum
Property UCStaffNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = UC_StaffNum ];

/// UC_OtherTasks
Property UCOtherTasks As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = UC_OtherTasks ];

/// UC_TotalScore
Property UCTotalScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = UC_TotalScore ];

/// UC_BenefitAnalysis
Property UCBenefitAnalysis As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = UC_BenefitAnalysis ];

/// UC_UseEvaluation
Property UCUseEvaluation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = UC_UseEvaluation ];

/// UC_BriefEvaluation
Property UCBriefEvaluation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = UC_BriefEvaluation ];

/// UC_OverallEvaluation
Property UCOverallEvaluation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = UC_OverallEvaluation ];

/// UC_Income
Property UCIncome As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = UC_Income ];

/// UC_PersonTime
Property UCPersonTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = UC_PersonTime ];

/// UC_ActualWorkLoad
Property UCActualWorkLoad As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = UC_ActualWorkLoad ];

/// UC_PositiveCases
Property UCPositiveCases As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = UC_PositiveCases ];

/// UC_RunTime
Property UCRunTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = UC_RunTime ];

/// UC_FailureTimes
Property UCFailureTimes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = UC_FailureTimes ];

/// UC_MaintTimes
Property UCMaintTimes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = UC_MaintTimes ];

/// UC_PMTimes
Property UCPMTimes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = UC_PMTimes ];

/// UC_DetectionTimes
Property UCDetectionTimes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = UC_DetectionTimes ];

/// UC_WaitingTimes
Property UCWaitingTimes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = UC_WaitingTimes ];

/// UC_AverageWorkHour
Property UCAverageWorkHour As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = UC_AverageWorkHour ];

/// UC_ActualWorkDays
Property UCActualWorkDays As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = UC_ActualWorkDays ];

/// UC_FailureDays
Property UCFailureDays As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = UC_FailureDays ];

/// UC_AddUserDR
Property UCAddUserDR As SSUser [ SqlColumnNumber = 33, SqlFieldName = UC_AddUserDR ];

/// UC_AddDate
Property UCAddDate As %Date [ SqlColumnNumber = 34, SqlFieldName = UC_AddDate ];

/// UC_AddTime
Property UCAddTime As %Time [ SqlColumnNumber = 35, SqlFieldName = UC_AddTime ];

/// UC_UpdateUserDR
Property UCUpdateUserDR As SSUser [ SqlColumnNumber = 36, SqlFieldName = UC_UpdateUserDR ];

/// UC_UpdateDate
Property UCUpdateDate As %Date [ SqlColumnNumber = 37, SqlFieldName = UC_UpdateDate ];

/// UC_UpdateTime
Property UCUpdateTime As %Time [ SqlColumnNumber = 38, SqlFieldName = UC_UpdateTime ];

/// UC_SubmitUserDR
Property UCSubmitUserDR As SSUser [ SqlColumnNumber = 39, SqlFieldName = UC_SubmitUserDR ];

/// UC_SubmitDate
Property UCSubmitDate As %Date [ SqlColumnNumber = 40, SqlFieldName = UC_SubmitDate ];

/// UC_SubmitTime
Property UCSubmitTime As %Time [ SqlColumnNumber = 41, SqlFieldName = UC_SubmitTime ];

/// UC_AuditUserDR
Property UCAuditUserDR As SSUser [ SqlColumnNumber = 42, SqlFieldName = UC_AuditUserDR ];

/// UC_AuditDate
Property UCAuditDate As %Date [ SqlColumnNumber = 43, SqlFieldName = UC_AuditDate ];

/// UC_AuditTime
Property UCAuditTime As %Time [ SqlColumnNumber = 44, SqlFieldName = UC_AuditTime ];

/// UC_InvalidFlag
Property UCInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = UC_InvalidFlag ];

/// UC_Status
Property UCStatus As %String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 46, SqlFieldName = UC_Status ];

/// UC_Hold1
Property UCHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = UC_Hold1 ];

/// UC_Hold2
Property UCHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = UC_Hold2 ];

/// UC_Hold3
Property UCHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = UC_Hold3 ];

/// UC_Hold4
Property UCHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = UC_Hold4 ];

/// UC_Hold5
Property UCHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = UC_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQUseContext("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UC_ActualSatis">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UC_ActualWorkDays">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="UC_ActualWorkLoad">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UC_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="UC_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="UC_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="UC_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="UC_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="UC_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="UC_AverageWorkHour">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="UC_BenefitAnalysis">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UC_BenefitSummaryDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UC_BriefEvaluation">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UC_DetectionTimes">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UC_ExpectedSatis">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UC_FailureDays">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="UC_FailureTimes">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="UC_GraduateNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="UC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="UC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="UC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="UC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="UC_Income">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UC_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="UC_MaintTimes">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="UC_Month">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UC_NewFunction">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UC_OtherSocial">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UC_OtherTasks">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UC_OverallEvaluation">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UC_PMTimes">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UC_PatientSatis">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UC_PersonTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UC_PositiveCases">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UC_RunTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UC_SpecialService">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UC_StaffNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UC_Status">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="UC_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="UC_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="UC_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="UC_TotalScore">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="UC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="UC_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="UC_UseEvaluation">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UC_WaitingTimes">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="UC_Year">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQUseContext</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{UC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBenefitSummary">
<Global>^DHCEQUseContext</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BenefitSummary"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UC_BenefitSummaryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQUseContext</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"EquipYearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{UC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>+{UC_Year}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{UC_Month}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQUseContextS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
