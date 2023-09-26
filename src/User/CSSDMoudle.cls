Class User.CSSDMoudle Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDM_Rowid, SqlTableName = CSSD_Moudle ]
{

/// 模板代码
Property CSSDMCode As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CSSDM_Code ];

/// 模板名称
Property CSSDMName As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CSSDM_Name ];

/// 申请科室
Property CSSDMAPPLYLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = CSSDM_APPLYLOCDR ];

/// 申请人
Property CSSDMPAAPPLYUSERDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = CSSDM_APPLYUSERDR ];

/// 紧急程度
Property CSSDMReqLevel As %Integer [ SqlColumnNumber = 6, SqlFieldName = CSSDM_ReqLevel ];

/// 单据类型
Property CSSDMType As %Integer [ SqlColumnNumber = 7, SqlFieldName = CSSDM_Type ];

/// 供应科室
Property CSSDMLOCDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = CSSDM_LOCDR ];

/// 龙岩二院 对应请领主表的CSSDPA_PackageClassDr
Property CSSDMPackageClassDr As User.CSSDPackageClass [ SqlColumnNumber = 9, SqlFieldName = CSSDM_PackageClassDr ];

Property CSSDMPkgApplyDr As User.CSSDPackageApply [ SqlColumnNumber = 10, SqlFieldName = CSSDM_PkgApplyDr ];

Index ApplyLoc On CSSDMAPPLYLOCDR As Exact;

Storage Default
{
<Data name="CSSDMoudleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDMCode</Value>
</Value>
<Value name="3">
<Value>CSSDMName</Value>
</Value>
<Value name="4">
<Value>CSSDMAPPLYLOCDR</Value>
</Value>
<Value name="5">
<Value>CSSDMPAAPPLYUSERDR</Value>
</Value>
<Value name="6">
<Value>CSSDMReqLevel</Value>
</Value>
<Value name="7">
<Value>CSSDMType</Value>
</Value>
<Value name="8">
<Value>CSSDMLOCDR</Value>
</Value>
<Value name="9">
<Value>CSSDMPackageClassDr</Value>
</Value>
<Value name="10">
<Value>CSSDMPkgApplyDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDMoudleD</DataLocation>
<DefaultData>CSSDMoudleDefaultData</DefaultData>
<IdLocation>^User.CSSDMoudleD</IdLocation>
<IndexLocation>^User.CSSDMoudleI</IndexLocation>
<SqlRowIdName>CSSDM_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDMoudleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
