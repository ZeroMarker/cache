Class User.DHCMRCOffShootStatItem Extends %SerialObject
{

Property CPWDicId As %Integer [ Required ];

Property ItemDesc As %String [ Required ];

//$Lb(TypeCode)

Property StepTypeList As %String;

//$Lb(cpwDicId)

Property SyndromeDicList As %String;

Storage Default
{
<Data name="DHCMRCOffShootStatItemState">
<Value name="1">
<Value>CPWDicId</Value>
</Value>
<Value name="2">
<Value>ItemDesc</Value>
</Value>
<Value name="3">
<Value>StepTypeList</Value>
</Value>
<Value name="4">
<Value>SyndromeDicList</Value>
</Value>
</Data>
<State>DHCMRCOffShootStatItemState</State>
<StreamLocation>^User.DHCMRCOffShootStatItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
