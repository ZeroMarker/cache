Class DHCCSYS.HealthMonitor Extends %CSP.REST
{

/// <!-- Copyright (c) 东华医为科技有限公司 系统部 ALL RIGHTS RESERVED. -->
/// Descript:	HIS系统健康检查的页面
/// Creater:    HouYongfeng
/// CreateDate: 2022-02-24
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/healthmonitor.cls" Method="GET" Call="getLicenseUsage"/>
</Routes>
}

/// w ##class(DHCCSYS.HealthMonitor).getLicenseUsage()
ClassMethod getLicenseUsage() As %Status
{
    Set LUAvailableCount=$SYSTEM.License.LUAvailable()	//可用License数
	Set LUConsumedCount=$SYSTEM.License.LUConsumed() 	//已用License数
	Set LUTotalCount=LUAvailableCount+LUConsumedCount 	//总License数
	Set LUConsumedPercent0=$Number(LUConsumedCount/LUTotalCount*100,0)	//已用License百分比
	Set LUConsumedPercent=LUConsumedCount/LUTotalCount
	if LUConsumedPercent>=0.9  
		{
		if LUConsumedPercent=1
			{
			Set %response.Status="500 Internal Server Error"   //修改http的response status前页面不能有输出；实现license满之后的httpcode返回500
			w !,"License usage has reached 100%,LicAvailableStatus is NotOK ." ,!
			}
		else
			{
			w !,"License usage exceeds 90%,LicAvailableStatus is NotOK ." ,!
			}
		}
	else
		{
		w !,"License usage below 90%,LicAvailableStatus is Good .",!
		}

	w "<br>"
   	w "Date Time: "_$zdt($h,3),!
	w "<br>"
    w "License Used: "_LUConsumedCount,!
	w "<br>"
   
	w "License Total: "_LUTotalCount,!
	w "<br>"
	w LUConsumedPercent,!
    s LUConsumedPercent100=..DealPoint(LUConsumedPercent)*100
    w LUConsumedPercent100,!
	w "License Used Percent: "_LUConsumedPercent100_"%",!
	w "<br>"
	w "备注：负载均衡设备可通过判断httpcode或页面内容来进行健康检查",!
	w "<br>"
		
	quit $$$OK
}

ClassMethod DealPoint(Number)
{
	i '$l(Number) q ""
	s Number=$g(Number)
	i $e(Number,1,1)="." d  s Number="0"_Number
	i $e(Number,2,1)="." s Number=$e(Number,1,1)_"0"_$e(Number,2)
	i $f(Number,".")>0,$l(Number) s Number=$e(Number,0,$f(Number,".")+3)
	q Number
}

}
