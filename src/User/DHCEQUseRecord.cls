Class User.DHCEQUseRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UR_RowID, SqlTableName = DHC_EQUseRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UR_AddDate
Property URAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = UR_AddDate ];

/// UR_AddTime
Property URAddTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = UR_AddTime ];

/// UR_AddUserDR
Property URAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = UR_AddUserDR ];

/// UR_AuditDate
Property URAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = UR_AuditDate ];

/// UR_AuditTime
Property URAuditTime As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = UR_AuditTime ];

/// UR_AuditUser
Property URAuditUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = UR_AuditUser ];

/// UR_CancelDate
Property URCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = UR_CancelDate ];

/// UR_CancelTime
Property URCancelTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = UR_CancelTime ];

/// UR_CancelUser
Property URCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = UR_CancelUser ];

/// UR_DoctorOrderID
Property URDoctorOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = UR_DoctorOrderID ];

/// UR_EndDate
Property UREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = UR_EndDate ];

/// UR_EndTime
Property UREndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = UR_EndTime ];

/// UR_ExID
Property URExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = UR_ExID ];

/// UR_ExType
Property URExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = UR_ExType ];

/// UR_ExposureNum
Property URExposureNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = UR_ExposureNum ];

/// UR_Hold1-->UR_ExecDeptDR
Property URExecDeptDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = UR_ExecDeptDR ];

/// UR_Hold2-->UR_StatFlag
Property URStatFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = UR_StatFlag ];

/// UR_Hold3-->UR_DeviceStatus
Property URDeviceStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = UR_DeviceStatus ];

/// UR_Hold4->UR_AvgTime
Property URAvgTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = UR_AvgTime ];

/// UR_Hold5-->UR_AdmissionType
Property URAdmissionType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = UR_AdmissionType ];

/// UR_InvalidFlag
Property URInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = UR_InvalidFlag ];

/// UR_IsInputFlag
Property URIsInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = UR_IsInputFlag ];

/// UR_ModelDR
Property URModelDR As User.DHCEQCModel [ SqlColumnNumber = 29, SqlFieldName = UR_ModelDR ];

/// UR_Month
Property URMonth As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = UR_Month ];

/// UR_Operator
Property UROperator As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = UR_Operator ];

/// UR_OtherInfo
Property UROtherInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = UR_OtherInfo ];

/// UR_PatientAge
Property URPatientAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = UR_PatientAge ];

/// UR_PatientID
Property URPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UR_PatientID ];

/// UR_PatientName
Property URPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = UR_PatientName ];

/// UR_PatientSex
Property URPatientSex As %Library.String(DISPLAYLIST = ",男,女", MAXLEN = 1, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",M,F") [ SqlColumnNumber = 45, SqlFieldName = UR_PatientSex ];

/// UR_PositiveFlag
Property URPositiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = UR_PositiveFlag ];

/// UR_Price
Property URPrice As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = UR_Price ];

/// UR_Remark
Property URRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = UR_Remark ];

/// UR_SampleNo
Property URSampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = UR_SampleNo ];

/// UR_ServiceItemDR
Property URServiceItemDR As User.DHCEQCServiceItem [ SqlColumnNumber = 16, SqlFieldName = UR_ServiceItemDR ];

/// UR_SourceID
Property URSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UR_SourceID ];

/// UR_SourceType
Property URSourceType As %Library.String(DISPLAYLIST = ",设备,设备项", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 2, SqlFieldName = UR_SourceType ];

/// UR_StartDate
Property URStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = UR_StartDate ];

/// UR_StartTime
Property URStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = UR_StartTime ];

/// UR_Status
Property URStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,报废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 20, SqlFieldName = UR_Status ];

/// UR_SubmitDate
Property URSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = UR_SubmitDate ];

/// UR_SubmitTime
Property URSubmitTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = UR_SubmitTime ];

/// UR_SubmitUser
Property URSubmitUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = UR_SubmitUser ];

/// UR_TotalFee
Property URTotalFee As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = UR_TotalFee ];

/// UR_UpdateDate
Property URUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = UR_UpdateDate ];

/// UR_UpdateTime
Property URUpdateTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = UR_UpdateTime ];

/// UR_UpdateUserDR
Property URUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = UR_UpdateUserDR ];

/// UR_UseDate
Property URUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = UR_UseDate ];

/// UR_UseLocDR
Property URUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UR_UseLocDR ];

/// UR_WorkLoadNum
Property URWorkLoadNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = UR_WorkLoadNum ];

/// UR_WorkLoadUnitDR
Property URWorkLoadUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UR_WorkLoadUnitDR ];

/// UR_Year
Property URYear As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = UR_Year ];

/// UR_OrdDate
Property UROrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = UR_OrdDate ];

/// UR_OrdTime
Property UROrdTime As %Library.Time [ SqlColumnNumber = 55, SqlFieldName = UR_OrdTime ];

/// UR_PreOccurDate
Property URPreOccurDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 56, SqlFieldName = UR_PreOccurDate ];

/// UR_PreOccurTime
Property URPreOccurTime As %Library.Time [ SqlColumnNumber = 57, SqlFieldName = UR_PreOccurTime ];

/// UR_PreDate
Property URPreDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 58, SqlFieldName = UR_PreDate ];

/// UR_PreTime
Property URPreTime As %Library.Time [ SqlColumnNumber = 59, SqlFieldName = UR_PreTime ];

/// UR_RegDate
Property URRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 60, SqlFieldName = UR_RegDate ];

/// UR_RegTime
Property URRegTime As %Library.Time [ SqlColumnNumber = 61, SqlFieldName = UR_RegTime ];

/// UR_ReportDate
Property URReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 62, SqlFieldName = UR_ReportDate ];

/// UR_ReportTime
Property URReportTime As %Library.Time [ SqlColumnNumber = 63, SqlFieldName = UR_ReportTime ];

/// UR_CheckPart
Property URCheckPart As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = UR_CheckPart ];

/// UR_DoctorID
Property URDoctorID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = UR_DoctorID ];

/// UR_RequestDeptDR
Property URRequestDeptDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = UR_RequestDeptDR ];

/// UR_ReportDoctorDR
Property URReportDoctorDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = UR_ReportDoctorDR ];

/// UR_TWorkLoadNum
Property URTWorkLoadNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = UR_TWorkLoadNum ];

/// UR_Hold1
Property URHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = UR_Hold1 ];

/// UR_Hold2
Property URHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = UR_Hold2 ];

/// UR_Hold3
Property URHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = UR_Hold3 ];

/// UR_Hold4
Property URHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = UR_Hold4 ];

/// UR_Hold5
Property URHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = UR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUseRecord("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="UR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UR_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="UR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="UR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="UR_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="UR_AvgTime">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="UR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="UR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="UR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="UR_CheckPart">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="UR_DeviceStatus">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="UR_DoctorID">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="UR_DoctorOrderID">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="UR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UR_ExID">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UR_ExType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UR_ExecDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="UR_ExposureNum">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="UR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="UR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="UR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="UR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="UR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="UR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UR_IsInputFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UR_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="UR_Month">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UR_Operator">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="UR_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="UR_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="UR_OtherInfo">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="UR_PatientAge">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="UR_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UR_PatientName">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="UR_PatientSex">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="UR_PositiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="UR_PreDate">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="UR_PreOccurDate">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="UR_PreOccurTime">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="UR_PreTime">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="UR_Price">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UR_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="UR_RegTime">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="UR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UR_ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="UR_ReportDoctorDR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="UR_ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="UR_RequestDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="UR_SampleNo">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="UR_ServiceItemDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UR_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="UR_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UR_StatFlag">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="UR_Status">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="UR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="UR_SubmitUser">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="UR_TWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="UR_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="UR_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UR_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UR_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UR_Year">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQUseRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAddDate">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_AddDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancelDate">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CancelDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_CancelDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_UseLocDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipService">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipService"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipServiceDate">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipServiceDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UR_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UR_UseDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ExID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_ExType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_ExID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExposureNum">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RwoID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExposureNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UR_ExType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UR_SampleNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{UR_ExposureNum}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHold1">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrderID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_ExType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_DoctorOrderID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_ExID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Service"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServicePatient">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceServicePatient"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UR_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UR_PatientID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceCancel">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceCancel"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_CancelDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceDate">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_UseDate}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseDate">
<Global>^DHCEQUseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UR_UseDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UR_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UR_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUseRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
