/// 描述:组织机构树
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrganization Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Organization ]
{

/// 组织代码
Property ORGCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORG_Code ];

/// 组织名称
Property ORGDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORG_Desc ];

/// 统一社会信用代码
Property ORGUSCC As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ORG_USCC ];

/// 组织简称
Property ORGAbbrev As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ORG_Abbrev ];

/// 组织简介
Property ORGIntro As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ORG_Intro ];

/// 组织法人
Property ORGLegalEntity As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ORG_LegalEntity ];

/// 组织负责人	
Property ORGHeader As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ORG_Header ];

/// 上级机构
Property ORGORGCode As CT.BDP.CT.HOSOrganization [ SqlColumnNumber = 9, SqlFieldName = ORG_ORGCode ];

/// 组织小类
Property ORGORGMCCode As CT.BDP.CT.HOSOrgMinCategory [ SqlColumnNumber = 10, SqlFieldName = ORG_ORGMCCode ];

/// 组织所在国家
Property ORGCountryCode As User.CTCountry [ SqlColumnNumber = 11, SqlFieldName = ORG_CountryCode ];

/// 组织所在省
Property ORGPROVCode As User.CTProvince [ SqlColumnNumber = 12, SqlFieldName = ORG_PROVCode ];

/// 组织所在市
Property ORGCITYCode As User.CTCity [ SqlColumnNumber = 13, SqlFieldName = ORG_CITYCode ];

/// 组织所在区
Property ORGDISTRCode As User.CTCityArea [ SqlColumnNumber = 14, SqlFieldName = ORG_DISTRCode ];

/// 组织地址
Property ORGAddress As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORG_Address ];

/// 组织邮编
Property ORGZipCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORG_ZipCode ];

/// 联系电话	
Property ORGTel As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORG_Tel ];

/// 传真
Property ORGFax As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ORG_Fax ];

/// 邮件
Property ORGEmail As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ORG_Email ];

/// 官网
Property ORGWebSite As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = ORG_WebSite ];

/// 建立日期
Property ORGFoundDate As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ORG_FoundDate ];

/// 注销日期
Property ORGCancelDate As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ORG_CancelDate ];

/// 是否有效(Y/N)
Property ORGActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 23, SqlFieldName = ORG_Activity ];

/// 开始日期
Property ORGStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 24, SqlFieldName = ORG_StartDate ];

/// 结束日期
Property ORGEndDate As %Date [ SqlColumnNumber = 25, SqlFieldName = ORG_EndDate ];

/// 系统创建日期
Property ORGCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 26, SqlFieldName = ORG_CreateDate ];

/// 系统创建时间
Property ORGCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 27, SqlFieldName = ORG_CreateTime ];

/// 系统创建人
Property ORGCreateUser As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = ORG_CreateUser ];

/// 系统排序号
Property ORGSeqNo As %Float [ SqlColumnNumber = 29, SqlFieldName = ORG_SeqNo ];

/// 系统最后更新日期
Property ORGLastUpdateDate As %Date [ SqlColumnNumber = 30, SqlFieldName = ORG_LastUpdateDate ];

/// 系统最后更新时间
Property ORGLastUpdateTime As %Time [ SqlColumnNumber = 31, SqlFieldName = ORG_LastUpdateTime ];

/// 系统最新更新人
Property ORGLastUpdateUser As User.SSUser [ SqlColumnNumber = 32, SqlFieldName = ORG_LastUpdateUser ];

/// 拼音码
Property ORGPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = ORG_PYCode ];

/// 五笔码
Property ORGWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = ORG_WBCode ];

/// 备注
Property ORGMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = ORG_Mark ];

/// 标准编码
Property ORGStandardCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = ORG_StandardCode ];

/// 标准名称
Property ORGStandardDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = ORG_StandardDesc ];

/// 原系统编码
Property ORGCodeBefore As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = ORG_CodeBefore ];

/// 索引-代码
Index IndexCode On ORGCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGDesc;

/// 索引-系统排序号
Index IndexSeqNo On ORGSeqNo;

/// 索引-上级组织机构-外键
Index IndexORGCode On ORGORGCode As Exact;

/// 索引-组织小类
Index IndexORGMCCode On ORGORGMCCode;

/// 索引-组织所在国家
Index IndexCountryCode On ORGCountryCode;

/// 索引-组织所在省
Index IndexPROVCode On ORGPROVCode;

/// 索引-组织所在市
Index IndexCITYCode On ORGCITYCode;

/// 索引-组织所在区
Index IndexDISTRCode On ORGDISTRCode;

Storage Default
{
<Data name="HOSOrganizationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGCode</Value>
</Value>
<Value name="3">
<Value>ORGDesc</Value>
</Value>
<Value name="4">
<Value>ORGUSCC</Value>
</Value>
<Value name="5">
<Value>ORGAbbrev</Value>
</Value>
<Value name="6">
<Value>ORGIntro</Value>
</Value>
<Value name="7">
<Value>ORGLegalEntity</Value>
</Value>
<Value name="8">
<Value>ORGHeader</Value>
</Value>
<Value name="9">
<Value>ORGORGCode</Value>
</Value>
<Value name="10">
<Value>ORGORGMCCode</Value>
</Value>
<Value name="11">
<Value>ORGCountryCode</Value>
</Value>
<Value name="12">
<Value>ORGPROVCode</Value>
</Value>
<Value name="13">
<Value>ORGCITYCode</Value>
</Value>
<Value name="14">
<Value>ORGDISTRCode</Value>
</Value>
<Value name="15">
<Value>ORGAddress</Value>
</Value>
<Value name="16">
<Value>ORGZipCode</Value>
</Value>
<Value name="17">
<Value>ORGTel</Value>
</Value>
<Value name="18">
<Value>ORGFax</Value>
</Value>
<Value name="19">
<Value>ORGEmail</Value>
</Value>
<Value name="20">
<Value>ORGWebSite</Value>
</Value>
<Value name="21">
<Value>ORGFoundDate</Value>
</Value>
<Value name="22">
<Value>ORGCancelDate</Value>
</Value>
<Value name="23">
<Value>ORGActivity</Value>
</Value>
<Value name="24">
<Value>ORGStartDate</Value>
</Value>
<Value name="25">
<Value>ORGEndDate</Value>
</Value>
<Value name="26">
<Value>ORGCreateDate</Value>
</Value>
<Value name="27">
<Value>ORGCreateTime</Value>
</Value>
<Value name="28">
<Value>ORGCreateUser</Value>
</Value>
<Value name="29">
<Value>ORGSeqNo</Value>
</Value>
<Value name="30">
<Value>ORGLastUpdateDate</Value>
</Value>
<Value name="31">
<Value>ORGLastUpdateTime</Value>
</Value>
<Value name="32">
<Value>ORGLastUpdateUser</Value>
</Value>
<Value name="33">
<Value>ORGPYCode</Value>
</Value>
<Value name="34">
<Value>ORGWBCode</Value>
</Value>
<Value name="35">
<Value>ORGMark</Value>
</Value>
<Value name="36">
<Value>ORGStandardCode</Value>
</Value>
<Value name="37">
<Value>ORGStandardDesc</Value>
</Value>
<Value name="38">
<Value>ORGCodeBefore</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrganizationD</DataLocation>
<DefaultData>HOSOrganizationDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrganizationD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrganizationI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrganizationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
