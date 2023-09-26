/// 描述：获取手术监控信息
/// 名称：DtPortal.MD.MD27OperMon
/// 作者：Yangtong
/// 日期：2017-02-22
Class DtPortal.MD.MD27OperMon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 名称: GetOpRoomStat
/// 描述: 查询当日手术间占用信息
/// 编写者：bmz
/// 编写日期:2017-02-22
/// 服务序号:MD2701.01.01
/// w ##class(DtPortal.MD.MD27OperMon).MD27010101()
ClassMethod MD27010101(hospitalId As %String = "") As DtPortal.OutPut
{
	#Dim return As DtPortal.OutPut 
	Set return = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrSendMessage"
	TStart
		
	s obj=##class(web.DHCANService).GetOpRoomStat(hospitalId)
	//w !,obj.Read()
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(obj)
	Do reader.Correlate("OperDetailsRoomStat","User.DHCANOPInterfaceForPortalRoomStat")

	set ret="["
	b ;00
	While (reader.Next(.object,.sc)) {
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("operationTableNum",object.operTotalNum)
		d jsonObj.Put("operationTableUseNum",object.operUsedNum)
		d jsonObj.Put("operationTableUnusedNum",object.operVacancyNum)
		set:ret'="[" ret=ret_","_jsonObj.Json()
		set:ret="[" ret=ret_jsonObj.Json()

	}
	set ret=ret_"]"
	
		TCommit
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = ret
		b ;end
		Quit return
		
ErrSendMessage
	
		TRollBack
		Set return.status = -1
		Set return.errMSG = $ZE
		Set return.data = ""
		b ;err
		Quit return
}

/// 名称: GetOpRoomStat
/// 描述: 查询所有手术室信息
/// 编写者：bmz
/// 编写日期:2017-02-22
/// 服务序号:MD2702.01.01
/// w ##class(DtPortal.MD.MD27OperMon).MD27020101()
ClassMethod MD27020101(hospitalId As %String = "") As DtPortal.OutPut
{
	#Dim return As DtPortal.OutPut
	Set return = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrMD27020101"
	TStart
		
	s obj=##class(web.DHCANService).GetAllOperDept(hospitalId)
	w !,obj.Read()
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(obj)
	Do reader.Correlate("AllOperatingRoom","User.DHCANOPInterfaceForPortalOperDept")
	set ret="["
	b ;1
	While (reader.Next(.object,.sc)) {
		b ;2
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		Do jsonObj.Put("operRoomId",object.operRoomId)
		Do jsonObj.Put("operRoomName",object.operRoomName)
	
		/*d jsonObj.Put("operationTableNum",object.operTotalNum)
		d jsonObj.Put("operationTableUseNum",object.operUsedNum)
		d jsonObj.Put("operationTableUnusedNum",object.operVacancyNum)
		*/
		set:ret'="[" ret=ret_","_jsonObj.Json()
		set:ret="[" ret=ret_jsonObj.Json()
	}
	set ret=ret_"]"
		TCommit
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = ret
		b ;end
		Quit return
		
ErrMD27020101
	
		TRollBack
		Set return.status = -1
		Set return.errMSG = $ZE
		Set return.data = ""
		b ;err
		Quit return
}

/// 名称: GetOpRoomStat
/// 描述: 查询当日手术间占用信息
/// 编写者：bmz
/// 编写日期:2017-02-22
/// 服务序号:MD2701.01.02
/// w ##class(DtPortal.MD.MD27OperMon).MD27020102("43")
ClassMethod MD27020102(operCurLocId As %String) As DtPortal.OutPut
{
	n (operCurLocId)
	#Dim return As DtPortal.OutPut
	Set return = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrMD27020102"
	TStart
		
	s obj=##class(web.DHCANService).GetDeptOperInfo(operCurLocId)
	w !,obj.Read()
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(obj)
	Do reader.Correlate("OperDetailsDeptOperInfo","User.DHCANOPInterfaceForPortalDeptOperInfo")

	set ret="["
	While (reader.Next(.object,.sc)) {
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("occupiedRoom",object.operUsedNum)  //已占用手术间
		d jsonObj.Put("IdleRoom",object.operVacancyNum)		//闲置手术间
		d jsonObj.Put("completedNum",object.operCompletedNum)	//已完成台次
		d jsonObj.Put("unfinishedNum",object.operUnfinishedNum)	//未完成台次
		
		set:ret'="[" ret=ret_","_jsonObj.Json()
		set:ret="[" ret=ret_jsonObj.Json()
	}
	set ret=ret_"]"
		TCommit
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = ret
		b ;end
		Quit return
		
ErrMD27020102
	
		TRollBack
		Set return.status = -1
		Set return.errMSG = $ZE
		Set return.data = ""
		b ;err
		Quit return
}

/// 名称: GetOpRoomStat
/// 描述: 通过手术执行室Id查询手术执行列表
/// 编写者：bmz
/// 编写日期:2017-02-22
/// 服务序号:MD2703.01.01
/// w ##class(DtPortal.MD.MD27OperMon).MD27030101("43")
ClassMethod MD27030101(operCurLocId As %String) As DtPortal.OutPut
{
	n (operCurLocId)
	#Dim return As DtPortal.OutPut
	Set return = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrMD27030101"
	TStart
		
	s obj=##class(web.DHCANService).GetOperDetailsByAppLocId(operCurLocId)
	w !,obj.Read()
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(obj)
	Do reader.Correlate("OperDetailsByAppLoc","User.DHCANOPInterfaceForPortalAppLoc")

	set ret="["
	While (reader.Next(.object,.sc)) {
		;b ;00
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("OpDate",object.OpDate)  
		d jsonObj.Put("operId",object.operId)  
		d jsonObj.Put("type",object.type) 
		d jsonObj.Put("name",object.name) 
		d jsonObj.Put("age",object.age) 
		d jsonObj.Put("sex",object.sex) 
		d jsonObj.Put("operTotalNum",object.operTotalNum) 
		d jsonObj.Put("operNum",object.operNum) 
		d jsonObj.Put("operRoomId",object.operRoomId) 
		d jsonObj.Put("operRoomDesc",object.operRoomDesc) 
		d jsonObj.Put("surgeonName",object.surgeonName) 
		d jsonObj.Put("operDep",object.operDep) 
		
		
		set:ret'="[" ret=ret_","_jsonObj.Json()
		set:ret="[" ret=ret_jsonObj.Json()
	}
	set ret=ret_"]"
		TCommit
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = ret
		;b ;end
		Quit return
		
ErrMD27030101
	
		TRollBack
		Set return.status = -1
		Set return.errMSG = $ZE
		Set return.data = ""
		b ;err
		Quit return
}

/// 名称: GetOperDetailsByRoomId
/// 描述: 通过手术间Id查询手术执行详情
/// 编写者：yangtong
/// 编写日期:2017-02-22
/// 服务序号:MD2704.01.01
/// w ##class(DtPortal.MD.MD27OperMon).MD27040101("6")
ClassMethod MD27040101(opRoomId As %String) As DtPortal.OutPut
{
	n (opRoomId)
	#Dim return As DtPortal.OutPut
	Set return = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrMD27040101"
	TStart
		
	s obj=##class(web.DHCANService).GetOperDetailsByRoomId(opRoomId)
	w !,obj.Read()
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(obj)
	Do reader.Correlate("OperationDetails","User.DHCANOPInterfaceForPortalOperDetails")
	
	set ret="["
	While (reader.Next(.object,.sc)) {
		;b ;00
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("OpDate",object.OpDate)  //手术日期1
		d jsonObj.Put("operId",object.operId)  //
		d jsonObj.Put("appointTime",object.appointTime) 
		d jsonObj.Put("startTime",object.startTime) 
		d jsonObj.Put("endTime",object.endTime) 
		d jsonObj.Put("operName",object.operName) ;手术名称，多个以","分割,6
		d jsonObj.Put("diagnosis",object.diagnosis) ;术前诊断7
		d jsonObj.Put("name",object.name)
		d jsonObj.Put("age",object.age)  
		d jsonObj.Put("sex",object.sex)  ;性别10
		d jsonObj.Put("bedNo",object.bedNo)  ;床位11
		d jsonObj.Put("surgeonName",object.surgeonName)   ;手术医师12
		d jsonObj.Put("firstAssistantName",object.firstAssistantName)  ;一助描述13
		d jsonObj.Put("secondAssistantName",object.secondAssistantName) ;二助描述14
		d jsonObj.Put("anesthesiaName",object.anesthesiaName) ;麻醉医师15 
		d jsonObj.Put("nurseName",object.nurseName) 
		d jsonObj.Put("operState",object.operState) ;状态代码17 
		d jsonObj.Put("operDep",object.operDep) ;申请科室18
		d jsonObj.Put("medicalNo",object.medicalNo) ;病案号19
		
	
		set:ret'="[" ret=ret_","_jsonObj.Json()
		set:ret="[" ret=ret_jsonObj.Json()
	}
	set ret=ret_"]"
		TCommit
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = ret
		b ;end
		Quit return
		
ErrMD27040101
	
		TRollBack
		Set return.status = -1
		Set return.errMSG = $ZE
		Set return.data = ""
		b ;err
		Quit return
}

/// 名称: MDOPer01
/// 描述: 今日手术完成率统计
/// 编写者：bmz
/// 编写日期:2020-11-16
/// 服务序号:MD.OPer.01
/// w ##class(DtPortal.MD.MD27OperMon).MDOPer01("")
ClassMethod MDOPer01(hospID As %String = "") As DtPortal.OutPut
{
	n (hospID)
	#Dim return As DtPortal.OutPut
	
	try{
		Set return = ##class(DtPortal.OutPut).%New()
		s StartDate=+$h,EndDate=+$h
		s DayOperAllNum=0,DayOperFinishNum=0,zeQiAllNum=0,zeQiFinishNum=0
		for date=StartDate:1:EndDate{
			set opaId=""
			for  {
				s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId))
				q:opaId=""
				s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1) 
				s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
    			s anaSub=$P(anaId,"||",2)
    			
    			s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
    			continue:operLocId=""
    			//w !,$p(^CTLOC(operLocId),"^",2)
    			s hospIDCurr=$p($g(^CTLOC(operLocId)),"^",22)  
    			i hospID'=""  continue:hospID'=hospIDCurr
				s OPAStatus=$P(^DHCANOPArrange(opaId),"^",27)
				continue:OPAStatus=""
				continue:("DC"[OPAStatus)
				s DayOperFlag=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",1)),"^",22)
				if (DayOperFlag="Y"){
					s DayOperAllNum=DayOperAllNum+1
					if (("PLF"[OPAStatus)){
						s DayOperFinishNum=DayOperFinishNum+1
					}
				}
				
				s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
				i anaSourceType="E" s anaSourceTypeDesc="急诊"
				e  s anaSourceTypeDesc="择期"
		    	if (anaSourceTypeDesc="择期"){
					s zeQiAllNum=zeQiAllNum+1
					if (("PLF"[OPAStatus)){
						s zeQiFinishNum=zeQiFinishNum+1
					}
				}
			}
		}
		
		
		set jsonObj =##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("DayOperAllNum",DayOperAllNum)
		d jsonObj.Put("DayOperFinishNum",DayOperFinishNum)
		d jsonObj.Put("zeQiAllNum",zeQiAllNum)
		d jsonObj.Put("zeQiFinishNum",zeQiFinishNum)
		s DayOperRate=0,zeQiRate=0
		if (DayOperAllNum'=0){
			s DayOperRate=$fn(DayOperFinishNum/DayOperAllNum*100,"",2)
		}
		if (zeQiAllNum'=0){
			s zeQiRate=$fn(zeQiFinishNum/zeQiAllNum*100,"",2)
		}
		d jsonObj.Put("DayOperRate",DayOperRate)
		d jsonObj.Put("zeQiRate",zeQiRate)
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = "["_jsonObj.Json()_"]"
	}catch exp{
		Set return.status = -1
		Set return.errMSG = $ze
		Set return.data = ""
		
	}
	;b ;01
	Quit return
}

}
