/// CTOR: QP
/// DATE: 2021-11-15
/// DESC: 医生交班本翻译类型表
Class User.DHCDocPassWorkTranslate Extends (%Persistent, User.Abstract)
{

/// 产品线
Property TProductLine As %String [ SqlColumnNumber = 2, SqlFieldName = T_ProductLine ];

/// 表名
Property TCode As %String [ SqlColumnNumber = 3, SqlFieldName = T_Code ];

/// 描述
Property TDesc As %String [ SqlColumnNumber = 4, SqlFieldName = T_Desc ];

Index TCode On TCode As Exact;

Index TProductLine On TProductLine As Exact;

Index TProductLineAndCode On (TProductLine As Exact, TCode As Exact);

Storage Default
{
<Data name="DHCDocPassWorkTranslateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TProductLine</Value>
</Value>
<Value name="3">
<Value>TCode</Value>
</Value>
<Value name="4">
<Value>TDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPassWorkTranslateD</DataLocation>
<DefaultData>DHCDocPassWorkTranslateDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkTranslateD</IdLocation>
<IndexLocation>^User.DHCDocPassWorkTranslateI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkTranslateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
