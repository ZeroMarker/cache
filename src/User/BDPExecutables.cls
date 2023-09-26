/// 功能为主表
/// 基础数据码表功能维护==等同于组件(使用Ext后，容器发挥作用，以后多个组件合成一个功能)
/// FunctionDefine
/// 名称: User.BDPMenu
/// 描述: 基础数据平台代码维护功能定义表, 主要用来制作菜单等;
/// 		子表功能定义：
/// 				1. 界面元素授权定义
/// 				2. 
/// 编写者：zhaocz
/// 编写日期: 2013-03-26
Class User.BDPExecutables Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = BDP_Executables ]
{

/// 功能代码(一般维护Extjs文件名称) 唯一
Property Code As %String(MAXLEN = "") [ Required, SqlFieldName = Code ];

/// 功能(中文名称)名称
Property Caption As %String(MAXLEN = "") [ SqlFieldName = Caption ];

Property JavaScriptFile As %String(MAXLEN = 500) [ SqlFieldName = JavaScriptFile ];

/// 基础数据授权JS路径  Basic Date Authorization   by-caihz  2014-7-16
Property BDAJavaScriptFile As %String(MAXLEN = 500) [ SqlFieldName = BDAJavaScriptFile ];

/// 指向菜单RowID
/// Property MenuDR As %String [ SqlFieldName = Menu_DR ];
Relationship ChildExtExecItem As User.BDPExtExecItem [ Cardinality = children, Inverse = ParRef ];

/// 本功能的描述
Property Description As %String(MAXLEN = "") [ SqlFieldName = Description ];

Property ActiveFlag As %Boolean [ SqlFieldName = ActiveFlag ];

/// 包名   用于基础数据授权  2014-8-14 by-caihz
Property PackageName As %String [ SqlFieldName = PackageName ];

/// 类名   用于基础数据授权   2014-8-14 by-caihz
Property ClassName As %String [ SqlFieldName = ClassName ];

/// 字段名   用于基础数据授权树菜单显示的字段   2014-8-14 by-caihz
Property PropertyName As %String [ SqlFieldName = PropertyName ];

Index CodeIndex On Code [ Unique ];

Storage Default
{
<Data name="BDPExecutablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActiveFlag</Value>
</Value>
<Value name="3">
<Value>Caption</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>JavaScriptFile</Value>
</Value>
<Value name="7">
<Value>BDAJavaScriptFile</Value>
</Value>
<Value name="8">
<Value>PackageName</Value>
</Value>
<Value name="9">
<Value>ClassName</Value>
</Value>
<Value name="10">
<Value>PropertyName</Value>
</Value>
</Data>
<DataLocation>^User.BDPExecutablesD</DataLocation>
<DefaultData>BDPExecutablesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPExecutablesD</IdLocation>
<IndexLocation>^User.BDPExecutablesI</IndexLocation>
<StreamLocation>^User.BDPExecutablesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
