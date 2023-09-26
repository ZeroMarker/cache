/// 名称: DHCMed.NINF.Srv.Dictionary
/// 描述: 基础字典 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-07
Class DHCMed.NINF.Srv.Dictionary Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Desc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj("")
ClassMethod GetDicObj(aInput As %String) As DHCMed.NINF.Srv.Dictionary
{
	New (aInput)
	Set obj=##Class(DHCMed.NINF.Srv.Dictionary).%New()
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
<StreamLocation>^DHCMed.NINF.Srv.DictionaryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
