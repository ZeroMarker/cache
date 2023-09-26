/// 数据传输接口，适用于大数据的数据改造等
Class DHCCPMWeb.CPMBL.DHCBLDataGateWay Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCBLDataGateWay";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://localhost/trakcarejst/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 查询Query的纪录集，需要返回DataSet给客户端
/// AClassName : 类名称
/// AQueryName : Query名称
/// COMPDR :组件的RowID,这个值保存在DHCReports 中
/// IPType : 根据传入数据大小 自动可以赋值为 String/ Stream /File(用来测试等)
/// IPData :  根据IPType 的类型决定是值还是文件路径 例如: C:\Text.xml
ClassMethod GetDataByQueryName(AClassName As %String, AQueryName As %String, COMPName As %String, IPType As %String, IPData) As %XML.DataSet
{
	;  web.DHCOPINVQuery
	;  INVOrdDetails
	;  File
	;  
	;  D:\Test.xml
	;s myds=##class(DHCCPMWeb.CPMBL.DHCBLDataGateWay).GetDataByQueryName("web.DHCOPINVQuery","INVOrdDetails","","File","D:\Test.xml")
	;s myds=##class(DHCCPMWeb.CPMBL.DHCBLDataGateWay).GetDataByQueryName("web.DHCOPAdmFind","AdmQuery","","File","D:\Test.xml")
	// Return the results of the Person class' ByName query.
	;1.需要解析(AClassName||AQueryName)  的输入参数
	;2.需要把传入的Parameters分解为^TMPCPMPrintPara($j,"IP","EName")=""
	
	n (AClassName,AQueryName, COMPName, IPType, IPData)
		
	s result=##class(%XML.DataSet).%New()
	s result.ClassName =AClassName
	s result.QueryName =AQueryName
	
	d ##class(DHCCPMWeb.CPMBL.Parse.DHCInPara).KTMP()
	s myExpStr=""
	s myrtn=##class(DHCCPMWeb.CPMBL.Parse.DHCInPara).IPToTMPG(IPType, IPData, myExpStr)
	
	s myQIPStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaList(AClassName, AQueryName, "")
	
	s myQIPList=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetParaList(myQIPStr,",")
	
	s myCount=myQIPList.Count()
	k myPL
	
	for i=1:1:myCount  d
	.s myIPStr=myQIPList.GetAt(i)
	.s myIPType=$P(myIPStr,":",2)
	.s myIPName=$P(myIPStr,":",1)
	.s myval=$g(^TMPCPMPrintPara($j,"IP",myIPName))
	.s myPL(i)=myval
	b		;;;
	if (myCount=0){
		Do result.SetArgs()
	}elseif(myCount=1){
		Do result.SetArgs(myPL(1))
	}elseif(myCount=2){
		Do result.SetArgs(myPL(1),myPL(2))
	}elseif(myCount=3){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3))
	}elseif(myCount=4){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4))
	}elseif(myCount=5){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5))
	}elseif(myCount=6){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6))
	}elseif(myCount=7){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7))
	}elseif(myCount=8){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8))
	}elseif(myCount=9){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9))
	}elseif(myCount=10){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10))
	}elseif(myCount=11){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11))
	}elseif(myCount=12){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12))
	}elseif(myCount=13){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12),myPL(13))
	}elseif(myCount=14){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12),myPL(13),myPL(14))
	}elseif(myCount=15){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12),myPL(13),myPL(14),myPL(15))
	}elseif(myCount=16){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12),myPL(13),myPL(14),myPL(15),myPL(16))
	}elseif(myCount=17){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12),myPL(13),myPL(14),myPL(15),myPL(16),myPL(17))
	}elseif(myCount=18){
		Do result.SetArgs(myPL(1),myPL(2),myPL(3),myPL(4),myPL(5),myPL(6),myPL(7),myPL(8),myPL(9),myPL(10),myPL(11),myPL(12),myPL(13),myPL(14),myPL(15),myPL(16),myPL(17),myPL(18))
	}
	
	d ##class(DHCCPMWeb.CPMBL.Parse.DHCInPara).KTMP()
	
	QUIT result
}

/// 把数据转换一下，能够适应TrakCare的数据对照格式
ClassMethod TranList(IPLIST As %List) As %String [ Final ]
{
	;需要解决的问题：需要根据参数的类型能够自动转换
	n (IPLIST)
	
	;会根据这个点的显示类型自动转换参数，赋值给myPLIST
	;^TMPCPMPrintPara($j,"IP", "COMDT")
	
	s myCount=IPLIST.Count()
	k myPLIST
	for i=1:1:myCount  d
	.s myIPStr=IPLIST.GetAt(i)
	.s myIPType=$P(myIPStr,":",2)
	.s myIPName=$P(myIPStr,":",1)
	.s myval=$g(^TMPCPMPrintPara($j,"IP",myIPName))
	.s myPLIST(i)=myval
	
	q myPLIST
}

}
