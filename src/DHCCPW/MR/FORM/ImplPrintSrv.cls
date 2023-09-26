/// 名称: DHCCPW.MR.FORM.ImplPrintSrv
/// 描述: 表单打印相关服务
/// 编写者：zhufei
/// 编写日期: 2016-10-24
Class DHCCPW.MR.FORM.ImplPrintSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		zhufei
/// CreatDate:		2016-10-24
/// Description:    取路径信息及基本信息
/// Table:        	User.DHCMRClinicalPathWay
/// Input:        	PathWayID ：出入径ID
/// Return:       	返回%String
/// w ##class(DHCCPW.MR.FORM.ImplPrintSrv).GetPathWayBaseInfo(19)
ClassMethod GetPathWayBaseInfo(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return=""
	Quit:aPathWayID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	Set MRAdm=objPathWay.CPWMRADMDR
	If $IsObject(objPathWay.CPWPathwayDR) {
		Set CPWID=objPathWay.CPWPathwayDR.%Id()
		Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
		Set CPWDays=objPathWay.CPWPathwayDR.CPWDays
		Set CPWLabel=objPathWay.CPWPathwayDR.CPWLabel
	}
	Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	Set MrNo=##class(web.DHCCPW.MR.Interface).GetMrNoByEpisodeID(EpisodeID)
	Set objPaadm=##Class(User.PAAdm).%OpenId(EpisodeID)
	If objPaadm'="" Do objPaadm.%Close()
    If $IsObject(objPaadm.PAADMPAPMIDR)
    {
	    Set objPatient=objPaadm.PAADMPAPMIDR
	    Set PatientID=objPatient.%Id()
	    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    Set PatName=objPatient.PAPMIName
	    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
	    Set Birthday=objPatient.PAPMIDOB
    	Set:Birthday'="" Birthda=$zd(Birthday,3)
		
    	//update by zf 20150228 统一调用年龄计算方法
    	Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,"","")	//返回“*岁*月*天”

	    Set PersonalID=objPatient.PAPMIID
	    //Set MrNo=objPatient.PAPMIMedicare	// Note by zhaoyu 2013-04-01 更改病案号取值
	}
	
    //Set AdmitDate=objPaadm.PAADMAdmDate
    //upadte by pylian 2016-02-18 修改入院时间取值方式
	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmitDate=$p(AdmDateTime,"^",1)
    //Set DisDate=objPaadm.PAADMEstimDischargeDate  //医疗结算日期
    //Update by pylian 2016-01-22 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DisDate=$p(DischDateTime,"^",1)
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    If AdmitDate'="" {
	    Set AdmitDate=$zd(AdmitDate,3)
		Set AdmitDate=$p(AdmitDate,"-",1)_"年"_$p(AdmitDate,"-",2)_"月"_$p(AdmitDate,"-",3)_"日"
	}
    If DisDate'="" {
	    Set DisDate=$zd(DisDate,3)
		Set DisDate=$p(DisDate,"-",1)_"年"_$p(DisDate,"-",2)_"月"_$p(DisDate,"-",3)_"日"
	} Else {
		Set DisDate="             "  //"0000年00月00日"  未出院患者打印为空 2014-12-23 by liyi
	}
	
	Set CPWLabel="适用对象:"_$g(CPWLabel)
	/*
	Set ApplyObject=""
	Set CPWLabel=$tr(CPWLabel,$c(0),"")
	Set CPWLabel=$tr(CPWLabel,$c(1),"")
	For {   //根据要求截取字符串分段输出
		Set tApplyObject=..GetStrSub(CPWLabel,103)
		Quit:tApplyObject=""
		Set ApplyObject=$c(1)_tApplyObject
		Quit:$l(CPWLabel)<=$l(tApplyObject)
		Set CPWLabel=""_$e(CPWLabel,$l(tApplyObject)+1,$l(CPWLabel))
	}
	Set ApplyObject=$e(ApplyObject,2,$l(ApplyObject))
	*/
	Set ApplyObject=..GetStrSub(CPWLabel,103)
	
	Set return=$g(CPWDesc)                            //临床路径名称
	Set return=return_"^"_ApplyObject               //准入提示
	Set return=return_"^"_"患者姓名:"_$g(PatName)   //患者基本信息
	Set return=return_" 性别:"_$g(Sex)
	Set return=return_" 年龄:"_$g(Age)
	Set return=return_" 登记号:"_$g(PapmiNo)
	Set return=return_" 住院号:"_$g(MrNo)
	Set return=return_"^"_"住院日期:"_$g(AdmitDate) //就诊信息
	Set return=return_" 出院日期:"_$g(DisDate)
	Set return=return_" 标准住院日:"_$g(CPWDays)_"天"
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2016-10-24
/// Description:    取路径步骤信息
/// Table:        	User.DHCMRClinicalPathWay
/// Input:        	PathWayID ：出入径ID
/// Return:       	返回%String
/// w ##class(DHCCPW.MR.FORM.ImplPrintSrv).GetPathWayStepList(362)
ClassMethod GetPathWayStepList(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return=""
	Quit:aPathWayID="" return
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"GetPathWayStepList")
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	If $IsObject(objPathWay.CPWPathwayDR) {
		Set CPWID=objPathWay.CPWPathwayDR.%Id()
		Quit:$g(CPWID)="" return
	}
	
	//*************************************
	//update by zf 20110913
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	Quit:EstTimeLS="" return
	//*************************************
	
	Set StepCount=0
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
		Quit:EpID=""
		
		Set CPWEpID=CPWID_"||"_EpID
		Set objCPWEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWEpID)
		If $IsObject(objCPWEp) {
			Set CPWEpDesc=objCPWEp.EPDesc
			Set EpNo=objCPWEp.EPEpisode
			Set tmpEpNo=""
			If EpNo'="" {
				Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
				Set EpNo=tmpEpNo
			}
		}
		
		Set EpStepID=0
		For {
			Set EpStepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",EpStepID))
			Quit:EpStepID=""
			
			Set CPWEpStepID=CPWEpID_"||"_EpStepID
			Set objCPWEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CPWEpStepID)
			If $IsObject(objCPWEpStep) {
				Set CPWEpStepDesc=objCPWEpStep.CPWSDesc
				Set StepNo=objCPWEpStep.CPWSDayNumber
				Set tmpStepNo=""
				If StepNo'="" {
					Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
					Set StepNo=tmpStepNo
				}
				Set num=$i(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID))
				Set ^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID,StepNo,EpStepID)=""
				
				//*************************************
				//update by zf 20110913
				//过滤调整步骤中未选中的步骤,不显示
				Set IsCurrFormStep="N",StepSttDate="",StepEndDate=""
				For EstTimeIndex=1:1:$listlength(EstTimeLS) {
					Set EstStepDR=$list($list(EstTimeLS,EstTimeIndex),1)
					If EstStepDR=CPWEpStepID {
						Set IsCurrFormStep="Y"
						Set StepSttDate=$list($list(EstTimeLS,EstTimeIndex),3)
						Set StepEndDate=$list($list(EstTimeLS,EstTimeIndex),5)
					}
				}
				If IsCurrFormStep="Y" {
					Set ^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID,StepNo,EpStepID)=$lb(StepSttDate,StepEndDate)
					Set StepCount=StepCount+1
				} Else {
					Kill ^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID,StepNo,EpStepID)
				}
				//*************************************
			}
		}
	}
	
	Set StepNumber=0
	Set EpNo=""
	For {
		Set EpNo=$o(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo))
		Quit:EpNo=""
		Set EpID=""
		For {
			Set EpID=$o(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID))
			Quit:EpID=""
			
			Set CPWEpID=CPWID_"||"_EpID,CPWEpDesc=""
			Set objCPWEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWEpID)
			If $IsObject(objCPWEp) {
				Set CPWEpDesc=objCPWEp.EPDesc
			}
			Set StepNo=""
			For {
				Set StepNo=$o(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID,StepNo))
				Quit:StepNo=""
				Set StepID=""
				For {
					Set StepID=$o(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID,StepNo,StepID))
					Quit:StepID=""
					
					Set CPWEpStepID=CPWEpID_"||"_StepID,CPWEpStepDesc=""
					Set objCPWEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CPWEpStepID)
					If $IsObject(objCPWEpStep) {
						Set CPWEpStepDesc=objCPWEpStep.CPWSDesc
					}
					
					//*************************************
					//add by zf 20111115  打印签名信息
					Set DoctorSign="",NurseSign=""
					Set SignRowID=0
					For {
						Set SignRowID=$o(^DHCMRi(0,"SIGN","IndexEpStep",aPathWayID,CPWEpStepID,SignRowID))
						Quit:SignRowID=""
						Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(aPathWayID_"||"_SignRowID)
						Continue:'$IsObject(objSign)
						Continue:objSign.CPWSActive'="Y"
						Set Doctor=objSign.CPWSDoctorDR
						If Doctor'="" {
							Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
							If Doctor'="" {
								Set:DoctorSign'="" DoctorSign=DoctorSign_","
								Set DoctorSign=DoctorSign_Doctor
							}
						}
						Set Nurse=objSign.CPWSNurseDR
						If Nurse'="" {
							Set Nurse=$p($g(^CTPCP(+Nurse,1)),"^",2)
							If Nurse'="" {
								Set:NurseSign'="" NurseSign=NurseSign_","
								Set NurseSign=NurseSign_Nurse
							}
						}
					}
					//*************************************
					
					Set EpStepCnt=+$g(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID))
					If EpStepCnt>1 {
						Set StepDesc=CPWEpDesc_" "_CPWEpStepDesc
					} Else {
						Set StepDesc=CPWEpStepDesc
					}
					
					Set StepNumber=StepNumber+1
					If StepNumber#3=0 {
						Set PageIndex=(StepNumber\3)
						Set StepIndex=3
					} Else {
						Set PageIndex=(StepNumber\3)+1
						Set StepIndex=StepNumber#3
					}
					
					If ((PageIndex*3)<=StepCount){
						Set PageStepCnt=3
					} Else {
						Set PageStepCnt=StepCount#3
					}
					
					Set StepDocSign=DoctorSign
					Set StepNurSign=NurseSign
					
					Set StepDate=$g(^TMP(ZIndex,JIndex,"GetPathWayStepList",EpNo,EpID,StepNo,StepID))
					Set StepSttDate=$list(StepDate,1)
					Set StepEndDate=$list(StepDate,2)
					Set:StepSttDate'="" StepSttDate=$zd(StepSttDate,3)
					Set:StepSttDate'="" StepSttDate=$p(StepSttDate,"-",2)_"."_$p(StepSttDate,"-",3)
					Set:StepEndDate'="" StepEndDate=$zd(StepEndDate,3)
					Set:StepEndDate'="" StepEndDate=$p(StepEndDate,"-",2)_"."_$p(StepEndDate,"-",3)
					Set StepDate=StepSttDate
					Set:StepEndDate'="" StepDate=StepDate_"至"_StepEndDate
					
					Set StepInfo=PageIndex
					Set StepInfo=StepInfo_"^"_PageStepCnt
					Set StepInfo=StepInfo_"^"_StepIndex
					Set StepInfo=StepInfo_"^"_StepNumber
					Set StepInfo=StepInfo_"^"_CPWID_"||"_EpID_"||"_StepID
					Set StepInfo=StepInfo_"^"_StepDesc
					Set StepInfo=StepInfo_"^"_StepDate
					Set StepInfo=StepInfo_"^"_StepDocSign
					Set StepInfo=StepInfo_"^"_StepNurSign
					Set return=return_$c(1)_StepInfo
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetPathWayStepList")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2016-10-24
/// Description:    取路径项目信息
/// Table:        	User.DHCMRClinicalPathWay
/// Input:        	PathWayID ：出入径ID
/// Return:       	返回ROWSPEC=...
/// d ##class(%ResultSet).RunQuery("DHCCPW.MR.FORM.ImplPrintSrv","QryFormImplRst",19)
Query QryFormImplRst(aPathWayID As %String) As %Query(ROWSPEC = "ItemNumber:%String,StepCINumber:%String,StepNumber:%String,PageIndex:%String,ItmCatIndex:%String,SubCatIndex:%String,SubCatDesc:%String,ItemDesc:%String")
{
}

ClassMethod QryFormImplRstExecute(ByRef qHandle As %Binary, aPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind = 1
	
	Set StepList=##class(DHCCPW.MR.FORM.ImplPrintSrv).GetPathWayStepList(aPathWayID)
	Quit:StepList="" $$$OK
	
	//update by zf 20150630 新版本同步数据
	Set flg=##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrderByPathWay(aPathWayID)
	
	Set JIndex=$j,ZIndex=$zn
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItems")
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItemsTMP")
	
	Set ItemNumber=0
	For indStep=1:1:$l(StepList,$c(1)) {
		Set tStep=$p(StepList,$c(1),indStep)
		Continue:tStep=""
		Set PageIndex=$p(tStep,"^",1)
		Set PageStepCnt=$p(tStep,"^",2)
		Set StepCharLen=$s(PageStepCnt=3:30,PageStepCnt=2:45,1:90)  //根据列数设置行字符宽度
		Set StepNumber=$p(tStep,"^",4)
		Set EpStepID=$p(tStep,"^",5)
		
		Set CompStepList=""
		
		//Add by zf 20120217
		//自动同步关联医嘱和关联项目数据
		//Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(aPathWayID,EpStepID)
		Set stepEstimate=##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(aPathWayID,EpStepID)
		Set StepSttDate=$list(stepEstimate,3)
		Set StepSttTime=$list(stepEstimate,4)
		Set StepEndDate=$list(stepEstimate,5)
		Set StepEndTime=$list(stepEstimate,6)
		
		//取步骤时间段内对应医嘱(医嘱开始时间)
		Set StartDate="",StartTime=""
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
		If EstTimeLS'="" {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:EpStepID'=EstEpStepDR
				//Set StartDate=$list(objEstTime,3)
				//Set StartTime=$list(objEstTime,4)
				//Set EndDate=$list(objEstTime,5)
				//Set EndTime=$list(objEstTime,6)
				Set CompStepList=$list(objEstTime,8)
			}
		}
		
		Set CPWID=+EpStepID
		Set EpID=$p(EpStepID,"||",2)
		Set StepID=$p(EpStepID,"||",3)
		Set aCPWEpID=CPWID_"||"_EpID
		Continue:(CPWID="")||(EpID="")||(StepID="")
		
		//病情变异记录
		Set IsVar=0,VarNumber=0
		Set VarID=0,GroupNo=0
		For {
			Set VarID=$o(^DHCMR("CPW",aPathWayID,"VAR",VarID))
			Quit:VarID=""
			
			Set (CPWEpID,VarReason,VarNote)=""
			Set VarianceID=aPathWayID_"||"_VarID
			Set objVariance=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
			Continue:'$IsObject(objVariance)
			Continue:'$IsObject(objVariance.CPWVReasonDR)
			Continue:objVariance.CPWVUpdoFlag="Y"
			Continue:'$IsObject(objVariance.CPWVEpisodeDR)
			Set CPWEpID=objVariance.CPWVEpisodeDR.%Id()
			Continue:CPWEpID'=aCPWEpID
			If $IsObject(objVariance.CPWVReasonDR){
				Set VarReason=objVariance.CPWVReasonDR.VRDesc
			}
			Set VarNote=objVariance.CPWVNote
			Set VarNote=$tr(VarNote," ","")
			Set VarReason=VarReason_","_VarNote
			
			Set IsVar=1
			Set VarNumber=VarNumber+1
			Set VarReason=VarNumber_"."_VarReason
			
			Set GroupNo=GroupNo+1
			Set ^TMP(ZIndex,JIndex,"GetEpStepItems",StepNumber,"04",1,GroupNo,VarianceID)=$lb("",StepNumber,"04",1,"病情变异记录",VarReason,StepCharLen,PageIndex)
		}
		If IsVar=1 {
			Set VarReason="□无  ☑有，原因："
		} Else {
			Set VarReason="☑无  □有，原因："
		}
		Set ^TMP(ZIndex,JIndex,"GetEpStepItems",StepNumber,"04",1,0,0)=$lb("",StepNumber,"04",1,"病情变异记录",VarReason,StepCharLen,PageIndex)
		
		//主要诊疗工作、重点医嘱、主要护理工作
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:ItemID=""
			
			Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set (ItemDesc,ItemType,GroupNo)=""
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
			Continue:'$IsObject(objItem)
			Continue:'$IsObject(objItem.CPWSISubCategory)
			Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
			Set ItemDesc=objItem.CPWSIDesc
			Set SubCatCode=objItem.CPWSISubCategory.SISCCode
			Set SubCatDesc=objItem.CPWSISubCategory.SISCDesc
			Set ItemCatCode=""
			Set ItemCatDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
			Set:ItemCatDesc="主要诊疗工作" ItemCatCode="01"
			Set:ItemCatDesc="重点医嘱" ItemCatCode="02"
			Set:ItemCatDesc="主要护理工作" ItemCatCode="03"
			Continue:(ItemCatCode="")||(ItemCatDesc="")
			Continue:(SubCatCode="")||(SubCatDesc="")
			Continue:ItemDesc=""
			Set GroupNo=+objItem.CPWSIGroupNo
			
			//Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,aPathWayID,StepItemID_"-"_EpStepID,"GetEpStepItemsTMP")
			//update by zf 20150630 新版本项目执行
			Set IsImplement=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(aPathWayID,StepItemID,EpStepID,StepSttDate,StepEndDate)
			If IsImplement>0 {
				Set ItemDesc="☑"_ItemDesc  //已执行项目
			} Else {
				Set ItemDesc="□"_ItemDesc  //未执行项目
			}
			Set ^TMP(ZIndex,JIndex,"GetEpStepItems",StepNumber,ItemCatCode,SubCatCode,GroupNo,StepItemID)=$lb("",StepNumber,ItemCatCode,"",SubCatDesc,ItemDesc,StepCharLen,PageIndex)
		}
		
		//合并症：主要诊疗工作、重点医嘱、主要护理工作
		For compIndex=1:1:$listlength(CompStepList) {
			Set CompStepID=$list(CompStepList,compIndex)
			Set CPWID=$p(CompStepID,"||",1)
			Set EpID=$p(CompStepID,"||",2)
			Set StepID=$p(CompStepID,"||",3)
			Continue:(CPWID="")||(EpID="")||(StepID="")
			
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
				Quit:ItemID=""
				
				Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
				Set (ItemDesc,ItemType,GroupNo)=""
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
				Continue:'$IsObject(objItem)
				Continue:'$IsObject(objItem.CPWSISubCategory)
				Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
				Set ItemDesc=objItem.CPWSIDesc
				Set SubCatCode=objItem.CPWSISubCategory.SISCCode
				Set SubCatDesc=objItem.CPWSISubCategory.SISCDesc
				Set ItemCatCode=""
				Set ItemCatDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
				Set:ItemCatDesc="主要诊疗工作" ItemCatCode="01"
				Set:ItemCatDesc="重点医嘱" ItemCatCode="02"
				Set:ItemCatDesc="主要护理工作" ItemCatCode="03"
				Continue:(ItemCatCode="")||(ItemCatDesc="")
				Continue:(SubCatCode="")||(SubCatDesc="")
				Continue:ItemDesc=""
				Set GroupNo=+objItem.CPWSIGroupNo
				Set GroupNo=GroupNo+1000
				
				//Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,aPathWayID,StepItemID_"-"_EpStepID,"GetEpStepItemsTMP")
				//update by zf 20150630 新版本项目执行
				Set IsImplement=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(aPathWayID,StepItemID,EpStepID,StepSttDate,StepEndDate)
				If IsImplement>0 {
					Set ItemDesc="☑"_ItemDesc  //已执行项目
				} Else {
					Set ItemDesc="□"_ItemDesc  //未执行项目
				}
				Set ^TMP(ZIndex,JIndex,"GetEpStepItems",StepNumber,ItemCatCode,SubCatCode,GroupNo,StepItemID)=$lb("",StepNumber,ItemCatCode,"",SubCatDesc,ItemDesc,StepCharLen,PageIndex)
			}
		}
	}
	
	Set xStepNumber=0,ItemNumber=0
	For {
		Set xStepNumber=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",xStepNumber))
		Quit:xStepNumber=""
		
		Set xICCode=""
		For {
			Set xICCode=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",xStepNumber,xICCode))
			Quit:xICCode=""
			
			Set xISCCode="",ISCNumber=0,StepCINumber=0
			For {
				Set xISCCode=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",xStepNumber,xICCode,xISCCode))
				Quit:xISCCode=""
				
				Set ISCNumber=ISCNumber+1
				
				Set xGroupNo=""
				For {
					Set xGroupNo=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",xStepNumber,xICCode,xISCCode,xGroupNo))
					Quit:xGroupNo=""
					
					Set xItemID=""
					For {
						Set xItemID=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",xStepNumber,xICCode,xISCCode,xGroupNo,xItemID))
						Quit:xItemID=""
						
						//Set Data=$lb(ItemNumber,StepNumber,"01",1,"主要诊疗工作","□明确诊断诊治方案")
						Set Data=$g(^TMP(ZIndex,JIndex,"GetEpStepItems",xStepNumber,xICCode,xISCCode,xGroupNo,xItemID))
						Continue:Data=""
						Set StepNumber=$listget(Data,2)
						Set ItmCatCode=$listget(Data,3)
						Set SubCatDesc=$listget(Data,5)
						Set ItemDesc=$listget(Data,6)
						Set StepCharLen=$listget(Data,7)
						Set PageIndex=$listget(Data,8)
						
						//根据要求截取字符串分段输出
						Set GroupDesc=ItemDesc
						For {
							Set tmpDesc=..GetStrSub(GroupDesc,StepCharLen)
							Quit:tmpDesc=""
							
							Set ItemNumber=ItemNumber+1
							Set StepCINumber=StepCINumber+1
							Set Data=$lb(ItemNumber,StepCINumber,StepNumber,PageIndex,ItmCatCode,ISCNumber,SubCatDesc,tmpDesc)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
							
							Quit:$l(GroupDesc)<=$l(tmpDesc)
							Set GroupDesc=$e(GroupDesc,$l(tmpDesc)+1,$l(GroupDesc))
						}
					}
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItemsTMP")
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItems")
	Quit $$$OK
}

ClassMethod QryFormImplRstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFormImplRstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFormImplRstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFormImplRstExecute ]
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

/// w ##Class(DHCCPW.MR.FORM.ImplPrintSrv).GetStrSub("cs","1")
ClassMethod GetStrSub(argStr As %String, argLen As %String) As %String
{
	Set return=##Class(web.DHCCPW.MR.ImplementPrint).GetStrSub(argStr,argLen)
	Quit return
}

}
