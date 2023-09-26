/// web.DHCBL.CT.UpdataHICApproved
Class web.DHCBL.CT.UpdataHICApproved Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "UpdataHICApproved";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// UpdataHICApproved
Method UpdataHICApproved(str) As %String [ WebMethod ]
{
	
	s len=$l(str,"!")
	s num=1
	
	for 
	{
		if (num>len)
		{
			q
		} 
		s item=$p(str,"!",num)
		if (item="") 
		{
			s result="1^入参为空" 
			q
		}
		s phyNum=$p(item,"^",1)
		s Active=$p(item,"^",3)
		s rowid=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(phyNum),0))
		if (rowid="") 
		{
			s result="1^该工号不存在" 
			q
		}
		s obj=##class(User.CTCareProv).%OpenId(rowid)
		i Active="Y"
		{
			s obj.CTPCPHICApproved = "Y"
		}
		else
		{
			s obj.CTPCPHICApproved = "N"
		}
		b
		Ts
		s sc=obj.%Save()
		If $$$ISOK(sc){
			Tc
			s result = 0 
		}
		else
		{
			Trollback
			s result = "1^id为"_phyNum_"的数据保存失败,errorinfo:"_zconvert(sc,"O","JS")    //"{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"',id:'"_phyNum_"'}"    //返回错误信息
			q
		}
		s num=num+1
	}
	q result
}

}
