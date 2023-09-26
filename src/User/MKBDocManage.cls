/// 术语文献管理
Class User.MKBDocManage Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBDM_RowId, SqlTableName = MKB_DocManage ]
{

/// 文献代码
Property MKBDMCode As %String(MAXLEN = "") [ SqlFieldName = MKBDM_Code ];

/// 文献名
Property MKBDMDesc As %String(MAXLEN = "") [ SqlFieldName = MKBDM_Desc ];

/// 文献存放路径
Property MKBDMPath As %String(MAXLEN = "") [ SqlFieldName = MKBDM_Path ];

/// 文献出处
Property MKBDMSource As %String(MAXLEN = "") [ SqlFieldName = MKBDM_Source ];

/// 文献类型
Property MKBDMType As %String(DISPLAYLIST = ",doc,excel,pdf", VALUELIST = ",D,E,P") [ SqlFieldName = MKBDM_Type ];

/// 文献上传人
Property MKBDMUpdateUser As User.SSUser [ SqlFieldName = MKBDM_UpdateUser ];

/// 文献上传时间
Property MKBDMUpdateDate As %Date [ SqlFieldName = MKBDM_UpdateDate ];

/// 关键词
Property MKBDMKeyWord As %String(MAXLEN = "") [ SqlFieldName = MKBDM_KeyWord ];

/// 审核状态
Property MKBDMFlag As %String(DISPLAYLIST = ",初传,审核通过,审核不通过", VALUELIST = ",F,Y,N") [ SqlFieldName = MKBDM_Flag ];

/// 备注
Property MKBDMNote As %String(MAXLEN = "") [ SqlFieldName = MKBDM_Note ];

/// 文献分类
Property MKBDMClassify As %String(MAXLEN = "") [ SqlFieldName = MKBDM_Classify ];

Index CodeIndex On MKBDMCode;

Index DescIndex On MKBDMDesc;

Storage Default
{
<Data name="MKBDocManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBDMCode</Value>
</Value>
<Value name="3">
<Value>MKBDMDesc</Value>
</Value>
<Value name="4">
<Value>MKBDMPath</Value>
</Value>
<Value name="5">
<Value>MKBDMSource</Value>
</Value>
<Value name="6">
<Value>MKBDMType</Value>
</Value>
<Value name="7">
<Value>MKBDMUpdateUser</Value>
</Value>
<Value name="8">
<Value>MKBDMUpdateDate</Value>
</Value>
<Value name="9">
<Value>MKBDMKeyWord</Value>
</Value>
<Value name="10">
<Value>MKBDMFlag</Value>
</Value>
<Value name="11">
<Value>MKBDMNote</Value>
</Value>
<Value name="12">
<Value>MKBDMClassify</Value>
</Value>
</Data>
<DataLocation>^User.MKBDocManageD</DataLocation>
<DefaultData>MKBDocManageDefaultData</DefaultData>
<IdLocation>^User.MKBDocManageD</IdLocation>
<IndexLocation>^User.MKBDocManageI</IndexLocation>
<StreamLocation>^User.MKBDocManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
