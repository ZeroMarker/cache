/// 名称: web.DHCCPW.MR.ImplementPrint
/// 描述: 临床路径实施记录表单打印
/// 编写者：zhufei
/// 编写日期: 2010-11-07
Class web.DHCCPW.MR.ImplementPrint Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-11-07
/// Description:  根据ID取表单头部信息
/// Table：       User.DHCMRClinicalPathWay
/// Input：       ID:    User.DHCMRClinicalPathWay.Id
/// Return：      return
/// w ##class(web.DHCCPW.MR.ImplementPrint).GetTitleInfo(1,1)
ClassMethod GetTitleInfo(argPathWayID As %String, argNum As %String) As %String
{
	New (argPathWayID,argNum)
	Set return=""
	Quit:argPathWayID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	If $IsObject(objPathWay) {
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
	    If $IsObject(objPaadm)
	    {
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
		}
	}
	If argNum=1 {                          //临床路径名称
		Set return=$g(CPWDesc)
	} ElseIf argNum=2 {                    //准入提示
		Set return="适用对象:"_$g(CPWLabel)
		Set GroupDesc=return,Rows=0
		For {   //根据要求截取字符串分段输出
			Set tmpDesc=..GetStrSub(GroupDesc,103)
			Quit:tmpDesc=""
			Set Rows=Rows+1
			Quit:$l(GroupDesc)<=$l(tmpDesc)
			Set GroupDesc="  "_$e(GroupDesc,$l(tmpDesc)+1,$l(GroupDesc))
		}
		Set:Rows=0 Rows=1
		Set return=Rows_$c(1)_return
	} ElseIf argNum=3 {                    //患者基本信息
		Set return="患者姓名:"_$g(PatName)
		Set return=return_" 性别:"_$g(Sex)
		Set return=return_" 年龄:"_$g(Age)
		Set return=return_" 登记号:"_$g(PapmiNo)
		Set return=return_" 住院号:"_$g(MrNo)
	} ElseIf argNum=4 {                    //就诊信息
		Set return="住院日期:"_$g(AdmitDate)
		Set return=return_" 出院日期:"_$g(DisDate)
		Set return=return_" 标准住院日:"_$g(CPWDays)_"天"
	} Else {
		Set return=$g(CPWDesc)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-07
/// Description:  根据ID取表单阶段和步骤信息
/// Table：       User.DHCMRClinicalPathWay
/// Input：       ID:    User.DHCMRClinicalPathWay.Id
/// Return：      return
/// w ##class(web.DHCCPW.MR.ImplementPrint).GetEpSteps(1)
ClassMethod GetEpSteps(argPathWayID As %String) As %String
{
	New (argPathWayID)
	Set return=""
	Quit:argPathWayID="" return
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"GetEpSteps")
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			Set CPWID=objPathWay.CPWPathwayDR.%Id()
		}
	}
	Quit:$g(CPWID)="" return
	
	//*************************************
	//update by zf 20110913
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(argPathWayID)
	Quit:EstTimeLS="" return
	//*************************************
	
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
				Set num=$i(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID))
				Set ^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID,StepNo,EpStepID)=""
			}
		}
	}
	
	Set EpNo=""
	For {
		Set EpNo=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo))
		Quit:EpNo=""
		Set EpID=""
		For {
			Set EpID=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID))
			Quit:EpID=""
			
			Set CPWEpID=CPWID_"||"_EpID,CPWEpDesc=""
			Set objCPWEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(CPWEpID)
			If $IsObject(objCPWEp) {
				Set CPWEpDesc=objCPWEp.EPDesc
			}
			Set StepNo=""
			For {
				Set StepNo=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID,StepNo))
				Quit:StepNo=""
				Set StepID=""
				For {
					Set StepID=$o(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID,StepNo,StepID))
					Quit:StepID=""
					
					Set CPWEpStepID=CPWEpID_"||"_StepID,CPWEpStepDesc=""
					Set objCPWEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(CPWEpStepID)
					If $IsObject(objCPWEpStep) {
						Set CPWEpStepDesc=objCPWEpStep.CPWSDesc
					}
					
					//*************************************
					//update by zf 20110913
					//过滤调整步骤中未选中的步骤,不显示
					Set IsCurrFormStep="N"
					For EstTimeIndex=1:1:$listlength(EstTimeLS) {
						Set EstStepDR=$list($list(EstTimeLS,EstTimeIndex),1)
						Set:EstStepDR=CPWEpStepID IsCurrFormStep="Y"
					}
					Continue:IsCurrFormStep="N"
					//*************************************
					
					//*************************************
					//add by zf 20111115  打印签名信息
					Set DoctorSign="",NurseSign=""
					Set SignRowID=0
					For {
						Set SignRowID=$o(^DHCMRi(0,"SIGN","IndexEpStep",argPathWayID,CPWEpStepID,SignRowID))
						Quit:SignRowID=""
						Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(argPathWayID_"||"_SignRowID)
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
					Set DoctorSign="医生签名:"_$s(DoctorSign'="":DoctorSign,1:"       ")
					Set NurseSign="护士签名:"_$s(NurseSign'="":NurseSign,1:"       ")
					//*************************************
					
					Set EpStepCnt=+$g(^TMP(ZIndex,JIndex,"GetEpSteps",EpNo,EpID))
					If EpStepCnt>1 {
						Set return=return_$c(1)_CPWEpStepID_$c(2)_CPWEpDesc_" "_CPWEpStepDesc_$c(2)_DoctorSign_"   "_NurseSign
					} Else {
						Set return=return_$c(1)_CPWEpStepID_$c(2)_CPWEpStepDesc_$c(2)_DoctorSign_"   "_NurseSign
					}
					
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetEpSteps")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-07
/// Description:  根据ID取表单项目信息
/// Table：       User.DHCMRClinicalPathWay
/// Input：       argPathWayID:    User.DHCMRClinicalPathWay.Id
///               argEpStepID:     User.DHCMRCClinPathWaysEpStepItem.Id
///               argNum:          1主要诊疗工作、2重要医嘱、3主要护理工作
/// Return：      return 步骤项目列表
/// w ##class(web.DHCCPW.MR.ImplementPrint).GetEpStepItems(3,"4||1||1",2,10)
ClassMethod GetEpStepItems(argPathWayID As %String, argEpStepID As %String, argNum As %String, argStrLen As %String) As %String
{
	New (argPathWayID,argEpStepID,argNum,argStrLen)
	Set return=""
	Quit:(argPathWayID="")||(argEpStepID="")||(argNum="")||(argStrLen="") return
	Set:+argStrLen<3 argStrLen=3
	
	Set JIndex=$j,ZIndex=$zn
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItems")
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItemsTMP")
	Set CPWID=$p(argEpStepID,"||",1)
	Set EpID=$p(argEpStepID,"||",2)
	Set StepID=$p(argEpStepID,"||",3)
	Set CompStepList=""
	
	//Add by zf 20120217
	//自动同步关联医嘱和关联项目数据
	//Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(argPathWayID,argEpStepID)
	//update by zf 20150630 新版本同步数据
	Set flg=##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrderByPathWay(argPathWayID)
	Set stepEstimate=##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(argPathWayID,argEpStepID)
	Set StepSttDate=$list(stepEstimate,3)
	Set StepSttTime=$list(stepEstimate,4)
	Set StepEndDate=$list(stepEstimate,5)
	Set StepEndTime=$list(stepEstimate,6)
	
	//取步骤时间段内对应医嘱(医嘱开始时间)
	If (argPathWayID'="")&&(argNum=2) {
		Set StartDate="",StartTime=""
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(argPathWayID)
		If EstTimeLS'="" {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:argEpStepID'=EstEpStepDR
				//Set StartDate=$list(objEstTime,3)
				//Set StartTime=$list(objEstTime,4)
				//Set EndDate=$list(objEstTime,5)
				//Set EndTime=$list(objEstTime,6)
				Set CompStepList=$list(objEstTime,8)
			}
		}
		/*
		If (StartDate'="")&&(StartTime'="")&&(EndDate'="")&&(EndTime'="") {
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
			If $IsObject(objPathWay) {
				Set MRAdm=objPathWay.CPWMRADMDR
				Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
				Do ##Class(web.DHCCPW.MRC.FormShow).getOEOrdByStep("GetEpStepItemsTMP")
			}
		}
		*/
	}
	
	If (argNum=1)||(argNum=2)||(argNum=3) {
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:ItemID=""
			
			Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set (ItemDesc,ItemType,GroupNo)=""
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
			If $IsObject(objItem) {
				Set ItemDesc=objItem.CPWSIDesc
				If $IsObject(objItem.CPWSISubCategory) {
					If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
						Set ItemType=objItem.CPWSISubCategory.SISCParRef.SICDesc
					}
				}
				Set GroupNo=+objItem.CPWSIGroupNo
				Set:GroupNo="" GroupNo=999
			}
			Continue:ItemDesc=""
			Continue:(argNum=1)&&(ItemType'="主要诊疗工作")
			Continue:(argNum=2)&&(ItemType'="重点医嘱")
			Continue:(argNum=3)&&(ItemType'="主要护理工作")
			
			//Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,argPathWayID,StepItemID_"-"_argEpStepID,"GetEpStepItemsTMP")
			//update by zf 20150630 新版本项目执行
			Set IsImplement=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(argPathWayID,StepItemID,argEpStepID,StepSttDate,StepEndDate)
			If IsImplement>0 {
				Set ItemDesc="■"_ItemDesc  //已执行项目
			} Else {
				Set ItemDesc="□"_ItemDesc  //未执行项目
			}
			Set ^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,StepItemID)=ItemDesc
		}
		
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
				If $IsObject(objItem) {
					Set ItemDesc=objItem.CPWSIDesc
					If $IsObject(objItem.CPWSISubCategory) {
						If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
							Set ItemType=objItem.CPWSISubCategory.SISCParRef.SICDesc
						}
					}
					Set GroupNo=+objItem.CPWSIGroupNo
					Set:GroupNo="" GroupNo=999
					Set GroupNo=(compIndex*100)+GroupNo
				}
				Continue:ItemDesc=""
				Continue:(argNum=1)&&(ItemType'="主要诊疗工作")
				Continue:(argNum=2)&&(ItemType'="重点医嘱")
				Continue:(argNum=3)&&(ItemType'="主要护理工作")
				
				//Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,argPathWayID,StepItemID_"-"_argEpStepID,"GetEpStepItemsTMP")
				//update by zf 20150630 新版本项目执行
				Set IsImplement=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(argPathWayID,StepItemID,argEpStepID,StepSttDate,StepEndDate)
				If IsImplement>0 {
					Set ItemDesc="■"_ItemDesc  //已执行项目
				} Else {
					Set ItemDesc="□"_ItemDesc  //未执行项目
				}
				Set ^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,StepItemID)=ItemDesc
			}
		}
	}
	
	If argNum=4 {
		Set argCPWEpID=CPWID_"||"_EpID
		Set VarID=0
		For {
			Set VarID=$o(^DHCMR("CPW",argPathWayID,"VAR",VarID))
			Quit:VarID=""
			
			Set (CPWEpID,VarReason,VarNote)=""
			Set VarianceID=argPathWayID_"||"_VarID
			Set objVariance=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
			Continue:'$IsObject(objVariance)
			Continue:'$IsObject(objVariance.CPWVReasonDR)
			Continue:objVariance.CPWVUpdoFlag="Y"
			
			If $IsObject(objVariance.CPWVEpisodeDR){
				Set CPWEpID=objVariance.CPWVEpisodeDR.%Id()
			}
			Continue:CPWEpID'=argCPWEpID
			If $IsObject(objVariance.CPWVReasonDR){
				Set VarReason=objVariance.CPWVReasonDR.VRDesc
			}
			Set VarNote=objVariance.CPWVNote
			Set VarNote=$tr(VarNote," ","")
			Set VarReason=VarReason_","_VarNote
			
			Set ^TMP(ZIndex,JIndex,"GetEpStepItems",1,VarianceID)="■"_VarReason
		}
	}
	
	Set GroupNo=""
	For {
		Set GroupNo=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo))
		Quit:GroupNo=""
		
		Set ItemID="",GroupDesc=""
		For {
			Set ItemID=$o(^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,ItemID))
			Quit:ItemID=""
			Set ItemDesc=$g(^TMP(ZIndex,JIndex,"GetEpStepItems",GroupNo,ItemID))
			Continue:ItemDesc=""
			Set GroupDesc=GroupDesc_"、"_ItemDesc
		}
		Set:GroupDesc'="" GroupDesc=$e(GroupDesc,2,$l(GroupDesc))
		Continue:GroupDesc=""
		
		If GroupDesc["■" {
			Set GroupDesc=$tr(GroupDesc,"■","")
			Set GroupDesc=$tr(GroupDesc,"□","")
			Set GroupDesc="■"_GroupDesc
		}Else{
			Set GroupDesc=$tr(GroupDesc,"■","")
			Set GroupDesc=$tr(GroupDesc,"□","")
			Set GroupDesc="□"_GroupDesc
		}
		
		For {   //根据要求截取字符串分段输出
			Set tmpDesc=..GetStrSub(GroupDesc,argStrLen)
			Quit:tmpDesc=""
			Set return=return_$c(1)_tmpDesc
			Quit:$l(GroupDesc)<=$l(tmpDesc)
			Set GroupDesc="  "_$e(GroupDesc,$l(tmpDesc)+1,$l(GroupDesc))
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItemsTMP")
	Kill ^TMP(ZIndex,JIndex,"GetEpStepItems")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// w ##Class(web.DHCCPW.MR.ImplementPrint).GetStrSub("cs","1")
ClassMethod GetStrSub(argStr As %String, argLen As %String) As %String
{
	New (argStr,argLen)
	Set return=""
	Set $zt="GetStrSubErr"
	
	Quit:argStr="" return
	Quit:+argLen<1 return
	
	Set tmpLen=0,tmpInd=0
	For {
		Quit:tmpInd>=$l(argStr)
		Quit:return'=""
		
		Set tmpInd=tmpInd+1
		Set tmpChar=$e(argStr,tmpInd,tmpInd)
		If ($ASCII(tmpChar)>255)||($ASCII(tmpChar)<0) {
			Set tmpLen=tmpLen+2
		} Else {
			Set tmpLen=tmpLen+1
		}
		Set:tmpLen>argLen return=$e(argStr,1,tmpInd-1)
	}
	Set:return="" return=argStr
	
	Quit return
	
GetStrSubErr
	Quit ""
}

}
