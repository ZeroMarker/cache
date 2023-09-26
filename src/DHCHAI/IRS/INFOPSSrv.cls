/// 名称: DHCHAI.IRS.INFOPSSrv
/// 描述: 手术切口报告相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-29
Class DHCHAI.IRS.INFOPSSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-05-10
/// Description:  打印手术切口调查表
/// Table：       DHCHAI.IR.INFOPS
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","PrintINFOPS","")
Query PrintINFOPS(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,RepStatusID:%String,RepStatus:%String,RepUserID:%String,RepUser:%String,RepDate:%String,RepTime:%String,INFOPSID:%String,PAAdmDr:%String,AnaesDR:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,AdmLocID:%String,AdmLocDesc:%String,AdmBed:%String,MRDiagnos:%String,OperName:%String,OperName2:%String,OperDxDr:%String,OperLocID:%String,OperLocDesc:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OpertorName:%String,OperHour:%String,OperTypeID:%String,OperTypeDesc:%String,AnesthID:%String,AnesthDesc:%String,NNISID:%String,NNISDesc:%String,CuteTypeID:%String,CuteTypeDesc:%String,HealID:%String,HealDesc:%String,ASAID:%String,ASADesc:%String,InfTypeID:%String,InfTypeDesc:%String,IsOperInf:%String,IsInHospInf:%String,PreoperWBC:%String,CuteNumber:%String,EndoscopeFlag:%String,ImplantFlag:%String,PreoperAntiFlag:%String,BloodLoss:%String,BloodTrans:%String,PostoperCompsListID:%String,PostoperCompsDesc:%String,UpdateDate:%String,UpdateTime:%String,UserID:%String,UserDesc:%String,PostoperComps1:%String,PostoperComps2:%String,PostoperComps3:%String,PostoperComps4:%String,PostoperComps5:%String,PostoperComps6:%String,VisitName:%String,VistDate:%String,VisitResultDesc:%String,PatTem:%String,VisitResume:%String") [ SqlProc ]
{
}

ClassMethod PrintINFOPSExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 	Quit:(aReportID="") $$$OK
 	
		Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
		Quit:'$IsObject(objReport)
		Set ReportID = objReport.%Id()
		Set RepDate  = objReport.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime = objReport.IRRepTime
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		Set (RepUserID,RepUserDesc)=""
		If $IsObject(objReport.IRRepUser) {
			Set RepUserID   = objReport.IRRepUser.%Id() 
			Set RepUserDesc = objReport.IRRepUser.BTDesc
		}
		Set (StatusID,StatusDesc)=""
		If $IsObject(objReport.IRStatusDr) {
			Set StatusID   = objReport.IRStatusDr.%Id() 
			Set StatusDesc = objReport.IRStatusDr.BTDesc
		}
		
		Set DataType="DHCHAI.IR.INFOPS"
		Set xRepExt=""
		For {
			Set xRepExt=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),aReportID,xRepExt))
			Quit:xRepExt=""
			
			Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(aReportID_"||"_xRepExt)
			Continue:'$IsObject(objRepExt)
			Set INFOPSID=objRepExt.IRObjectID
			
			Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(INFOPSID)
			Continue:'$Isobject(objOPS)
			Continue:'$Isobject(objOPS.IREpisodeDr)
			Continue:'$Isobject(objOPS.IROperDr)
		    Set AnaesDR   = objOPS.IROperDr.%Id()
			// 手术信息
			Set OperName  = objOPS.IROperName
			Set OperName2 = objOPS.IROperName2
			// 标准手术DR
			Set objOperDx = ##class(DHCHAI.DP.OROperDx).GetObjByCodeDesc("",OperName2)
			Set:$IsObject(objOperDx) OperDxDr= objOperDx.%Id()	
			If $IsObject(objOPS.IROperLocDr){
				Set OperLocID   = objOPS.IROperLocDr.%Id()
				Set OperLocDesc = objOPS.IROperLocDr.BTDesc
				Set OperLocDesc2 = objOPS.IROperLocDr.BTDesc2
				Set:OperLocDesc2'="" OperLocDesc=OperLocDesc2
				Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
			}Else{
				Set OperLocID = "",OperLocDesc = ""
			}
				
			Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(OperLocID)
			Set HospID=$p(HospInfo,"^",1)
			
			Set OperDate    = objOPS.IROperDate         // 手术日期
			Set SttTime     = objOPS.IRSttTime          // 手术开始时间
			Set AdmInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(objOPS.IREpisodeDr.%Id(),OperDate,SttTime)
			Set CurrWardID = $p(AdmInfo,"^",2)

			//Set:OperDate'="" OperDate=$zd(OperDate,3)
			Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
			Set:SttTime'="" SttTime= $zt(SttTime,2)
			Set EndDate     = objOPS.IREndDate          // 手术结束日期
			Set EndTime     = objOPS.IREndTime          // 手术结束时间
			//Set:EndDate'="" EndDate=$zd(EndDate,3)
			Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
			Set:EndTime'="" EndTime= $zt(EndTime,2)
			Set OpertorName = objOPS.IROperDocTxt       // 手术医生
			If (OpertorName="") {
				If $IsObject(objOPS.IROperDocDr){
					Set OpertorName = objOPS.IROperDocDr.BTDesc
				}
			}
			
			Set OperHour    = objOPS.IROperHours        // 手术时长
			If $IsObject(objOPS.IROperTypeDr){          // 手术类型
				Set OperTypeID   = objOPS.IROperTypeDr.%Id()
				Set OperTypeDesc = objOPS.IROperTypeDr.BTDesc
			}Else{
				Set OperTypeID = "",OperTypeDesc = ""
			}
			
			If $IsObject(objOPS.IRAnesthesiaDr){        // 麻醉方式
				Set AnesthID   = objOPS.IRAnesthesiaDr.%Id()
				Set AnesthDesc = objOPS.IRAnesthesiaDr.BTDesc
			}Else{
				Set AnesthID = "",AnesthDesc = ""
			}
			If $IsObject(objOPS.IRNNISLevelDr){         // NNIS分级
				Set NNISID   = objOPS.IRNNISLevelDr.%Id()
				Set NNISDesc = objOPS.IRNNISLevelDr.BTDesc
			}Else{
				Set NNISID = "",NNISDesc = ""
			}
			If $IsObject(objOPS.IRCuteTypeDr){          // 切口分类 
				Set CuteTypeID   = objOPS.IRCuteTypeDr.%Id()
				Set CuteTypeDesc = objOPS.IRCuteTypeDr.BTDesc
			}Else{
				Set CuteTypeID = "",CuteTypeDesc = ""
			}
			
			If $IsObject(objOPS.IRCuteHealingDr){        // 愈合情况
				Set HealID   = objOPS.IRCuteHealingDr.%Id()
				Set HealDesc = objOPS.IRCuteHealingDr.BTDesc
			}Else{
				Set HealID = "",HealDesc = ""
			}
			If $IsObject(objOPS.IRASAScore){             // ASA评分 
				Set ASAID   = objOPS.IRASAScore.%Id()
				Set ASADesc = objOPS.IRASAScore.BTDesc
			}Else{
				Set ASAID = "",ASADesc = ""
			}
			If $IsObject(objOPS.IRInfTypeDr){             // 感染部位
				Set InfTypeID   = objOPS.IRInfTypeDr.%Id()
				Set InfTypeDesc = objOPS.IRInfTypeDr.BTDesc
			}Else{
				Set InfTypeID = "",InfTypeDesc = ""
			}		
			Set IsOperInf     = objOPS.IRIsOperInf
			
			Set IsInHospInf   = objOPS.IRIsInHospInf
			Set PreoperWBC    = objOPS.IRPreoperWBC
			Set CuteNumber    = objOPS.IRCuteNumber
			Set EndoscopeFlag = objOPS.IREndoscopeFlag
			Set:EndoscopeFlag=0 EndoscopeFlag="否"
			Set:EndoscopeFlag=1 EndoscopeFlag="是"
			Set ImplantFlag   = objOPS.IRImplantFlag
			Set:ImplantFlag=0 ImplantFlag="否"
			Set:ImplantFlag=1 ImplantFlag="是"
			Set PreoperAntiFlag = objOPS.IRPreoperAntiFlag
			Set:PreoperAntiFlag=0 PreoperAntiFlag="否"
			Set:PreoperAntiFlag=1 PreoperAntiFlag="是"
			Set BloodLoss     = objOPS.IRBloodLoss
			Set BloodTrans    = objOPS.IRBloodTrans
			Set PostoperCompsListID = objOPS.IRPostoperComps
			Set PostoperCompsDesc=""
			Set (PostoperComps1,PostoperComps2,PostoperComps3,PostoperComps4,PostoperComps5,PostoperComps6)="□"
			For indx=1:1:$l(PostoperCompsListID,","){
				Set CompsID=$p(PostoperCompsListID,",",indx)
				Set CompsDesc=""	
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(CompsID)
				If $IsObject(objDic){
					Set CompsCode = objDic.BTCode
					Set CompsDesc = objDic.BTDesc
				}
				Set PostoperCompsDesc=PostoperCompsDesc_","_CompsDesc 
				
				Set:CompsDesc="引流" PostoperComps1="☑"
				Set:CompsDesc="穿孔" PostoperComps2="☑"
				Set:CompsDesc="瘘管" PostoperComps3="☑"
				Set:CompsDesc="切口裂开" PostoperComps4="☑"
				Set:CompsDesc="深静脉血栓" PostoperComps5="☑"
				Set:CompsDesc="脂肪液化" PostoperComps6="☑"
			} 
			Set:PostoperCompsDesc'="" PostoperCompsDesc = $e(PostoperCompsDesc,2,$l(PostoperCompsDesc))
			// 病人基本信息
		 	Set PAAdmDr   = objOPS.IREpisodeDr.%Id()
			Set EpisodeID   = objOPS.IREpisodeDr.PAEpisodeIDx
			Set PatientID   = objOPS.IREpisodeDr.PAPatientIDx
			Set PapmiNo     = objOPS.IREpisodeDr.PAPapmiNo
			Set MrNo        = objOPS.IREpisodeDr.PAMrNo
			Set PatName     = objOPS.IREpisodeDr.PAPatName
			Set Sex         = objOPS.IREpisodeDr.PASex
			Set Sex         = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
			Set AdmDate     = objOPS.IREpisodeDr.PAAdmDate
			Set AdmTime     = objOPS.IREpisodeDr.PAAdmTime
			Set Age         = objOPS.IREpisodeDr.PAAge
			Set DischDate   = objOPS.IREpisodeDr.PADischDate
			Set DischTime   = objOPS.IREpisodeDr.PADischTime
			Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	        Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			Set:DischTime'="" DischTime=$zt(DischTime,1)
			If $IsObject(objOPS.IREpisodeDr.PAAdmLocDr){
				Set AdmLocID   = objOPS.IREpisodeDr.PAAdmLocDr.%Id()
				Set AdmLocCode = objOPS.IREpisodeDr.PAAdmLocDr.BTCode
				Set AdmLocDesc = objOPS.IREpisodeDr.PAAdmLocDr.BTDesc
			}Else {
				Set (AdmLocID,AdmLocCode,AdmLocDesc)=""
			}
			Set AdmRoom     = objOPS.IREpisodeDr.PAAdmRoom
			Set (AdmBedDr,AdmBed)=""
			If $IsObject(objOPS.IREpisodeDr.PAAdmBedDr){
				Set AdmBedDr=objOPS.IREpisodeDr.PAAdmBedDr.%Id()
				Set AdmBed=objOPS.IREpisodeDr.PAAdmBedDr.BTDesc
			}
			Set MRDiagnos   = ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(PAAdmDr,"")
			Set UpdateDate = objOPS.IRUpdateDate    
			Set UpdateTime = objOPS.IRUpdateTime 
			Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)     
	        Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
   
			Set UserID="",UserCode="",UserDesc=""
			If $IsObject(objOPS.IRUpdateUserDr){
				Set UserID   = objOPS.IRUpdateUserDr.%Id()
				Set UserCode = objOPS.IRUpdateUserDr.BTCode
				Set UserDesc = objOPS.IRUpdateUserDr.BTDesc
			}  
			Set:IsInHospInf=0 IsInHospInf="否"
			Set:IsInHospInf=1 IsInHospInf="是"
			Set:IsOperInf=0 IsOperInf="否"
			Set:IsOperInf=1 IsOperInf="是"
			//回访信息			
			Set VisitName  = objOPS.IRVisitName   
			Set VistDate =objOPS.IRVistDate
			Set:VistDate'="" VistDate = ##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VistDate)   
			Set VisitResultDesc=""               
			Set:$IsObject(objOPS.IRVisitResultDr) VisitResultDesc = objOPS.IRVisitResultDr.BTDesc  
			Set PatTem = objOPS.IRPatTem  
			Set VisitResume = objOPS.IRVisitResume
	
			Set Data = $lb(ReportID,StatusID,StatusDesc,RepUserID,RepUserDesc,RepDate,RepTime)
            Set Data = Data_$lb(INFOPSID,PAAdmDr,AnaesDR,EpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmDate,AdmTime,DischDate,DischTime,AdmLocID,AdmLocDesc,AdmBed,MRDiagnos)
			Set Data = Data_$lb(OperName,OperName2,OperDxDr,OperLocID,OperLocDesc,OperDate,SttTime,EndDate,EndTime,OpertorName,OperHour)
			Set Data = Data_$lb(OperTypeID,OperTypeDesc,AnesthID,AnesthDesc,NNISID,NNISDesc,CuteTypeID,CuteTypeDesc,HealID,HealDesc,ASAID,ASADesc,InfTypeID,InfTypeDesc)
			Set Data = Data_$lb(IsOperInf,IsInHospInf,PreoperWBC,CuteNumber,EndoscopeFlag,ImplantFlag,PreoperAntiFlag,BloodLoss,BloodTrans,PostoperCompsListID,PostoperCompsDesc)
            Set Data = Data_$lb(UpdateDate,UpdateTime,UserID,UserDesc,PostoperComps1,PostoperComps2,PostoperComps3,PostoperComps4,PostoperComps5,PostoperComps6)
			//回访信息
			Set Data = Data_$lb(VisitName,VistDate,VisitResultDesc,PatTem,VisitResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	
	
	Quit $$$OK
}

ClassMethod PrintINFOPSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintINFOPSExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PrintINFOPSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintINFOPSExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-05
/// Description:  保存手术切口报告信息
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFOPS
/// Input：       inputStr : 手术切口报告信息
/// Return：      返回String
/// w ##Class(DHCHAI.IRS.INFOPSSrv).SaveINFOPS()
ClassMethod SaveINFOPS(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="") return
	Set:$g(aSeparete)="" aSeparete="^"
	Set $ZT="SaveINFOPSErr"
	Set InputOPSStr = $p(aInputStr,"#",1)
	Set InputRepStr = $p(aInputStr,"#",2)
	Set InputLogStr = $p(aInputStr,"#",3)
	Set aAntis      = $p(aInputStr,"#",4)
	// 保存手术切口报告信息
	Set flg=##Class(DHCHAI.IR.INFOPS).Update(InputOPSStr,"^")
	Quit:(+flg)<1 return
	Set OPSID=+flg
	
	///手术切口调查表手术信息合并到手麻记录表DHCHAI.DP.OROperAnaes
	//根据就诊号、手术日期和手术名称获取手术记录表ID合并数据
	Set EpisodeDr = $p(InputOPSStr,"^",2)
	Set AnaesDr  = $p(InputOPSStr,"^",3)
	//合并数据
	Set RetAnaesDr = ##class(DHCHAI.DP.OROperAnaes).OperINFOPSMerge(AnaesDr,OPSID)
	If ((+RetAnaesDr)<1)&&(AnaesDr'="") {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.OROperAnaes"
		Set ErrMethod = "OperINFOPSMerge"
		Set ErrArgStr = $lb(AnaesDr_"^"_OPSID,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	
	// 抗菌药物
	Set LinkAntis = "",flg=1
	For Ind = 1:1:$length(aAntis,$c(2)){
		Set AntStr = $p(aAntis,$c(2),Ind)
		Continue:AntStr=""
		Set ret = ##Class(DHCHAI.IR.INFAnti).Update(AntStr,$c(1))
		If ret<1 {
			Set flg=0
		}else{
			Set LinkAntis = LinkAntis_","_(+ret)
		}
	}
	Set:LinkAntis'="" LinkAntis = $e(LinkAntis,2,$length(LinkAntis))
	
	// 保存报告信息
	Set EpisodeDR = $p(InputRepStr,"^",2)
	Set RepType   = $p(InputRepStr,"^",3)
	Set IsInfAnti = $p(InputRepStr,"^",27) //add 20230308
	//*****************************************************
	//转换操作代码->ID
	Set StatusCode = $p(InputRepStr,aSeparete,8)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(InputRepStr,aSeparete,8)=StatusDr
	//*****************************************************
	Set INFRepInfo = ..GetOPSRepID(EpisodeDR,OPSID)
	Set INFRepID=$p(INFRepInfo,"^",1)
	Set $p(InputRepStr,"^",1)=INFRepID
	Set $p(InputRepStr,"^",12)=LinkAntis
	Set $p(InputRepStr,"^",13)=OPSID
	Set $p(InputRepStr,"^",30)=IsInfAnti
	Set flg=##Class(DHCHAI.IR.INFReport).Update(InputRepStr,"^")
	Quit:(+flg)<1 return
	Set ReportID=+flg
	
	// 保存报告日志信息
	Set $p(InputLogStr,"^",1) = ReportID
	//*****************************************************
	//转换操作代码->ID
	Set StatusCode = $p(InputLogStr,aSeparete,2)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(InputLogStr,aSeparete,2)=StatusDr
	//*****************************************************
	Set flg=##Class(DHCHAI.IR.INFRepLog).Update(InputLogStr,"^")
	Quit:(+flg)<1 return
	
	Set return=OPSID
	Quit return
	
SaveINFOPSErr
	Quit -999_"^"_$ZError
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-05
/// Description:  根据"就诊记录+报告类型+手术信息"获取报告基本信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       inputStr : 手术切口报告信息
/// Return：      返回DHCHAI.IR.INFReport.ID
/// w ##Class(DHCHAI.IRS.INFOPSSrv).GetOPSRepID()
ClassMethod GetOPSRepID(aEpisodeDr As %String, aOPSID As %String) As %String
{
	New (aEpisodeDr,aOPSID,%session)
	Set return=""
	Quit:(aEpisodeDr="")||(aOPSID="") return
	
	Set DataType=$zcvt("DHCHAI.IR.INFOPS","U")
	Set ObjectID=$zcvt(aOPSID,"U")
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_DataType," "_ObjectID,xRepID))
		Quit:xRepID=""
		Quit:return'=""
		
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.IRRepType'=4 //手术切口调查
		
		Set RepDate  = objRep.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime = objRep.IRRepTime
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		Set (RepUserID,RepUserDesc)=""
		If $IsObject(objRep.IRRepUser) {
			Set RepUserID   = objRep.IRRepUser.%Id() 
			Set RepUserDesc = objRep.IRRepUser.BTDesc
		}
		Set (StatusID,StatusDesc,StatusCode)=""
		If $IsObject(objRep.IRStatusDr) {
			Set StatusID   = objRep.IRStatusDr.%Id() 
			Set StatusCode = objRep.IRStatusDr.BTCode
			Set StatusDesc = objRep.IRStatusDr.BTDesc
		}
		Set (RepLocID,RepLocDesc) =""
		If $IsObject(objRep.IRRepLocDr) {
			Set RepLocID   = objRep.IRRepLocDr.%Id() 
			Set RepLocDesc = objRep.IRRepLocDr.BTDesc
		}
		Set IsInfAnti   =  objRep.IRIsInfAnti
		//多语言处理
		Set RepUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUserDesc,"User.SSUser")
		Set RepLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RepLocDesc,"User.CTLoc")
		Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")
		
		Set return=xRepID_"^"_RepDate_"^"_RepUserID_"^"_RepUserDesc_"^"_StatusID_"^"_StatusDesc_"^"_RepTime_"^"_StatusCode_"^"_RepLocID_"^"_RepLocDesc_"^"_IsInfAnti
	}
	Quit return
}

/// Creator：     zhaiyusheng
/// CreatDate：   2022-12-18
/// Description:  批量审核提交和取消审核状态的报告
/// Table：       DHCHAI.IR.INFReport
/// Input：       aRepIDs: 待审核报告id合集 aUpdateUser：当前审核人
/// Return：      1：success ; "": error
/// w ##Class(DHCHAI.IRS.INFOPSSrv).CheckSelected("18^37",8)
ClassMethod CheckSelected(aRepIDs As %String, aUpdateUser As %String, aStatusCode As %String) As %String
{
	New (aRepIDs,aUpdateUser,aStatusCode)
	Set return =""
	Quit:(aRepIDs="")||(aStatusCode="") return
	
	Set isError=0
	For indRep=1:1:$l(aRepIDs,"^"){
		Set RepID=$p(aRepIDs,"^",indRep)
		Continue:RepID=""
		Set aRepLog=RepID_"^"_aStatusCode_"^^"_aUpdateUser
		Set res=##class(DHCHAI.IRS.INFReportSrv).SaveINFReportStatus(aRepLog,"^")
		if res="" {
			Set isError=1
			Quit
		}
	}
	if isError=1{
			Quit return
	} 
	Set return=1
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-29
/// Description:  取报告内容
/// Table：       DHCHAI.IR.INFOPS
/// Input：       ID:    DHCHAI.IR.INFOPS.ID
/// Return：      返回String
/// w ##class(DHCHAI.IRS.INFOPSSrv).GetReportString(1)
ClassMethod GetReportString(aRepID As %String) As %String
{
	New (aRepID,%session)
	Set return=""
	Quit:aRepID="" return
	Set aSeparete = "^"
	
	Set obj=##class(DHCHAI.IR.INFOPS).GetObjById(aRepID)
	Quit:'$IsObject(obj) return

	Set return = aRepID_aSeparete                                     //1
	If $IsObject(obj.IREpisodeDr){                                    //2
		Set return = return_obj.IREpisodeDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	} 
	If $IsObject(obj.IROperDr){                                       //3
		Set return = return_obj.IROperDr.%Id()_aSeparete   	 
	}else {  
		Set return = return_""_aSeparete  
	}  
	                                
	Set return = return_##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTOperDesc",obj.IROperName,"DHCHAI.DP.OROperDx")_aSeparete                      //4
	Set OperDate=obj.IROperDate
	//Set:OperDate'="" OperDate=$zd(OperDate,3)
	Set:OperDate'="" OperDate = ##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
	Set SttTime=obj.IRSttTime
	Set:SttTime'="" SttTime=$zt(SttTime,2)
	Set OperDateTime=OperDate_" "_SttTime
	Set:OperDateTime=" " OperDateTime=""
	Set return = return_OperDateTime_aSeparete                //5
	Set EndDate=obj.IREndDate
	//Set:EndDate'="" EndDate=$zd(EndDate,3)
	Set:EndDate'="" EndDate = ##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set EndTime=obj.IREndTime
	Set:EndTime'="" EndTime=$zt(EndTime,2)
	Set EndOperDateTime=EndDate_" "_EndTime
	Set:EndOperDateTime=" " EndOperDateTime=""
	Set return = return_EndOperDateTime_aSeparete                 //6                                  //7
	Set return = return_##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",obj.IROperDocTxt,"User.SSUser")_aSeparete                    //7 	           
	Set return = return_..GetDicByObj(obj.IROperTypeDr)_aSeparete     //8 
	Set return = return_..GetDicByObj(obj.IRAnesthesiaDr)_aSeparete   //9
	Set return = return_..GetDicByObj(obj.IRNNISLevelDr)_aSeparete    //10
	Set return = return_..GetDicByObj(obj.IRCuteTypeDr)_aSeparete     //11
	Set return = return_..GetDicByObj(obj.IRCuteHealingDr)_aSeparete  //12
	Set return = return_..GetDicByObj(obj.IRASAScore)_aSeparete       //13
	Set return = return_..GetInfTypeByObj(obj.IRInfTypeDr)_aSeparete  //14
	Set return = return_obj.IRIsOperInf_aSeparete                     //15
	Set return = return_obj.IRIsInHospInf_aSeparete                   //16
	Set return = return_obj.IRPreoperWBC_aSeparete                    //17
	Set return = return_obj.IRCuteNumber_aSeparete                    //18
	Set return = return_obj.IREndoscopeFlag_aSeparete                 //19 
	Set return = return_obj.IRImplantFlag_aSeparete                   //20
	Set return = return_obj.IRPreoperAntiFlag_aSeparete               //21
	Set return = return_obj.IRBloodLoss_aSeparete                     //22
	Set return = return_obj.IRBloodTrans_aSeparete                    //23
	Set return = return_obj.IRPostoperComps_aSeparete                 //24  
	Set VistDate =obj.IRVistDate
	Set:VistDate'="" VistDate = ##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VistDate)
	
	Set return = return_obj.IRVisitName_aSeparete                     //25
	Set return = return_VistDate_aSeparete                      //26
	Set return = return_..GetDicByObj(obj.IRVisitResultDr)_aSeparete  //27
	Set return = return_obj.IRVisitResume_aSeparete                   //28  
	Set return = return_obj.IRPatTem_aSeparete                     	  //29 
	If $IsObject(obj.IROperLocDr){                                    //30
		Set return = return_obj.IROperLocDr.%Id()_aSeparete  	 
	}else {  
		Set return = return_""_aSeparete 
	}      
	
	If $IsObject(obj.IROperDr) {
		Set OperCatDrs = obj.IROperDr.OROperCatDrs
		Set OperCatList=""
		For indC=1:1:$L(OperCatDrs,",") {
			Set OperCatDr=$p(OperCatDrs,",",indC)
			Continue:OperCatDr=""
			
			Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
			Continue:'$IsObject(objCat)
			Set OperCat =objCat.BTOperCat
			If $listfind(OperCatList,OperCat)<1 {
				Set OperCatList=OperCatList_$lb(OperCat)
			}
		}
		Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
		Set return = return_OperCatLists  
	}Else {
		Set return = return_"" 
	}
	Quit return
}

ClassMethod GetDicByObj(obj As DHCHAI.BT.Dictionary) As %String
{
	new (obj,%session)
	set return=""
	quit:'$IsObject(obj) return
	//多语言处理
	//set return=obj.%Id()_","_obj.BTDesc
	Set return=obj.%Id()_","_##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",obj.BTDesc,"DHCHAI.BT.Dictionary")
	quit return
}

ClassMethod GetInfTypeByObj(obj As DHCHAI.BT.InfPos) As %String
{
	new (obj,%session)
	set return=""
	quit:'$IsObject(obj) return
	//多语言处理
	//set return=obj.%Id()_","_obj.BTDesc
	set return=obj.%Id()_","_##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",obj.BTDesc,"DHCHAI.BT.InfPos")
	quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-29
/// Description:  查询手术切口报告情况  前台界面手术科室为入参
/// Table：       DHCHAI.IR.INFOPS
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryINFOPS","2021-03-01","2021-11-06","","","","","","0","0","")
Query QryINFOPS(aDateFrom As %String, aDateTo As %String, aOperLocDr As %String, aIncisionDr As %String, aOperTypeDr As %String, aInfPosDr As %String, aOperDesc As %String, aOperHours As %String, aHospInfFlag As %String, aCutInfFlag As %String, aHospID As %String = "", aVisitRstDr As %String = "", aDateType As %String = "2", aOperCat As %String = "", aHealDesc As %String = "", aSurvStatus As %String = "") As %Query(ROWSPEC = "ReportID:%String,RepStatusID:%String,RepStatus:%String,RepUserID:%String,RepUser:%String,RepDate:%String,RepTime:%String,INFOPSID:%String,PAAdmDr:%String,AnaesDR:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,AdmLocID:%String,AdmLocDesc:%String,AdmBed:%String,MRDiagnos:%String,OperName:%String,OperName2:%String,OperDxDr:%String,OperLocID:%String,OperLocDesc:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OpertorName:%String,OperHour:%String,OperTypeID:%String,OperTypeDesc:%String,AnesthID:%String,AnesthDesc:%String,NNISID:%String,NNISDesc:%String,CuteTypeID:%String,CuteTypeDesc:%String,HealID:%String,HealDesc:%String,ASAID:%String,ASADesc:%String,InfTypeID:%String,InfTypeDesc:%String,IsOperInf:%String,IsInHospInf:%String,PreoperWBC:%String,CuteNumber:%String,EndoscopeFlag:%String,ImplantFlag:%String,PreoperAntiFlag:%String,BloodLoss:%String,BloodTrans:%String,PostoperCompsListID:%String,PostoperCompsDesc:%String,UpdateDate:%String,UpdateTime:%String,UserID:%String,UserDesc:%String,VisitName:%String,VistDate:%String,VisitRstDr:%String,VisitRstDesc:%String,VisitResume:%String,OperCatDrs:%String,OperCatLists:%String,PAAdmDoc:%String,IRPatTem:%String,RepStatusCode:%String") [ SqlProc ]
{
}

ClassMethod QryINFOPSExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aOperLocDr As %String, aIncisionDr As %String, aOperTypeDr As %String, aInfPosDr As %String, aOperDesc As %String, aOperHours As %String, aHospInfFlag As %String, aCutInfFlag As %String, aHospID As %String = "", aVisitRstDr As %String = "", aDateType As %String = "2", aOperCat As %String = "", aHealDesc As %String = "", aSurvStatus As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="")||(aDateFrom>aDateTo) $$$OK

  	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospID,"|")
	If (aDateType =1) {  //手术日期
		For xOperDate=aDateFrom:1:aDateTo {	 					
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.INFOPSI("IndexOperDate",xOperDate,xID))
				Quit:xID=""
				Do BuildINFOPSInfo(xID)
			}
 		}
 	
 	}ElseIf (aDateType =2) {  //手术切口调查登记报告日期
 		For xRepDate=aDateFrom:1:aDateTo {
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate","4",xRepDate,xRepID))
				Quit:xRepID=""
				
				Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Set EpisodeID = objReport.IREpisodeDr.%Id()
               
				Set DataType="DHCHAI.IR.INFOPS"
				Set xRepExt=""
				For {
					Set xRepExt=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),xRepID,xRepExt))
					Quit:xRepExt=""
					
					Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepExt)
					Continue:'$IsObject(objRepExt)
					Set INFOPSID=objRepExt.IRObjectID
					
					Do BuildINFOPSInfo(INFOPSID)
				}      
			}
 		}
 	}ElseIf (aDateType =3) {  //手术切口调查登记回访日期
 		For xVistDate=aDateFrom:1:aDateTo {		 		
			Set xOperDr=""
			For {
				Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr))
				Quit:xOperDr=""
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr,xID))
					Quit:xID=""
					
					Do BuildINFOPSInfo(xID)
				}
			}
 		}
 		
 	}ElseIf (aDateType =4) {  //患者入院日期
 		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xEpisodeID))
						Quit:xEpisodeID=""
						
						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildINFOPSInfo(xID)
							}  
						}                         
					}
				}
			}
		} 	

 	}ElseIf (aDateType =5) {  //患者出院日期
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xEpisodeID))
						Quit:xEpisodeID=""

						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildINFOPSInfo(xID)
							}  
						}                                
					}
				}
			}
		}
 	}
  	Quit $$$OK
BuildINFOPSInfo(INFOPSID)
  
	Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(INFOPSID)
	Quit:'$Isobject(objOPS)
	Quit:'$Isobject(objOPS.IREpisodeDr)
	Quit:'$Isobject(objOPS.IROperDr)
	Set EpisodeDr = objOPS.IREpisodeDr.%Id()
    Set AnaesDR   = objOPS.IROperDr.%Id()
    //add 20210926 增加手术分类条件过滤
   	Set OperCatDrs = objOPS.IROperDr.OROperCatDrs
	Set IsFlag=0
	For xInd=1:1:$l(aOperCat,",") {
		Set OperCat=$p(aOperCat,",",xInd)
		
		Set:(OperCat'="")&&((","_OperCatDrs_",")[(","_OperCat_",")) IsFlag=1
		Quit:IsFlag=1
	}
	Quit:(aOperCat'="")&&(IsFlag=0)
	
	
	Set OperCatList=""
	For indC=1:1:$L(OperCatDrs,",") {
		Set OperCatDr=$p(OperCatDrs,",",indC)
		Continue:OperCatDr=""
		
		Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
		Continue:'$IsObject(objCat)
		Set OperCat =objCat.BTOperCat
		If $listfind(OperCatList,OperCat)<1 {
			Set OperCatList=OperCatList_$lb(OperCat)
		}
	}	
	Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")

	Set RepInfo  = ##Class(DHCHAI.IRS.INFOPSSrv).GetOPSRepID(EpisodeDr,INFOPSID)
	Quit:RepInfo=""	
	Set ReportID    = $p(RepInfo,"^",1)
	Set RepDate     = $p(RepInfo,"^",2)
	Set RepTime     = $p(RepInfo,"^",7)
	Set RepUserID   = $p(RepInfo,"^",3)
	Set RepUserDesc = $p(RepInfo,"^",4)
	Set StatusID    = $p(RepInfo,"^",5)
	Set StatusDesc  = $p(RepInfo,"^",6)
	Set RepTime     = $p(RepInfo,"^",7)
	Set RepStatusCode=""
	Set RepStatusCode=$p(RepInfo,"^",8)
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set:RepTime'="" RepTime=$zt(RepTime,1)

	// 手术信息
	Set OperName  = objOPS.IROperName
	Quit:(aOperDesc'="")&&(OperName'[aOperDesc)
	Set OperName2 = objOPS.IROperName2
	// 标准手术DR
	Set objOperDx = ##class(DHCHAI.DP.OROperDx).GetObjByCodeDesc("",OperName2)
	Set:$IsObject(objOperDx) OperDxDr= objOperDx.%Id()	
					
	Set OperDate    = objOPS.IROperDate         // 手术日期
	Set SttTime     = objOPS.IRSttTime          // 手术开始时间
	Set AdmInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,SttTime)
	Set CurrLocID = $p(AdmInfo,"^",1)
	Set CurrWardID = $p(AdmInfo,"^",2)
	Quit:(aOperLocDr'="")&((CurrWardID'=aOperLocDr)&&(CurrLocID'=aOperLocDr))  // 过滤手术科室
	// 取手术科室，按照手术时间所在的病区科室
	Set (OperLocID,OperLocDesc)=""
	Set objCurLoc = ##class(DHCHAI.BT.Location).GetObjById(CurrWardID)
	If ($IsObject(objCurLoc)){
		Set OperLocID   = CurrWardID
		Set OperLocDesc = objCurLoc.BTDesc2
		Set:OperLocDesc="" OperLocDesc= objCurLoc.BTDesc
	}
	If (OperLocID=""){
		Set objCurLoc = ##class(DHCHAI.BT.Location).GetObjById(CurrLocID)
		If ($IsObject(objCurLoc)){
			Set OperLocID   = CurrLocID
			Set OperLocDesc = objCurLoc.BTDesc2
			Set:OperLocDesc="" OperLocDesc= objCurLoc.BTDesc
		}
	}
	Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(OperLocID)
	Set HospID=$p(HospInfo,"^",1)
	Quit:(aHospID'="")&&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤

	Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
	Set:SttTime'="" SttTime= $zt(SttTime,2)
	Set EndDate     = objOPS.IREndDate          // 手术结束日期
	Set EndTime     = objOPS.IREndTime          // 手术结束时间
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set:EndTime'="" EndTime= $zt(EndTime,2)
	Set OpertorName = objOPS.IROperDocTxt       // 手术医生
	If (OpertorName="") {
		If $IsObject(objOPS.IROperDocDr){
			Set OpertorName = objOPS.IROperDocDr.BTDesc
		}
	}
	Set OperHour    = objOPS.IROperHours        // 手术时长
	Quit:(+aOperHours'=0)&&(OperHour>aOperHours)
	If $IsObject(objOPS.IROperTypeDr){          // 手术类型
		Set OperTypeID   = objOPS.IROperTypeDr.%Id()
		Set OperTypeDesc = objOPS.IROperTypeDr.BTDesc
	}Else{
		Set OperTypeID = "",OperTypeDesc = ""
	}
	Quit:(aOperTypeDr'="")&&(aOperTypeDr'=OperTypeID)
	If $IsObject(objOPS.IRAnesthesiaDr){        // 麻醉方式
		Set AnesthID   = objOPS.IRAnesthesiaDr.%Id()
		Set AnesthDesc = objOPS.IRAnesthesiaDr.BTDesc
	}Else{
		Set AnesthID = "",AnesthDesc = ""
	}
	If $IsObject(objOPS.IRNNISLevelDr){         // NNIS分级
		Set NNISID   = objOPS.IRNNISLevelDr.%Id()
		Set NNISDesc = objOPS.IRNNISLevelDr.BTDesc
	}Else{
		Set NNISID = "",NNISDesc = ""
	}
	If $IsObject(objOPS.IRCuteTypeDr){          // 切口分类 
		Set CuteTypeID   = objOPS.IRCuteTypeDr.%Id()
		Set CuteTypeDesc = objOPS.IRCuteTypeDr.BTDesc
	}Else{
		Set CuteTypeID = "",CuteTypeDesc = ""
	}
	Quit:(aIncisionDr'="")&&(aIncisionDr'=CuteTypeID)
	If $IsObject(objOPS.IRCuteHealingDr){        // 愈合情况
		Set HealID   = objOPS.IRCuteHealingDr.%Id()
		Set HealDesc = objOPS.IRCuteHealingDr.BTDesc
	}Else{
		Set HealID = "",HealDesc = ""
	}
	if HealDesc=""{
		Quit:(aHealDesc'="")&&((","_aHealDesc_",")'[(",其他,"))  //愈合情况包含”其他“的时候,可以把愈合情况为空的筛查出来
	}else{
		Quit:(aHealDesc'="")&&((","_aHealDesc_",")'[(","_HealDesc_","))
	}
	If $IsObject(objOPS.IRASAScore){             // ASA评分 
		Set ASAID   = objOPS.IRASAScore.%Id()
		Set ASADesc = objOPS.IRASAScore.BTDesc
	}Else{
		Set ASAID = "",ASADesc = ""
	}
	If $IsObject(objOPS.IRInfTypeDr){             // 感染部位
		Set InfTypeID   = objOPS.IRInfTypeDr.%Id()
		Set InfTypeDesc = objOPS.IRInfTypeDr.BTDesc
	}Else{
		Set InfTypeID = "",InfTypeDesc = ""
	}
	Quit:(aInfPosDr'="")&&(aInfPosDr'=InfTypeID)		
	Set IsOperInf     = objOPS.IRIsOperInf
	Set objVisitRstDr  = objOPS.IRVisitResultDr 
	If $IsObject(objVisitRstDr){          // 回访结果
		Set VisitRstDr    = objVisitRstDr.%Id()
		Set VisitRstDesc  = objVisitRstDr.BTDesc
	}Else{
		Set VisitRstDr  = "",VisitRstDesc = ""
	}

	Quit:(aVisitRstDr'="")&&(aVisitRstDr'=VisitRstDr)
	Quit:(+aCutInfFlag'=0)&&(aCutInfFlag'=IsOperInf)     // 过滤手术切口感染
	Set IsInHospInf   = objOPS.IRIsInHospInf
	Quit:(aHospInfFlag'=0)&&(aHospInfFlag'=IsInHospInf) // 过滤是否医院感染
	Set PreoperWBC    = objOPS.IRPreoperWBC
	Set CuteNumber    = objOPS.IRCuteNumber
	Set EndoscopeFlag = objOPS.IREndoscopeFlag
	Set ImplantFlag   = objOPS.IRImplantFlag
	Set PreoperAntiFlag = objOPS.IRPreoperAntiFlag
	Set BloodLoss     = objOPS.IRBloodLoss
	Set BloodTrans    = objOPS.IRBloodTrans
	Set PostoperCompsListID = objOPS.IRPostoperComps
	Set PostoperCompsDesc=""
	For indx=1:1:$l(PostoperCompsListID,","){
		Set CompsID=$p(PostoperCompsListID,",",indx)
		Set CompsDesc=""	
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(CompsID)
		If $IsObject(objDic){
			Set CompsCode = objDic.BTCode
			Set CompsDesc = objDic.BTDesc
		}
		Set PostoperCompsDesc=PostoperCompsDesc_","_CompsDesc
	} 
	Set:PostoperCompsDesc'="" PostoperCompsDesc = $e(PostoperCompsDesc,2,$l(PostoperCompsDesc))

	// 病人基本信息
	Set EpisodeID   = objOPS.IREpisodeDr.PAEpisodeIDx
	Set PatientID   = objOPS.IREpisodeDr.PAPatientIDx
	Set PapmiNo     = objOPS.IREpisodeDr.PAPapmiNo
	Set MrNo        = objOPS.IREpisodeDr.PAMrNo
	Set PatName     = objOPS.IREpisodeDr.PAPatName
	Set Sex         = objOPS.IREpisodeDr.PASex
	Set Sex         = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set PAAdmDoc    = objOPS.IREpisodeDr.PAAdmDoc
	Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
	Set AdmDate     = objOPS.IREpisodeDr.PAAdmDate
	Set AdmTime     = objOPS.IREpisodeDr.PAAdmTime
	Set Age         = objOPS.IREpisodeDr.PAAge
	Set DischDate   = objOPS.IREpisodeDr.PADischDate
	Set DischTime   = objOPS.IREpisodeDr.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
    Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)
	If $IsObject(objOPS.IREpisodeDr.PAAdmLocDr){
		Set AdmLocID   = objOPS.IREpisodeDr.PAAdmLocDr.%Id()
		Set AdmLocCode = objOPS.IREpisodeDr.PAAdmLocDr.BTCode
		Set AdmLocDesc = objOPS.IREpisodeDr.PAAdmLocDr.BTDesc
	}Else {
		Set (AdmLocID,AdmLocCode,AdmLocDesc)=""
	}
	Set AdmRoom     = objOPS.IREpisodeDr.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objOPS.IREpisodeDr.PAAdmBedDr){
		Set AdmBedDr=objOPS.IREpisodeDr.PAAdmBedDr.%Id()
		Set AdmBed=objOPS.IREpisodeDr.PAAdmBedDr.BTDesc
	}
	Set MRDiagnos   = ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeDr,"")
	Set UpdateDate = objOPS.IRUpdateDate    
	Set UpdateTime = objOPS.IRUpdateTime 
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)     
    Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)

	Set UserID="",UserCode="",UserDesc=""
	If $IsObject(objOPS.IRUpdateUserDr){
		Set UserID   = objOPS.IRUpdateUserDr.%Id()
		Set UserCode = objOPS.IRUpdateUserDr.BTCode
		Set UserDesc = objOPS.IRUpdateUserDr.BTDesc
	}  
	Set VisitName      = objOPS.IRVisitName 
	Set VistDate       = objOPS.IRVistDate 
	Set IRPatTem       = objOPS.IRPatTem 
	Set:VistDate'="" VistDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VistDate)	
	Set VisitResume    = objOPS.IRVisitResume

	If ((StatusDesc="")&(aSurvStatus'="")){
		Quit:aSurvStatus'="新建"
	}
	If (aSurvStatus'=""){
		Quit:aSurvStatus'=StatusDesc
	}
	//多语言处理
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set:Age["岁" Age=$Replace(Age,"岁",##Class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))
	Set:Age["月" Age=$Replace(Age,"月",##Class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:Age["天" Age=$Replace(Age,"天",##Class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	Set PAAdmDoc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
	Set OperLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",OperLocDesc,"User.CTLoc")
	Set HealDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",HealDesc,"DHCHAI.BT.Dictionary")
	Set RepUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUserDesc,"User.SSUser")
	Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")
	Set VisitRstDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",VisitRstDesc,"DHCHAI.BT.Dictionary")
	
	Set Data = $lb(ReportID,StatusID,StatusDesc,RepUserID,RepUserDesc,RepDate,RepTime)
    Set Data = Data_$lb(INFOPSID,EpisodeDr,AnaesDR,EpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmDate,AdmTime,DischDate,DischTime,AdmLocID,AdmLocDesc,AdmBed,MRDiagnos)
	Set Data = Data_$lb(OperName,OperName2,OperDxDr,OperLocID,OperLocDesc,OperDate,SttTime,EndDate,EndTime,OpertorName,OperHour)
	Set Data = Data_$lb(OperTypeID,OperTypeDesc,AnesthID,AnesthDesc,NNISID,NNISDesc,CuteTypeID,CuteTypeDesc,HealID,HealDesc,ASAID,ASADesc,InfTypeID,InfTypeDesc)
	Set Data = Data_$lb(IsOperInf,IsInHospInf,PreoperWBC,CuteNumber,EndoscopeFlag,ImplantFlag,PreoperAntiFlag,BloodLoss,BloodTrans,PostoperCompsListID,PostoperCompsDesc)
    Set Data = Data_$lb(UpdateDate,UpdateTime,UserID,UserDesc,VisitName,VistDate,VisitRstDr,VisitRstDesc,VisitResume,OperCatDrs,OperCatLists,PAAdmDoc,IRPatTem)
	Set Data = Data_$lb(RepStatusCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryINFOPSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFOPSExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryINFOPSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFOPSExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenrui 
/// CreatDate：   2021-03-02
/// Description:  查询手术信息  
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryOperAnaesByAdm","")
Query QryOperAnaesByAdm(aEpisodeDr As %String) As %Query(ROWSPEC = "xID:%String,OperName:%String,OperType:%String,OperLocDesc:%String,OperStartDate:%String,OperEndDate:%String,OpertorName:%String,AnesthDesc:%String,ASADesc:%String,CuteTypeDesc:%String,HealDesc:%String,NNISDesc:%String,OperStatus:%String") [ SqlProc ]
{
}

ClassMethod QryOperAnaesByAdmExecute(ByRef qHandle As %Binary, aEpisodeDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aEpisodeDr="" $$$OK
	Set IROperDr=0 
	Set xID=0 
	For {
		Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		Set objInfOps=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		Continue:'$IsObject(objInfOps) 
		Set SCode      = objInfOps.ORSCode            // 子系统代码
		Set OperStatus = objInfOps.OROperStatus         // 手术状态
		Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OperStatus",OperStatus)
		Set:tOperStatus'="" OperStatus=tOperStatus
		//Continue:"ADC"[OperStatus    // 过滤手术状态   //update 20210916 与摘要中手术保持一致
		Set OpStaSynchronous=##class(DHCHAI.BT.Config).GetValByCode("OpStaSynchronous")
		Continue:OpStaSynchronous'[OperStatus 
		Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("OperStatus",OperStatus)
		If $IsObject(objStatus) {
			Set OperStatus=objStatus.BTDesc
		}
	
		Set OperName  		= objInfOps.OROperDesc				// 手术名称（手麻）
		Set OperType 		= objInfOps.OROperType				// 手术类型
		Set OperDate    	= objInfOps.OROperDate         		// 手术开始日期
		Set SttTime     	= objInfOps.ORSttTime          		// 手术开始时间
		Set OperEDate   	= objInfOps.OREndDate         		// 手术结束日期
		Set SttETime     	= objInfOps.OREndTime         		// 手术结束时间
		Set AdmInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeDr,OperDate,SttTime)
		Set CurrLocID = $p(AdmInfo,"^",1)
		Set CurrWardID = $p(AdmInfo,"^",2)
		// 取手术科室，按照手术时间所在的病区科室
		Set (OperLocID,OperLocDesc)=""
		Set objCurLoc = ##class(DHCHAI.BT.Location).GetObjById(CurrWardID)
		If ($IsObject(objCurLoc)){
			Set OperLocID   = CurrWardID
			Set OperLocDesc = objCurLoc.BTDesc2
			Set:OperLocDesc="" OperLocDesc= objCurLoc.BTDesc
		}
		If (OperLocID=""){
			Set objCurLoc = ##class(DHCHAI.BT.Location).GetObjById(CurrLocID)
			If ($IsObject(objCurLoc)){
				Set OperLocID   = CurrLocID
				Set OperLocDesc = objCurLoc.BTDesc2
				Set:OperLocDesc="" OperLocDesc= objCurLoc.BTDesc
			}
		}
		Set OpertorName     	= objInfOps.OROpertor         		// 手术医生
		Set:OpertorName'="" OpertorName=$p(OpertorName,"|",3)
		Set CuteTypeDesc     	= objInfOps.ORIncision         		// 切口分类
		//取常用短语对照中的标准字段
		Set CuteTypeinfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",CuteTypeDesc)
		If (CuteTypeinfo'="") {
			Set CuteTypeDesc=$p(CuteTypeinfo,"^",3)
		}	
		Set HealDesc 			= objInfOps.ORHealing				// 愈合情况
		Set AnesthDesc 			= objInfOps.ORAnesMethod			// 麻醉方式
		Set ASADesc 			= objInfOps.ORASAScore				// ASA
		Set NNISDesc 			= objInfOps.ORNNISGrade				// NNIS分级
		Set:OperEDate'="" OperEDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperEDate)
		Set:SttETime'="" SttETime= $zt(SttETime,2)		// 结束时间
		Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
		Set:SttTime'="" SttTime= $zt(SttTime,2)			// 开始时间
		Set OperStartDate 	= OperDate_" "_SttTime	   			// 手术开始时间
		Set OperEndDate 	= OperEDate_" "_SttETime	   		// 手术结束时间
		Set Data=$lb(xID,OperName,OperType,OperLocDesc,OperStartDate,OperEndDate,OpertorName,AnesthDesc,ASADesc,CuteTypeDesc,HealDesc,NNISDesc,OperStatus)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryOperAnaesByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperAnaesByAdmExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperAnaesByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperAnaesByAdmExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian 
/// CreatDate：   2021-05-25
/// Description:  查询手术切口调查报告情况  
/// Table：       DHCHAI.IR.INFOPS
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryINFOPSByAdm","12")
Query QryINFOPSByAdm(aEpisodeDr As %String) As %Query(ROWSPEC = "ReportID:%String,OPSID:%String,OperAnaesID:%String,OperName:%String,OperType:%String,OperStartDateTime:%String,OperEndDateTime:%String,InfPosDesc:%String,ASADesc:%String,CuteType:%String,CuteHealing:%String,NNISLevel:%String,RepDate:%String,RepTime:%String,RepUserID:%String,RepUserDesc:%String,StatusID:%String,StatusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryINFOPSByAdmExecute(ByRef qHandle As %Binary, aEpisodeDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aEpisodeDr="" $$$OK
	
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,"4",xRepID))
		Quit:xRepID=""
			
		Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.IREpisodeDr)
		
		Set ReportID = objReport.%Id()
		Set RepDate  = objReport.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime = objReport.IRRepTime
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		Set (RepUserID,RepUserDesc)=""
		If $IsObject(objReport.IRRepUser) {
			Set RepUserID   = objReport.IRRepUser.%Id() 
			Set RepUserDesc = objReport.IRRepUser.BTDesc
		}
		Set (StatusID,StatusDesc)=""
		If $IsObject(objReport.IRStatusDr) {
			Set StatusID   = objReport.IRStatusDr.%Id() 
			Set StatusDesc = objReport.IRStatusDr.BTDesc
		}

		Set DataType="DHCHAI.IR.INFOPS"
		Set xRepExt=""
		For {
			Set xRepExt=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),xRepID,xRepExt))
			Quit:xRepExt=""
				
			Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepExt)
			Continue:'$IsObject(objRepExt)
			Set INFOPSID=objRepExt.IRObjectID
			
			Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(INFOPSID)
			Continue:'$Isobject(objOPS)
			Continue:'$Isobject(objOPS.IROperDr)
		    Set AnaesDR   = objOPS.IROperDr.%Id()
		   
		   	Set OperName    =objOPS.IROperName       		   // 标准手术名称
			Set OperType    =objOPS.IROperTypeDr.BTDesc        // 手术类型
		   	Set OperDate    = objOPS.IROperDate               // 手术日期
			Set SttTime     = objOPS.IRSttTime                // 手术开始时间
			Set EndDate     = objOPS.IREndDate                // 手术日期
			Set EndTime     = objOPS.IREndTime                // 手术开始时间
			Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
			Set:SttTime'="" SttTime=$zt(SttTime,1)
			Set OperStartDateTime = OperDate_" "_SttTime
			
			Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
			Set:EndTime'="" EndTime=$zt(EndTime,1)
			Set OperEndDateTime = EndDate_" "_EndTime
			Set (NNISLevel,CuteType,CuteHealing,InfPosDesc,ASADesc)=""
						
			Set:$IsObject(objOPS.IRNNISLevelDr) NNISLevel   =objOPS.IRNNISLevelDr.BTDesc       // NNIS分级
			Set:$IsObject(objOPS.IRCuteTypeDr) CuteType    =objOPS.IRCuteTypeDr.BTDesc        // 切口类型
			Set:$IsObject(objOPS.IRCuteHealingDr) CuteHealing =objOPS.IRCuteHealingDr.BTDesc     // 愈合情况
			Set:$IsObject(objOPS.IRInfTypeDr) InfPosDesc  =objOPS.IRInfTypeDr.BTDesc         // 感染部位
			Set:$IsObject(objOPS.IRASAScore) ASADesc = objOPS.IRASAScore.BTDesc		
			//多语言处理	
			Set NNISLevel=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",NNISLevel,"DHCHAI.BT.Dictionary")
			Set CuteType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CuteType,"DHCHAI.BT.Dictionary")
			Set CuteHealing=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CuteHealing,"DHCHAI.BT.Dictionary")
			Set ASADesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ASADesc,"DHCHAI.BT.Dictionary")
			Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")
			Set OperType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",OperType,"DHCHAI.BT.Dictionary")
			Set OperName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTOperDesc",OperName,"DHCHAI.DP.OROperDx")
			Set RepUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUserDesc,"User.SSUser")
			Set Data=$lb(xRepID,INFOPSID,AnaesDR,OperName,OperType,OperStartDateTime,OperEndDateTime,InfPosDesc,ASADesc,CuteType,CuteHealing,NNISLevel,RepDate,RepTime,RepUserID,RepUserDesc,StatusID,StatusDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}

	}
	Quit $$$OK
}

ClassMethod QryINFOPSByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFOPSByAdmExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryINFOPSByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFOPSByAdmExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Input:		  aReportID,aEpisodeID,IsHist(是否查询历史信息，1-查询 0-不查询)
/// Description:  通过感染报告ID查询手术信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryINFOPSByRep","","68",1)
Query QryINFOPSByRep(aReportID As %String, aEpisodeID As %String, IsHist As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,AdmDate:%String,OperAnaesID:%String,OperName:%String,OperName2:%String,OperLocID:%String,OperLoc:%String,OperDate:%String,EndDate:%String,SttTime:%String,EndTime:%String,OperHours:%String,OperDocTxt:%String,OperDocID:%String,OperDocCode:%String,OperDoc:%String,OperTypeID:%String,OperType:%String,AnesthesiaID:%String,Anesthesia:%String,NNISLevelID:%String,NNISLevel:%String,CuteTypeID:%String,CuteType:%String,CuteHealingID:%String,CuteHealing:%String,IsOperInf:%String,InfTypeID:%String,InfType:%String,IsInHospInf:%String,ASAScoreID:%String,ASAScore:%String,PreoperWBC:%String,CuteNumber:%String,EndoscopeFlag:%String,ImplantFlag:%String,PreoperAntiFlag:%String,BloodLossFlag:%String,BloodLoss:%String,BloodTransFlag:%String,BloodTrans:%String,PostoperComps:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryINFOPSByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, IsHist As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
 	
 	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
 	If aReportID'=""{
	 	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
		Quit:'$IsObject(objRep) $$$OK
		Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
		
		Set LinkOPSs=objRep.GetRepLinkIDs("DHCHAI.IR.INFOPS")
		Quit:LinkOPSs="" $$$OK
		
		for indx = 1:1:$length(LinkOPSs,","){
			Set ID = $p(LinkOPSs,",",indx)
			Continue:ID=""
			
			Set Data = ..BuildINFOPSData(ID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
 	}Else {// 手麻数据
 		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
		Quit:(PAAdmData="")
		Set AdmDate=$lg(PAAdmData,20)
		Set DischDate=$lg(PAAdmData,26)
		Set PatientIDx=$lg(PAAdmData,3)	
 		Set EpisodeList =""
		If (IsHist=1) {
			Set xEpisodeID=""
	    	For {
		    	Set xEpisodeID=$o(^DHCHAI.DP.PAAdmI("IndexPatientIDx",PatientIDx,xEpisodeID),-1)
		    	Quit:xEpisodeID=""
		        Continue:xEpisodeID=aEpisodeID  //去除本次就诊
		        
		    	Set HPAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeID))
				Continue:(HPAAdmData="")
				Set PAAdmDate=$lg(HPAAdmData,20)
				Set PADischDate=$lg(HPAAdmData,26)
		
				Continue:(PAAdmDate>AdmDate)
				Continue:(PADischDate'="")&((AdmDate-PADischDate)>365)
		    	Set EpisodeList=EpisodeList_$lb(xEpisodeID)
	    	}
		}
		
		Set EpisodeList=$lb(aEpisodeID)_EpisodeList
 	    Set Count=0
		For indexL=1:1:$ll(EpisodeList) {
			Set xEpisodeID=$lg(EpisodeList,indexL)
			Quit:xEpisodeID=""	
		
			Set xID = ""
			For  {
		 		Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",xEpisodeID,xID))
		 		Quit:xID=""			//手术ID
		 	
		 		Set objOperAna = ##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		 		Continue:'$IsObject(objOperAna)
		 	
		 		Set IsActive 	= objOperAna.ORIsActive
				Continue:IsActive'=1
				Set OperStatus = objOperAna.OROperStatus         // 手术状态 
				Set SCode = objOperAna.ORSCode
				Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OperStatus",OperStatus)
				Set:tOperStatus'="" OperStatus=tOperStatus
				//Continue:"AC"[OperStatus    // 过滤手术状态(申请、取消)
				//Continue:ExclStatus[OperStatus //20211012 根据配置过滤手术状态
			
		 		Set INFOpsID = $o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xID,""))
		 		// 该手术有报告记录
		 		If INFOpsID'="" {
					Set Data = ..BuildINFOPSData(INFOpsID)
					Continue:Data=""
				
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				} Else {
					Set OperAnaData = ##class(DHCHAI.DPS.OROperAnaesSrv).BuildOperData(xID,"")
					Continue:OperAnaData=""
					Set AdmDate= $li($g(^DHCHAI.DP.PAAdmD(xEpisodeID)),20)
					Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
					Set OperICD 	= $lg(OperAnaData,3)
					Set OperName 	= $lg(OperAnaData,4)
					Set OperTypeID 	= $lg(OperAnaData,5)
					Set OperType 	= $lg(OperAnaData,6)
					Set OperDate 	= $lg(OperAnaData,7)
					Set SttTime 	= $lg(OperAnaData,8)
					If SttTime'="" {
						Set SttTime = $zth(SttTime)
						Set SttTime = $zt(SttTime,2)
					}
					Set EndDate 	= $lg(OperAnaData,9)
					Set EndTime 	= $lg(OperAnaData,10)
					If EndTime'="" {
						Set EndTime = $zth(EndTime)
						Set EndTime = $zt(EndTime,2)
					}
					Set OperHour 	= $lg(OperAnaData,11)
					Set OperLocID 	= $lg(OperAnaData,12)
					Set OperLoc 	= $lg(OperAnaData,13)
					Set OpertorName = $lg(OperAnaData,14)
					Set OpertorCode = $lg(OperAnaData,15)
					Set Assistant1 	= $lg(OperAnaData,16)
					Set Assistant2 	= $lg(OperAnaData,17)
					Set CuteTypeID 	= $lg(OperAnaData,18)
					Set CuteType 	= $lg(OperAnaData,19)
					Set CuteHealingID 	= $lg(OperAnaData,20)
					Set CuteHealing 	= $lg(OperAnaData,21)
					Set AnesthesiaID= $lg(OperAnaData,22)
					Set Anesthesia 	= $lg(OperAnaData,23)
					Set AnesthesiaDoc 	= $lg(OperAnaData,24)
					Set ASAScoreID 	= $lg(OperAnaData,25)
					Set ASAScore 	= $lg(OperAnaData,26)
					Set NNISLevelID = $lg(OperAnaData,27)
					Set NNISLevel 	= $lg(OperAnaData,28)
					Set PreoperWBC 	= $lg(OperAnaData,29)
					Set CuteNumber  = $lg(OperAnaData,30)
					Set EndoscopeFlag= $lg(OperAnaData,31)
					Set ImplantFlag = $lg(OperAnaData,32)
					Set BloodLoss 	= $lg(OperAnaData,33)
					Set BloodTrans 	= $lg(OperAnaData,34)
					Set PostoperComps= $lg(OperAnaData,35)
					Set OperName2 = ""
					Set OperDocTxt= OpertorName
					Set OperDoc   = OpertorName
				    Set OperDocCode = OpertorCode
					Set IsOperInf = ""
					Set InfTypeID = ""
					Set InfType = ""
					Set IsInHospInf = ""
					Set PreoperAntiFlag = ""
					Set BloodLossFlag = ""
					If BloodLoss'=""{
						Set BloodLossFlag = 1
					}
					Set BloodTransFlag = ""
					If BloodTrans'=""{
						Set BloodTransFlag = 1
					}
					//多语言翻译
					Set OperName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTOperDesc",OperName,"DHCHAI.DP.OROperDx")
					Set OperLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",OperLoc,"User.CTLoc")
					Set OperDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",OperDoc,"User.SSUser")
					Set OperDocTxt=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",OperDocTxt,"User.SSUser")
					Set OperType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",OperType,"DHCHAI.BT.Dictionary")
					Set Anesthesia=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Anesthesia,"DHCHAI.BT.Dictionary")
					Set NNISLevel=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",NNISLevel,"DHCHAI.BT.Dictionary")
					Set CuteType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CuteType,"DHCHAI.BT.Dictionary")
					Set CuteHealing=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CuteHealing,"DHCHAI.BT.Dictionary")
					Set ASAScore=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ASAScore,"DHCHAI.BT.Dictionary")
					Set Data = $lb("",xEpisodeID,AdmDate,xID,OperName,OperName2,OperLocID,OperLoc,
					OperDate,EndDate,SttTime,EndTime,OperHour,OperDocTxt,OperDocID,OperDocCode,OperDoc,
					OperTypeID,OperType,AnesthesiaID,Anesthesia,NNISLevelID,NNISLevel,
					CuteTypeID,CuteType,CuteHealingID,CuteHealing,IsOperInf,InfTypeID,
					InfType,IsInHospInf,ASAScoreID,ASAScore,PreoperWBC,CuteNumber,EndoscopeFlag,
					ImplantFlag,PreoperAntiFlag,BloodLossFlag,BloodLoss,BloodTransFlag,BloodTrans,
					PostoperComps,"","","","")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		 	}
		}
	}
	Quit $$$OK
}

ClassMethod QryINFOPSByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFOPSByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFOPSByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFOPSByRepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 取单个手术信息
ClassMethod BuildINFOPSData(aINFOPSID As %String) As %String
{
	New (aINFOPSID,%session)
	Set return=""
	Quit:aINFOPSID="" return
	
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(aINFOPSID)
	Quit:'$IsObject(objINFOPS) return
	Quit:'$IsObject(objINFOPS.IREpisodeDr) return
	
	Set EpisodeID=objINFOPS.IREpisodeDr.%Id()
	Set AdmDate = objINFOPS.IREpisodeDr.PAAdmDate
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set objOperAnaes = objINFOPS.IROperDr
	Set OperAnaesID = ""
	If $IsObject(objOperAnaes){
		Set OperAnaesID = objOperAnaes.%Id()
	}
	Set OperName = objINFOPS.IROperName
	Set OperName2 = objINFOPS.IROperName2
	Set objOperLoc = objINFOPS.IROperLocDr
	Set (OperLocID,OperLoc)=""
	If $IsObject(objOperLoc){
		Set OperLocID = objOperLoc.%Id()
		Set LocDesc2 = objOperLoc.BTDesc2
		Set LocDesc = objOperLoc.BTDesc
		Set OperLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set OperDate = objINFOPS.IROperDate
	Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
	Set EndDate = objINFOPS.IREndDate
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set SttTime = objINFOPS.IRSttTime
	Set:SttTime'="" SttTime=$zt(SttTime,2)
	Set EndTime = objINFOPS.IREndTime
	Set:EndTime'="" EndTime=$zt(EndTime,2)
	Set OperHours = objINFOPS.IROperHours
	Set OperDocTxt = objINFOPS.IROperDocTxt
	Set objOperDoc = objINFOPS.IROperDocDr
	Set (OperDocID,OperDocCode,OperDoc)=""
	If $IsObject(objOperDoc){
		Set OperDocID = objOperDoc.%Id()
		Set OperDocCode = objOperDoc.BTCode
		Set OperDoc = objOperDoc.BTDesc
	}
	Set:OperDoc="" OperDoc=OperDocTxt
	Set objOperType = objINFOPS.IROperTypeDr
	Set (OperTypeID,OperType)=""
	If $IsObject(objOperType){
		Set OperTypeID = objOperType.%Id()
		Set OperType = objOperType.BTDesc
	}
	Set objAnesthesia = objINFOPS.IRAnesthesiaDr
	Set (AnesthesiaID,Anesthesia)=""
	If $IsObject(objAnesthesia){
		Set AnesthesiaID = objAnesthesia.%Id()
		Set Anesthesia = objAnesthesia.BTDesc
	}
	Set objNNISLevel = objINFOPS.IRNNISLevelDr
	Set (NNISLevelID,NNISLevel)=""
	If $IsObject(objNNISLevel){
		Set NNISLevelID = objNNISLevel.%Id()
		Set NNISLevel = objNNISLevel.BTDesc
	}
	Set objCuteType = objINFOPS.IRCuteTypeDr
	Set (CuteTypeID,CuteType)=""
	If $IsObject(objCuteType){
		Set CuteTypeID = objCuteType.%Id()
		Set CuteType = objCuteType.BTDesc
	}
	Set objCuteHealing = objINFOPS.IRCuteHealingDr
	Set (CuteHealingID,CuteHealing)=""
	If $IsObject(objCuteHealing){
		Set CuteHealingID = objCuteHealing.%Id()
		Set CuteHealing = objCuteHealing.BTDesc
	}
	Set IsOperInf = objINFOPS.IRIsOperInf
	Set objInfType = objINFOPS.IRInfTypeDr
	Set (InfTypeID,InfType)=""
	If $IsObject(objInfType){
		Set InfTypeID = objInfType.%Id()
		Set InfType = objInfType.BTDesc
	}
	Set IsInHospInf = objINFOPS.IRIsInHospInf
	Set objASAScore = objINFOPS.IRASAScore
	Set (ASAScoreID,ASAScore)=""
	If $IsObject(objASAScore){
		Set ASAScoreID = objASAScore.%Id()
		Set ASAScore = objASAScore.BTDesc
	}
	Set PreoperWBC = objINFOPS.IRPreoperWBC
	Set CuteNumber = objINFOPS.IRCuteNumber
	Set EndoscopeFlag = objINFOPS.IREndoscopeFlag
	Set ImplantFlag = objINFOPS.IRImplantFlag
	Set PreoperAntiFlag = objINFOPS.IRPreoperAntiFlag
	Set BloodLossFlag = objINFOPS.IRBloodLossFlag
	Set BloodLoss = objINFOPS.IRBloodLoss
	Set BloodTransFlag = objINFOPS.IRBloodTransFlag
	Set BloodTrans = objINFOPS.IRBloodTrans
	Set PostoperComps = objINFOPS.IRPostoperComps
	Set UpdateDate = objINFOPS.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = objINFOPS.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = objINFOPS.IRUpdateUserDr
	//多语言翻译
	Set OperName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTOperDesc",OperName,"DHCHAI.DP.OROperDx")
	Set OperLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",OperLoc,"User.CTLoc")
	Set OperDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",OperDoc,"User.SSUser")
	Set OperDocTxt=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",OperDocTxt,"User.SSUser")
	Set OperType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",OperType,"DHCHAI.BT.Dictionary")
	Set Anesthesia=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Anesthesia,"DHCHAI.BT.Dictionary")
	Set NNISLevel=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",NNISLevel,"DHCHAI.BT.Dictionary")
	Set CuteType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CuteType,"DHCHAI.BT.Dictionary")
	Set CuteHealing=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CuteHealing,"DHCHAI.BT.Dictionary")
	Set ASAScore=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ASAScore,"DHCHAI.BT.Dictionary")
	
	Set return = $lb(aINFOPSID,EpisodeID,AdmDate,OperAnaesID,OperName,OperName2,OperLocID,OperLoc,OperDate,EndDate,SttTime,EndTime,OperHours,OperDocTxt,OperDocID,OperDocCode,OperDoc,OperTypeID,OperType,AnesthesiaID,Anesthesia,NNISLevelID,NNISLevel,CuteTypeID,CuteType,CuteHealingID,CuteHealing,IsOperInf,InfTypeID,InfType,IsInHospInf,ASAScoreID,ASAScore,PreoperWBC,CuteNumber,EndoscopeFlag,ImplantFlag,PreoperAntiFlag,BloodLossFlag,BloodLoss,BloodTransFlag,BloodTrans,PostoperComps,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
	Quit return
}

/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryOprInfo","","2020-04-04","2021-07-09","")
Query QryOprInfo(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDateType As %String = "2", aOperCat As %String = "") As %Query(ROWSPEC = "ID:%String,OperName:%String,OperType:%String,MapNNISDicDesc:%String,MapIncDicDesc:%String,CuteHealing:%String,IRIsOperInf:%String,InfPosDesc:%String,OperLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOprInfoExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aDateType As %String = "2", aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|") 
	If (aDateType =1) {  //手术日期
		For xOperDate=aDateFrom:1:aDateTo {	 			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.INFOPSI("IndexOperDate",xOperDate,xID))
				Quit:xID=""

				Do BuildOPSInfo(xID)
			}
 		}
 	
 	}ElseIf (aDateType =2) {  //手术切口调查登记报告日期
 		For xRepDate=aDateFrom:1:aDateTo {
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate","4",xRepDate,xRepID))
				Quit:xRepID=""
				
				Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Set EpisodeID = objReport.IREpisodeDr.%Id()
               
				Set DataType="DHCHAI.IR.INFOPS"
				Set xRepExt=""
				For {
					Set xRepExt=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),xRepID,xRepExt))
					Quit:xRepExt=""
					
					Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepExt)
					Continue:'$IsObject(objRepExt)
					Set INFOPSID=objRepExt.IRObjectID
					
					Do BuildOPSInfo(INFOPSID)
				}      
			}
 		}
 	}ElseIf (aDateType =3) {  //手术切口调查登记回访日期
 		For xVistDate=aDateFrom:1:aDateTo {		 		
			Set xOperDr=""
			For {
				Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr))
				Quit:xOperDr=""
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr,xID))
					Quit:xID=""
					
					Do BuildOPSInfo(xID)
				}
			}
 		}
 		
 	}ElseIf (aDateType =4) {  //患者入院日期
 		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xEpisodeID))
						Quit:xEpisodeID=""
						
						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildOPSInfo(xID)
							}  
						}                         
					}
				}
			}
		} 	

 	}ElseIf (aDateType =5) {  //患者出院日期
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xEpisodeID))
						Quit:xEpisodeID=""

						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildOPSInfo(xID)
							}  
						}                                
					}
				}
			}
		}
 	}
  	Quit $$$OK

BuildOPSInfo(OPSID)
	Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(OPSID)
	Quit:'$Isobject(objOPS)
	Quit:'$Isobject(objOPS.IREpisodeDr)
	Quit:'$Isobject(objOPS.IROperDr)
	Set EpisodeDr = objOPS.IREpisodeDr.%Id()
    Set AnaesDR   = objOPS.IROperDr.%Id()
     //add 20210926 增加手术分类条件过滤
   	Set OperCatDrs = objOPS.IROperDr.OROperCatDrs
	Quit:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
	Set OperCatList=""
	For indC=1:1:$L(OperCatDrs,",") {
		Set OperCatDr=$p(OperCatDrs,",",indC)
		Continue:OperCatDr=""
		
		Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
		Continue:'$IsObject(objCat)
		Set OperCat =objCat.BTOperCat
		If $listfind(OperCatList,OperCat)<1 {
			Set OperCatList=OperCatList_$lb(OperCat)
		}
	}	
	Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
	
	Set RepInfo  = ##Class(DHCHAI.IRS.INFOPSSrv).GetOPSRepID(EpisodeDr,OPSID)
	Quit:RepInfo="" 
	Set RepID  = $p(RepInfo,"^",1)
	Set Status = $p(RepInfo,"^",6)
	Quit:Status'="审核"

	Set OperName    =objOPS.IROperName       		   // 标准手术名称
	Set IsOperInf   =objOPS.IRIsOperInf                // 是否引起院内感染	
	Quit:'$IsObject(objOPS.IROperLocDr)
	Set OperLocDesc =objOPS.IROperLocDr.BTDesc         // 手术科室
	Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
	Set (OperType,NNISLevel,CuteType,CuteHealing,InfPosDesc)=""
	Set:$IsObject(objOPS.IROperTypeDr) OperType=objOPS.IROperTypeDr.BTDesc             // 手术类型	
	Set:$IsObject(objOPS.IRNNISLevelDr) NNISLevel=objOPS.IRNNISLevelDr.BTDesc          // NNIS分级
	Set:$IsObject(objOPS.IRCuteTypeDr) CuteType =objOPS.IRCuteTypeDr.BTDesc            // 切口类型
	Set:$IsObject(objOPS.IRCuteHealingDr) CuteHealing =objOPS.IRCuteHealingDr.BTDesc   // 愈合情况
	Set:$IsObject(objOPS.IRInfTypeDr) InfPosDesc  =objOPS.IRInfTypeDr.BTDesc           // 感染部位

	Set:NNISLevel="0级" MapNNISDicDesc=0
	Set:NNISLevel="1级" MapNNISDicDesc=1
	Set:NNISLevel="2级" MapNNISDicDesc=2
	Set:NNISLevel="3级" MapNNISDicDesc=3
	
	Set ID=RepID_"||"_OPSID
	Set Data=$lb(ID,OperName,OperType,MapNNISDicDesc,CuteType,CuteHealing,IsOperInf,InfPosDesc,OperLocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryOprInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOprInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOprInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOprInfoExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 手术切口调查统计明细
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryOprInfoDtl","","2020-05-09","2020-09-13","","2")
Query QryOprInfoDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocDesc As %String = "", aDateType As %String = "2", aOperCat As %String = "") As %Query(ROWSPEC = "ReportID:%String,StatusID:%String,StatusDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,OPSID:%String,EpisodeDr:%String,AnaesDR:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,AdmLocDesc:%String,AdmBed:%String,MRDiagnos:%String,OperName:%String,OperLocID:%String,OperLocDesc:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OpertorName:%String,OperHour:%String,OperStartDateTime:%String,OperEndDateTime:%String,OperTypec:%String,NNISLevel:%String,CuteType:%String,CuteHealing:%String,InfPosDesc:%String,ASADesc:%String,AnesthDesc:%String,InfTypeDesc:%String,IsOperInf:%String,IsInHospInf:%String,PreoperWBC:%String,CuteNumber:%String,EndoscopeFlag:%String,ImplantFlag:%String,PreoperAntiFlag:%String,BloodLoss:%String,BloodTrans:%String,PostoperCompsDesc:%String,VisitName:%String,VistDate:%String,VisitRstDesc:%String,VisitResume:%String,OperCatLists:%String") [ SqlProc ]
{
}

ClassMethod QryOprInfoDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocDesc As %String = "", aDateType As %String = "2", aOperCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	 
	If (aDateType =1) {  //手术日期
		For xOperDate=aDateFrom:1:aDateTo {	 			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.INFOPSI("IndexOperDate",xOperDate,xID))
				Quit:xID=""

				Do BuildOPSInfoDtl(xID)
			}
 		}
 	
 	}ElseIf (aDateType =2) {  //手术切口调查登记报告日期
 		For xRepDate=aDateFrom:1:aDateTo {
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate","4",xRepDate,xRepID))
				Quit:xRepID=""
				
				Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Set EpisodeID = objReport.IREpisodeDr.%Id()
               
				Set DataType="DHCHAI.IR.INFOPS"
				Set xRepExt=""
				For {
					Set xRepExt=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),xRepID,xRepExt))
					Quit:xRepExt=""
					
					Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepExt)
					Continue:'$IsObject(objRepExt)
					Set INFOPSID=objRepExt.IRObjectID
					
					Do BuildOPSInfoDtl(INFOPSID)
				}      
			}
 		}
 	}ElseIf (aDateType =3) {  //手术切口调查登记回访日期
 		For xVistDate=aDateFrom:1:aDateTo {		 		
			Set xOperDr=""
			For {
				Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr))
				Quit:xOperDr=""
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr,xID))
					Quit:xID=""
					
					Do BuildOPSInfoDtl(xID)
				}
			}
 		}
 		
 	}ElseIf (aDateType =4) {  //患者入院日期
 		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xEpisodeID))
						Quit:xEpisodeID=""
						
						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildOPSInfoDtl(xID)
							}  
						}                         
					}
				}
			}
		} 	

 	}ElseIf (aDateType =5) {  //患者出院日期
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xEpisodeID))
						Quit:xEpisodeID=""

						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildOPSInfoDtl(xID)
							}  
						}                                
					}
				}
			}
		}
 	}
  	Quit $$$OK

BuildOPSInfoDtl(OPSID)
	Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(OPSID)
	Quit:'$Isobject(objOPS)
	Quit:'$Isobject(objOPS.IREpisodeDr)
	Quit:'$Isobject(objOPS.IROperDr)
	Set EpisodeDr = objOPS.IREpisodeDr.%Id()
    Set AnaesDR   = objOPS.IROperDr.%Id()
    //add 20210926 增加手术分类条件过滤
    Set OperCatDrs = objOPS.IROperDr.OROperCatDrs
	Quit:(aOperCat'="")&&((","_OperCatDrs_",")'[(","_aOperCat_","))
	Set OperCatList=""
	For indC=1:1:$L(OperCatDrs,",") {
		Set OperCatDr=$p(OperCatDrs,",",indC)
		Continue:OperCatDr=""
		
		Set objCat =##class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr)
		Continue:'$IsObject(objCat)
		Set OperCat =objCat.BTOperCat
		If $listfind(OperCatList,OperCat)<1 {
			Set OperCatList=OperCatList_$lb(OperCat)
		}
	}	
	Set OperCatLists=##class(DHCHAI.Utils.CommonSrv).ListToString(OperCatList,",")
	Set RepInfo  = ##Class(DHCHAI.IRS.INFOPSSrv).GetOPSRepID(EpisodeDr,OPSID)
	Quit:RepInfo="" 
	Set ReportID    = $p(RepInfo,"^",1)
	Set RepDate     = $p(RepInfo,"^",2)
	Set RepTime     = $p(RepInfo,"^",7)
	Set RepUserID   = $p(RepInfo,"^",3)
	Set RepUserDesc = $p(RepInfo,"^",4)
	Set StatusID    = $p(RepInfo,"^",5)
	Set StatusDesc  = $p(RepInfo,"^",6)
	Quit:StatusDesc'="审核"
	Set RepTime     = $p(RepInfo,"^",7)
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set:RepTime'="" RepTime=$zt(RepTime,1)

   	Set OperName    = objOPS.IROperName       		   // 标准手术名称
	Quit:'$IsObject(objOPS.IROperLocDr)
	Set OperLocID = objOPS.IROperLocDr.%Id()
	Set OperLocDesc = objOPS.IROperLocDr.BTDesc         // 手术科室
	Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
	Quit:(aLocDesc'="")&&(aLocDesc'=OperLocDesc)
	Set HospID=""
	If $IsObject(objOPS.IROperLocDr.BTHospDr) {
		Set HospID = objOPS.IROperLocDr.BTHospDr.%Id()
	}		
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
	
   	Set OperDate    = objOPS.IROperDate               // 手术日期
	Set SttTime     = objOPS.IRSttTime                // 手术开始时间
	Set EndDate     = objOPS.IREndDate                // 手术日期
	Set EndTime     = objOPS.IREndTime                // 手术开始时间
	Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
	Set:SttTime'="" SttTime=$zt(SttTime,1)
	Set OperStartDateTime = OperDate_" "_SttTime
	
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set:EndTime'="" EndTime=$zt(EndTime,1)
	Set OperEndDateTime = EndDate_" "_EndTime
	Set OpertorName = objOPS.IROperDocTxt       // 手术医生
	If (OpertorName="") {
		If $IsObject(objOPS.IROperDocDr){
			Set OpertorName = objOPS.IROperDocDr.BTDesc
		}
	}
	Set OperHour    = objOPS.IROperHours        // 手术时长
	Set (OperType,NNISLevel,CuteType,CuteHealing,InfPosDesc,ASADesc,AnesthDesc,InfTypeDesc)=""
	Set:$IsObject(objOPS.IROperTypeDr) OperType = objOPS.IROperTypeDr.BTDesc       // 手术类型
	Set:$IsObject(objOPS.IRNNISLevelDr) NNISLevel   =objOPS.IRNNISLevelDr.BTDesc       // NNIS分级
	Set:$IsObject(objOPS.IRCuteTypeDr) CuteType    =objOPS.IRCuteTypeDr.BTDesc         // 切口类型
	Set:$IsObject(objOPS.IRCuteHealingDr) CuteHealing =objOPS.IRCuteHealingDr.BTDesc   // 愈合情况
	Set:$IsObject(objOPS.IRInfTypeDr) InfPosDesc  =objOPS.IRInfTypeDr.BTDesc           // 感染部位
	Set:$IsObject(objOPS.IRASAScore) ASADesc = objOPS.IRASAScore.BTDesc			       // ASA评分
	Set:$IsObject(objOPS.IRAnesthesiaDr) AnesthDesc = objOPS.IRAnesthesiaDr.BTDesc	   // 麻醉方式 
	Set:$IsObject(objOPS.IRInfTypeDr) InfTypeDesc = objOPS.IRInfTypeDr.BTDesc	       // 感染部位

	Set IsOperInf     = objOPS.IRIsOperInf				//切口感染  
	Set IsOperInf   = $s(IsOperInf="0":"否",IsOperInf="1":"是")
	Set IsInHospInf   = objOPS.IRIsInHospInf				 //是否院感 
	Set IsInHospInf   = $s(IsInHospInf="0":"否",IsInHospInf="1":"是")			
	Set PreoperWBC    = objOPS.IRPreoperWBC					//外周WBC
	Set CuteNumber    = objOPS.IRCuteNumber					//切口个数
	Set EndoscopeFlag = objOPS.IREndoscopeFlag				//使用窥镜
	Set EndoscopeFlag = $s(EndoscopeFlag="0":"否",EndoscopeFlag="1":"是")
	Set ImplantFlag   = objOPS.IRImplantFlag				//植入物
	Set ImplantFlag   = $s(ImplantFlag="0":"否",ImplantFlag="1":"是")
	Set PreoperAntiFlag = objOPS.IRPreoperAntiFlag			//术前口服抗生素
	Set PreoperAntiFlag = $s(PreoperAntiFlag="0":"否",PreoperAntiFlag="1":"是")
	Set BloodLoss     = objOPS.IRBloodLoss					//失血量
	Set BloodTrans    = objOPS.IRBloodTrans					//输血量
	Set PostoperCompsListID = objOPS.IRPostoperComps		//术后并发症
	Set PostoperCompsDesc=""
	For indx=1:1:$l(PostoperCompsListID,","){
		Set CompsID=$p(PostoperCompsListID,",",indx)
		Set CompsDesc=""	
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(CompsID)
		If $IsObject(objDic){
			Set CompsCode = objDic.BTCode
			Set CompsDesc = objDic.BTDesc
		}
		Set PostoperCompsDesc=PostoperCompsDesc_","_CompsDesc
	} 
	Set:PostoperCompsDesc'="" PostoperCompsDesc = $e(PostoperCompsDesc,2,$l(PostoperCompsDesc))

	Set VisitRstDesc = ""
	If $IsObject( objOPS.IRVisitResultDr){          // 回访结果
		Set VisitRstDesc  = objOPS.IRVisitResultDr.BTDesc
	}
	Set VisitName      = objOPS.IRVisitName 
	Set VistDate       = objOPS.IRVistDate 
	Set:VistDate'="" VistDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VistDate)
	Set VisitResume    = objOPS.IRVisitResume

	// 病人基本信息
	Set EpisodeID   = objOPS.IREpisodeDr.PAEpisodeIDx
	Set PatientID   = objOPS.IREpisodeDr.PAPatientIDx
	Set PapmiNo     = objOPS.IREpisodeDr.PAPapmiNo
	Set MrNo        = objOPS.IREpisodeDr.PAMrNo
	Set PatName     = objOPS.IREpisodeDr.PAPatName
	Set Sex         = objOPS.IREpisodeDr.PASex
	Set Sex         = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate     = objOPS.IREpisodeDr.PAAdmDate
	Set AdmTime     = objOPS.IREpisodeDr.PAAdmTime
	Set Age         = objOPS.IREpisodeDr.PAAge
	Set DischDate   = objOPS.IREpisodeDr.PADischDate
	Set DischTime   = objOPS.IREpisodeDr.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
    Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)
	If $IsObject(objOPS.IREpisodeDr.PAAdmLocDr){
		Set AdmLocID   = objOPS.IREpisodeDr.PAAdmLocDr.%Id()
		Set AdmLocCode = objOPS.IREpisodeDr.PAAdmLocDr.BTCode
		Set AdmLocDesc = objOPS.IREpisodeDr.PAAdmLocDr.BTDesc
	}Else {
		Set (AdmLocID,AdmLocCode,AdmLocDesc)=""
	}
	Set AdmRoom     = objOPS.IREpisodeDr.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objOPS.IREpisodeDr.PAAdmBedDr){
		Set AdmBedDr=objOPS.IREpisodeDr.PAAdmBedDr.%Id()
		Set AdmBed=objOPS.IREpisodeDr.PAAdmBedDr.BTDesc
	}
	Set MRDiagnos   = ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeDr,"")

	Set Data = $lb(ReportID,StatusID,StatusDesc,RepUserID,RepUserDesc,RepDate,RepTime,OPSID,EpisodeDr,AnaesDR)
    Set Data = Data_$lb(PapmiNo,MrNo,PatName,Sex,Age,AdmDate,AdmTime,DischDate,DischTime,AdmLocDesc,AdmBed,MRDiagnos)
	Set Data = Data_$lb(OperName,OperLocID,OperLocDesc,OperDate,SttTime,EndDate,EndTime,OpertorName,OperHour,OperStartDateTime,OperEndDateTime)
	Set Data = Data_$lb(OperTypec,NNISLevel,CuteType,CuteHealing,InfPosDesc,ASADesc,AnesthDesc,InfTypeDesc,IsOperInf,IsInHospInf)
	Set Data = Data_$lb(PreoperWBC,CuteNumber,EndoscopeFlag,ImplantFlag,PreoperAntiFlag,BloodLoss,BloodTrans,PostoperCompsDesc,VisitName,VistDate,VisitRstDesc,VisitResume,OperCatLists)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryOprInfoDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOprInfoDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOprInfoDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOprInfoDtlExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 取手术切口调查表中的抗菌药物信息

/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFOPSSrv","QryAntilDtl","","2020-09-09","2021-09-13","","2")
Query QryAntilDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocDesc As %String = "", aDateType As %String = "2") As %Query(ROWSPEC = "ReportID:%String,OPSID:%String,INFANTID:%String,AntiDesc:%String,SttDate:%String,EndDate:%String,DoseQty:%String,DoseUnitDesc:%String,PhcFreqDesc:%String,MedUsePurposeDesc:%String,AdminRouteDesc:%String,MedPurposeDesc:%String,TreatmentModeDesc:%String,PreMedEffectDesc:%String,PreMedIndicatDesc:%String,CombinedMedDesc:%String,PreMedTime:%String,IRPostMedDays:%String,SenAnaDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAntilDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocDesc As %String = "", aDateType As %String = "2") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|") 
	 
	If (aDateType =1) {  //手术日期
		For xOperDate=aDateFrom:1:aDateTo {	 			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.INFOPSI("IndexOperDate",xOperDate,xID))
				Quit:xID=""

				Do BuildOPSAntilDtl(xID)
			}
 		}
 	
 	}ElseIf (aDateType =2) {  //手术切口调查登记报告日期
 		For xRepDate=aDateFrom:1:aDateTo {
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate","4",xRepDate,xRepID))
				Quit:xRepID=""
				
				Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Set EpisodeID = objReport.IREpisodeDr.%Id()
               
				Set DataType="DHCHAI.IR.INFOPS"
				Set xRepExtID=""
				For {
					Set xRepExtID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),xRepID,xRepExtID))
					Quit:xRepExtID=""
					
					Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepExtID)
					Continue:'$IsObject(objRepExt)
					Set INFOPSID=objRepExt.IRObjectID
					
					Do BuildOPSAntilDtl(INFOPSID)
				}      
			}
 		}
 	}ElseIf (aDateType =3) {  //手术切口调查登记回访日期
 		For xVistDate=aDateFrom:1:aDateTo {		 		
			Set xOperDr=""
			For {
				Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr))
				Quit:xOperDr=""
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xOperDr,xID))
					Quit:xID=""
					
					Do BuildOPSAntilDtl(xID)
				}
			}
 		}
 		
 	}ElseIf (aDateType =4) {  //患者入院日期
 		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xEpisodeID))
						Quit:xEpisodeID=""
						
						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildOPSAntilDtl(xID)
							}  
						}                         
					}
				}
			}
		} 	

 	}ElseIf (aDateType =5) {  //患者出院日期
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xEpisodeID = ""
					For {
						Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xEpisodeID))
						Quit:xEpisodeID=""

						Set xOperDr=""
						For {
				 			Set xOperDr=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr))
							Quit:xOperDr=""

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",xEpisodeID,xOperDr,xID))
								Quit:xID=""
								
								Do BuildOPSAntilDtl(xID)
							}  
						}                                
					}
				}
			}
		}
 	}
  	Quit $$$OK

BuildOPSAntilDtl(OPSID)
	Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(OPSID)
	Quit:'$Isobject(objOPS)
	Quit:'$Isobject(objOPS.IREpisodeDr)
	Quit:'$Isobject(objOPS.IROperDr)
	Set EpisodeDr = objOPS.IREpisodeDr.%Id()
    Set AnaesDR   = objOPS.IROperDr.%Id()
   
	Set RepInfo  = ##Class(DHCHAI.IRS.INFOPSSrv).GetOPSRepID(EpisodeDr,OPSID)
	Quit:RepInfo="" 
	Set ReportID    = $p(RepInfo,"^",1)
	Set StatusDesc  = $p(RepInfo,"^",6)
	Quit:StatusDesc'="审核"
	
   	Set OperName    = objOPS.IROperName       		   // 标准手术名称
	Quit:'$IsObject(objOPS.IROperLocDr)
	Set OperLocID = objOPS.IROperLocDr.%Id()
	Set OperLocDesc = objOPS.IROperLocDr.BTDesc         // 手术科室
	Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
	Quit:(aLocDesc'="")&&(aLocDesc'=OperLocDesc)
	Set HospID=""
	If $IsObject(objOPS.IROperLocDr.BTHospDr) {
		Set HospID = objOPS.IROperLocDr.BTHospDr.%Id()
	}		
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
	Set DataType="DHCHAI.IR.INFAnti"
	Quit:'$d(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),ReportID))

	Set xRepExt=""
	For {
		Set xRepExt=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),ReportID,xRepExt))
		Quit:xRepExt=""
		
		Set objRepExt=##class(DHCHAI.IR.INFRepExt).GetObjById(ReportID_"||"_xRepExt)
		Continue:'$IsObject(objRepExt)
		Set INFANTID=objRepExt.IRObjectID
		
		Set objAnti = ##class(DHCHAI.IR.INFAnti).GetObjById(INFANTID)
		Continue:'$Isobject(objAnti)
		Continue:'$Isobject(objAnti.IREpisodeDr)
		Continue:'$Isobject(objAnti.IRAntiUseDr)
	    Set AntiDesc 	= objAnti.IRAntiDesc				//抗生素
	    Set SttDate		= objAnti.IRSttDate					//开始日期
		Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
	    Set EndDate		= objAnti.IREndDate					//结束日期
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set DoseQty		= objAnti.IRDoseQty					//剂量
		//Set DoseUnit	= objAnti.IRDoseUnit				//剂量单位
		If $IsObject(objAnti.IRDoseUnit){        
			Set DoseUnitID   = objAnti.IRDoseUnit.%Id()
			Set DoseUnitDesc = objAnti.IRDoseUnit.BTDesc
		}Else{
			Set DoseUnitID = "",DoseUnitDesc = ""
		}
		
		//Set PhcFreq		=objAnti.IRPhcFreq						    
		If $IsObject(objAnti.IRPhcFreq){         			//频次
			Set PhcFreqID   = objAnti.IRPhcFreq.%Id()
			Set PhcFreqDesc = objAnti.IRPhcFreq.BTDesc
		}Else{
			Set PhcFreqID = "",PhcFreqDesc = ""
		}
		//Set IRMedUsePurpose	=objAnti.IRMedUsePurpose		    					    
		If $IsObject(objAnti.IRMedUsePurpose){         					//用途
			Set MedUsePurposeID   = objAnti.IRMedUsePurpose.%Id()
			Set MedUsePurposeDesc = objAnti.IRMedUsePurpose.BTDesc
		}Else{
			Set MedUsePurposeID = "",MedUsePurposeDesc = ""
		}	
		    					    
		If $IsObject(objAnti.IRAdminRoute){         					 //给药途径
			Set AdminRouteID   = objAnti.IRAdminRoute.%Id()
			Set AdminRouteDesc = objAnti.IRAdminRoute.BTDesc
		}Else{
			Set AdminRouteID = "",AdminRouteDesc = ""
		}
		   					    
		If $IsObject(objAnti.IRMedPurpose){         					  //目的
			Set MedPurposeID   = objAnti.IRMedPurpose.%Id()
			Set MedPurposeDesc = objAnti.IRMedPurpose.BTDesc
		}Else{
			Set MedPurposeID = "",MedPurposeDesc = ""
		}						   
			  					    
		If $IsObject(objAnti.IRTreatmentMode){         					 //治疗用药方式
			Set TreatmentModeID   = objAnti.IRTreatmentMode.%Id()
			Set TreatmentModeDesc = objAnti.IRTreatmentMode.BTDesc
		}Else{
			Set TreatmentModeID = "",TreatmentModeDesc = ""
		}					  
			  					    
		If $IsObject(objAnti.IRPreMedEffect){         					  //预防用药效果
			Set PreMedEffectID   = objAnti.IRPreMedEffect.%Id()
			Set PreMedEffectDesc = objAnti.IRPreMedEffect.BTDesc
		}Else{
			Set PreMedEffectID = "",PreMedEffectDesc = ""
		}					    
			  					    
		If $IsObject(objAnti.IRPreMedIndicat){         					   //预防用药指针
			Set PreMedIndicatID   = objAnti.IRPreMedIndicat.%Id()
			Set PreMedIndicatDesc = objAnti.IRPreMedIndicat.BTDesc
		}Else{
			Set PreMedIndicatID = "",PreMedIndicatDesc = ""
		}					    
								    
		If $IsObject(objAnti.IRCombinedMed){         					    //联合用药
			Set CombinedMedID   = objAnti.IRCombinedMed.%Id()
			Set CombinedMedDesc = objAnti.IRCombinedMed.BTDesc
		}Else{
			Set CombinedMedID = "",CombinedMedDesc = ""
		}					   
								   
		Set PreMedTime	  = objAnti.IRPreMedTime						    //术前用药时间(分钟)
		Set IRPostMedDays = objAnti.IRPostMedDays						    //术后用药天数
											    
		If $IsObject(objAnti.IRSenAna){         					    //敏感度
			Set SenAnaID   = objAnti.IRSenAna.%Id()
			Set SenAnaDesc = objAnti.IRSenAna.BTDesc
		}Else{
			Set SenAnaID = "",SenAnaDesc = ""
		}		   
	    Set Data = $lb(ReportID,OPSID,INFANTID,AntiDesc,SttDate,EndDate,DoseQty,DoseUnitDesc,PhcFreqDesc,MedUsePurposeDesc,AdminRouteDesc)
        Set Data = Data_$lb(MedPurposeDesc,TreatmentModeDesc,PreMedEffectDesc,PreMedIndicatDesc,CombinedMedDesc,PreMedTime,IRPostMedDays,SenAnaDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAntilDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntilDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntilDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntilDtlExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:  保存手术切口报告回访信息
/// Table：       DHCHAI.IR.INFOPS
/// Input：       inputStr : 手术切口报告回访信息
/// Return：      返回String
/// w ##Class(DHCHAI.IRS.INFOPSSrv).SaveINFOPSFollow("3^测试^2023-04-11^1^133333333333^wge","^")
ClassMethod SaveINFOPSFollow(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="") return
	Set:$g(aSeparete)="" aSeparete="^"
	Set $ZT="SaveINFOPSFollowErr"
	Set INFOPSID 	= $p(aInputStr,"^",1)
	Set VisitName 	= $p(aInputStr,"^",2)
	Set VistDate 	= $p(aInputStr,"^",3)
	Set VisitResul  = $p(aInputStr,"^",4)
	Set VisitResume = $p(aInputStr,"^",5)
	Set PatTem 		= $p(aInputStr,"^",6)
	Set objINFOPS=$g(^DHCHAI.IR.INFOPSD(INFOPSID))
	Quit:objINFOPS=""
	
	Set InputStr=""
	Set IREpisodeDr		=$lg(objINFOPS,2)
	Set IROperDr		=$lg(objINFOPS,3)
	Set IROperName		=$lg(objINFOPS,4)
	Set IROperName2		=$lg(objINFOPS,5)
	Set IROperLocDr		=$lg(objINFOPS,6)
	Set IROperDate		=$lg(objINFOPS,7)
	Set IREndDate		=$lg(objINFOPS,8)
	Set IRSttTime		=$lg(objINFOPS,9)
	Set IREndTime		=$lg(objINFOPS,10)
	Set IROperHours		=$lg(objINFOPS,11)
	Set IROperDocTxt	=$lg(objINFOPS,12)
	Set IROperDocDr		=$lg(objINFOPS,13)
	Set IROperTypeDr	=$lg(objINFOPS,14)
	Set IRAnesthesiaDr  =$lg(objINFOPS,15)
	Set IRNNISLevelDr   =$lg(objINFOPS,16)
	Set IRCuteTypeDr	=$lg(objINFOPS,17)
	Set IRCuteHealingDr =$lg(objINFOPS,18)
	Set IRIsOperInf		=$lg(objINFOPS,19)
	Set IRInfTypeDr		=$lg(objINFOPS,20)
	Set IRIsInHospInf	=$lg(objINFOPS,21)
	Set IRASAScore		=$lg(objINFOPS,22)
	Set IRPreoperWBC	=$lg(objINFOPS,23)
	Set IRCuteNumber	=$lg(objINFOPS,24)
	Set IREndoscopeFlag =$lg(objINFOPS,25)
	Set IRImplantFlag	=$lg(objINFOPS,26)
	Set IRPreoperAntiFlag=$lg(objINFOPS,27)
	Set IRBloodLossFlag =$lg(objINFOPS,28)
	Set IRBloodLoss		=$lg(objINFOPS,29)
	Set IRBloodTransFlag=$lg(objINFOPS,30)
	Set IRBloodTrans	=$lg(objINFOPS,31)
	Set IRPostoperComps =$lg(objINFOPS,32)
	Set IRUpdateDate	=$lg(objINFOPS,33)
	Set IRUpdateTime	=$lg(objINFOPS,34)
	Set IRUpdateUserDr  =$lg(objINFOPS,35)
	Set InputStr=INFOPSID_"^"_IREpisodeDr_"^"_IROperDr_"^"_IROperLocDr_"^"_IROperName_"^"_IROperName2_"^"_IROperDate_"^"_IREndDate
	_"^"_IRSttTime_"^"_IREndTime_"^"_IROperHours_"^"_IROperDocTxt_"^"_IROperDocDr_"^"_IROperTypeDr_"^"_IRAnesthesiaDr_"^"_IRNNISLevelDr
	_"^"_IRCuteTypeDr_"^"_IRCuteHealingDr_"^"_IRIsOperInf_"^"_IRInfTypeDr_"^"_IRIsInHospInf_"^"_IRASAScore_"^"_IRPreoperWBC_"^"_IRCuteNumber
	_"^"_IREndoscopeFlag_"^"_IRImplantFlag_"^"_IRPreoperAntiFlag_"^"_IRBloodLoss_"^"_IRBloodTrans_"^"_IRPostoperComps
	_"^"_IRUpdateDate_"^"_IRUpdateTime_"^"_IRUpdateUserDr_"^"_VisitName_"^"_VistDate_"^"_VisitResul_"^"_VisitResume_"^"_PatTem
	
	// 保存手术切口报告信息
	Set flg=##Class(DHCHAI.IR.INFOPS).Update(InputStr,"^")
	Quit:(+flg)<1 return
	Set OPSID=+flg
	
	Set return=OPSID
	Quit return
	
SaveINFOPSFollowErr
	Quit -999_"^"_$ZError
}

}
