/// 1、人员基本信息DHC_HM_OBaseInfo
Class User.DHCHMOBaseInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_OBaseInfo ]
{

Parameter ClassName = "User.DHCHMOBaseInfo";

/// 2	BI_Code	编码	Text	19	NOT NULL	唯一	
Property BICode As %String(MAXLEN = 19) [ Required ];

Index BICodeIndex On BICode [ Unique ];

/// 3	BI_PassWord	密码
Property BIPassWord As %String;

/// 4	BI_PAPMINo	登记号	Text	PA_Patmas表的PAPMI_No字段
Property BIPAPMINo As %String;

/// 	BI_CCertificateType_DR	证件类型	D				DHC_HM_CCodeTable
Property BICCertificateTypeDR As User.DHCHMCCodeTable;

/// 5	BI_IDCard	身份证号	Text
Property BIIDCard As %String;

/// 6	BI_Name	姓名	Text	3	
Property BIName As %String;

/// 	BI_InputCode	输入码					拼音简写
Property BIInputCode As %String;

/// 7	BI_CSex_DR	性别		1			DHC_HM_CCodeTable
Property BICSexDR As User.DHCHMCCodeTable;

/// 8	BI_CNation_DR	民族					指向民族表DHC_HM_CCodeTable
Property BICNationDR As User.DHCHMCCodeTable;

/// 9	BI_DOB	出生日期
Property BIDOB As %Date;

/// 	BI_PostCode	邮编	
Property BIPostCode As %String;

/// 10	BI_City	居住城市
Property BICity As %String;

/// 11	BI_Address	联系地址
Property BIAddress As %String;

/// 12	BI_MobilePhone	手机
Property BIMobilePhone As %String;

/// 13	BI_Tel	电话
Property BITel As %String;

/// 14	BI_Email	电子邮箱
Property BIEmail As %String;

/// 15	BI_Company	公司	
Property BICompany As %String;

/// 16	BI_CMarital_DR	婚否					DHC_HM_CCodeTable
Property BICMaritalDR As User.DHCHMCCodeTable;

/// 	BI_COccupation_DR	职业					DHC_HM_CCodeTable
Property BICOccupationDR As User.DHCHMCCodeTable;

/// 	BI_CEducation_DR	学历					DHC_HM_CCodeTable
Property BICEducationDR As User.DHCHMCCodeTable;

/// 17	BI_CUserType_DR	人员类别					指向DHC_HM_CCodeTable
Property BICUserTypeDR As User.DHCHMCCodeTable;

/// 18	BI_CServiceClass_DR	服务级别					指向服务级别DHC_HM_CServiceClass表
Property BICServiceClassDR As User.DHCHMCServiceClass;

/// 19	BI_HospWebsite	网点					指向CT_Hospital
Property BIHospWebsite As User.CTHospital;

/// 20	BI_Loc_DR	所在科室					指向CT_Loc
Property BILocDR As User.CTLoc;

/// 21	BI_CUserGroup_DR	无原则分组					指向DHC_HM_CCodeTable
Property BICUserGroupDR As User.DHCHMCCodeTable;

/// 22	BI_Doc_DR	责任医生					指向SS_User
Property BIDocDR As User.SSUser;

/// 23	BI_HM_DR	健康管理师					指向SS_User
Property BIHMDR As User.SSUser;

/// 24	BI_Remark	预留字段					可以维护有关的情况
Property BIRemark As %String;

/// 25	BI_AddUser_DR	录入人					指向SS_User
Property BIAddUserDR As User.SSUser;

/// 	BI_Date	录入日期	Date
Property BIAddDate As %Date;

/// 	BI_Time	录入时间	Time	
Property BIAddTime As %Time;

Index BIPAPMINoIndex On BIPAPMINo [ Unique ];

Index BIIDCardIndex On BIIDCard;

Index BINameIndex On BIName;

Index BIInputCodeIndex On BIInputCode;

Index BICSexDRIndex On BICSexDR;

Index BIPostCodeIndex On BIPostCode;

Index BIMobilePhoneIndex On BIMobilePhone;

Index BITelIndex On BITel;

Index BICOccupationDRIndex On BICOccupationDR;

Index BICEducationDRIndex On BICEducationDR;

Index BICServiceClassDRIndex On BICServiceClassDR;

Index BILocDRIndex On BILocDR;

Index BIDocDRIndex On BIDocDR;

Index BIHMDRIndex On BIHMDR;

Storage Default
{
<Data name="DHCHMOBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BIAddUserDR</Value>
</Value>
<Value name="3">
<Value>BIAddress</Value>
</Value>
<Value name="4">
<Value>BICCertificateTypeDR</Value>
</Value>
<Value name="5">
<Value>BICEducationDR</Value>
</Value>
<Value name="6">
<Value>BICMaritalDR</Value>
</Value>
<Value name="7">
<Value>BICNationDR</Value>
</Value>
<Value name="8">
<Value>BICOccupationDR</Value>
</Value>
<Value name="9">
<Value>BICServiceClassDR</Value>
</Value>
<Value name="10">
<Value>BICSexDR</Value>
</Value>
<Value name="11">
<Value>BICUserGroupDR</Value>
</Value>
<Value name="12">
<Value>BICUserTypeDR</Value>
</Value>
<Value name="13">
<Value>BICity</Value>
</Value>
<Value name="14">
<Value>BICode</Value>
</Value>
<Value name="15">
<Value>BICompany</Value>
</Value>
<Value name="16">
<Value>BIDOB</Value>
</Value>
<Value name="17">
<Value>BIDate</Value>
</Value>
<Value name="18">
<Value>BIDocDR</Value>
</Value>
<Value name="19">
<Value>BIEmail</Value>
</Value>
<Value name="20">
<Value>BIHMDR</Value>
</Value>
<Value name="21">
<Value>BIHospWebsite</Value>
</Value>
<Value name="22">
<Value>BIIDCard</Value>
</Value>
<Value name="23">
<Value>BIInputCode</Value>
</Value>
<Value name="24">
<Value>BILocDR</Value>
</Value>
<Value name="25">
<Value>BIMobilePhone</Value>
</Value>
<Value name="26">
<Value>BIName</Value>
</Value>
<Value name="27">
<Value>BIPAPMINo</Value>
</Value>
<Value name="28">
<Value>BIPassWord</Value>
</Value>
<Value name="29">
<Value>BIPostCode</Value>
</Value>
<Value name="30">
<Value>BIRemark</Value>
</Value>
<Value name="31">
<Value>BITel</Value>
</Value>
<Value name="32">
<Value>BITime</Value>
</Value>
<Value name="33">
<Value>BIAddDate</Value>
</Value>
<Value name="34">
<Value>BIAddTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOBaseInfoD</DataLocation>
<DefaultData>DHCHMOBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOBaseInfoD</IdLocation>
<IndexLocation>^User.DHCHMOBaseInfoI</IndexLocation>
<StreamLocation>^User.DHCHMOBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
