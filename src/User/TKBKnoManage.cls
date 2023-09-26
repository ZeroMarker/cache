/// Description： 知识提交表
/// Creator：谷雪萍
/// Date： 2017-08-21
Class User.TKBKnoManage Extends %Persistent [ SqlTableName = TKB_KnoManage ]
{

/// 代码 （要求自动生成）
Property TKBKnoCode As %String [ SqlFieldName = TKBKno_Code ];

/// 名称
Property TKBKnoDesc As %String [ SqlFieldName = TKBKno_Desc ];

/// 路径
Property TKBKnoPath As %String [ SqlFieldName = TKBKno_Path ];

/// 出处
Property TKBKnoSource As %String [ SqlFieldName = TKBKno_Source ];

/// 上传文件类型
Property TKBKnoType As %String(DISPLAYLIST = ",doc,excel,pdf", VALUELIST = ",D,E,P") [ SqlFieldName = TKBKno_Type ];

/// 上传者（从session取）
Property TKBKnoUpdateUser As User.SSUser [ SqlFieldName = TKBKno_UpdateUser ];

/// 上传日期
Property TKBKnoUpdateDate As %Date [ SqlFieldName = TKBKno_UpdateDate ];

/// 审核状态
Property TKBKnoFlag As %String [ SqlFieldName = TKBKno_Flag ];

/// 备注
Property TKBKnoNote As %String [ SqlFieldName = TKBKno_Note ];

/// 科室（从session取）
Property TKBKnoUpdateLoc As User.CTLoc [ SqlFieldName = TKBKno_UpdateLoc ];

/// 术语ID
Property TKBKnoTremDr As User.TKBTrem [ SqlFieldName = TKBKno_Trem_Dr ];

/// 属性ID
Property TKBKnoExtDr As User.TKBTremExtend [ SqlFieldName = TKBKno_Ext_Dr ];

Index CodeIndex On TKBKnoCode;

Index TremIndex On TKBKnoTremDr;

Index ExtIndex On TKBKnoExtDr;

Storage Default
{
<Data name="TKBKnoManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBKnoCode</Value>
</Value>
<Value name="3">
<Value>TKBKnoDesc</Value>
</Value>
<Value name="4">
<Value>TKBKnoPath</Value>
</Value>
<Value name="5">
<Value>TKBKnoSource</Value>
</Value>
<Value name="6">
<Value>TKBKnoType</Value>
</Value>
<Value name="7">
<Value>TKBKnoUpdateUser</Value>
</Value>
<Value name="8">
<Value>TKBKnoUpdateDate</Value>
</Value>
<Value name="9">
<Value>TKBKnoFlag</Value>
</Value>
<Value name="10">
<Value>TKBKnoNote</Value>
</Value>
<Value name="11">
<Value>TKBKnoTremDr</Value>
</Value>
<Value name="12">
<Value>TKBKnoExtDr</Value>
</Value>
<Value name="13">
<Value>TKBKnoUpdateLoc</Value>
</Value>
</Data>
<DataLocation>^User.TKBKnoManageD</DataLocation>
<DefaultData>TKBKnoManageDefaultData</DefaultData>
<IdLocation>^User.TKBKnoManageD</IdLocation>
<IndexLocation>^User.TKBKnoManageI</IndexLocation>
<StreamLocation>^User.TKBKnoManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
