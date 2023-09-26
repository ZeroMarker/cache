/// CTOR: QP
/// DATE: 2016-08-7
/// VERN: V4.1.3
/// DESC: CACHE BASE Tool
Class DHCAnt.Util.CacheServerBase Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter bootEasyUiLibPath = "../scripts/dhcdocant/";

Parameter pLibPath = "../scripts_lib/hisui-";

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: ASSIGN Query Return Common Style
/// 
/// EXEC: w ##class(DHCAnt.Util.CacheServerBase).GetQueryData()
ClassMethod GetQueryData(ClassName, QueryName, ArgCnt, startRecordNo, limitRecordCnt, paraStr, ModuleName) As %String
{
	n (ClassName,QueryName,ArgCnt,startRecordNo,limitRecordCnt,paraStr,execute,i,ModuleName,%session,%request,%response)
	S ^TEMP("QP",1111)=$lb(ClassName,QueryName,ArgCnt,paraStr,ModuleName)
	s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s ReturnType=..GetReturnType(ClassName,QueryName)
 	k PLIST
 	s execute="set %sc=$zobjmethod(rs,""Execute"""
 	f i=1:1:ArgCnt  d 
 	.s PLIST(i)=$p(paraStr,"^",i)
 	.s execute=execute_",PLIST("_i_")"
 	s execute=execute_")"
 	x execute
 	s cnt=0
 	s displayRows=0
 	s rowData=""
 	i ModuleName["combobox" w "["
 	e  i ModuleName["datagrid" w "{""rows"":["
 	e  w "["
 	s columns=rs.GetColumnCount()
 	f  q:rs.Next()=0  d
 	.i ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))!(startRecordNo="")!(limitRecordCnt="")  d
 	..w:displayRows>0 ","
 	..w "{"
 	..s rowData=""
 	..f i=1:1:columns  d
 	...s:i>1 rowData=rowData_","
 	...s fieldInfo=$p(ReturnType,",",i)
 	...s fieldType=$p(fieldInfo,":",2)
 	...s rowData=rowData_""""_rs.GetColumnName(i)_""""_" : "
 	...s tmpData=rs.GetData(i)
 	...s tmpData=..FilterValue(tmpData)					//$zconvert(tmpData,"O","JS")
 	...i (($e(tmpData,1,1)="'"))  d
 	....s rowData=rowData_""""_tmpData_""""
 	...e  d
 	....s:fieldType="" fieldType="%String"
 	....i fieldType="%String"  d 
 	.....s rowData=rowData_""""_tmpData_""""
 	....e  d
 	.....s:((tmpData="")&&(fieldType="%Integer")) rowData=rowData_""""_"0"_""""
 	.....s:((tmpData="")&&(fieldType="%Float")) rowData=rowData_""""_"0"_""""
 	.....s:tmpData'="" rowData=rowData_""""_tmpData_""""
 	..w rowData
 	..w "}",!
 	..s displayRows=displayRows+1
 	.s cnt=cnt+1
 	
 	i ModuleName["combobox" w "]"
 	e  i ModuleName["datagrid" w "],""total"" : "_cnt_"}"
 	e  w "]"
 	d rs.%Close()
 	q ""
}

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: EXECUTE ASSIGNED METHOD's Name  
/// 
/// EXEC: w ##class(DHCAnt.Util.CacheServerBase).GetQueryData()
ClassMethod GetMethodData(ClassName, MethodName, ArgCnt, paraStr, ReqType) As %String
{
	n (ClassName, MethodName, ArgCnt, paraStr,ReqType)
	;If ##Class(websys.SessionEvents).SessionExpired() Quit $$$ERROR($$$CSPSessionTimeout)
 	s ret=""
 	s execute=""
 	s i=""
 	s execute="s ret=$ZOBJCLASSMETHOD(ClassName,MethodName"
 	k PLIST
 	f i=1:1:ArgCnt  d 
 	.s PLIST(i)=$p(paraStr,"^",i)
 	.s execute=execute_",PLIST("_i_")"
 	s execute=execute_")"
 	x execute
 	i $IsObject(ret)'=0  w "-101"
 	if ReqType="text" w ret
 	if ReqType="json" d
 	.w "{""value"":"
 	.w """"_ret_""""
 	.w "}"
 	q ""
}

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: GET RETURN TYPE
/// 
/// EXEC: w ##class(DHCAnt.Util.CacheServerBase).GetReturnType(1)
ClassMethod GetReturnType(ClassName, QueryName) As %String
{
	n (ClassName, QueryName)
	Set ret=""
	Set cdef = ##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	set count = cdef.Queries.Count() 
	For i = 1:1:count {
		if (cdef.Queries.GetAt(i).Name=QueryName)
 		{		 	
 		Set ret=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
		}	 
	}
	k cdef
	Quit ret
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: INIT DHCANT LIB
/// 
/// EXEC: d ##class(DHCAnt.Util.CacheServerBase).LoadDHCAntLib()
ClassMethod LoadDHCAntLib(EUI As %String = "") As %String
{
	New (EUI,%session,DHCAntlibCode,%request,%response)
	set SHUI=0
	
	if EUI="" s SHUI=1	//##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SHUI")
	if (SHUI=1) {
		w ..LoadJS(..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/js/html5shiv.min.js"),!
		w ..LoadJS(..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/js/respond.min.js"),!
		w ..LoadCSS(..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/css/bootstrap.min.css"),!
		Set ActiveRowId = $o(^websys.SkinI("ActiveIndex","Y",""))
		Set skinCode=""
		If ActiveRowId>0{
			Set obj = ##class(websys.Skin).%OpenId(ActiveRowId,0)
			Set skinCode = obj.SCode
			Set obj=""
		}
		set hisphy = ##class(ext.util.String).GetPhysicalPath("","/scripts_lib/hisui-0.1.0/")
		if (##class(%File).Exists(hisphy_"/dist/css/hisui."_skinCode_".css")){
			w ..LoadCSS(..#pLibPath_"0.1.0/dist/css/hisui."_skinCode_".css"),!
		}else{
			w ..LoadCSS(..#pLibPath_"0.1.0/dist/css/hisui.css"),!
		}
		w ..LoadUTF8JS(..#pLibPath_"0.1.0/dist/js/jquery-1.11.3.min.js"),!
		w ..LoadJS(..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/js/bootstrap.min.js"),!	//QP
		w ..LoadUTF8JS(..#pLibPath_"0.1.0/dist/js/jquery.hisui.min.js"),!
		w ..LoadUTF8JS(..#pLibPath_"0.1.0/dist/js/locale/"_..LanuageFile()),!
		w ..LoadUTF8JS("../scripts/websys.jquery.js"),!
		;d ..WriteDateFormat()
	} else {
		s DHCAntlibCode($i(DHCAntlibCode))=" "
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<script type=""text/javascript"" src="""_..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/js/html5shiv.min.js""></script>"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<script type=""text/javascript"" src="""_..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/js/respond.min.js""></script>"
		s DHCAntlibCode($i(DHCAntlibCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/css/bootstrap.min.css"" />"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<link rel=""stylesheet"" type=""text/css"" href="""_..#bootEasyUiLibPath_"lib/jquery-easyui-1.3.5/themes/default/easyui.css"" />"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<link rel=""stylesheet"" type=""text/css"" href="""_..#bootEasyUiLibPath_"lib/jquery-easyui-1.3.5/themes/icon.css"" />"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<script type=""text/javascript"" src="""_..#bootEasyUiLibPath_"lib/jQuery/jquery-1.11.3.min.js""></script>"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<script type=""text/javascript"" src="""_..#bootEasyUiLibPath_"lib/bootstrap-3.3.4/js/bootstrap.min.js""></script>"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<script type=""text/javascript"" src="""_..#bootEasyUiLibPath_"lib/jquery-easyui-1.3.5/jquery.easyui.min.js""></script>"
		s DHCAntlibCode($i(DHCAntlibCode))=" "_"<script type=""text/javascript"" src="""_..#bootEasyUiLibPath_"lib/jquery-easyui-1.3.5/locale/easyui-lang-zh_CN.js""></script>"
		f myIdx=1:1:DHCAntlibCode {
			w DHCAntlibCode(myIdx),!
		
		}
	}
	w $$$cspStrictJavaScriptStart
	s BaseMethodEncrypt=##class(websys.Page).Encrypt($lb("websys.Configuration.CSPServerConnect"))
	w "var DHCAntClassMethodEncrypt="""_BaseMethodEncrypt_""";"
	w $$$cspJavaScriptEnd
	d ..WriteDateFormat()
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: CACHE SERVER INVOKE
/// 
/// EXEC: w ##class(DHCAnt.Util.CacheServerBase).CacheServerInvoke("DHCAnt.Base.MainConfigExcute","GetValuesJsonByParentCode","PARA")
ClassMethod CacheServerInvoke(inclass, inmethod, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %String
{
	n (inclass, inmethod, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
	q:((inclass="")!(inmethod="")) ""
	s isValidClass=..IsValidClassName(inclass)
	
	q:('isValidClass) ""
	s isValidMethod=..IsValidMethodName(inclass,inmethod)
	q:('isValidMethod) ""
	s invokeMethod=inclass_"||"_inmethod
	
	s invokeObj=##class(%Dictionary.CompiledMethod).%OpenId(invokeMethod)
	q:('$IsObject(invokeObj)) ""
	
	s paramlist=invokeObj.FormalSpec
	d invokeObj.%Close()
	Set code="s ret=##class("_inclass_")."_inmethod_"("
	s paramColLen=$l(paramlist, ",")
	s:(paramlist="") paramColLen=0
	f curIdx=1:1:paramColLen {
		s paramColStr=$p(paramlist,",",curIdx)
		s paramName=$p(paramColStr,":",1)
		If curIdx>1 Set code=code_","
		i paramName'=""{
			s checkstr="s para=$g(p"_curIdx_")"
			XECUTE checkstr
			Set para=$replace(para,$c(34),$c(34)_$c(34))
			Set code=code_""""_para_""""
		}
	}
	s code=code_")"
	XECUTE code
	
	Q ret
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: VALIDATE CLASS
/// 
/// EXEC: w ##class(DHCAnt.Util.CacheServerBase).IsValidClassName("DHCAnt.Util.CacheServerBase")
ClassMethod IsValidClassName(classname As %Library.String) As %Library.Boolean
{
	n (classname)
	s $ZT="ERROR^DHCSSERR"
	q:(classname="") 0
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(classname)
	s myrtn=0
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	Do:myobj'="" myobj.%Close()
	q myrtn
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: VALIDATE METHOD
/// 
/// EXEC: w ##class(DHCAnt.Util.CacheServerBase).IsValidMethodName("DHCAnt.Util.CacheServerBase","IsValidClassName")
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
	n (classname, methodname)
	s $ZT="ERROR^DHCSSERR"
	q:((classname="")||(methodname="")) 0
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
	s myrtn=0
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	Do:myobj'="" myobj.%Close()
	q myrtn
}

/// QP
/// DATE: 2016-08-14
ClassMethod FilterValue(value) As %String
{
	s value=$tr(value,$c(9))   ;制表符
	s value=$tr(value,$c(10))   ;替换换行符
	s value=$tr(value,$c(13))	;替换回车符
	//s value=$Replace(value,"\","\\")
	//s value=$Replace(value,"'","\'")
	s value=..ReplaceStr(value,"\","\\")
	s value=..ReplaceStr(value,"'","\'")
	s value=..ReplaceStr(value,"""","")
	q value
}

/// QP
/// DATE: 2016-08-14
ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// QP
/// DATE: 2017-06-13
/// 获取系统日期格式配置
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
/// w ##class(DHCAnt.Util.CacheServerBase).GetDateFormat()
ClassMethod GetDateFormat() As %String
{
	n
	/*
	s sptHisDate=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SPTHISDATE")
	s cfgDateFormat=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("DATEFORMAT")
	i (cfgDateFormat'=3)&&(cfgDateFormat'=1)&&(cfgDateFormat'=4) s cfgDateFormat=4
	s defaultFormat=cfgDateFormat
	i sptHisDate=1 s defaultFormat=##class(websys.Conversions).DateFormat()
	q defaultFormat
	*/
	s defaultFormat=##class(websys.Conversions).DateFormat()
	q defaultFormat
}

/// QP
/// DATE: 2017-06-13
ClassMethod WriteDateFormat()
{
	Set format = ..GetDateFormat()
	w "<script type='text/javascript'>",!
	w:format=3 "var dtseparator='-',dtformat='YMD';",!
	w:format=4 "var dtseparator='/',dtformat='DMY';",!
	w "if ($.fn.datebox){",!
	w "$.fn.datebox.defaults.formatter = function(date){",!
	w "	var y = date.getFullYear();",!
	w "	var m = date.getMonth()+1;",!
	w "	var d = date.getDate();",!
	w:format=3 "	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);",!
	w:format=4 "	return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;",!
	w:format=1 "	return (m<10?('0'+m):m)+'/'+(d<10?('0'+d):d)+'/'+y;",!
	w "};",!
	w "$.fn.datebox.defaults.parser = function(s){",!
	w "	if (!s) return new Date();",!
	if (format=3){	
		w "	var ss = s.split('-');",!
		w "	var y = parseInt(ss[0],10);",!
		w "	var m = parseInt(ss[1],10);",!
		w "	var d = parseInt(ss[2],10);",!
	}elseif(format=4){
		w "	var ss = s.split('/');",!
		w "	var y = parseInt(ss[2],10);",!
		w "	var m = parseInt(ss[1],10);",!
		w "	var d = parseInt(ss[0],10);",!
	} elseif(format=1) {
		w "	var ss = s.split('/');",!
		w "	var y = parseInt(ss[2],10);",!
		w "	var d = parseInt(ss[1],10);",!
		w "	var m = parseInt(ss[0],10);",!	
	}
	w "	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){",!
	w "		return new Date(y,m-1,d);",!
	w "	} else {",!
	w "		return new Date();",!
	w "	}",!
	w "};",!
	w "}",!
	w "</"_"script>",!
	Q ""
}

/// QP
/// DATE: 2018-04-28
ClassMethod LoadJS(src)
{
	q " "_"<script type=""text/javascript"" src="""_src_"""></script>"
}

ClassMethod LoadUTF8JS(src)
{
	q " "_"<script type=""text/javascript"" src="""_src_""" charset=""utf-8""></script>"
}

/// QP
/// DATE: 2018-04-28
ClassMethod LoadCSS(href)
{
	q " "_"<link rel=""stylesheet"" type=""text/css"" href="""_href_""" />"
}

/// CreatDate：   2014-4-14
/// Description:  输出Easyui 语言包
/// Table：       SS_Lanuage
/// Input：       LanuageJavaScriptFileName
/// ret：      	  HISUI 中，各语言对应的js文件名
/// SS_Lanuage 中定义的语言如下
/// 1	EN	English
/// 3	GR	Greek
/// 20	CH	Chinese
/// 56	TH	Thai
/// 59	SP	Spanish
/// 60	IT	Italian
/// 61	FR	French
/// 62	GR	German
/// 63	PT	Portuguese
/// 64	RU	Russian
/// 65	UA	Ukrainian
/// 66	MA	Malaisian
/// 100	AR	Arabic
ClassMethod LanuageFile(fileName As %String = "")
{
	q:fileName'="" fileName	
	set lan = 20
	if +$g(%session.Data("LOGON.LANGID")){
		set lan=+%session.Data("LOGON.LANGID")
	}
	//默认情况，读取中文
	set language = $CASE(lan,
		1:  "hisui-lang-en.js",
		3:  "hisui-lang-gr.js",
		20: "hisui-lang-zh_CN.js",
		56: "hisui-lang-th.js",
	   ;59: "",
		60: "hisui-lang-it.js",
		61: "hisui-lang-fr.js",
		62: "hisui-lang-gr.js",
		63: "hisui-lang-pt.js",
		64: "hisui-lang-ru.js",
		65: "hisui-lang-ukr.js",
	   ;66: "",
		100: "hisui-lang-ar.js",
		   : "hisui-lang-zh_CN.js")
	quit language
}

}
