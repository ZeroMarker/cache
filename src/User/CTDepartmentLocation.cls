/// 描述: HIS-Location与HR-组织关联关系表(HCP)
/// 编写者：基础数据平台 chenying
/// 编写日期: 2020-07-21
Class User.CTDepartmentLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = CT_DepartmentLocation ]
{

/// 指向组织部门表，存ID
Property DEPLDeptDR As User.CTDepartment [ Required ];

/// Location 来源,如CT_Loc/LIS/PACS/病理
Property DEPLLocSource As %String [ Required ];

/// Location rowid，如果Location 来源是CT_Loc,LocationID存对应的科室rowid；其他的来源，LocationID可以为空
Property DEPLLocID As %String;

/// 引用iMedical HIS【CT_Loc】表中Location代码或在专业IT系统中自定义的Location代码
Property DEPLLocCode As %String(MAXLEN = 300, TRUNCATE = 1);

/// 引用iMedical HIS【CT_Loc】表中Location名称或在专业IT系统中定义的Location名称
Property DEPLLocDesc As %String(MAXLEN = 300, TRUNCATE = 1);

/// 上次Location 来源,如CT_Loc/LIS/PACS/病理
Property DEPLParentLocSource As %String;

/// 上级 Location rowid ,指当前Location的上级LocationID，指向本表中的LocationID，可以为空
Property DEPLParentLocID As %String;

/// 指当前Location的上级Location代码，指向本表中的Location代码，可以为空
Property DEPLParentLocCode As %String(MAXLEN = 300, TRUNCATE = 1);

/// 指当前Location的上级Location名称，指向本表中的Location名称，可以为空
Property DEPLParentLocDesc As %String(MAXLEN = 300, TRUNCATE = 1);

/// 开始日期 ，取值来源于CT_Loc、或者专业系统的定义
Property DEPLDateFrom As %Date;

/// 结束日期 ，取值来源于CT_Loc、或者专业系统的定义
Property DEPLDateTo As %Date;

// hr组织部门索引

Index DEPLDeptDR On DEPLDeptDR;

// Location代码索引

Index DEPLLocCode On DEPLLocCode;

// Location名称索引

Index DEPLLocDesc On DEPLLocDesc;

// Location来源索引

Index DEPLLocSource On DEPLLocSource As Exact;

Storage Default
{
<Data name="CTDepartmentLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DEPLDeptDR</Value>
</Value>
<Value name="3">
<Value>DEPLLocSource</Value>
</Value>
<Value name="4">
<Value>DEPLLocID</Value>
</Value>
<Value name="5">
<Value>DEPLLocCode</Value>
</Value>
<Value name="6">
<Value>DEPLLocDesc</Value>
</Value>
<Value name="7">
<Value>DEPLParentLocSource</Value>
</Value>
<Value name="8">
<Value>DEPLParentLocID</Value>
</Value>
<Value name="9">
<Value>DEPLParentLocCode</Value>
</Value>
<Value name="10">
<Value>DEPLParentLocDesc</Value>
</Value>
<Value name="11">
<Value>DEPLDateFrom</Value>
</Value>
<Value name="12">
<Value>DEPLDateTo</Value>
</Value>
</Data>
<DataLocation>^User.CTDepartmentLocationD</DataLocation>
<DefaultData>CTDepartmentLocationDefaultData</DefaultData>
<IdLocation>^User.CTDepartmentLocationD</IdLocation>
<IndexLocation>^User.CTDepartmentLocationI</IndexLocation>
<StreamLocation>^User.CTDepartmentLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
