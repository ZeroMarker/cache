Class dt.ext.websys.Configuration Extends %Persistent
{

ClassMethod Head(page As %String = {%request.PageName})
{
	w "<link rel=""stylesheet"" type=""text/css"" href=""../ext/extjs/resources/css/ext-all.css""/>",!
	;w "<link rel=""stylesheet"" type=""text/css"" href=""../ext/extjs/examples/desktop/css/desktop.css""/>",!
	w "<script type=""text/javascript"" src=""../../ext/extjs/adapter/ext/ext-base.js""></script>",!
	w "<script type=""text/javascript"" src=""../../ext/extjs/ext-all.js""></script>",!
	;w "<script type=""text/javascript"" src=""../../ext/extjs/build/locale/ext-lang-zh_CN-min.js""></script>",!
	
	;w "<script type=""text/javascript"" src=""../../ext/extjs/ext-core.js""></script>",!
	;要求能够自动加载对应的
	
	w "<script type=""text/javascript"" src=""../../ext/extjs/ext-all.js""></script>",!
	
	;w ""_page_"",!
	
	w !
}

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dt.ext.websys.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dt.ext.websys.ConfigurationD</IdLocation>
<IndexLocation>^dt.ext.websys.ConfigurationI</IndexLocation>
<StreamLocation>^dt.ext.websys.ConfigurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
