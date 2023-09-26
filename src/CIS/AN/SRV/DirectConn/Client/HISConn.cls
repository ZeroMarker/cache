Class CIS.AN.SRV.DirectConn.Client.HISConn Extends %RegisteredObject
{

/// Version of the direct connect client.
Parameter Version = "0.1.0";

/// Name of the Service.
Parameter SERVICENAME = "HISAPIForOPApp";

ClassMethod IsDaySurgeryLoc(deptID As %String) As %String
{
	set result="N"
	try
	{
		set result=##class(web.DHCBL.CT.ORCDaySurgeryLoc).IsDaySurgeryLoc(deptID)
	}
	catch(e)
	{
		//write "E^DTS:调用HIS判断是否为日间手术科室接口错误:"_e.DisplayString()
	}
	
	quit result
}

ClassMethod GetLinkLoc(deptID As %String) As %String
{
	set result=deptID
	try
	{
		set result=##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).GetLinkLoc(deptID)
	}
	catch(e)
	{
		//write "E^DTS:调用HIS获取日间关联科室接口错误:"_e.DisplayString()
	}
	
	quit result
}

}
