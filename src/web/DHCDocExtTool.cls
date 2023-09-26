Class web.DHCDocExtTool Extends %RegisteredObject
{

ClassMethod WriteExtjs1()
{
	w "<link rel=""stylesheet"" type=""text/css"" href=""../scripts_lib/ext3.2.1/resources/css/ext-all.css"" />",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/adapter/ext/ext-base.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/ext-all.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts/DHCOPDocAppointExt.js""></script>",!
	w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../scripts/dhcdoc.app.css""></LINK>",!
}

/// do ##class(web.DHCDocExtTool).WriteExtjs()
ClassMethod WriteExtjs()
{
	w "<link rel=""stylesheet"" type=""text/css"" href=""../scripts_lib/ext3.2.1/resources/css/ext-all.css"" />",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/adapter/ext/ext-base.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/ext-all.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts/DHCOPRegAppointExt.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/src/locale/ext-lang-zh_CN.js""></script>",!
	w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../scripts/dhcdoc.app.css""></LINK>",!
}

ClassMethod WriteExtjs2()
{
	w "<link rel=""stylesheet"" type=""text/css"" href=""../scripts_lib/ext3.2.1/resources/css/ext-all.css"" />",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/adapter/ext/ext-base.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/ext-all.js""></script>",!
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/src/locale/ext-lang-zh_CN.js""></script>",!
	w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../scripts/dhcdoc.app.css""></LINK>",!
}

}
