/// 名称: DHCMed.DPCustom.Data.Operation
/// 描述: 与手术相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-05-09
Class DHCMed.DPCustom.Data.Operation Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// 手术编码(CM3)
Property OperCode As %String(TRUNCATE = 1);

/// 手术名称
Property OperDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术类型（急诊、择期、损伤）
Property OperType As %String(TRUNCATE = 1);

/// 手术开始日期
Property SttDate As %String(TRUNCATE = 1);

/// 手术开始时间
Property SttTime As %String(TRUNCATE = 1);

/// 手术结束日期
Property EndDate As %String(TRUNCATE = 1);

/// 手术结束时间
Property EndTime As %String(TRUNCATE = 1);

/// 手术科室代码
Property DeptCode As %String(TRUNCATE = 1);

/// 手术科室名称
Property DeptDesc As %String(TRUNCATE = 1);

/// 手术医生代码
Property DocCode As %String(TRUNCATE = 1);

/// 手术医生名称
Property DocName As %String(TRUNCATE = 1);

/// 切口等级（Ⅰ、Ⅱ、Ⅲ、Ⅳ、无）
Property CutGrade As %String(TRUNCATE = 1);

/// 愈合情况(甲、乙、丙、无)
Property CutHealing As %String(TRUNCATE = 1);

/// 麻醉方法
Property Anesthesia As %String(TRUNCATE = 1);

/// ASA（麻醉）评分 （P1、P2、P3、P4、P5、P6）
Property ASAScore As %String(TRUNCATE = 1);

/// 手术日期
Property ActDate As %String(TRUNCATE = 1);

/// 手术开始时间
Property ActTime As %String(TRUNCATE = 1);

/// 术者代码
Property ActUser As %String(TRUNCATE = 1);

/// 术者姓名
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.Operation).GetDataByAdm("21977096","2016-04-29","2016-04-29")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	/*
	//数据池修改
	Set OperID=""
	For {
		Set OperID=$o(^DHCMed.DC.ORIS.OperationI("IndexEpisode"," "_aEpisodeID,OperID))
		Quit:OperID=""
		
		Set obj=..GetOperById(OperID)
		Continue:'$IsObject(obj)
		Set ActDate=obj.ActDate
		Continue:ActDate=""
		Set tmpDate=ActDate
		Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
		Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
		Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
		Continue:(aDateTo'="")&&(tmpDate>aDateTo)
		//Do $system.OBJ.Dump(obj)
		Do return.Insert(obj)
	}
	*/
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-Operation","")
	Set DataType=+DataType
	
	If DataType=1 {
		//DataType=1 友谊手术接口取值
		;^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," 13956941",240)	
		Set xAnaestID=0
		For {
			Set xAnaestID=$O(^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," "_aEpisodeID,xAnaestID))
			Quit:xAnaestID=""
			
			Set obj=..GetObjById1(xAnaestID)
			Continue:'$IsObject(obj)
			
			Set ActDate=obj.ActDate
			Continue:ActDate=""
			Set tmpDate=ActDate
			Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
			Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
			Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
			Continue:(aDateTo'="")&&(tmpDate>aDateTo)
			
	    	//Do $system.OBJ.Dump(obj)
			Do return.Insert(obj)
		}
	} ElseIf DataType=2 {
		//DataType=2 取安贞手术申请信息
 		Set SChid=""
        For {
			Set SChid=$o(^opeschi(0,"ADM",aEpisodeID,SChid))
			Quit:(SChid="")||(SChid="room")
			Set SChStatus=$p($g(^opesch(SChid)),"^",28)
			Continue:SChStatus'="完成"
			
			Set RecordID=SChid
			Set obj=..GetObjById2(RecordID)
			Continue:'$IsObject(obj)
			
			Set ActDate=obj.ActDate
			Continue:ActDate=""
			Set tmpDate=ActDate
			Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
			Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
			Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
			Continue:(aDateTo'="")&&(tmpDate>aDateTo)
			
	    	//Do $system.OBJ.Dump(obj)
			Do return.Insert(obj)
		}
	} Else {
		//DataType=0 东华手麻系统取值
		//手术排班表DHC_AN_OPArrange    ^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
		//麻醉表OR_Anaesthesia          ^OR({PA_Adm.EpisodeID_RowID},"ANA",{ANA_Childsub})  
		//手术表OR_Anaest_Operation     ^OR({PA_Adm.EpisodeID_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
		//手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
		//参考：web.DHCANAdaptor.GetANOperation
		Set OperStatusList=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OperStatusList","")
		Set:OperStatusList="" OperStatusList="F"
		
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
    		
    		Set OPChild=0
    		For {
	    		Set OPChild=$o(^OR(EpisodeID,"ANA",AnaChild,"OP",OPChild))
	    		Quit:OPChild=""
	    		
	    		Set ORAnaestID=EpisodeID_"||"_AnaChild_"||"_OPChild
				Set obj=..GetObjById0(ORAnaestID)
				Continue:'$IsObject(obj)
				
				Set ActDate=obj.ActDate
				Continue:ActDate=""
				Set tmpDate=ActDate
				Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
				Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
				Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
				Continue:(aDateTo'="")&&(tmpDate>aDateTo)
				
		    	//Do $system.OBJ.Dump(obj)
				Do return.Insert(obj)
	    	}
    	}
	}
	
	Quit return
}

ClassMethod GetOperById(aOperID As %String) As DHCMed.DPCustom.Data.Operation
{
	New (aOperID)
	Set return=""
	Quit:aOperID="" return
	
	Set objOper = ##class(DHCMed.DC.ORIS.Operation).GetObjById(aOperID)
	Quit:'$IsObject(objOper) return
	
	Set OperType = objOper.OperTypeDR
	Set:$isobject(OperType) OperTypeDesc=OperType.CName
	
	Set OperLoc = objOper.OperLocDR
	Set:$isobject(OperLoc) OperLocCode=OperLoc.Code
	Set:$isobject(OperLoc) OperLocDesc=OperLoc.CName
	
	Set Incision = objOper.IncisionDR
	Set:$isobject(Incision) IncisionDesc=Incision.CName
	
	Set Healing = objOper.HealingDR
	Set:$isobject(Healing) HealingDesc=Healing.CName
	
	Set ASAScore = objOper.ASAScoreDR
	Set:$isobject(ASAScore) ASAScoreDesc=ASAScore.CName
	
	Set OperDate = objOper.OperDate
	Set OperEndDate = objOper.OperEndDate
	Set OperSttTime = objOper.OperSttTime
	Set OperEndTime = objOper.OperEndTime
	Set:OperDate'="" OperDate=$zd(OperDate,3)
	Set:OperEndDate'="" OperEndDate=$zd(OperEndDate,3)
	Set:OperSttTime'="" OperSttTime=$zt(OperSttTime)
	Set:OperEndTime'="" OperEndTime=$zt(OperEndTime)
	
	Set obj=##Class(DHCMed.DPCustom.Data.Operation).%New()
	If obj'="" Do obj.%Close()
	Set obj.RecordID       = aOperID
	Set obj.OperCode       = objOper.OperICD9
	Set obj.OperDesc       = objOper.OperDesc
	Set obj.OperType       = $g(OperTypeDesc)
	Set obj.SttDate        = $g(OperDate)
	Set obj.SttTime        = $g(OperSttTime)
	Set obj.EndDate        = $g(OperEndDate)
	Set obj.EndTime        = $g(OperEndTime)
	Set obj.DeptCode       = $g(OperLocCode)
	Set obj.DeptDesc       = $g(OperLocDesc)
	Set obj.DocCode        = ""
	Set obj.DocName        = objOper.Operator
	Set obj.CutGrade       = $g(IncisionDesc)
	Set obj.CutHealing     = $g(HealingDesc)
	Set obj.Anesthesia     = objOper.Anesthesia
	Set obj.ASAScore       = $g(ASAScoreDesc)
	Set obj.ActDate        = $g(OperDate)
	Set obj.ActTime        = $g(OperSttTime)
	Set obj.ActUser        = ""
	Set obj.ActUserDesc    = ""
	Set return=obj
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.Operation).GetDataByID("309655||")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.Operation
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-Operation","")
	Set DataType=+DataType
	
	If DataType=1 {
		//DataType=1 友谊手麻接口
		Set obj=..GetObjById1(aRecordID)
		//Do $system.OBJ.Dump(obj)
	} ElseIf DataType=2 {
		//DataType=2 安贞手术接口
		Set obj=..GetObjById2(aRecordID)
		//Do $system.OBJ.Dump(obj)
	} Else {
		//DataType=0 默认东华手麻系统
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

ClassMethod GetObjById2(aId As %String) As DHCMed.DPCustom.Data.Operation
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set SChid=aId
	Set OperationDesc=$p($g(^opesch(SChid)),"^",21)
	Quit:OperationDesc="" return
	Set OperationDesc=$tr(OperationDesc,$c(13),"")
	Set OperationDesc=$tr(OperationDesc,$c(10),"")
	Set OperationDesc=$tr(OperationDesc,$c(9),"")
	Quit:OperationDesc="" return
	
	Set OperStartDate=+$p($g(^opesch(SChid)),"^",35)
	Quit:OperStartDate<1 return
	Set OperStartTime=+$p($g(^opesch(SChid)),"^",43)
	Set OperEndTime=+$p($g(^opesch(SChid)),"^",44)
	Set OperEndDate=""
	Set:OperEndTime>=OperStartTime OperEndDate=OperStartDate   ;结束时间大于开始时间 手术当天结束
	Set:OperEndTime<OperStartTime OperEndDate=OperStartDate+1 ;结束时间小于开始时间 手术持续到第二天
	Set:OperStartDate'="" OperStartDate=$zd(OperStartDate,3)
	Set:OperStartTime'="" OperStartTime=$zt(OperStartTime,1)
	Set:OperEndDate'="" OperEndDate=$zd(OperEndDate,3)
	Set:OperEndTime'="" OperEndTime=$zt(OperEndTime,1)
	Set OperDocID=""
	Set OperDocDesc=$p($g(^opesch(SChid)),"^",12)
	
	//手术类型：-急诊 -择期
	Set OperationType=$p($g(^opesch(SChid)),"^",9)
	Set:OperationType["急诊" OperationType="急诊"
	Set:OperationType'["急诊" OperationType="择期"
	
	//麻醉方式
	Set Anesthesia=$p($g(^opesch(SChid)),"^",34)
	Set:Anesthesia="" Anesthesia="无"
	
	//切口类型
	Set CuteType=$p($g(^opesch(SChid)),"^",50)
	Set:CuteType="" CuteType="无"
	
	//记录ID、记录日期、记录时间、记录人
	Set RecordID = aId
	Set ActDate=OperStartDate           //手术结束日期
	Set ActTime=OperStartTime           //手术结束时间
	Set ActUser=OperDocID               //术者
	Set ActUserDesc=OperDocDesc         //术者
	
	Set obj=##Class(DHCMed.DPCustom.Data.Operation).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = RecordID
	Set obj.OperCode       = ""
	Set obj.OperDesc       = OperationDesc
	Set obj.OperType       = OperationType
	Set obj.SttDate        = OperStartDate
	Set obj.SttTime        = OperStartTime
	Set obj.EndDate        = OperEndDate
	Set obj.EndTime        = OperEndTime
	Set obj.DeptCode       = ""
	Set obj.DeptDesc       = ""
	Set obj.DocCode        = OperDocID
	Set obj.DocName        = OperDocDesc
	Set obj.CutGrade       = CuteType
	Set obj.CutHealing     = ""
	Set obj.Anesthesia     = Anesthesia
	Set obj.ASAScore       = ""
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

ClassMethod GetObjById1(aId As %String) As DHCMed.DPCustom.Data.Operation
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set objOpera=##Class(DHCMed.NINF.Srv.OperationInfo).GetObjectByID(aId)
	Quit:'$IsObject(objOpera) return
	
	Set OperationDesc=objOpera.OperationName
	Set OperDocID=objOpera.OperatorCode
	Set OperDocDesc=objOpera.OperatorName
	Set OperationType=objOpera.OperationType
	Set:OperationType="E" OperationType="急诊"
	Set:OperationType="B" OperationType="择期"
	Set:OperationType="I" OperationType="损伤"
	If (OperationType'="急诊")&&(OperationType'="择期")&&(OperationType'="损伤") {
		Set OperationType="择期"
	}
	
	Set DeptCode=objOpera.OperatingDeptCode
	Set DeptDesc=objOpera.OperatingDeptDesc
	
	Set Anesthesia=objOpera.NarcosisModeDesc
	Set:Anesthesia="" Anesthesia="无"
	
	Set CutType=objOpera.CutGradeDesc
	Set:CutType="" CutType="无"
	Set HealState=objOpera.HealState
	Set:HealState="" HealState="无"
	
	Set StartDate=objOpera.StartDate
	Set:StartDate'="" StartDate=$zd(StartDate,3)
	Set StartTime=objOpera.StartTime
	Set:StartTime'="" StartTime=$zt(StartTime,1)
	
	Set EndDate=objOpera.EndDate
	Set:EndDate'="" EndDate=$zd(EndDate,3)
	Set EndTime=objOpera.EndTime
	Set:EndTime'="" EndTime=$zt(EndTime,1)
	
	Set ASAScore=objOpera.NarcosisFraction
	Set:ASAScore["Ⅰ" ASAScore="P1"
	Set:ASAScore["Ⅱ" ASAScore="P2"
	Set:ASAScore["Ⅲ" ASAScore="P3"
	Set:ASAScore["Ⅳ" ASAScore="P4"
	Set:ASAScore["Ⅴ" ASAScore="P5"
	Set:ASAScore["Ⅵ" ASAScore="P6"
	
	//记录ID、记录日期、记录时间、记录人
	Set RecordID = aId
	Set ActDate=StartDate               //手术结束日期
	Set ActTime=StartTime               //手术结束时间
	Set ActUser=""                      //术者
	Set ActUserDesc=OperDocDesc         //术者
	
	Set obj=##Class(DHCMed.DPCustom.Data.Operation).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = RecordID
	Set obj.OperCode       = ""
	Set obj.OperDesc       = OperationDesc
	Set obj.OperType       = OperationType
	Set obj.SttDate        = StartDate
	Set obj.SttTime        = StartTime
	Set obj.EndDate        = EndDate
	Set obj.EndTime        = EndTime
	Set obj.DeptCode       = DeptCode
	Set obj.DeptDesc       = DeptDesc
	Set obj.DocCode        = OperDocID
	Set obj.DocName        = OperDocDesc
	Set obj.CutGrade       = CutType
	Set obj.CutHealing     = HealState
	Set obj.Anesthesia     = Anesthesia
	Set obj.ASAScore       = ASAScore
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.Operation
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
	
	//手术开始日期、结束日期
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
	Set:OperationType="E" OperationType="急诊"
	Set:OperationType="B" OperationType="择期"
	Set:OperationType="I" OperationType="损伤"
	If (OperationType'="急诊")&&(OperationType'="择期")&&(OperationType'="损伤") {
		Set OperationType="择期"
	}
	
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
	
	//记录ID、记录日期、记录时间、记录人
	Set RecordID = aId
	Set ActDate=OperSttDate                 //手术日期
	Set ActTime=OperSttTime                 //手术时间
	Set ActUser=OperDocID                   //术者（SS_User.ID）
	Set ActUserDesc=OperDocDesc             //术者
	
	Set obj=##Class(DHCMed.DPCustom.Data.Operation).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = RecordID
	Set obj.OperCode       = OperationID
	Set obj.OperDesc       = OperationDesc
	Set obj.OperType       = OperationType
	Set obj.SttDate        = OperSttDate
	Set obj.SttTime        = OperSttTime
	Set obj.EndDate        = OperEndDate
	Set obj.EndTime        = OperEndTime
	Set obj.DeptCode       = OperLocID
	Set obj.DeptDesc       = OperLocDesc
	Set obj.DocCode        = OperDocID
	Set obj.DocName        = OperDocDesc
	Set obj.CutGrade       = CutType
	Set obj.CutHealing     = ""
	Set obj.Anesthesia     = Anesthesia
	Set obj.ASAScore       = ASAScore
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

}
