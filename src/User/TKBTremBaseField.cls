/// 术语库字段信息表：TKB_TremBaseField （子）
Class User.TKBTremBaseField Extends %Persistent [ SqlTableName = TKB_TremBaseField ]
{

Relationship ParRef As User.TKBTremBase [ Cardinality = parent, Inverse = ChildField ];

Property TKBTRBCode As %String [ Required, SqlFieldName = TKBTRB_Code ];

Property TKBTRBDesc As %String [ SqlFieldName = TKBTRB_Desc ];

Property TKBTRBType As %String(DISPLAYLIST = ",文本,数据来源,上传文档,单选框,复选框,下拉框,多行文本框,引用属性内容", VALUELIST = ",T,S,U,R,CB,C,TA,SD") [ SqlFieldName = TKBTRB_Type ];

Property TKBTRBNote As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlFieldName = TKBTRB_Note ];

Property TKBTRBConfig As %String [ SqlFieldName = TKBTRB_Config ];

Property TKBTRBFlag As %String(DISPLAYLIST = ",代码,中心词,检索码,上级分类,备注,映射,映射状态,反向映射", VALUELIST = ",C,D,P,L,N,CT,MS,RM") [ SqlFieldName = TKBTRB_Flag ];

Property TKBTRBSort As %Float [ SqlFieldName = TKBTRB_Sort ];

Property TKBTRBRequire As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlFieldName = TKBTRB_Require ];

Index UnCodeIndex On (ParRef, TKBTRBCode) [ Unique ];

Index DescIndex On (ParRef, TKBTRBDesc);

Index SortIndex On (ParRef, TKBTRBSort);

Index CodeIndex On TKBTRBCode;

Storage Default
{
<Data name="TKBTremBaseFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBTRBCode</Value>
</Value>
<Value name="3">
<Value>TKBTRBDesc</Value>
</Value>
<Value name="4">
<Value>TKBTRBType</Value>
</Value>
<Value name="5">
<Value>TKBTRBNote</Value>
</Value>
<Value name="6">
<Value>TKBTRBConfig</Value>
</Value>
<Value name="7">
<Value>TKBTRBFlag</Value>
</Value>
<Value name="8">
<Value>TKBTRBSort</Value>
</Value>
<Value name="9">
<Value>TKBTRBRequire</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>TKBTremBaseFieldDefaultData</DefaultData>
<IdLocation>^User.TKBTremBaseC("ChildField")</IdLocation>
<IndexLocation>^User.TKBTremBaseFieldI</IndexLocation>
<StreamLocation>^User.TKBTremBaseFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
