Class DHCMA.CPW.SD.DataSrv.OperationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s a=##Class(DHCMA.CPW.SD.DataSrv.OperationSrv).GetDataByItem("482","")
ClassMethod GetDataByItem(aEpisodeID As %String, aItemID As %String = "") As DHCMA.CPW.SD.Data.Operation
{
	New (aEpisodeID,aItemID)
	Set return="",OperKey=""
	Quit:(aEpisodeID="") return
	If (aItemID'="") {
		Set QCID=$p(aItemID,"||",1)
		Set objQC=##class(DHCMA.CPW.SD.QCEntity).GetObjById(QCID)
		Set OperKey=objQC.BTOperKey
	}
	Set xRowID=""
	For {
		Set xRowID=$o(^DHCMA.CPW.SD.Data.OperationI("IdxAdm",aEpisodeID,xRowID))
		Quit:xRowID=""
		Set obj=##Class(DHCMA.CPW.SD.Data.Operation).%OpenId(xRowID)
		Continue:'$IsObject(obj)
		Set OperDesc=obj.OperDesc
		Set OperCode=obj.OperCode
		Set SttDate=obj.SttDate
		Set OperSttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set OperSttTime=$zt(obj.SttTime,1)
		Set EndDate=obj.EndDate
		Set OperEndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set OperEndTime=$zt(obj.EndTime,1)
		Set OperSttDateT=OperSttDate_" "_OperSttTime
		Set OperEndDateT=OperEndDate_" "_OperEndTime
		continue:(OperKey'="")&&(OperDesc'[OperKey)&&(OperCode'[OperKey)
		Set ActDate=obj.ActDate
		Continue:ActDate=""
		Set obj.SttDateT=OperSttDateT
		Set obj.EndDateT=OperEndDateT
		Set return=obj
	}
	If (aItemID'=""){
		Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		Quit:'$IsObject(objItem) return
		Set aItemDesc=objItem.BTDesc
		Set DicID=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(aItemDesc)
		Quit:DicID="" return
		Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
		Quit:TabelInfo="" return
		Quit:TabelInfo'["OperInfo" return
		Set Field=$p(TabelInfo,"^",2)
		set $property(return,Field)="*"_$property(return,Field)
	}
	Quit return
}

/// s a=##Class(DHCMA.CPW.SD.DataSrv.OperationSrv).GetDataByAdm("481","")
ClassMethod GetDataByAdm(aEpisodeID As %String, OperKey As %String = "") As %ListOfObjects
{
	New (aEpisodeID,OperKey)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	Set xRowID=""
	For {
		Set xRowID=$o(^DHCMA.CPW.SD.Data.OperationI("IdxAdm",aEpisodeID,xRowID))
		Quit:xRowID=""
		Set obj=##Class(DHCMA.CPW.SD.Data.Operation).%OpenId(xRowID)
		Continue:'$IsObject(obj)
		Set OperDesc=obj.OperDesc
		Set OperCode=obj.OperCode
		Set SttDate=obj.SttDate
		Set OperSttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set OperSttTime=$zt(obj.SttTime,1)
		Set EndDate=obj.EndDate
		Set OperEndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set OperEndTime=$zt(obj.EndTime,1)
		Set OperSttDateT=OperSttDate_" "_OperSttTime
		Set OperEndDateT=OperEndDate_" "_OperEndTime
		continue:(OperKey'="")&&(OperDesc'[OperKey)&&(OperCode'[OperKey)
		Set ActDate=obj.ActDate
		Continue:ActDate=""
		Set obj.SttDateT=OperSttDateT
		Set obj.EndDateT=OperEndDateT
		Do return.Insert(obj)
	}
	Quit return
}

/// w ##Class(DHCMA.CPW.SD.DataSrv.OperationSrv).GetOperDate("482","")
ClassMethod GetOperDate(aEpisodeID As %String, OperKey As %String = "") As %ListOfObjects
{
	New (aEpisodeID,OperKey)
	Set return=""
	Quit:(aEpisodeID="") return
	Set xRowID=""
	For {
		Set xRowID=$o(^DHCMA.CPW.SD.Data.OperationI("IdxAdm",aEpisodeID,xRowID))
		Quit:xRowID=""
		Set obj=##Class(DHCMA.CPW.SD.Data.Operation).%OpenId(xRowID)
		Continue:'$IsObject(obj)
		Set SttDate=obj.SttDate
		Set SttTime=obj.SttTime
		Set EndDate=obj.EndDate
		Set EndTime=obj.EndTime
		continue:(OperKey'="")&&(OperDesc'[OperKey)&&(OperCode'[OperKey)
		;开始结束时间不全的手术时间过滤，没有时间区间意义
		Continue:(SttDate="")||(EndDate="")
		Set return=SttDate_"^"_SttTime_"^"_EndDate_"^"_EndTime
		Quit //如果没有传入手术关键字 只判断首次手术即可
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.DataSrv.OperationSrv).SynOperDataByAdm(2862771)
ClassMethod SynOperDataByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	//默认东华手麻系统取值     其他数据来源可利用配置
	//手术排班表DHC_AN_OPArrange    ^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
	//麻醉表OR_Anaesthesia          ^OR({PA_Adm.EpisodeID_RowID},"ANA",{ANA_Childsub})  
	//手术表OR_Anaest_Operation     ^OR({PA_Adm.EpisodeID_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
	//手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
	//参考：web.DHCANAdaptor.GetANOperation
	Set OperStatusList="LF"	
	Set OperArr=0
	For {
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",+aEpisodeID,OperArr))
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
		Continue:OperStatus=""
		Continue:OperStatusList'[OperStatus
		Set AnaRowID=$p($g(^DHCANOPArrange(OperArr)),"^",2)
		Set EpisodeID=$p(AnaRowID,"||",1)
		Set AnaChild=$p(AnaRowID,"||",2)
		Continue:(AnaChild="")||(EpisodeID="")
		Set ORAnaestID=EpisodeID_"||"_AnaChild_"||"_1
		Set ret=..SynOperById(ORAnaestID)
		Set:ret>0 return=return+1
		/*
		Set OPChild=""
		For {
    		Set OPChild=$o(^OR(EpisodeID,"ANA",AnaChild,"OP",OPChild),-1)
    		Quit:OPChild=""
    		
    		Set ORAnaestID=EpisodeID_"||"_AnaChild_"||"_OPChild
			Set ret=..SynOperById(ORAnaestID)
			Set:ret>0 return=return+1
    	}*/
	}
	Quit return
}

ClassMethod SynOperById(aId As %String) As %String
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set EpisodeID=$p(aId,"||",1)
	Set AnaChild=$p(aId,"||",2)
	Set OPChild=$p(aId,"||",3)
	Quit:(EpisodeID="")||(AnaChild="")||(OPChild="") return
	
	Set OperArr=""
	Set xOperArr=0
	For {
		Set xOperArr=$o(^DHCANOPArrange(0,"Adm",EpisodeID,xOperArr))
		Quit:xOperArr=""
		Quit:OperArr'=""
		
    	Set AnaRowID=$p($g(^DHCANOPArrange(xOperArr)),"^",2)
    	Set tmpAnaRowID=EpisodeID_"||"_AnaChild
    	Continue:AnaRowID'=tmpAnaRowID
    	Set OperArr=xOperArr
	}
	s OperDateStr=##class(web.DHCANCom).GetANDateTime(OperArr)
	//手术开始日期、结束日期(默认优先取手麻系统时间)
	Set OperSttDate=$P(^OR(EpisodeID,"ANA",AnaChild),"^",39)
	Set aOperSttTime=$P(^OR(EpisodeID,"ANA",AnaChild),"^",40)
	Set OperEndDate=$P(^OR(EpisodeID,"ANA",AnaChild),"^",41)
	;Set OperEndTime=$P(^OR(EpisodeID,"ANA",AnaChild),"^",42)
	
	s OperSttTime=$p(OperDateStr,"^",14) ;取手麻监控单手术开始结束时间
	if (OperSttTime'="") {
		s:$zth(OperSttTime,1)<aOperSttTime OperSttDate=OperSttDate+1
	}else{
		Set OperSttTime=$zt(aOperSttTime,1)
		}
	s OperEndTime=$p(OperDateStr,"^",16)
	
	if (OperEndTime'="") {
		s:$zth(OperSttTime,1)<$zth(OperEndTime,1) OperEndDate=OperSttDate

	}else{
		s OperEndTime=$zt($p($g(^OR(EpisodeID,"ANA",AnaChild)),"^",42),1)
		}
	;麻醉开始时间##class(web.DHCANOrder).GetAnoEventSingle(aId,"AnaStart",1,"Y","","T")
	;麻醉结束时间##class(web.DHCANOrder).GetAnoEventSingle(aId,"AnaEnd",-1,"Y","","T")
	;操作开始时间##class(web.DHCANOrder).GetAnoEventSingle(aId,"OperStart",1,"Y","","T")
	;操作结束时间##class(web.DHCANOrder).GetAnoEventSingle(aId,"OperEnd",-1,"Y","","T")
	if (OperSttDate'=""){
		Set OperSttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OperSttDate)
		Set:OperSttTime'[":" OperSttTime=$zt(+OperSttTime,1)
		Set OperEndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OperEndDate)
		Set:OperEndTime'[":" OperEndTime=$zt(+OperEndTime,1)		
		}
	else{
			Set OperSttDate=$p($g(^DHCANOPArrange(OperArr)),"^",3)
			If OperSttDate'="" {
				Set OperSttDate=$zd(+OperSttDate,3)
				Set OperSttTime=$p($g(^DHCANOPArrange(OperArr)),"^",5)
				Set OperSttTime=$zt(+OperSttTime,1)
			} Else {
		    	Set OperSttDate=$p($g(^DHCANOPArrange(OperArr)),"^",14)
				If OperSttDate'="" {
					Set OperSttDate=$zd(+OperSttDate,3)
					Set OperSttTime=$p($g(^DHCANOPArrange(OperArr)),"^",15)
					Set OperSttTime=$zt(+OperSttTime,1)
				} Else {
			    	Set OperSttDate=""
			    	Set OperSttTime=""
			    }
		    }
			Set OperEndDate=$p($g(^DHCANOPArrange(OperArr)),"^",16)
			If OperEndDate'="" {
				Set OperEndDate=$zd(OperEndDate,3)
				Set OperEndTime=$p($g(^DHCANOPArrange(OperArr)),"^",17)
				Set OperEndTime=$zt(+OperEndTime,1)
			} Else {
		    	Set OperEndTime=""
		    }
			}
	Set OperSttDateT=OperSttDate_" "_OperSttTime
	Set OperEndDateT=OperEndDate_" "_OperEndTime
	//手术科室（申请科室）
	Set OperLocID=$p($g(^DHCANOPArrange(OperArr)),"^",54)
	Set OperLocDesc=$p($g(^CTLOC(+OperLocID)),"^",2)
	Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
	
	
	Set tmpOper=$g(^OR(EpisodeID,"ANA",AnaChild,"OP",OPChild))
	Quit:tmpOper="" return
	
	//手术名称（一般手麻系统手术都是存的文本）
	Set OperationID=$p(tmpOper,"^",6)
	Set OperationDesc=""
	Set OperationDesc=$p($g(^ORC("OPER",+OperationID)),"^",2)
	Set tmpOperationDesc=""
	Set RemSubID=$o(^OR(EpisodeID,"ANA",AnaChild,"OP",OPChild,"REM",""),-1)
	Set:(+RemSubID)>0 tmpOperationDesc=$g(^OR(EpisodeID,"ANA",AnaChild,"OP",OPChild,"REM",RemSubID))
	If (tmpOperationDesc'="")&&(OperationDesc="") {
		Set OperationDesc=tmpOperationDesc
	} ElseIf (tmpOperationDesc'="")&&(OperationDesc'="") {
		Set OperationDesc=OperationDesc_","_tmpOperationDesc
	} Else {}
	Quit:OperationDesc="" return
	
	//术者
	Set OperDoc=$p(tmpOper,"^",8)
	Set tmpOperDocDesc=$p($g(^CTPCP(+OperDoc)),"^",2)
	Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
	Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
	If $IsObject(objSSUser) {
		Set OperDocID=objSSUser.Rowid
		Set OperDocDesc=objSSUser.Name
	} Else {
		Set OperDocID=""
		Set OperDocDesc=tmpOperDocDesc
	}
	
	//麻醉方式
	Set Anesthesia=$p($g(^OR(EpisodeID,"ANA",AnaChild)),"^",5)
	Set:Anesthesia'="" Anesthesia=$p(^ORC("ANMET",+Anesthesia),"^",2)
	Set:$p(Anesthesia,"-",2)'="" Anesthesia=$p(Anesthesia,"-",2)
	
	//切口类型
	Set CutType=""
	Set tmpCuteTypeID=$p($g(^OR(EpisodeID,"ANA",AnaChild,"OP",OPChild)),"^",9)
	Set:tmpCuteTypeID'="" CutType=$p($g(^ORC("BLDTP",tmpCuteTypeID)),"^",2)
	Set:(CutType["清洁")&&(CutType'["污染") CutType="1"
	Set:(CutType["清洁")&&(CutType["污染") CutType="2"
	Set:(CutType'["清洁")&&(CutType["污染") CutType="3"
	Set:CutType="小" CutType="1"
	Set:CutType="中" CutType="2"
	Set:CutType="大" CutType="3"
	Set:CutType="特大" CutType="4"
	Set:CutType["Ⅰ" CutType="1"
	Set:CutType["Ⅱ" CutType="2"
	Set:CutType["Ⅲ" CutType="3"
	Set:CutType["Ⅳ" CutType="4"
	If (CutType'="1")&&(CutType'="2")&&(CutType'="3")&&(CutType'="4"){
		Set CutType="0"
	}
	Set:CutType="0" CutType="无"
	Set:CutType="1" CutType="Ⅰ"
	Set:CutType="2" CutType="Ⅱ"
	Set:CutType="3" CutType="Ⅲ"
	Set:CutType="4" CutType="Ⅳ"
	
	//急诊 择期 损伤
	Set OperationType=$p($g(^OR(EpisodeID,"ANA",AnaChild)),"^",32)
	Set OperationType="择期"
	Set:OperationType="E" OperationType="急诊"
	
	//ASA评分
	Set ASAScore=""
	Set ASAId=$p($g(^OR(EpisodeID,"ANA",AnaChild)),"^",26) ;ASA分级
	If ASAId'="" {
		Set ASAScore=$p($g(^ORC("ASA",ASAId)),"^",1)
		Set:ASAScore="1" ASAScore="P1"
		Set:ASAScore="2" ASAScore="P2"
		Set:ASAScore="3" ASAScore="P3"
		Set:ASAScore="4" ASAScore="P4"
		Set:ASAScore="5" ASAScore="P5"
		Set:ASAScore="6" ASAScore="P6"
	}
	
	;记录ID、记录日期、记录时间、记录人
	Set RecordID = aId
	Set ActDate=OperSttDate                 //手术日期
	Set ActTime=OperSttTime                 //手术时间
	Set ActUser=OperDocID                   //术者（SS_User.ID）
	Set ActUserDesc=OperDocDesc             //术者
	
	
	;失血量 输血量;济宁第一测试无值
	s LoseBlood=$p($g(^DHCANOPArrange(aId,"InOut",11)),"^",3) 
	s UseSelfBlood=$P($g(^DHCANOPArrange(aId)),"^",34) ;自体血回输 
	s GotBlood=UseSelfBlood
	;新增如下内容
	Set (Time3h,Lose1500,OperMin)=""
	Set LogicSttDate=##class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(OperSttDate)
	Set LogicSttTime=$zth(OperSttTime)
	If (OperEndDate'="") {
		Set LogicEndDate=##class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(OperEndDate)
		Set:OperEndTime'="" LogicEndTime=$zth(OperEndTime)
		Set IntervalTime=(LogicEndDate-LogicSttDate)*24*3600+(LogicEndTime-LogicSttTime)
		Set IntervalHour=IntervalTime\3600
		Set:IntervalHour>=3 Time3h=1
		Set OperMin=IntervalTime\60
	}
	Set:LoseBlood>=1500 Lose1500=1
	;有无实施手术患者静脉血栓栓塞症风险评估
	;是否进行手术后镇痛治疗
	;非计划再次手术
	;备皮方式
	Set (VTEFlg,EasePain,BadReOper,SkinType)=""
	Set xID=$o(^DHCMA.CPW.SD.Data.OperationI("IdxRecordID",RecordID,0))
	If (xID="") {
		Set obj=##Class(DHCMA.CPW.SD.Data.Operation).%New()
	}else{
		Set obj=##Class(DHCMA.CPW.SD.Data.Operation).%OpenId(xID)	
	}
	Set obj.EpisodeID      = EpisodeID
	Set obj.RecordID       = RecordID
	Set obj.OperCode       = OperationID
	Set obj.OperDesc       = OperationDesc
	Set obj.OperType       = OperationType
	Set obj.SttDate        = OperSttDate
	Set obj.SttTime        = OperSttTime
	Set obj.SttDateT	   = OperSttDateT
	Set obj.EndDate        = OperEndDate
	Set obj.EndTime        = OperEndTime
	Set obj.EndDateT       = OperEndDateT
	Set obj.DeptCode       = OperLocID
	Set obj.DeptDesc       = OperLocDesc
	Set obj.DocCode        = OperDocID
	Set obj.DocName        = OperDocDesc
	Set obj.CutType        = CutType
	Set obj.CutHealing     = ""
	Set obj.Anesthesia     = Anesthesia
	Set obj.ASAScore       = ASAScore
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	Set obj.LoseBlood	   = LoseBlood
	Set obj.GotBlood       = GotBlood
	Set obj.Time3h		   = Time3h
	Set obj.Lose1500	   = Lose1500
	Set obj.OperMin		   = OperMin
	Set obj.VTEFlg		   = VTEFlg
	Set obj.EasePain	   = EasePain
	Set obj.BadReOper	   = BadReOper
	Set obj.SkinType	   = SkinType
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

}
