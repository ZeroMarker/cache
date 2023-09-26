/// creator: xbl
/// createdate: 20180112
/// description: 护士长夜查房检查内容
Class DHCNMG.Arg.MgCheckContent Extends %Persistent
{

/// 描述
Property ContentDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Content_Desc ];

/// 启用日期
Property ContentStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Content_StDate ];

/// 结束日期
Property ContentEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Content_EndDate ];

/// 创建者
Property ContentCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 5, SqlFieldName = Content_CrtUser ];

/// 创建日期
Property ContentCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = Content_CrtDate ];

/// 创建时间
Property ContentCrtTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = Content_CrtTime ];

/// 类型
Property ContentType As %String [ SqlColumnNumber = 8, SqlFieldName = Content_Type ];

Index TypeDesc On (ContentType, ContentDesc);

Storage Default
{
<Data name="MgCheckContentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContentDesc</Value>
</Value>
<Value name="3">
<Value>ContentStDate</Value>
</Value>
<Value name="4">
<Value>ContentEndDate</Value>
</Value>
<Value name="5">
<Value>ContentCrtUser</Value>
</Value>
<Value name="6">
<Value>ContentCrtDate</Value>
</Value>
<Value name="7">
<Value>ContentCrtTime</Value>
</Value>
<Value name="8">
<Value>ContentType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgCheckContentD</DataLocation>
<DefaultData>MgCheckContentDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgCheckContentD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgCheckContentI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgCheckContentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
