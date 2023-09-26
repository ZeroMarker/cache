/// 名称: DHCHAI.DI.DHS.SyncOpsInfo
/// 描述: 同步东华手麻数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncOpsInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-05
/// Description:  根据日期同步东华患者手麻信息
/// Input：       aEpisodeIDX ：就诊号
///               aDateFrom : 开始日期
/// 			  aDateTo ：结束日期
/// Return：      处理同步手麻的数量
/// w ##class(DHCHAI.DI.DHS.SyncOpsInfo).SyncOperByDateAdm("OPS01","HIS01||100","2022-01-01","2020-06-19")
ClassMethod SyncOperByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncOperByDateAdmErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="OPS" return  //手麻系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromOpsSrv:GetAnOpListForM")
  	Set sc=rs.Execute(aDateFrom,aDateTo,EpisodeID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")                  // 就诊号（DHCHAI.DP.PAAdm.ID）
		Do rowData.SetAt(rs.Data("OperID"),"OperID")             // 手术ID
		Do rowData.SetAt(rs.Data("OperICD"),"OperICD")           // 手术编码
		Do rowData.SetAt(##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(rs.Data("OperDesc"),"'"),"OperDesc")         // 手术名称
		Do rowData.SetAt(rs.Data("OperType"),"OperType")         // 手术类型
		Do rowData.SetAt(rs.Data("StartDate"),"OperDate")        // 手术日期
		Do rowData.SetAt(rs.Data("StartTime"),"StartTime")       // 手术开始时间
		Do rowData.SetAt(rs.Data("EndDate"),"EndDate")           // 手术结束日期
		Do rowData.SetAt(rs.Data("EndTime"),"EndTime")           // 手术结束时间
		Do rowData.SetAt(rs.Data("OperHour"),"OperHour")         // 手术时长
		Do rowData.SetAt(rs.Data("OperLocCode"),"OperLocCode")   // 手术科室代码
		Do rowData.SetAt(rs.Data("OperLocDesc"),"OperLocDesc")   // 手术科室 
		Do rowData.SetAt(rs.Data("OpertorCode"),"OpertorCode")   // 术者代码
		Do rowData.SetAt(rs.Data("OpertorName"),"OpertorName")   // 术者名称
		Do rowData.SetAt(rs.Data("Assistant1"),"Assistant1")     // 一助
		Do rowData.SetAt(rs.Data("Assistant2"),"Assistant2")     // 二助
		Do rowData.SetAt(rs.Data("IncisionCode"),"IncisionCode") // 切口类型代码
		Do rowData.SetAt(rs.Data("Incision"),"Incision")         // 切口类型
		Set:rs.Data("Healing")="-" rs.Data("Healing")=""
		if (rs.Data("HealingCode")=""){							  //愈合情况代码
			Do rowData.SetAt(rs.Data("Healing"),"HealingCode")
		}else{
			Do rowData.SetAt(rs.Data("HealingCode"),"HealingCode") 
		}
		Do rowData.SetAt(rs.Data("Healing"),"Healing")            // 愈合情况
		Set:rs.Data("AnesMethod")="-" rs.Data("AnesMethod")=""
		if (rs.Data("AnesMethodCode")=""){						     // 麻醉方式代码	
			Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethodCode")
		}else{
			Do rowData.SetAt(rs.Data("AnesMethodCode"),"AnesMethodCode") 
		}
		Do rowData.SetAt(rs.Data("AnesMethod"),"AnesMethod")     // 麻醉方式
		Do rowData.SetAt(rs.Data("Anesthesia"),"Anesthesia")     // 麻醉医生
		Do rowData.SetAt(rs.Data("ASAScore"),"ASAScore")         // ASA评分
		Do rowData.SetAt(rs.Data("NNISGrade"),"NNISGrade")       // NNIS分级
		Do rowData.SetAt(rs.Data("WBC"),"WBC")                   // 术前外周WBC计数
		Do rowData.SetAt(rs.Data("IncisionNum"),"IncisionNum")   // 切口个数
		Do rowData.SetAt(rs.Data("IsSightGlass"),"IsSightGlass") // 是否使用窥镜
		Do rowData.SetAt(rs.Data("IsImplants"),"IsImplants")     // 是否有植入物
		Do rowData.SetAt(rs.Data("LoseBlood"),"LoseBlood")       // 失血量
		Do rowData.SetAt(rs.Data("GotBlood"),"GotBlood")         // 输血量
		Do rowData.SetAt(rs.Data("Complication"),"Complication") // 术后并发症
		Do rowData.SetAt(rs.Data("OpStatus"),"OpaStatus")       // 手术状态
		Do rowData.SetAt(rs.Data("OPertypesoc"),"OPertypesoc")       // 手术类型手术或者操作
		Do rowData.SetAt(rs.Data("OperTypeValue"),"OperTypeValue")   // add 20211221浅层组织手术、深部组织手术、器官类别、腔隙手术
		
		//完成F、申请A、登记R
	    Set OpaStatus=rs.Data("OpStatus")
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"OperStatus",OpaStatus)
		Set:MapStatus="" MapStatus=OpaStatus
		
		//F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消
		Set IsActive=1
		Set:MapStatus="C" IsActive=0   //考虑未上手麻系统之前 手术没有完成状态
		Set:MapStatus="" IsActive=0   //科室主任未审核情况下状态为空
		Do rowData.SetAt(IsActive,"IsActive")  // 是否有效
		
		//检查手术是否有效
		Set OperDesc=rowData.GetAt("OperDesc")
		Set Num =$L(OperDesc)
		Set FnOperDesc=OperDesc
		Set:Num>50 FnOperDesc=$e(OperDesc,1,50) //截取前50个字符
		Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,FnOperDesc)
		If $IsObject(objOperDxMap) {
			Continue:objOperDxMap.BTIsActive'=1
		}
		
		//保存手麻记录
		Set OperationDr=..SaveOperInfo(rowData,aSCode)
		Continue:(+OperationDr)<1
		
		//计数
		Set Count=Count+1
    }
    
	Set return=Count
	Quit return
	
SyncOperByDateAdmErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveOperInfo(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveOperInfoErr"
	
	Set EpisodeID      = rd.GetAt("EpisodeID")
	Set EpisodeDr      = rd.GetAt("EpisodeDr")
	Set XCode          = rd.GetAt("OperID")         // 手术记录ID
	Set OperICD        = rd.GetAt("OperICD")        // 手术编码
	Set OperDesc       = rd.GetAt("OperDesc")       // 手术名称
	Set OperType       = rd.GetAt("OperType")       // 手术类型
	Set OperDate       = rd.GetAt("OperDate")       // 手术日期
	Set StartTime      = rd.GetAt("StartTime")      // 手术开始时间
	Set EndDate        = rd.GetAt("EndDate")        // 手术结束日期
	Set EndTime        = rd.GetAt("EndTime")        // 手术结束时间
	Set OperHour       = rd.GetAt("OperHour")       // 手术时长
	Set OperLocID      = ""
	Set OperLocCode    = rd.GetAt("OperLocCode")    // 手术科室代码
	Set OperLocDesc    = rd.GetAt("OperLocDesc")    // 手术科室 
	Set OpertorID      = ""
	Set OpertorCode    = rd.GetAt("OpertorCode")    // 术者代码
	Set OpertorName    = rd.GetAt("OpertorName")    // 术者名称
	Set Assistant1     = rd.GetAt("Assistant1")     // 一助
	Set Assistant2     = rd.GetAt("Assistant2")     // 二助
	Set IncisionCode   = rd.GetAt("IncisionCode")   // 切口类型代码
	Set Incision       = rd.GetAt("Incision")       // 切口类型
	Set HealingCode    = rd.GetAt("HealingCode")    // 愈合情况代码
	Set Healing        = rd.GetAt("Healing")        // 愈合情况
	Set:HealingCode["/" HealingCode=$p(HealingCode,"/",1)
	Set:Healing["/" Healing=$p(Healing,"/",2)
	Set:Healing="-" Healing=""
	Set AnesMethodCode = rd.GetAt("AnesMethodCode") // 麻醉方式代码
	Set AnesMethod     = rd.GetAt("AnesMethod")     // 麻醉方式
	Set:AnesMethod="-" AnesMethod=""
	Set Anesthesia     = rd.GetAt("Anesthesia")     // 麻醉医生
	Set ASAScore       = rd.GetAt("ASAScore")       // ASA评分
	Set NNISGrade      = rd.GetAt("NNISGrade")      // NNIS分级
	Set WBC            = rd.GetAt("WBC")            // 术前外周WBC计数
	Set IncisionNum    = rd.GetAt("IncisionNum")    // 切口个数
	Set IsSightGlass   = rd.GetAt("IsSightGlass")   // 是否使用窥镜
	Set IsImplants     = rd.GetAt("IsImplants")     // 是否有植入物
	Set LoseBlood      = rd.GetAt("LoseBlood")      // 失血量
	Set GotBlood       = rd.GetAt("GotBlood")       // 输血量
	Set Complication   = rd.GetAt("Complication")   // 术后并发症
	Set OpaStatus      = rd.GetAt("OpaStatus")      // 手术状态
	Set IsActive       = rd.GetAt("IsActive")       // 是否有效
	Set OPertypesoc    = rd.GetAt("OPertypesoc")    // 
	Set OperTypeValue  = rd.GetAt("OperTypeValue")  // add 20211221浅层组织手术、深部组织手术、器官类别、腔隙手术

	Quit:(XCode="")||(EpisodeDr="")||(OperDesc="")||(OperDate="") return
	
	/* Set OperLocDr=""
	Set objOperLoc=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,OperLocCode)
	If $IsObject(objOperLoc) {
		Set OperLocDr=objOperLoc.%Id()
	} */
	
	//手术科室取手术时间时的就诊科室
	Set OperLocDr=""
	Set OperLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,StartTime)
	If (OperLocInfo'=""){
		Set OperLocType=##class(DHCHAI.BT.Config).GetValByCode("OPSDisplayLocType")
		Set index=$CASE(OperLocType,"E":1,"W":2,:1) 			//1科室 2病区 默认1
		Set OperLocDr=$p(OperLocInfo,"^",index) //病区
	}
	// 手麻数据原始记录
	Set OperAnaesRecDr=""
	Set objOperRecord=##class(DHCHAI.DP.OROperAnaesRecord).GetObjByXCode(aSCode,XCode)
	If $isobject(objOperRecord){
		Set OperAnaesRecDr=objOperRecord.%Id()
	}
	//在下面拼接ID
	Set InputStr = "^"_EpisodeDr
	Set InputStr = InputStr_"^"_OperICD
	Set InputStr = InputStr_"^"_OperDesc
	Set InputStr = InputStr_"^"_OperType
	Set InputStr = InputStr_"^"_OperDate
	Set InputStr = InputStr_"^"_StartTime
	Set InputStr = InputStr_"^"_EndDate
	Set InputStr = InputStr_"^"_EndTime
	Set InputStr = InputStr_"^"_OperHour
	Set InputStr = InputStr_"^"_OperLocDr
	Set InputStr = InputStr_"^"_OperLocID_"|"_OperLocCode_"|"_OperLocDesc
	Set InputStr = InputStr_"^"_OpertorID_"|"_OpertorCode_"|"_OpertorName
	Set InputStr = InputStr_"^"_""_"|"_""_"|"_Assistant1
	Set InputStr = InputStr_"^"_""_"|"_""_"|"_Assistant2
	Set InputStr = InputStr_"^"_Incision
	Set InputStr = InputStr_"^"_Healing
	Set InputStr = InputStr_"^"_AnesMethod
	Set InputStr = InputStr_"^"_""_"|"_""_"|"_Anesthesia
	Set InputStr = InputStr_"^"_ASAScore
	Set InputStr = InputStr_"^"_NNISGrade
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_WBC
	Set InputStr = InputStr_"^"_IncisionNum
	Set InputStr = InputStr_"^"_IsSightGlass
	Set InputStr = InputStr_"^"_IsImplants
	Set InputStr = InputStr_"^"_LoseBlood
	Set InputStr = InputStr_"^"_GotBlood
	Set InputStr = InputStr_"^"_Complication
	Set InputStr = InputStr_"^"_IsActive  //是否有效
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_$p($h,",",2)
	Set InputStr = InputStr_"^"_OpaStatus
	Set InputStr = InputStr_"^"_OPertypesoc
	Set InputStr = InputStr_"^"_OperTypeValue
	
	Set RecInputStr = OperAnaesRecDr_InputStr
	Set OperAnaesRecDr=##class(DHCHAI.DP.OROperAnaesRecord).Update(RecInputStr,"^")
	If (+OperAnaesRecDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.OROperAnaesRecord"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(RecInputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+OperAnaesRecDr)<1 return
	Set return=OperAnaesRecDr
	Set Config=##class(DHCHAI.BT.Config).GetValByCode("OperDataSourceConfig")
	Set OperAnaesDr=""
	If (Config=1){ 		//数据源为手麻
		//存手麻数据 update 2021-04-16
		Set objOperAnaes=##class(DHCHAI.DP.OROperAnaes).GetObjByXCode(aSCode,XCode)
		If $isobject(objOperAnaes){
			Set OperAnaesDr=objOperAnaes.%Id()
		}
		Set AnaInputStr = OperAnaesDr_InputStr
		Set OpStaSynchronous=##class(DHCHAI.BT.Config).GetValByCode("OpStaSynchronous")
		Quit:OpStaSynchronous'[OpaStatus return													
		Set OperAnaesDr=##class(DHCHAI.DP.OROperAnaes).Update(AnaInputStr,"^")
		If (+OperAnaesDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.OROperAnaes"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Quit:(+OperAnaesDr)<1 return
		Set return=OperAnaesDr
	
	}
	
	If (Config=4){	//数据源为合并
			//1.存手麻数据 update 2021-04-16
		Set OperAnaesDr=""
		Set objOperAnaes=##class(DHCHAI.DP.OROperAnaes).GetObjByXCode(aSCode,XCode)
		If $isobject(objOperAnaes){
			Set OperAnaesDr=objOperAnaes.%Id()
		}
		Set AnaInputStr = OperAnaesDr_InputStr
		Set OpStaSynchronous=##class(DHCHAI.BT.Config).GetValByCode("OpStaSynchronous")
		Quit:OpStaSynchronous'[OpaStatus return													
		Set OperAnaesDr=##class(DHCHAI.DP.OROperAnaes).Update(AnaInputStr,"^")
		If (+OperAnaesDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.OROperAnaes"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Quit:(+OperAnaesDr)<1 return
		Set return=OperAnaesDr
		//2.同步合并首页、编目记录 update 2021-04-16
		Set EMRAnaesDr=""
		Set xOperID=""
		For {
			Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisAisOper",EpisodeDr," "_XCode,xOperID))
			Quit:xOperID=""
			Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
			Continue:OperData=""
			Set AnaesDr = ##class(DHCHAI.DP.OROperAnaes).OperEMRMerge(OperAnaesDr,xOperID)
			Set EMRAnaesDr = AnaesDr
		}
		If (EMRAnaesDr=""){
			Set EMRAnaesDr=##class(DHCHAI.DP.OROperAnaes).OperationMerge(EpisodeDr,OperAnaesDr,OperDate)
		}
		If (+EMRAnaesDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.OROperAnaes"
			Set ErrMethod = "OperEMRMerge"
			Set ErrArgStr = $lb(EpisodeDr_"^"_OperAnaesDr_"^"_OperDate,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//3.同步合并手术切口调查记录 update 2021-04-16
	Set OPSAnaesDr=##class(DHCHAI.DP.OROperAnaes).OperOPSMerge(EpisodeDr,OperAnaesDr)	
	If (+OperAnaesDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.OROperAnaes"
		Set ErrMethod = "OperOPSMerge"
		Set ErrArgStr = $lb(EpisodeDr_"^"_OperAnaesDr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	
	//保存手术对照（重复记录不再处理）
	If OperDesc'="" {
		//保存手术对照
		Set Num =$L(OperDesc)
		Set FnOperDesc=OperDesc
		Set:Num>50 FnOperDesc=$e(OperDesc,1,50) //截取前50个字符
		Set objOperDxMap=##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(aSCode,FnOperDesc)
		If '$isobject(objOperDxMap){
			Set MapOperDxDr=""
			Set objMapOperDx=##class(DHCHAI.DP.OROperDx).GetObjByCodeDesc("",FnOperDesc)
			Set:$IsObject(objMapOperDx) MapOperDxDr=objMapOperDx.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_FnOperDesc		// 手术名称
			Set InputStr = InputStr_"^"_MapOperDxDr		// 标准手术名称
			Set InputStr = InputStr_"^"_""				// 标准备注
			Set InputStr = InputStr_"^"_aSCode			// 子系统代码
			Set InputStr = InputStr_"^"_1				// 有效标志
			Set InputStr = InputStr_"^"_""				// 处置日期
			Set InputStr = InputStr_"^"_""				// 处置时间
			Set InputStr = InputStr_"^"_""				// 处置人
			Set OperDxMapDr=##class(DHCHAI.DP.OROperDxMap).Update(InputStr,"^")
			If (+OperDxMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.OROperDxMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	// 手术类型对照（重复记录不再处理）
	If OperType'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="OperType"  // 手术类型
		Set $p(InputStr,"^",2)=OperType
		Set $p(InputStr,"^",3)=OperType
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	//手术状态对照（重复记录不再处理）
	If OpaStatus'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="OperStatus"  //手术状态
		Set $p(InputStr,"^",2)=OpaStatus
		Set $p(InputStr,"^",3)=OpaStatus
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	//切口类型对照（重复记录不再处理）
	If Incision'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="CuteType"  //切口类型
		Set $p(InputStr,"^",2)=IncisionCode
		Set $p(InputStr,"^",3)=Incision
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//愈合情况对照（重复记录不再处理）
	If Healing'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="CuteHealing"  //愈合情况
		Set $p(InputStr,"^",2)=HealingCode
		Set $p(InputStr,"^",3)=Healing
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//麻醉方式对照（重复记录不再处理）
	If AnesMethod'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="Anesthesia"  //麻醉方式
		Set $p(InputStr,"^",2)=AnesMethodCode
		Set $p(InputStr,"^",3)=AnesMethod
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//ASA评分对照（重复记录不再处理）
	If ASAScore'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="ASAScore"  //ASA评分
		Set $p(InputStr,"^",2)=ASAScore
		Set $p(InputStr,"^",3)=ASAScore
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//NNIS分级对照（重复记录不再处理）
	If NNISGrade'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="NNISLevel"  //NNIS分级
		Set $p(InputStr,"^",2)=NNISGrade
		Set $p(InputStr,"^",3)=NNISGrade
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	Quit return
	
SaveOperInfoErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-12-20
/// Description:  插入手术编目信息到手术申请表
/// 			  aEpisodeID：就诊号
///               DHCHAI.DP.OROperation、DHCHAI.DP.OROperAnaes
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncOpsInfo).AddWMROperToAnaes("OPS01","454")
ClassMethod AddWMROperToAnaes(aSCode As %String, aEpisodeID As %String) As %String
{
	New (aSCode,aEpisodeID)
	Set return=0,Count=0
	Quit:(aSCode="")||(aEpisodeID="") return

	Set $ZT="AddWMROperToAnaesErr"
	//Quit:($d(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID)))||('$d(^DHCHAI.DP.OROperationI("IndexEpisodeDr",aEpisodeID))) return
	
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",aEpisodeID,xDate))
		Quit:xDate=""
	
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDrOperDate",aEpisodeID,xDate,xID))
			Quit:xID=""
			
			Set OperData = $g(^DHCHAI.DP.OROperationD(xID))
			Continue:OperData=""
			Set OperSource=$lg(OperData,22)
		    Set IsActive=$lg(OperData,25)
			Continue:OperSource'="F"   //只同步编目后的手术
			Continue:IsActive'=1
			
			Set OperICD    = $lg(OperData,3)
			Set OperDesc   = $lg(OperData,4)
			Set OperType   = $lg(OperData,5)
			Set OperDate   = $lg(OperData,6)
			Set SttTime    = $lg(OperData,7)
			Set EndDate    = $lg(OperData,8)
			Set EndTime    = $lg(OperData,9)
			Set OperHour   = $lg(OperData,10)
			Set OperLocDr  = $lg(OperData,11)
			Set OperLoc    = $lg(OperData,12)
			Set Opertor    = $lg(OperData,13)
			Set Assistant1 = $lg(OperData,14)
			Set Assistant2 = $lg(OperData,15)
			Set Incision   = $lg(OperData,16)
			Set Healing    = $lg(OperData,17)
			Set AnesMethod = $lg(OperData,18)
			Set Anesthesia = $lg(OperData,19)
			Set ASAScore   = $lg(OperData,20)
			Set NNISGrade  = $lg(OperData,21)
			Set SCode      = $lg(OperData,23)
			Set XCode      = SCode_":"_$lg(OperData,24)
            //手术科室取手术时间时的就诊科室
			Set OperLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,OperDate,SttTime)
			If (OperLocInfo'=""){
				Set OperLocType=##class(DHCHAI.BT.Config).GetValByCode("OPSDisplayLocType")
				Set index=$CASE(OperLocType,"E":1,"W":2,:1) 			//1科室 2病区 默认1
				Set OperLocDr=$p(OperLocInfo,"^",index) 
			}
			Set OperAnaesDr=""
			Set objOperAnaes=##class(DHCHAI.DP.OROperAnaes).GetObjByXCode(aSCode,XCode)
			If $isobject(objOperAnaes){
				Set OperAnaesDr=objOperAnaes.%Id()
			}
			Set InputStr = OperAnaesDr
			Set InputStr = InputStr_"^"_aEpisodeID
			Set InputStr = InputStr_"^"_OperICD
			Set InputStr = InputStr_"^"_OperDesc
			Set InputStr = InputStr_"^"_OperType
			Set InputStr = InputStr_"^"_OperDate
			Set InputStr = InputStr_"^"_SttTime
			Set InputStr = InputStr_"^"_EndDate
			Set InputStr = InputStr_"^"_EndTime
			Set InputStr = InputStr_"^"_OperHour
			Set InputStr = InputStr_"^"_OperLocDr
			Set InputStr = InputStr_"^"_OperLoc
			Set InputStr = InputStr_"^"_Opertor
			Set InputStr = InputStr_"^"_""_"|"_""_"|"_Assistant1
			Set InputStr = InputStr_"^"_""_"|"_""_"|"_Assistant2
			Set InputStr = InputStr_"^"_Incision
			Set InputStr = InputStr_"^"_Healing
			Set InputStr = InputStr_"^"_AnesMethod
			Set InputStr = InputStr_"^"_""_"|"_""_"|"_Anesthesia
			Set InputStr = InputStr_"^"_ASAScore
			Set InputStr = InputStr_"^"_NNISGrade
			Set InputStr = InputStr_"^"_aSCode
			Set InputStr = InputStr_"^"_XCode
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_IsActive  //是否有效
			Set InputStr = InputStr_"^"_+$h
			Set InputStr = InputStr_"^"_$p($h,",",2)
			Set InputStr = InputStr_"^"_"F"
			Set InputStr = InputStr_"^"_""
			
			Set flg=##class(DHCHAI.DP.OROperAnaes).Update(InputStr,"^")
			//计数
			If (flg>0){
				Set Count=Count+1
			}			
		}
    }
        
    Set return=Count
    Quit return
	
AddWMROperToAnaesErr
	Set return="-999^"_$ZError
	Quit return
}

}
