Class web.DHCBL.CI.ServiceBuilder Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 子接口服务
ClassMethod SubInterfaceService(ReqObj As web.DHCEntity.CI.Request, ByRef ResponseObj As web.DHCEntity.CI.Response) As %String
{
	n (ReqObj, ResponseObj)
	;;s myReqObj=##class(web.DHCEntity.CI.Request).%New()
	;s myClient=##class(web.DHCService.CI.Client.PACSServiceSoap).%New()
	s myClient=##class(web.DHCService.CI.Client.DHCCPHARMACYSoap).%New()
	s myResponseObj=ResponseObj
	
	s mylen=ReqObj.Patients.Count()
	f myIdx=1:1:mylen {
		s myReq=##class(web.DHCEntity.CI.Request.Request).%New()
		s myReq.Service=ReqObj.Service
		s myPatObj=ReqObj.Patients.GetAt(myIdx)
		
		d myReq.Patients.Insert(myPatObj)
		
		d myReq.XMLExportToString(.myXmlData)
		;s myRtnXML=myClient.TrakToSystem(myXmlData)
		s ^TMP("ECG")=myXmlData
		s myRtnXML=myClient.DocToCardiogram(myXmlData)
		
		;XML
		s myRtn=##class(web.DHCOPCommonFunLib).GetXmlElementValue(myRtnXML,"ResultCode")
		
		///返回消息处理
		///只是对消息加工转换成HIS自己的Reponse Object
		if (myRtn=0){
			i (myPatObj.InterfaceType="LIS"){
				s myResponseObj.LISXmlInfo=$g(myRtnXML)
				;获取试管数量
				i (myPatObj.Instruction="GetAmountOfTube"){
					;s myTAmount=##class(web.DHCEntity.CI.Response.TubeAmount).%New()
					;s myTAmount.Amount=##class(web.DHCOPCommonFunLib).GetXmlElementValue(myRtnXML,"Amount")
					;i (+myTAmount.Amount'=0){
					;	s myTAmount.ORIRowID=myPatObj.PAADMs.GetAt(1).OrdItems.GetAt(1).RowID
					;	s myResponseObj.TubeAmount=myTAmount
					;}
				}
			}elseif(myPatObj.InterfaceType="BC"){
				s myResponseObj.BCXmlInfo=$g(myRtnXML)
			}elseif(myPatObj.InterfaceType="PACS"){
				s myResponseObj.PACSXmlInfo=$g(myRtnXML)
			}
		}
		
		d myReq.%Close()
	}
	
	d myClient.%Close()
	s myRespXml=""
	
	q myRespXml
}

ClassMethod OPINVPRTCollectService(ServiceType As %String, PRTRowIDStr As %String) As %String
{
	;w ##class(web.DHCBL.CI.ServiceBuilder).OPINVPRTCollectService("OPCharge","0^460126")
	;门诊收费，退费等
	n (ServiceType, PRTRowIDStr)
	
	s $ZT="ERRORNoTrans^DHCSSERR"
	
	s myrtn=-601
	
	s myLISXmlInfo=""
	s myBCXmlInfo=""
	s myPACSXmlInfo=""
	
	s mylen=$l(PRTRowIDStr,"^")
	
	;判断是否传递一次
	f myIdx=2:1:mylen   d
	.s myPRTRowID=$p(PRTRowIDStr,"^",myIdx)
	.q:(myPRTRowID="")
	.q:(+myPRTRowID=0)
	.s myinfo=..OPINVPRTService(ServiceType, myPRTRowID)
	.i +($p(myinfo,"^",1))=0 d
	..s myrtn=0
	.s myLISXmlInfo=myLISXmlInfo_$p(myinfo,$c(1),2)
	.s myBCXmlInfo=myBCXmlInfo_$p(myinfo,$c(1),3)
	.s myPACSXmlInfo=myPACSXmlInfo_$p(myinfo,$c(1),4)
	
	q myrtn_$c(1)_myLISXmlInfo_$c(1)_myBCXmlInfo_$c(1)_myPACSXmlInfo
}

/// 专门针对门诊发票的服务
ClassMethod OPINVPRTService(ServiceType As %String, PRTRowID As %String) As %String
{
	;1.查找服务列表
	;2. 执行每个服务类型，返回一个字符串
	;3. 调用Ensumble的服务，返回一个串
	;4. 
	;w ##class(web.DHCBL.CI.ServiceBuilder).OPINVPRTService("OPCharge",156)
	n (ServiceType, PRTRowID)
	s $ZT="ERRORNoTrans^DHCSSERR"
	s myrtn=0
	
	;^User.DHCCIServiceD
	;^User.DHCCIServiceI
	
	s myrtn=0
	s ServiceType=$ZConvert(ServiceType, "U")
	s myCISRowID=$o(^User.DHCCIServiceI("CISCodeIndex", " "_ServiceType,0))
	s myXmlData=""
	
	q:(myCISRowID="") -600_"^"
	
	s myReqObj=##class(web.DHCEntity.CI.Request).%New()
	s myResponseObj=##class(web.DHCEntity.CI.Response).%New()
	
	s myrtn=##class(web.DHCBL.CIDefine.CIService).GetOPCIReqService(myCISRowID, PRTRowID, .myReqObj)
	
	s myCount=myReqObj.Patients.Count()
	s myResposeXml=""
	b	;Req
	i ($IsObject(myReqObj))&&(+myCount>0){
		s myrtn=0
		d myReqObj.XMLExportToString(.myXmlData)
		d ..SubInterfaceService(myReqObj, .myResponseObj)
		d myReqObj.%Close()
	}else{
		s myrtn=-601
	}
	
	;处理Ensemble返回的消息
	if (+myrtn=0){
		;
	}
	
	s myLISXmlInfo= myResponseObj.LISXmlInfo
	s myBCXmlInfo=myResponseObj.BCXmlInfo
	s myPACSXmlInfo=myResponseObj.PACSXmlInfo
	
	d myResponseObj.%Close()
	
	q myrtn_$c(1)_myLISXmlInfo_$c(1)_myBCXmlInfo_$c(1)_myPACSXmlInfo
}

/// 传入OEORI 字符串的服务
/// 作为一个纯医嘱的、统一的 服务
ClassMethod OPOEORIService(ServiceType As %String, OEORIStr As %String) As %String
{
	;w ##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService("OPCharge","4||2^")
	;1. 分布 接口调用
	;2. 调用接口服务
	;3. Respose Info 处理
	
	n (ServiceType, OEORIStr)
	s $ZT="ERRORNoTrans^DHCSSERR"
	s myrtn=0
	
	;^User.DHCCIServiceD
	;^User.DHCCIServiceI
	
	s myrtn=0
	s ServiceType=$ZConvert(ServiceType, "U")
	s myCISRowID=$o(^User.DHCCIServiceI("CISCodeIndex", " "_ServiceType,0))
	s myXmlData=""
	
	q:(myCISRowID="") -600_"^"
	
	s myReqObj=##class(web.DHCEntity.CI.Request).%New()
	s myResponseObj=##class(web.DHCEntity.CI.Response).%New()
	

	
	s myrtn=##class(web.DHCBL.CIDefine.CIService).GetOPCIReqByOEORIService(myCISRowID, OEORIStr, .myReqObj)
	
	s myCount=myReqObj.Patients.Count()
	s myResposeXml=""
	b	;Req
	i ($IsObject(myReqObj))&&(+myCount>0){
		s myrtn=0
		d myReqObj.XMLExportToString(.myXmlData)
		d ..SubInterfaceService(myReqObj, .myResponseObj)
		d myReqObj.%Close()
	}else{
		s myrtn=-601
	}
	
	;对于Response Object 处理
	;处理Ensemble返回的消息
	if (+myrtn=0){
		;
	}
	
	s myLISXmlInfo= myResponseObj.LISXmlInfo
	s myBCXmlInfo=myResponseObj.BCXmlInfo
	s myPACSXmlInfo=myResponseObj.PACSXmlInfo
	
	d myResponseObj.%Close()
	
	q myrtn_$c(1)_myLISXmlInfo_$c(1)_myBCXmlInfo_$c(1)_myPACSXmlInfo
	;q myrtn_"^"_myResposeXml
}

/// 给患者信息修改提供的服务
/// 只提供一个PMI
ClassMethod PATMASService(ServiceType As %String, PMIRowID As %String) As %String
{
	;w ##class(web.DHCBL.CI.ServiceBuilder).PATMASService("PatientChange",2)
	s $ZT="ERRORNoTrans^DHCSSERR"
	n (ServiceType, PMIRowID)
	s myrtn=0
	s myrtn=0
	
	s ServiceType=$ZConvert(ServiceType, "U")
	s myCISRowID=$o(^User.DHCCIServiceI("CISCodeIndex", " "_ServiceType,0))
	s myXmlData=""
	
	q:(myCISRowID="") -600_"^"
	
	s myReqObj=##class(web.DHCEntity.CI.Request).%New()
	s myResponseObj=##class(web.DHCEntity.CI.Response).%New()
	
	s myrtn=##class(web.DHCBL.CIDefine.CIService).GetPATMasReqByPMI(myCISRowID, PMIRowID, .myReqObj)
	
	s myCount=myReqObj.Patients.Count()
	s myResposeXml=""
	b	;Req
	i ($IsObject(myReqObj))&&(+myCount>0){
		
		s myrtn=0
		d myReqObj.XMLExportToString(.myXmlData)
		d ..SubInterfaceService(myReqObj, .myResponseObj)
		d myReqObj.%Close()
	}else{
		s myrtn=-601
	}
	
	q myrtn
}

}
