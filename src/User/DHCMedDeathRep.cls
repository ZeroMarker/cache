Class User.DHCMedDeathRep Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDR_Rowid, SqlTableName = DHC_MedDeathRep, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MDR_PatNo
Property MDRPatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MDR_PatNo ];

/// MDR_MedRecord
Property MDRMedRecord As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MDR_MedRecord ];

/// MDR_Name
Property MDRName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MDR_Name ];

/// MDR_Sex
Property MDRSex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MDR_Sex ];

/// MDR_Identify
Property MDRIdentify As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MDR_Identify ];

/// MDR_Birthday
Property MDRBirthday As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MDR_Birthday ];

/// MDR_Country
Property MDRCountry As User.DHCMedDictory [ SqlColumnNumber = 8, SqlFieldName = MDR_Country ];

/// MDR_Nation
Property MDRNation As User.DHCMedDictory [ SqlColumnNumber = 9, SqlFieldName = MDR_Nation ];

/// MDR_Marital
Property MDRMarital As User.DHCMedDictory [ SqlColumnNumber = 10, SqlFieldName = MDR_Marital ];

/// MDR_Occupation
Property MDROccupation As User.DHCMedDictory [ SqlColumnNumber = 11, SqlFieldName = MDR_Occupation ];

/// MDR_PayMent
Property MDRPayMent As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = MDR_PayMent ];

/// MDR_Education
Property MDREducation As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = MDR_Education ];

/// MDR_Company
Property MDRCompany As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MDR_Company ];

/// MDR_TelPhone
Property MDRTelPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MDR_TelPhone ];

/// MDR_AddrFrom
Property MDRAddrFrom As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MDR_AddrFrom ];

/// MDR_AddrNow
Property MDRAddrNow As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MDR_AddrNow ];

/// MDR_FamName
Property MDRFamName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MDR_FamName ];

/// MDR_FamRelation
Property MDRFamRelation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MDR_FamRelation ];

/// MDR_AddrFam
Property MDRAddrFam As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MDR_AddrFam ];

/// MDR_DeathNo
Property MDRDeathNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MDR_DeathNo ];

/// MDR_Region
Property MDRRegion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MDR_Region ];

/// MDR_Aim
Property MDRAim As User.DHCMedDictory [ SqlColumnNumber = 23, SqlFieldName = MDR_Aim ];

/// MDR_A_reason
Property MDRAreason As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MDR_A_reason ];

/// MDR_A_Interval
Property MDRAInterval As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MDR_A_Interval ];

/// MDR_A_ICD
Property MDRAICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MDR_A_ICD ];

/// MDR_B_Reason
Property MDRBReason As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MDR_B_Reason ];

/// MDR_B_Interval
Property MDRBInterval As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MDR_B_Interval ];

/// MDR_B_ICD
Property MDRBICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MDR_B_ICD ];

/// MDR_C_Reason
Property MDRCReason As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MDR_C_Reason ];

/// MDR_C_Interval
Property MDRCInterval As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MDR_C_Interval ];

/// MDR_C_ICD
Property MDRCICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = MDR_C_ICD ];

/// MDR_D_Reason
Property MDRDReason As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MDR_D_Reason ];

/// MDR_D_Interval
Property MDRDInterval As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MDR_D_Interval ];

/// MDR_D_ICD
Property MDRDICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = MDR_D_ICD ];

/// MDR_BasReason
Property MDRBasReason As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = MDR_BasReason ];

/// MDR_BasICD
Property MDRBasICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = MDR_BasICD ];

/// MDR_Damage
Property MDRDamage As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MDR_Damage ];

/// MDR_DamageICD
Property MDRDamageICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = MDR_DamageICD ];

/// MDR_DiagnoseUnit
Property MDRDiagnoseUnit As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = MDR_DiagnoseUnit ];

/// MDR_DiagnoseBasis
Property MDRDiagnoseBasis As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MDR_DiagnoseBasis ];

/// MDR_DeathDay
Property MDRDeathDay As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = MDR_DeathDay ];

/// MDR_DeathAddr
Property MDRDeathAddr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MDR_DeathAddr ];

/// MDR_Status
Property MDRStatus As User.DHCMedDictory [ SqlColumnNumber = 44, SqlFieldName = MDR_Status ];

/// MDR_Type_DR
Property MDRTypeDR As User.DHCMedDictory [ SqlColumnNumber = 45, SqlFieldName = MDR_Type_DR ];

/// MDR_DeathTime
Property MDRDeathTime As %Library.Time [ SqlColumnNumber = 46, SqlFieldName = MDR_DeathTime ];

/// MDR_RepUsr_DR
Property MDRRepUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = MDR_RepUsr_DR ];

/// MDR_RepDate
Property MDRRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 48, SqlFieldName = MDR_RepDate ];

/// MDR_RepTime
Property MDRRepTime As %Library.Time [ SqlColumnNumber = 49, SqlFieldName = MDR_RepTime ];

/// MDR_CheckUsr_DR
Property MDRCheckUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = MDR_CheckUsr_DR ];

/// MDR_CheckDate
Property MDRCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 51, SqlFieldName = MDR_CheckDate ];

/// MDR_CheckTime
Property MDRCheckTime As %Library.Time [ SqlColumnNumber = 52, SqlFieldName = MDR_CheckTime ];

/// MDR_AuditUsr_DR
Property MDRAuditUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = MDR_AuditUsr_DR ];

/// MDR_AuditDate
Property MDRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = MDR_AuditDate ];

/// MDR_AuditTime
Property MDRAuditTime As %Library.Time [ SqlColumnNumber = 55, SqlFieldName = MDR_AuditTime ];

/// MDR_LoadUsr_DR
Property MDRLoadUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = MDR_LoadUsr_DR ];

/// MDR_LoadDate
Property MDRLoadDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 57, SqlFieldName = MDR_LoadDate ];

/// MDR_LoadTime
Property MDRLoadTime As %Library.Time [ SqlColumnNumber = 58, SqlFieldName = MDR_LoadTime ];

/// MDR_Loc_DR
Property MDRLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = MDR_Loc_DR ];

/// MDR_Demo
Property MDRDemo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = MDR_Demo ];

/// MDR_RepPlace
Property MDRRepPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = MDR_RepPlace ];

/// MDR_Resume
Property MDRResume As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = MDR_Resume ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MDR_A_ICD">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MDR_A_Interval">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MDR_A_reason">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MDR_AddrFam">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MDR_AddrFrom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MDR_AddrNow">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MDR_Aim">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MDR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MDR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MDR_AuditUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MDR_B_ICD">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MDR_B_Interval">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MDR_B_Reason">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MDR_BasICD">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MDR_BasReason">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MDR_Birthday">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MDR_C_ICD">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MDR_C_Interval">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MDR_C_Reason">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MDR_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="MDR_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="MDR_CheckUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="MDR_Company">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MDR_Country">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MDR_D_ICD">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MDR_D_Interval">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MDR_D_Reason">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MDR_Damage">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MDR_DamageICD">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MDR_DeathAddr">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MDR_DeathDay">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MDR_DeathNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MDR_DeathTime">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MDR_Demo">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="MDR_DiagnoseBasis">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MDR_DiagnoseUnit">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MDR_Education">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MDR_FamName">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MDR_FamRelation">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MDR_Identify">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDR_LoadDate">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="MDR_LoadTime">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MDR_LoadUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MDR_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="MDR_Marital">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MDR_MedRecord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDR_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDR_Nation">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MDR_Occupation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MDR_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDR_PayMent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MDR_Region">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MDR_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MDR_RepPlace">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="MDR_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MDR_RepUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MDR_Resume">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="MDR_Sex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDR_Status">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MDR_TelPhone">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MDR_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Global>^DHCMDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MDR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPapmiNo">
<Global>^DHCMDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDR_PatNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepDate">
<Global>^DHCMDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RepDate-Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDR_RepDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDR_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDeathRepS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
