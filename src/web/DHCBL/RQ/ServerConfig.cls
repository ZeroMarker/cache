/// 报表服务器配置
Class web.DHCBL.RQ.ServerConfig Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

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

ClassMethod GetApplet() As %String
{
	;; jre 1.4 版本
	;d ##class(web.DHCBL.RQ.ServerConfig).GetApplet()
	;判断最后一位是否 有 /
	;拆分：  报表服务器地址(可能是IP或者网站)   端口   工程名称(网站名称)
	s mywebsite = ##class(web.DHCBL.RQ.WebServerConfig).GetSourceID()
	s myappRoot=..GetReportServiceUrl(mywebsite)
	if ($e(myappRoot,$l(myappRoot))'="/"){
		s myappRoot=myappRoot_"/"
	}
	
	s myappmap="runqianReport"
	s myappmap="http://127.0.0.1/dthealthcare/trak/web/addins/client/"
	s myappmap=myappRoot
	if ($e(myappmap,$l(myappmap))'="/"){
		s myappmap=myappmap_"/"
	}
	
	s myprompt="yes"
	
	w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "
	w "codebase='"_myappRoot_"j2re-1_4_1-windows-i586-i.exe#Version=1,4,1,0' "
	w "width='0' height='0' id='Dtreport1_directPrintApplet'"
	w "style='vertical-align: middle'>",!
	w "<param name='name' value='Dtreport1_directPrintApplet'>",!
	
	;w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintApplet.class'>",!
	;w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
	
	;w "<param name='code' value='com.runqian.report4.view.applet.DirectPrintApplet.class'>",!
	;w "<param name='archive' value='"_myappmap_"runqianReport4Applet.jar'>",!
	
	w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintAppletTest.class'>",!
	w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
	
	w "<param name='type' value='application/x-java-applet;version=1.4'>",!
	w "<param name='appRoot' value='"_myappRoot_"'>",!
	w "<param name='dataServlet' value='/reportServlet?action=1'>",!
	w "<param name='srcType' value='file'>",!
	w "<param name='fontFace' value='宋体'>",!
	w "<param name='fontSize' value='18pt'>",!
	w "<param name='fontColor' value='#0000FF'>",!
	w "<param name='backColor' value='#12632256'>",!
	w "<param name='label' value='直接打印'>",!
	w "<param name='needPrintPrompt' value='"_myprompt_"'>",!
	w "<param name='scriptable' value='true'>", !
	w "</object>"
}

ClassMethod GetApplet5() As %String
{
	;专门针对Jre1.5版本的Applet
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
	
	s myprompt="yes"
	
	w "<object classid='clsid:CAFEEFAC-0015-0000-0022-ABCDEFFEDCBA' "
	w "codebase='http://java.sun.com/update/1.5.0/jinstall-1_5_0_22-windows-i586.cab#Version=5,0,220,3' "
	w "width='0' height='0' id='Dtreport1_directPrintApplet'"
	w "style='vertical-align: middle'>",!
	w "<param name='name' value='Dtreport1_directPrintApplet'>",!
	
	w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintApplet.class'>",!
	w "<param name='archive' value='"_myappmap_"runqianReport4Applet.jar'>",!
	///;w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
	
	;w "<param name='code' value='com.runqian.report4.view.applet.DirectPrintApplet.class'>",!
	;w "<param name='archive' value='"_myappmap_"runqianReport4Applet.jar'>",!
	
	
	;w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintAppletTest.class'>",!
	;w "<param name='archive' value='"_myappmap_"runqianReport4Applet.jar'>",!
	
	
	w "<param name='type' value='application/x-java-applet;jpi-version=1.5.0_22'>",!
	w "<param name='appRoot' value='"_myappRoot_"'>",!
	w "<param name='dataServlet' value='/reportServlet?action=1'>",!
	w "<param name='srcType' value='file'>",!
	w "<param name='fontFace' value='宋体'>",!
	w "<param name='fontSize' value='18pt'>",!
	w "<param name='fontColor' value='#0000FF'>",!
	w "<param name='backColor' value='#12632256'>",!
	w "<param name='label' value='直接打印'>",!
	w "<param name='needPrintPrompt' value='"_myprompt_"'>",!
	w "<param name='scriptable' value='true'>", !
	w "</object>"
}

ClassMethod GetApplet4() As %String
{
	;专门针对Jre1.4版本的Applet
	;d ##class(web.DHCBL.RQ.ServerConfig).GetApplet4()
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
	;st
	;w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "
	;w "codebase='"_myappRoot_"jre-6u10-windows-i586-p.exe#Version=1,6,0,10' "

	;w "width='80' height='36' style='vertical-align: middle'>"	
	;w "</object>"
	;end 修改了自动安装jre1.6.10
	w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "
	w "codebase='"_myappRoot_"j2re-1_4_1-windows-i586-i.exe#Version=1,4,1,0' "
	w "width='0' height='0' id='Dtreport1_directPrintApplet'"
	w "style='vertical-align: middle'>",!
	
	w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintApplet.class'>",!
	w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
	w "<param name='name' value='Dtreport1_directPrintApplet'>",!
	w "<param name='type' value='application/x-java-applet;version=1.4'>",!
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
	
	;st
	w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "
	w "codebase='"_myappRoot_"jre-6u10-windows-i586-p.exe#Version=1,6,0,10' "
	w "width='80' height='36' style='vertical-align: middle'>"	
	w "</object>"
	;end 修改了自动安装jre1.6.10
	
	w "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93'"
	;w " codebase='"_myappRoot_"jre-6u10-beta-windows-i586-p.exe#Version=1,6,0,10' "
	w " width='80' height='16' id='appl'style='vertical-align: middle'>",!
	w "<param name='code' value='com.dthealth.runqian.report1.view.applet.DirectPrintApplet.class'>",!
	w "<param name='name' value='appl'>",!
	;w "<param name='type' value='application/x-java-applet;version=1.6'>",!
	w "<param name='type' value='application/x-java-applet'>",!
	w "<param name='appRoot' value='"_myappRoot_"'>",!
	w "<param name='archive' value='"_myappmap_"DtReportApplet.jar'>",!
	w "<param name='dataServlet' value='/reportServlet?action=1'>",!
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
