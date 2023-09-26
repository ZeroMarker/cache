/// 表单记录明细表
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormRecordItm Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormRecordItm ]
{

Property parrRef As User.DHCAdvFormRecord [ SqlColumnNumber = 2, SqlFieldName = parrRef ];

Property form As User.DHCAdvForm [ SqlColumnNumber = 3, SqlFieldName = form ];

Property value As %String(MAXLEN = 5000) [ SqlColumnNumber = 4, SqlFieldName = value ];

Property formDic As User.DHCAdvFormDic [ SqlColumnNumber = 5, SqlFieldName = formDic ];

/// datagrid 元素每行的标识
Property datagridRowKey As %String [ SqlColumnNumber = 6, SqlFieldName = datagridRowKey ];

/// datagrid 用
Property parrRefDic As %String [ SqlColumnNumber = 7, SqlFieldName = parrRefDic ];

/// 表单元素关联表单版本号
Property dicFormVersion As %String [ SqlColumnNumber = 8, SqlFieldName = dicFormVersion ];

Index IndexFormRecord On parrRef;

Index IndexDic On (parrRef, formDic);

Storage Default
{
<Data name="DHCAdvFormRecordItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>parrRef</Value>
</Value>
<Value name="3">
<Value>formDic</Value>
</Value>
<Value name="4">
<Value>value</Value>
</Value>
<Value name="5">
<Value>form</Value>
</Value>
<Value name="6">
<Value>pid</Value>
</Value>
<Value name="7">
<Value>datagridRowKey</Value>
</Value>
<Value name="8">
<Value>parrRefDic</Value>
</Value>
<Value name="9">
<Value>version</Value>
</Value>
<Value name="10">
<Value>dicFormVersion</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormRecordItmD</DataLocation>
<DefaultData>DHCAdvFormRecordItmDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormRecordItmD</IdLocation>
<IndexLocation>^User.DHCAdvFormRecordItmI</IndexLocation>
<StreamLocation>^User.DHCAdvFormRecordItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexFormDic On (parrRef, form, formDic);

Index IndexRowKey On (parrRef, form, parrRefDic As AlphaUp, datagridRowKey As AlphaUp, formDic);

// Index IndexFormDicValue On (parrRef, form, formDic, value As AlphaUp);

Index IndexRefFormDic On (parrRef, parrRefDic As AlphaUp, formDic);

}
