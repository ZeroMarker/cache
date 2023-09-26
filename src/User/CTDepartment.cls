/// 描述: 组织部门表-HCP同步数据
/// 编写者：基础数据平台-陈莹
/// 编写日期: 2020-07-24 
Class User.CTDepartment Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = CT_Department ]
{

/// HR里（MDM平台）的组织部门代码  唯一标识，不能修改
Property DEPRowId As %String(MAXLEN = "") [ Required ];

/// 编码
Property DEPCode As %String(MAXLEN = "");

/// 描述
Property DEPDesc As %String(MAXLEN = "") [ Required ];

/// 简称
Property DEPAlias As %String(MAXLEN = "");

/// 联系电话
Property DEPOfficePhone As %String;

/// HR科室分类  临床科室 01,医技科室 02,医辅科室 03,职能科室 04,其他 99,党群科室 05,后勤科室 06
Property DEPCategory As %String(MAXLEN = "");

/// 上级组织部门ID，指向本身
Property DEPParentDR As User.CTDepartment;

/// HIS医疗机构
Property DEPRefClinDR As User.CTRefClin;

/// 组织属性 行政序列 01,党群序列 02,委员会序列 03,其他序列 09,业务线 04
Property DEPAtrribute As %String;

/// 修改人ID
Property DEPUpdateUserID As User.SSUser;

/// 修改人名称
Property DEPUpdateUserName As %String;

/// 部门性质  门诊 1，住院 2,医技 3。药库 4。药房 5，门诊医辅 6，住院医辅 7，其他医辅 8，物资加工 9，科研 10。教学 11，管理 12
Property DEPCharacter As %String;

/// 支出属性  医疗 1.管理 2,药品 3,加工物资 4
Property DEPPayAtrribute As %String;

/// 是否采购部门 
Property DEPPurchaseFlag As %String;

/// 分摊性质  管理 1,门诊医辅 2,内部定价 3
Property DEPShareCharacter As %String;

/// 开始日期
Property DEPDateFrom As %Date;

/// 结束日期
Property DEPDateTo As %Date;

/// 国家编码
Property DEPNationalCode As %String;

/// 地址
Property DEPOfficeAddress As %String(MAXLEN = "");

Index DEPRowIdRef On DEPRowId As Exact;

Index DEPCodeRef On DEPCode;

Index DEPDescRef On DEPDesc As Exact;

Storage Default
{
<Data name="CTDepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DEPRowId</Value>
</Value>
<Value name="3">
<Value>DEPCode</Value>
</Value>
<Value name="4">
<Value>DEPDesc</Value>
</Value>
<Value name="5">
<Value>DEPAlias</Value>
</Value>
<Value name="6">
<Value>DEPOfficePhone</Value>
</Value>
<Value name="7">
<Value>DEPCategory</Value>
</Value>
<Value name="8">
<Value>DEPParentDR</Value>
</Value>
<Value name="9">
<Value>DEPRefClinDR</Value>
</Value>
<Value name="10">
<Value>DEPAtrribute</Value>
</Value>
<Value name="11">
<Value>DEPUpdateUserID</Value>
</Value>
<Value name="12">
<Value>DEPUpdateUserName</Value>
</Value>
<Value name="13">
<Value>DEPCharacter</Value>
</Value>
<Value name="14">
<Value>DEPPayAtrribute</Value>
</Value>
<Value name="15">
<Value>DEPPurchaseFlag</Value>
</Value>
<Value name="16">
<Value>DEPShareCharacter</Value>
</Value>
<Value name="17">
<Value>DEPDateFrom</Value>
</Value>
<Value name="18">
<Value>DEPDateTo</Value>
</Value>
<Value name="19">
<Value>DEPNationalCode</Value>
</Value>
<Value name="20">
<Value>DEPOfficeAddress</Value>
</Value>
</Data>
<DataLocation>^User.CTDepartmentD</DataLocation>
<DefaultData>CTDepartmentDefaultData</DefaultData>
<IdLocation>^User.CTDepartmentD</IdLocation>
<IndexLocation>^User.CTDepartmentI</IndexLocation>
<StreamLocation>^User.CTDepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
