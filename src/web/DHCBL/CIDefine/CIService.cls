Import SQLUser

Class web.DHCBL.CIDefine.CIService Extends (%RegisteredObject, %XML.Adaptor, web.DHCBL.BLAbstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// /
/// /为门诊收费发票提供的服务调用
ClassMethod GetOPCIReqService(CISRowID As %String, PRTRowID As %String, ByRef OutReq As web.DHCEntity.CI.Request) As %String
{
	;1.查找服务列表
	;2. 执行每个服务类型，返回一个字符串
	;s myobj=##class(web.DHCBL.CIDefine.CIService).GetOPCIReqService(1,156)
	s myrtn=0
	
	q:(CISRowID="") myrtn_"^"
	s myrtn=0
	
	s myServObj=##class(User.DHCCIService).%OpenId(CISRowID)
	
	;s myReqObj=##class(web.DHCEntity.CI.Request).%New()
	s myReqObj=OutReq
	
	q:(myServObj.CISActiveFlag'="Y") -602_"^"
	s myReqObj.Service=myServObj.CISCode
	
	s myCount=myServObj.STypeList.Count()
	for myIdx=1:1:myCount  d
	.s myTDObj=myServObj.STypeList.GetAt(myIdx)
	.s myCTDRowID=myTDObj.STPLTypeDefineDR.%Id()
	.q:(myTDObj.STPLDateTo'="")&&(myTDObj.STPLDateTo<+$h)
	.s myPAObj=##class(web.DHCEntity.CI.PaPatMas).%New()
	.s myrtn=##class(web.DHCBL.CIDefine.TypeDefine).GetPatMasByPRTRowID(myCTDRowID,PRTRowID, .myPAObj)
	.q:(+myrtn'=0)
	.d myReqObj.Patients.Insert(myPAObj)
	
	q myrtn
}

/// / 对于传入医嘱串生成的方法 
/// / 这个是比较统一的办法
ClassMethod GetOPCIReqByOEORIService(CISRowID As %String, OEORIStr As %String, ByRef OutReq As web.DHCEntity.CI.Request) As %String
{
	;
	s myrtn=0
	
	q:(CISRowID="") myrtn_"^"
	s myrtn=0
	
	s myServObj=##class(User.DHCCIService).%OpenId(CISRowID)
	
	;s myReqObj=##class(web.DHCEntity.CI.Request).%New()
	s myReqObj=OutReq
	
	q:(myServObj.CISActiveFlag'="Y") -602_"^"
	s myReqObj.Service=myServObj.CISCode
	
	s myCount=myServObj.STypeList.Count()
	for myIdx=1:1:myCount  d
	.s myTDObj=myServObj.STypeList.GetAt(myIdx)
	.s myCTDRowID=myTDObj.STPLTypeDefineDR.%Id()
	.q:(myTDObj.STPLDateTo'="")&&(myTDObj.STPLDateTo<+$h)
	.s myPAObj=##class(web.DHCEntity.CI.PaPatMas).%New()
	.s myrtn=##class(web.DHCBL.CIDefine.TypeDefine).GetPatMasByOEORDStr(myCTDRowID,OEORIStr, .myPAObj)
	.q:(+myrtn'=0)
	.d myReqObj.Patients.Insert(myPAObj)
	
	q myrtn
}

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	i DTObj.CIRowID="" {
		s myPObj=##class(User.DHCCIService).%New()
	}else{
		s myPObj=##class(User.DHCCIService).%OpenId(DTObj.CIRowID)
	}
	
	s myPObj.CISCode=DTObj.CISCode
	s myPObj.CISDesc=DTObj.CISDesc
	s myPObj.CISActiveFlag=DTObj.CISActiveFlag
	
	q myPObj
}

/// 使用PMI RowID获取 PATMAS对象的方法
ClassMethod GetPATMasReqByPMI(CISRowID As %String, PAPMIRowID As %String, ByRef OutReq As web.DHCEntity.CI.Request) As %String
{
	s myrtn=0
	
	q:(CISRowID="") myrtn_"^"
	s myrtn=0
	
	s myServObj=##class(User.DHCCIService).%OpenId(CISRowID)
	
	s myReqObj=OutReq
	
	q:(myServObj.CISActiveFlag'="Y") -602_"^"
	s myReqObj.Service=myServObj.CISCode
	
	s myCount=myServObj.STypeList.Count()
	for myIdx=1:1:myCount  d
	.s myTDObj=myServObj.STypeList.GetAt(myIdx)
	.s myCTDRowID=myTDObj.STPLTypeDefineDR.%Id()
	.q:(myTDObj.STPLDateTo'="")&&(myTDObj.STPLDateTo<+$h)
	.s myPAObj=##class(web.DHCEntity.CI.PaPatMas).%New()
	.s myrtn=##class(web.DHCBL.CIDefine.TypeDefine).GetPatMasByPMIRowID(myCTDRowID,PAPMIRowID, .myPAObj)
	.q:(+myrtn'=0)
	.d myReqObj.Patients.Insert(myPAObj)
	
	q myrtn
}

ClassMethod SaveDataToServer(XmlData As %String) As %String
{
	;w ##class(web.DHCBL.CIDefine.CIService).SaveDataToServer(^TMPXmlData)
	s ^TMPXmlData=XmlData
	s myrtn=0
	s myobj=##class(web.DHCEntity.CIDefine.CIService).%New()
	
	d myobj.XMLDeserialize(.myobj, XmlData)
	
	s myPObj=..DTOTransObj(myobj)
	
	s sc=myPObj.%Save()
	If $System.Status.IsError(sc) {
		s myErr=sc
		s myrtn=-102
	}
	
	d myobj.%Close()
	
	q myrtn
}

Query SelectAll() As %SQLQuery(CONTAINID = 4)
{
SELECT CIS_Code,CIS_Desc,CIS_ActiveFlag,%ID FROM DHC_CIService
 ORDER BY CIS_Code
}

}
