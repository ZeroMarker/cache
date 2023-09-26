/// BDPInterface.Service
/// 供第三方/新数据库调用，给本数据库同步数据。
Class BDPInterface.Service Extends %SOAP.WebService [ ProcedureBlock ]
{

/// tools->add-Ins->AOSP  
/// http://localhost/imedical/web/BDPInterface.Service.cls?WSDL
/// WebService 的名称.  引用时：BDPInterfaceService.BDPInterfaceServiceSoap
Parameter SERVICENAME = "BDPInterfaceService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.1.	收费项同步接口		
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncTarItem(XMLStr)
Method syncTarItem(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveTarItem(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.2.	医嘱项同步接口		
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncArcItem(XMLStr)
Method syncArcItem(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItem(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.3.	医嘱项与收费项关联同步接口		
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncArcOrderLinktar(XMLStr)
Method syncArcOrderLinktar(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcOrderLinktar(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.4.	收费项价格同步接口		
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncTarItemPrice(XMLStr)
Method syncTarItemPrice(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveTarItemPrice(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.5.	医嘱项外部代码同步接口		
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncArcItemExternalCode(XMLStr)
Method syncArcItemExternalCode(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemExternalCode(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.6.	医嘱项医院同步接口		
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncArcItemHosp(XMLStr)
Method syncArcItemHosp(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemHosp(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：3.1.7.	医嘱项+收费项+医嘱项与收费项关联同步接口	
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().syncArcItemAndTarItem(XMLStr)
Method syncArcItemAndTarItem(XMLStr As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemAndTarItem(InputStream)
		
	}
	q rtn
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：安徽省立同步数据调用接口			
/// Input:xml	
/// Return：xml		
/// Others：w ##class(BDPInterface.Service).%New().SaveRecord("","ArcItem")
Method SaveRecord(XMLStr As %String, tablename As %String) As %String [ WebMethod ]
{
	s InputStream=##class(%Stream.GlobalCharacter).%New()
	d InputStream.Write(XMLStr)
	s rtn="",returncode="",returndesc=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	if $$$ISERR(tSC)
	{
		s rtn="<Response><return_code>-1</return_code><return_desc>xml格式错误</return_desc><Body><Results></Results></Body></Response>"	
	}
	else
	{
		if (tablename="TarItem")  //收费项目
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveTarItem(InputStream)
		}
		elseif (tablename="ArcItem")  //医嘱项
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItem(InputStream)
		}
		elseif (tablename="TarItemPrice") ///收费项目价格表
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveTarItemPrice(InputStream)
		}
		elseif (tablename="ArcOrderLinktar")  ///收费项目和医嘱项目对照
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcOrderLinktar(InputStream)		
		}
		elseif (tablename="ArcItemExternalCode")  ///医嘱项外部代码
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemExternalCode(InputStream)
		}
		elseif (tablename="ArcItemHosp")  ///医嘱项医院
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).syncArcItemHosp(InputStream)
		}
		elseif (tablename="ArcItemAndTarItem")  ///医嘱项+收费项+医嘱项与收费项关联
		{
			s rtn=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemAndTarItem(InputStream)
		}
		else
		{
			s rtn="<Response><return_code>-1</return_code><return_desc>未订阅此字典</return_desc><Body><Results>未订阅此字典</Results></Body></Response>"
		}
	}
	q rtn
}

}
