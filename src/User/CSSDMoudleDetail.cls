Class User.CSSDMoudleDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDMD_Rowid, SqlTableName = CSSD_MoudleDetail ]
{

/// 主表ID
Property CSSDMDParref As User.CSSDMoudle [ SqlColumnNumber = 2, SqlFieldName = CSSDMD_Parref ];

/// 消毒包Dr
Property CSSDMDPackage As User.CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = CSSDMD_Package ];

/// 申请数量
Property CSSDMDQty As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDMD_Qty ];

/// 模板名称
Property CSSDMDRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDMD_Remark ];

Property CSSDMDPrice As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDMD_Price ];

/// 包装材料字典
Property CSSDMDMaterialDR As User.CSSDMaterial [ SqlColumnNumber = 7, SqlFieldName = CSSDMD_Material_DR ];

Index CSSDMDParrefIndex On CSSDMDParref As Exact;

Storage Default
{
<Data name="CSSDMoudleDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDMDParref</Value>
</Value>
<Value name="3">
<Value>CSSDMDPackage</Value>
</Value>
<Value name="4">
<Value>CSSDMDQty</Value>
</Value>
<Value name="5">
<Value>CSSDMDRemark</Value>
</Value>
<Value name="6">
<Value>CSSDMDPrice</Value>
</Value>
<Value name="7">
<Value>CSSDMDMaterialDR</Value>
</Value>
</Data>
<DataLocation>^User.CSSDMoudleDetailD</DataLocation>
<DefaultData>CSSDMoudleDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDMoudleDetailD</IdLocation>
<IndexLocation>^User.CSSDMoudleDetailI</IndexLocation>
<SqlRowIdName>CSSDMD_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDMoudleDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
