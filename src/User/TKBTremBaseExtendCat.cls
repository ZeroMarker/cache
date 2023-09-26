/// 术语扩展属性子表
Class User.TKBTremBaseExtendCat Extends %Persistent [ SqlTableName = TKB_TremBaseExtendCat ]
{

Relationship ParRef As User.TKBTremBaseExtend [ Cardinality = parent, Inverse = ChildCat ];

Property TKBTRBECName As %String [ SqlColumnNumber = 2, SqlFieldName = TKBTRBEC_Name ];

Property TKBTRBECType As %String(DISPLAYLIST = ",文本,数据来源,上传文档,单选框,复选框,下拉框,多行文本框,引用属性内容", VALUELIST = ",T,S,U,R,CB,C,TA,SD") [ SqlColumnNumber = 3, SqlFieldName = TKBTRBEC_Type ];

Property TKBTRBECConfig As %String [ SqlColumnNumber = 4, SqlFieldName = TKBTRBEC_Config ];

Index NameIndex On (ParRef As Exact, TKBTRBECName As Exact);

Storage Default
{
<Data name="TKBTremBaseExtendCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBTRBECName</Value>
</Value>
<Value name="3">
<Value>TKBTRBECType</Value>
</Value>
<Value name="4">
<Value>TKBTRBECConfig</Value>
</Value>
</Data>
<DataLocation>^User.TKBTremBaseExtendCatD</DataLocation>
<DefaultData>TKBTremBaseExtendCatDefaultData</DefaultData>
<IdLocation>^User.TKBTremBaseExtendCatD</IdLocation>
<IndexLocation>^User.TKBTremBaseExtendCatI</IndexLocation>
<StreamLocation>^User.TKBTremBaseExtendCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
