/// 获取Dthealth web服务器配置
Class web.DHCBL.RQ.WebServerConfig Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取发送URL的，web 服务器标示
/// 由 csp的Request中获取
/// w ##class(web.DHCBL.RQ.WebServerConfig).GetSourceID()
ClassMethod GetSourceID() As %String
{
	s myIP=""
	
	; SERVER_NAME  CGI 标准
	; WEBSERVER_NAME 自定义的CGI，参数
	
	s myIP=(%request.GetCgiEnv("WEBSERVER_NAME"))
	if (myIP=""){
		s myIP=(%request.GetCgiEnv("SERVER_NAME"))
	}
	
	; 2010版本以上；  GatewayInstanceName
	;:(myIP="")  zhaocz  2012-08-06 修改
	s VerNumber = $$$PRODUCTVERSIONSTR
	if (+$p(VerNumber,".",1)>2009){
		s myIP=(%request.GatewayInstanceName)
	}
	k ^myIP
	s ^myIP=myIP
	k ^Temprequest
	m ^Temprequest=%request.CgiEnvs
	
	q myIP
}

/// create mzc
/// date:2020-02-20
/// 获取报表服务器地址(可能是IP或者网站)   端口   工程名称(网站名称)
/// 如 http://192.168.174.129:8080/runqianReport
/// w ##class(web.DHCBL.RQ.WebServerConfig).GetProjectURL()
ClassMethod GetProjectURL() As %String
{
	s myip=##class(ext.util.String).ServerIP()
	q:myip=""
	s myip=..GetSourceID()
	s rqappserver=""
	s rqappserver=##class(web.DHCBL.RQ.ServerConfig).GetReportServiceUrl(myip)
	
	q rqappserver
}

/// 要求被替换的内容不能=""
/// ##class(web.DHCBL.RQ.WebServerConfig).Replace(paraVal,"u","%u")
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// create mzc
/// date:2020-02-20
/// 直接打印报表参数转换
/// w ##class(web.DHCBL.RQ.WebServerConfig).GetReportName("{ABC-DF-报表名称.raq}")
/// w ##class(web.DHCBL.RQ.WebServerConfig).GetReportName("{ABC-DF-报表名称.raq(arg1=闵;arg2=z;arg3=成)}")
ClassMethod GetReportName(strName As %String) As %String
{
	//对中文判断
	
	s reportName=""
	if (strName["(")&&(strName[")"){
		s strPr=$p($p(strName,"(",2),")}",1)
		s myColLen=$l(strPr, ";")
		s:(strPr="") myColLen=""
		s strRtn=""
		f myIdx=1:1:myColLen {
			s myColStr=$p(strPr,";",myIdx)
			s myPrName=$p(myColStr,"=",1)
			s myPrValue=$p(myColStr,"=",2)
			s myPrValue=$ZCONVERT(myPrValue,"O","URL")
			i (myPrValue["%u"){
				s myPrValue = ##class(web.DHCBL.RQ.WebServerConfig).Replace(myPrValue,"%u","|u")
		
			}
			if (strRtn=""){
				s strRtn=myPrName_"="_myPrValue
			}else{
				s strRtn=strRtn_";"_myPrName_"="_myPrValue
			}
		}
		
		s strName=$p($p(strName,"{",2),"(",1)
		s reportName=$ZCONVERT(strName,"O","URL")
		i (reportName["%u"){
			s reportName = ##class(web.DHCBL.RQ.WebServerConfig).Replace(reportName,"%u","|u")
		
		}
		s reportName=reportName_"("_strRtn_")"
		
	}else{
		s strName=$p($p(strName,"{",2),"}",1)
		s reportName=$ZCONVERT(strName,"O","URL")
		i (reportName["%u"){
			s reportName = ##class(web.DHCBL.RQ.WebServerConfig).Replace(reportName,"%u","|u")
		
		}
	}
	
	s reportName="{"_reportName_"}"
	q reportName
}

/// create mzc
/// date:2020-02-29
/// 弹出报表参数转换
/// w ##class(web.DHCBL.RQ.WebServerConfig).GetReportArgName("ABC-DF-报表名称.raq")
/// w ##class(web.DHCBL.RQ.WebServerConfig).GetReportArgName("ABC-DF-报表名称.raq&arg1=闵&arg2=z&arg3=成")
ClassMethod GetReportArgName(strName As %String) As %String
{
	s myColLen=$l(strName, "&")
	s:(strName="") myColLen=""
	s strRtn=""
	f myIdx=1:1:myColLen {
		s myColStr=$p(strName,"&",myIdx)
		s myPrName=$p(myColStr,"=",1)
		s myPrValue=$p(myColStr,"=",2)
		if (myIdx=1){
			s myPrValue=myPrName
		}
		s myPrValue=$ZCONVERT(myPrValue,"O","URL")
		i (myPrValue["%u"){
			s myPrValue = ##class(web.DHCBL.RQ.WebServerConfig).Replace(myPrValue,"%u","__u")
			
		}
		if (strRtn=""){
				s strRtn=myPrValue
		}else{
				s strRtn=strRtn_"&"_myPrName_"="_myPrValue
		}
	}
	q strRtn
}

// w ##class(web.DHCBL.RQ.WebServerConfig).GetURLReportArgName("ABC-DF-报表名称.raq&arg1=闵&arg2=z&arg3=成","1")

ClassMethod GetURLReportArgName(strName As %String, strType As %String) As %String
{
	s jspName=""
	if (strType="1"){
		s jspName="dhccpmrunqianreport.jsp"
	}else{
		s jspName="dhccpmrunqianreportprint.jsp"
	}
	s UrlName=..GetProjectURL()
	b ;;
	s reportUrlType=0
	s myColLen=$l(strName, "&")
	s:(strName="") myColLen=""
	s strRtn=""
	f myIdx=1:1:myColLen {
		s myColStr=$p(strName,"&",myIdx)
		s myPrName=$p(myColStr,"=",1)
		s myPrValue=$p(myColStr,"=",2)
		if (myIdx=1){
			s myPrValue=myPrName
		}
		s myPrValue=$ZCONVERT(myPrValue,"O","URL")
		i (myPrValue["%u"){
			s myPrValue = ##class(web.DHCBL.RQ.WebServerConfig).Replace(myPrValue,"%u","__u")
			s reportUrlType=1
		}
		if (strRtn=""){
				s strRtn=myPrValue
		}else{
				s strRtn=strRtn_"&"_myPrName_"="_myPrValue
		}
	}
	s myrtn=##class(web.DHCBL.Sys.SessionShareInfo).CheckDtSessionSync()
	
	s myjspsessioninfo=""
	s mycspsinfo=""
	i (myrtn){
		;同步过的信息
		s myobj=##class(web.DHCBL.Sys.SessionShareInfo).GetShareSession(%session.SessionId)
		s myjspsessioninfo=";jsessionid="_myobj.TargetSessionId
	}
	s mycspsinfo="&cspsessionid="_%session.SessionId
	s str=UrlName_"report/jsp/"_jspName_"?report="_strRtn_"&reportUrlType="_reportUrlType_mycspsinfo
	q str
}

}
