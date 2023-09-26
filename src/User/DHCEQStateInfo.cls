Class User.DHCEQStateInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SI_RowID, SqlTableName = DHC_EQStateInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SI_AddDate
Property SIAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = SI_AddDate ];

/// SI_AddTime
Property SIAddTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = SI_AddTime ];

/// SI_AddUserDR
Property SIAddUserDR As User.DHCEQCUser [ SqlColumnNumber = 20, SqlFieldName = SI_AddUserDR ];

/// SI_AgeDay
Property SIAgeDay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = SI_AgeDay ];

/// SI_AgeMth
Property SIAgeMth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = SI_AgeMth ];

/// SI_AgeYr
Property SIAgeYr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = SI_AgeYr ];

/// SI_AuditDate
Property SIAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = SI_AuditDate ];

/// SI_AuditTime
Property SIAuditTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = SI_AuditTime ];

/// SI_AuditUserDR
Property SIAuditUserDR As User.DHCEQCUser [ SqlColumnNumber = 29, SqlFieldName = SI_AuditUserDR ];

/// SI_BedNo
Property SIBedNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = SI_BedNo ];

/// SI_DisinfectFlag
Property SIDisinfectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = SI_DisinfectFlag ];

/// SI_Disinfector
Property SIDisinfector As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = SI_Disinfector ];

/// SI_EndDate
Property SIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = SI_EndDate ];

/// SI_EndState
Property SIEndState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SI_EndState ];

/// SI_EndStateInfo
Property SIEndStateInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SI_EndStateInfo ];

/// SI_EndTime
Property SIEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = SI_EndTime ];

/// SI_EQName
Property SIEQName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = SI_EQName ];

/// SI_EquipDR
Property SIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = SI_EquipDR ];

/// SI_Hold1
Property SIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = SI_Hold1 ];

/// SI_Hold2
Property SIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = SI_Hold2 ];

/// SI_Hold3
Property SIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = SI_Hold3 ];

/// SI_Hold4
Property SIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = SI_Hold4 ];

/// SI_Hold5
Property SIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = SI_Hold5 ];

/// SI_Humidity
Property SIHumidity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = SI_Humidity ];

/// SI_InvalidFlag
Property SIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = SI_InvalidFlag ];

/// SI_Location
Property SILocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = SI_Location ];

/// SI_ModelDR
Property SIModelDR As User.DHCEQCModel [ SqlColumnNumber = 34, SqlFieldName = SI_ModelDR ];

/// SI_No
Property SINo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = SI_No ];

/// SI_NoType
Property SINoType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = SI_NoType ];

/// SI_Nurse
Property SINurse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = SI_Nurse ];

/// SI_Origin
Property SIOrigin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = SI_Origin ];

/// SI_PatientID
Property SIPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SI_PatientID ];

/// SI_PatientName
Property SIPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = SI_PatientName ];

/// SI_RecordDate
Property SIRecordDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = SI_RecordDate ];

/// SI_Remark
Property SIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SI_Remark ];

/// SI_Sex
Property SISex As %Library.String(DISPLAYLIST = ",男,女", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 43, SqlFieldName = SI_Sex ];

/// SI_SnNumber
Property SISnNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = SI_SnNumber ];

/// SI_StartDate
Property SIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = SI_StartDate ];

/// SI_StartState
Property SIStartState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SI_StartState ];

/// SI_StartStateInfo
Property SIStartStateInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SI_StartStateInfo ];

/// SI_StartTime
Property SIStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = SI_StartTime ];

/// SI_Status
Property SIStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 18, SqlFieldName = SI_Status ];

/// SI_StoreLocDR
Property SIStoreLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 36, SqlFieldName = SI_StoreLocDR ];

/// SI_SubmitDate
Property SISubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = SI_SubmitDate ];

/// SI_SubmitTime
Property SISubmitTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = SI_SubmitTime ];

/// SI_SubmitUserDR
Property SISubmitUserDR As User.DHCEQCUser [ SqlColumnNumber = 26, SqlFieldName = SI_SubmitUserDR ];

/// SI_Temperature
Property SITemperature As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = SI_Temperature ];

/// SI_TMPFileNo
Property SITMPFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = SI_TMPFileNo ];

/// SI_TotalTime
Property SITotalTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SI_TotalTime ];

/// SI_Type
Property SIType As %Library.String(DISPLAYLIST = ",运行,故障", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 2, SqlFieldName = SI_Type ];

/// SI_UpdateDate
Property SIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = SI_UpdateDate ];

/// SI_UpdateTime
Property SIUpdateTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = SI_UpdateTime ];

/// SI_UpdateUserDR
Property SIUpdateUserDR As User.DHCEQCUser [ SqlColumnNumber = 23, SqlFieldName = SI_UpdateUserDR ];

/// SI_UseContent
Property SIUseContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SI_UseContent ];

/// SI_UseLocDR
Property SIUseLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 40, SqlFieldName = SI_UseLocDR ];

/// SI_UserDR
Property SIUserDR As User.DHCEQCUser [ SqlColumnNumber = 15, SqlFieldName = SI_UserDR ];

/// SI_WardCode
Property SIWardCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = SI_WardCode ];

/// SI_WardName
Property SIWardName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = SI_WardName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQStateInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SI_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SI_AgeDay">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SI_AgeMth">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SI_AgeYr">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SI_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SI_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SI_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SI_BedNo">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SI_DisinfectFlag">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="SI_Disinfector">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="SI_EQName">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SI_EndState">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SI_EndStateInfo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SI_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="SI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="SI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="SI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="SI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="SI_Humidity">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SI_Location">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="SI_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SI_No">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="SI_NoType">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SI_Nurse">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="SI_Origin">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SI_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SI_PatientName">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SI_RecordDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SI_Sex">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SI_SnNumber">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SI_StartState">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SI_StartStateInfo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SI_Status">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SI_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SI_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SI_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SI_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SI_TMPFileNo">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SI_Temperature">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SI_TotalTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SI_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SI_UseContent">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SI_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SI_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SI_WardCode">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SI_WardName">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Global>^DHCEQStateInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCEQStateInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SI_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQStateInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SI_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SI_EquipDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQStateInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStateInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
