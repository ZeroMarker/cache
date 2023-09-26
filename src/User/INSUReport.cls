Class User.INSUReport Extends (%Library.Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INRPT_Rowid, SqlTableName = INSU_Report, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INRPT_AdmDr
Property INRPTAdmDr As %Library.String(CAPTION = "就诊号", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INRPT_AdmDr ];

/// INRPT_AdmInfoDr
Property INRPTAdmInfoDr As %Library.String(CAPTION = "医保登记表指针", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INRPT_AdmInfoDr ];

/// INRPT_PatNo
Property INRPTPatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INRPT_PatNo ];

/// INRPT_PatName
Property INRPTPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INRPT_PatName ];

/// INRPT_RptType
Property INRPTRptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INRPT_RptType ];

/// INRPT_AdmSeriNo
Property INRPTAdmSeriNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INRPT_AdmSeriNo ];

/// INRPT_RptDate
Property INRPTRptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = INRPT_RptDate ];

/// INRPT_Flag
Property INRPTFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INRPT_Flag ];

/// INRPT_AdmType
Property INRPTAdmType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INRPT_AdmType ];

/// INRPT_DiagCode
Property INRPTDiagCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INRPT_DiagCode ];

/// INRPT_DiagDesc
Property INRPTDiagDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INRPT_DiagDesc ];

/// INRPT_SDate
Property INRPTSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = INRPT_SDate ];

/// INRPT_EDate
Property INRPTEDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INRPT_EDate ];

/// INRPT_RPTNo
Property INRPTRPTNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INRPT_RPTNo ];

/// INRPT_xmbm
Property INRPTxmbm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INRPT_xmbm ];

/// INRPT_xmmc
Property INRPTxmmc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INRPT_xmmc ];

/// INRPT_HisCode
Property INRPTHisCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INRPT_HisCode ];

/// INRPT_HisDesc
Property INRPTHisDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INRPT_HisDesc ];

/// INRPT_xmlb
Property INRPTxmlb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INRPT_xmlb ];

/// INRPT_OutHosName
Property INRPTOutHosName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INRPT_OutHosName ];

/// INRPT_HosLevel
Property INRPTHosLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INRPT_HosLevel ];

/// INRPT_OutType
Property INRPTOutType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INRPT_OutType ];

/// INRPT_money
Property INRPTmoney As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INRPT_money ];

/// INRPT_sl
Property INRPTsl As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INRPT_sl ];

/// INRPT_SYDate
Property INRPTSYDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = INRPT_SYDate ];

/// INRPT_SYYCDate
Property INRPTSYYCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = INRPT_SYYCDate ];

/// INRPT_UserName
Property INRPTUserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INRPT_UserName ];

/// INRPT_Doctor
Property INRPTDoctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INRPT_Doctor ];

/// INRPT_LRUser
Property INRPTLRUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INRPT_LRUser ];

/// INRPT_LRDate
Property INRPTLRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = INRPT_LRDate ];

/// INRPT_NumberID
Property INRPTNumberID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INRPT_NumberID ];

/// INRPT_States
Property INRPTStates As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INRPT_States ];

/// INRPT_HosYJ
Property INRPTHosYJ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INRPT_HosYJ ];

/// INRPT_JSYJ
Property INRPTJSYJ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INRPT_JSYJ ];

/// INRPT_KZRYJ
Property INRPTKZRYJ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INRPT_KZRYJ ];

/// INRPT_KZRName
Property INRPTKZRName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INRPT_KZRName ];

/// INRPT_MD
Property INRPTMD As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INRPT_MD ];

/// INRPT_ZZ
Property INRPTZZ As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INRPT_ZZ ];

/// INRPT_Tel
Property INRPTTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INRPT_Tel ];

/// INRPT_SYFWID
Property INRPTSYFWID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INRPT_SYFWID ];

/// INRPT_BZ
Property INRPTBZ As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INRPT_BZ ];

/// INRPT_String1
Property INRPTString1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INRPT_String1 ];

/// INRPT_String2
Property INRPTString2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INRPT_String2 ];

/// INRPT_String3
Property INRPTString3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INRPT_String3 ];

/// INRPT_String4
Property INRPTString4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = INRPT_String4 ];

/// INRPT_String5
Property INRPTString5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = INRPT_String5 ];

/// INRPT_String6
Property INRPTString6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = INRPT_String6 ];

/// INRPT_String7
Property INRPTString7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = INRPT_String7 ];

/// INRPT_String8
Property INRPTString8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = INRPT_String8 ];

/// INRPT_String9
Property INRPTString9 As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = INRPT_String9 ];

/// INRPT_String10
Property INRPTString10 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = INRPT_String10 ];

/// INRPT_HospDr
Property INRPTHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = INRPT_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^mdata("INSUREPORT"))</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INRPT_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INRPT_AdmInfoDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INRPT_AdmSeriNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRPT_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INRPT_BZ">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INRPT_DiagCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INRPT_DiagDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INRPT_Doctor">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INRPT_EDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INRPT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INRPT_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INRPT_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INRPT_HosLevel">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INRPT_HosYJ">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INRPT_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INRPT_JSYJ">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INRPT_KZRName">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INRPT_KZRYJ">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INRPT_LRDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INRPT_LRUser">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INRPT_MD">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INRPT_NumberID">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INRPT_OutHosName">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INRPT_OutType">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INRPT_PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INRPT_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRPT_RPTNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INRPT_RptDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INRPT_RptType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRPT_SDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INRPT_SYDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INRPT_SYFWID">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INRPT_SYYCDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INRPT_States">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INRPT_String1">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INRPT_String10">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INRPT_String2">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INRPT_String3">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INRPT_String4">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INRPT_String5">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INRPT_String6">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INRPT_String7">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INRPT_String8">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INRPT_String9">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INRPT_Tel">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INRPT_UserName">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INRPT_ZZ">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INRPT_money">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INRPT_sl">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INRPT_xmbm">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INRPT_xmlb">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INRPT_xmmc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^INSURPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INRPT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INRPT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINSUPatNo">
<Global>^INSURPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRPT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRPT_PatNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INRPT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexInsuTypeRptType">
<Global>^INSURPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRPT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsuType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRPT_String2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RptType"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INRPT_RptType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INRPT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOEORD">
<Global>^INSURPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRPT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OEORD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INRPT_String1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INRPT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRptDateINSUType">
<Global>^INSURPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INRPT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RptDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRPT_RptDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"INSUType"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INRPT_String2}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INRPT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRptNo">
<Global>^INSURPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRPT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RptNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRPT_RPTNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INRPT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
