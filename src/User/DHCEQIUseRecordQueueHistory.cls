Class User.DHCEQIUseRecordQueueHistory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URQ_RowID, SqlTableName = DHC_EQIUseRecordQueueHistory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// URQ_AddDate
Property URQAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = URQ_AddDate ];

/// URQ_AddTime
Property URQAddTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = URQ_AddTime ];

/// URQ_CancelFlag
Property URQCancelFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = URQ_CancelFlag ];

/// URQ_DoctorOrderID
Property URQDoctorOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = URQ_DoctorOrderID ];

/// URQ_EndDate
Property URQEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = URQ_EndDate ];

/// URQ_EndTime
Property URQEndTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = URQ_EndTime ];

/// URQ_ExBussID
Property URQExBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = URQ_ExBussID ];

/// URQ_ExDeviceID
Property URQExDeviceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = URQ_ExDeviceID ];

/// URQ_ExItemID
Property URQExItemID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = URQ_ExItemID ];

/// URQ_ExType
Property URQExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = URQ_ExType ];

/// URQ_ExUseLocID
Property URQExUseLocID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = URQ_ExUseLocID ];

/// URQ_ExecuteTimes
Property URQExecuteTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = URQ_ExecuteTimes ];

/// URQ_ExposureNum
Property URQExposureNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = URQ_ExposureNum ];

/// URQ_FinishDate
Property URQFinishDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = URQ_FinishDate ];

/// URQ_FinishTime
Property URQFinishTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = URQ_FinishTime ];

/// URQ_ExecDeptDR
Property URQExecDeptDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = URQ_ExecDeptDR ];

/// URQ_StatFlag
Property URQStatFlag As %Library.String(DISPLAYLIST = ",正常记录,汇总登记", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 36, SqlFieldName = URQ_StatFlag ];

/// URQ_DeviceStatus
Property URQDeviceStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = URQ_DeviceStatus ];

/// URQ_AvgTime
Property URQAvgTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = URQ_AvgTime ];

/// URQ_AdmissionType
Property URQAdmissionType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = URQ_AdmissionType ];

/// URQ_LastExecuteDate
Property URQLastExecuteDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = URQ_LastExecuteDate ];

/// URQ_LastExecuteTime
Property URQLastExecuteTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = URQ_LastExecuteTime ];

/// URQ_Operator
Property URQOperator As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = URQ_Operator ];

/// URQ_OtherInfo
Property URQOtherInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = URQ_OtherInfo ];

/// URQ_PatientAge
Property URQPatientAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = URQ_PatientAge ];

/// URQ_PatientID
Property URQPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = URQ_PatientID ];

/// URQ_PatientName
Property URQPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = URQ_PatientName ];

/// URQ_PatientSex
Property URQPatientSex As %Library.String(DISPLAYLIST = ",男,女", MAXLEN = 1, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",M,F") [ SqlColumnNumber = 24, SqlFieldName = URQ_PatientSex ];

/// URQ_PositiveFlag
Property URQPositiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = URQ_PositiveFlag ];

/// URQ_Price
Property URQPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = URQ_Price ];

/// URQ_Remark
Property URQRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = URQ_Remark ];

/// URQ_SampleNo
Property URQSampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = URQ_SampleNo ];

/// URQ_StartDate
Property URQStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = URQ_StartDate ];

/// URQ_StartTime
Property URQStartTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = URQ_StartTime ];

/// URQ_Status
Property URQStatus As %Library.String(DISPLAYLIST = ",新增,导入出错,导入完成", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 33, SqlFieldName = URQ_Status ];

/// URQ_TotalFee
Property URQTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = URQ_TotalFee ];

/// URQ_UseDate
Property URQUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = URQ_UseDate ];

/// URQ_WorkLoadNum
Property URQWorkLoadNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = URQ_WorkLoadNum ];

/// URQ_OrdDate
Property URQOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 40, SqlFieldName = URQ_OrdDate ];

/// URQ_OrdTime
Property URQOrdTime As %Library.Time [ SqlColumnNumber = 41, SqlFieldName = URQ_OrdTime ];

/// URQ_PreOccurDate
Property URQPreOccurDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = URQ_PreOccurDate ];

/// URQ_PreOccurTime
Property URQPreOccurTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = URQ_PreOccurTime ];

/// URQ_PreDate
Property URQPreDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = URQ_PreDate ];

/// URQ_PreTime
Property URQPreTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = URQ_PreTime ];

/// URQ_RegDate
Property URQRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = URQ_RegDate ];

/// URQ_RegTime
Property URQRegTime As %Library.Time [ SqlColumnNumber = 47, SqlFieldName = URQ_RegTime ];

/// URQ_ReportDate
Property URQReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 48, SqlFieldName = URQ_ReportDate ];

/// URQ_ReportTime
Property URQReportTime As %Library.Time [ SqlColumnNumber = 49, SqlFieldName = URQ_ReportTime ];

/// URQ_CheckPart
Property URQCheckPart As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = URQ_CheckPart ];

/// URQ_DoctorID
Property URQDoctorID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = URQ_DoctorID ];

/// URQ_RequestDeptDR
Property URQRequestDeptDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = URQ_RequestDeptDR ];

/// URQ_ReportDoctorDR
Property URQReportDoctorDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = URQ_ReportDoctorDR ];

/// URQ_TWorkLoadNum
Property URQTWorkLoadNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = URQ_TWorkLoadNum ];

/// URQ_Hold1
Property URQHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = URQ_Hold1 ];

/// URQ_Hold2
Property URQHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = URQ_Hold2 ];

/// URQ_Hold3
Property URQHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = URQ_Hold3 ];

/// URQ_Hold4
Property URQHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = URQ_Hold4 ];

/// URQ_Hold5
Property URQHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = URQ_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQIUseRecordQueueHistory("0"))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="URQ_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="URQ_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="URQ_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="URQ_AvgTime">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="URQ_CancelFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="URQ_CheckPart">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="URQ_DeviceStatus">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="URQ_DoctorID">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="URQ_DoctorOrderID">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="URQ_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="URQ_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="URQ_ExBussID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URQ_ExDeviceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URQ_ExItemID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="URQ_ExType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="URQ_ExUseLocID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URQ_ExecDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="URQ_ExecuteTimes">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="URQ_ExposureNum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="URQ_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="URQ_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="URQ_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="URQ_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="URQ_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="URQ_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="URQ_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="URQ_LastExecuteDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="URQ_LastExecuteTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="URQ_Operator">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="URQ_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="URQ_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="URQ_OtherInfo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="URQ_PatientAge">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="URQ_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="URQ_PatientName">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="URQ_PatientSex">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="URQ_PositiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="URQ_PreDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="URQ_PreOccurDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="URQ_PreOccurTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="URQ_PreTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="URQ_Price">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="URQ_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="URQ_RegTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="URQ_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="URQ_ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="URQ_ReportDoctorDR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="URQ_ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="URQ_RequestDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="URQ_SampleNo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="URQ_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="URQ_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="URQ_StatFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="URQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="URQ_TWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="URQ_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="URQ_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="URQ_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQIUseRecordQueueHistory</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>URQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{URQ_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExBussID">
<Global>^DHCEQIUseRecordQueueHistory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>URQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ExBussID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{URQ_ExType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URQ_ExItemID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{URQ_ExBussID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{URQ_CancelFlag}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{URQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExTypeItem">
<Global>^DHCEQIUseRecordQueueHistory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>URQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ExTypeItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{URQ_ExType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URQ_AddDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{URQ_ExItemID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{URQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeBussID">
<Global>^DHCEQIUseRecordQueueHistory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>URQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeBussID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{URQ_ExType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URQ_ExBussID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{URQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseDate">
<Global>^DHCEQIUseRecordQueueHistory</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{URQ_UseDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{URQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQIUseRecordQueueHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
