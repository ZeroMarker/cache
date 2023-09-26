/// 对外接口业务域列表
Class CT.DOC.Interface.AccessProduct Extends (%Persistent, User.Abstract) [ SqlTableName = AccessProduct ]
{

Index IdxCode On ProductCode;

Index IdxDesc On ProductDesc;

/// 业务域代码
Property ProductCode As %String(COLLATION = "Exact", MAXLEN = 99) [ Required, SqlColumnNumber = 2, SqlFieldName = Product_Code ];

/// 业务域描述
Property ProductDesc As %String(COLLATION = "Exact", MAXLEN = 99) [ Required, SqlColumnNumber = 3, SqlFieldName = Product_Desc ];

/// 开始日期
Property ProductStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Product_StDate ];

/// 结束日期
Property ProductEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Product_EndDate ];

/// 关联JS
Property ReferenceJS As %String(MAXLEN = 999) [ SqlColumnNumber = 6, SqlFieldName = ReferenceJS ];

Storage Default
{
<Data name="CT.DOC.Interface.AccessProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductCode</Value>
</Value>
<Value name="3">
<Value>ProductDesc</Value>
</Value>
<Value name="4">
<Value>ProductStDate</Value>
</Value>
<Value name="5">
<Value>ProductEndDate</Value>
</Value>
<Value name="6">
<Value>ReferenceJS</Value>
</Value>
</Data>
<DataLocation>^CT.DOC.Interface.AccessProductD</DataLocation>
<DefaultData>CT.DOC.Interface.AccessProductDefaultData</DefaultData>
<IdLocation>^CT.DOC.Interface.AccessProductD</IdLocation>
<IndexLocation>^CT.DOC.Interface.AccessProductI</IndexLocation>
<StreamLocation>^CT.DOC.Interface.AccessProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
