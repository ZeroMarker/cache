Class web.DHCBL.CI.Service Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod KillTMP() As %String
{
	k ^TMPBLCIService($j)
}

ClassMethod Service(CDefine As web.DHCEntity.CIDefine.ConditionDefine) As %String
{
	;1 根据条件获取 OEORIStr
	;2 把OEORIStr 传递给 外部接口
	;3 把OEORIStr 传递给内部接口
	
	s myrtn=0
	i ('$IsObject(CDefine)){
		q -607
	}
	
	d ..KillTMP()
	
	;1.获取OEORIStr字符串
	;这个是内部业务，只有在此写
	s myOEORIStr=""
	;计费前服务
	i (CDefine.ServiceName="OPCBeforeCharge"){
		s myPaadminfo=CDefine.AdmListInfo
		s myInstype=CDefine.Instype
		s myUnBillOrdStr=CDefine.UnBillOrdStr
		s myGroupDR=CDefine.GroupDR
		s myUserid=CDefine.UserDR
		s myOEORIStr=##class(web.udhcOPBillIF).ReadUFAdmOrder(myPaadminfo,myInstype,myUnBillOrdStr,myGroupDR,myUserid)
		
	}elseif (CDefine.ServiceName="OPCharge"){
		;结算后服务
		s myPRTRowIDStr =CDefine.PRTRowIDStr
		s mySFlag =CDefine.SFlag
		s myOEORIStr=##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByINVPRTStr(myPRTRowIDStr,mySFlag)
	}elseif (CDefine.ServiceName="OPCRefund"){
		;退费服务
		;结算后服务
		s myPRTRowIDStr =CDefine.PRTRowIDStr
		s mySFlag =CDefine.SFlag
		s myOEORIStr=##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByINVPRTStr(myPRTRowIDStr, mySFlag)
	}
	
	;外部接口
	s myrtn=##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService(CDefine.ServiceName, myOEORIStr)
	s myOutInterInfo=myrtn
	
	;内部接口
	;门诊收费和退费需要调用的
	i ((CDefine.ServiceName="OPCharge")||(CDefine.ServiceName="OPCRefund")){
		s myrtn=##class(web.DHCBL.CI.InFunctionBuilder).OPChargeServiceByPRTStr(CDefine.PRTRowIDStr,CDefine.SFlag)
	}
	
	d ..KillTMP()
	
	q myOutInterInfo
}

ClassMethod ServiceTest()
{
	;w ##class(web.DHCBL.CI.Service).ServiceTest()
	s myobj=##class(web.DHCEntity.CIDefine.ConditionDefine).%New()
	s myobj.AdmListInfo=""
	s myobj.GroupDR=""
	s myobj.Instype=""
	s myobj.OEORIStr=""
	s myobj.PRTRowIDStr="0^460537^"
	
	s myobj.SFlag=0
	s myobj.ServiceName="OPCharge"			;收费服务
	s myobj.UnBillOrdStr=""
	s myobj.UserDR=""
	
	s myInf=..Service(myobj)
	b	;;zhaocz
	d myobj.%Close()
	
	q 0
}

}
