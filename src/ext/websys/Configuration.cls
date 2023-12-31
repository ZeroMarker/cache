Include (%occInclude, %cspInclude)

IncludeGenerator %occInclude

Class ext.websys.Configuration Extends (%Persistent, ext.websys.Abstract) [ Inheritance = right, Owner = {_SYSTEM}, Not ProcedureBlock ]
{

Parameter MAJORVERSION;

Parameter MINORVERSION;

Parameter SQLFILTER;

Parameter BUILD = 356;

Parameter SQLCODE = "ID";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

Parameter pExtJSName = "ExtJSName";

Parameter pExtAppPath = "../scriptsext/";

/// Display shandard header lines.
/// This will automatically include the standard javascript and style sheets.
/// 2009-07-07  zhaocz 改写
/// 2010-10-26  怎样知道 是一次请求  主要是 记住 应用的上个操作
ClassMethod Head(page As %String = {%request.PageName})
{
	;原版本方法
	;d ##class(websys.Configuration).Head(page)
	
	;还有一个工作流的JS函数没有写
	
	s mylangid=$g(%session.Data("LOGON.LANGID"))
	i mylangid=""{
		
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
	
	/*
	s myUnqIdx=$i(^websys.Unique)
	s myRequestPageName=page
	s myreqdata=(%request.Next(""))
	while (myreqdata'=""){
		s ^TMP("reload",mySessionID,myUnqIdx,myreqdata,1)=$g(%request.Data(myreqdata,1))
		s myreqdata=(%request.Next(myreqdata))
	}
	s ^TMP("reload",mySessionID,myUnqIdx,"RequestPageName")=myRequestPageName
	i $d(^TMP("reload",mySessionID,myUnqIdx,"TRELOADID",1)){
		s ^TMP("reload",mySessionID,myUnqIdx,"TRELOADID",1) = +myUnqIdx-1
	}
	*/
	
	s myCode($i(myCode))=" "
	;s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../scriptsext/ext/resources/css/ext-all.css"" />"
	;s myCode($i(myCode))= " "_"<script type=""text/javascript"" src=""../scriptsext/ext/adapter/ext/ext-base.js""></script>"
	;s myCode($i(myCode))= " "_"<script type=""text/javascript"" src=""../scriptsext/ext/ext-all.js""></script>"
	;s myCode($i(myCode))= " "_"<script type=""text/javascript"" src=""../scriptsext/ext/src/locale/ext-lang-zh_CN.js""></script>"
	s myCode($i(myCode))=" "_$$$cspStrictBrokerInsertJS
	s myCode($i(myCode))=" "_$$$cspStrictBrokerInsertHttpJS
	s myCode($i(myCode))=" "_"<SCRIPT SRC=""../scripts/websys.js""></SCRIPT>"
	;;s myCode($i(myCode))=" "_"<SCRIPT SRC=""../scriptsext/ext.websys.js""></SCRIPT>"
	;;s myCode($i(myCode))= " "_"<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../scripts/websys.css""></LINK>"
	;;s myCode($i(myCode))= " "_"<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../CSS/ext/websys.css""></LINK>"
	
	s myCode($i(myCode))=" "_"<SCRIPT SRC=""../scripts/framework/ext.websys.js""></SCRIPT>"
	s myCode($i(myCode))= " "_"<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""../skin/default/css/websys.css""></LINK>"
	
	
	;指定一个ExtJSName=""
	s myExtJSName=$g(%request.Data(..#pExtJSName,1))
	i myExtJSName'=""{
		s myCode($i(myCode))= " "_"<script language='javascript' src='"_(..#pExtAppPath)_myExtJSName_"'></script>"
	}
	
	;新增 reload 函数
	;^TMP("reload","126p0u1c00",27231489,"RequestPageName")
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
	
	s myStatusTip = "用户名称:  "_ $g(%session.Data("LOGON.USERNAME"))_"  组:  "_$g(%session.Data("LOGON.GROUPDESC"))
	s myStatusTip = myStatusTip_"  科室: "_$g(%session.Data("LOGON.CTLOCDESC"))
	
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

/// 根据配置 获取本地的日期格式
ClassMethod GetLocalDate() As %String
{
	
	q +$h
}

/// 获取本地的时间格式
ClassMethod GetLocalTime() As %String
{
}

ClassMethod GetLocalDateTime() As %String
{
}

/// returns the NoofDecimalPlaces and DecimalSymbol
/// called in ARReceipts.Edit component
ClassMethod GetCurrencySettings() As %Library.String
{
}

/// Get the default language from system wide defaults
ClassMethod GetDefaultLanguage() As %Library.String
{
}

ClassMethod GetLayoutManager()
{
}

ClassMethod CSPServerConnect(tkclass, tkmethod, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %String
{
	;w ##class(websys.Configuration).CSPServerConnect("web.UDHCJFCOMMON","gethospital")
	q ##class(websys.Configuration).CSPServerConnect(tkclass, tkmethod, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
}

/// Return the version of the instance based on MAJORVERSION and SUBVERSION 
ClassMethod GetPatchVersion() As %Library.String [ CodeMode = generator ]
{
}

/// ab 4.04.07 63062 - get version dynamically (still have to change manually on default.htm
/// 获取 Trak的版本信息  例如： TrakCare 6.8.17
ClassMethod VersionString() As %String
{
	Q $p($G(^CF("SM",1)),"^",5)
	//q ##class(dt.Deploy).GetProductVersion("DtHealth")
	;q ..#pDTHealthVersion
	;q "DTHealth 6.9.2"    //2010
	;q ##class(websys.Configuration).VersionString()
}

/// 默认编码
/// 例如： Western European
ClassMethod GetDefaultEncoding() As %String
{
	q ##class(websys.Configuration).GetDefaultEncoding()
}

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ext.websys.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ext.websys.ConfigurationD</IdLocation>
<IndexLocation>^ext.websys.ConfigurationI</IndexLocation>
<StreamLocation>^ext.websys.ConfigurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
