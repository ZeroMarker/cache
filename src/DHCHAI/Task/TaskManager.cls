/// 名称: DHCHAI.Task.TaskManager
/// 描述: 任务入口
/// 编写者：liyi
/// 编写日期: 2017-07-31
Class DHCHAI.Task.TaskManager Extends (%RegisteredObject, DHCHAI.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-07-31
/// Description:  根据日期同步数据主入口
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      "OK"
/// w ##class(DHCHAI.Task.TaskManager).AutoTask("2018-04-01","2018-04-05")
ClassMethod AutoTask(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//处理作废、修改、删除记录数据不一致问题
	Set ret=..AutoTask4(aDateFrom,aDateTo)
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	//1 医院、科室、用户(初始上线时用)
	Set ret=##Class(DHCHAI.Task.DPBaseDicSrv).SyncBaseData("HIS01")
	
	//2.1 就诊信息
	Set ret = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByDate("HIS01",aDateFrom,aDateTo)
		
	K ^TMP($zn,$j,"AutoTask1","PatAdm")	
	
	//2.2 按就诊同步数据
	Set arrEpisodeID=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate(aDateFrom,aDateTo)
	Set Count=arrEpisodeID.Count()
	For indEpis=1:1:Count {
		Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
		Continue:xEpisodeID=""
		
		Continue:$d(^TMP($zn,$j,"AutoTask1","PatAdm",xEpisodeID))   //同步一段时间内的患者，不重复同步
	    Set ^TMP($zn,$j,"AutoTask1","PatAdm",xEpisodeID) = ""
	    
		Write "EpisodeID="_xEpisodeID,!
		Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeID_")"
		
		//2.2.1 转科、转病区、转床信息
		Set ret = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmTransLoc("HIS01",xEpisodeID)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncHisInfo"
			Set ErrMethod = "SyncAdmTransLoc"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		//2.2.2.1 临床诊断
		Set ret = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmDiagnos("HIS01",xEpisodeID,aDateFrom,aDateTo)
	    If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncHisInfo"
			Set ErrMethod = "SyncAdmDiagnos"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		//2.2.2.2 病程入院诊断
		Set ret = ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrAdmDiagnos("HIS01",xEpisodeID,aDateFrom,aDateTo)
   	    If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncEmrInfo"
			Set ErrMethod = "SyncEmrAdmDiagnos"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		//2.2.3 医嘱及抗菌用药
		Set ret = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmOEOrdItem("HIS01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncHisInfo"
			Set ErrMethod = "SyncAdmOEOrdItem"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
   	
		//2.2.4 护理记录
		Set ret=##class(DHCHAI.DI.DHS.SyncNisInfo).SyncNisByDateAdm("NIS01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncNisInfo"
			Set ErrMethod = "SyncNisByDateAdm"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		//2.2.5 手麻记录、手术记录（编目、首页）
		//先同步首页、编目手术
		Do ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncEMROperByDateAdm("EMR01",xEpisodeID,aDateFrom,aDateTo)   //首页手术
		Do ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncWMROperByDateAdm("MRS01",xEpisodeID,aDateFrom,aDateTo)   //编目手术
		
		Set Config=4
		Set Config=##class(DHCHAI.BT.Config).GetValByCode("OperDataSourceConfig")
		Set OperAnaesDr=""
		If ((Config=1)||(Config=4)){//数据源为手麻
	        //数据源为手麻或者同步手麻记录并合并编目、首页手术
			Set ret=##class(DHCHAI.DI.DHS.SyncOpsInfo).SyncOperByDateAdm("OPS01",xEpisodeID,aDateFrom,aDateTo)
			If (+ret)<0 {
				Set ErrClass  = "DHCHAI.DI.DHS.SyncOpsInfo"
				Set ErrMethod = "SyncOperByDateAdm"
				Set ErrArgStr = $lb(ret)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
		    }
		}
		If ((Config=2)||(Config=3)){
			
	    //数据源为编目或者病案首页
		    Set ret=##class(DHCHAI.DPS.OROperAnaesSrv).SaveOperData(xEpisodeID)
			If (+ret)<0 {
				Set ErrClass  = "DHCHAI.DPS.OROperAnaesSrv"
				Set ErrMethod = "SaveOperData"
				Set ErrArgStr = $lb(ret)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	    
		//2.2.6 检查报告
		Set ret= ##class(DHCHAI.DI.DHS.SyncPacsInfo).SyncPacsByDateAdm("RIS01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncPacsInfo"
			Set ErrMethod = "SyncPacsByDateAdm"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		//2.2.7 送检+检验结果
		Set ret =##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber("LIS01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncLabInfo"
			Set ErrMethod = "SyncLabVisitNumber"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		Set ret = ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate("LIS01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncLabInfo"
			Set ErrMethod = "SyncLabRepByDate"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
	    //处理污染标本检验结果记录
	    Set ret=##class(DHCHAI.DI.DHS.SyncLabInfo).SyncInfTypeByDate(aDateFrom,aDateTo)
	    
		//2.2.8 病程记录
		Set ret= ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrByDateAdm("EMR01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncEmrInfo"
			Set ErrMethod = "SyncEmrByDateAdm"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
		/*
		//2.2.11 会诊记录
		Set ret= ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmEmConsult("HIS01",xEpisodeID,aDateFrom,aDateTo)   
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncHisInfo"
			Set ErrMethod = "SyncAdmEmConsult"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
	    */
		//2.2.10 消毒中心
		Set ret= ##class(DHCHAI.DI.DHS.SyncCSSDInfo).SyncCSSDByDateAdm("CSSD01",xEpisodeID,aDateFrom,aDateTo)
		If (+ret)<0 {
			Set ErrClass  = "DHCHAI.DI.DHS.SyncCSSDInfo"
			Set ErrMethod = "SyncCSSDByDateAdm"
			Set ErrArgStr = $lb(ret)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    }
	    
	    //2.3 同步患者重症系统VAE数据
	    Set IsSyncVAEData=##class(DHCHAI.BT.Config).GetValByCode("IsSyncVAEData")
	    If (IsSyncVAEData=1){
			Set ret= ##class(DHCHAI.DI.DWS.SyncPatVaeData).SyncVAEByDate(xEpisodeID,aDateFrom,aDateTo)
			If (+ret)<0 {
				Set ErrClass  = "DHCHAI.DI.DWS.SyncPatVaeData"
				Set ErrMethod = "SyncVAEByDate"
				Set ErrArgStr = $lb(ret)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
	    	}
	    }
	    
	   	Set IsSyncBooking=##class(DHCHAI.BT.Config).GetValByCode("IsSyncIPBooking")
	   	If (IsSyncBooking=1) {
		    //2.4.1 同步住院证
			Set ret = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncIPBooking("HIS01",xEpisodeID)
		    If (+ret)<0 {
				Set ErrClass  = "DHCHAI.DI.DHS.SyncHisInfo"
				Set ErrMethod = "SyncIPBooking"
				Set ErrArgStr = $lb(ret)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
		    }
		    If $d(^MA.HAI.DP.PADocBookingI("IndexEpisodeIDx",xEpisodeID)) {   //存在于住院证表中 	
		    	Set xBookID=""
		    	For {
			    	Set xBookID=$o(^MA.HAI.DP.PADocBookingI("IndexEpisodeIDx",xEpisodeID,xBookID))
			    	Quit:xBookID=""
			    	
			    	Set BookData=$g(^MA.HAI.DP.PADocBookingD(xBookID))
			    	Continue:BookData=""
			    	Set EpisodeIDxF = $lg(BookData,6)    //HIS门诊就诊ID
			    	
			    	Set EpisodeID=$p(EpisodeIDxF,"||",2)
			    	Set AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
			    	
			    	 //2.4.2 同步住院证患者的门急诊检验送检信息
					Set ret =##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber("LIS01",EpisodeIDxF,AdmDate,aDateTo)
					If (+ret)<0 {
						Set ErrClass  = "DHCHAI.DI.DHS.SyncLabInfo"
						Set ErrMethod = "SyncLabVisitNumber"
						Set ErrArgStr = $lb(ret)
						Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeIDxF,ErrClass,ErrMethod,ErrArgStr)
				    }
					Set ret = ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate("LIS01",EpisodeIDxF,AdmDate,aDateTo)
					If (+ret)<0 {
						Set ErrClass  = "DHCHAI.DI.DHS.SyncLabInfo"
						Set ErrMethod = "SyncLabRepByDate"
						Set ErrArgStr = $lb(ret)
						Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeIDxF,ErrClass,ErrMethod,ErrArgStr)
				    }
			    	
		    	}
		    }
	    }
	     
	}

	//院感报告
	//Do ##class(DHCHAI.DI.DHS.SyncINFInfo).SyncInfRep(aDateFrom,aDateTo)
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	//自动生成疑似筛查记录
	Set ret=..AutoTask2(aDateFrom,aDateTo)
	//自动生成ICU日志信息
	Set ret=..AutoTask3(aDateFrom,aDateTo)
	
	//按照出院日期同步电子病历出院诊断
	Set ret=..AutoTask5(aDateFrom-5,aDateTo-2)
	
	// 按照出院日期同步前5天的出院病人检验结果信息
	Set ret=..AutoTask6(+$h-5,+$h-1)
	
	//统计图(每天生成上个月至今的数据)
	If (aDateTo>aDateFrom) { //手工执行
		Set ret=##class(DHCHAI.STAS.ResultSrv).GetEChartsResult(aDateFrom,aDateTo,"DataMonth")
	} Else { //自动任务执行
		Set DateFromStart=$e($zd(aDateFrom,3),1,7)_"-01"
		Set ret=##class(DHCHAI.STAS.ResultSrv).GetEChartsResult($zdh(DateFromStart,3)-1,aDateTo,"DataMonth")
	}
	//处理多重耐药菌感染类型
	Set ret=..AutoTask9(aDateFrom,aDateTo)
	
	//环境卫生学每月漏监测提醒
	Set ret=..AutoTask10(aDateFrom,aDateTo)
	
	// 按照出院日期同步前N天的出院病人手术信息
	Set LateDay=##class(DHCHAI.BT.Config).GetValByCode("DPEmrSyncDisLateDay")
	Set:LateDay="" LateDay=15
	Set ret=..AutoTask11(+$h-LateDay,+$h-LateDay)
	
	//2.1.1 手卫生记录同步
	Set ret = ##class(DHCHAI.DI.DHS.HandByDateSyn).SyncHandByDate("HAND01",aDateFrom,aDateTo)
	
	//根据日期同步环境卫生学和职业暴露检验信息
	Set IsAutoGetValue=##class(DHCHAI.BT.Config).GetValByCode("IsAutoGetValue")
	If (IsAutoGetValue=1) {
		Set ret = ##class(DHCHAI.IO.ToEOLabSrv).SyncYGLabReport(aDateFrom-3,aDateTo)
	}
	//根据日期同步血透患者信息
	Set IsAutoSyncBPPat=##class(DHCHAI.BT.Config).GetValByCode("IsAutoSyncBPPat")
	If (IsAutoSyncBPPat=1) {
		// 血透患者数据来源1：血透系统  2：血透室(PABPRegID血透记录ID即就诊ID)
		Set IsBPPatSource=##class(DHCHAI.BT.Config).GetValByCode("IsBPPatSource")
		If (IsBPPatSource=1){
			//根据日期同步门诊、急诊血透患者就诊、检验
			Set ret = ##class(DHCHAI.IO.FromBPSrv).SyncBPPatInfo(aDateFrom,aDateTo)
		}
		//根据日期同步血透患者透析记录、血管通路
		Set ret = ##class(DHCHAI.IO.FromBPSrv).SyncBPReg(aDateFrom,aDateTo)
	}
	
	//检验信息得自动匹配对照
	Set ret=..AutoTaskLISSync()
	
	Set IsAutoCalc=##class(DHCHAI.BT.Config).GetValByCode("OPSIsAutoCalcP75")
	If (IsAutoCalc=1) {
		If (aDateTo>aDateFrom) {
			For xDate=aDateFrom:1:aDateTo {
				Set ret = ##Class(DHCHAI.IRS.CRuleOperCatP75Srv).SyncOperCatP75(xDate)
			}
		}Else {
			Set ret = ##Class(DHCHAI.IRS.CRuleOperCatP75Srv).SyncOperCatP75(aDateTo)
		}
	}
	
	//add 2022-08-24  新增每月首日自动统计疑似筛查结果任务
	Set SyncDay=+$p($zd(+$h,3),"-",3)
	If (SyncDay=1) {   //每月第一天同步疑似筛查统计
		Set ret = ##class(DHCHAI.AMS.ScreenResultSrv).SuRuleTask()
	}
    Do ##class(DHCHAI.Task.TaskManager).WarnSendMsg("","",+$H,"发热标准差|30|2^发热人数|7|3^检出同种菌|7|3^检出同种同源多耐菌|7|3^相同感染诊断|7|3^入院24H内计入|1")
	Quit "OK"
}

/// 环境卫生学每月漏监测提醒
/// w ##class(DHCHAI.Task.TaskManager).AutoTask10("2021-06-25","2021-06-27")
ClassMethod AutoTask10(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	Set DateDay=+$p(aDateFrom,"-",3)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	Set IsCheckFlag = ##class(DHCHAI.BT.Config).GetValByCode("IREnviAItemConfig")  // 0：全部，1：环境卫生学监测项目走科室计划
	Quit:IsCheckFlag'=1 "OK"
	Set RemindDay = ##class(DHCHAI.BT.Config).GetValByCode("EnviHyRemindDay")    // 环境卫生学申请计划到期前提醒天数
	Quit:((DateDay+RemindDay)<30) "OK"   //每月按照30天算
	Set aGrpTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("CCLocGroupType","环境卫生学监测工作分组","1")
	Quit:aGrpTypeDr="" "OK"
	Set IsMangePlanFlag=##class(DHCHAI.BT.Config).GetValByCode("EnviHyMangePlan")  //0：否 院感科申请的项目是否计算到监测计划数量限制
    Set MsgCode = ##class(DHCHAI.BT.Config).GetValByCode("IREnviMsgCode")
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyLocItemsD(xID))
		Quit:xID=""
		
		Set objItem = ##class(DHCHAI.IR.EnviHyLocItems).GetObjById(xID)
		Continue:'$IsObject(objItem)
		Set IsActive = objItem.EHIsActive
		Continue:(IsActive'=1)
		Set ObjLoc = objItem.EHLocationDr
		Continue:'$IsObject(ObjLoc)
		Set LocID=ObjLoc.%Id()             // 监测科室
		Set LocDesc=ObjLoc.BTDesc2
		Set:LocDesc="" LocDesc=ObjLoc.BTDesc
		Continue:'$IsObject(objItem.EHItemDr)
		//获取HIS用户ID
		Set GrpID=$o(^DHCHAI.IR.CCLocGroupI("IndexLocType",LocID,aGrpTypeDr,0))
		Continue:GrpID=""
		Set objGrp=##class(DHCHAI.IR.CCLocGroup).GetObjById(GrpID)
		Continue:'$IsObject(objGrp)
		Continue:'$IsObject(objGrp.CCLocUser)
		Set CCLocUserDr=objGrp.CCLocUser.%Id()
		Set HISUser = objGrp.CCLocUser.BTXCode
		Continue:HISUser=""
		Set HISUserDr=+$p(HISUser,"||",2)
		
		// 监测项目
		Set EHItemDr   = objItem.EHItemDr.%Id()
		Set EHItemDesc = objItem.EHItemDr.EHItemDesc
		Continue:'$IsObject(objItem.EHItemUnit)
		// 限定单位（项/月、项/季度、项/半年、项/年）
		Set ItemUnitDr     = objItem.EHItemUnit.%Id()
		Set EHItemUnitDesc = objItem.EHItemUnit.BTDesc
		Set EHPlanDate = objItem.EHPlanDate   // 计划安排日期
		Continue:(EHPlanDate="")
		Set:EHPlanDate'="" EHPlanDate=$zd(EHPlanDate,3)
		Set EHItemMax = +objItem.EHItemMax
		Set Month=$p(EHPlanDate,"-",2)
		Set DateUnitDesc=""
		Set Year=$p($zd(+$h,3),"-",1)
		Set CurrMonth=$p($zd(aDateFrom,3),"-",2)
		Set DateFrom="",DateTo=""
		If (EHItemUnitDesc["月"){
			Set DateUnitDesc=Year_"年"_Month_"月"
			Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-"_CurrMonth,1)
			Set DateFrom    = $p(StartEndDate,"^",1)
			Set DateTo      = $p(StartEndDate,"^",2)
			Continue:((objItem.EHPlanDate<DateFrom)||(objItem.EHPlanDate>DateTo))
		}
		If (EHItemUnitDesc["季度"){
			If (Month<4){ //一季度
				Set DateUnitDesc=Year_"年1季度"
				Continue:(CurrMonth'="03")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-03",1)
				Set DateFrom    = $zdh(Year_"-01-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}ElseIf (Month<7){
				Set DateUnitDesc=Year_"年2季度"
				Continue:(CurrMonth'="06")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-06",1)
				Set DateFrom    = $zdh(Year_"-04-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}ElseIf (Month<10){
				Set DateUnitDesc=Year_"年3季度"
				Continue:(CurrMonth'="09")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-09",1)
				Set DateFrom    = $zdh(Year_"-07-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}Else{
				Set DateUnitDesc=Year_"年4季度"
				Continue:(CurrMonth'="12")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-12",1)
				Set DateFrom    = $zdh(Year_"-10-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}
		}
		If (EHItemUnitDesc["半年"){
			If (Month<6){
				Set DateUnitDesc=Year_"年上半年"
				Continue:(CurrMonth'="06")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-06",1)
				Set DateFrom    = $zdh(Year_"-01-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}Else{
				Set DateUnitDesc=Year_"年下半年"
				Continue:(CurrMonth'="12")
				Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-12",1)
				Set DateFrom    = $zdh(Year_"-07-01",3)
				Set DateTo      = $p(StartEndDate,"^",2)
			}
		}
		If (EHItemUnitDesc="项/年"){
			Set DateUnitDesc=Year_"年全年"
			Continue:(CurrMonth'="12")
			Set StartEndDate = ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(Year_"-12",1)
			Set DateFrom    = $zdh(Year_"-01-01",3)
			Set DateTo      = $p(StartEndDate,"^",2)
		}
		
		Set MonitSum=0
		//获取该科室该项目本月监测的次数
		For xDate = DateFrom:1:DateTo{
		 	Set xxID = ""
		 	For {
				Set xxID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnApplyDate",xDate,xxID))
				Quit:xxID=""
				Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(xxID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.EHItemDr)       //监测项目不允许为空
				Continue:'$IsObject(objRep.EHRepStatus)    //状态不允许为空
				Continue:(objRep.EHIsReCheck=1) // 过滤复查的报告
				Set ItemDr=objRep.EHItemDr.%Id()      //项目名称
				Continue:(EHItemDr'=ItemDr)
				//报告状态
				Set StatusCode=objRep.EHRepStatus.BTCode
				Set StatusDesc=objRep.EHRepStatus.BTDesc
				Continue:(StatusDesc="删除")
				Set MonitLocDr=""
				If $IsObject(objRep.EHMonitorLocDr){
					Set MonitLocDr=objRep.EHMonitorLocDr.%Id()
				}
				Continue:(LocID'=MonitLocDr)
				Set ApplyLocDr=""
				If $IsObject(objRep.EHApplyLocDr){
					Set ApplyLocDr=objRep.EHApplyLocDr.%Id()
				}
				Continue:(IsMangePlanFlag=0)&&(ApplyLocDr'=MonitLocDr) // 过滤院感科给临床科室开的项目
				Set MonitSum=MonitSum+1
			}
		}
		Continue:(MonitSum>=EHItemMax)
		
		Set NotMonitSum = EHItemMax-MonitSum  // 未检测数量
		
		Set MessageInfo=DateUnitDesc_"环境卫生学监测项目："_EHItemDesc_"，计划监测数量："_EHItemMax_"，已监测数量："_MonitSum_"，漏监测数量："_NotMonitSum_",请及时申请。"
		// 获取发送人ID
		Set ObjMed = ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","med")
		Set aFromUser = $p(ObjMed.BTXCode,"||",2)
		// 2000:对应消息类型中的消息通知的代码
        Set:MsgCode="" MsgCode="2000"
        Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(MessageInfo,MsgCode,aFromUser,"",HISUserDr,"")
		
		Set InputStr="^"_LocID_"^"_EHItemDr_"^"_DateUnitDesc_"^"_CCLocUserDr_"^"_MessageInfo_"^"_CSMsgDtlID
		Set Flg=##class(DHCHAI.IR.EnviLocMLog).Update(InputStr,"^")
	}
	Quit "OK"
}

/// 同步监控结果及疑似病例筛查
/// w ##class(DHCHAI.Task.TaskManager).AutoTask2("2017-12-30","2018-01-13")
ClassMethod AutoTask2(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask2("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	K ^TMP($zn,$j,"AutoTask2","PatAdm")	
	K ^TMP($zn,$j,"AutoTask2","AnalysisSrv")	
	
	//按就诊执行监控和筛查
	Set IsDynamicObject=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	
	//第一步：自然语义分析
	Set ^DHCHAI.Task.TaskManager("NLPStatus")=0  //初始化语义分析服务器状态，是否能链接,异常赋值=1
	Set Count=arrEpisodeDr.Count()
	For indEpis=1:1:Count {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
		Continue:$g(^DHCHAI.Task.TaskManager("NLPStatus"))=1
		
		Continue:$d(^TMP($zn,$j,"AutoTask2","AnalysisSrv",xEpisodeDr))   //分析一段时间内的患者数据时，不重复分析
	    Set ^TMP($zn,$j,"AutoTask2","AnalysisSrv",xEpisodeDr) = "" 
		
		Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"计数1")=indEpis_"/"_Count_"("_xEpisodeDr_")"
		Write "EpisodeDr="_xEpisodeDr,!
	
		If IsDynamicObject="dhcyes" {
			//2016库+东华NLP语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCSrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.3 入院诊断语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCSrv).AdmDiagAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.4 出院诊断语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCSrv).DiagAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)	
			//1.5 会诊意见语义分析
			//Do ##class(DHCHAI.RMES.AnalyDHCSrv).OECAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		} ElseIf IsDynamicObject="dhcno" {
			//2010库+东华NLP语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCUpSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCUpSrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		} ElseIf IsDynamicObject="yes" {
			//2016库+康夫子语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.3 入院诊断语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).AdmDiagAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.4 出院诊断语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).DiagAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)	
			//1.5 会诊意见语义分析
			//Do ##class(DHCHAI.RMES.AnalysisSrv).OECAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		} ElseIf IsDynamicObject="no" {
			//2010库+康夫子语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalysisUpSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalysisUpSrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		} ElseIf IsDynamicObject="key" {
			//关键词筛查
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalysisKeySrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalysisKeySrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		} ElseIf IsDynamicObject="key2.0" {
			//关键词筛查2.0
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalyCorpusSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalyCorpusSrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		}
	}
	//语义词（归一词）与感染症状词（主题词）对照
	//If (IsDynamicObject="yes")||(IsDynamicObject="no")||(IsDynamicObject="key"){
		Do ##Class(DHCHAI.RMES.ThWordsMapSrv).ChangeMapping()
	//}
	
	//第二步：监控结果与疑似筛查
	Set Count=arrEpisodeDr.Count()
	For indEpis=1:1:Count {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
		
		Continue:$d(^TMP($zn,$j,"AutoTask2","PatAdm",xEpisodeDr))   //同步一段时间内的患者时不重复判定
	    Set ^TMP($zn,$j,"AutoTask2","PatAdm",xEpisodeDr) = ""
	    
		Write "EpisodeDr="_xEpisodeDr,!
		Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"计数2")=indEpis_"/"_Count_"("_xEpisodeDr_")"
		
		//2.1 监控结果任务
		Do ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlResult(xEpisodeDr,aDateFrom,aDateTo)
		
		//2.2 疑似病例筛查
		//Do ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlag(xEpisodeDr)
	    Do ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(xEpisodeDr)
	    //2.3 VAE筛查任务
	    Set IsSyncVAEData=##class(DHCHAI.BT.Config).GetValByCode("IsSyncVAEData")
	    If (IsSyncVAEData=1){
			Do ##class(DHCHAI.IRS.VAEScreenSrv).GetScreenResult(xEpisodeDr,aDateFrom,aDateTo)
	    }
	}
	
	//科室每天发热人数
	Do ##class(DHCHAI.IRS.CCFeverNumSrv).GetFerverByDate("",aDateFrom,aDateTo)
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	K ^TMP($zn,$j,"AutoTask2","PatAdm")	
    K ^TMP($zn,$j,"AutoTask2","AnalysisSrv")
    
	Quit "OK"
}

/// 自动生成ICU日志信息
/// w ##class(DHCHAI.Task.TaskManager).AutoTask3("2018-01-01","2018-01-31")
ClassMethod AutoTask3(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask3("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	//是否启用'医嘱自动生成三管感染防控督查表'
	Set IsCreateIExAByOEOrd=##class(DHCHAI.BT.Config).GetValByCode("IsCreateIExAByOEOrd")

	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			Continue:'$isobject(objLoc.BTTypeDr)
			Set IsActive	= objLoc.BTIsActive
			Continue:IsActive'=1
			Set LocType     =objLoc.BTTypeDr.BTCode
			//Continue:(LocType'="W")
			Continue:(LocType'="W")&&(LocType'="E")  
			Set IsICU	    = objLoc.BTIsICU
			Set IsNICU	    = objLoc.BTIsNICU
			//Continue:(IsICU'=1)&&(IsNICU'=1)
			Set LocDr=objLoc.%Id()
			
			Write "LocDr="_LocDr,!
			
			Set DateFrom = aDateFrom
			Set:IsNICU=1 DateFrom =aDateFrom-7   // update 20220429 处理bug:2605688新生儿体重存在临床补录情况，造成日志中分组数据错误，前推7天重新生成
			//自动生成ICU日志明细信息
			Set flg=##class(DHCHAI.IRS.ICULogSrv).CreateICULogByOEOrd(aDateFrom,aDateTo,LocDr,LocType)
			
			//自动生成ICU日志汇总信息
			Set flg=##class(DHCHAI.IRS.ICULogSrv).CreateICULogByDay(DateFrom,aDateTo,LocDr,LocType)
			
			//自动生成'三管感染防控督查表'信息
			If (IsCreateIExAByOEOrd="1"){
				Set flg=##class(DHCHAI.IRS.ICUIExASrv).CreateIExAByOEOrd(aDateFrom,aDateTo,LocDr,LocType)
			}
		}
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit "OK"
}

/// 同步修改、作废记录任务
/// w ##class(DHCHAI.Task.TaskManager).AutoTask4("2018-01-01","2018-03-24")
ClassMethod AutoTask4(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask4("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Set arrEpisodeID=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate(aDateFrom,aDateTo)
	Set Count=arrEpisodeID.Count()
	For indEpis=1:1:Count {
		Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
		Continue:xEpisodeID=""
		
		Write "EpisodeID="_xEpisodeID,!
		Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeID_")"
		
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(xEpisodeID)
		Continue:'$IsObject(objEpisode)
		Set EpisodeDr=objEpisode.%Id()
		
		//处理历史就诊和转科数据
		Do ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByEpisodeID("HIS01",$p(xEpisodeID,"||",2))
		
		//2.2.3 医嘱及抗菌用药
		Set flg=##class(DHCHAI.DI.ERR.SyncHisErrInfo).SyncOrdErrByEpis("HIS01",xEpisodeID,aDateFrom,aDateTo)
		
		//2.2.4 护理记录
		Set flg=##class(DHCHAI.DI.ERR.SyncNisErrInfo).SyncNisErrByEpis("NIS01",xEpisodeID,aDateFrom,aDateTo)
		
		//2.2.5 手麻记录
		Do ##class(DHCHAI.DI.ERR.SyncOpsErrInfo).SyncOperErrByEpis("OPS01",xEpisodeID,aDateFrom,aDateTo)
		//2.2.5.2 首页记录、编目记录 add 20211109	
		Do ##class(DHCHAI.DI.ERR.SyncOpsErrInfo).SyncWMROperErrByEpis("MRS01",xEpisodeID,aDateFrom,aDateTo)   //编目手术
		Do ##class(DHCHAI.DI.ERR.SyncOpsErrInfo).SyncEMROperErrByEpis("EMR01",xEpisodeID,aDateFrom,aDateTo)   //首页手术

		//2.2.6 检查报告
		Do ##class(DHCHAI.DI.ERR.SyncPacsErrInfo).SyncPacsErrByEpis("RIS01",xEpisodeID,aDateFrom,aDateTo)
		
		//2.2.7 检验结果
		Set flg=##class(DHCHAI.DI.ERR.SyncLabErrInfo).SyncLabErrByEpis("LIS01",xEpisodeID,aDateFrom,aDateTo)
		
		//2.2.8 病程记录
		Set flg=##class(DHCHAI.DI.ERR.SyncEmrErrInfo).SyncEmrErrByEpis("EMR01",xEpisodeID,aDateFrom,aDateTo)
		
		//处理更新监控结果
		Set flg=##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlResult2(EpisodeDr,+$h,+$h)
		
		//处理疑似病例筛查
		Do ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(EpisodeDr)
		
		//删除出院日期后的ICU日志记录(转科记录导致的多余数据) add 20190214
		If $d(^DHCHAI.IR.ICULogDtlI("IndexEpisodeDr",EpisodeDr)) {  //先检查类中是否有这个索引，没有需添加上并重建索引
			Do ##class(DHCHAI.IR.ICULogDtl).DeleteByDischDate(EpisodeDr)
		}

	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit "OK"
}

/// 同步监控检出菌项目
/// w ##class(DHCHAI.Task.TaskManager).CheckBactTask("2018-04-01","2018-04-10")
ClassMethod CheckBactTask(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//2.1 就诊信息
	Set ret = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByDate("HIS01",aDateFrom,aDateTo)
	
	//先同步送检+检验结果
	Set CurrTime = $h
	Set arrEpisodeID=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate(aDateFrom,aDateTo)
	Set Count=arrEpisodeID.Count()
	For indEpis=1:1:Count {
		Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
		Continue:xEpisodeID=""

		//2.2.7 送检+检验结果
		Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber("LIS01",xEpisodeID,aDateFrom,aDateTo)
		Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate("LIS01",xEpisodeID,aDateFrom,aDateTo)
	}
	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	For indEpis=1:1:arrEpisodeDr.Count() {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
		
		Write "EpisodeDr="_xEpisodeDr,!
		
		Do ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlBactResult(xEpisodeDr,aDateFrom,aDateTo)
	}
	//Write "按就诊执行监控和筛查用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	
	Quit "OK"
}

/// 同步监控检出菌项目
/// w ##class(DHCHAI.Task.TaskManager).CheckBackTask2("2018-04-02","2018-04-02")
ClassMethod CheckBackTask2(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	Set return = -1
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	Quit:(LabRepVer'="LIS1.0")&&(LabRepVer'="LIS2.0")&&(LabRepVer'="LISC1.0")&&(LabRepVer'="LISC2.0") return

	If LabRepVer="LIS1.0" {
		//Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:QryLabVisitReport")
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:QryGermVisitReport") //仅微生物送检
	} ElseIf LabRepVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:QryLabVisitReport")
	} ElseIf LabRepVer="LISC1.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncLis1Srv:QryLabVisitRepItem")
	} ElseIf LabRepVer="LISC2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.EnsFromLis2Srv:SelectLISItemListByDate")
	}
  	Set sc=rs.Execute("",aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	Do:rowData'="" rowData.%Close()
	Set Count=+$g(^tmpDHCHAI.Task.TaskManagerC(+$h,"Count"))
	Set xCount=0
	Set xxCount=0
	While (rs.Next()){
		Set xCount=xCount+1
		Continue:xCount'>Count
		Set xxCount=xxCount+1
		Quit:xxCount>50
		Set num=$i(^tmpDHCHAI.Task.TaskManagerC(+$h,"Count"))
	    //部分检验医嘱及项目存在回车换行符
	    Set TestSetStr=rs.Data("TestSetStr")
	    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
	    Set SpecDesc=rs.Data("SpecDesc")
	    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("VisitNumberID"),"VisitNumberID")
	    Do rowData.SetAt(rs.Data("EpisodeID"),"EpisodeID")
	    
	    //同步就诊信息
	    Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX("HIS01"_rs.Data("EpisodeID"))
		If '$IsObject(objAdm){
			Set EpisodeDr=##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByEpisodeID("HIS01",rs.Data("EpisodeID"))
		}
		
		If (LabRepVer'="LISC2.0"){
			Do rowData.SetAt(EpisodeDr,"EpisodeDr")
		    Do rowData.SetAt(rs.Data("EpisodeNo"),"EpisodeNo")
		    Do rowData.SetAt(rs.Data("SpecCode"),"SpecCode")
		    Do rowData.SetAt(SpecDesc,"SpecDesc")
		    Do rowData.SetAt(rs.Data("LocCode"),"LocCode")
		    Do rowData.SetAt(rs.Data("LocDesc"),"LocDesc")
		    Do rowData.SetAt(rs.Data("CollDate"),"CollDate")
		    Do rowData.SetAt(rs.Data("CollTime"),"CollTime")
		    Do rowData.SetAt(rs.Data("CollUserCode"),"CollUserCode")
		    Do rowData.SetAt(rs.Data("CollUserName"),"CollUserName")
		    Do rowData.SetAt(rs.Data("RecDate"),"RecDate")
		    Do rowData.SetAt(rs.Data("RecTime"),"RecTime")
		    Do rowData.SetAt(rs.Data("RecUserCode"),"RecUserCode")
		    Do rowData.SetAt(rs.Data("RecUserName"),"RecUserName")
		    Do rowData.SetAt(TestSetStr,"TestSetStr")
		    
		    Do rowData.SetAt(rs.Data("ReportID"),"ReportID")
		    Do rowData.SetAt(rs.Data("TestSetRow"),"TestSetRow")
		    Do rowData.SetAt(rs.Data("Order"),"Order")
		    Do rowData.SetAt(rs.Data("RepStatus"),"RepStatus")
		    Do rowData.SetAt(rs.Data("RegDate"),"RegDate")
		    Do rowData.SetAt(rs.Data("RegTime"),"RegTime")
		    Do rowData.SetAt(rs.Data("RegUserCode"),"RegUserCode")
		    Do rowData.SetAt(rs.Data("RegUserName"),"RegUserName")
		    Do rowData.SetAt(rs.Data("AuthDate"),"AuthDate")
		    Do rowData.SetAt(rs.Data("AuthTime"),"AuthTime")
		    Do rowData.SetAt(rs.Data("AuthUserCode"),"AuthUserCode")
		    Do rowData.SetAt(rs.Data("AuthUserName"),"AuthUserName")
		}Else {
			//部分检验医嘱及项目存在回车换行符
		    Set TestSetStr=rs.Data("TestSetStr")
		    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
		    Set SpecDesc=rs.Data("SpecimenDesc")
		    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
		    // 标本号作为标本ID，平台无此字段
		    Do rowData.SetAt(rs.Data("LabEpisodeNo"),"VisitNumberID")
		    Do rowData.SetAt(EpisodeID,"EpisodeID")
			Do rowData.SetAt(EpisodeDr,"EpisodeDr")
		    Do rowData.SetAt(rs.Data("LabEpisodeNo"),"EpisodeNo")
		    Do rowData.SetAt(rs.Data("SpecimenCode"),"SpecCode")
		    Do rowData.SetAt(SpecDesc,"SpecDesc")
		    Do rowData.SetAt(rs.Data("LocCode"),"LocCode")
		    Do rowData.SetAt(rs.Data("LocDesc"),"LocDesc")
		    Do rowData.SetAt(rs.Data("CollectionDate"),"CollDate")
		    Do rowData.SetAt(rs.Data("CollectionTime"),"CollTime")
		    Do rowData.SetAt(rs.Data("CollectUserCode"),"CollUserCode")
		    Do rowData.SetAt(rs.Data("CollectUserName"),"CollUserName")
		    Do rowData.SetAt(rs.Data("ReceiveDate"),"RecDate")
		    Do rowData.SetAt(rs.Data("ReceiveTime"),"RecTime")
		    Do rowData.SetAt(rs.Data("ReceiveUserCode"),"RecUserCode")
		    Do rowData.SetAt(rs.Data("ReceiveUserName"),"RecUserName")
		    Do rowData.SetAt(rs.Data("LocCode"),"WardCode")
		    Do rowData.SetAt(rs.Data("LocDesc"),"WardDesc")
		    Do rowData.SetAt(TestSetStr,"TestSetStr")
		    
		    Do rowData.SetAt(rs.Data("VisitNumberReportDR"),"ReportID")
		    Do rowData.SetAt(rs.Data("TestSetRow"),"TestSetRow")
		    Do rowData.SetAt(rs.Data("Order"),"Order")
		    Do rowData.SetAt(rs.Data("RepStatus"),"RepStatus")
		    Do rowData.SetAt(rs.Data("RegDate"),"RegDate")
		    Do rowData.SetAt(rs.Data("RegTime"),"RegTime")
		    Do rowData.SetAt(rs.Data("RegUserCode"),"RegUserCode")
		    Do rowData.SetAt(rs.Data("RegUserName"),"RegUserName")
		    Do rowData.SetAt(rs.Data("AuthorisationDate"),"AuthDate")
		    Do rowData.SetAt(rs.Data("AuthorisationTime"),"AuthTime")
		    Do rowData.SetAt(rs.Data("AuthUserCode"),"AuthUserCode")
		    Do rowData.SetAt(rs.Data("AuthUserName"),"AuthUserName")
		    //审核A、登记R、作废U
	   		Set RepStatus=rs.Data("RepStatus")
		}
		//审核A、登记R、作废U
	    Set RepStatus=rs.Data("RepStatus")
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("LIS01","LabRepStatus",RepStatus)
		Set:MapStatus="" MapStatus=RepStatus
		
		//检验1.0（A审核）
		//检验2.0（1登记，2初审，3审核，4复查，5取消审核，6作废）
	    Set IsActive=0 
		Set:(MapStatus="A") IsActive=1
		Set:(MapStatus=2)||(MapStatus=3)||(MapStatus=4) IsActive=1
	 
	    Do rowData.SetAt(IsActive,"IsActive")  //是否有效
	    
		//标本记录检查
		Set XCode=rowData.GetAt("VisitNumberID")
		Set VisitNumberDr=""
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjByXCode("LIS01",XCode)
		If $IsObject(objVisitNumber){
			Set VisitNumberDr=objVisitNumber.%Id()
		} Else {
			//保存标本记录
			Set VisitNumberDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitNumber(rowData,"LIS01")
			Continue:(+VisitNumberDr)<1
		}
		Continue:(+VisitNumberDr)<1
		Do rowData.SetAt(VisitNumberDr,"VisitNumberDr")
		 
		//保存检验医嘱
		Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitTestSet(rowData,"LIS01")
		
		//保存检验报告
		Set ReportDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitReport(rowData,"LIS01")
		Continue:(+ReportDr)<1
		
		//保存检验结果
		Set LReportID=rowData.GetAt("ReportID")  //LIS报告ID
		Set TestSetStr=rowData.GetAt("TestSetStr")
		Set TSCode=$p(TestSetStr,"^",1)     //TSCode
		Set TSDesc=$p(TestSetStr,"^",2)     //TSDesc
		Set ArcimCode=$p(TestSetStr,"^",3)  //ArcimCode
		Set ArcimDesc=$p(TestSetStr,"^",4)  //ArcimDesc
		Set TestSetData=TSDesc_$c(1)_ArcimDesc
		
		If LabRepVer="LIS1.0" {
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromLis10Srv).GetRepResult(LReportID)
		} Else {
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepResult(LReportID)
		}
		For indRst=1:1:$listlength(ResultDatas) {
			Set ResultData=$listget(ResultDatas,indRst)
			Continue:ResultData=""
			
			Set ResultInfo=""
			Set $p(ResultInfo,"^",1)=ReportDr
			Set $p(ResultInfo,"^",2)=$p(ResultData,"^",2)   //TCCode
			Set $p(ResultInfo,"^",3)=$p(ResultData,"^",3)   //TCDesc
			Set $p(ResultInfo,"^",4)=$p(ResultData,"^",4)   //RstFormat
			Set $p(ResultInfo,"^",5)=$p(ResultData,"^",5)   //Result
			Set $p(ResultInfo,"^",6)=$p(ResultData,"^",6)   //TextRes
			Set $p(ResultInfo,"^",7)=$p(ResultData,"^",7)   //ResNoes
			Set $p(ResultInfo,"^",8)=$p(ResultData,"^",8)   //AbFlag
			Set $p(ResultInfo,"^",9)=$p(ResultData,"^",9)   //Unit
			Set $p(ResultInfo,"^",10)=$p(ResultData,"^",10) //RefRanges
			Set $p(ResultInfo,"^",11)=$p(ResultData,"^",11) //MDRResult
			Set $p(ResultInfo,"^",12)=TestSetData           //TestSetData
			Set $p(ResultInfo,"^",13)=EpisodeDr             //EpisodeDr
			Set ResultDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepResult(ResultInfo,"LIS01")
			Continue:(+ResultDr)<1
			
			//保存药敏试验结果
			Set LResultID=$p(ResultData,"^",1)  //LIS结果ID
			
			If LabRepVer="LIS1.0" {
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.FromLis10Srv).GetResultSen(LResultID)
			} Else {
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetResultSen(LResultID)
			}
			For indTSS=1:1:$listlength(TestSenDatas) {
				Set TestSenData=$listget(TestSenDatas,indTSS)
				Continue:TestSenData=""
				
				Set TestSenInfo=""
				Set $p(TestSenInfo,"^",1)=ResultDr
				Set $p(TestSenInfo,"^",2)=$p(TestSenData,"^",1)   //AntCode
				Set $p(TestSenInfo,"^",3)=$p(TestSenData,"^",2)   //AntDesc
				Set $p(TestSenInfo,"^",4)=$p(TestSenData,"^",3)   //SenDesc
				Set $p(TestSenInfo,"^",5)=EpisodeDr               //EpisodeDr
				Set TestSenDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepRstSen(TestSenInfo,"LIS01")
				Continue:(+TestSenDr)<1
			}
			
			//保存耐药机制结果
			If LabRepVer="LIS1.0" {
				///
				Set RstResDatas=""
			} Else {
				Set RstResDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepRstRes(LResultID)
			}
			
			For indRes=1:1:$listlength(RstResDatas) {
				Set RstResData=$listget(RstResDatas,indRes)
				Continue:RstResData=""
			
				Set RstResInfo=""
				Set $p(RstResInfo,"^",1)=ResultDr
				Set $p(RstResInfo,"^",2)=$p(RstResData,"^",2)   //ResItemCode
				Set $p(RstResInfo,"^",3)=$p(RstResData,"^",3)   //ResItemName
				Set $p(RstResInfo,"^",4)=$p(RstResData,"^",5)   //RstCode
				Set $p(RstResInfo,"^",5)=$p(RstResData,"^",6)   //RstName
				Set $p(RstResInfo,"^",6)=EpisodeDr             //EpisodeDr
				Set RstResDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepRstRes(RstResInfo,"LIS01")
				Continue:(+RstResDr)<1
			}
		}
		//Write "EpisodeDr="_EpisodeDr,!
		
		Do ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlBactResult(EpisodeDr,aDateFrom,aDateTo)
    }
    If (xxCount=0) {
    	Set return="OK"
    	Kill ^tmpDHCHAI.Task.TaskManagerC
    } Else {
    	Set return=+$g(^tmpDHCHAI.Task.TaskManagerC(+$h,"Count"))
    }
    Quit return
}

/// 测试方法
/// w ##class(DHCHAI.Task.TaskManager).Test("2017-12-30","2018-01-13")
ClassMethod Test(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	Set CurrTime = $h
	Set arrAdm=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate(aDateFrom,aDateTo)
	For indAdm=1:1:arrAdm.Count() {
		Set xEpisodeID=arrAdm.GetAt(indAdm)
		Continue:xEpisodeID=""
		
		Write "EpisodeID="_xEpisodeID,!
		
		Do ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmTransLoc("HIS01",xEpisodeID)
		//Do ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrByDateAdm("EMR01",xEpisodeID,aDateFrom,aDateTo)
	}
	//科室每天发热人数
	Do ##class(DHCHAI.IRS.CCFeverNumSrv).GetFerverByDate("",aDateFrom,aDateTo)
	
	Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	
	Quit "OK"
}

/// 测试方法
/// w ##class(DHCHAI.Task.TaskManager).Test2("2017-12-30","2018-01-13")
ClassMethod Test2(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//按就诊执行监控和筛查
	Set CurrTime = $h
	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	For indEpis=1:1:arrEpisodeDr.Count() {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
		
		Write "EpisodeDr="_xEpisodeDr,!
		
		//3.1 病程语义分析
		Do ##class(DHCHAI.RMES.AnalysisSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		
		//3.4 疑似病例筛查
		//Do ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlag(xEpisodeDr)
	}
	Write "按就诊执行监控和筛查用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	
	Quit "OK"
}

/// Description:  生成检验项目结果列表（S结果类型）
/// w ##class(DHCHAI.Task.TaskManager).BuildRstDicByTC("LIS01","N6108")
ClassMethod BuildRstDicByTC(aSCode As %String, aTCCode As %String) As %String
{
	New (aSCode, aTCCode)
	Set return=""
	Quit:(aSCode="")||(aTCCode="") return
	
	Set xRstID=0,Count=0
	For {
		Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode2"," "_$zcvt(aTCCode,"U"),xRstID))
		Quit:xRstID=""
		
		Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
		Continue:'$IsObject(objRst)
		Continue:'$IsObject(objRst.LabReportDr)
		Continue:'$IsObject(objRst.LabReportDr.LabVisitNumberDr)
		Continue:'$IsObject(objRst.LabReportDr.LabVisitNumberDr.LabEpisodeDr)
		Continue:objRst.LabReportDr.LabVisitNumberDr.LabSCode'=aSCode
		Set objEpisodeDr=objRst.LabReportDr.LabVisitNumberDr.LabEpisodeDr
		Set EpisodeIDx=objEpisodeDr.PAEpisodeIDx
		Set EpisodeDr=objEpisodeDr.%Id()
		Set AuthDate=objRst.LabReportDr.LabAuthDate
		Continue:AuthDate=""
		Continue:EpisodeIDx=""
		Continue:EpisodeDr=""
		
		Write "EpisodeDr="_EpisodeDr,!
		
		// 同步检验报告
		Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate(aSCode,EpisodeIDx,AuthDate,AuthDate)
		
		// 常规检验监控
		Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-TestAb")
		Set flg=##class(DHCHAI.IRC.LabTestAbSrv).Check(EpisodeDr,AuthDate,AuthDate,ItmMastID)
		
		Set Count=Count+1
	}
	
    Set return=Count
    Quit return
}

/// 按照出院日期同步电子病历出院诊断
/// 需先维护出院诊断数语集
/// w ##class(DHCHAI.Task.TaskManager).AutoTask5("2018-01-01","2018-01-31")
ClassMethod AutoTask5(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask5("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
			Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime))
			Quit:xTime=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime,xPaadm))
				Quit:xPaadm=""
				Set EpisodeDr=xPaadm
				Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
				Continue:'$isobject(objAdm)
				Set EpisodeID = objAdm.PAEpisodeIDx
				Write "EpisodeID="_EpisodeID ,!
				
				// 根据就诊同步患者电子病历出院诊断
				Do ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrDiagnos("HIS01",EpisodeID,xDate,xDate)
				
				//处理删除已出院中间转科记录未结束的患者转科记录(手工修改转科记录前条转出日期晚于后条转入日期所致)
				Do ##class(DHCHAI.DP.PAAdmTrans).DeleteUnEndTrans(EpisodeDr)
			}
		}
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit "OK"
}

/// 按照出院日期补录多耐信息
/// 同步当前日期前5天的出院病人检验结果信息
/// w ##class(DHCHAI.Task.TaskManager).AutoTask6(+$h-5,+$h-1)
ClassMethod AutoTask6(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask6("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
			Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime))
			Quit:xTime=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime,xPaadm))
				Quit:xPaadm=""
				Set EpisodeDr=xPaadm
				Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
				Continue:'$isobject(objAdm)
				Set EpisodeID = objAdm.PAEpisodeIDx
				Write "EpisodeID="_EpisodeID ,!

				//2.2.6 检查报告
				Do ##class(DHCHAI.DI.DHS.SyncPacsInfo).SyncPacsByDateAdm("RIS01",EpisodeID,xDate,(xDate+5))
				
				//2.2.7 送检+检验结果
				Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber("LIS01",EpisodeID,xDate,(xDate+5))
				Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate("LIS01",EpisodeID,xDate,(xDate+5))
				
				// 下面三个都可能检出多重耐药菌
				// 检出菌
				Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
				Set flg=##class(DHCHAI.IRC.LabBacteriaSrv).Check(EpisodeID,xDate,(xDate+5),ItmMastID)
				
				// 常规检验
				Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-TestAb")
				Set flg=##class(DHCHAI.IRC.LabTestAbSrv).Check(EpisodeID,xDate,(xDate+5),ItmMastID)
				
				// 常规送检
				Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Submit")
				Set flg=##class(DHCHAI.IRC.LabSubmitSrv).Check(EpisodeID,xDate,(xDate+5),ItmMastID)
				
			}
		}
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit "OK"
}

/// 同步检出菌
/// w ##class(DHCHAI.Task.TaskManager).AutoTask7("2019-09-01","2019-09-10")
ClassMethod AutoTask7(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask7("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	//按就诊执行监控和筛查
	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	
	K ^TMP($zn,$j,"AutoTask7","PatAdm")	
	// 检出菌
	Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
	
	//第二步：监控结果与疑似筛查
	Set Count=arrEpisodeDr.Count()
	For indEpis=1:1:Count {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
				
		Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"计数7")=indEpis_"/"_Count_"("_xEpisodeDr_")"
		
		Continue:$d(^TMP($zn,$j,"AutoTask7","PatAdm",xEpisodeDr))
	    Set ^TMP($zn,$j,"AutoTask7","PatAdm",xEpisodeDr) = ""
	    Write "EpisodeDr="_xEpisodeDr,!
             
		//2.1 监控结果任务
		Do ##class(DHCHAI.IRC.LabBacteriaSrv).Check(xEpisodeDr,aDateFrom,aDateTo,ItmMastID)
	}
	
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	K ^TMP($zn,$j,"AutoTask7","PatAdm")	
	Quit "OK"
}

/// 处理新规则筛查不到的历史已出院患者未处置疑似病例
/// w ##class(DHCHAI.Task.TaskManager).AutoTask8("2019-10-01","2019-11-07")
ClassMethod AutoTask8(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask8("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	K ^TMP($zn,$j,"AutoTask8","PatAdm")	
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
			Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime))
			Quit:xTime=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime,xPaadm))
				Quit:xPaadm=""
				Set EpisodeDr=xPaadm
				Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
				Continue:'$isobject(objAdm)
				
				Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",EpisodeDr,0))
				Continue:AttID="" 
				Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
				Continue:'$IsObject(objAtt) 
				Set IsSusInf=objAtt.CSIsSusInf    //疑似病例  （1疑似病例）
				Continue:IsSusInf'=1
				Continue:$d(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",EpisodeDr))  //存在记录退出
				
				Continue:$d(^TMP($zn,$j,"AutoTask8","PatAdm",EpisodeDr))
	   			Set ^TMP($zn,$j,"AutoTask8","PatAdm",EpisodeDr) = ""
	    		Write "EpisodeDr="_EpisodeDr,!
             
				//2.2 疑似病例筛查
				 Do ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(EpisodeDr)
			}
		}
	}
	
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	K ^TMP($zn,$j,"AutoTask8","PatAdm")	
	Quit "OK"
}

/// 处理细菌感染类型  update 20210913 多耐->细菌，不区分是否多耐细菌
/// w ##class(DHCHAI.Task.TaskManager).AutoTask9(+$h-200,+$h-1)
ClassMethod AutoTask9(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	Set ItemID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	Quit:ItemID="" "OK"
    Set ItmScreenID=$o(^DHCHAI.IR.CCItmScreenI("IdxofDesc","检出致病菌",0))
    Quit:ItmScreenID="" "OK"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask9("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	K ^TMP($zn,$j,"AutoTask9")	
	For xDate=aDateFrom:1:aDateTo {  //时段内报告细菌（处理确诊操作前后细菌感染情况）
	   	Set xResultID=""
		For {
			Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",ItemID,xDate,xResultID))
			Quit:xResultID=""
				  
			Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
			Continue:'$IsObject(objResult) 
			Continue:'$IsObject(objResult.CCEpisodeDr)
			Continue:objResult.CCIsActive'=1
			//update 20210913  需求2151261：细菌感染类型设置和同步及相关统计报表规则统一与优化
			//Continue:('$IsObject(objResult.CCMRBTpDr))&&('$IsObject(objResult.CCMRBTp2Dr))  //只处理多重耐药菌
			Set EpisodeID=objResult.CCEpisodeDr.%Id()
			Set Bacteria=objResult.CCBacteria  //细菌名称
           
	       	//患者是否有细菌确诊排除记录
	       	Continue:'$d(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeID,ItmScreenID," "_Bacteria))
	      	Set xScreeningID =""   //排除确诊记录
	      	For {
		      	Set xScreeningID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",EpisodeID,ItmScreenID," "_Bacteria,xScreeningID))
	        	Quit:xScreeningID=""
	        	
	      		Set xSubID = ""
			   	For {
			   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreeningID,"Dtl",xSubID))
			   		Quit:xSubID=""
			   		
			   		Set xID =xScreeningID_"||"_xSubID
			   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
					Continue:'$IsObject(objScreenDtl)
					Set Status =objScreenDtl.CSStatus
					Set RstDate =objScreenDtl.CSRstDate	
					Set InfDate="",InfType=""
					If ($IsObject(objScreenDtl.CSInfRepPosDr)) {
						Set InfRepDiagID=objScreenDtl.CSInfRepPosDr.%Id()	              //项目确诊感染诊断信息ID
						Set IsActive=objScreenDtl.CSInfRepPosDr.IRIsActive
						Continue:IsActive'=1
						Set InfType =objScreenDtl.CSInfRepPosDr.IRInfType
						Set InfDate =objScreenDtl.CSInfRepPosDr.IRInfDate
					}
					Set ^TMP($zn,$j,"AutoTask9",EpisodeID,Bacteria,"ScreenDtl",xID)=$lb(Bacteria,Status,RstDate,InfType,InfDate)
			   	}
	      	}
	      	
      	 	Set xID = ""   //细菌检出记录
            For {
	            Set xID = $o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",EpisodeID,ItemID," "_Bacteria,xID))
            	Quit:xID=""

           	    Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(objResult) 
				Continue:'$IsObject(objResult.CCEpisodeDr)
				Continue:objResult.CCIsActive'=1
			    //update 20210913  需求2151261：细菌感染类型设置和同步及相关统计报表规则统一与优化
				//Continue:('$IsObject(objResult.CCMRBTpDr))&&('$IsObject(objResult.CCMRBTp2Dr))  //只处理多重耐药菌
				Set Bacteria=objResult.CCBacteria  //细菌名称
				Set ActDate =objResult.CCActDate   //细菌送检日期
				Continue:ActDate=""
				Set ActTime =objResult.CCActTime
				Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
		       	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
		       	Continue:'$IsObject(objLabRes) 
		       	Set MakeInfType = objLabRes.LabMakeInfType
		       	Set IsByHand = objLabRes.LabIsByHand
		       	Continue:(IsByHand=1)   //手工标记感染类型后不再处理
		    	
		       	Set ^TMP($zn,$j,"AutoTask9",EpisodeID,Bacteria,"RepResult",ActDate,ResultID)=$lb(Bacteria,ActDate,MakeInfType)  //加入日期便于取送检日期第一条记录
			}
		}
	}
	
	//时段内未报告细菌有确诊排除记录（处理确诊操作前后细菌感染情况）
	For yDate=aDateFrom:1:aDateTo {  //时段内报告多耐细菌
		Set yTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
		For {
			Set yTime=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",yDate,yTime))
			Quit:yTime=""
			Set yLogID=""
			For {
				Set yLogID=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",yDate,yTime,yLogID))
				Quit:yLogID=""
				Set ScreeningID=$p(yLogID,"||",1)  //筛查表
				Set objScr =##class(DHCHAI.IR.CCScreening).GetObjById(ScreeningID)
				Continue:'$IsObject(objScr) 
				Continue:'$IsObject(objScr.CSItmScreenDr) 
				Continue:'$IsObject(objScr.CSEpisodeDr) 
				Set ItmScreenTxt = objScr.CSItmScreenTxt
				Set ItmScreenDr = objScr.CSItmScreenDr.%Id()
				Continue:ItmScreenDr'=ItmScreenID
				Set EpisodeID = objScr.CSEpisodeDr.%Id()
				
				Set RstFromDate = objScr.CSRstFromDate
				Set RstToDate = objScr.CSRstToDate
			    
			    Set IsHaveBact=0
				//患者是否有细菌检出
	       		Continue:'$d(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",EpisodeID,ItemID," "_ItmScreenTxt))
	            Set yResultID = ""   //细菌检出记录
	            For {
		            Set yResultID = $o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",EpisodeID,ItemID," "_ItmScreenTxt,yResultID))
	            	Quit:yResultID=""
				
	           	    Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(yResultID)
					Continue:'$IsObject(objResult) 
					Continue:'$IsObject(objResult.CCEpisodeDr)
					Continue:objResult.CCIsActive'=1
					//update 20210913  需求2151261：细菌感染类型设置和同步及相关统计报表规则统一与优化
					//Continue:('$IsObject(objResult.CCMRBTpDr))&&('$IsObject(objResult.CCMRBTp2Dr))  //只处理多重耐药菌
					Set Bacteria=objResult.CCBacteria  //细菌名称
					Set ActDate =objResult.CCActDate   //细菌送检日期
					Continue:ActDate=""
					Set ActTime =objResult.CCActTime
					Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
			       	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
			       	Continue:'$IsObject(objLabRes) 
			       	Set MakeInfType = objLabRes.LabMakeInfType
			       	Set IsByHand = objLabRes.LabIsByHand
			       	Continue:(IsByHand=1)   //手工标记感染类型后不再处理
			    	Set IsHaveBact=1
			       	Set ^TMP($zn,$j,"AutoTask9",EpisodeID,Bacteria,"RepResult",ActDate,ResultID)=$lb(Bacteria,ActDate,MakeInfType)  //加入日期便于取送检日期第一条记录
				}
				Continue:IsHaveBact'=1
				Set ySubID = ""    //排除确诊记录
			   	For {
			   		Set ySubID=$o(^DHCHAI.IR.CCScreeningD(ScreeningID,"Dtl",ySubID))
			   		Quit:ySubID=""
			   		
			   		Set yID =ScreeningID_"||"_ySubID
			   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(yID)
					Continue:'$IsObject(objScreenDtl)
					Set Status =objScreenDtl.CSStatus
					Set RstDate =objScreenDtl.CSRstDate	
					Set InfDate="",InfType=""
					If ($IsObject(objScreenDtl.CSInfRepPosDr)) {
						Set InfRepDiagID=objScreenDtl.CSInfRepPosDr.%Id()	              //项目确诊感染诊断信息ID
						Set IsActive=objScreenDtl.CSInfRepPosDr.IRIsActive
						Continue:IsActive'=1
						Set InfType =objScreenDtl.CSInfRepPosDr.IRInfType
						Set InfDate =objScreenDtl.CSInfRepPosDr.IRInfDate
					}
					Set ^TMP($zn,$j,"AutoTask9",EpisodeID,ItmScreenTxt,"ScreenDtl",yID)=$lb(ItmScreenTxt,Status,RstDate,InfType,InfDate)
			   	}
			}		
		}
	}
	
	Set tEpisodeID=""
	For {
		Set tEpisodeID=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID))
		Quit:tEpisodeID=""
		
		Set arrResult1="",arrResult2="",arrResult3=""
		Set tBacteria=""
		For {
			Set tBacteria=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria))
			Quit:tBacteria=""
			
			Set tDtlID=""
			For {
				Set tDtlID=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"ScreenDtl",tDtlID))
				Quit:tDtlID=""
				
				Set ScreenDtl=$g(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"ScreenDtl",tDtlID))
				Continue:ScreenDtl=""
				Set Status = $lg(ScreenDtl,2)
				Set RstDate = $lg(ScreenDtl,3)
				Set InfType = $lg(ScreenDtl,4)
				Set InfDate = $lg(ScreenDtl,5)
			    Set arrResult = Status_","_RstDate_","_InfDate_","_InfType
				If Status=1 {  //确诊
					Set arrResult1=arrResult1_"^"_arrResult			
				} Else {  //排除  
					Set arrResult2=arrResult2_"^"_arrResult
				}
				//全部数据
				Set arrResult3=arrResult3_"^"_arrResult
			}
			Set:arrResult1'="" arrResult1=$e(arrResult1,2,$l(arrResult1))
			Set:arrResult2'="" arrResult2=$e(arrResult2,2,$l(arrResult2))
			Set:arrResult3'="" arrResult3=$e(arrResult3,2,$l(arrResult3))
			
			If (arrResult1=arrResult3) {  //仅有确诊数据
				Set FirstActDate="",NextInfDate="",NextActDate=""
		    	For tind=1:1:$l(arrResult1,"^") {
			    	Set arrResult=$p(arrResult1,"^",tind)
			    	Continue:arrResult=""
			    	Set InfDate =$p(arrResult,",",3)
		  			Set InfType =$p(arrResult,",",4)
			    	Set:tind>1 NextInfDate = InfDate,NextActDate=""
			    	Set tActDate=""
					For {
						Set tActDate=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"RepResult",tActDate))
						Quit:tActDate=""
						Continue:(tind>1)&&(tActDate<NextInfDate)	//多次确诊时，从第二次确诊后，不再查找感染日期之前的送检
						Set:FirstActDate="" FirstActDate=tActDate   //第一次送检日期 确诊时第一条送检为HA/CA，之后为HA/CA重复
						Set:(NextInfDate'="")&&(NextActDate="") NextActDate=tActDate
						
						If (FirstActDate=tActDate)||(tActDate=NextActDate) { //存在确诊感染日期早于送检日期情况，故不比较两者日期大小
						     Set MakeCode = 1   //HA 
						     Set:InfType'=1 MakeCode = 2   //CA  
					    }Else {
						    Set MakeCode = 5   //HA重复 
						    Set:InfType'=1 MakeCode = 6   //CA重复
					    }
				  		Set tResultID=""
						For {
							Set tResultID=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"RepResult",tActDate,tResultID))
							Quit:tResultID=""
							Set flg=##class(DHCHAI.DP.LabVisitRepResult).UpdateInfType(tResultID,MakeCode,0)
							Continue:(+flg)<1
						}				  
					}
		    	} 	   
			}ElseIf (arrResult2=arrResult3) {   //仅有排除数据
				Set FirstActDate=""
		  	 	Set tActDate=0
				For {
					Set tActDate=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"RepResult",tActDate))
					Quit:tActDate=""		
					Set:FirstActDate="" FirstActDate=tActDate   //第一次送检日期 排除时第一条送检为定植，之后为定植重复（不分多次排除情况）
					If (FirstActDate=tActDate) { 
					     Set MakeCode = 3   //定植
				    } Else {
					    Set MakeCode = 7   //定植重复
				    }
			  		Set tResultID=""
					For {
						Set tResultID=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"RepResult",tActDate,tResultID))
						Quit:tResultID=""
						Set flg=##class(DHCHAI.DP.LabVisitRepResult).UpdateInfType(tResultID,MakeCode,0)
						Continue:(+flg)<1
					}
				}	
			}Else {  //同时有确诊、排除数据
				Set FirstActDate="",NextActDate="",NextDate=""
		    	For tind=1:1:$l(arrResult3,"^") {
			    	Set arrResult=$p(arrResult3,"^",tind)
			    	Continue:arrResult=""
			    	Set Status  =$p(arrResult,",",1)
			    	Set RstDate =$p(arrResult,",",2)
			    	Set InfDate =$p(arrResult,",",3)
		  			Set InfType =$p(arrResult,",",4)
			    	If tind>1 {
				    	 Set:Status=1 NextDate = InfDate
				    	 Set:Status=2 NextDate = RstDate
				    	 Set NextActDate=""
			    	}
			   
			    	Set tActDate=0
					For {
						Set tActDate=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"RepResult",tActDate))
						Quit:tActDate=""
						Continue:(tind>1)&&(tActDate<NextDate)	//多次确诊排除时，从第二次确诊排除后，不再查找感染日期之前的送检
						Set:FirstActDate="" FirstActDate=tActDate   //第一次送检日期 确诊排除时第一条送检为HA/CA/定植，之后为HA/CA/定植重复
						Set:(NextDate'="")&&(NextActDate="") NextActDate=tActDate
						
						If (FirstActDate=tActDate)||(tActDate=NextActDate) { //存在确诊感染日期早于送检日期情况，故不比较两者日期大小
						     If (Status=1) {
						     	Set MakeCode = 1   //HA 
						     	Set:InfType'=1 MakeCode = 2   //CA
						     }Else {  //排除
						     	Set MakeCode = 3   //定植
						     }  
					    }Else {
						    If (Status=1) {
						   		Set MakeCode = 5   //HA重复 
						    	Set:InfType'=1 MakeCode = 6   //CA重复
						    }Else {
							    Set MakeCode = 7   //定植重复
						    }
					    }
				  		Set tResultID=""
						For {
							Set tResultID=$o(^TMP($zn,$j,"AutoTask9",tEpisodeID,tBacteria,"RepResult",tActDate,tResultID))
							Quit:tResultID=""
							Set flg=##class(DHCHAI.DP.LabVisitRepResult).UpdateInfType(tResultID,MakeCode,0)
							Continue:(+flg)<1
						}				  
					}
		    	} 
			}
		}		
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	K ^TMP($zn,$j,"AutoTask9")	
	Quit "OK"
}

/// 按照出院日期同步病案首页、编目数据
/// 需先维护出院诊断数语集
/// w ##class(DHCHAI.Task.TaskManager).AutoTask11("2018-01-01","2018-01-31")
ClassMethod AutoTask11(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTask11("_aDateFrom_","_aDateTo_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
			Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime))
			Quit:xTime=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime,xPaadm))
				Quit:xPaadm=""
				Set EpisodeDr=xPaadm
				Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
				Continue:'$isobject(objAdm)
				Set EpisodeID = objAdm.PAEpisodeIDx
				Write "EpisodeID="_EpisodeID ,!
				
				Do ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncWMROperByDateAdm("MRS01",EpisodeID,xDate,xDate)   //编目手术
				Do ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncEMROperByDateAdm("EMR01",EpisodeID,xDate,xDate)   //首页手术
       			 //同步手麻记录并合并编目、首页手术
				Set ret=##class(DHCHAI.DI.DHS.SyncOpsInfo).SyncOperByDateAdm("OPS01",EpisodeID,xDate,xDate)
				If (+ret)<0 {
					Set ErrClass  = "DHCHAI.DI.DHS.SyncOpsInfo"
					Set ErrMethod = "SyncOperByDateAdm"
					Set ErrArgStr = $lb(ret)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeID,ErrClass,ErrMethod,ErrArgStr)
			    }
			    //需求2347109 add 20211220 无手术申请但有编目手术信息患者手术申请中插入手术编目信息
			    If ('$d(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",EpisodeID)))&&($d(^DHCHAI.DP.OROperationI("IndexEpisodeDr",EpisodeID))) {
			   		Do ##class(DHCHAI.DI.DHS.SyncOpsInfo).AddWMROperToAnaes("OPS01",EpisodeID)
			    }
                			    
			}
		}
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit "OK"
}

/// 检验信息得自动匹配对照
/// w ##class(DHCHAI.Task.TaskManager).AutoTaskLISSync()
ClassMethod AutoTaskLISSync() As %String
{
	Set return = ""
	Set Count=0
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="AutoTaskLISSync("_Date_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Set Count =##Class(DHCHAI.DPS.LabTestSetSrv).SynMapRule("检验医嘱")
	If (Count>0) {
		W "成功自动匹配"_Count_"条检验医嘱!",!
	}
	
	Set Count =##Class(DHCHAI.DPS.LabSpecSrv).SynMapRule("检验标本")
	If (Count>0) {
		W "成功自动匹配"_Count_"条检验标本!",!
	}
	
	Set Count =##Class(DHCHAI.DPS.LabBactSrv).SynMapRule("检验细菌")
	If (Count>0) {
		W "成功自动匹配"_Count_"条检验细菌!",!
	}

	Set Count =##Class(DHCHAI.DPS.LabAntiSrv).SynMapRule("检验抗生素")
	If (Count>0) {
		W "成功自动匹配"_Count_"条检验抗生素!",!
	}

	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
    Quit "OK"
}

/// 职业暴露短信
/// w ##class(DHCHAI.Task.TaskManager).OccSendMsgTask("2019-07-01","2019-09-25")
ClassMethod OccSendMsgTask(aDateFrom As %String, aDateTo As %String) As %String
{
    New (aDateFrom,aDateTo)
    Set return = ""
    Quit:(aDateFrom="")||(aDateTo="") return
    
    Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateFrom'="" aDateFrom=+aDateFrom
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
    Set:aDateFrom'="" aDateTo=+aDateTo
    Quit:(aDateFrom="")||(aDateTo="") "OK"
    
    //按就诊执行监控和筛查
    Set CurrTime = $h
    Quit:(aDateFrom>aDateTo) "OK"
    
    Set OccSendMsgFlg=##class(DHCHAI.BT.Config).GetValByCode("OccSendMsgFlg")
    Quit:OccSendMsgFlg'="1" return
    Set OccSendMsgContent=##class(DHCHAI.BT.Config).GetValByCode("OccSendMsgContent")
    Set xType="" 
    For {
        Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType))
        Quit:xType=""
        //Continue:(aRepType'="")&&(aRepType'=xType)
        
        Set xDate=""
        For {
            Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate))
            Quit:xDate=""
            Quit:xDate>aDateTo
            
            Set xID=""
            For {
                Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate,xID))
                Quit:xID="" 
            
                Set (IsRequire,LabTimList,ReqDateList,OERegDate,OccSendMsg)=""
                Set ReqInfo =##class(DHCHAI.IRS.OccExpRegSrv).CheckIsRequire(xID,aDateFrom,aDateTo)
                Set IsRequire  = $p(ReqInfo,"^",1)
                Set LabTimList = $p(ReqInfo,"^",2)
                Set ReqDateList = $p(ReqInfo,"^",3) 
                Set OERegDate=$p(ReqInfo,"^",4)
                
                Continue:IsRequire'=1
                Set strOccExpReg=$g(^DHCHAI.IR.OccExpRegD(xID))
                Continue:strOccExpReg=""
                Set OETelPhone=$li(strOccExpReg,20)
                Set OccSendMsg=$replace(OccSendMsgContent,"<text>",OERegDate)
                Set MessageInfo="",Message=""
                Set MessageInfo=OETelPhone_":"_OccSendMsg
                Set Message=##class(DHCENS.REG.BO.SendSMSMessageInfo).SendMessageInfo(OETelPhone,MessageInfo)    //短信       
                w "Message:"_MessageInfo,!
                d ##class(DHCHAI.TMP.LogTestOcc).Add(xID,Message,"##class(DHCHAI.Task.TaskManager).OccSendMsgTask()")   
            }   
        }
    }
    
    Write "按就诊执行监控和筛查用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
    
	Quit "OK"
}

/// 测试方法
/// w ##class(DHCHAI.Task.TaskManager).Test4("2019-07-01","2019-09-25")
ClassMethod Test4(aDateFrom As %String, aDateTo As %String) As %String
{
    New (aDateFrom,aDateTo)
    Set return = ""
    Quit:(aDateFrom="")||(aDateTo="") return
    
    Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateFrom'="" aDateFrom=+aDateFrom
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
    Set:aDateFrom'="" aDateTo=+aDateTo
    Quit:(aDateFrom="")||(aDateTo="") "OK"
    
    //按就诊执行监控和筛查
    Set CurrTime = $h
    Quit:(aDateFrom>aDateTo) "OK"
  
    For xDate = aDateFrom:1:aDateTo {
        Set xID=""
        For {
            Set xID=$o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xID))
            Quit:xID="" 
            
            Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xID)
            Continue:'$IsObject(objRep) 
            Set Standard     = objRep.EHStandard.BTCode
            Continue:Standard'=0
            Set objMonitorLoc   = objRep.EHMonitorLocDr
            Continue:'$IsObject(objMonitorLoc)
            Continue:'$IsObject(objMonitorLoc.BTHospDr)
            Continue:'$IsObject(objMonitorLoc.BTHospDr.BTGroupDr)
            Set tHospGrpID=objMonitorLoc.BTHospDr.BTGroupDr.%Id()
    
            Set BTLocPhone=objMonitorLoc.BTLocPhone
            Set BarCode=##class(DHCHAI.IR.EnviHyReport).GetBarCode(xID)
            //w xID_"@@@"_BarCode_"###"_BTLocPhone,!
        
            
        }
    }
    
    Write "按就诊执行监控和筛查用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
    
    Quit "OK"
}

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  更新暴发预警发送消息
/// Table：       DHCHAI.BT.SysUserManager
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.Task.TaskManager).WarnSendMsg("1|2","","2023-01-30","发热标准差|30|2^发热人数|7|3^检出同种菌|7|3^检出同种同源多耐菌|7|3^相同感染诊断|7|3^入院24H内计入|1")
ClassMethod WarnSendMsg(aHospIDs As %String = "", aLocIDs As %String = "", aWarnDate As %String, aWarnItems As %String)
{
    new (aHospIDs,aLocIDs,aWarnDate,aWarnItems)
    Set return=""
    Set (IsSendCCWarningNew,listLoc) =""
    
    Set IsSendCCWarningNew = ##class(DHCHAI.BT.Config).GetValByCode("WarningIsSendNew") // 判断启用消息提醒
    Quit:IsSendCCWarningNew'=1 return+1
    
    Set JustWarningLocs = ##class(DHCHAI.BT.Config).GetValByCode("WarningJustInLocs")   // 判断是否发送给单独科室(有值的话就发给少数几个科室)
    Set:(+JustWarningLocs>0) listLoc=$listfromString(JustInCludeWarningLoc,",")
    
    Set aMessage = ##class(DHCHAI.BT.Config).GetValByCode("WarningNewDesc")         // 消息体
    Set IsWarningTodo = ##class(DHCHAI.BT.Config).GetValByCode("WarningTodo")      // 双人确认是否发消息
    Set MsgCode = ##class(DHCHAI.BT.Config).GetValByCode("WarningNewCode")
    Set aWarnDate=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aWarnDate)
    Set:aWarnDate="" aWarnDate=+$H     
    set FromDate=aWarnDate-6
    Set ToDate=aWarnDate
    Set Is24HourFlag=0

    Set ZIndex=$zn,JIndex=$j,NIndex="WarnSendMsg"
    Kill ^TMP(ZIndex,JIndex,NIndex)
    Set flg=##class(DHCHAI.IRS.CCWarningNewSrv).QueryProcess(aWarnDate,aWarnItems,"",aLocIDs,"W")
    Quit:(+flg)<1 return+2

    //输出预警值
    Set xWarnLoc="",CSMsgDtlID="",otherInfoJson=""
    For {
        Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
        Quit:xWarnLoc=""
        
        Set xItemDesc="",flag=0,patInfo=""
        For {
            Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
            Quit:xItemDesc=""
            
            Set ArgData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnArgs",xItemDesc))
            Continue:ArgData=""
            Set FromDate=$listget(ArgData,1)
            Set ToDate=$listget(ArgData,2)
            Set WarnCnt=$listget(ArgData,3)
            Set WarnDate=$listget(ArgData,4)
            Set WarnDays=$listget(ArgData,5)
            Set:WarnCnt=0 WarnCnt =1   //默认条件不输入为1
            Set:WarnDays=0 WarnDays =7   //默认条件不输入为7
            
            If (xItemDesc="相同感染诊断") {
                Set xInfPos=""
                For {
                    Set xInfPos=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xInfPos))
                    Quit:xInfPos=""
                    
                    Set InfCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xInfPos))
                    Continue:InfCnt<WarnCnt
                    Set flag=1
                    Set patInfo1=..GetPatBaseData(xWarnLoc,xItemDesc,ZIndex,JIndex,NIndex)
                    Quit:patInfo1=""
                    Set patInfo=patInfo_patInfo1
                }           
                
            }ElseIf (xItemDesc="检出同种菌") {
                Set xBacteria=""
                For {
                    Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
                    Quit:xBacteria=""
                    
                    Set BactCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
                    Continue:BactCnt<WarnCnt
                    Set flag=1
                    Set patData=..GetPatBaseData(xWarnLoc,xItemDesc,ZIndex,JIndex,NIndex)    //这个是第一个要用的   
                    Quit:patData=""
                    Set:patInfo'="" patInfo=patInfo_"、"_patData 
                    Set:patInfo="" patInfo=patData
                  
                }               
                
            }ElseIf (xItemDesc="检出同种同源多耐菌") {
                Set xBacteria=""
                For {
                    Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
                    Quit:xBacteria=""
                    Set BactCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc,xBacteria))
                    Continue:BactCnt<WarnCnt
                    Set flag=1
                    Set patInfo2=..GetPatBaseData(xWarnLoc,xItemDesc,ZIndex,JIndex,NIndex)
                    Quit:patInfo2'="" 
                    Set:patInfo2'="" patInfo=patInfo_"、"_patInfo2
                    Set:patInfo2="" patInfo=patInfo_patInfo2
                }               
                
            }ElseIf (xItemDesc="发热人数") {
                Set FeverCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
                Continue:FeverCnt<WarnCnt
                Set flag=1
                Set patInfo3=..GetPatBaseData(xWarnLoc,xItemDesc,ZIndex,JIndex,NIndex)
                Continue:patInfo3'="" 
                Set:patInfo3'="" patInfo=patInfo_"、"_patInfo3
                Set:patInfo3="" patInfo=patInfo_patInfo3
   
            }ElseIf (xItemDesc="发热标准差") {
                Set FeStandCnt = +$g(^TMP(ZIndex,JIndex,NIndex,"WarnCnt",xWarnLoc,xItemDesc))
                Continue:(FeStandCnt=0)
                Set flag=1
                Set patInfo4=..GetPatBaseData(xWarnLoc,xItemDesc,ZIndex,JIndex,NIndex)
                Continue:patInfo4'=""
                Set:patInfo4'="" patInfo=patInfo_"、"_patInfo4
                Set:patInfo4="" patInfo=patInfo_patInfo4
   
            }Else{
            }
        }
       
        Continue:flag=0
        Continue:patInfo=""
       
        Set LinkLoc=##class(DHCHAI.Task.TaskManager).WarningGetlinkLoc(xWarnLoc)
        Continue:LinkLoc=""
        Continue:($lf(listLoc,LinkLoc)>0)
        Set Message=aMessage
        Set Message=$replace(Message,"${patient}",patInfo)
        Set LocDesc="贵科"
        Set objWarnLoc = ##class(DHCHAI.BT.Location).GetObjById(xWarnLoc)
        Continue:'$isobject(objWarnLoc)
        Set LocDesc     = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objWarnLoc.BTDesc)
        Set LocDesc2    = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objWarnLoc.BTDesc2)
        Set:LocDesc2'="" LocDesc = LocDesc2
         
        Continue:LocDesc=""
        Set Message=$replace(Message,"${Loc}","贵科下"_LocDesc)
        Set objFromUser= ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","MED")
        continue:'$IsObject(objFromUser) 
        Set FromUserID=$p(objFromUser.BTXCode,"||",2)
    
        if IsWarningTodo=1 {
            Set ToUserDr=""
            
            Set ToUserDr1=##class(DHCHAI.IRS.CCLocGroupSrv).GetUserByLocID("4",xWarnLoc)
            Set ToUserDr2=##class(DHCHAI.IRS.CCLocGroupSrv).GetUserByLocID("4",LinkLoc)

            if (ToUserDr1'="")&&(ToUserDr2'=""){
                Set User=ToUserDr1_","_ToUserDr2
                Set ToUserDr=$replace(User,",","^")
            }else{
                Set ToUserDr=ToUserDr1
            }

            Continue:ToUserDr=""
        }else{
           
            Set objToUserDr= ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","med")
            // 以科室id 挨个解析用户串,是否要考虑HISUi里没有这个用户?
            //Set objToUserDr= ##class(DHCHAI.BT.SysUser).GetObjById("3879")
            continue:'$IsObject(objToUserDr) 
            Set ToUserDr=$p(objToUserDr.BTXCode,"||",2)
        }
        
        Set otherInfoJson="{""linkParam"":""WarnLocID="_xWarnLoc_"&WarnDate="_aWarnDate_"&WarnItems="_aWarnItems_"""}"   //处理消息对应的链接
        Set:MsgCode="" MsgCode="1317"
  
        Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(Message,MsgCode,FromUserID,"",ToUserDr,otherInfoJson)  

        if (+CSMsgDtlID>0){
            d ##class(DHCHAI.TMP.LogTestMsg).Add(CSMsgDtlID,"W"_+aWarnDate_"_"_xWarnLoc,"DHCHAI.IO.FromHisSrv.SendMsg("_MsgCode_","_ToUserDr_")")
         }
          
        }
    Kill ^TMP(ZIndex,JIndex,NIndex)
    quit "OK"
}

ClassMethod GetPatBaseData(aWarnLoc, aItemDesc, ZIndex, JIndex, NIndex)
{
    new (aWarnLoc,aItemDesc,ZIndex,JIndex,NIndex)
    Set listPat=""
    Set xEpisodeDr=""
    For {
        Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",aWarnLoc,xEpisodeDr))
        Quit:xEpisodeDr=""
        Set xItemDesc="" 
  
        For {
            Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",aWarnLoc,xEpisodeDr,xItemDesc))
            Quit:xItemDesc=""
            Continue:aItemDesc'=xItemDesc
           
            Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
            Continue:PAAdmData=""
            Set RegNo=$li(PAAdmData,4)     //登记号
            Set PatName=$li(PAAdmData,6)     //姓名
            Set LocID=$li(PAAdmData,22)
            Continue:LocID=""

            Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
            Set LocDesc=$li(AdmLocData,3)
            Set LocDesc2=$li(AdmLocData,4)
            Set:LocDesc2'="" LocDesc=LocDesc2
            Set WardID=$li(PAAdmData,23)
            Continue:WardID=""
            Set AdmWardData=$g(^DHCHAI.BT.LocationD(WardID))
            Set WardDesc=$li(AdmWardData,3)
            Set WardDesc2=$li(AdmWardData,4)
            Set:WardDesc2'="" WardDesc=WardDesc2
            Set (CurrBedDr,CurrBed,AdmBedData)=""           //床位
            Set CurrBedDr=$li(PAAdmData,25)
            If CurrBedDr'=""{
                Set AdmBedData=$g(^DHCHAI.BT.PACBedD(CurrBedDr))
                If AdmBedData'=""{
                    Set CurrBed=$li(AdmBedData,3)
                }
            }

            Set:(CurrBed'="")&&(CurrBed'["床") CurrBed=CurrBed_"床"
            Set data=CurrBed_PatName_"("_RegNo_")"
            if ($lf(listPat,data)<1) {
                Set listPat=listPat_$lb(data)
                kill ^TMP(ZIndex,JIndex,NIndex,"WarnEpis",aWarnLoc,xEpisodeDr)
                Quit
            }
        }  
    }
    Set patInfo=$LISTTOSTRING(listPat,"、")
    Quit patInfo
}

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  爆发预警病区取关联科室,配置参数1,取科室关联表第一个,配置参数2取用户联系方式表首次取值
/// Table：       DHCHAI.BT.SysUserManager
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回科室id首次，失败：返回<0的代码
/// w ##class(DHCHAI.Task.TaskManager).WarningGetlinkLoc(1)
ClassMethod WarningGetlinkLoc(aWarnLoc)
{
    new (aWarnLoc)
    Set return=""
    
    Quit:aWarnLoc="" return
    
    Set WarningLocFlag = ##class(DHCHAI.BT.Config).GetValByCode("WarningLocSelect")
    if (WarningLocFlag=1){
        Set linkLocs= ##class(DHCHAI.BT.LocationLink).GetLocLinks(aWarnLoc)
       
        Set return=  $p(linkLocs,"|",1)
    }elseif (WarningLocFlag=2){
        Set UserIDs=##class(DHCHAI.BTS.LocUserManagerSrv).GetUserByLocID(aWarnLoc)
        Quit:UserIDs="" ""
        Set xLocID=$p(UserIDs,",",1)   //默认取第一个科室,多了反而没意思
        quit:'$d(^DHCHAI.BT.SysUserManagerI("IndexLocDrWardDr",xLocID)) ""
        Set xxWardID=""
        For {
            Set xxWardID=$o(^DHCHAI.BT.SysUserManagerI("IndexLocDrWardDr",xLocID,xxWardID))
            Quit:xxWardID=""
            Continue:(aWarnLoc'="")&&(aWarnLoc'=xxWardID)
            Set return=xLocID
        }
    }elseif (WarningLocFlag=3){
        
    }
    Quit return
}

}
