/// 描述：人员基本信息表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPerson Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Person ]
{

/// 唯一标识码
Property PAPersonID As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PA_PersonID ];

/// 姓名
Property PAName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PA_Name ];

/// 曾用名
Property PAFormerName As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PA_FormerName ];

/// 性别代码-外键
Property PAGenderCode As User.CTSex [ SqlColumnNumber = 5, SqlFieldName = PA_GenderCode ];

/// 出生日期
Property PABirthDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PA_BirthDate ];

/// 出生时间	
Property PABirthTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PA_BirthTime ];

/// 国籍-外键
Property PANationalityCode As User.CTCountry [ SqlColumnNumber = 8, SqlFieldName = PA_NationalityCode ];

/// 第一语言 add@20230202
Property PALanguageCode1 As User.SSLanguage [ SqlColumnNumber = 9, SqlFieldName = PA_LanguageCode1 ];

/// 第二语言 add@20230202
Property PALanguageCode2 As User.SSLanguage [ SqlColumnNumber = 10, SqlFieldName = PA_LanguageCode2 ];

/// 身份证号
Property PAIdentityID As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PA_IdentityID ];

/// 身份证件类型
Property PAIdentityType As User.DHCCredType [ SqlColumnNumber = 12, SqlFieldName = PA_IdentityType ];

/// 民族代码-外键
Property PANationCode As User.CTNation [ SqlColumnNumber = 13, SqlFieldName = PA_NationCode ];

/// 学历代码-外键
Property PAEducationCode As User.CTEducation [ SqlColumnNumber = 14, SqlFieldName = PA_EducationCode ];

/// 学位代码-外键 add@20230207
Property PADegreeCode As CT.BDP.CT.HOSDegree [ SqlColumnNumber = 15, SqlFieldName = PA_DegreeCode ];

/// 职业代码-外键
Property PAOccupationCode As User.CTOccupation [ SqlColumnNumber = 16, SqlFieldName = PA_OccupationCode ];

/// 婚姻状态-外键
Property PAMarriedCode As User.CTMarital [ SqlColumnNumber = 17, SqlFieldName = PA_MarriedCode ];

/// 宗教-外键
Property PAReligionCode As User.CTReligion [ SqlColumnNumber = 18, SqlFieldName = PA_ReligionCode ];

/// 籍贯（国家）-外键
Property PANPCountryCode As User.CTCountry [ SqlColumnNumber = 19, SqlFieldName = PA_NPCountryCode ];

/// 籍贯（省）-外键
Property PANPPROVCode As User.CTProvince [ SqlColumnNumber = 20, SqlFieldName = PA_NPPROVCode ];

/// 籍贯（市）-外键
Property PANPCITYCode As User.CTCity [ SqlColumnNumber = 21, SqlFieldName = PA_NPCITYCode ];

/// 籍贯（县区）-外键
Property PANPDISTRCode As User.CTCityArea [ SqlColumnNumber = 22, SqlFieldName = PA_NPDISTRCode ];

/// 现住址（国家）-外键
Property PAAddrCountryCode As User.CTCountry [ SqlColumnNumber = 23, SqlFieldName = PA_AddrCountryCode ];

/// 现住址（省）-外键
Property PAAddrPROVCode As User.CTProvince [ SqlColumnNumber = 24, SqlFieldName = PA_AddrPROVCode ];

/// 现住址（市）-外键
Property PAAddrCITYCode As User.CTCity [ SqlColumnNumber = 25, SqlFieldName = PA_AddrCITYCode ];

/// 现住址（县区）-外键
Property PAAddrDISTRCode As User.CTCityArea [ SqlColumnNumber = 26, SqlFieldName = PA_AddrDISTRCode ];

/// 现住址（详细地址）	
Property PAAddress As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PA_Address ];

/// 照片
Property PAPhoto As %String(MAXLEN = 999999, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PA_Photo ];

/// 手机号码	
Property PAMobile As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PA_Mobile ];

/// 邮箱 add@20230202	
Property PAEmail As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PA_Email ];

/// 状态 外键
Property PAPersonStatus As CT.BDP.CT.HOSPersonStatusDict [ SqlColumnNumber = 31, SqlFieldName = PA_PersonStatus ];

/// 是否有效(Y/N)
Property PAActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 32, SqlFieldName = PA_Activity ];

/// 开始日期
Property PAStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 33, SqlFieldName = PA_StartDate ];

/// 结束日期
Property PAEndDate As %Date [ SqlColumnNumber = 34, SqlFieldName = PA_EndDate ];

/// 系统创建日期
Property PACreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 35, SqlFieldName = PA_CreateDate ];

/// 系统创建时间
Property PACreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 36, SqlFieldName = PA_CreateTime ];

/// 系统创建人
Property PACreateUser As User.SSUser [ SqlColumnNumber = 37, SqlFieldName = PA_CreateUser ];

/// 系统排序号
Property PASeqNo As %Float [ SqlColumnNumber = 38, SqlFieldName = PA_SeqNo ];

/// 系统最后更新日期
Property PALastUpdateDate As %Date [ SqlColumnNumber = 39, SqlFieldName = PA_LastUpdateDate ];

/// 系统最后更新时间
Property PALastUpdateTime As %Time [ SqlColumnNumber = 40, SqlFieldName = PA_LastUpdateTime ];

/// 系统最新更新人
Property PALastUpdateUser As User.SSUser [ SqlColumnNumber = 41, SqlFieldName = PA_LastUpdateUser ];

/// 拼音码
Property PAPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = PA_PYCode ];

/// 五笔码
Property PAWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = PA_WBCode ];

/// 备注
Property PAMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = PA_Mark ];

/// 索引-唯一标识码
Index IndexPersonID On PAPersonID [ Unique ];

/// 索引-身份证号
Index IndexIdentityID On PAIdentityID;

/// 索引-系统排序号
Index IndexSeqNo On PASeqNo;

/// 索引-性别代码
Index IndexGenderCode On PAGenderCode;

/// 索引-国籍
Index IndexNationalityCode On PANationalityCode;

/// 索引-身份证件类型
Index IndexIdentityType On PAIdentityType;

/// 索引-民族代码
Index IndexNationCode On PANationCode;

/// 索引-学历代码
Index IndexEducationCode On PAEducationCode;

/// 索引-学位代码
Index IndexDegreeCode On PADegreeCode;

/// 索引-职业代码
Index IndexOccupationCode On PAOccupationCode;

/// 索引-婚姻状态
Index IndexMarriedCode On PAMarriedCode;

/// 索引-宗教
Index IndexReligionCode On PAReligionCode;

/// 索引-籍贯（国家）
Index IndexNPCountryCode On PANPCountryCode;

/// 索引-籍贯（省）
Index IndexNPPROVCode On PANPPROVCode;

/// 索引-籍贯（市）
Index IndexNPCITYCode On PANPCITYCode;

/// 索引-籍贯（县区）
Index IndexNPDISTRCode On PANPDISTRCode;

/// 索引-现住址（国家）
Index IndexAddrCountryCode On PAAddrCountryCode;

/// 索引-现住址（省）
Index IndexAddrPROVCode On PAAddrPROVCode;

/// 索引-现住址（市）
Index IndexAddrCITYCode On PAAddrCITYCode;

/// 索引-现住址（县区）
Index IndexAddrDISTRCode On PAAddrDISTRCode;

/// 索引-状态
Index IndexPersonStatus On PAPersonStatus;

Storage Default
{
<Data name="HOSPersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAPersonID</Value>
</Value>
<Value name="3">
<Value>PAName</Value>
</Value>
<Value name="4">
<Value>PAFormerName</Value>
</Value>
<Value name="5">
<Value>PAGenderCode</Value>
</Value>
<Value name="6">
<Value>PABirthDate</Value>
</Value>
<Value name="7">
<Value>PABirthTime</Value>
</Value>
<Value name="8">
<Value>PANationalityCode</Value>
</Value>
<Value name="9">
<Value>PALanguageCode1</Value>
</Value>
<Value name="10">
<Value>PALanguageCode2</Value>
</Value>
<Value name="11">
<Value>PAIdentityID</Value>
</Value>
<Value name="12">
<Value>PAIdentityType</Value>
</Value>
<Value name="13">
<Value>PANationCode</Value>
</Value>
<Value name="14">
<Value>PAEducationCode</Value>
</Value>
<Value name="15">
<Value>PADegreeCode</Value>
</Value>
<Value name="16">
<Value>PAOccupationCode</Value>
</Value>
<Value name="17">
<Value>PAMarriedCode</Value>
</Value>
<Value name="18">
<Value>PAReligionCode</Value>
</Value>
<Value name="19">
<Value>PANPCountryCode</Value>
</Value>
<Value name="20">
<Value>PANPPROVCode</Value>
</Value>
<Value name="21">
<Value>PANPCITYCode</Value>
</Value>
<Value name="22">
<Value>PANPDISTRCode</Value>
</Value>
<Value name="23">
<Value>PAAddrCountryCode</Value>
</Value>
<Value name="24">
<Value>PAAddrPROVCode</Value>
</Value>
<Value name="25">
<Value>PAAddrCITYCode</Value>
</Value>
<Value name="26">
<Value>PAAddrDISTRCode</Value>
</Value>
<Value name="27">
<Value>PAAddress</Value>
</Value>
<Value name="28">
<Value>PAPhoto</Value>
</Value>
<Value name="29">
<Value>PAMobile</Value>
</Value>
<Value name="30">
<Value>PAEmail</Value>
</Value>
<Value name="31">
<Value>PAPersonStatus</Value>
</Value>
<Value name="32">
<Value>PAActivity</Value>
</Value>
<Value name="33">
<Value>PAStartDate</Value>
</Value>
<Value name="34">
<Value>PAEndDate</Value>
</Value>
<Value name="35">
<Value>PACreateDate</Value>
</Value>
<Value name="36">
<Value>PACreateTime</Value>
</Value>
<Value name="37">
<Value>PACreateUser</Value>
</Value>
<Value name="38">
<Value>PASeqNo</Value>
</Value>
<Value name="39">
<Value>PALastUpdateDate</Value>
</Value>
<Value name="40">
<Value>PALastUpdateTime</Value>
</Value>
<Value name="41">
<Value>PALastUpdateUser</Value>
</Value>
<Value name="42">
<Value>PAPYCode</Value>
</Value>
<Value name="43">
<Value>PAWBCode</Value>
</Value>
<Value name="44">
<Value>PAMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPersonD</DataLocation>
<DefaultData>HOSPersonDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPersonD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPersonI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
