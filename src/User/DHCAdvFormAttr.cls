/// 表单属性
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormAttr Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormAttr ]
{

// 表单

Property formItm As User.DHCAdvForm [ SqlColumnNumber = 2, SqlFieldName = formItm ];

// 表单字典 

Property formDic As User.DHCAdvFormDic [ SqlColumnNumber = 3, SqlFieldName = formDic ];

// 是否必填

// on:必填

// 其他:不必填

Property required As %String [ SqlColumnNumber = 4, SqlFieldName = required ];

// 不打印序号

// on:不打印

// 其他:打印

Property printSeq As %String [ SqlColumnNumber = 5, SqlFieldName = print_seq ];

// 不打印元素

// on:不打印

// 其他:打印

Property print As %String [ SqlColumnNumber = 6, SqlFieldName = print ];

// css style 样式

Property style As %String(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = style ];

Storage Default
{
<Data name="DHCAdvFormAttrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>formItm</Value>
</Value>
<Value name="3">
<Value>formDic</Value>
</Value>
<Value name="4">
<Value>required</Value>
</Value>
<Value name="5">
<Value>printSeq</Value>
</Value>
<Value name="6">
<Value>print</Value>
</Value>
<Value name="7">
<Value>formName</Value>
</Value>
<Value name="8">
<Value>style</Value>
</Value>
</Data>
<DataLocation>^User.DHCADVFormAttrD</DataLocation>
<DefaultData>DHCAdvFormAttrDefaultData</DefaultData>
<IdLocation>^User.DHCADVFormAttrD</IdLocation>
<IndexLocation>^User.DHCADVFormAttrI</IndexLocation>
<StreamLocation>^User.DHCADVFormAttrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexItmDic On (formItm, formDic);

}
