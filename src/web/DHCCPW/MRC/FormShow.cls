/// 名称: web.DHCCPW.MRC.FormShow
/// 描述: 实施路径表单展现
/// 编写者：zhufei
/// 编写日期: 2010-05-21
Class web.DHCCPW.MRC.FormShow Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Group内的分隔符
Parameter SEPARATE = "、";

/// 未执行项目颜色
Parameter COLORORG = "#0080ff";

/// 已执行项目颜色
Parameter COLORIMPL = "#ff0000";

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonEpSteps("",1)
/// Modify by wuqk 2011-12-27
///     增加iscurrstep，显示是否当前步骤
ClassMethod BuildJsonEpSteps(aPathWayID As %String, aCPWID As %String) As %String
{
	New (aPathWayID,aCPWID)
	Set return=""
	Quit:(aPathWayID="")&&(aCPWID="") return
	
	Set $ZT="BuildJsonEpStepsErr"
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"JsonEpSteps")
	Set numIsCurrStep=$i(^Temp(ZIndex,JIndex,"isCurrStep"))
	Set numIsOverStep=$i(^Temp(ZIndex,JIndex,"isOverStep"))
	Set numIsDocSignStep=$i(^Temp(ZIndex,JIndex,"isDocSignStep"))
	Set numIsNurSignStep=$i(^Temp(ZIndex,JIndex,"isNurSignStep"))
	
	If aPathWayID'="" {	// Add by zhaoyu 2013-04-28 临床路径维护 表单展现 界面空白
	
		//add by zf 2012-12-06 如果前边步骤不签名,后边步骤不允许操作
		Set strSign=##Class(web.DHCCPW.MR.ClinPathWaysSign).GetSignSteps(aPathWayID)
		If strSign'="" {
			Set strDoctorSign=$p(strSign,",",1)
			For indSign=1:1:$l(strDoctorSign,"/") {
				Set tmpStepID=$p(strDoctorSign,"/",indSign)
				Continue:tmpStepID=""
				Set ^Temp(ZIndex,JIndex,"isDocSignStep",numIsDocSignStep,tmpStepID)=1
			}
			Set strNurseSign=$p(strSign,",",2)
			For indSign=1:1:$l(strNurseSign,"/") {
				Set tmpStepID=$p(strNurseSign,"/",indSign)
				Continue:tmpStepID=""
				Set ^Temp(ZIndex,JIndex,"isNurSignStep",numIsNurSignStep,tmpStepID)=1
			}
		}
	
	//If aPathWayID'="" {	// Note by zhaoyu 2013-04-28
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
		If $IsObject(objPathWay) {
			Set aCPWID=objPathWay.CPWPathwayDR.%Id()
		}
	}
	Quit:aCPWID="" return
	Quit:'$d(^DHCMRC("CPW",aCPWID)) return
	
	Set EstTimes=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Set EstTimes=EstTimes_$lb(EstEpStepDR)
			Set ^Temp(ZIndex,JIndex,"isCurrStep",numIsCurrStep,EstEpStepDR)=$list(objEstTime,2)
			Set ^Temp(ZIndex,JIndex,"isOverStep",numIsOverStep,EstEpStepDR)=$list(objEstTime,9)
		}
	}
	
	Set EpID=""
	For {
		Set EpID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID))
		Quit:EpID=""
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(aCPWID_"||"_EpID)
		Continue:'$IsObject(objEp)
		Set EpNo=objEp.EPEpisode
		Set tmpEpNo=""
		If EpNo'="" {
			Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
			Set EpNo=tmpEpNo
		}
		Set EpDesc=objEp.EPDesc
		Continue:(EpNo="")||(EpDesc="")
		Set ^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID)=""
		
		Set StepID="",Count=0
		For {
			Set StepID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set EstStepRowid=aCPWID_"||"_EpID_"||"_StepID
			If EstTimes'="" {
				Continue:'$listfind(EstTimes,EstStepRowid)
			}
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(aCPWID_"||"_EpID_"||"_StepID)
			Continue:'$IsObject(objStep)
			Set StepNo=objStep.CPWSDayNumber
			Set tmpStepNo=""
			If StepNo'="" {
				Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
				Set StepNo=tmpStepNo
			}
			Set StepDesc=objStep.CPWSDesc
			Continue:(StepNo="")||(StepDesc="")
			Set num=$i(^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID,"EpSCnt"))
			Set ^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID,"Step",StepNo,StepID)=""
		}
	}
	
	Set EpNo="",Json="[",stepflg=0
	For {
		Set EpNo=$o(^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo))
		Quit:EpNo=""
		Set EpID=""
		For {
			Set EpID=$o(^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID))
			Quit:EpID=""
			Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(aCPWID_"||"_EpID)
			Continue:'$IsObject(objEp)
			Set EpDesc=objEp.EPDesc
			Set EpSCnt=+$g(^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID,"EpSCnt"))
			
			Set StepNo=""
			For {
				Set StepNo=$o(^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID,"Step",StepNo))
				Quit:StepNo=""
				Set StepID=""
				For {
					Set StepID=$o(^TMP(ZIndex,JIndex,"JsonEpSteps",EpNo,EpID,"Step",StepNo,StepID))
					Quit:StepID=""
					Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(aCPWID_"||"_EpID_"||"_StepID)
					Continue:'$IsObject(objStep)
					Set StepRowid=aCPWID_"||"_EpID_"||"_StepID
					Set StepDesc=objStep.CPWSDesc
					Set:EpSCnt>1 StepDesc=EpDesc_"<br>"_StepDesc
					If stepflg=1 {
						Set Json=Json_","
					}Else{
						Set stepflg=1
					}
					Set Json=Json_"{'stepid':'"_StepRowid_"'"
					Set Json=Json_",'stepdesc':'"_StepDesc_"'"
					Set Json=Json_",'iscurrstep':"_+$g(^Temp(ZIndex,JIndex,"isCurrStep",numIsCurrStep,StepRowid))_""
					Set Json=Json_",'isoverstep':"_+$g(^Temp(ZIndex,JIndex,"isOverStep",numIsOverStep,StepRowid))_""
					Set Json=Json_",'isDocSignStep':"_+$g(^Temp(ZIndex,JIndex,"isDocSignStep",numIsDocSignStep,StepRowid))_""
					Set Json=Json_",'isNurSignStep':"_+$g(^Temp(ZIndex,JIndex,"isNurSignStep",numIsNurSignStep,StepRowid))_""
					Set Json=Json_"}"
				}
			}
		}
	}
	Set Json=Json_"]"
	Kill ^TMP(ZIndex,JIndex,"JsonEpSteps")
	Kill ^Temp(ZIndex,JIndex,"isCurrStep")
	Kill ^Temp(ZIndex,JIndex,"isOverStep")
	Kill ^Temp(ZIndex,JIndex,"isDocSignStep")
	Kill ^Temp(ZIndex,JIndex,"isNurSignStep")
	
	Set return=Json
	Quit return
	
BuildJsonEpStepsErr
	Kill ^TMP(ZIndex,JIndex,"JsonEpSteps")
	Quit ""
}

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonEpStepsEst("1","")
ClassMethod BuildJsonEpStepsEst(aPathWayID As %String, aCPWID As %String) As %String
{
	New (aPathWayID,aCPWID)
	Set return=""
	Quit:(aPathWayID="")&&(aCPWID="") return
	
	Set $ZT="BuildJsonEpStepsEstErr"
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepsEst")
	
	If aPathWayID'="" {
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
		If $IsObject(objPathWay) {
			Set aCPWID=objPathWay.CPWPathwayDR.%Id()
		}
	}
	Quit:aCPWID="" return
	Quit:'$d(^DHCMRC("CPW",aCPWID)) return
	
	Set EstTimesLB=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Set EstTimesLB=EstTimesLB_$lb(EstEpStepDR)
			Set EstTimes(EstEpStepDR)=objEstTime
			//w $listtostring(objEstTime,"///"),!
		}
	}
	
	Set EpID=""
	For {
		Set EpID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID))
		Quit:EpID=""
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(aCPWID_"||"_EpID)
		Continue:'$IsObject(objEp)
		Set EpNo=objEp.EPEpisode
		Set tmpEpNo=""
		If EpNo'="" {
			Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
			Set EpNo=tmpEpNo
		}
		Set EpDesc=objEp.EPDesc
		Continue:(EpNo="")||(EpDesc="")
		Set ^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID)=""
		
		Set StepID="",Count=0
		For {
			Set StepID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(aCPWID_"||"_EpID_"||"_StepID)
			Continue:'$IsObject(objStep)
			Set StepNo=objStep.CPWSDayNumber
			Set tmpStepNo=""
			If StepNo'="" {
				Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
				Set StepNo=tmpStepNo
			}
			Set StepDesc=objStep.CPWSDesc
			Continue:(StepNo="")||(StepDesc="")
			Set num=$i(^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID,"EpSCnt"))
			Set ^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID,"Step",StepNo,StepID)=""
		}
	}
	
	Set EpNo="",Json="[",stepflg=0,isStart=1
	For {
		Set EpNo=$o(^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo))
		Quit:EpNo=""
		Set EpID=""
		For {
			Set EpID=$o(^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID))
			Quit:EpID=""
			Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(aCPWID_"||"_EpID)
			Continue:'$IsObject(objEp)
			Set EpDesc=objEp.EPDesc
			Set EpSCnt=$g(^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID,"EpSCnt"))
			
			Set StepNo=""
			For {
				Set StepNo=$o(^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID,"Step",StepNo))
				Quit:StepNo=""
				Set StepID=""
				For {
					Set StepID=$o(^TMP(ZIndex,JIndex,"JsonEpStepsEst",EpNo,EpID,"Step",StepNo,StepID))
					Quit:StepID=""
					Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(aCPWID_"||"_EpID_"||"_StepID)
					Continue:'$IsObject(objStep)
					Set StepRowid=aCPWID_"||"_EpID_"||"_StepID
					
					If EstTimesLB'="" {
						Continue:'$listfind(EstTimesLB,StepRowid)
					}
					
					Set StepDays=+objStep.CPWSDay
					Set DaysUnit=objStep.CPWSUnit
					Set:StepDays<0 StepDays=1
					Set DaysUnit=$s(DaysUnit="M":"分钟",DaysUnit="H":"小时",DaysUnit="D":"天",1:"天")
					
					Set EstTime=$g(EstTimes(StepRowid))
					//w $listtostring(EstTime,"///"),!
					If EstTime'="" {
						Set xIsCurrStep=$list(EstTime,2)
						Set xStartDate=$list(EstTime,3)
						;Set:xStartDate'="" xStartDate=$zd(xStartDate,3)
						Set:xStartDate'="" xStartDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xStartDate)
						Set xStartTime=$list(EstTime,4)
						Set:xStartTime'="" xStartTime=$zt(xStartTime,1)
						Set xEndDate=$list(EstTime,5)
						;Set:xEndDate'="" xEndDate=$zd(xEndDate,3)
						Set:xEndDate'="" xEndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xEndDate)
						Set xEndTime=$list(EstTime,6)
						Set:xEndTime'="" xEndTime=$zt(xEndTime,1)
						Set xEstTime=$list(EstTime,7)
						
						Set xIsOverStep=$list(EstTime,9)
						
						Set title=$s(xIsOverStep="1":"",1:"?")_"实际时间:"_xEstTime_"(参考时间:"_StepDays_DaysUnit_")"
						Set subtitle=xStartDate_" "_xStartTime_"～"_xEndDate_" "_xEndTime
						Set iscurrstep=xIsCurrStep
					}Else{
						Set title="参考时间:"_StepDays_DaysUnit
						Set subtitle=""
						Set iscurrstep=0
						Set xEstTime=""
					}
					If stepflg=1 {
						Set Json=Json_","
					}Else{
						Set stepflg=1
					}
					Set Json=Json_"{'stepid':'"_StepRowid_"'"
					Set Json=Json_",'title':'"_title_"'"
					Set Json=Json_",'iscurrstep':"_iscurrstep_""   //removed '' by wuqk 2011-2
					If subtitle'="" {
						Set Json=Json_",'estsub':[{'subtitle':'"_subtitle_"','estTime':'"_xEstTime_"','isStart':'"_isStart_"','nameList':'CPW_EST_ITEM','idList':'"_StepRowid_"'}]"
						Set isStart=0
					}Else{
						Set Json=Json_",'estsub':[]"
					}
					Set Json=Json_"}"
				}
			}
		}
	}
	Set Json=Json_"]"
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepsEst")
	
	Set return=Json
	Quit return
	
BuildJsonEpStepsEstErr
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepsEst")
	Quit ""
}

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonEpStepItems("1","67||1||1","01")
ClassMethod BuildJsonEpStepItems(aPathWayID As %String, aEpStep As %String, aFlag As %String) As %String
{
	New (aPathWayID,aEpStep,aFlag)
	Set return=""
	Quit:(aEpStep="")||(aFlag="") return
	
	Set $ZT="BuildJsonEpStepItemsErr"
	
	If $l(aEpStep,"||")<3 {
		Set aCPWID=+aEpStep
		Set aEpID=$o(^DHCMRC("CPW",aCPWID,"EP",0))
		Quit:aEpID="" return
		Set aStepID=$o(^DHCMRC("CPW",aCPWID,"EP",aEpID,"STEP",0))
		Quit:aStepID="" return
		Set aEpStep=aCPWID_"||"_aEpID_"||"_aStepID
	}
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepItems")
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepItemsTMP")
	If aFlag="01" {
		Set aCategDesc="诊疗"
	} ElseIf aFlag="02" {
		Set aCategDesc="医嘱"
	} ElseIf aFlag="03" {
		Set aCategDesc="护理"
	} Else {
		Set aCategDesc="Error"
	}
	
	//Add by zf 20120217
	//自动同步关联医嘱和关联项目数据
	//Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(aPathWayID,aEpStep)
	//update by zf 20150630 新版本同步数据
	Set flg=##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrderByPathWay(aPathWayID)
	Set stepEstimate=##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(aPathWayID,aEpStep)
	Set (StepSttDate,StepSttTime,StepEndDate,StepEndTime)=""
	
	If stepEstimate'=""	//update by lyh 2015-8-17 修复stepEstimate为空bug
	{
		Set StepSttDate=$list(stepEstimate,3)
		Set StepSttTime=$list(stepEstimate,4)
		Set StepEndDate=$list(stepEstimate,5)
		Set StepEndTime=$list(stepEstimate,6)
	}
	
	/*
	//取步骤时间段内对应医嘱(医嘱开始时间)
	If aPathWayID'="" {
		Set StartDate="",StartTime=""
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
		If EstTimeLS'="" {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:aEpStep'=EstEpStepDR
				Set StartDate=$list(objEstTime,3)
				Set StartTime=$list(objEstTime,4)
				Set EndDate=$list(objEstTime,5)
				Set EndTime=$list(objEstTime,6)
			}
		}
		//w $zd(StartDate,3)_" "_$zt(StartTime,2)_","_$zd(EndDate,3)_" "_$zt(EndTime,2),!
		//w StartDate_" "_StartTime_","_EndDate_" "_EndTime,!
		If (StartDate'="")&&(StartTime'="")&&(EndDate'="")&&(EndTime'="") {
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
			If $IsObject(objPathWay) {
				Set MRAdm=objPathWay.CPWMRADMDR
				Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
				Do ##Class(web.DHCCPW.MRC.FormShow).getOEOrdByStep("JsonEpStepItemsTMP")
			}
		}
	}
	*/
	
	// 电子病历评级(与护理病历)
	Set Paadm="",EstStepStaDate=0,EstStepEndDate=0
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	If $IsObject(objPathWay) {
		Set MRAdm=objPathWay.CPWMRADMDR
		Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
		Set (EstStepStaDate,EstStepEndDate)=0
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
		If (EstTimeLS'="") {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:(EstEpStepDR'=aEpStep)
				Set EstStepStaDate=$list(objEstTime,3)
				Set EstStepEndDate=$list(objEstTime,5)
				Set EstStepEndTime=$list(objEstTime,6)
				Set:(+EstStepEndTime=0) EstStepEndDate=EstStepEndDate-1	// 00:00结束不算
			}
		}
	}
	//
	
	Set CPWID=$p(aEpStep,"||",1),EpID=$p(aEpStep,"||",2),StepID=$p(aEpStep,"||",3)
	Set ItemID=""
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(CPWID_"||"_EpID_"||"_StepID_"||"_ItemID)
		Continue:'$IsObject(objItem)
		Continue:'$IsObject(objItem.CPWSISubCategory)
		Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
		Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
		Continue:CategDesc'[aCategDesc  //按项目大类过滤
		Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
		Set SubCatID=objItem.CPWSISubCategory.%Id()
		Set GroupNo=objItem.CPWSIGroupNo
		Set tmpGroupNo=""
		If GroupNo'="" {
			Set $p(tmpGroupNo,"0",5-$l(GroupNo))=GroupNo
			Set GroupNo=tmpGroupNo
		}
		Continue:GroupNo=""
		Set ^TMP(ZIndex,JIndex,"JsonEpStepItems",CategID,SubCatID,GroupNo,ItemID)=""
	}
	
	Set Json="{'stepid':'"_aEpStep_"','stepdata':["
	Set CategID=""
	For {
		Set CategID=$o(^TMP(ZIndex,JIndex,"JsonEpStepItems",CategID))
		Quit:CategID=""
		
		Set SubCatID="",subcatflg=0
		For {
			Set SubCatID=$o(^TMP(ZIndex,JIndex,"JsonEpStepItems",CategID,SubCatID))
			Quit:SubCatID=""
			Set objSubCat=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(SubCatID)
			Continue:'$IsObject(objSubCat)
			Set SubCatDesc=objSubCat.SISCDesc
			Continue:SubCatDesc=""
			Set SubCatPower=objSubCat.SISCPower
			
			If SubCatPower="D" {
				Set itemNameList="CPW_CONSULT_ITEM"
				Set itemSubCatName="CPW_CONSULT_SELALL"
			} ElseIf SubCatPower="OE" {
				Set itemNameList="CPW_OE_ITEM"
				Set itemSubCatName="CPW_OE_SELALL"
			} ElseIf SubCatPower="NE" {
				Set itemNameList="CPW_NE_ITEM"
				Set itemSubCatName="CPW_NE_SELALL"
			} ElseIf SubCatPower="N" {
				Set itemNameList="CPW_NURSE_ITEM"
				Set itemSubCatName="CPW_NURSE_SELALL"
			} Else {
				Set itemNameList="CPW_NULL_ITEM"
				Set itemSubCatName="CPW_NULL_SELALL"
			}
			
			If subcatflg=1 {
				Set Json=Json_","
				Set ItemIDList=ItemIDList_","
			}Else{
				Set subcatflg=1
			}
			Set Json=Json_"{'stepsubcatname':'"_itemSubCatName_"','stepsubcatid':'"_aEpStep_"-"_SubCatID_"-"_$p(aEpStep,"||",1)_"','subtitle':'"_SubCatDesc_"','subcatedata':["
			
			Set GroupNo="",groupflg=0
			For {
				Set GroupNo=$o(^TMP(ZIndex,JIndex,"JsonEpStepItems",CategID,SubCatID,GroupNo))
				Quit:GroupNo=""
				
				If groupflg=1 {
					Set Json=Json_","
				}Else{
					Set groupflg=1
				}
				Set Json=Json_"{'groupno':'"_GroupNo_"'"
				Set Json=Json_",'nameList':'"_itemNameList_"'"
				Set Json=Json_",'groupdata':["
				
				Set ItemID="",ItemIDList="",itemflg=0,tmpIsMust="",tmpArcim=""
				For {
					Set ItemID=$o(^TMP(ZIndex,JIndex,"JsonEpStepItems",CategID,SubCatID,GroupNo,ItemID))
					Quit:ItemID=""
					Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowid)
					Continue:'$IsObject(objItem)
					Set ItemDesc=objItem.CPWSIDesc
					Set ItemIsMust=objItem.CPWSIIsMust
					Set:ItemIsMust["Y" tmpIsMust="Y"
					Set:ItemIsMust["N" tmpIsMust="N"
					Set ArcimCnt=objItem.CPWSIARCIM.Count()
					Set:ArcimCnt>0 tmpArcim="Y"
					Set tmpItemID=$o(^TMP(ZIndex,JIndex,"JsonEpStepItems",CategID,SubCatID,GroupNo,ItemID))
					Set ItemOptional=0
					Set:tmpIsMust="Y" ItemOptional=1
					Set:(tmpArcim'="Y")&&(tmpItemID="")&&((SubCatPower="OE")||(SubCatPower="NE")) ItemDesc=ItemDesc
					Continue:ItemDesc=""
					
					Set ItemRowid=ItemRowid_"-"_aEpStep_"-"_SubCatID
					//Set ItemImpl=..IsItemImpl(ZIndex,JIndex,aPathWayID,ItemRowid,"JsonEpStepItemsTMP")  //判断项目是否有实施记录
					//update by zf 20150630 新版本项目执行
					Set ItemImpl=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(aPathWayID,$p(ItemRowid,"-",1),$p(ItemRowid,"-",2),StepSttDate,StepEndDate)
					If ItemImpl>0 {
						Set ItemImpl=1
					}Else{
						Set ItemImpl=0
					}
					
					//电子病历评级(与护理病历)
					If (SubCatDesc="护理病历")&&(aFlag="03") {
						Set EmrStatus=##class(web.DHCCPW.MR.Interface).CPWGetEmrStatus(Paadm,EstStepStaDate,EstStepEndDate,ItemDesc)
						Set:(EmrStatus>0) ItemImpl=1
					}
					//
					
					If itemflg=1 {
						Set Json=Json_","
						Set ItemIDList=ItemIDList_","
					}Else{
						Set itemflg=1
					}
					Set Json=Json_"{'id':'"_ItemRowid_"'"
					Set Json=Json_",'item':'"_ItemDesc_"'"
					Set Json=Json_",'optional':'"_ItemOptional_"'"
					Set Json=Json_",'impl':'"_ItemImpl_"'}"
					Set ItemIDList=ItemIDList_ItemRowid
				}
				Set Json=Json_"]"
				Set Json=Json_",'idList':'"_ItemIDList_"'"
				Set Json=Json_"}"
			}
			Set Json=Json_"]}"
		}
	}
	Set Json=Json_"]}"
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepItemsTMP")
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepItems")
	
	Set return=Json
	Quit return
	
BuildJsonEpStepItemsErr
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepItemsTMP")
	Kill ^TMP(ZIndex,JIndex,"JsonEpStepItems")
	Quit ""
}

/// w ##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(6,"8||2||1||2-8||2||1")
ClassMethod IsItemImpl(aZIndex As %String, aJIndex As %String, aPathWayID As %String, aItemID As %String, NIndex As %String) As %String
{
	New (aPathWayID,aItemID)
	Set return=0
	Quit:(aPathWayID="")||(aItemID="") return
	
	Set $ZT="IsItemImplErr"
	
	Set aStepID=$p(aItemID,"-",2)
	Set aItemID=$p(aItemID,"-",1)
	Set:aStepID="" aStepID=$p(aItemID,"||",1)_"||"_$p(aItemID,"||",2)_"||"_$p(aItemID,"||",3)
	
	//1 判断实时记录，查看表单项目是否执行
	Set ImplID=""
	For {
		Set ImplID=$o(^DHCMRi(0,"IMPL","IndexStepItem",aPathWayID,aItemID,ImplID))
		Quit:ImplID=""
		Set ImplRowid=aPathWayID_"||"_ImplID
		Set objImpl=##class(web.DHCCPW.MR.Implement).GetObjById(ImplRowid)
		Continue:'$IsObject(objImpl)
		Set IsActive=objImpl.CPWEActive
		Continue:IsActive'["Y"
		If $IsObject(objImpl.CPWEStepDR){
			Set ImplStepID=objImpl.CPWEStepDR.%Id()
			Continue:aStepID'=ImplStepID
		}
		Set OeoriID=objImpl.CPWEOEORIDR
		Set OeoriStatus=""
		If OeoriID'="" {
			Set OeoriStatus=$p($g(^OEORD(+OeoriID,"I",+$p(OeoriID,"||",2),1)),"^",13)
			Set OeoriStatus=$p($g(^OEC("OSTAT",+OeoriStatus)),"^",2)
		}
		Continue:(OeoriStatus["停")||(OeoriStatus["作废")  //医嘱状态  停止
		Set return=return+1
	}
	Quit:return>0 return
	
	//2 关联医嘱+关联项目检查，查看表单项目是否执行
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(aItemID)
	If $IsObject(objItem) {
		//2.1 关联医嘱检查,查看表单项目是否执行
		Set ItemArcimCnt=objItem.CPWSIARCIM.Count()
		For ItemArcimInd=1:1:ItemArcimCnt {
			Set objItemArcim=objItem.CPWSIARCIM.GetAt(ItemArcimInd)
			Continue:'$IsObject(objItemArcim)
			Set ArcimID=objItemArcim.ITMARCIMDR
			Continue:ArcimID=""   //医嘱项ID
			Set IsMain=objItemArcim.ITMIsMain
			//Continue:IsMain'["Y"  //不是主要项目，不检查
			//w "ItemID="_aItemID_",ArcimID="_ArcimID,!
			If $l(ArcimID,"||")=2 {
				Continue:$g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1))=""  //无此医嘱
				//w "ArcimID="_ArcimID,!
				Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ArcimID,aItemID))
				Set return=return+1
			}Else{
				//^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)
				Set ARCOSRowid=ArcimID
				Continue:$g(^ARCOS(+ARCOSRowid))=""  //无此医嘱套
				
				//w "ARCOSRowid="_ARCOSRowid,!
				Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ARCOSRowid,aItemID))
				Set return=return+1
				
				/*
				//取医嘱套的日期节点
				Set ARCOSDateID=0
				For {
					Set ARCOSDateID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID))
					Quit:ARCOSDateID=""
					//判断医嘱套下的医嘱项
					Set ARCOSItemID=0
					For {
						Set ARCOSItemID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"ITM",ARCOSItemID))
						Quit:ARCOSItemID=""
						Set ARCOSARCIMID=$p($g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"ITM",ARCOSItemID)),"^",1)
						Continue:$g(^ARCIM(+ARCOSARCIMID,$p(ARCOSARCIMID,"||",2),1))=""  //无此医嘱
						//w "ARCOSARCIMID="_ARCOSARCIMID,!
						Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ARCOSARCIMID,aItemID))
						Set return=return+1
					}
					//医嘱套下的医嘱子套
					Set ARCOSOSID=0
					For {
						Set ARCOSOSID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"OS",ARCOSOSID))
						Quit:ARCOSOSID=""
						Set ARCOSSubID=$p($g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"OS",ARCOSOSID)),"^",1)
						//取医嘱子套的日期节点
						Set ARCOSSubDateID=0
						For {
							Set ARCOSSubDateID=$o(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID))
							Quit:ARCOSSubDateID=""
							//取医嘱子套的医嘱项
							Set ARCOSSubItemID=0
							For {
								Set ARCOSSubItemID=$o(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID,"ITM",ARCOSSubItemID))
								Quit:ARCOSSubItemID=""
								Set ARCOSSubARCIMID=$p($g(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID,"ITM",ARCOSSubItemID)),"^",1)
								Continue:$g(^ARCIM(+ARCOSSubARCIMID,$p(ARCOSSubARCIMID,"||",2),1))=""  //无此医嘱
								//w "ARCOSSubARCIMID="_ARCOSSubARCIMID,!
								Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ARCOSSubARCIMID,aItemID))
								Set return=return+1
							}
						}
					}
				}
				*/
			}
		}
		
		//2.2 关联项目检查,查看表单项目是否执行
		Set lnkItemCnt=objItem.CPWSIBLItmList.Count()
		For indLnkItem=1:1:lnkItemCnt {
			Set objLnkItem=objItem.CPWSIBLItmList.GetAt(indLnkItem)
			Continue:'$IsObject(objLnkItem)
			Continue:'$IsObject(objLnkItem.ITMBLItmDR)
			Set lnkItemID=objLnkItem.ITMBLItmDR.%Id()
			Continue:lnkItemID=""   //关联项ID
			Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"LNKITM",lnkItemID,aItemID))
			Set return=return+1
		}
	}
	
	Quit return
	
IsItemImplErr
	Quit 0
}

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonEpStepVars("6","8||2||1")
ClassMethod BuildJsonEpStepVars(aPathWayID As %String, aEpStep As %String) As %String
{
	New (aPathWayID,aEpStep)
	Set return=""
	Quit:aEpStep="" return
	
	Set $ZT="BuildJsonEpStepVarsErr"
	Set Json="{'stepid':'"_aEpStep_"','subtitle':'"_"病情变异记录"_"','stepdata':["
	Set Json=Json_"{'subcatedata':["
	If aPathWayID'="" {
		Set VarID="",varflg=0,VarNum=0
		
		For {
			Set VarID=$o(^DHCMRi(0,"VAR","IndexEpStep",aPathWayID,aEpStep,VarID))
			Quit:VarID=""
			Set VarRowid=aPathWayID_"||"_VarID
			Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarRowid)
			Continue:'$IsObject(objVar)
			Continue:'$IsObject(objVar.CPWVReasonDR)
			Continue:objVar.CPWVUpdoFlag="Y"
			
			Set VarDesc=objVar.CPWVReasonDR.VRDesc
			Set VarNote=objVar.CPWVNote
			Set:VarNote'="" VarDesc=VarDesc_":"_VarNote  //, to : by wuqk 2011-10-25
			Set VarDesc=$tr(VarDesc,$c(13),"")
			Set VarDesc=$tr(VarDesc,$c(10),"")
			Set VarNum=VarNum+1
			If varflg=1 {
				Set Json=Json_","
			}Else{
				Set varflg=1
			}
			set Json=Json_"{'id':'"_VarRowid_"','itemnum':'"_VarNum_"','itemdesc':'"_VarDesc_"'}"
		}
		
		/*
		For {
			Set VarID=$o(^DHCMRi(0,"VAR","IndexEpStep",aPathWayID,aEpStep,VarID))
			Quit:VarID=""
			Set VarRowid=aPathWayID_"||"_VarID
			Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarRowid)
			Continue:'$IsObject(objVar)
			Continue:'$IsObject(objVar.CPWVReasonDR)
			Continue:objVar.CPWVUpdoFlag="Y"
			
			Set VarDesc=objVar.CPWVReasonDR.VRDesc
			Set VarNote=objVar.CPWVNote
			Set:VarNote'="" VarDesc=VarDesc_":"_VarNote  //, to : by wuqk 2011-10-25
			
			Set DescBackUp=VarDesc
			Set CPWVEV=objVar.CPWVExtraValues			
			Set:CPWVEV="" CPWVEV=":-,"
			For index=1:1:$l(CPWVEV,","){
				Set tmp=$p(CPWVEV,",",index)
				Continue:tmp=""
				
				Set CPWVEVType=$p(tmp,":",1)
				Set CPWVEVId=$p($p(tmp,":",2),"-",1)
				If (CPWVEVType="ARCIM"){
					Set CPWVEVDesc=$p(^ARCIM($p(CPWVEVId,"||",1),$p(CPWVEVId,"||",2),1),"^",2)
					Set VarDesc=DescBackUp_":"_CPWVEVDesc
				}ElseIf(CPWVEVType="CPWITM"){
					//b ;33
					Set ObjCPWITM=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(CPWVEVId)
					Set CPWVEVDesc=ObjCPWITM.CPWSIDesc
					//Set CPWVEVDesc=""
					Set VarDesc=DescBackUp_":"_CPWVEVDesc
					Do ObjCPWITM.%Close()
					//b ;44
				}Else{
					Set VarDesc=DescBackUp
				}
				Set VarDesc=$tr(VarDesc,$c(13),"")
				Set VarDesc=$tr(VarDesc,$c(10),"")
				Set VarNum=VarNum+1
				If varflg=1 {
					Set Json=Json_","
				}Else{
					Set varflg=1
				}
				set Json=Json_"{'id':'"_VarRowid_"','itemnum':'"_VarNum_"','itemdesc':'"_VarDesc_"'}"
			}
		}
		*/
	}
	Set Json=Json_"]}"
	Set Json=Json_"]}"
	
	Set return=Json
	Quit return
BuildJsonEpStepVarsErr
	Quit ""
}

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonEpStepSigns("6","8||2||1","Doc")
ClassMethod BuildJsonEpStepSigns(aPathWayID As %String, aEpStep As %String, aType As %String) As %String
{
	New (aPathWayID,aEpStep,aType)
	Set return=""
	Quit:aEpStep="" return
	
	Set $ZT="BuildJsonEpStepDocSignsErr"
	Set subtitle=$s(aType["D":"医师签名",1:"护士签名")
	Set Json="{'stepid':'"_aEpStep_"','subtitle':'"_subtitle_"','stepdata':["
	Set Json=Json_"{'subcatedata':["
	If aPathWayID'="" {
		Set SignID="",signflg=0,SignNum=0
		For {
			Set SignID=$o(^DHCMRi(0,"SIGN","IndexEpStep",aPathWayID,aEpStep,SignID))
			Quit:SignID=""
			Set SignRowid=aPathWayID_"||"_SignID
			Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(SignRowid)
			Continue:'$IsObject(objSign)
			Continue:objSign.CPWSActive'["Y"
			If aType["D" {
				Set CareProvID=objSign.CPWSDoctorDR
			}Else{
				Set CareProvID=objSign.CPWSNurseDR
			}
			Continue:CareProvID=""
			Set CareProvName=$p($g(^CTPCP(+CareProvID,1)),"^",2)
			Continue:CareProvName=""
			
			Set SignDate=objSign.CPWSDate
			Set SignTime=objSign.CPWSTime
			;Set:SignDate'="" SignDate=$zd(SignDate,3)
			Set:SignDate'="" SignDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SignDate)
			Set:SignTime'="" SignTime=$zt(SignTime,2)
			Set ItemDesc=CareProvName_" "_SignDate_" "_SignTime
			Set ItemDesc=$tr(ItemDesc,$c(10),"")
			Set ItemDesc=$tr(ItemDesc,$c(13),"")
			
			Set SignNum=SignNum+1
			If signflg=1 {
				Set Json=Json_","
			}Else{
				Set signflg=1
			}
			set Json=Json_"{'id':'"_SignRowid_"','itemnum':'"_SignNum_"','itemdesc':'"_ItemDesc_"'}"
		}
	}
	Set Json=Json_"]}"
	Set Json=Json_"]}"
	
	Set return=Json
	Quit return
BuildJsonEpStepDocSignsErr
	Quit ""
}

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonCompList(1)
ClassMethod BuildJsonCompList(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return=""
	Quit:aPathWayID="" return
	
	Set $ZT="BuildJsonCompListErr"
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	Quit:EstTimeLS="" return
	
	Set CompJson="[",compflg=0
	For CompListIndex=1:1:objPathWay.CPWCompList.Count() {
		Set CompCPWID=objPathWay.CPWCompList.GetAt(CompListIndex)
		Set objCompCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CompCPWID)
		Continue:'$IsObject(objCompCPW)
		
		//*********************************************
		//判断合并症是否勾选，如果没有步骤勾选，过滤掉
		Set IsCompUsing="N"
		For EstTimesInd=1:1:$listlength(EstTimeLS) {
			Quit:IsCompUsing="Y"
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Set EstCompStepList=$list(objEstTime,8)
			If EstCompStepList'="" {
				For EstCompStepIndex=1:1:$listlength(EstCompStepList) {
					Quit:IsCompUsing="Y"
					Set EstCompStep=$list(EstCompStepList,EstCompStepIndex)
					Continue:(+EstCompStep'=CompCPWID)
					Set IsCompUsing="Y"
				}
			}
		}
		Continue:IsCompUsing="N"
		//*********************************************
		
		Set CompCPWDesc=objCompCPW.CPWDesc
		If compflg=1 {
			Set CompJson=CompJson_","
		}Else{
			Set compflg=1
		}
		Set CompJson=CompJson_"{'compcpwid':'"_CompCPWID_"'"
		Set CompJson=CompJson_",'compcpwdesc':'"_CompCPWDesc_"'"
		Set CompJson=CompJson_"}"
	}
	Set CompJson=CompJson_"]"
	
	Set return=CompJson
	Quit return
	
BuildJsonCompListErr
	Quit ""
}

/// w ##Class(web.DHCCPW.MRC.FormShow).BuildJsonCompItems("1","69||1||1","67")
ClassMethod BuildJsonCompItems(aPathWayID As %String, aEpStep As %String, aCompID As %String) As %String
{
	New (aPathWayID,aEpStep,aCompID)
	Set return=""
	Quit:(aPathWayID="")||(aEpStep="")||(aCompID="") return
	
	Set $ZT="BuildJsonCompItemsErr"
	
	//如果有时间调整记录，取调整记录中步骤对应合并症步骤
	Set CurrCompStep=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	If EstTimeLS'="" {
		For EstTimesInd=1:1:$listlength(EstTimeLS) {
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Continue:EstEpStepDR'=aEpStep
			Set EstCompStepList=$list(objEstTime,8)
			If EstCompStepList'="" {
				For EstCompStepIndex=1:1:$listlength(EstCompStepList) {
					Set EstCompStep=$list(EstCompStepList,EstCompStepIndex)
					Continue:(+EstCompStep'=aCompID)
					Set CurrCompStep=EstCompStep
					Quit:CurrCompStep'=""
				}
			}
		}
	}
	Quit:CurrCompStep="" return
	
	/**************************************************
	//暂时不考虑无时间调整记录有合并症的情况
	//没有时间调整记录，取合并症的第一个步骤
	If CurrCompStep="" {
		Set aCPWID=aCompID
		Set aEpID=$o(^DHCMRC("CPW",aCPWID,"EP",0))
		Quit:aEpID="" return
		Set aStepID=$o(^DHCMRC("CPW",aCPWID,"EP",aEpID,"STEP",0))
		Quit:aStepID="" return
		Set aEpStep=aCPWID_"||"_aEpID_"||"_aStepID
	}
	***************************************************/
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"JsonCompItems")
	Kill ^TMP(ZIndex,JIndex,"JsonCompItemsTMP")
	
	/**************************************************
	//暂时不考虑分块取值
	//合并症中维护什么子类显示什么子类
	If aFlag="01" {
		Set aCategDesc="诊疗"
	} ElseIf aFlag="02" {
		Set aCategDesc="医嘱"
	} ElseIf aFlag="03" {
		Set aCategDesc="护理"
	} Else {
		Set aCategDesc="Error"
	}
	***************************************************/
	
	//Add by zf 20120217
	//自动同步关联医嘱和关联项目数据
	//Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(aPathWayID,aEpStep)
	//update by zf 20150630 新版本同步数据
	Set flg=##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrderByPathWay(aPathWayID)
	Set stepEstimate=##class(DHCCPW.MR.FORM.EstimateSrv).GetEstimateByStep(aPathWayID,aEpStep)
	Set StepSttDate=$list(stepEstimate,3)
	Set StepSttTime=$list(stepEstimate,4)
	Set StepEndDate=$list(stepEstimate,5)
	Set StepEndTime=$list(stepEstimate,6)
	
	/*
	//取步骤时间段内对应医嘱(医嘱开始时间)
	If aPathWayID'="" {
		Set StartDate="",StartTime=""
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
		If EstTimeLS'="" {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:aEpStep'=EstEpStepDR
				Set StartDate=$list(objEstTime,3)
				Set StartTime=$list(objEstTime,4)
				Set EndDate=$list(objEstTime,5)
				Set EndTime=$list(objEstTime,6)
			}
		}
		If (StartDate'="")&&(StartTime'="")&&(EndDate'="")&&(EndTime'="") {
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
			If $IsObject(objPathWay) {
				Set MRAdm=objPathWay.CPWMRADMDR
				Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
				Do ##Class(web.DHCCPW.MRC.FormShow).getOEOrdByStep("JsonCompItemsTMP")
			}
		}
	}
	*/
	
	Set CPWID=$p(CurrCompStep,"||",1)
	Set EpID=$p(CurrCompStep,"||",2)
	Set StepID=$p(CurrCompStep,"||",3)
	Set ItemID=""
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(CPWID_"||"_EpID_"||"_StepID_"||"_ItemID)
		Continue:'$IsObject(objItem)
		Continue:'$IsObject(objItem.CPWSISubCategory)
		Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
		Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
		//Continue:CategDesc'[aCategDesc  //按项目大类过滤
		Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
		Set SubCatID=objItem.CPWSISubCategory.%Id()
		Set GroupNo=objItem.CPWSIGroupNo
		Set tmpGroupNo=""
		If GroupNo'="" {
			Set $p(tmpGroupNo,"0",5-$l(GroupNo))=GroupNo
			Set GroupNo=tmpGroupNo
		}
		Continue:GroupNo=""
		Set ^TMP(ZIndex,JIndex,"JsonCompItems",CategID,SubCatID,GroupNo,ItemID)=""
	}
	
	Set Json="{'stepid':'"_aEpStep_"','stepdata':["
	Set CategID="",categflg=0
	For {
		Set CategID=$o(^TMP(ZIndex,JIndex,"JsonCompItems",CategID))
		Quit:CategID=""
		
		If categflg=1 {
			Set Json=Json_","
		}Else{
			Set categflg=1
		}
		
		Set SubCatID="",subcatflg=0
		For {
			Set SubCatID=$o(^TMP(ZIndex,JIndex,"JsonCompItems",CategID,SubCatID))
			Quit:SubCatID=""
			Set objSubCat=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(SubCatID)
			Continue:'$IsObject(objSubCat)
			Set SubCatDesc=objSubCat.SISCDesc
			Continue:SubCatDesc=""
			Set SubCatPower=objSubCat.SISCPower
			
			If SubCatPower="D" {
				Set itemNameList="CPW_CONSULT_ITEM"
				Set itemSubCatName="CPW_CONSULT_SELALL"
			} ElseIf SubCatPower="OE" {
				Set itemNameList="CPW_OE_ITEM"
				Set itemSubCatName="CPW_OE_SELALL"
			} ElseIf SubCatPower="NE" {
				Set itemNameList="CPW_NE_ITEM"
				Set itemSubCatName="CPW_NE_SELALL"
			} ElseIf SubCatPower="N" {
				Set itemNameList="CPW_NURSE_ITEM"
				Set itemSubCatName="CPW_NURSE_SELALL"
			} Else {
				Set itemNameList="CPW_NULL_ITEM"
				Set itemSubCatName="CPW_NULL_SELALL"
			}
			
			If subcatflg=1 {
				Set Json=Json_","
				Set ItemIDList=ItemIDList_","
			}Else{
				Set subcatflg=1
			}
			Set Json=Json_"{'stepsubcatname':'"_itemSubCatName_"','stepsubcatid':'"_aEpStep_"-"_SubCatID_"-"_$p(aCompID,"||",1)_"','subtitle':'"_SubCatDesc_"','subcatedata':["
			
			Set GroupNo="",groupflg=0
			For {
				Set GroupNo=$o(^TMP(ZIndex,JIndex,"JsonCompItems",CategID,SubCatID,GroupNo))
				Quit:GroupNo=""
				
				If groupflg=1 {
					Set Json=Json_","
				}Else{
					Set groupflg=1
				}
				Set Json=Json_"{'groupno':'"_GroupNo_"'"
				Set Json=Json_",'nameList':'"_itemNameList_"'"
				Set Json=Json_",'groupdata':["
				
				Set ItemID="",ItemIDList="",itemflg=0,tmpIsMust="",tmpArcim=""
				For {
					Set ItemID=$o(^TMP(ZIndex,JIndex,"JsonCompItems",CategID,SubCatID,GroupNo,ItemID))
					Quit:ItemID=""
					Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowid)
					Continue:'$IsObject(objItem)
					Set ItemDesc=objItem.CPWSIDesc
					Set ItemIsMust=objItem.CPWSIIsMust
					Set:ItemIsMust["Y" tmpIsMust="Y"
					Set ArcimCnt=objItem.CPWSIARCIM.Count()
					Set:ArcimCnt>0 tmpArcim="Y"
					Set tmpItemID=$o(^TMP(ZIndex,JIndex,"JsonCompItems",CategID,SubCatID,GroupNo,ItemID))
					Set ItemOptional=0
					Set:tmpIsMust="Y" ItemOptional=1
					Set:(tmpArcim'="Y")&&(tmpItemID="")&&((SubCatPower="OE")||(SubCatPower="NE")) ItemDesc=ItemDesc
					Continue:ItemDesc=""
					
					Set ItemRowid=ItemRowid_"-"_aEpStep_"-"_SubCatID
					//Set ItemImpl=..IsItemImpl(ZIndex,JIndex,aPathWayID,ItemRowid,"JsonCompItemsTMP")  //判断项目是否有实施记录
					//update by zf 20150630 新版本项目执行
					Set ItemImpl=##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement(aPathWayID,$p(ItemRowid,"-",1),$p(ItemRowid,"-",2),StepSttDate,StepEndDate)
					If ItemImpl>0 {
						Set ItemImpl=1
					}Else{
						Set ItemImpl=0
					}
					If itemflg=1 {
						Set Json=Json_","
						Set ItemIDList=ItemIDList_","
					}Else{
						Set itemflg=1
					}
					Set Json=Json_"{'id':'"_ItemRowid_"'"
					Set Json=Json_",'item':'"_ItemDesc_"'"
					Set Json=Json_",'optional':'"_ItemOptional_"'"
					Set Json=Json_",'impl':'"_ItemImpl_"'}"
					Set ItemIDList=ItemIDList_ItemRowid
				}
				Set Json=Json_"]"
				Set Json=Json_",'idList':'"_ItemIDList_"'"
				Set Json=Json_"}"
			}
			Set Json=Json_"]}"
		}
	}
	Set Json=Json_"]}"
	Kill ^TMP(ZIndex,JIndex,"JsonCompItemsTMP")
	Kill ^TMP(ZIndex,JIndex,"JsonCompItems")
	
	Set return=Json
	Quit return
	
BuildJsonCompItemsErr
	Kill ^TMP(ZIndex,JIndex,"JsonCompItemsTMP")
	Kill ^TMP(ZIndex,JIndex,"JsonCompItems")
	Quit ""
}

/// 取步骤对应医嘱信息,不能独立执行
/// ##Class(web.DHCCPW.MRC.FormShow).getOEOrdByStep("")
ClassMethod getOEOrdByStep(aGlobalStr As %String)
{
	Set ArcimCategList=$g(ArcimCategList)
	Set ArcimSubCatList=$g(ArcimSubCatList)
	New (aGlobalStr,EpisodeID,ZIndex,JIndex,StartDate,StartTime,EndDate,EndTime,ArcimCategList,ArcimSubCatList)
	
	Set StDtTmIndex=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("OEOrdItemStDtTmIndex")
	If $IsObject(objConfig){
		Set StDtTmIndex=objConfig.BCValue
	}
	Set:StDtTmIndex="" StDtTmIndex="StDtTm1"
	
	If StDtTmIndex="StDtTm1" {
		Set OrdID=$o(^OEORD(0,"Adm",+EpisodeID,""))
		If OrdID'="" {
			Set OeoriDate=StartDate-1
			For {
				Set OeoriDate=$o(^OEORDi(0,"StDtTm1",OrdID,OeoriDate))
				Quit:(OeoriDate="")||(OeoriDate>EndDate)
				Set OeoriTime=0
				For {
					Set OeoriTime=$o(^OEORDi(0,"StDtTm1",OrdID,OeoriDate,OeoriTime))
					Quit:OeoriTime=""
					//w OeoriDate_" "_OeoriTime_","_StartDate_" "_StartTime_","_EndDate_" "_EndTime,!
					Continue:(OeoriDate=StartDate)&&(OeoriTime<StartTime)
					Continue:(OeoriDate=EndDate)&&(OeoriTime>EndTime)
					Set OeoriID=0
					For {
						Set OeoriID=$o(^OEORDi(0,"StDtTm1",OrdID,OeoriDate,OeoriTime,OeoriID))
						Quit:OeoriID=""
						Set ArcimID=$p($g(^OEORD(OrdID,"I",OeoriID,1)),"^",2)
						
						Set (ArcimSubCatID,ArcimSubCat,ArcimCategID,ArcimCateg)=""
						Set ArcimSubCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
						Set:ArcimSubCatID'="" ArcimSubCat=$p($g(^ARC("IC",+ArcimSubCatID)),"^",2)
						Set:ArcimSubCatID'="" ArcimCategID=$p($g(^ARC("IC",+ArcimSubCatID)),"^",8)
						Set:ArcimCategID'="" ArcimCateg=$p($g(^OEC("ORCAT",+ArcimCategID)),"^",2)
						Continue:(ArcimCategList'="")&&(ArcimCateg'="")&&($listfind(ArcimCategList,ArcimCateg)>0)
						Continue:(ArcimSubCatList'="")&&(ArcimSubCat'="")&&($listfind(ArcimSubCatList,ArcimSubCat)>0)
						
						Set OeoriStatus=$p($g(^OEORD(+OeoriID,"I",+$p(OeoriID,"||",2),1)),"^",13)
						Set OeoriStatus=$p($g(^OEC("OSTAT",+OeoriStatus)),"^",2)
						Continue:(OeoriStatus["停")||(OeoriStatus["作废")  //医嘱状态  停止
						Set ^TMP(ZIndex,JIndex,aGlobalStr,ArcimID,OrdID_"||"_OeoriID)=""
						//w "ArcimID="_ArcimID,!
					}
				}
			}
		}
	}
	
	//友谊,安贞等,没有StDtTm1索引
	If StDtTmIndex="StDtTm" {
		Set OrdID=$o(^OEORD(0,"Adm",+EpisodeID,""))
		If OrdID'="" {
			Set OeoriDate=StartDate-1
			For {
				Set OeoriDate=$o(^OEORDi(0,"StDtTm",OeoriDate))
				Quit:(OeoriDate="")||(OeoriDate>EndDate)
				Set OeoriTime=0
				For {
					Set OeoriTime=$o(^OEORDi(0,"StDtTm",OeoriDate,OeoriTime))
					Quit:OeoriTime=""
					//w OeoriDate_" "_OeoriTime_","_StartDate_" "_StartTime_","_EndDate_" "_EndTime,!
					Continue:(OeoriDate=StartDate)&&(OeoriTime<StartTime)
					Continue:(OeoriDate=EndDate)&&(OeoriTime>EndTime)
					Set OeoriID=0
					For {
						Set OeoriID=$o(^OEORDi(0,"StDtTm",OeoriDate,OeoriTime,OrdID,OeoriID))
						Quit:OeoriID=""
						Set ArcimID=$p($g(^OEORD(OrdID,"I",OeoriID,1)),"^",2)
						
						Set (ArcimSubCatID,ArcimSubCat,ArcimCategID,ArcimCateg)=""
						Set ArcimSubCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
						Set:ArcimSubCatID'="" ArcimSubCat=$p($g(^ARC("IC",+ArcimSubCatID)),"^",2)
						Set:ArcimSubCatID'="" ArcimCategID=$p($g(^ARC("IC",+ArcimSubCatID)),"^",8)
						Set:ArcimCategID'="" ArcimCateg=$p($g(^OEC("ORCAT",+ArcimCategID)),"^",2)
						Continue:(ArcimCategList'="")&&(ArcimCateg'="")&&($listfind(ArcimCategList,ArcimCateg)>0)
						Continue:(ArcimSubCatList'="")&&(ArcimSubCat'="")&&($listfind(ArcimSubCatList,ArcimSubCat)>0)
						
						Set OeoriStatus=$p($g(^OEORD(+OeoriID,"I",+$p(OeoriID,"||",2),1)),"^",13)
						Set OeoriStatus=$p($g(^OEC("OSTAT",+OeoriStatus)),"^",2)
						Continue:(OeoriStatus["停")||(OeoriStatus["作废")  //医嘱状态  停止
						Set ^TMP(ZIndex,JIndex,aGlobalStr,ArcimID,OrdID_"||"_OeoriID)=""
						//w "ArcimID="_ArcimID,!
					}
				}
			}
		}
	}
	
	//航天中心医院,直接取HIS数据
	If StDtTmIndex="YYGL" {
		Set flg=##Class(web.DHCCPW.MR.InterfaceToPrj).getOEOrdItems(EpisodeID,StartDate,StartTime,EndDate,EndTime)
	}
}

/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.FormShow","QryCurrLocCPWPat","186")
Query QryCurrLocCPWPat(LocID As %String, UserType As %String = "D") As %Query(ROWSPEC = "PatientID:%String,PatientName:%String,PatStr:%String")
{
}

ClassMethod QryCurrLocCPWPatExecute(ByRef qHandle As %Binary, LocID As %String, UserType As %String = "D") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:LocID="" $$$OK
	
	if (UserType="D")
	{
		Set AdmDate=""
		For {
			Set AdmDate=$o(^PAADMi("CurrLoc",LocID,AdmDate))
			Quit:AdmDate=""
		
			Set AdmTime=""
			For {
				Set AdmTime=$o(^PAADMi("CurrLoc",LocID,AdmDate,AdmTime))
				Quit:AdmTime=""
				
				Set EpisodeID=""
				For {
					Set EpisodeID=$o(^PAADMi("CurrLoc",LocID,AdmDate,AdmTime,EpisodeID))
					Quit:EpisodeID=""
					
					Set MRADMID=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
					Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
					Set PathWayID=0,CPWID="",CurrPathWayID=""
					For {
						Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRADMID,PathWayID))
						Quit:(PathWayID="")||(CurrPathWayID'="")
						
						Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
						If $IsObject(objPathWay){
							Set Status=objPathWay.CPWStatus
							Continue:Status'="I"
							Set CurrPathWayID=PathWayID
						}
					}
					Continue:(CurrPathWayID="")||(PatientID="")
					
					Set PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
					
					Set Data=$lb(PatientID,PatientName,PatientID_"^"_EpisodeID_"^"_MRADMID_"^"_CurrPathWayID)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}else{
		Set RoomDR=""
		For {
			Set RoomDR=$o(^PAADMi("CurrWard",LocID,RoomDR))
			Quit:RoomDR=""
			
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^PAADMi("CurrWard",LocID,RoomDR,EpisodeID))
				Quit:EpisodeID=""	
				
				Set MRADMID=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
				Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
				Set PathWayID=0,CPWID="",CurrPathWayID=""
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRADMID,PathWayID))
					Quit:(PathWayID="")||(CurrPathWayID'="")
					
					Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay){
						Set Status=objPathWay.CPWStatus
						Continue:Status'="I"
						Set CurrPathWayID=PathWayID
					}
				}
				Continue:(CurrPathWayID="")||(PatientID="")
				
				Set PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
				
				Set Data=$lb(PatientID,PatientName,PatientID_"^"_EpisodeID_"^"_MRADMID_"^"_CurrPathWayID)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
		}
	}
	
 	Quit $$$OK
}

ClassMethod QryCurrLocCPWPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCurrLocCPWPatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCurrLocCPWPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCurrLocCPWPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
