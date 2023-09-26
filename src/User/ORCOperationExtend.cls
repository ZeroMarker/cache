/// 手术信息扩展表
Class User.ORCOperationExtend Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = OPER_RowId, SqlTableName = ORC_OperationExtend, StorageStrategy = SQLStorage ]
{

/// 手术分级表Id：ORC_OperationCategory
Property OPERClassDr As User.ORCOperationCategory [ SqlColumnNumber = 2, SqlFieldName = OPER_Class_Dr ];

/// 手术切口类型Id：ORC_BladeType  global ^3
Property OPERBladeDr As User.ORCBladeType [ SqlColumnNumber = 3, SqlFieldName = OPER_Blade_Dr ];

/// 手术部位表Id：OEC_BodySite  global ^2
Property OPERBodySiteDr As User.OECBodySite [ SqlColumnNumber = 4, SqlFieldName = OPER_BodySite_Dr ];

/// 手术体位Id：ORC_OperPosition
Property OPEROperPositionDr As User.ORCOperPosition [ SqlColumnNumber = 5, SqlFieldName = OPER_OperPosition_Dr ];

/// 手术清洁类型Id（未用）
Property OPERMRBladeDr As %String [ SqlColumnNumber = 6, SqlFieldName = OPER_MRBlade_Dr ];

/// 手术医生科室Id(|分割)
Property OPERSurgeonDeptDr As %String [ SqlColumnNumber = 7, SqlFieldName = OPER_SurgeonDept_Dr ];

/// 是否重点手术
Property OPERIsKeyOperation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = OPER_IsKeyOperation ];

/// 器械护士分级
Property OPERScrubNurseClass As %String [ SqlColumnNumber = 9, SqlFieldName = OPER_ScrubNurseClass ];

/// 巡回护士分级
Property OPERCirculNurseClass As %String [ SqlColumnNumber = 10, SqlFieldName = OPER_CirculNurseClass ];

/// 默认手术室Id
Property OPERDefaultOperLocDr As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = OPER_DefaultOperLoc_Dr ];

/// 手术操作类别（N手术，D诊断性操作，T治疗性操作，I介入治疗 国家临床版2.0）
Property OPERType As %String(DISPLAYLIST = ",Normal,Diagnosis,Therapy,Intervention", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",N,D,T,I") [ SqlColumnNumber = 12, SqlFieldName = OPER_Type ];

/// 登记类型（标本登记本，特殊病人登记本，手术登记本、结扎手术登记本）
Property OPERRegType As %String [ SqlColumnNumber = 13, SqlFieldName = OPER_RegType ];

/// 码表修改用户
Property OPERUpdateUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = OPER_UpdateUser_Dr ];

/// 码表更新日期
Property OPERUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = OPER_UpdateDate ];

/// 码表更新时间
Property OPERUpdateTime As %String [ SqlColumnNumber = 16, SqlFieldName = OPER_UpdateTime ];

/// 手术分类指针
Property OPERCategoryDr As User.DHCANCOperationCat [ SqlColumnNumber = 17, SqlFieldName = OPER_Category_Dr ];

/// 是否有上传编码
Property OPERIsUploadCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = OPER_IsUploadCode ];

/// 使用技术（常规/开放性/普通，介入，内窥镜/内镜，腹腔镜/腔镜，操作）
Property OPERTechnique As %String(DISPLAYLIST = ",Normal,Intervention,Endoscope,Laparoscope,Procedure", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",N,I,E,L,P") [ SqlColumnNumber = 19, SqlFieldName = OPER_Technique ];

/// 医疗技术级别要求
Property OPERMedicalTechniqueLevel As %String [ SqlColumnNumber = 20, SqlFieldName = OPER_MedicalTechniqueLevel ];

/// 是否特殊手术
Property OPERIsSpecial As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = OPER_IsSpecial ];

/// 是否高风险技术
Property OPERIsHighRisk As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = OPER_IsHighRisk ];

/// 是否审批
Property OPERIsAudit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = OPER_IsAudit ];

/// 是否有PACS影像
Property OPERIsPacs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = OPER_IsPacs ];

/// 医院Id(|分割)
Property OPERHospitalDr As %String [ SqlColumnNumber = 25, SqlFieldName = OPER_Hospital_Dr ];

/// 手术缩写名
Property OPERAbbreviation As %String [ SqlColumnNumber = 26, SqlFieldName = OPER_Abbreviation ];

/// 是否供应商备货   ^ 26 //add @20170717
Property OPERIsSupplierPreparation As %Boolean [ SqlColumnNumber = 27, SqlFieldName = OPER_IsSupplierPreparation ];

/// 是否使用预防性抗菌药物  ^ 27 //add @20170717
Property OPERIsProtectiveAntibacterial As %Boolean [ SqlColumnNumber = 28, SqlFieldName = OPER_IsProtectiveAntibacterial ];

/// 手术应用特性：R必选，C中医必选，O选择性
Property OPERApplyFeature As %String(DISPLAYLIST = ",Required,Chinese Medicine Required,Optional", VALUELIST = ",R,C,O") [ SqlColumnNumber = 29, SqlFieldName = OPER_ApplyFeature ];

/// 是否微创手术
Property OPERIsMinInvasive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = OPER_IsMinInvasive ];

/// 是否子手术
Property OPERIsSubOperation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = OPER_IsSubOperation ];

/// 是否限制类技术
Property OPERIsRestrictedTechnology As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = OPER_IsRestrictedTechnology ];

/// 是否新项目新技术
Property OPERIsNewItem As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = OPER_IsNewItem ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OPER_Abbreviation">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="OPER_ApplyFeature">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="OPER_Blade_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="OPER_BodySite_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="OPER_Category_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="OPER_CirculNurseClass">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="OPER_Class_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="OPER_DefaultOperLoc_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="OPER_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="OPER_IsAudit">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="OPER_IsHighRisk">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="OPER_IsKeyOperation">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="OPER_IsMinInvasive">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="OPER_IsNewItem">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>32</Piece>
</Data>
<Data name="OPER_IsPacs">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="OPER_IsProtectiveAntibacterial">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="OPER_IsRestrictedTechnology">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="OPER_IsSpecial">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="OPER_IsSubOperation">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="OPER_IsSupplierPreparation">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="OPER_IsUploadCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="OPER_MRBlade_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="OPER_MedicalTechniqueLevel">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="OPER_OperPosition_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="OPER_RegType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="OPER_ScrubNurseClass">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="OPER_SurgeonDept_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="OPER_Technique">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="OPER_Type">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="OPER_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="OPER_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="OPER_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OPER_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperationExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
