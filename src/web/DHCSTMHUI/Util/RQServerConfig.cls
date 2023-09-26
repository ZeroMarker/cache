Class web.DHCSTMHUI.Util.RQServerConfig Extends %RegisteredObject
{

/// 润乾打印的公共调用,便于修改
/// d ##class(web.DHCSTMHUI.Util.RQServerConfig).GetApplet()
ClassMethod GetApplet() As %String
{
	s HISVersion=##class(web.DHCSTMHUI.StkTypeM).sssHISVersion()
	q:(HISVersion'="")&&(HISVersion>=8.4)
	
	s UserAgent=$G(%request.CgiEnvs("HTTP_USER_AGENT"))
	;jre版本, 1.4, 1.6U10 等,可根据情况自行扩展
	;相应的jre文件要放在 Tomcat***\webapps\runqianReport\路径下
	;根据实际使用的jre情况,下方脚本中赋值
	s JreVersion=$$GetAppletJreVersion(UserAgent)	
	s Bit="32"		;2017-12-01 这个不需修改,暂时保留
	
	;1.4版本的,走润乾原始封装版本
	i JreVersion="1.4" d
	.d ##class(web.DHCBL.RQ.ServerConfig).GetApplet4()
	q:JreVersion="1.4"
	
	;其他jdk版本的,根据jre版本和系统bit版本,调用GetAppletByVersion方法
	i JreVersion="1.6U10" d
	.s JreVersionNo="1,6,0,10"
	.s JreVer="1.6"
	.i Bit="32" s JreName="jre-6u10-windows-i586-p.exe"
	.i Bit="64" s JreName="jre-6u10-windows-x64.exe"
	e  i JreVersion="1.6U25" d
	.s JreVersionNo="1,6,0,25"
	.s JreVer="1.6"
	.i Bit="32" s JreName="jre-6u25-windows-i586.exe"
	.i Bit="64" s JreName="jre-6u25-windows-x64.exe"
	
	d ..GetAppletByVersion(JreName,JreVersionNo,JreVer)

GetAppletJreVersion(UserAgent)
	s JreVersion="1.6U10"
	;IE8:		Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729)
	;IE11:		Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko
	;Chrome:	Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36
	;ie11:1.6U25, ie8:1.6U10, ie6:1.4
	i (UserAgent["Mozilla/5.0")&&(UserAgent["Trident/7.0") d
	.;IE11
	.s JreVersion="1.6U25"
	e  i UserAgent["Mozilla/4.0 (compatible; MSIE 9.0;" d
	.;IE9
	.s JreVersion="1.6U10"
	e  i UserAgent["Mozilla/4.0 (compatible; MSIE 8.0;" d
	.;IE8
	.s JreVersion="1.6U10"
	e  i UserAgent["Mozilla/4.0 (compatible; MSIE 6.0;" d
	.;IE6
	.s JreVersion="1.4"
	
	q JreVersion
}

ClassMethod GetReportServiceUrl(website As %String = "") As %String
{
    ;拆分：  报表服务器地址(可能是IP或者网站)   端口   工程名称(网站名称)
    ;w ##class(web.DHCBL.RQ.ServerConfig).GetReportServiceUrl()
    
    ;serverName + ":" + serverPort + appmap
    s myserverName="127.0.0.1"
    s myserverPort="8080"
    s myAppMap="runqianReport"
    s website=$g(website)
    
    s myUrl="http://"_myserverName_":"_myserverPort_"/"_myAppMap_"/"
    s myUrl = ##class(web.DHCBL.RQ.RepServerConfig).GetReportServiceUrl(website)
    
    q myUrl
}

ClassMethod GetApplet6() As %String
{
    ;专门针对Jre1.6. 20 以下版本的Applet
    ;d ##class(web.DHCBL.RQ.ServerConfig).GetApplet()
    ;判断最后一位是否 有 /
    ;拆分：  报表服务器地址(可能是IP或者网站)   端口   工程名称(网站名称)
    s mywebsite = ##class(web.DHCBL.RQ.WebServerConfig).GetSourceID()
    
    s myappRoot=..GetReportServiceUrl(mywebsite)
    if ($e(myappRoot,$l(myappRoot))'="/"){
        s myappRoot=myappRoot_"/"
    }
    
    s myappmap="runqianReport"
    
    s myappmap=myappRoot
    if ($e(myappmap,$l(myappmap))'="/"){
        s myappmap=myappmap_"/"
    }
    
    s myprompt="no"
    
    s jreName="jre-6u10-windows-i586-p.exe"
    s jreVersion="1,6,0,10"
    s jreVer="1.6"
    
    w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93'"
    w " codebase='"_myappRoot_jreName_"#Version="_jreVersion_"' "
    w " width='0' height='0' id='Dtreport1_directPrintApplet' style='vertical-align: middle'>",!
    w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintApplet.class'>",!
    w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
    w "<param name='name' value='Dtreport1_directPrintApplet'>",!
    w "<param name='type' value='application/x-java-applet;version="_jreVer_"'>",!
    w "<param name='appRoot' value='"_myappRoot_"'>",!
    w "<param name='dataServlet' value='reportServlet?action=1'>",!
    w "<param name='srcType' value='file'>",!
    w "<param name='fontFace' value='宋体'>",!
    w "<param name='fontSize' value='18pt'>",!
    w "<param name='fontColor' value='#0000FF'>",!
    w "<param name='backColor' value='#12632256'>",!
    w "<param name='needPrintPrompt' value='"_myprompt_"'>",!
    w "<param name='needSelectPrinter' value='no'>",!
    w "<param name='scriptable' value='true'>", !
    w "</object>"
}

/// CreatDate:	2016-08-18
/// Description:润乾打印applet调用,根据版本号等信息处理)
/// Input:		JreName, jreVersion, jreVer, bit
ClassMethod GetAppletByVersion(JreName, JreVersion, JreVer) As %String [ Private ]
{
	i JreName="" d
	.s JreName="jre-6u10-windows-x64.exe"
	.s JreVersion="1,6,0,10"
	.s JreVer="1.6"
	
	s mywebsite = ##class(web.DHCBL.RQ.WebServerConfig).GetSourceID()

	s myappRoot=..GetReportServiceUrl(mywebsite)
	if ($e(myappRoot,$l(myappRoot))'="/"){
		s myappRoot=myappRoot_"/"
	}

	s myappmap="runqianReport"

	s myappmap=myappRoot
	if ($e(myappmap,$l(myappmap))'="/"){
	s myappmap=myappmap_"/"
	}

	s myprompt="no"

	w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93'"
	w " codebase='"_myappRoot_JreName_"#Version="_JreVersion_"' "
	w " width='0' height='0' id='Dtreport1_directPrintApplet' style='vertical-align: middle'>",!
	w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintApplet.class'>",!
	w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
	w "<param name='name' value='Dtreport1_directPrintApplet'>",!
	w "<param name='type' value='application/x-java-applet;version="_JreVer_"'>",!
	w "<param name='appRoot' value='"_myappRoot_"'>",!
	w "<param name='dataServlet' value='reportServlet?action=1'>",!
	w "<param name='srcType' value='file'>",!
	w "<param name='fontFace' value='宋体'>",!
	w "<param name='fontSize' value='18pt'>",!
	w "<param name='fontColor' value='#0000FF'>",!
	w "<param name='backColor' value='#12632256'>",!
	w "<param name='needPrintPrompt' value='"_myprompt_"'>",!
	w "<param name='needSelectPrinter' value='no'>",!
	w "<param name='scriptable' value='true'>", !
	w "</object>"
}

}
