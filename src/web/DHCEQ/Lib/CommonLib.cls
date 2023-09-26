Class web.DHCEQ.Lib.CommonLib Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

Parameter pExtLibPath = "/";

Parameter pCommonLibPath = "/scripts/dhceq/";

ClassMethod Version330()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"scripts_lib/ext3.3.0/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"scripts_lib/ext3.3.0/resources/css/ext-extend.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"scripts_lib/ext3.3.0/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"scripts_lib/ext3.3.0/ext-all-debug.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"scripts_lib/ext3.3.0/src/locale/ext-lang-zh_CN.js""></script>"
	//s myCode($i(myCode))= " "_"<script Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.3.0/resources/images/default/s.gif';></script>" 
	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

ClassMethod LoadCommonJsM()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pCommonLibPath_"extcontrol/MessageBox.css"" />"
		
	//<!-- 第三方插件CSS end  -->
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pCommonLibPath_"extcontrol/MessageBox.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pCommonLibPath_"function/string.js""></script>"

	

	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

/// Display shandard header lines.
/// This will automatically include the standard javascript and style sheets.
/// From websys.Configuration   怎样知道 是一次请求  主要是 记住 应用的上个操作
ClassMethod Head(page As %String = {%request.PageName})
{
	;原版本方法
	;d ##class(websys.Configuration).Head(page)
	
	;还有一个工作流的JS函数没有写
	
	;n (page, %session, %request, %response, TRELOADNEW,t, TRELOADID,msg)
	n mylangid, myIdx, mySessionID, myUnqIdx, myRequestPageName, myCode, event
	n myExtJSName, mydesc, myArrayIdx
	
	s mylangid=$g(%session.Data("LOGON.LANGID"))
	i mylangid=""{
		s:'mylangid mylangid=$lg($g(^websys.ConfigurationD(1)),15) 
		s:'mylangid mylangid=$o(^SS("LAN",0))
	}
	s myIdx=0

	s mySessionID=%session.SessionId
	s myUnqIdx=$g(TRELOADNEW)
	//TRELOADNEW
	if myUnqIdx'="" {
		s myRequestPageName=$G(^TMP("reload",mySessionID,myUnqIdx,"RequestPageName"))
	}else{
		;s myUnqIdx=$i(^websys.Unique)
		d ##Class(websys.Conversions).CommonReload()
		s myUnqIdx=$g(TRELOADNEW)
		s myRequestPageName=page
	}
	
	
	s myCode($i(myCode))=" "

	s myCode($i(myCode))=" "_$$$cspStrictBrokerInsertJS
	s myCode($i(myCode))=" "_$$$cspStrictBrokerInsertHttpJS
	;s myCode($i(myCode))=" "_"<SCRIPT SRC=""../scripts/websys.js""></SCRIPT>"
	;;s myCode($i(myCode))= " "_"<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../scripts/websys.css""></LINK>"
	;;s myCode($i(myCode))= " "_"<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../CSS/ext/websys.css""></LINK>"
	
	
	;新增 reload 函数
	s myCode($i(myCode))= " "
	s myCode($i(myCode))= " "_$$$cspStrictJavaScriptStart
	s myCode($i(myCode))= " "_"var TRELOADPAGE='"_myRequestPageName_"';"
	s myCode($i(myCode))= " "_"var TRELOADID='"_myUnqIdx_"';"
	
	s myCode($i(myCode))= " "_"function treload(csppage) {"
	s myCode($i(myCode))= " "_" setTimeout(treloadtimeout,100);"
	s myCode($i(myCode))= " "_"}"
	s myCode($i(myCode))= " "_"function treloadtimeout(csppage) {"
	s myCode($i(myCode))= " "_"  window.location.href= """_myRequestPageName_"?TRELOADID="_myUnqIdx_"&TRELOAD=1"";"
	s myCode($i(myCode))= " "_"}"
	s myCode($i(myCode))= " "_"var TRELOADPATLIST='';"

	s myCode($i(myCode))= " "_$$$cspJavaScriptEnd
	
	s myCode($i(myCode))= " "
	s myCode($i(myCode))= " "_$$$cspStrictJavaScriptStart
	;;; 注意需要在Message中获取变量
	s myCode($i(myCode))="var t=new Array();"
	i (+$d(%session.Data("LOGON.LANGID"))){
		d ##Class(websys.Component).GetComponentMessages(.t,"websys.SYSTEM")
		s myArrayIdx=$o(t(""))
		while (myArrayIdx'=""){
			s mydesc=##class(%CSP.Page).EscapeHTML( $g(t(myArrayIdx)))
			;s mydesc=##class(%CSP.Page).QuoteJS($g(t(myArrayIdx)))
			i (myArrayIdx'=""){
				s myCode($i(myCode))="t['"_myArrayIdx_"']='"_mydesc_"';"
			}
			s myArrayIdx=$o(t(myArrayIdx))
		}
	}
	
	s myCode($i(myCode))="var session=new Array();"
	s myCode($i(myCode))="session['LOGON.TIMEOUT']='"_$g(%session.Data("LOGON.TIMEOUT"))_"';"
	s myCode($i(myCode))="session['LOGON.SITECODE']='"_$g(%session.Data("LOGON.SITECODE"))_"';"
	s myCode($i(myCode))="session['LOGON.REGION']='"_$g(%session.Data("LOGON.REGION"))_"';"
	s myCode($i(myCode))="session['LOGON.USERID']='"_$g(%session.Data("LOGON.USERID"))_"';"
	s myCode($i(myCode))="session['LOGON.USERCODE']='"_$g(%session.Data("LOGON.USERCODE"))_"';"
	s myCode($i(myCode))="session['LOGON.USERNAME']='"_$g(%session.Data("LOGON.USERNAME"))_"';"
	s myCode($i(myCode))="session['LOGON.GROUPID']='"_$g(%session.Data("LOGON.GROUPID"))_"';"
	s myCode($i(myCode))="session['LOGON.GROUPDESC']='"_$g(%session.Data("LOGON.GROUPDESC"))_"';"
	s myCode($i(myCode))="session['LOGON.LANGID']='"_$g(%session.Data("LOGON.LANGID"))_"';"
	s myCode($i(myCode))="session['LOGON.CTLOCID']='"_$g(%session.Data("LOGON.CTLOCID"))_"';"
	s myCode($i(myCode))="session['XMONTHSSHORT']='"_$g(%session.Data("XMONTHSSHORT"))_"';"
	s myCode($i(myCode))="session['CONTEXT']='"_$g(%request.Data("CONTEXT",1))_"';"			;;;%session.Data("CONTEXT",1)
	s myCode($i(myCode))="session['LOGON.WARDID']='"_$g(%session.Data("LOGON.WARDID"))_"';"
	s myCode($i(myCode))="session['LOGON.HOSPID']='"_$g(%session.Data("LOGON.HOSPID"))_"';"
	s myCode($i(myCode))="session['ContainerName']='"_$g(%session.Data("ContainerName"))_"';"
	s StatusTipLOCDesc = $g(%session.Data("LOGON.CTLOCDESC"))
	if $l(StatusTipLOCDesc,"-") =2 s StatusTipLOCDesc = $p(StatusTipLOCDesc,"-",2) 
	s myStatusTip = "用户名称:  "_ $g(%session.Data("LOGON.USERNAME"))_"  组:  "_$g(%session.Data("LOGON.GROUPDESC"))
	s myStatusTip = myStatusTip_"  科室: "_StatusTipLOCDesc_" "_$g(%session.Data("LOGON.HOSPDESC"))
	
	s myCode($i(myCode))="window.status='"_myStatusTip_"';"
	s event=##class(websys.Page).Encrypt($lb("websys.Configuration.CSPServerConnect"))
	
	s myCode($i(myCode))="function tkMakeServerCall(tkclass,tkmethod) {"
	s myCode($i(myCode))="	if ((tkclass=='')||(tkmethod=='')) return '';"
	s myCode($i(myCode))="	var args=new Array('"_event_"',tkclass,tkmethod);"
	s myCode($i(myCode))="	for (var i=2; i<tkMakeServerCall.arguments.length; i++) {"
	s myCode($i(myCode))="	args[i+1]=tkMakeServerCall.arguments[i];"
	s myCode($i(myCode))="	}"
	s myCode($i(myCode))="	var retval=cspHttpServerMethod.apply(this,args);"
	s myCode($i(myCode))="	return retval;"
	s myCode($i(myCode))="}"
	
	
	s myCode($i(myCode))= " "_$$$cspJavaScriptEnd
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

Storage Default
{
<Data name="CommonLibDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.Lib.CommonLibD</DataLocation>
<DefaultData>CommonLibDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.Lib.CommonLibD</IdLocation>
<IndexLocation>^web.DHCEQ.Lib.CommonLibI</IndexLocation>
<StreamLocation>^web.DHCEQ.Lib.CommonLibS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
