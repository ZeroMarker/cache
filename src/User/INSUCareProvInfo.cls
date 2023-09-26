/// Table:医保医师信息
/// Creator:DingSH
/// Date:2018-09-21
Class User.INSUCareProvInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCPI_Rowid, SqlTableName = INSU_CareProvInfo, StorageStrategy = CacheSQLStorage ]
{

/// INCPI_CPCode	医师编号
Property INCPICPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INCPI_CPCode ];

/// INCPI_CPName	医师姓名
Property INCPICPName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INCPI_CPName ];

/// INCPI_IDType	证件类型
Property INCPIIDType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INCPI_IDType ];

/// INCPI_IDNo	证件号码
Property INCPIIDNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INCPI_IDNo ];

/// INCPI_Sex	性别		
Property INCPISex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INCPI_Sex ];

/// INCPI_Nation	民族
Property INCPINation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INCPI_Nation ];

/// INCPI_BOD	出生日期
Property INCPIBOD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INCPI_BOD ];

/// INCPI_TelNo	联系电话
Property INCPITelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INCPI_TelNo ];

/// INCPI_DeptDr	科室Dr
Property INCPIDeptDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = INCPI_DeptDr ];

/// INCPI_DeptCode	科室编号
Property INCPIDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INCPI_DeptCode ];

/// INCPI_DeptDesc	科室名称
Property INCPIDeptDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INCPI_DeptDesc ];

/// INCPI_JobTitle	职称（级别）
Property INCPIJobTitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INCPI_JobTitle ];

/// INCPI_AdminPost	行政职务
Property INCPIAdminPost As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INCPI_AdminPost ];

/// INCPI_AcadePost	学术职务
Property INCPIAcadePost As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INCPI_AcadePost ];

/// INCPI_College	毕业院校
Property INCPICollege As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INCPI_College ];

/// INCPI_Education	学历
Property INCPIEducation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INCPI_Education ];

/// INCPI_Profession	所学专业 
Property INCPIProfession As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INCPI_Profession ];

/// INCPI_PatType	医院人员类别 
Property INCPIPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INCPI_PatType ];

/// INCPI_AppoitNo	医院聘书编码
Property INCPIAppoitNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INCPI_AppoitNo ];

/// INCPI_MSQCNo	资格证书编码 
Property INCPIMSQCNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INCPI_MSQCNo ];

/// INCPI_MSQCMajor	资格证专业
Property INCPIMSQCMajor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INCPI_MSQCMajor ];

/// INCPI_MSQCType	资格证类别
Property INCPIMSQCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INCPI_MSQCType ];

/// INCPI_MCNo	执业证书编码
Property INCPIMCNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INCPI_MCNo ];

/// INCPI_MCType	执业类别
Property INCPIMCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INCPI_MCType ];

/// INCPI_MCMajor	执业范围（专业）
Property INCPIMCMajor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INCPI_MCMajor ];

/// INCPI_MSQCStDate	执业开始时间
Property INCPIMSQCStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = INCPI_MSQCStDate ];

/// INCPI_MSQCEdDate	执业结束时间 
Property INCPIMSQCEdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = INCPI_MSQCEdDate ];

/// INCPI_MajorDiags	主治疾病内容
Property INCPIMajorDiags As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = INCPI_MajorDiags ];

/// INCPI_MajorDiagType	疾病种类
Property INCPIMajorDiagType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INCPI_MajorDiagType ];

/// INCPI_MSQCRegDate	执业证书注册日期
Property INCPIMSQCRegDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INCPI_MSQCRegDate ];

/// INCPI_MSQCMultiFlag	是否多点执业
Property INCPIMSQCMultiFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INCPI_MSQCMultiFlag ];

/// INCPI_MSQCAddr1	第一执业地点
Property INCPIMSQCAddr1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INCPI_MSQCAddr1 ];

/// INCPI_MSQCAddr2	第二执业地点
Property INCPIMSQCAddr2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INCPI_MSQCAddr2 ];

/// INCPI_MSQCAddr3	第三执业地点
Property INCPIMSQCAddr3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INCPI_MSQCAddr3 ];

/// INCPI_MSQCAddrN	其它执业注册地			可填写多个,以|隔开
Property INCPIMSQCAddrN As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INCPI_MSQCAddrN ];

/// INCPI_DoctLevel	医师级别
Property INCPIDoctLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INCPI_DoctLevel ];

/// INCPI_NurseLevel	护师级别
Property INCPINurseLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INCPI_NurseLevel ];

/// INCPI_MediPrescFlag	医保处方权
Property INCPIMediPrescFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INCPI_MediPrescFlag ];

/// INCPI_OpTsPrescFlag	门诊特殊病开单标志
Property INCPIOpTsPrescFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INCPI_OpTsPrescFlag ];

/// INCPI_InsuDoctFlag	医保医师标志 
Property INCPIInsuDoctFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INCPI_InsuDoctFlag ];

/// INCPI_StDate	备案开始日期
Property INCPIStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = INCPI_StDate ];

/// INCPI_EdDate	备案结束日期
Property INCPIEdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 43, SqlFieldName = INCPI_EdDate ];

/// INCPI_ActFlag	有效标志
Property INCPIActFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INCPI_ActFlag ];

/// INCPI_MediPatype	卫生技术人员类别
Property INCPIMediPatype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INCPI_MediPatype ];

/// INCPI_UserDr	经办人
Property INCPIUserDr As User.SSUser [ SqlColumnNumber = 46, SqlFieldName = INCPI_UserDr ];

/// INCPI_Date	经办日期
Property INCPIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 47, SqlFieldName = INCPI_Date ];

/// INCPI_Time	经办时间
Property INCPITime As %Library.Time [ SqlColumnNumber = 48, SqlFieldName = INCPI_Time ];

/// INCPI_ExtStr01	扩展01	VARCHAR2(30) 
Property INCPIExtStr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = INCPI_ExtStr01 ];

/// INCPI_ExtStr02	扩展02	VARCHAR2(30) 
Property INCPIExtStr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = INCPI_ExtStr02 ];

/// INCPI_ExtStr03	扩展03	VARCHAR2(30) 
Property INCPIExtStr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = INCPI_ExtStr03 ];

/// INCPI_ExtStr04	扩展04	VARCHAR2(30) 
Property INCPIExtStr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = INCPI_ExtStr04 ];

/// INCPI_ExtStr05	扩展05	VARCHAR2(30) 
Property INCPIExtStr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = INCPI_ExtStr05 ];

/// INCPI_HospDr	 
Property INCPIHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = INCPI_HospDr ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCINCPI)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INCPI_AcadePost">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCPI_ActFlag">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INCPI_AdminPost">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCPI_AppoitNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INCPI_BOD">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCPI_CPCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCPI_CPName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCPI_College">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INCPI_Date">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INCPI_DeptCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCPI_DeptDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCPI_DeptDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCPI_DoctLevel">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INCPI_EdDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INCPI_Education">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCPI_ExtStr01">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INCPI_ExtStr02">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INCPI_ExtStr03">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INCPI_ExtStr04">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INCPI_ExtStr05">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INCPI_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INCPI_IDNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCPI_IDType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCPI_InsuDoctFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INCPI_JobTitle">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCPI_MCMajor">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INCPI_MCNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INCPI_MCType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INCPI_MSQCAddr1">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INCPI_MSQCAddr2">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INCPI_MSQCAddr3">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INCPI_MSQCAddrN">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INCPI_MSQCEdDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INCPI_MSQCMajor">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INCPI_MSQCMultiFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INCPI_MSQCNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INCPI_MSQCRegDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INCPI_MSQCStDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INCPI_MSQCType">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INCPI_MajorDiagType">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INCPI_MajorDiags">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INCPI_MediPatype">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INCPI_MediPrescFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INCPI_Nation">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCPI_NurseLevel">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INCPI_OpTsPrescFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INCPI_PatType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INCPI_Profession">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INCPI_Sex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCPI_StDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INCPI_TelNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCPI_Time">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INCPI_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Global>^DHCINCPI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCPI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INCPI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOfCPCode">
<Global>^DHCINCPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCPI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCPI_CPCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCPI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfCPCodeHosp">
<Global>^DHCINCPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCPI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCPI_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CPCode"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INCPI_CPCode})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCPI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfCPDesc">
<Global>^DHCINCPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCPI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCPI_CPName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCPI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfCPDescHosp">
<Global>^DHCINCPI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCPI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCPI_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CPDesc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INCPI_CPName})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCPI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUCareProvInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
