/// 名称: DHCHAI.IRS.INFDiagnosSrv
/// 描述: 医院感染诊断相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-07
Class DHCHAI.IRS.INFDiagnosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-03-28
/// Description:  查询出院感染诊断列表信息
/// Input:        aHospIDs :  院区
/// 			  aDateFrom : 开始日期
/// 			  aDateTo :   出院日期
/// 			  aAdmLoc :   科室
/// 			  aStatus :   处置状态
///               aMrNo :     病案号  
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFDiagnosSrv","QryDischInfDiag","","2019-09-25","2019-09-25","","","")
Query QryDischInfDiag(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmLoc As %String, aStatus As %String, aMrNo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeDr:%String,ActStatus:%String,ActOpinion:%String,InfDiagList:%String,InfPosDesc:%String,IRInfDate:%String,PapmiNo:%String,MrNo:%String,IsNewBaby:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,InDiagList:%String,MainDiagList:%String,FirstDiagList:%String,OPDiagList:%String")
{
}

ClassMethod QryDischInfDiagExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmLoc As %String, aStatus As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK

	Set aDateFrom = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo   = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

	Set MapCatID  = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("MapRule","DischINFDiag","")
	Quit:MapCatID="" $$$OK  // 维护出院感染诊断对照关系
	
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
				Set (ActStatus,ActOpinion)=""  // 处置状态
				Set DisInfID  = $o(^DHCHAI.IR.CCDiagnosI("IndexEpisodeDr",EpisodeDr,0))
				Set objDisInf = ##class(DHCHAI.IR.CCDiagnos).GetObjById(DisInfID)
				//出院诊断是否疑似由任务处判断 1
				Continue:'$IsObject(objDisInf)
				If ($IsObject(objDisInf)) {
					Set ActStatus  = objDisInf.IRStatus
					Set ActOpinion = objDisInf.IROpinion   // 处置意见
				}
				Continue:((aStatus'="")&&(aStatus'=ActStatus))
				Set:ActStatus'="" ActStatus=$s(ActStatus=1:"确诊",ActStatus=2:"疑似",ActStatus=3:"排除")
				
				// 1,出院感染诊断信息
				Set InfDiagList=""  
				// 1.1, 入院诊断信息
				Set (InDiagList,MainDiagList,FirstDiagList,OPDiagList)=""   
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",EpisodeDr,xID))
					Quit:xID=""
					Set objDiag=##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
					Continue:'$IsObject(objDiag)
					Continue:objDiag.MRIsActive'=1
					
					Set MRDiagDesc   = objDiag.MRDiagDesc   // 诊断名称
					Set MRDiagTpCode = objDiag.MRDiagTpCode // 诊断类型代码
					Set MRDiagSource = objDiag.MRDiagSource // 诊断来源（C临床、E首页、F编目、D出院诊断证明书）
					;Continue:MRDiagTpCode'="DIS"
					Continue:(MRDiagSource'="D")&&(MRDiagSource'="E")  //update 20190920
					Continue:InfDiagList[(","_MRDiagDesc)  
					// 判断出院诊断是否是感染诊断
					//出院诊断是否疑似由任务处判断 2
					//出院感染诊断查询 出院感染诊断只显示与感染相关的诊断。  --update zhoubo 2022-03-21
					Set IsInfDiagFlg =..CheckInfDiag(MRDiagDesc)
					Set:(IsInfDiagFlg=1) InfDiagList = InfDiagList_","_MRDiagDesc
					//Set InfDiagList = InfDiagList_","_MRDiagDesc
					//修改代码逻辑取其他相关诊断 add by chenjb
					Set:MRDiagTpCode="C008" InDiagList 		= InDiagList_","_MRDiagDesc			// 入院诊断
					Set:MRDiagTpCode="M" MainDiagList 		= MainDiagList_","_MRDiagDesc		// 主要诊断
					Set:MRDiagTpCode="PRE" FirstDiagList 	= FirstDiagList_","_MRDiagDesc  	// 初步诊断
					Set:MRDiagTpCode="OP" OPDiagList 		= OPDiagList_","_MRDiagDesc			// 门诊诊断
				}
				Set:InfDiagList'="" InfDiagList=$e(InfDiagList,2,$l(InfDiagList))
				Continue:InfDiagList=""
				
				Set:InDiagList'="" InDiagList		=$e(InDiagList,2,$l(InDiagList))
				Set:MainDiagList'="" MainDiagList	=$e(MainDiagList,2,$l(MainDiagList))
				Set:FirstDiagList'="" FirstDiagList	=$e(FirstDiagList,2,$l(FirstDiagList))
				Set:OPDiagList'="" OPDiagList		=$e(OPDiagList,2,$l(OPDiagList))
				// 2,取患者感染报告信息
				Set (InfPosDesc,IRInfDate)=""
				Set xRepTy=""
				For {
					Set xRepTy=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",EpisodeDr,xRepTy))
					Quit:xRepTy=""
					
					Set xRepID=""
					For {
						Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",EpisodeDr,xRepTy,xRepID))
						Quit:xRepID=""
						Set ReportID=xRepID
						Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
						Continue:'$IsObject(objReport)
						If $IsObject(objReport.IRStatusDr) {
							Set ReportStatusID=objReport.IRStatusDr.%Id()
							Set ReportStatusCode=objReport.IRStatusDr.BTCode
							Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
						}
						Continue:ReportStatusDesc="删除"
						Set arrInfDiag=objReport.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
						For IndD=1:1:arrInfDiag.Count(){
							Set objDias=arrInfDiag.GetAt(IndD)
							Continue:'$IsObject(objDias)
							Continue:'$IsObject(objDias.IRInfPosDr)
							// 感染部位
							Set InfPosID =objDias.IRInfPosDr.%Id()
							Set xInfPosDesc=objDias.IRInfPosDr.BTDesc
							Continue:xInfPosDesc=""
							Set InfPosDesc=InfPosDesc_","_xInfPosDesc
							// 感染日期
							If (objDias.IRInfDate'="") {
								Set xTmpDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objDias.IRInfDate)
								Set IRInfDate=IRInfDate_","_xTmpDate
							}
						}
						Set:InfPosDesc'="" InfPosDesc=$e(InfPosDesc,2,$l(InfPosDesc))
						Set:IRInfDate'="" IRInfDate=$e(IRInfDate,2,$l(IRInfDate))
					}
				}
				// 3,取患者基本信息
				Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
				Continue:'$isobject(objPaadm)
				
				Set PapmiNo = objPaadm.PAPapmiNo
				Set MrNo    = objPaadm.PAMrNo
				Set PatName = objPaadm.PAPatName
				Set IsNewBaby = objPaadm.PAIsNewBaby
				Continue:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo)
				Set Sex = objPaadm.PASex
				Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
				Set Age = objPaadm.PAAge
				Set AdmDate = objPaadm.PAAdmDate
				Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
				Set AdmTime = objPaadm.PAAdmTime
				Set:AdmTime'="" AdmTime=$zt(AdmTime)
				Set objAdmLoc = objPaadm.PAAdmLocDr
				Set AdmLocDesc=""
				If $isobject(objAdmLoc) {
					Set LocDesc2 = objAdmLoc.BTDesc2
					Set LocDesc  = objAdmLoc.BTDesc
					Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
					Set HospGroupID=""
					If $isobject(objPaadm.PAAdmLocDr.BTHospDr){
						Set HospID=objPaadm.PAAdmLocDr.BTHospDr.%Id()
						Continue:($g(aHospIDs)'="")&($listfind($g(aHospIDs),HospID)<1)	//医院过滤
					}
					Continue:($g(aAdmLoc)'="")&&($g(aAdmLoc)'=objAdmLoc.%Id())  //科室过滤
				}
				Set DischDate = objPaadm.PADischDate
				Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
				Set DischTime = objPaadm.PADischTime
				Set:DischTime'="" DischTime=$zt(DischTime)
				Set objDischLoc = objPaadm.PADischLocDr
				Set DischLocDesc=""   // 出院科室
				If $isobject(objDischLoc) {
					Set LocDesc2 = objDischLoc.BTDesc2
					Set LocDesc = objDischLoc.BTDesc
					Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
				}
				
				Set Data=$lb(ind,EpisodeDr,ActStatus,ActOpinion,InfDiagList,InfPosDesc,IRInfDate,PapmiNo,MrNo,IsNewBaby,PatName,Sex,Age,AdmDate,AdmTime,AdmLocDesc,DischDate,DischTime,DischLocDesc,InDiagList,MainDiagList,FirstDiagList,OPDiagList)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}				
		}
	}
	Quit $$$OK
}

ClassMethod QryDischInfDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischInfDiagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDischInfDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischInfDiagExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  根据数据标化规则判断诊断是否是感染诊断
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       aDiagDesc : 诊断名称
/// Return：      返回1：是  0：否
/// w ##Class(DHCHAI.IRS.INFDiagnosSrv).CheckInfDiag("新生儿肺炎")
ClassMethod CheckInfDiag(aDiagDesc As %String) As %String
{
	New (aDiagDesc)
	Set return=0
	Quit:(aDiagDesc="") return
	
	Set MapCatObj =##class(DHCHAI.BT.Dictionary).GetObjByCode("MapRule","DischINFDiag")
	Quit:'$Isobject(MapCatObj) return
	Set MapCatID=MapCatObj.%Id()
	//Set MapCatID  = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("MapRule","DischINFDiag","")		
	Quit:MapCatID="" return  // 未维护出院感染诊断对照关系
    //update 20190920
    Set xMapDesc="",MapFlg2=1    // 排除
	For {
		Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",MapCatID,2,xMapDesc))
		Quit:((xMapDesc="")||(MapFlg2=0))
	 
	    Set MapFlg2=0
		Continue:(aDiagDesc[xMapDesc)
		Set MapFlg2=1
	}
   Quit:MapFlg2=0 0
   
    Set xMapDesc="",MapFlg=0    // 匹配
	For {
		Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",MapCatID,0,xMapDesc))
		Quit:((xMapDesc="")||(MapFlg=1))
	  
	   	Continue:(aDiagDesc'=xMapDesc)
		Set MapFlg=1		
	}	
	Quit:MapFlg=1 1
	
	Set xMapDesc="",MapFlg1=0    // 包含
	For {
		Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",MapCatID,1,xMapDesc))
		Quit:((xMapDesc="")||(MapFlg1=1))
	  
		Continue:(aDiagDesc'[xMapDesc)
		Set MapFlg1=1
	}

	Quit:MapFlg1=1 1
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-08-25
/// Description:  查询医院感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input:        aRepType(多个报告类型以|分割)
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFDiagnosSrv","QryRepInfoByDateLoc","1","2020-02-02","2022-02-02","","","1","","","","1","",4)
/// 新增三个返回字段INFLabDesc:病原学检验,INFOPSDesc:手术信息,INFAntiDesc:抗菌用药信息,caogang,2022-07-25
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "", aInfDiags As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,TransID:%String,TransLocID:%String,TransLocDesc:%String,ReportTypeID:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusCode:%String,ReportStatusDesc:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,IsDeath:%String,DiasID:%String,InfPos:%String,InfDiag:%String,InfLocDesc:%String,InfEffectCode:%String,InfEffectDesc:%String,Specimen:%String,InfPath:%String,IsHaveHisRep:%String,EncryptLevel:%String,PatLevel:%String,InfEffectDate:%String,IRInfDate:%String,InfPosID:%String,InfDiagID:%String,InfDiags:%String,InfLoc:%String,RepType:%String,ReturnReason:%String,CheckUser:%String,CheckDate:%String,INFLabDesc:%String,INFOPSDesc:%String,INFAntiDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepInfoByDateLocExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospIDs As %String, aInfLoc As %String = "", aInfDiags As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	//默认查询感染报告
	Set:aRepType="" aRepType = "1"
	
	//获取科室相关性
	Set:aRepLoc'="" relevLocRep=##class(DHCHAI.BTS.LocRelevantSrv).GetLocListByLoc("WestEstLocRelev",aRepLoc)
	Set:aInfLoc'="" relevLocInf=##class(DHCHAI.BTS.LocRelevantSrv).GetLocListByLoc("WestEstLocRelev",aInfLoc)
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	//add for 增加支持(成人|新生儿)报告同时查询
	For Ind = 1:1:$length(aRepType,"|"){
	Set xRepType = $p(aRepType,"|",Ind)
	Continue:xRepType=""
		//按报告日期查询
		If aDateType=1 {
			Set xDate=aDateFrom-1
			For {
				//Set xDate=$o(^DHCHAI.IR.INFReportI("IndexRepDate",aRepType,xDate))
				Set xDate=$o(^DHCHAI.IR.INFReportI("IndexRepDate",xRepType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
						
				Set xRepID=0
				For {
					//Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate",aRepType,xDate,xRepID))
					Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate",xRepType,xDate,xRepID))
					Quit:xRepID=""
					
					Set ReportID=xRepID
					Do BuildReportData
				}
				
			}
		}
		//按入院日期查询
		If aDateType=2 {
			For xDate=aDateFrom:1:aDateTo {
				Set xTime=""
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime","I",xDate,xTime))
					Quit:xTime=""
					
					Set xPaadm =0
					For {
						Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime","I",xDate,xTime,xPaadm))
						Quit:xPaadm=""
						
						Set xRepID=0
						For {
							//Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,aRepType,xRepID))
							Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,xRepType,xRepID))
							Quit:xRepID=""
							
							Set ReportID=xRepID
							Do BuildReportData
						}
					}				
				}
			}
		}
		//按出院日期查询
		If aDateType=3 {
			For xDate=aDateFrom:1:aDateTo {
				Set xTime=""
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime))
					Quit:xTime=""
					
					Set xPaadm =0
					For {
						Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime,xPaadm))
						Quit:xPaadm=""
						
						Set xRepID=0
						For {
							//Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,aRepType,xRepID))
							Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,xRepType,xRepID))
							Quit:xRepID=""
							
							Set ReportID=xRepID
							Do BuildReportData
						}
					}				
				}
			}
		}
		//按感染日期查询        
		If aDateType=4 {
			Set RepList=""
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xDiaID=0
				For {
					Set xDiaID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xDiaID))
					Quit:xDiaID=""
					
					Set objDia=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiaID)
					Continue:'$Isobject(objDia)
					Continue:'$Isobject(objDia.IREpisodeDr)
					
					Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiaID)
					Continue:arrInfRep.Count()<1
					For indIR=1:1:arrInfRep.Count() {
						Set objInfRep=arrInfRep.GetAt(indIR)
						Continue:'$IsObject(objInfRep)
						Set InfRepType=objInfRep.IRRepType
						Continue:(InfRepType'=1)  //感染报告 
						Set ReportID=objInfRep.%Id()
						Continue:$listfind(RepList,ReportID)>0
						Set RepList=RepList_$lb(ReportID)
						
						Do BuildReportData
					}
				}
			}
		}
	}
	Quit $$$OK
	
BuildReportData
	Set (AdmitDate,AdmitTime,DischDate,AdmLoc,AdmWard,AdmBed,PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge,IsDeath)=""
	Set (EpisodeID,TransID,TransLocID,TransLocDesc,ReportTypeID,ReportTypeDesc)=""
	Set (ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)=""
	Set (ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
	Set (DiasID,InfPosDesc,InfDiagDesc,InfLocDesc,InfEffectCode,InfEffectDesc,SpecimenDesc,TestResults)=""
	Set (EncryptLevel,PatLevel,InfEffectDate,IRInfDate,InfPosID,InfDiagID,InfDiags,InfLoc,RepType)=""
	Set (INFLabDesc,INFOPSDesc,INFAntiDesc)=""
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
	Quit:'$IsObject(objReport)
	//Quit:(aRepType'="")&(objReport.IRRepType'=aRepType)
	Quit:(aRepType'="")&(objReport.IRRepType'=xRepType)
	Set RepType = objReport.IRRepType
	
	If $IsObject(objReport.IRStatusDr) {
		Set ReportStatusID=objReport.IRStatusDr.%Id()
		Set ReportStatusCode=objReport.IRStatusDr.BTCode
		Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
	}
	Quit:(aRepStatus'="")&&(ReportStatusID'=aRepStatus)
		
	Set objRepLoc=objReport.IRRepLocDr
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.%Id()
		Set ReportLocDesc=objRepLoc.BTDesc2
		Set:ReportLocDesc="" ReportLocDesc=objRepLoc.BTDesc
		If $IsObject(objReport.IRRepLocDr.BTHospDr){
			Set HospID=objReport.IRRepLocDr.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	//Quit:(aRepLoc'="")&&(ReportLocID'=aRepLoc)
	Quit:(aRepLoc'="")&&($ListFind(relevLocRep,ReportLocID)<1)
	
	Set objPaadm=objReport.IREpisodeDr
	Quit:'$IsObject(objPaadm)
	Set EpisodeID = objPaadm.%Id()
	
	
	Set AdmitDate=objPaadm.PAAdmDate
	If (AdmitDate'="")
	{
		Set AdmitDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmitDate)
	}
	Set AdmitTime=objPaadm.PAAdmTime
	Set DischDate=objPaadm.PADischDate
	If (DischDate'="")
	{
		Set DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	}
	Set AdmLoc=objPaadm.PAAdmLocDr.BTDesc2
	Set AdmWard=objPaadm.PAAdmWardDr.BTDesc2
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	Set PatientID=objPaadm.PAPatientIDx
	Set PapmiNo=objPaadm.PAPapmiNo
	Set:aRegNo'="" aRegNo=$ZCVT($g(aRegNo),"W")	//登记号大小写转换
	Quit:(aRegNo'="")&&(PapmiNo'=aRegNo)
	
	Set PatName=objPaadm.PAPatName
	Quit:(aPatName'="")&&($zcvt(PatName,"U")'[$zcvt(aPatName,"U"))
	
	Set PatMrNo=objPaadm.PAMrNo
	Set:aMrNo'="" aMrNo=$ZCVT($g(aMrNo),"W")	//病案号大小写转换---201404299 yanjifu
	Quit:(aMrNo'="")&&(PatMrNo'=aMrNo)
	
	Set PatAge=objPaadm.PAAge
	Set IsDeath = objPaadm.PAIsDeath
	Set PatSex=objPaadm.PASex
	Set PatSex=$s(PatSex="M":"男",PatSex="F":"女",1:"")
	//病人密级
	Set EncryptLevel =""
	//病人级别
	Set PatLevel =""
	
	Set InfLocFlag=""
	//感染科室 感染日期 感染诊断 感染子诊断 疾病转归 转归日期
	Set (InfDiagIDList,InfEffectCodeList,InfEffectDateList,IRInfDateList,IRInfLocList,InfPosID)=""
	Set arrInfDiag=objReport.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
	For IndD=1:1:arrInfDiag.Count(){
		Set objDias=arrInfDiag.GetAt(IndD)
		Continue:'$IsObject(objDias)
		Continue:'$IsObject(objDias.IRInfPosDr)
		Set DiasID=DiasID_","_objDias.%Id()
		Set InfPosID =objDias.IRInfPosDr.%Id()
		Set xInfPosDesc=objDias.IRInfPosDr.BTDesc
		Continue:xInfPosDesc=""
		//多语言
		Set xInfPosDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",xInfPosDesc,"DHCHAI.BT.InfPos")       //感染部位/感染诊断	
		If $IsObject(objDias.IRInfSubDr) {
			Set xInfDiagDesc=objDias.IRInfSubDr.BTDesc
			//多语言
			Set xInfDiagDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",xInfDiagDesc,"DHCHAI.BT.InfSub")       //感染诊断分类
			Set:xInfDiagDesc'="" xInfPosDesc=xInfPosDesc_"（"_xInfDiagDesc_"）"
			Set InfDiagID = objDias.IRInfSubDr.%Id()
			Continue:$listfind(InfDiagIDList,InfDiagID)>0
			Set InfDiagIDList=InfDiagIDList_$lb(InfDiagID)
			Set InfDiagDesc=InfDiagDesc_","_xInfDiagDesc
		}
		Set InfPosDesc=InfPosDesc_","_xInfPosDesc
	
	    If $IsObject(objDias.IRInfEffectDr) {
		    Set xInfEffectDesc=objDias.IRInfEffectDr.BTDesc
		    If xInfEffectDesc'="" {
				Set InfEffectCode = objDias.IRInfEffectDr.%Id()
				Continue:$listfind(InfEffectCodeList,InfEffectCode)>0
				Set InfEffectCodeList=InfEffectCodeList_$lb(InfEffectCode)
				Set InfEffectDesc=InfEffectDesc_","_xInfEffectDesc
		    }
		}
		If (objDias.IRInfXDate'="") {
			Set xTmpDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objDias.IRInfXDate)
			Continue:$listfind(InfEffectDateList,xTmpDate)>0
			Set InfEffectDateList=InfEffectDateList_$lb(xTmpDate)
			Set InfEffectDate=InfEffectDate_","_xTmpDate
		}
		If (objDias.IRInfDate'="") {
			Set xTmpDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objDias.IRInfDate)
			Continue:$listfind(IRInfDateList,xTmpDate)>0
			Set IRInfDateList=IRInfDateList_$lb(xTmpDate)
			Set IRInfDate=IRInfDate_","_xTmpDate
		}
		If $IsObject(objDias.IRInfLocDr) {
			Set IRInfLoc = objDias.IRInfLocDr.BTDesc2
			Set:IRInfLoc="" IRInfLoc=objDias.IRInfLocDr.BTDesc
			Continue:$listfind(IRInfLocList,IRInfLoc)>0
			Set IRInfLocList=IRInfLocList_$lb(IRInfLoc)
			Set InfLocDesc=InfLocDesc_","_IRInfLoc
			Set InfLoc = objDias.IRInfLocDr.%Id()
			//Set:(aInfLoc'="")&&(aInfLoc=InfLoc) InfLocFlag=1
			Set:(aInfLoc'="")&&($ListFind(relevLocInf,InfLoc)>0) InfLocFlag=1
		}
	}
	Quit:(aInfLoc'="")&&(InfLocFlag'=1)
	Set:DiasID'="" DiasID=$e(DiasID,2,$l(DiasID))
	Set:InfPosDesc'="" InfPosDesc=$e(InfPosDesc,2,$l(InfPosDesc))
	Set:InfDiagDesc'="" InfDiagDesc=$e(InfDiagDesc,2,$l(InfDiagDesc))
	Set:InfEffectDesc'="" InfEffectDesc=$e(InfEffectDesc,2,$l(InfEffectDesc))
	Set:InfEffectDate'="" InfEffectDate=$e(InfEffectDate,2,$l(InfEffectDate))
	Set:InfLocDesc'="" InfLocDesc=$e(InfLocDesc,2,$l(InfLocDesc))
	Set:IRInfDate'="" IRInfDate=$e(IRInfDate,2,$l(IRInfDate))
	//add 20220816，caogang
	//取病原学检验信息:检验医嘱名及检出菌
	Set arrInfLab=objReport.GetRepLinkObjs("DHCHAI.IR.INFLab")
	For IndL=1:1:arrInfLab.Count(){
		Set objInfLab=arrInfLab.GetAt(IndL)
		Continue:'$IsObject(objInfLab)
		Set TSDesc = objInfLab.IRTSDesc
		//多语言
		Set TSDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("CName",TSDesc,"dbo.BTTestSet")  //检验医嘱
		Set INFLabDesc=INFLabDesc_TSDesc
		Set aInfLabID=objInfLab.%Id()	
		Continue:aInfLabID=""
		Set xIndexEpisodeLabRepDr=""
		For{
			Set xIndexEpisodeLabRepDr=$o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",aInfLabID,xIndexEpisodeLabRepDr))
			Quit:xIndexEpisodeLabRepDr=""
			Set xLabBactID=0
			For{
				Set xLabBactID=$o(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",aInfLabID,xIndexEpisodeLabRepDr,xLabBactID))
				Quit:xLabBactID=""
			
				Set BactID=aInfLabID_"||"_xLabBactID
				Set INFLabBactobj=##class(DHCHAI.IR.INFLabBact).GetObjById(BactID)
				Continue:INFLabBactobj=""
				Set BactDesc =INFLabBactobj.IRBactDesc
				//多语言
				Set BactDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BactDesc,"DHCHAI.DP.LabBacteria")       //细菌名称
				Set INFLabDesc=INFLabDesc _"("_BactDesc_")"
			}
		}
		
		//每条检验信息以";"隔离
		If (IndL<arrInfLab.Count()){
			Set INFLabDesc=INFLabDesc_";"
		}
		
	}
	
	//手术信息,手术名称
	Set arrInfOPS=objReport.GetRepLinkObjs("DHCHAI.IR.INFOPS")
	For IndO=1:1:arrInfOPS.Count(){
		Set objInfOPS=arrInfOPS.GetAt(IndO)
		Continue:'$IsObject(arrInfOPS)
		
		Set INFOPSDesc=INFOPSDesc_";"_objInfOPS.IROperName
	}
	Set INFOPSDesc=$e(INFOPSDesc,2,$l(INFOPSDesc))
	
	//抗菌用药信息,抗生素名称
	Set arrInfAnti=objReport.GetRepLinkObjs("DHCHAI.IR.INFAnti")
	For IndA=1:1:arrInfAnti.Count(){
		Set objInfAnti=arrInfAnti.GetAt(IndA)
		Continue:'$IsObject(objInfAnti)
		Set AntiDesc = objInfAnti.IRAntiDesc
		Set AntiDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",AntiDesc,"User.ARCItmMast")  //医嘱
		Set INFAntiDesc=INFAntiDesc_";"_AntiDesc
	}
	Set INFAntiDesc=$e(INFAntiDesc,2,$l(INFAntiDesc))
	
	Set:objReport.IRRepType=2 IRInfDate=$p(IRInfDate,",",1)   //新生儿感染报告只有一个感染日期
	Set:objReport.IRRepType=2 InfPosDesc=$p(InfPosDesc,",",1)
	
	Set objRepUser=objReport.IRRepUser
	If $IsObject(objRepUser) {
		Set ReportUserID=objRepUser.%Id()
		Set ReportUserDesc=objRepUser.BTDesc
	}
	Set ReportDate=objReport.IRRepDate
	Set:ReportDate'="" ReportDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ReportDate)
	Set ReportTime=objReport.IRRepTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	
	//判断是否有历史报告
	Set IsHaveHisRep="N"
	Set ReturnReason=""
	Set xLogDr=""
	For {
		Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
		Quit:(xLogDr="")||(ReturnReason'="")
		Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
		Continue:'$IsObject(objLog)
		Continue:'$IsObject(objLog.IRStatusDr)
		Set StatusCode=objLog.IRStatusDr.BTCode
		Continue:(StatusCode'="5")   // 退回
		Set ReturnReason = objLog.IROpinion
	}
	//审核人+审核时间	
	Set CheckFlag="0"
	Set CheckUser="",CheckDate=""
	Set xLogDr=""
	For {
		Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
        Quit:(xLogDr="")
		Quit:CheckFlag="1"
		Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
		Continue:'$IsObject(objLog)
		Continue:'$IsObject(objLog.IRStatusDr)
		
		Set StatusCode=objLog.IRStatusDr.BTCode
		if (StatusCode="3"){   //审核状态
			Set CheckUser=objLog.IRUpdateUserDr.BTDesc
			Set CheckDate=objLog.IRUpdateDate
			Set:CheckDate'="" CheckDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CheckDate)
			Set CheckFlag="1"
		}
        Quit    //只看最后一个状态
	}
	//过滤感染诊断
	Quit:(aInfDiags'="")&&((","_aInfDiags_",")'[(","_InfPosID_","))
	
	//多语言处理
	Set PatSex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",PatSex,"User.CTSex")  //性别
	Set:PatAge["岁" PatAge=$Replace(PatAge,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
	Set:PatAge["月" PatAge=$Replace(PatAge,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:PatAge["天" PatAge=$Replace(PatAge,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	
	Set TransLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",TransLocDesc,"User.CTLoc")    //转科科室
	Set ReportLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",ReportLocDesc,"User.CTLoc")  //报告科室
	Set InfLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",InfLocDesc,"User.CTLoc")        //感染科室
	Set AdmLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLoc,"User.CTLoc")                //就诊科室
	Set AdmWard=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWard,"User.CTLoc")              //就诊病区

	Set ReportUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",ReportUserDesc,"User.SSUser")  //报告人
	Set CheckUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",CheckUser,"User.SSUser")            //审核人
	
	Set ReportTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ReportTypeDesc,"DHCHAI.BT.Dictionary")      //报告类型
	Set ReportStatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ReportStatusDesc,"DHCHAI.BT.Dictionary")  //报告状态
	Set InfEffectDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfEffectDesc,"DHCHAI.BT.Dictionary")        //转归情况
    
	Set Data=$lb(ReportID,EpisodeID,TransID,TransLocID,TransLocDesc,ReportTypeID,ReportTypeDesc)
	Set Data=Data_$lb(ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)
	Set Data=Data_$lb(ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)
	Set Data=Data_$lb(AdmitDate,DischDate,AdmLoc,AdmWard,AdmBed,PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge,IsDeath)
	Set Data=Data_$lb(DiasID,InfPosDesc,InfDiagDesc,InfLocDesc,InfEffectCode,InfEffectDesc,SpecimenDesc,TestResults,IsHaveHisRep)
	Set Data=Data_$lb(EncryptLevel,PatLevel,InfEffectDate,IRInfDate,InfPosID,InfDiagID,InfDiags,InfLoc,RepType,ReturnReason)
	Set Data=Data_$lb(CheckUser,CheckDate,INFLabDesc,INFOPSDesc,INFAntiDesc)
	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryRepInfoByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
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

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Description:  通过感染报告ID查询报告医院感染诊断
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFDiagnosSrv","QryINFDiagByRep","","4309","")
Query QryINFDiagByRep(aReportID As %String, aEpisodeID As %String, aSurvID As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,InfPosID:%String,InfPos:%String,InfSubID:%String,InfSub:%String,InfDate:%String,InfLocID:%String,InfLoc:%String,InfDiagnosisBasis:%String,InfDiseaseCourse:%String,InfXDate:%String,InfEffectID:%String,InfEffect:%String,DeathRelationID:%String,DeathRelation:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,IsReportDiag:%String,Bacteria:%String,IsActive:%String,IsActDesc:%String,InfType:%String,InfTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryINFDiagByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, aSurvID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aSurvID=$g(aSurvID)
 	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
 	
 	If aReportID'="" {
	 	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
		Quit:'$IsObject(objRep) $$$OK
		Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
		
		Set LinkDiags=objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		Quit:LinkDiags="" $$$OK
		For indD=1:1:$l(LinkDiags,",") {
			Set xID=$p(LinkDiags,",",indD)
			Continue:xID=""
			Set Data=..BuildINFDiagData(xID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
 	}else{
	 	If aSurvID="" {
			Set xID=""
			For {
				Set xID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
				Quit:xID=""
				// 过滤临床上报的诊断
				Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
				Continue:'$IsObject(objINFDiagnos)
				Continue:objINFDiagnos.IRIsReportDiag=1
				
				// 已经关联有效感染报告过滤
				Set listReports = ##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
				Continue:listReports.Count()>0
		 
				Set Data = ..BuildINFDiagData(xID)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data
		    	Set ind=ind+1
			}
	 	} Else {
		 	//附加参数 横断面ID 现患率调查 过滤
		 	Set objSExec=##class(DHCHAI.IR.SurveyExec).GetObjById(aSurvID)
			Quit:'$IsObject(objSExec) $$$OK
 			Set SurvSttDate=objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 			Set SurvEndDate=objSExec.SESurvEndDate
 			
		 	Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.IRInfPosDr)
				Set InfDiagnosDr=obj.%Id()
				Set InfPosDr=obj.IRInfPosDr.%Id()
				Set InfPosDesc=obj.IRInfPosDr.BTDesc
				
				Set InfDate=obj.IRInfDate
				Continue:InfDate=""
				Set InfXDate=obj.IRInfXDate
				Set InfPosDesc=obj.IRInfPosDr.BTDesc
				Set InfSubDesc=""
				If $IsObject(obj.IRInfSubDr) {
					Set InfSubDesc=obj.IRInfSubDr.BTDesc
				}
				Set IsReportDiag=obj.IRIsReportDiag
				
				Continue:InfDate>SurvSttDate  //调查时未感染开始
				Continue:((+InfXDate)>0)&(InfXDate<=SurvSttDate)  //调查时感染已结束
				
				// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
				Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
				Set ReportCnt=listReports.Count()
				If (IsReportDiag=1)&&(ReportCnt<1){
					Continue
				}
				
				Set Data = ..BuildINFDiagData(xID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
		    	Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryINFDiagByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFDiagByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFDiagByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFDiagByRepExecute ]
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

/// 取单个疾病诊断信息
ClassMethod BuildINFDiagData(aINFDiagID As %String) As %String
{
	New (aINFDiagID,%session)
	Set return=""
	Quit:aINFDiagID="" return
	
	Set INFDiagnosData=$g(^DHCHAI.IR.INFDiagnosD(aINFDiagID))
	Quit:INFDiagnosData="" return
	
	Set EpisodeID=$lg(INFDiagnosData,2)
	
	Set (InfPosID,InfPos,InfPosData)=""
	Set InfPosID = $lg(INFDiagnosData,3)
	Set:InfPosID'="" InfPosData=$g(^DHCHAI.BT.InfPosD(InfPosID))
	Set:InfPosData'="" InfPos=$lg(InfPosData,3)
	
	Set (InfSubID,InfSub,InfSubData)=""
	Set InfSubID = $lg(INFDiagnosData,4)
	Set:InfSubID'="" InfSubData=$g(^DHCHAI.BT.InfSubD(InfSubID))
	Set:InfSubData'="" InfSub=$lg(InfSubData,3)
	
	Set InfDate = $lg(INFDiagnosData,5)
	Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	
	Set (InfLocID,InfLoc,LocDesc2,LocDesc,InfLocData)=""
	Set InfLocID = $lg(INFDiagnosData,6)
	Set:InfLocID'="" InfLocData=$g(^DHCHAI.BT.LocationD(InfLocID))
	Set:InfLocData'="" LocDesc2=$lg(InfLocData,4)
	Set:InfLocData'="" LocDesc=$lg(InfLocData,3)
	Set InfLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	
	Set InfDiagnosisBasis = $lg(INFDiagnosData,12)
	Set InfDiseaseCourse = $lg(INFDiagnosData,13)
	Set InfXDate = $lg(INFDiagnosData,7)
	Set:InfXDate'="" InfXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
	
	Set (InfEffectID,InfEffect,InfEffectData)=""
	Set InfEffectID = $lg(INFDiagnosData,8)
	Set:InfEffectID'="" InfEffectData=$g(^DHCHAI.BT.DictionaryD(InfEffectID))
	Set:InfEffectData'="" InfEffect=$lg(InfEffectData,3)
	
	Set (DeathRelationID,DeathRelation,DeathRelationData)=""
	Set DeathRelationID = $lg(INFDiagnosData,14)
	Set:DeathRelationID'="" DeathRelationData=$g(^DHCHAI.BT.DictionaryD(DeathRelationID))
	Set:DeathRelationData'="" DeathRelation=$lg(DeathRelationData,3)
	
	Set UpdateDate = $lg(INFDiagnosData,9)
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = $lg(INFDiagnosData,10)
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	
	Set (UpdateUserID,UpdateUser)=""
	Set UpdateUserID = $lg(INFDiagnosData,11)
	Set:UpdateUserID'="" UpdateUserData=$g(^DHCHAI.BT.SysUserD(UpdateUserID))
	Set:UpdateUserData'="" UpdateUser=$lg(UpdateUserData,3)
	
	Set IsReportDiag = $lg(INFDiagnosData,15)	// 是否临床上报诊断
	
	Set Bacteria =$lg(INFDiagnosData,16)
	Set IsActive = $lg(INFDiagnosData,17)
	Set IsActDesc = $s(IsActive=1:"是",1:"否")
	Set InfType = $lg(INFDiagnosData,18)
	Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")
	//多语言处理
	Set InfPos=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfPos,"DHCHAI.BT.InfPos")
	Set InfLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",InfLoc,"User.CTLoc")
	Set return = $lb(aINFDiagID,EpisodeID,InfPosID,InfPos,InfSubID,InfSub,InfDate,InfLocID,InfLoc,InfDiagnosisBasis,InfDiseaseCourse,InfXDate,InfEffectID,InfEffect,DeathRelationID,DeathRelation,UpdateDate,UpdateTime,UpdateUserID,UpdateUser,IsReportDiag,Bacteria,IsActive,IsActDesc,InfType,InfTypeDesc)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-03-15
/// Description:  根据ID取感染诊断信息
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       aID : DHCHAI.IR.INFDiagnos.%Id()
/// Return：      返回String
/// w ##class(DHCHAI.IRS.INFDiagnosSrv).GetStrByRowID("13")
ClassMethod GetStrByRowID(aID As %String) As %String
{
	New (aID,%session)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set:$IsObject(obj.IREpisodeDr) EpisodeDr=obj.IREpisodeDr.%Id()
	Set:$IsObject(obj.IRInfPosDr) InfPosDr=obj.IRInfPosDr.%Id()
	Set:$IsObject(obj.IRInfPosDr) InfPos=obj.IRInfPosDr.BTDesc
	Set:$IsObject(obj.IRInfSubDr) InfSubDr=obj.IRInfSubDr.%Id()
	Set:$IsObject(obj.IRInfSubDr) InfSub=obj.IRInfSubDr.BTDesc
	Set:$IsObject(obj.IRInfLocDr) InfLocDr=obj.IRInfLocDr.%Id()
	If ($IsObject(obj.IRInfLocDr)){
		Set InfLoc=obj.IRInfLocDr.BTDesc2
		Set:InfLoc="" InfLoc=obj.IRInfLocDr.BTDesc
	}
	Set:$IsObject(obj.IRInfEffectDr) InfEffectDr=obj.IRInfEffectDr.%Id()
	Set:$IsObject(obj.IRInfEffectDr) InfEffect=obj.IRInfEffectDr.BTDesc
	Set:$IsObject(obj.IRDeathRelationDr) DeathRelationDr=obj.IRDeathRelationDr.%Id()
	Set:$IsObject(obj.IRDeathRelationDr) DeathRelation=obj.IRDeathRelationDr.BTDesc
	//Set:obj.IRInfDate'="" InfDate=$zd(obj.IRInfDate,3)
	//Set:obj.IRInfXDate'="" InfXDate=$zd(obj.IRInfXDate,3)
	Set:obj.IRInfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(obj.IRInfDate)
	Set:obj.IRInfXDate'="" InfXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(obj.IRInfXDate)
	
	Set $p(return,"^",1)=$g(EpisodeDr)				// 就诊记录
	Set $p(return,"^",2)=$g(InfPosDr)				// 感染部位ID/感染诊断ID
	Set $p(return,"^",3)=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",$g(InfPos),"DHCHAI.BT.InfPos")				// 感染部位/感染诊断
	Set $p(return,"^",4)=$g(InfSubDr)				// 感染分类ID
	Set $p(return,"^",5)=$g(InfSub)					// 感染分类
	Set $p(return,"^",6)=$g(InfDate)				// 感染日期
	Set $p(return,"^",7)=$g(InfLocDr)				// 感染科室ID
	Set $p(return,"^",8)=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",$g(InfLoc),"User.CTLoc")					// 感染科室
	Set $p(return,"^",9)=obj.IRInfDiagnosisBasis	// 诊断依据
	Set $p(return,"^",10)=obj.IRInfDiseaseCourse	// 感染性疾病病程
	Set $p(return,"^",11)=$g(InfXDate)				// 感染转归日期
	Set $p(return,"^",12)=$g(InfEffectDr)			// 感染转归/疗效ID
	Set $p(return,"^",13)=$g(InfEffect)				// 感染转归/疗效
	Set $p(return,"^",14)=$g(DeathRelationDr)		// 与死亡关系ID
	Set $p(return,"^",15)=$g(DeathRelation)			// 与死亡关系
	Set $p(return,"^",16)=obj.IRIsReportDiag		// 是否临床上报诊断
	Set $p(return,"^",17)=obj.IRBacteria
	Set $p(return,"^",18)=obj.IRIsActive 
	Set $p(return,"^",19)=obj.IRInfType
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-06-21
/// Description:  根据报告感染分类诊断取新生儿诊断ID
/// Table：       DHCHAI.IR.INFReport，DHCHAI.IR.INFDiagnos
/// Input：       aReportID : DHCHAI.IR.INFReport.ID
///               aInfSubID : DHCHAI.BT.InfSub.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.INFDiagnosSrv).GetDiagID("140","22")
ClassMethod GetDiagID(aReportID As %String, aInfSubID As %String) As %String
{
	New (aReportID,aInfSubID)
	Set return=""
	Quit:(aInfSubID="")||(aInfSubID="") return
	
	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
		
	Set LinkDiags=objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
	Quit:LinkDiags="" return
	For indD=1:1:$l(LinkDiags,",") {
		Set xID=$p(LinkDiags,",",indD)
		Continue:xID=""
		
		Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
		Continue:'$IsObject(objINFDiagnos) 
		Continue:'$IsObject(objINFDiagnos.IREpisodeDr) 
	    Continue:'$IsObject(objINFDiagnos.IRInfSubDr) 
		Set InfSubID = objINFDiagnos.IRInfSubDr.%Id()
		Continue:InfSubID'=aInfSubID
	    Set return =xID
	}
			
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-06-24
/// Description:  通过就诊查询本次就诊感染报告信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFDiagnosSrv","QryInfRepList","91")
Query QryInfRepList(aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,InfPosID:%String,InfPos:%String,InfSubID:%String,InfSub:%String,InfDate:%String,InfLocID:%String,InfLoc:%String,InfDiagnosisBasis:%String,InfDiseaseCourse:%String,InfXDate:%String,InfEffectID:%String,InfEffect:%String,DeathRelationID:%String,DeathRelation:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,IsReportDiag:%String,Bacteria:%String,IsActive:%String,IsActDesc:%String,InfType:%String,InfTypeDesc:%String,ReportID:%String,RepStatus:%String,ReportDate:%String,ReportTime:%String,ReportLocDesc:%String,ReportUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfRepListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK	
 	Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID)) $$$OK

	Set xType= ""
	For {
		Set xType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xType))
		Quit:xType=""
		Continue:(xType'=1)&&(xType'=2)
		
		Set xRepID = ""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xType,xRepID))
			Quit:xRepID=""
		
			Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Quit:'$IsObject(objRep)
			Continue:'$IsObject(objRep.IRStatusDr)
			Set RepStatus = objRep.IRStatusDr.BTDesc
			Set objRepLoc=objRep.IRRepLocDr
			Set ReportLocDesc=""
			If $IsObject(objRepLoc) {
				Set ReportLocID=objRepLoc.%Id()
				Set ReportLocDesc=objRepLoc.BTDesc2
				Set:ReportLocDesc="" ReportLocDesc=objRepLoc.BTDesc
			}
		
			Set objRepUser=objRep.IRRepUser
			Set ReportUserDesc=""
			If $IsObject(objRepUser) {
				Set ReportUserID=objRepUser.%Id()
				Set ReportUserDesc=objRepUser.BTDesc
			}
			Set ReportDate=objRep.IRRepDate
			Set:ReportDate'="" ReportDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ReportDate)
			Set ReportTime=objRep.IRRepTime
			Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	
		    Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		    Continue:LinkDiags=""
			For indD=1:1:$l(LinkDiags,",") {
				Set xID=$p(LinkDiags,",",indD)
				Continue:xID=""
				Set Data=..BuildINFDiagData(xID)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data_$lb(xRepID,RepStatus,ReportDate,ReportTime,ReportLocDesc,ReportUserDesc)
		    	Set ind=ind+1
			}			
		}
	}
	Quit $$$OK
}

ClassMethod QryInfRepListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfRepListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfRepListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfRepListExecute ]
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

}
