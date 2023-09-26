/// 用户信息扩展表
/// Creator:chenying bdp
/// 2019-06-25
Class User.SSUserExtend Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = SSUSR_RowId, SqlTableName = SS_UserExtend, StorageStrategy = CacheSQLStorage ]
{

/// 出生日期
Property SSUSREBirthday As %Date [ SqlColumnNumber = 2, SqlFieldName = SSUSRE_Birthday ];

/// 国籍
Property SSUSRECountryDR As CTCountry [ SqlColumnNumber = 3, SqlFieldName = SSUSRE_Country_DR ];

/// 民族
Property SSUSRENationDR As CTNation [ SqlColumnNumber = 4, SqlFieldName = SSUSRE_Nation_DR ];

/// 婚姻状况
Property SSUSREMaritalDR As User.CTMarital [ SqlColumnNumber = 5, SqlFieldName = SSUSRE_MaritalDR ];

/// 教育水平(学历)
Property SSUSREEducationDR As User.CTEducation [ SqlColumnNumber = 6, SqlFieldName = SSUSRE_EducationDR ];

/// 家庭住址
Property SSUSREAddress As %String [ SqlColumnNumber = 7, SqlFieldName = SSUSRE_Address ];

/// 职工号
Property SSUSRESerialNo As %String [ SqlColumnNumber = 8, SqlFieldName = SSUSRE_SerialNo ];

/// 职工简介
Property SSUSREIntroduction As %String(MAXLEN = 99999) [ SqlColumnNumber = 9, SqlFieldName = SSUSRE_Introduction ];

/// 图片
Property SSUSREImg As %String(MAXLEN = 999999) [ SqlColumnNumber = 10, SqlFieldName = SSUSRE_Img ];

/// 图片偏转角度
Property SSUSREImgOrientation As %String [ SqlColumnNumber = 11, SqlFieldName = SSUSRE_ImgOrientation ];

/// 证书编码
Property SSUSRECertificateNo As %String [ SqlColumnNumber = 12, SqlFieldName = SSUSRE_CertificateNo ];

/// 政治面貌
Property SSUSREPoliticalStatus As %String [ SqlColumnNumber = 13, SqlFieldName = SSUSRE_PoliticalStatus ];

/// text1
Property SSUSREText1 As %String [ SqlColumnNumber = 14, SqlFieldName = SSUSRE_Text1 ];

/// text2
Property SSUSREText2 As %String [ SqlColumnNumber = 15, SqlFieldName = SSUSRE_Text2 ];

/// 职工特长
Property SSUSRESpeciality As %String(MAXLEN = 99999) [ SqlColumnNumber = 16, SqlFieldName = SSUSRE_Speciality ];

Property SSUSREFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = SSUSRE_Flag1 ];

Property SSUSREFlag2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = SSUSRE_Flag2 ];

/// 性别 用于烟台医保数据对照
Property SSUSRESexDR As User.CTSex [ SqlColumnNumber = 19, SqlFieldName = SSUSRE_SexDR ];

/// 多点执业标志
Property SSUSREMulpracFlag As %String [ SqlColumnNumber = 20, SqlFieldName = SSUSRE_MulpracFlag ];

/// 主执业机构标志
Property SSUSREMainpracinsFlag As %String [ SqlColumnNumber = 21, SqlFieldName = SSUSRE_MainpracinsFlag ];

/// 医疗服务类型
Property SSUSREHiServType As %String [ SqlColumnNumber = 22, SqlFieldName = SSUSRE_HiServType ];

/// 医疗服务开始时间
Property SSUSREBeginDate As %Date [ SqlColumnNumber = 23, SqlFieldName = SSUSRE_BeginDate ];

/// 医师执业类别
Property SSUSREDrPracType As %String [ SqlColumnNumber = 24, SqlFieldName = SSUSRE_DrPracType ];

/// 医师专业技术职务
Property SSUSREDrProTechDuty As %String [ SqlColumnNumber = 25, SqlFieldName = SSUSRE_DrProTechDuty ];

/// 医师执业范围代码
Property SSUSREDrPracScpCode As %String [ SqlColumnNumber = 26, SqlFieldName = SSUSRE_DrPracScpCode ];

/// 专业编号
Property SSUSREProCode As %String [ SqlColumnNumber = 27, SqlFieldName = SSUSRE_ProCode ];

/// 是否申报为本市专家库成员
Property SSUSREDclProfFlag As %String [ SqlColumnNumber = 28, SqlFieldName = SSUSRE_DclProfFlag ];

/// 医师执业情况
Property SSUSREPracticeCode As %String [ SqlColumnNumber = 29, SqlFieldName = SSUSRE_PracticeCode ];

/// 医师职称编号
Property SSUSREDrProfttlCode As %String [ SqlColumnNumber = 30, SqlFieldName = SSUSRE_DrProfttlCode ];

/// bind_flag	定岗标志
Property SSUSREBindFlag As %String [ SqlColumnNumber = 31, SqlFieldName = SSUSRE_BindFlag ];

/// siprof_flag	是否医保专家库成员
Property SSUSRESiprofFlag As %String [ SqlColumnNumber = 32, SqlFieldName = SSUSRE_SiprofFlag ];

/// loclprof_flag	是否本地申报专家
Property SSUSRELoclprofFlag As %String [ SqlColumnNumber = 33, SqlFieldName = SSUSRE_LoclprofFlag ];

/// hi_dr_flag	是否医保医师
Property SSUSREHiDrFlag As %String [ SqlColumnNumber = 34, SqlFieldName = SSUSRE_HiDrFlag ];

/// cert_type	证件类型
Property SSUSRECertType As %String [ SqlColumnNumber = 35, SqlFieldName = SSUSRE_CertType ];

/// certno	证件号码
Property SSUSRECertno As %String [ SqlColumnNumber = 36, SqlFieldName = SSUSRE_Certno ];

/// 出生地
Property SSUSREBirthplace As %String [ SqlColumnNumber = 37, SqlFieldName = SSUSRE_Birthplace ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SSUSRE_Address">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>6</Piece>
</Data>
<Data name="SSUSRE_BeginDate">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>21</Piece>
</Data>
<Data name="SSUSRE_BindFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>29</Piece>
</Data>
<Data name="SSUSRE_Birthday">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>1</Piece>
</Data>
<Data name="SSUSRE_Birthplace">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>35</Piece>
</Data>
<Data name="SSUSRE_CertType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>33</Piece>
</Data>
<Data name="SSUSRE_CertificateNo">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>9</Piece>
</Data>
<Data name="SSUSRE_Certno">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>34</Piece>
</Data>
<Data name="SSUSRE_Country_DR">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>2</Piece>
</Data>
<Data name="SSUSRE_DclProfFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>26</Piece>
</Data>
<Data name="SSUSRE_DrPracScpCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>24</Piece>
</Data>
<Data name="SSUSRE_DrPracType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>22</Piece>
</Data>
<Data name="SSUSRE_DrProTechDuty">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>23</Piece>
</Data>
<Data name="SSUSRE_DrProfttlCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>28</Piece>
</Data>
<Data name="SSUSRE_EducationDR">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>5</Piece>
</Data>
<Data name="SSUSRE_Flag1">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>14</Piece>
</Data>
<Data name="SSUSRE_Flag2">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>15</Piece>
</Data>
<Data name="SSUSRE_HiDrFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>32</Piece>
</Data>
<Data name="SSUSRE_HiServType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>20</Piece>
</Data>
<Data name="SSUSRE_Img">
<Delimiter>"^"</Delimiter>
<Node>"EXTIMG"</Node>
<Piece>1</Piece>
</Data>
<Data name="SSUSRE_ImgOrientation">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>17</Piece>
</Data>
<Data name="SSUSRE_Introduction">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>8</Piece>
</Data>
<Data name="SSUSRE_LoclprofFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>31</Piece>
</Data>
<Data name="SSUSRE_MainpracinsFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>19</Piece>
</Data>
<Data name="SSUSRE_MaritalDR">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>4</Piece>
</Data>
<Data name="SSUSRE_MulpracFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>18</Piece>
</Data>
<Data name="SSUSRE_Nation_DR">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>3</Piece>
</Data>
<Data name="SSUSRE_PoliticalStatus">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>10</Piece>
</Data>
<Data name="SSUSRE_PracticeCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>27</Piece>
</Data>
<Data name="SSUSRE_ProCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>25</Piece>
</Data>
<Data name="SSUSRE_SerialNo">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>7</Piece>
</Data>
<Data name="SSUSRE_SexDR">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>16</Piece>
</Data>
<Data name="SSUSRE_SiprofFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>30</Piece>
</Data>
<Data name="SSUSRE_Speciality">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>13</Piece>
</Data>
<Data name="SSUSRE_Text1">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>11</Piece>
</Data>
<Data name="SSUSRE_Text2">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>12</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SSUSR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.SSUserExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
