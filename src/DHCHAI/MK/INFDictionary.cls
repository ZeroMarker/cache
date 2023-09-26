/// 导出民科中间类--基础字典
Class DHCHAI.MK.INFDictionary Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Desc As %String(TRUNCATE = 1);

/// w ##Class(DHCHAI.MK.INFDictionary).GetDicObj("")
ClassMethod GetDicObj(aInput As %String) As DHCHAI.MK.INFDictionary
{
	New (aInput)
	Set obj=##Class(DHCHAI.MK.INFDictionary).%New()
	If $IsObject(obj) {
		Set obj.Code=$p(aInput,"^",1)
		Set obj.Desc=$p(aInput,"^",2)
	}
	If obj'="" Do obj.%Close()
	Quit obj
}

Storage Default
{
<Data name="DictionaryState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Desc</Value>
</Value>
</Data>
<State>DictionaryState</State>
<StreamLocation>^DHCHAI.MK.INFDictionaryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
