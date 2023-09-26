/// Description： 知识提交表
/// Creator：丁亚男
/// Date： 2018-03-26
Class User.MKBKnoManage Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_KnoManage ]
{

/// 代码 （要求自动生成）
Property MKBKMCode As %String(MAXLEN = "") [ SqlFieldName = MKBKM_Code ];

/// 名称
Property MKBKMDesc As %String(MAXLEN = "") [ SqlFieldName = MKBKM_Desc ];

/// 路径
Property MKBKMPath As %String(MAXLEN = "") [ SqlFieldName = MKBKM_Path ];

/// 出处
Property MKBKMSource As %String(MAXLEN = "") [ SqlFieldName = MKBKM_Source ];

/// 上传文件类型
Property MKBKMType As %String(DISPLAYLIST = ",doc,excel,pdf", VALUELIST = ",D,E,P") [ SqlFieldName = MKBKM_Type ];

/// 上传者（从session取）// 2019-09-09改为字符串类型，微信小程序用
Property MKBKMUpdateUser As %String [ SqlFieldName = MKBKM_UpdateUser ];

/// 上传日期
Property MKBKMUpdateDate As %Date [ SqlFieldName = MKBKM_UpdateDate ];

/// 审核状态
Property MKBKMFlag As %String(DISPLAYLIST = ",初传,审核通过,审核不通过", VALUELIST = ",F,Y,N") [ SqlFieldName = MKBKM_Flag ];

/// 备注
Property MKBKMNote As %String(MAXLEN = "") [ SqlFieldName = MKBKM_Note ];

/// 科室（从session取）
Property MKBKMUpdateLoc As User.CTLoc [ SqlFieldName = MKBKM_UpdateLoc ];

/// 术语ID
Property MKBKMTermDr As User.MKBTerm [ SqlFieldName = MKBKM_Term_Dr ];

/// 属性ID
Property MKBKMProDr As User.MKBTermProperty [ SqlFieldName = MKBKM_Pro_Dr ];

/// 基础内容id串
Property MKBKMDetail As %String(MAXLEN = "") [ SqlFieldName = MKBKM_Detail ];

/// 微信小程序(mini)和电脑端(computer)的区分标志
Property MKBKMMiniFlag As %String(DISPLAYLIST = ",微信小程序,电脑端", VALUELIST = ",M,C") [ SqlFieldName = MKBKM_MiniFlag ];

/// 审核不通过的原因
Property MKBKMFailureReason As %String(MAXLEN = "") [ SqlFieldName = MKBKM_FailureReason ];

Index CodeIndex On MKBKMCode [ Unique ];

Index TermIndex On MKBKMTermDr;

Index ExtIndex On MKBKMProDr;

Storage Default
{
<Data name="MKBKnoManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBKMCode</Value>
</Value>
<Value name="3">
<Value>MKBKMDesc</Value>
</Value>
<Value name="4">
<Value>MKBKMPath</Value>
</Value>
<Value name="5">
<Value>MKBKMSource</Value>
</Value>
<Value name="6">
<Value>MKBKMType</Value>
</Value>
<Value name="7">
<Value>MKBKMUpdateUser</Value>
</Value>
<Value name="8">
<Value>MKBKMUpdateDate</Value>
</Value>
<Value name="9">
<Value>MKBKMFlag</Value>
</Value>
<Value name="10">
<Value>MKBKMNote</Value>
</Value>
<Value name="11">
<Value>MKBKMUpdateLoc</Value>
</Value>
<Value name="12">
<Value>MKBKMTermDr</Value>
</Value>
<Value name="13">
<Value>MKBKMProDr</Value>
</Value>
<Value name="14">
<Value>MKBKMDetail</Value>
</Value>
<Value name="15">
<Value>MKBKMMiniFlag</Value>
</Value>
<Value name="16">
<Value>MKBKMFailureReason</Value>
</Value>
</Data>
<DataLocation>^User.MKBKnoManageD</DataLocation>
<DefaultData>MKBKnoManageDefaultData</DefaultData>
<IdLocation>^User.MKBKnoManageD</IdLocation>
<IndexLocation>^User.MKBKnoManageI</IndexLocation>
<StreamLocation>^User.MKBKnoManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
