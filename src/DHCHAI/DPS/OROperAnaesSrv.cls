/// 名称: DHCHAI.DPS.OROperAnaesSrv
/// 描述: 手术麻醉记录相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-23
Class DHCHAI.DPS.OROperAnaesSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取手术日期
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aEpisodeID ：就诊号
/// w ##class("DHCHAI.DPS.OROperAnaesSrv").GetOperDates(160)
ClassMethod GetOperDates(aEpisodeDr As %String) As %List
{
	New (aEpisodeDr)
	Set return=""
	Quit:(aEpisodeDr="") return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.ORIsActive'=1
		Set OperDate=obj.OROperDate
		Continue:OperDate=""
		Set OperDesc =obj.OROperDesc
		//启用手术字典对照是否有效配置，过滤无关手术 20191101
		Set Flg = 0
		Set xSCode =""
	    For {
		    Set xSCode=$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",xSCode))
		    Quit:xSCode=""
		    
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",xSCode,OperDesc,xMapID))
			    Quit:xMapID=""
			    
			    Set objMap=##class(DHCHAI.DP.OROperDxMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set IsActive = objMap.BTIsActive
				Continue:IsActive'=1
				Set Flg =1
				Quit
		    }
	    }
	    Continue:Flg'=1
		    
		Continue:$listfind(return,OperDate)>0
		Set return=return_$lb(OperDate)
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-23
/// Description:  查询手术切口调查列表
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
///               aLocID   : 手术科室ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OROperAnaesSrv","QryINFOPSSurv","2020-03-01","2020-05-31","","1|3|4","","","","1")
Query QryINFOPSSurv(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String = "", aCuteType As %String = "", aEpisodeID As %String = "", aOperAnaesID As %String = "", aVisitRes As %String = "", aDateType As %String = 1, aOperCat As %String = "", aSurvStatus As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeDr:%String,ReportID:%String,INFOPSID:%String,RepStatus:%String,RepDate:%String,RepUser:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,AdmLocID:%String,AdmLocDesc:%String,AdmBed:%String,OperICD:%String,OperDesc:%String,SCode:%String,MapTypeDicDR:%String,MapTypeDicDesc:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OpertorName:%String,OperHour:%String,OperLocID:%String,OperLocDesc:%String,Assistant1:%String,Assistant2:%String,MapIncDicDR:%String,MapIncDicDesc:%String,MapHealDicDR:%String,MapHealDicDesc:%String,MapASADicDR:%String,MapASADicDesc:%String,MapNNISDicDR:%String,MapNNISDicDesc:%String,WBC:%String,IncisionNum:%String,IsSightGlass:%String,IsImplants:%String,LoseBlood:%String,GotBlood:%String,Complication:%String,MapAnesDicDR:%String,MapAnesDicDesc:%String,Anesthesia:%String,OperDxDr:%String,Operation:%String,MRDiagnos:%String,IsOperInf:%String,IsInHospInf:%String,InfTypeID:%String,InfTypeDesc:%String,RepTime:%String,InLocDate:%String,OutLocDate:%String,VisitResult:%String,VistDate:%String,OperCatDrs:%String,OperCatLists:%String,OperTypeSoC:%String,PAAdmDoc:%String,RepStatusCode:%String") [ SqlProc ]
{
}

ClassMethod QryINFOPSSurvExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String = "", aCuteType As %String = "", aEpisodeID As %String = "", aOperAnaesID As %String = "", aVisitRes As %String = "", aDateType As %String = 1, aOperCat As %String = "", aSurvStatus As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aHospID=$g(aHospID)
 	Set:aHospID'="" aHospID="|"_aHospID_"|"
 	Set:aLocID=0 aLocID=""
 	//Set:aOperAnaesID'="" aOperAnaesID=aOperAnaesID
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:((aDateFrom="")||(aDateTo="")||(aDateFrom>aDateTo))&(aEpisodeID="") $$$OK
 	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
 	
 	//手术筛查规则启用标志
 	Set IRCRuleOperFlag=##class(DHCHAI.BT.Config).GetValByCode("IRCRuleOperFlag")
 	Set IRCRuleOperFlag=+IRCRuleOperFlag
 	If (aEpisodeID="") { 	
	 	If (aDateType =1) {  //手术日期
	 		For xOperDate=aDateFrom:1:aDateTo {
				Set xTime=""
				For {
		 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xOperDate,xTime))
					Quit:xTime=""
					
					Set xOperLocDr=""
					For {
						Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xOperDate,xTime,xOperLocDr))
						Quit:xOperLocDr=""
						
						Set xID=""
						For {
				 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xOperDate,xTime,xOperLocDr,xID))
							Quit:xID=""
							
							Do BuildDataOperInfo(xID)
						}
					}
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
						
						Set objOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(INFOPSID)
						Continue:'$Isobject(objOPS)
						Continue:'$Isobject(objOPS.IROperDr)
					    Set AnaesDR   = objOPS.IROperDr.%Id()
						
						Do BuildDataOperInfo(AnaesDR)
					}      
				}
	 		}
	 	}ElseIf (aDateType =3) {  //手术切口调查登记回访日期
	 		For xVistDate=aDateFrom:1:aDateTo {
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.INFOPSI("IndexVistDateOperDr",xVistDate,xID))
					Quit:xID=""
					
					Do BuildDataOperInfo(xID)
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

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",xEpisodeID,xID))
								Quit:xID=""
								
								Do BuildDataOperInfo(xID)
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

							Set xID=""
							For {
					 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",xEpisodeID,xID))
								Quit:xID=""
								
								Do BuildDataOperInfo(xID)
							}                           
						}
					}
				}
			}
	 	}
	 } Else { //根据患者查数据
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""
			
			Do BuildDataOperInfo(xID)
		}
	}
	Quit $$$OK
	
BuildDataOperInfo(xID)

	Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
 	Quit:'$IsObject(obj)
 	Quit:obj.ORIsActive'=1
 	Quit:'$IsObject(obj.OREpisodeDr)
 	//通过就诊号和手麻ID确保数据唯一准确
 	Quit:((aOperAnaesID'="")&&(aOperAnaesID'=xID))

 	Set EpisodeDr  = obj.OREpisodeDr.%Id()
 	Set OperDesc   = obj.OROperDesc
 	Set SCode      = obj.ORSCode            // 子系统代码
 	//启用手术字典对照是否有效配置，过滤无关手术 20191101
	Set Flg = 0
    Set xMapID=""
    For {  
		Set xMapID=$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",SCode,OperDesc,xMapID))
	    Quit:xMapID=""
	    
	    Set objMap=##class(DHCHAI.DP.OROperDxMap).GetObjById(xMapID)
		Continue:'$Isobject(objMap)	
		Set IsActive = objMap.BTIsActive
		Continue:IsActive'=1
		Set Flg =1
		Quit
    }
    Quit:Flg'=1
 	Set OperDate   = obj.OROperDate         // 手术开始日期
	Set SttTime    = obj.ORSttTime          // 手术开始时间
 	Set AdmInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,OperDate,SttTime)
 	Set CurrLocID = $p(AdmInfo,"^",1)
 	Set CurrWardID = $p(AdmInfo,"^",2)
 	If aLocID="" {
 		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(CurrLocID)
 		Quit:'$IsObject(objLoc)
 		Quit:'$IsObject(objLoc.BTHospDr)
 		Set HospID=objLoc.BTHospDr.%Id()
 		Quit:(aHospID'="")&(aHospID'[("|"_HospID_"|"))
 		Set CRuleOperLoc=CurrLocID
 		Set:CRuleOperLoc="" CRuleOperLoc=CurrWardID
 		Set objRuleLoc=##class(DHCHAI.BT.Location).GetObjById(CRuleOperLoc)
 		Quit:'$IsObject(objRuleLoc)
 	}Else {
 		Quit:(aLocID'="")&((CurrWardID'=aLocID)&&(CurrLocID'=aLocID))  // 过滤手术科室
 		Set CRuleOperLoc=CurrLocID
 		Set:CRuleOperLoc="" CRuleOperLoc=CurrWardID
 	}
	Set OperStatus = obj.OROperStatus         // 手术状态
	Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OperStatus",OperStatus)
	Set:tOperStatus'="" OperStatus=tOperStatus
  	//Quit:"ADC"[OperStatus    // 过滤手术状态
 	//Quit:ExclStatus[OperStatus
 	
	Set EpisodeID   = obj.OREpisodeDr.PAEpisodeIDx
	Set PatientID   = obj.OREpisodeDr.PAPatientIDx
	Set PapmiNo     = obj.OREpisodeDr.PAPapmiNo
	Set MrNo        = obj.OREpisodeDr.PAMrNo
	Set PatName     = obj.OREpisodeDr.PAPatName
	Set Sex         = obj.OREpisodeDr.PASex
	Set Sex         = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate     = obj.OREpisodeDr.PAAdmDate
	Set AdmTime     = obj.OREpisodeDr.PAAdmTime
	Set Age         = obj.OREpisodeDr.PAAge
	Set DischDate   = obj.OREpisodeDr.PADischDate
	Set DischTime   = obj.OREpisodeDr.PADischTime
	Set PAAdmDoc    = obj.OREpisodeDr.PAAdmDoc
	Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
    Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)
	Set (AdmLocID,AdmLocCode,AdmLocDesc)=""
	If $IsObject(obj.OREpisodeDr.PAAdmLocDr){
		Set AdmLocID   = obj.OREpisodeDr.PAAdmLocDr.%Id()
		Set AdmLocCode = obj.OREpisodeDr.PAAdmLocDr.BTCode
		Set AdmLocDesc = obj.OREpisodeDr.PAAdmLocDr.BTDesc
	}
	Set AdmRoom     = obj.OREpisodeDr.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(obj.OREpisodeDr.PAAdmBedDr){
		Set AdmBedDr=obj.OREpisodeDr.PAAdmBedDr.%Id()
		Set AdmBed=obj.OREpisodeDr.PAAdmBedDr.BTDesc
	}
	Set MRDiagnos = ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(EpisodeDr,"")
	Set OperICD   = obj.OROperICD          // 手术ICD
	Set Incision  = obj.ORIncision         // 切口等级
	Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (IncisionInfo'="") {
		Set MapIncDicDR   = $p(IncisionInfo,"^",1)
		Set MapIncDicDesc = $p(IncisionInfo,"^",3)
	}Else {
		Set MapIncDicDR   = ""
		Set MapIncDicDesc = Incision
	}
	//Quit:MapIncDicDesc="无" // 过滤无切口的手术
	//*********************************************************************
	//手术筛查规则 add by zf 20171128
	If IRCRuleOperFlag=1 { //启用筛查规则过滤
		Set objCROper=##class(DHCHAI.IRS.CRuleOperSrv).CheckByCRuleOper(OperDesc,CRuleOperLoc,MapIncDicDR)
		Quit:'$IsObject(objCROper)
		If $IsObject(objCROper.BTOperDxDr){
			Set OperDxDr=objCROper.BTOperDxDr.%Id()
			Set Operation=objCROper.BTOperDesc //手术标准名称
		} Else {
			Set OperDxDr=""
			Set Operation=objCROper.BTOperation  //手术筛查规则 自定义手术名称
		}
	}
	//*********************************************************************
	
	Set OperHour  = obj.OROperHour         // 手术时长
	Set Assistant1= obj.ORAssistant1       // 一助
	Set Assistant2= obj.ORAssistant2       // 二助
	Set ASAScore  = obj.ORASAScore         // ASA评分
	Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (ASAScoreInfo'="") {
		Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
		Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
	}Else {
		Set MapASADicDR   = ""
		Set MapASADicDesc = ASAScore
	}
	Set NNISGrade   = obj.ORNNISGrade        // NNIS分级
	Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (NNISGradeInfo'="") {
		Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
		Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
	}Else {
		Set MapNNISDicDR   = ""
		Set MapNNISDicDesc = NNISGrade
	}
	Set WBC         = obj.ORWBC              // 术前WBC外周值
	Set IncisionNum = obj.ORIncisionNum      // 切口个数
	Set IsSightGlass= obj.ORIsSightGlass     // 是否使用窥镜
	Set IsImplants  = obj.ORIsImplants       // 是否植入物
	Set LoseBlood   = obj.ORLoseBlood        // 失血量
	Set GotBlood    = obj.ORGotBlood         // 输血量
	Set Complication= obj.ORComplication     // 并发症
	Set Anesthesia  = obj.ORAnesthesia       // 麻醉医生
	// 取手术科室，按照手术时间所在的病区科室
	Set (OperLocID,OperLocDesc)=""
	Set objCurLoc = ##class(DHCHAI.BT.Location).GetObjById(CurrLocID)
	If ($IsObject(objCurLoc)){
		Set OperLocID   = CurrWardID
		Set OperLocDesc = objCurLoc.BTDesc
		Set OperLocDesc2 = objCurLoc.BTDesc2
		Set:OperLocDesc["-" OperLocDesc= $p(OperLocDesc,"-",2)
		Set OperLocDesc=$s(OperLocDesc2'="":OperLocDesc2,1:OperLocDesc)
	}

	If (OperLocID=""){
		Set objCurLoc = ##class(DHCHAI.BT.Location).GetObjById(CurrLocID)
		If ($IsObject(objCurLoc)){
			Set OperLocID   = CurrLocID
			Set OperLocDesc = objCurLoc.BTDesc
			Set OperLocDesc2 = objCurLoc.BTDesc2
			Set:OperLocDesc["-" OperLocDesc= $p(OperLocDesc,"-",2)
			Set OperLocDesc=$s(OperLocDesc2'="":OperLocDesc2,1:OperLocDesc)
		}
	}
	Quit:OperLocID=""	
	// 手术切口调查表---院感报告数据共享
	Set (ReportID,INFOPSID,RepStatus,RepDate,RepTime,RepUser,VisitResID,VisitResult,VistDate,RepStatusCode)=""
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(EpisodeDr,xID)
	If ($IsObject(objINFOPS)) {
		Set INFOPSID = objINFOPS.%Id()
		Set RepInfo  = ##Class(DHCHAI.IRS.INFOPSSrv).GetOPSRepID(EpisodeDr,INFOPSID)
		If (RepInfo="") {  // 说明数据是院感报告那边填写的,手术切口调查表ID应该置为空
			Set INFOPSID   = ""
		}Else {
			Set ReportID   = $p(RepInfo,"^",1)
			Set RepDate    = $p(RepInfo,"^",2)
			Set RepUser    = $p(RepInfo,"^",4)
			Set RepStatus  = $p(RepInfo,"^",6)
			Set RepTime    = $p(RepInfo,"^",7)
			Set RepStatusCode=$p(RepInfo,"^",8)
		}
		Set OperDxDr       = ""
		Set Operation      = objINFOPS.IROperName2  //手术标准名称
		
		If $IsObject(objINFOPS.IROperTypeDr){          // 手术类型
			Set MapTypeDicDR   = objINFOPS.IROperTypeDr.%Id()
			Set MapTypeDicDesc = objINFOPS.IROperTypeDr.BTDesc
		}Else{
			Set MapTypeDicDR = "",MapTypeDicDesc = ""
		}
		Set OperDate    = objINFOPS.IROperDate         // 手术日期
		Set SttTime     = objINFOPS.IRSttTime          // 手术开始时间
		Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
		Set:SttTime'="" SttTime= $zt(SttTime,2)
		Set EndDate     = objINFOPS.IREndDate          // 手术结束日期
		Set EndTime     = objINFOPS.IREndTime          // 手术结束时间
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set:EndTime'="" EndTime= $zt(EndTime,2)
		Set OpertorName = objINFOPS.IROperDocTxt       // 手术医生
		If (OpertorName="") {
			If $IsObject(objINFOPS.IROperDocDr){
				Set OpertorName = objINFOPS.IROperDocDr.BTDesc
			}
		}
		/*
		If $IsObject(objINFOPS.IROperLocDr){   // 手术科室
			Set OperLocID   = objINFOPS.IROperLocDr.%Id()
			Set OperLocDesc = objINFOPS.IROperLocDr.BTDesc
			Set OperLocDesc2 = objINFOPS.IROperLocDr.BTDesc2
			Set:OperLocDesc2'="" OperLocDesc=OperLocDesc2
			Set:OperLocDesc["-" OperLocDesc=$p(OperLocDesc,"-",2)
		}Else{
			Set OperLocID = "",OperLocDesc = ""
		}
		*/
		If $IsObject(objINFOPS.IRAnesthesiaDr){        // 麻醉方式
			Set MapAnesDicDR   = objINFOPS.IRAnesthesiaDr.%Id()
			Set MapAnesDicDesc = objINFOPS.IRAnesthesiaDr.BTDesc
		}Else{
			Set MapAnesDicDR = "",MapAnesDicDesc = ""
		}
		If $IsObject(objINFOPS.IRCuteTypeDr){          // 切口分类 
			Set MapIncDicDR   = objINFOPS.IRCuteTypeDr.%Id()
			Set MapIncDicDesc = objINFOPS.IRCuteTypeDr.BTDesc
		}Else{
			Set MapIncDicDR = "",MapIncDicDesc = ""
		}
		Quit:(aCuteType'="")&&(aCuteType'=MapIncDicDR)
		If $IsObject(objINFOPS.IRASAScore){        // ASA评分
			Set MapASADicDR   = objINFOPS.IRASAScore.%Id()
			Set MapASADicDesc = objINFOPS.IRASAScore.BTDesc
		}Else{
			Set MapASADicDR = "",MapASADicDesc = ""
		}
		If $IsObject(objINFOPS.IRCuteHealingDr){        // 愈合情况
			Set MapHealDicDR   = objINFOPS.IRCuteHealingDr.%Id()
			Set MapHealDicDesc = objINFOPS.IRCuteHealingDr.BTDesc
		}Else{
			Set MapHealDicDR = "",MapHealDicDesc = ""
		}
		Set IsOperInf     = objINFOPS.IRIsOperInf
		Set IsInHospInf   = objINFOPS.IRIsInHospInf
		If $IsObject(objINFOPS.IRInfTypeDr){             // 感染部位
			Set InfTypeID   = objINFOPS.IRInfTypeDr.%Id()
			Set InfTypeDesc = objINFOPS.IRInfTypeDr.BTDesc
		}Else{
			Set InfTypeID = "",InfTypeDesc = ""
		}
		//回访结果
		Set VisitResDr=objINFOPS.IRVisitResultDr
		if ($IsObject(VisitResDr)){
			Set VisitResID=VisitResDr.%Id()
			Set VisitResult=VisitResDr.BTDesc
		}
		Set VistDate=objINFOPS.IRVistDate
		Set:VistDate'="" VistDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VistDate)
	} Else {
		Set OperType = obj.OROperType         // 手术类型
		Set OperTypeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
		If (OperTypeInfo'="") {
			Set MapTypeDicDR   = $p(OperTypeInfo,"^",1)
			Set MapTypeDicDesc = $p(OperTypeInfo,"^",3)
		}Else {
			Set MapTypeDicDR   = ""
			Set MapTypeDicDesc = OperType
		}
		Set CuteType = obj.ORIncision					//切口类型
		Set CuteTypeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",CuteType)  
		If (CuteTypeInfo'="") {
			Set MapAnesDicDR   = $p(CuteTypeInfo,"^",1)
			Set MapAnesDicDesc = $p(CuteTypeInfo,"^",3)
		}Else {
			Set (MapAnesDicDR,MapAnesDicDesc) = ""
		}
		Quit:(aCuteType'="")&&(aCuteType'=MapIncDicDR)
		
		Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
		Set:SttTime'="" SttTime= $zt(SttTime,2)
		Set EndDate     = obj.OREndDate          // 手术结束日期
		Set EndTime     = obj.OREndTime          // 手术结束时间
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set:EndTime'="" EndTime= $zt(EndTime,2)
		Set Opertor = obj.OROpertor              // 手术医生
		Set OpertorName=$p(Opertor,"|",3)
		Set Healing = obj.ORHealing   // 愈合情况
		Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",Healing)  
		If (HealingInfo'="") {
			Set MapHealDicDR   = $p(HealingInfo,"^",1)
			Set MapHealDicDesc = $p(HealingInfo,"^",3)
		}Else {
			Set MapHealDicDR   = ""
			Set MapHealDicDesc = Healing
		}
		Set AnesMethod  = obj.ORAnesMethod       // 麻醉方式
		Set AnesMethodInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"Anesthesia",AnesMethod)  
		If (AnesMethodInfo'="") {
			Set MapAnesDicDR   = $p(AnesMethodInfo,"^",1)
			Set MapAnesDicDesc = $p(AnesMethodInfo,"^",3)
		}Else {
			Set MapAnesDicDR   = ""
			Set MapAnesDicDesc = AnesMethod
		}
		Set (InfTypeID,InfTypeDesc)=""
		Set (IsOperInf,IsInHospInf)=0
	}
	Quit:(aVisitRes'="")&(aVisitRes'=VisitResID)
	//通过手术日期和科室，找出入科、出科日期
	Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransDateInfo(EpisodeDr,OperLocID,OperDate)
	Set (InLocDate,OutLocDate)=""
	If (TransInfo'=""){
		Set InLocDate=$p(TransInfo,"^",3)
		Set OutLocDate=$p(TransInfo,"^",4)
	}
	//add 20221009 guojun 增加手术分类多选条件过滤
	Set OperCatDrs = obj.OROperCatDrs
	Set IsFlag=0
	For xInd=1:1:$l(aOperCat,",") {
		Set OperCat=$p(aOperCat,",",xInd)	
		Set:(OperCat'="")&&((","_OperCatDrs_",")[(","_OperCat_",")) IsFlag=1
		Quit:IsFlag=1
	}
	Quit:(OperCat'="")&&(IsFlag=0)

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
	Set OperTypeSoC =obj.OROperTypeSoC
	//报告状态筛选
	If (aSurvStatus'=""){
		If (RepStatus=""){
			Quit:aSurvStatus'="新建"
		}else{
			Quit:aSurvStatus'=RepStatus    
		}
		
	}
	//多语言改造Sex,Age
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set:Age["岁" Age=$Replace(Age,"岁",##Class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))
	Set:Age["月" Age=$Replace(Age,"月",##Class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:Age["天" Age=$Replace(Age,"天",##Class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	Set PAAdmDoc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
	Set OperLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",OperLocDesc,"User.CTLoc")
	Set MapIncDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapIncDicDesc,"DHCHAI.BT.Dictionary")
	Set OpertorName =##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",OpertorName,"User.SSUser")
	Set MapTypeDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapTypeDicDesc,"DHCHAI.BT.Dictionary")
	Set MapASADicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapASADicDesc,"DHCHAI.BT.Dictionary")
	Set MapASADicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapASADicDesc,"DHCHAI.BT.Dictionary")
	Set RepUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUser,"User.SSUser")
	Set RepStatus=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.Dictionary")
	
	Set Data=$lb(xID,EpisodeDr,ReportID,INFOPSID,RepStatus,RepDate,RepUser,EpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmDate,AdmTime,DischDate,DischTime,AdmLocID,AdmLocDesc,AdmBed)
	Set Data=Data_$lb(OperICD,OperDesc,SCode,MapTypeDicDR,MapTypeDicDesc,OperDate,SttTime,EndDate,EndTime,OpertorName,OperHour,OperLocID,OperLocDesc,Assistant1,Assistant2,MapIncDicDR,MapIncDicDesc,MapHealDicDR,MapHealDicDesc,MapASADicDR,MapASADicDesc,MapNNISDicDR,MapNNISDicDesc,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication,MapAnesDicDR,MapAnesDicDesc,Anesthesia)
	Set Data=Data_$lb(OperDxDr,Operation,MRDiagnos,IsOperInf,IsInHospInf,InfTypeID,InfTypeDesc,RepTime,InLocDate,OutLocDate)
	Set Data=Data_$lb(VisitResult,VistDate,OperCatDrs,OperCatLists,OperTypeSoC,PAAdmDoc)
	Set Data=Data_$lb(RepStatusCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryINFOPSSurvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFOPSSurvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFOPSSurvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFOPSSurvExecute ]
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
/// CreatDate：   2017-09-20
/// Description:  查询病人手术信息
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aEpisodeID: 开始日期
///               aOperType  : 手术类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OROperAnaesSrv","QryOperByEpisodeID","6","")
Query QryOperByEpisodeID(aEpisodeID As %String, aOperType As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,OperICD:%String,OperDesc:%String,OperTypeID:%String,OperType:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OperHour:%String,OperLocID:%String,OperLoc:%String,OpertorName:%String,OpertorCode:%String,Assistant1:%String,Assistant2:%String,IncisionID:%String,Incision:%String,HealingID:%String,Healing:%String,AnesMethodID:%String,AnesMethod:%String,Anesthesia:%String,ASAScoreID:%String,ASAScore:%String,NNISGradeID:%String,NNISGrade:%String,WBC:%String,IncisionNum:%String,IsSightGlass:%String,IsImplants:%String,LoseBlood:%String,GotBlood:%String,Complication:%String")
{
}

ClassMethod QryOperByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aOperType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
 	
 	Set xID = ""
 	For {
		Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set Data = ..BuildOperData(xID,aOperType)
		Continue:Data=""
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryOperByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperByEpisodeIDExecute ]
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

/// 取单个手术信息
ClassMethod BuildOperData(aOperAnaesID As %String, aOperType As %String) As %String
{
	New (aOperAnaesID,aOperType)
	Set return=""
	Quit:aOperAnaesID="" return
	
	Set objOper = ##class(DHCHAI.DP.OROperAnaes).GetObjById(aOperAnaesID)
	Quit:'$isobject(objOper) return
	
	Set IsActive 	= objOper.ORIsActive
	Quit:IsActive'=1 return
	
	Set SCode 		= objOper.ORSCode
	Set OperICD 	= objOper.OROperICD
	Set OperDesc 	= objOper.OROperDesc
	Set OperType 	= objOper.OROperType
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
	If (PhraseMap'="") {
		Set OperTypeID  = $p(PhraseMap,"^",1)
		Set OperType 	= $p(PhraseMap,"^",3)
	}Else {
		Set OperTypeID  = ""
	}
	Quit:(aOperType'="")&&(aOperType'=OperType) return
	
	Set OperDate 	= objOper.OROperDate
	Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(+OperDate)
	Set SttTime 	= objOper.ORSttTime
	Set:SttTime'="" SttTime=$zt(SttTime)
	Set EndDate 	= objOper.OREndDate
	Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(+EndDate)
	Set EndTime 	= objOper.OREndTime
	Set:EndTime'="" EndTime=$zt(EndTime)
	Set OperHour 	= objOper.OROperHour
	if (+OperHour=0)
	{
		if ((OperDate)'=""&(EndDate'=""))
		{
			Set SpanSec = ##class(DHCHAI.IR.INFOPS).GetGapNow(+objOper.OROperDate,+objOper.ORSttTime,+objOper.OREndDate,+objOper.OREndTime)
			Set OperHour=$fn((SpanSec/(60*60)),"",2)
		}
	}
	Set objOperLoc 	= objOper.OROperLocDr
	Set (OperLocID,OperLoc)=""
	If $isobject(objOperLoc){
		Set OperLocID = objOperLoc.%Id()
		If objOperLoc.BTDesc2'=""{
			Set OperLoc = objOperLoc.BTDesc2
		}else{
			Set OperLoc = objOperLoc.BTDesc
		}
	}
	If (OperLoc=""){
		Set OperLocID = $p(objOper.OROperLoc,"|",1)
		Set OperLoc   = $p(objOper.OROperLoc,"|",3)
	}
	Set Opertor = objOper.OROpertor
	Set OpertorCode=$p(Opertor,"|",2)
	Set OpertorName=$p(Opertor,"|",3)
	Set Assistant1 	= objOper.ORAssistant1
	Set Assistant2 	= objOper.ORAssistant2
	Set Incision 	= objOper.ORIncision
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (PhraseMap'="") {
		Set IncisionID  = $p(PhraseMap,"^",1)
		Set Incision 	= $p(PhraseMap,"^",3)
	}Else {
		Set IncisionID  = ""
	}
	Set Healing 	= objOper.ORHealing
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",Healing)  
	If (PhraseMap'="") {
		Set HealingID   = $p(PhraseMap,"^",1)
		Set Healing 	= $p(PhraseMap,"^",3)
	}Else {
		Set HealingID   = ""
	}
	Set AnesMethod 	= objOper.ORAnesMethod
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"Anesthesia",AnesMethod)  
	If (PhraseMap'="") {
		Set AnesMethodID  	= $p(PhraseMap,"^",1)
		Set AnesMethod 		= $p(PhraseMap,"^",3)
	}Else {
		Set AnesMethodID   	= ""
	}
	Set Anesthesia 	= objOper.ORAnesthesia
	Set ASAScore 	= objOper.ORASAScore
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (PhraseMap'="") {
		Set ASAScoreID  = $p(PhraseMap,"^",1)
		Set ASAScore 	= $p(PhraseMap,"^",3)
	}Else {
		Set ASAScoreID  = ""
	}
	Set NNISGrade 	= objOper.ORNNISGrade
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (PhraseMap'="") {
		Set NNISGradeID = $p(PhraseMap,"^",1)
		Set NNISGrade 	= $p(PhraseMap,"^",3)
	}Else {
		Set NNISGradeID = ""
	}
	Set WBC 		= objOper.ORWBC
	Set IncisionNum = objOper.ORIncisionNum
	Set IsSightGlass= objOper.ORIsSightGlass
	Set IsImplants 	= objOper.ORIsImplants
	Set LoseBlood 	= objOper.ORLoseBlood
	Set GotBlood 	= objOper.ORGotBlood
	Set Complication= objOper.ORComplication
	Set return = $lb(aOperAnaesID,aEpisodeID,OperICD,OperDesc,OperTypeID,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocID,OperLoc,OpertorName,OpertorCode,Assistant1,Assistant2,IncisionID,Incision,HealingID,Healing,AnesMethodID,AnesMethod,Anesthesia,ASAScoreID,ASAScore,NNISGradeID,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-05-20
/// Description:  查询手术信息
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aID: 手术记录
/// 取单个手术信息
/// w ##class(DHCHAI.DPS.OROperAnaesSrv).GetOperData(252)
ClassMethod GetOperData(aOperAnaesID As %String) As %String
{
	New (aOperAnaesID,%session)
	Set return=""
	Quit:aOperAnaesID="" return
	
	Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(aOperAnaesID)
 	Quit:'$IsObject(obj)
 	Quit:obj.ORIsActive'=1
 	Quit:'$IsObject(obj.OREpisodeDr)

 	Set EpisodeDr  = obj.OREpisodeDr.%Id()
 	Set OperDesc   = obj.OROperDesc
 	Set SCode      = obj.ORSCode
	Set OperStatus = obj.OROperStatus         // 手术状态	
	Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OperStatus",OperStatus)
	Set:tOperStatus'="" OperStatus=tOperStatus
 	//Quit:"ADC"[OperStatus    // 过滤手术状态
 	//Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
 	//Quit:ExclStatus[OperStatus
	Set OperICD   = obj.OROperICD          // 手术ICD
	Set OperHour  = obj.OROperHour         // 手术时长
	Set ASAScore  = obj.ORASAScore         // ASA评分
	Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (ASAScoreInfo'="") {
		Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
		Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
	}Else {
		Set MapASADicDR   = ""
		Set MapASADicDesc = ASAScore
	}
	Set NNISGrade   = obj.ORNNISGrade        // NNIS分级
	Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (NNISGradeInfo'="") {
		Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
		Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
	}Else {
		Set MapNNISDicDR   = ""
		Set MapNNISDicDesc = NNISGrade
	}
	Set Incision  = obj.ORIncision         // 切口等级
	Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (IncisionInfo'="") {
		Set MapIncDicDR   = $p(IncisionInfo,"^",1)
		Set MapIncDicDesc = $p(IncisionInfo,"^",3)
	}Else {
		Set MapIncDicDR   = ""
		Set MapIncDicDesc = Incision
	}
	Set WBC         = obj.ORWBC              // 术前WBC外周值
	Set IncisionNum = obj.ORIncisionNum      // 切口个数
	Set IsSightGlass= obj.ORIsSightGlass     // 是否使用窥镜
	Set IsImplants  = obj.ORIsImplants       // 是否植入物
	Set LoseBlood   = obj.ORLoseBlood        // 失血量
	Set GotBlood    = obj.ORGotBlood         // 输血量
	Set Complication= obj.ORComplication     // 并发症
	Set Anesthesia  = obj.ORAnesthesia       // 麻醉医生
	Set objOperLoc 	= obj.OROperLocDr
	Set (OperLocID,OperLoc)=""
	If $Isobject(objOperLoc){
		Set OperLocID = objOperLoc.%Id()
		If objOperLoc.BTDesc2'=""{
			Set OperLoc = objOperLoc.BTDesc2
		}else{
			Set OperLoc = objOperLoc.BTDesc
		}
	}
	If (OperLoc=""){
		Set OperLocID = $p(obj.OROperLoc,"|",1)
		Set OperLoc   = $p(obj.OROperLoc,"|",3)
	}
	//add 20210926 增加手术分类
	Set OperCatDrs = obj.OROperCatDrs
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
	
	// 手术切口调查表---院感报告数据共享
	Set (INFOPSID,OperName)=""
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(EpisodeDr,aOperAnaesID)
	If ($IsObject(objINFOPS)) {
		Set INFOPSID = objINFOPS.%Id()
		Set OperName      = objINFOPS.IROperName2  //手术标准名称
		
		If $IsObject(objINFOPS.IROperTypeDr){          // 手术类型
			Set MapTypeDicDR   = objINFOPS.IROperTypeDr.%Id()
			Set MapTypeDicDesc = objINFOPS.IROperTypeDr.BTDesc
		}Else{
			Set MapTypeDicDR = "",MapTypeDicDesc = ""
		}
		Set OperDate    = objINFOPS.IROperDate         // 手术日期
		Set SttTime     = objINFOPS.IRSttTime          // 手术开始时间
		Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
		Set:SttTime'="" SttTime= $zt(SttTime,2)
		Set EndDate     = objINFOPS.IREndDate          // 手术结束日期
		Set EndTime     = objINFOPS.IREndTime          // 手术结束时间
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set:EndTime'="" EndTime= $zt(EndTime,2)
		Set OpertorName = objINFOPS.IROperDocTxt       // 手术医生
		If (OpertorName="") {
			If $IsObject(objINFOPS.IROperDocDr){
				Set OpertorName = objINFOPS.IROperDocDr.BTDesc
			}
		}
		Set OperHour = objINFOPS.IROperHours
		If $IsObject(objINFOPS.IRAnesthesiaDr){        // 麻醉方式
			Set MapAnesDicDR   = objINFOPS.IRAnesthesiaDr.%Id()
			Set MapAnesDicDesc = objINFOPS.IRAnesthesiaDr.BTDesc
		}Else{
			Set MapAnesDicDR = "",MapAnesDicDesc = ""
		}
		If $IsObject(objINFOPS.IRCuteTypeDr){          // 切口分类 
			Set MapIncDicDR   = objINFOPS.IRCuteTypeDr.%Id()
			Set MapIncDicDesc = objINFOPS.IRCuteTypeDr.BTDesc
		}Else{
			Set MapIncDicDR = "",MapIncDicDesc = ""
		}
		If $IsObject(objINFOPS.IRASAScore){        // ASA评分
			Set MapASADicDR   = objINFOPS.IRASAScore.%Id()
			Set MapASADicDesc = objINFOPS.IRASAScore.BTDesc
		}Else{
			Set MapHealDicDR = "",MapHealDicDesc = ""
		}
		If $IsObject(objINFOPS.IRCuteHealingDr){        // 愈合情况
			Set MapHealDicDR   = objINFOPS.IRCuteHealingDr.%Id()
			Set MapHealDicDesc = objINFOPS.IRCuteHealingDr.BTDesc
		}Else{
			Set MapHealDicDR = "",MapHealDicDesc = ""
		}
		Set IsOperInf     = objINFOPS.IRIsOperInf
		Set IsInHospInf   = objINFOPS.IRIsInHospInf
		If $IsObject(objINFOPS.IRInfTypeDr){             // 感染部位
			Set InfTypeID   = objINFOPS.IRInfTypeDr.%Id()
			Set InfTypeDesc = objINFOPS.IRInfTypeDr.BTDesc
		}Else{
			Set InfTypeID = "",InfTypeDesc = ""
		}
		
		Set (OperLocID,OperLoc)=""
		If $IsObject(objOperLoc){
			Set OperLocID = objOperLoc.%Id()
			Set LocDesc2 = objOperLoc.BTDesc2
			Set LocDesc = objOperLoc.BTDesc
			Set OperLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		}
	
		Set WBC         = objINFOPS.IRPreoperWBC         // 术前WBC外周值
		Set IncisionNum = objINFOPS.IRCuteNumber         // 切口个数
		Set IsSightGlass= objINFOPS.IREndoscopeFlag      // 是否使用窥镜
		Set IsImplants  = objINFOPS.IRImplantFlag        // 是否植入物
		Set LoseBlood   = objINFOPS.IRBloodLoss          // 失血量
		Set GotBlood    = objINFOPS.IRBloodTrans         // 输血量
		Set Complication= objINFOPS.IRPostoperComps      // 并发症
	} Else {
		Set OperType = obj.OROperType         // 手术类型
		Set OperTypeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
		If (OperTypeInfo'="") {
			Set MapTypeDicDR   = $p(OperTypeInfo,"^",1)
			Set MapTypeDicDesc = $p(OperTypeInfo,"^",3)
		}Else {
			Set MapTypeDicDR   = ""
			Set MapTypeDicDesc = OperType
		}
		Set CuteType = obj.ORIncision					//切口类型
		Set CuteTypeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",CuteType)  
		If (CuteTypeInfo'="") {
			Set MapAnesDicDR   = $p(CuteTypeInfo,"^",1)
			Set MapAnesDicDesc = $p(CuteTypeInfo,"^",3)
		}Else {
			Set (MapAnesDicDR,MapAnesDicDesc) = ""
		}
		
		Set OperDate    = obj.OROperDate         // 手术日期
		Set SttTime     = obj.ORSttTime          // 手术开始时间
		Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
		Set:SttTime'="" SttTime= $zt(SttTime,2)
		Set EndDate     = obj.OREndDate          // 手术结束日期
		Set EndTime     = obj.OREndTime          // 手术结束时间
		Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set:EndTime'="" EndTime= $zt(EndTime,2)
		Set Opertor = obj.OROpertor              // 手术医生
		Set OpertorName=$p(Opertor,"|",3)
		Set Healing = obj.ORHealing   // 愈合情况
		Set HealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",Healing)  
		If (HealingInfo'="") {
			Set MapHealDicDR   = $p(HealingInfo,"^",1)
			Set MapHealDicDesc = $p(HealingInfo,"^",3)
		}Else {
			Set MapHealDicDR   = ""
			Set MapHealDicDesc = Healing
		}
		Set AnesMethod  = obj.ORAnesMethod       // 麻醉方式
		Set AnesMethodInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"Anesthesia",AnesMethod)  
		If (AnesMethodInfo'="") {
			Set MapAnesDicDR   = $p(AnesMethodInfo,"^",1)
			Set MapAnesDicDesc = $p(AnesMethodInfo,"^",3)
		}Else {
			Set MapAnesDicDR   = ""
			Set MapAnesDicDesc = AnesMethod
		}
		Set (InfTypeID,InfTypeDesc)=""
		Set (IsOperInf,IsInHospInf)=0
	}
	
	//多语言处理
	Set OperDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTOperDesc",OperDesc,"DHCHAI.DP.OROperDx")
	Set OpertorName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",OpertorName,"User.SSUser")
	Set MapTypeDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapTypeDicDesc,"DHCHAI.BT.Dictionary")
	Set MapAnesDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapAnesDicDesc,"DHCHAI.BT.Dictionary")
	Set MapIncDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapIncDicDesc,"DHCHAI.BT.Dictionary")
	Set MapHealDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapHealDicDesc,"DHCHAI.BT.Dictionary")
	Set MapASADicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapASADicDesc,"DHCHAI.BT.Dictionary")
	Set MapNNISDicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MapNNISDicDesc,"DHCHAI.BT.Dictionary")
	Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.InfPos")
	Set OperLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",OperLoc,"User.CTLoc")

	 Set return=OperDesc
	 Set return=return_"^"_OpertorName
	 Set return=return_"^"_OperDate
	 Set return=return_"^"_SttTime
	 Set return=return_"^"_EndDate
	 Set return=return_"^"_EndTime       
	 Set return=return_"^"_MapTypeDicDR
	 Set return=return_"^"_MapTypeDicDesc
	 Set return=return_"^"_MapAnesDicDR
	 Set return=return_"^"_MapAnesDicDesc
	 Set return=return_"^"_MapIncDicDR         
	 Set return=return_"^"_MapIncDicDesc
	 Set return=return_"^"_MapHealDicDR
	 Set return=return_"^"_MapHealDicDesc
	 Set return=return_"^"_MapASADicDR
	 Set return=return_"^"_MapASADicDesc          
	 Set return=return_"^"_MapNNISDicDR
	 Set return=return_"^"_MapNNISDicDesc
	 Set return=return_"^"_WBC
	 Set return=return_"^"_IncisionNum
	 Set return=return_"^"_LoseBlood
	 Set return=return_"^"_GotBlood          
	 Set return=return_"^"_IsSightGlass
	 Set return=return_"^"_IsImplants
	 Set return=return_"^"_IsOperInf
	 Set return=return_"^"_IsInHospInf
	 Set return=return_"^"_InfTypeID
	 Set return=return_"^"_InfTypeDesc
	 Set return=return_"^"_OperLocID
	 Set return=return_"^"_OperLoc
	 Set return=return_"^"_OperCatDrs
	 Set return=return_"^"_OperCatLists

	 Quit return
}

/// Creator：     liutao
/// CreatDate：   2022-12-02
/// Description:  保存数据源为编目或者病案首页的手术信息
/// Table：       DHCHAI.DP.OROperAnaes,
/// Input：       aEpisodeID: 就诊号
/// w ##class(DHCHAI.DPS.OROperAnaesSrv).SaveOperData(252)
ClassMethod SaveOperData(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeID)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set Config=##class(DHCHAI.BT.Config).GetValByCode("OperDataSourceConfig")
	Set OperAnaesDr=""
	If ((Config=2)||(Config=3)){ //数据源为编目或者病案首页

		Set OperAnaesDr=""
		Set xOperID =""
		For {
			Set xOperID = $o(^DHCHAI.DP.OROperationI("IndexEpisodeDr",EpisodeDr,xOperID))
			Quit:xOperID=""
		
			Set OperData = $g(^DHCHAI.DP.OROperationD(xOperID))
			Continue:OperData=""
		
			Set OperAnaesDr = ##class(DHCHAI.DP.OROperAnaes).SaveOper(xOperID)
		}
		If (+OperAnaesDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.OROperAnaes"
			Set ErrMethod = "SaveOper"
			Set ErrArgStr = $lb(aEpisodeID)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Quit:(+OperAnaesDr)<1 return
		Set return=OperAnaesDr
	}
	Quit return
}

}
