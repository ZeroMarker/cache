Include websys

/// ext框架lib
Class ext.websys.ExtLib Extends %RegisteredObject
{

Parameter pExtLibPath = "/scripts_lib/";

ClassMethod Version331()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	Set cspUrl = ##class(ext.util.String).GetCacheURL()
	Set cspFix = $p($p(cspUrl,"/csp/",2),"?")
	Set cspFixLevel = $l(cspFix,"/")
	Set pre = ".."
	for i=2:1:cspFixLevel{
		Set pre = pre_"/.."
	}
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_..#pExtLibPath_"ext3.3.1/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_"/skin/default/css/websys.ext.3.3.1.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#pExtLibPath_"ext3.3.1/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#pExtLibPath_"ext3.3.1/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#pExtLibPath_"ext3.3.1/src/locale/"_language_"""></script>"
	s myCode($i(myCode))= " "_"<script>var BLANK_IMAGE_URL='"_pre_..#pExtLibPath_"ext3.3.1/resources/images/default/s.gif';</script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod Version330()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	;Ext Version 3.3.0
	;d ##class(ext.websys.ExtLib).Version330()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext3.3.0/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext3.3.0/resources/css/ext-extend.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../skin/default/css/websys.ext.3.3.0.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.3.0/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.3.0/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.3.0/src/locale/"_language_"""></script>"
	s myCode($i(myCode))= " "_"<script>Ext.BLANK_IMAGE_URL='.."_..#pExtLibPath_"ext3.3.0/resources/images/default/s.gif';</script>"
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod Version321()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	;Ext Version 3.2.1
	;wanghc 2016-07-29 先只改321包 如果csp不在csp目录下,如:csp/a/b/c.csp
	;%request.URL					-取得是csr所在csp的路径/dthealth/web/csp/test/csrpathtest.csp, 就算是后台跳转也是该路径
	;%request.CgiEnvs("CACHE_URL")	http://localhost:80/dthealth/web/csp/test/csrpathtest.csp  ,跳转时http://localhost:80/dthealth/web/csp/redirctest.csp 
	Set cspUrl = ##class(ext.util.String).GetCacheURL()
	Set cspFix = $p($p(cspUrl,"/csp/",2),"?")
	Set cspFixLevel = $l(cspFix,"/")
	Set pre = ".."
	for i=2:1:cspFixLevel{
		Set pre = pre_"/.."
	}
	;d ##class(ext.websys.ExtLib).Version321()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_..#pExtLibPath_"ext3.2.1/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_"/skin/default/css/websys.ext.3.2.1.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#pExtLibPath_"ext3.2.1/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#pExtLibPath_"ext3.2.1/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#pExtLibPath_"ext3.2.1/src/locale/"_language_"""></script>"
	s myCode($i(myCode))= " "_"<script>Ext.BLANK_IMAGE_URL='"_pre_..#pExtLibPath_"ext3.2.1/resources/images/default/s.gif';</script>"
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod Version311()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext3.1.1/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../skin/default/css/websys.ext.3.1.1.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.1.1/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.1.1/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.1.1/src/locale/"_language_"""></script>"
	
	s myCode($i(myCode))= " "_"<script>Ext.BLANK_IMAGE_URL='.."_..#pExtLibPath_"ext3.1.1/resources/images/default/s.gif';</script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod Version310()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	;Ext Version 3.1.0
	;d ##class(ext.websys.ExtLib).Version310()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext3.1.0/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../skin/default/css/websys.ext.3.1.0.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.1.0/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.1.0/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.1.0/src/locale/"_language_"""></script>"
	
	s myCode($i(myCode))= " "_"<script>Ext.BLANK_IMAGE_URL='.."_..#pExtLibPath_"ext3.1.0/resources/images/default/s.gif';</script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod Version210()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	;Ext Version 2.1.0
	;d ##class(ext.websys.ExtLib).Version210()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext2.1.0/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../skin/default/css/websys.ext.2.1.0.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext2.1.0/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext2.1.0/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext2.1.0/source/locale/"_language_"""></script>"
	
	s myCode($i(myCode))= " "_"<script>Ext.BLANK_IMAGE_URL='.."_..#pExtLibPath_"ext2.1.0/resources/images/default/s.gif';</script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod Version200()
{
	set language=##class(ext.websys.Translation).ExtLanuageFile()
	;Ext Version 2.0.0
	;d ##class(ext.websys.ExtLib).Version200()
	
	s myCode($i(myCode))= " "_"<script language='javascript' src="".."_..#pExtLibPath_"ext2.0.0/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script language='javascript' src="".."_..#pExtLibPath_"ext2.0.0/ext-core-debug.js""></script>"
	s myCode($i(myCode))= " "_"<script language='javascript' src="".."_..#pExtLibPath_"ext2.0.0/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script language='javascript' src="".."_..#pExtLibPath_"ext2.0.0/"_language_"""></script>"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext2.0.0/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../skin/default/css/websys.ext.2.0.0.css"" />"
	s myCode($i(myCode))= " "_"<script>Ext.BLANK_IMAGE_URL='.."_..#pExtLibPath_"ext2.0.0/resources/images/default/s.gif';</script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	d ..WriteDateFormat()
	d ##class(ext.websys.Translation).WriteTranslations()
}

ClassMethod WriteDateFormat()
{
	w !," "_"<script type='text/javascript'>"
	;w !,"Ext.BLANK_IMAGE_URL='"_pre_..#pExtLibPath_"ext3.2.1/resources/images/default/s.gif';"
	Set format = $$$DateFormat //##class(websys.Conversions).DateFormat()
	
	If (format=3){ 
		Set format="Y-m-d"
	} elseif(format=4){
		Set format = "j/n/Y"
	}
	w !," "_"websys_DateFormat='"_format_"';"
	w !," "_"if(Ext.util.Format){"
	w !," "_"   Ext.util.Format.date = function(v, format){"
	w !," "_"      if(!v) return """";"
	w !," "_"      if(!(v instanceof Date)) v = new Date(Date.parse(v));"
	w !," "_"      return v.dateFormat(format || websys_DateFormat);"
	w !," "_"   };"
	w !," "_"}"
	w !," "_"if(Ext.DatePicker){"
	w !," "_"   Ext.apply(Ext.DatePicker.prototype, {"
	w !," "_"      format:websys_DateFormat"
	w !," "_"   });"
	w !," "_"}"
	w !," "_"if(Ext.form.DateField) {"
	w !," "_"	Ext.apply(Ext.form.DateField.prototype,{format: websys_DateFormat});"
	w !," "_"}"
	w !," "_"</script>"
}

}
