/// Table:医保科室信息
/// Creator:DingSH
/// Date:20180920
Class User.INSULocInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INLCI_Rowid, SqlTableName = INSU_LocInfo, StorageStrategy = CacheSQLStorage ]
{

/// INLCI_DeptCode	医院科室编码	VARCHAR2(30) 
Property INLCIDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INLCI_DeptCode ];

/// INLCI_DeptDesc	医院科室名称	VARCHAR2(100)
Property INLCIDeptDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INLCI_DeptDesc ];

/// INLCI_DeptType	科室类型	VARCHAR2(1) 		1、门诊；2、住院、3、门诊&住院  
Property INLCIDeptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INLCI_DeptType ];

/// INLCI_StandDeptCode	标准科室编码	VARCHAR2(4) 		卫计委统一标准编码
Property INLCIStandDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INLCI_StandDeptCode ];

/// INLCI_ProfessionDeptCode	专业科室代码 	VARCHAR2(4) 		
Property INLCIProfessionDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INLCI_ProfessionDeptCode ];

/// INLCI_DeptDr	科室Dr			CT_Loc.Rowid
Property INLCIDeptDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = INLCI_DeptDr ];

/// INLCI_SPBedNum	批准床位数量	NUMBER
Property INLCISPBedNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INLCI_SPBedNum ];

/// INLCI_SJBedNum	实际开放床位数量	NUMBER
Property INLCISJBedNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INLCI_SJBedNum ];

/// INLCI_DeptSetUpDate	科室成立时间	
Property INLCIDeptSetUpDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INLCI_DeptSetUpDate ];

/// INLCI_DoctorNum	医师数量	NUMBER
Property INLCIDoctorNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INLCI_DoctorNum ];

/// INLCI_TechnicianNum	技师数量	NUMBER
Property INLCITechnicianNum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INLCI_TechnicianNum ];

/// INLCI_PharmacistNum	药师数量	NUMBER
Property INLCIPharmacistNum As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INLCI_PharmacistNum ];

/// INLCI_NurseNum	护理人员数量	NUMBER
Property INLCINurseNum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INLCI_NurseNum ];

/// INLCI_DeptHead	科室负责人	VARCHAR2(20) 
Property INLCIDeptHead As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INLCI_DeptHead ];

/// INLCI_DeptHeadTelNo	科室负责人联系电话	VARCHAR2(20) 
Property INLCIDeptHeadTelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INLCI_DeptHeadTelNo ];

/// INLCI_NurseHead	病区护士长姓名	VARCHAR2(20) 
Property INLCINurseHead As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INLCI_NurseHead ];

/// INLCI_NurseHeadTelNo	病区护士长联系电话	VARCHAR2(20) 
Property INLCINurseHeadTelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INLCI_NurseHeadTelNo ];

/// INLCI_IsKeyDept	是否重点科室	VARCHAR2(1) 
Property INLCIIsKeyDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INLCI_IsKeyDept ];

/// INLCI_KeyDeptLevel	重点科室等级	VARCHAR2(4) 
Property INLCIKeyDeptLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INLCI_KeyDeptLevel ];

/// INLCI_IsAllowFee	该科室是否发生费用	VARCHAR2(1) 
Property INLCIIsAllowFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INLCI_IsAllowFee ];

/// INLCI_HospCode	医院机构编码	VARCHAR2(30) 
Property INLCIHospCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INLCI_HospCode ];

/// INLCI_StDate	开始日期	Date
Property INLCIStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INLCI_StDate ];

/// INLCI_StTime	开始时间
Property INLCIStTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = INLCI_StTime ];

/// INLCI_EdDate	结束日期
Property INLCIEdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = INLCI_EdDate ];

/// INLCI_EdTime	结束时间	Time
Property INLCIEdTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = INLCI_EdTime ];

/// INLCI_ActFlag	有效标志	VARCHAR2(30) 		1为有效 0为失效 
Property INLCIActFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INLCI_ActFlag ];

/// INLCI_UserDr	经办人	VARCHAR2(20) 
Property INLCIUserDr As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = INLCI_UserDr ];

/// INLCI_Date	经办日期	Date
Property INLCIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = INLCI_Date ];

/// INLCI_Time	经办时间	Time
Property INLCITime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = INLCI_Time ];

/// INLCI_Remark	备注	VARCHAR2(100) 
Property INLCIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INLCI_Remark ];

/// INLCI_ExtStr01	扩展01	VARCHAR2(30) 
Property INLCIExtStr01 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INLCI_ExtStr01 ];

/// INLCI_ExtStr02	扩展02	VARCHAR2(30) 
Property INLCIExtStr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INLCI_ExtStr02 ];

/// INLCI_ExtStr03	扩展03	VARCHAR2(30) 
Property INLCIExtStr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INLCI_ExtStr03 ];

/// INLCI_ExtStr04	扩展04	VARCHAR2(30) 
Property INLCIExtStr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INLCI_ExtStr04 ];

/// INLCI_ExtStr05	扩展05	VARCHAR2(30) 
Property INLCIExtStr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INLCI_ExtStr05 ];

/// INLCI_HospDr	 
Property INLCIHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INLCI_HospDr ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCINLCI)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INLCI_ActFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INLCI_Date">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INLCI_DeptCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INLCI_DeptDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INLCI_DeptDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INLCI_DeptHead">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INLCI_DeptHeadTelNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INLCI_DeptSetUpDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INLCI_DeptType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INLCI_DoctorNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INLCI_EdDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INLCI_EdTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INLCI_ExtStr01">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INLCI_ExtStr02">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INLCI_ExtStr03">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INLCI_ExtStr04">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INLCI_ExtStr05">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INLCI_HospCode">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INLCI_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INLCI_IsAllowFee">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INLCI_IsKeyDept">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INLCI_KeyDeptLevel">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INLCI_NurseHead">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INLCI_NurseHeadTelNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INLCI_NurseNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INLCI_PharmacistNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INLCI_ProfessionDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INLCI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INLCI_SJBedNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INLCI_SPBedNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INLCI_StDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INLCI_StTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INLCI_StandDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INLCI_TechnicianNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INLCI_Time">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INLCI_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCINLCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOfDeptCode">
<Global>^DHCINLCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INLCI_DeptCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfDeptCodeHosp">
<Global>^DHCINLCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLCI_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DeptCode"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INLCI_DeptCode})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfDeptDesc">
<Global>^DHCINLCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INLCI_DeptDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfDeptDescHosp">
<Global>^DHCINLCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLCI_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DeptDesc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INLCI_DeptDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfDeptDr">
<Global>^DHCINLCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLCI_DeptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfDeptDrHosp">
<Global>^DHCINLCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLCI_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DeptDr"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLCI_DeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSULocInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
