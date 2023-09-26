/// 团体职业病信息
Class User.DHCPEOccuGBaseInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OccuGBaseInfo ]
{

Parameter ClassName = "User.DHCPEOccuGBaseInfo";

/// DHC_PE_PreGBaseInfo
Property OGBIPreGBIDR As User.DHCPEPreGBaseInfo [ SqlFieldName = OGBI_PreGBI_DR ];

/// 企业名称
Property OGBIName As %String(MAXLEN = 100) [ SqlFieldName = OGBI_Name ];

/// 社会信用代码
Property OGBICreditCode As %String [ SqlFieldName = OGBI_CreditCode ];

/// 是否分支机构
Property OGBISubOrgFlag As %String [ SqlFieldName = OGBI_SubOrgFlag ];

/// 上级单位社会信用代码
Property OGBIUpCreditCode As %String [ SqlFieldName = OGBI_UpCreditCode ];

/// 所属省
Property OGBIProvince As %String [ SqlFieldName = OGBI_Province ];

/// 所属市
Property OGBICity As %String [ SqlFieldName = OGBI_City ];

/// 所属县区
Property OGBICounty As %String [ SqlFieldName = OGBI_County ];

/// 所属镇 街道
Property OGBITown As %String [ SqlFieldName = OGBI_Town ];

/// 行业类别
Property OGBIIndusType As %String [ SqlFieldName = OGBI_IndusType ];

/// 经济类型
Property OGBIEconomy As %String [ SqlFieldName = OGBI_Economy ];

/// 企业规模
Property OGBICrptSize As %String [ SqlFieldName = OGBI_CrptSize ];

/// 单位注册地址
Property OGBIAddress As %String(MAXLEN = 100) [ SqlFieldName = OGBI_Address ];

/// 法人联系电话
Property OGBICorporationTel As %String [ SqlFieldName = OGBI_CorporationTel ];

/// 法人代表
Property OGBICorporateDeputy As %String [ SqlFieldName = OGBI_CorporateDeputy ];

/// 单位注册邮编
Property OGBIPostalCode As %String [ SqlFieldName = OGBI_PostalCode ];

/// 经营面积
Property OGBIWorkArea As %String [ SqlFieldName = OGBI_WorkArea ];

/// 注册资金
Property OGBIRegFund As %String [ SqlFieldName = OGBI_RegFund ];

/// 建档日期
Property OGBIFilingDate As %Date [ SqlFieldName = OGBI_FilingDate ];

/// 建厂日期
Property OGBIBuildDate As %Date [ SqlFieldName = OGBI_BuildDate ];

/// 职业卫生安全负责人
Property OGBISafeLinkMan As %String [ SqlFieldName = OGBI_SafeLinkMan ];

/// 职业卫生安全联系人职务
Property OGBISafePosition As %String [ SqlFieldName = OGBI_SafePosition ];

/// 职业卫生安全联系人电话
Property OGBISafeLinkTel As %String [ SqlFieldName = OGBI_SafeLinkTel ];

/// 检测联系人
Property OGBIChkLinkMan As %String [ SqlFieldName = OGBI_ChkLinkMan ];

/// 检测联系人职务
Property OGBIChkPosition As %String [ SqlFieldName = OGBI_ChkPosition ];

/// 检测联系人电话
Property OGBIChkLinkTel As %String [ SqlFieldName = OGBI_ChkLinkTel ];

/// 体检联系人
Property OGBIPELinkMan As %String [ SqlFieldName = OGBI_PELinkMan ];

/// 体检联系人职务
Property OGBIPEPosition As %String [ SqlFieldName = OGBI_PEPosition ];

/// 体检联系人电话
Property OGBIPELinkTel As %String [ SqlFieldName = OGBI_PELinkTel ];

/// 隶属关系
Property OGBISubjeConn As %String [ SqlFieldName = OGBI_SubjeConn ];

/// 作业场所地址
Property OGBIEnrolAddress As %String(MAXLEN = 100) [ SqlFieldName = OGBI_EnrolAddress ];

/// 作业场所邮政编码
Property OGBIEnrolPostalCode As %String [ SqlFieldName = OGBI_EnrolPostalCode ];

/// 职业卫生管理机构
Property OGBIOccuManaOffice As %String(MAXLEN = 100) [ SqlFieldName = OGBI_OccuManaOffice ];

/// 职工人数
Property OGBIWorkForce As %Integer [ SqlFieldName = OGBI_WorkForce ];

/// 女职工人数
Property OGBIFemaleWorkForce As %Integer [ SqlFieldName = OGBI_FemaleWorkForce ];

/// 生产工人数
Property OGBIWorkNum As %Integer [ SqlFieldName = OGBI_WorkNum ];

/// 生产女工人数
Property OGBIFemaleWorkNum As %Integer [ SqlFieldName = OGBI_FemaleWorkNum ];

/// 接触职业病危害因素人数
Property OGBIExposureEndanges As %Integer [ SqlFieldName = OGBI_ExposureEndanges ];

/// 接触职业病危害因素女工人数
Property OGBIFemaleExpEndanges As %Integer [ SqlFieldName = OGBI_FemaleExpEndanges ];

Index PreGBaseInfoIndex On OGBIPreGBIDR [ Unique ];

Storage Default
{
<Data name="DHCPEOccuGBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OGBIPreGBIDR</Value>
</Value>
<Value name="3">
<Value>OGBIName</Value>
</Value>
<Value name="4">
<Value>OGBICreditCode</Value>
</Value>
<Value name="5">
<Value>OGBISubOrgFlag</Value>
</Value>
<Value name="6">
<Value>OGBIUpCreditCode</Value>
</Value>
<Value name="7">
<Value>OGBIProvince</Value>
</Value>
<Value name="8">
<Value>OGBICity</Value>
</Value>
<Value name="9">
<Value>OGBICounty</Value>
</Value>
<Value name="10">
<Value>OGBITown</Value>
</Value>
<Value name="11">
<Value>OGBIIndusType</Value>
</Value>
<Value name="12">
<Value>OGBIEconomy</Value>
</Value>
<Value name="13">
<Value>OGBICrptSize</Value>
</Value>
<Value name="14">
<Value>OGBIAddress</Value>
</Value>
<Value name="15">
<Value>OGBICorporationTel</Value>
</Value>
<Value name="16">
<Value>OGBICorporateDeputy</Value>
</Value>
<Value name="17">
<Value>OGBIPostalCode</Value>
</Value>
<Value name="18">
<Value>OGBIWorkArea</Value>
</Value>
<Value name="19">
<Value>OGBIRegFund</Value>
</Value>
<Value name="20">
<Value>OGBIFilingDate</Value>
</Value>
<Value name="21">
<Value>OGBIBuildDate</Value>
</Value>
<Value name="22">
<Value>OGBISafeLinkMan</Value>
</Value>
<Value name="23">
<Value>OGBISafePosition</Value>
</Value>
<Value name="24">
<Value>OGBISafeLinkTel</Value>
</Value>
<Value name="25">
<Value>OGBIChkLinkMan</Value>
</Value>
<Value name="26">
<Value>OGBIChkPosition</Value>
</Value>
<Value name="27">
<Value>OGBIChkLinkTel</Value>
</Value>
<Value name="28">
<Value>OGBIPELinkMan</Value>
</Value>
<Value name="29">
<Value>OGBIPEPosition</Value>
</Value>
<Value name="30">
<Value>OGBIPELinkTel</Value>
</Value>
<Value name="31">
<Value>OGBISubjeConn</Value>
</Value>
<Value name="32">
<Value>OGBIEnrolAddress</Value>
</Value>
<Value name="33">
<Value>OGBIEnrolPostalCode</Value>
</Value>
<Value name="34">
<Value>OGBIOccuManaOffice</Value>
</Value>
<Value name="35">
<Value>OGBIWorkForce</Value>
</Value>
<Value name="36">
<Value>OGBIFemaleWorkForce</Value>
</Value>
<Value name="37">
<Value>OGBIWorkNum</Value>
</Value>
<Value name="38">
<Value>OGBIFemaleWorkNum</Value>
</Value>
<Value name="39">
<Value>OGBIExposureEndanges</Value>
</Value>
<Value name="40">
<Value>OGBIFemaleExpEndanges</Value>
</Value>
</Data>
<DataLocation>^CB.PE.OccuGBaseInfoD</DataLocation>
<DefaultData>DHCPEOccuGBaseInfoDefaultData</DefaultData>
<IdLocation>^CB.PE.OccuGBaseInfoD</IdLocation>
<IndexLocation>^CB.PE.OccuGBaseInfoI</IndexLocation>
<StreamLocation>^CB.PE.OccuGBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
