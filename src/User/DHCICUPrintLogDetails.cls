/// DHC_ICU_PrintLogDetails
Class User.DHCICUPrintLogDetails Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_PrintLogDetails ]
{

/// 打印记录Id
Property PrintLogId As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 类型
Property Type As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 坐标1
Property Point1 As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 坐标2
Property Point2 As %String(MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 坐标3
Property Point3 As %String(MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 文本内容
Property TextNote As %String(MAXLEN = 999) [ SqlColumnNumber = 7 ];

/// 属性
Property Style As %String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 颜色
Property Color As %String(MAXLEN = 200) [ SqlColumnNumber = 9 ];

/// 宽度
Property Width As %String(MAXLEN = 200) [ SqlColumnNumber = 10 ];

/// 高度
Property Heigh As %String(MAXLEN = 200) [ SqlColumnNumber = 11 ];

/// 文本字体
Property TextFont As %String(MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 模板代码
Property TemplateCode As %String(MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 重症Id索引
Index IPrintLogId On PrintLogId;

Storage Default
{
<Data name="DHCICUPrintLogDetailsDefaultData">
<Value name="1">
<Value>PrintLogId</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>StartPoint</Value>
</Value>
<Value name="4">
<Value>EndPoint</Value>
</Value>
<Value name="5">
<Value>TextNote</Value>
</Value>
<Value name="6">
<Value>Style</Value>
</Value>
<Value name="7">
<Value>Color</Value>
</Value>
<Value name="8">
<Value>LineWidth</Value>
</Value>
<Value name="9">
<Value>TextFont</Value>
</Value>
<Value name="10">
<Value>Point1</Value>
</Value>
<Value name="11">
<Value>Point2</Value>
</Value>
<Value name="12">
<Value>Point3</Value>
</Value>
<Value name="13">
<Value>Width</Value>
</Value>
<Value name="14">
<Value>Heigh</Value>
</Value>
<Value name="15">
<Value>TemplateCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUPrintLogDetailsD</DataLocation>
<DefaultData>DHCICUPrintLogDetailsDefaultData</DefaultData>
<IdLocation>^User.DHCICUPrintLogDetailsD</IdLocation>
<IndexLocation>^User.DHCICUPrintLogDetailsI</IndexLocation>
<StreamLocation>^User.DHCICUPrintLogDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
