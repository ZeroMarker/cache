Import sqluser

/// 同医为HRP(Oracle版本)间的接口实现
Class web.DHCSTMHUI.ServiceForHRP Extends (%RegisteredObject, StkTypeM) [ ProcedureBlock ]
{

/// Description:推送科室信息给HRP
/// CreateDate:	2022-05-20
/// Input:		
/// Output:  	
/// w ##class(web.DHCSTMHUI.ServiceForHRP).SendLoc()
ClassMethod SendLoc(LocIdStr = "", HospId)
{
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("HRP",HospId)
	q:UseFlag'="Y" -1
	
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.HRPJson.HRP2STMClient||SendLoc"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendLoc(LocIdStr)
	q Ret
}

/// Description:推送医嘱信息给HRP(含高值台帐,低值台帐,跟台高值 几种类型)
/// CreateDate:	2022-05-27
/// Input:		
/// Output:  	
/// w ##class(web.DHCSTMHUI.ServiceForHRP).SendOeori()
ClassMethod SendOeori(Oeore, Type, HospId)
{
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("HRP",HospId)
	q:UseFlag'="Y" -1
	
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.HRPJson.HRP2STMClient||SendOeori"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendOeori(Oeore,Type)
	q Ret
}

/// Description:HRP接口的后台任务
/// Input:		
/// Output: 	
/// w ##class(web.DHCSTMHUI.ServiceForHRP).SendTask()
ClassMethod SendTask(HospId)
{
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("HRP",HospId)
	q:UseFlag'="Y" -1
	
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.HRPJson.HRP2STMClient||SendTask"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendTask()
	q Ret
}

/*
/// 这是个后台任务???
/// w ##class(web.DHCSTMHUI.ServiceForHRP).SendHvMatToHRP()
ClassMethod SendHvMatToHRP(HospId)
{
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("HRP",HospId)
	q:UseFlag'="Y" -1
	
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.HRPJson.HRP2STMClient||SendHvMatToHRP"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendHvMatToHRP()
	q Ret
}
*/
}
