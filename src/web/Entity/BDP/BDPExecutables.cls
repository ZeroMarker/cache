/// Function: 功能大表实体类
/// Creaor: sunfengchao
Class web.Entity.BDP.BDPExecutables Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPExecutables";

Property ID As %String;

/// 功能代码(一般维护Extjs文件名称) 唯一
Property Code As %String;

/// 功能(中文名称)名称
Property Caption As %String;

/// 本功能的描述
Property Description As %String;

/// JS文件及路径
Property JavaScriptFile As %String;

/// 激活标识
Property ActiveFlag As %String;

/// 基础数据授权JS路径
Property BDAJavaScriptFile As %String;

/// 包名   用于基础数据授权  2014-8-14   PackageName ClassName PropertyName
Property PackageName As %String;

/// 类名   用于基础数据授权   2014-8-14  
Property ClassName As %String;

/// 字段名   用于基础数据授权树菜单显示的字段   2014-8-14  
Property PropertyName As %String;

Storage Default
{
<Data name="BDPExecutablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDETRowid</Value>
</Value>
<Value name="3">
<Value>BDETCode</Value>
</Value>
<Value name="4">
<Value>BDETName</Value>
</Value>
<Value name="5">
<Value>BDETJavaScriptFile</Value>
</Value>
<Value name="6">
<Value>BDETMenuDR</Value>
</Value>
<Value name="7">
<Value>BDETRowId</Value>
</Value>
</Data>
<DataLocation>^web.Entity.BDP.BDPExecutablesD</DataLocation>
<DefaultData>BDPExecutablesDefaultData</DefaultData>
<IdLocation>^web.Entity.BDP.BDPExecutablesD</IdLocation>
<IndexLocation>^web.Entity.BDP.BDPExecutablesI</IndexLocation>
<StreamLocation>^web.Entity.BDP.BDPExecutablesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
