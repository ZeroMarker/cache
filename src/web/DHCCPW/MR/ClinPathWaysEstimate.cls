/// 名称: web.DHCCPW.MR.ClinPathWaysEstimate
/// 描述: 评估记录
/// 编写者：zhufei
/// 编写日期: 2011-04-18
Class web.DHCCPW.MR.ClinPathWaysEstimate Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  根据ID取评估记录
/// Table：       User.DHCMRClinicalPathWayEstimate
/// Input：       ID:    User.DHCMRClinicalPathWayEstimate.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWayEstimate
{
	New (argId)
	Quit:$p(argId,"||",1)="" ""
	Quit:$p(argId,"||",2)="" ""
	Set return=##Class(User.DHCMRClinicalPathWayEstimate).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  取实施路径当前评估记录
/// Table：       User.DHCMRClinicalPathWayEstimate
/// Input：       ID:    User.DHCMRClinicalPathWay.Id
///               separete: 指定的分隔符
/// Return：      返回$lb($lb("步骤1","时间1"),$lb("步骤2","时间2"))
/// w ##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(3)
ClassMethod GetObjByPathWayID(aPathWayID As %String)
{
	New (aPathWayID)
	Set return=""
	Quit:aPathWayID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	Set CPWStatus=objPathWay.CPWStatus
	Set CPWOutDate=objPathWay.CPWOutDate
	Set CPWOutTime=objPathWay.CPWOutTime
	Set CurrDate=+$h,CurrTime=$p($h,",",2)
	Set CPWAdm=objPathWay.CPWMRADMDR
	Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(CPWAdm)
	
	Set IsHaveEST="N"
	Set ChildSub=$o(^DHCMR("CPW",aPathWayID,"EST",""),-1)
	If ChildSub="" {
		Set EstEpStepID=objPathWay.CPWPathwayEpStepDR.%Id()
		Set EstStartDate=objPathWay.CPWInDate
		Set EstStartTime=objPathWay.CPWInTime
		Set EstTimes=..GetEpStepTimes(EstEpStepID)
		Set IsHaveEST="N"
	} Else {
		Set objEst=..GetObjById(aPathWayID_"||"_ChildSub)
		Quit:'$IsObject(objEst) return
		Set EstEpStepID=objEst.CPWEEpStepDR.%Id()
		Set EstStartDate=objEst.CPWEStartDate
		Set EstStartTime=objEst.CPWEStartTime
		Set EstTimes=""
		Set EstTimesCnt=objEst.CPWETimes.Count()
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=objEst.CPWETimes.GetAt(EstTimesInd)
			If $IsObject(objEstTime) {
			  Continue:'$IsObject(objEstTime.EstEpStepDR)   //add by wangcs 2012-12-10
				Set EstEpStepDR=objEstTime.EstEpStepDR.%Id()
				Set EstTime=objEstTime.EstTime
				Set EstCompStepList=""
				For EstCompStepIndex=1:1:objEstTime.CPWCompStepList.Count() {
					Set EstCompStepID=objEstTime.CPWCompStepList.GetAt(EstCompStepIndex)
					Continue:EstCompStepID=""
					Set EstCompStepList=EstCompStepList_$lb(EstCompStepID)
				}
				Set EstTimes=EstTimes_$lb($lb(EstEpStepDR,EstTime,EstCompStepList))
			}
		}
		Set IsHaveEST="Y"
	}
	Quit:EstTimes="" return
	
	Set xEndDate=EstStartDate
	Set xEndTime=EstStartTime
	Set EstTimesCnt=$listlength(EstTimes)
	For EstTimesInd=1:1:EstTimesCnt {
		Set objEstTime=$list(EstTimes,EstTimesInd)
		Continue:objEstTime=""
		Set EstEpStepDR=$list(objEstTime,1)
		Set EstTime=$list(objEstTime,2)
		Set EstCompStepList=$list(objEstTime,3)
		
		Set DTime=EstTime\(24*60)
		Set HTime=(EstTime-(DTime*24*60))\60
		Set MTime=EstTime-(DTime*24*60)-(HTime*60)
		Set xStartDate=xEndDate
		Set xStartTime=xEndTime
		Set xEndDate=xStartDate+DTime
		Set xEndTime=xStartTime+(HTime*60*60)+(MTime*60)
		If (xEndTime-(24*60*60))>=0 {
			Set xEndDate=xEndDate+1
			Set xEndTime=xEndTime-(24*60*60)
		} Else {
			Set xEndDate=xEndDate
			Set xEndTime=xEndTime
		}
		If IsHaveEST="N" {
			//没有保存评估时间记录情况：
			//阶段时间跨天,阶段时长小于1天,结束时间归零,结束日期不变
			If (xEndDate>xStartDate)&&(DTime>0) {
				Set xEndTime=0
			}
		}
		
		//update by zf 20120214
		//最后一个步骤的特殊处理
		//如果最后一个步骤的结束日期小于当前日期,设置结束日期为今天的结束
		If EstTimesInd=EstTimesCnt
		{
			If (CPWStatus="I")
			{
				//Set DischDate=$p(^PAADM(+Paadm),"^",17)
				//Set DischTime=$p(^PAADM(+Paadm),"^",18)
				//Update by pylian 2016-01-21 修改出院时间取值方式
				Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
				Set DischDate=$p(DischDateTime,"^",1)
				Set DischTime=$p(DischDateTime,"^",2)
				If DischDate'="" {
					Set xEndDate=+DischDate
					Set xEndTime=+DischTime
				} else {
					If (xEndDate<CurrDate)||((xEndDate=CurrDate)&&(xEndTime<CurrTime))
					{
						Set xEndDate=CurrDate
						Set xEndTime=(24*60*60)-1
					}
				}
			}
			If (CPWStatus="C")
			{
				If (xStartDate<CPWOutDate)	//update by liuyh 2015-9-29 bug修复
				{
					Set xEndDate=CPWOutDate
					Set xEndTime=CPWOutTime
				}
			}
		}
		
		Set xEstTime=((xEndDate-xStartDate)*24*60)+((xEndTime-xStartTime)\60)
		Set xDTime=xEstTime\(24*60)
		Set xHTime=(xEstTime-(xDTime*24*60))\60
		Set xMTime=xEstTime-(xDTime*24*60)-(xHTime*60)
		Set xEstTime=""
		Set:xDTime>0 xEstTime=xEstTime_xDTime_"天"
		Set:xHTime>0 xEstTime=xEstTime_xHTime_"小时"
		Set:xMTime>0 xEstTime=xEstTime_xMTime_"分钟"
		
		Set xIsCurrStep=0
		If (CPWStatus="I")
		{
			Set flg1=0,flg2=0
			If (CurrDate>xStartDate)||((CurrDate=xStartDate)&&(CurrTime>xStartTime)) {
				Set flg1=1
			}
			If (xEndDate>CurrDate)||((CurrDate=xEndDate)&&(xEndTime>CurrTime)) {
				Set flg2=1
			}
			Set:((flg1=1)&&(flg2=1)) xIsCurrStep=1
		}
		
		Set xIsOverStep=0
		If (CPWStatus="I")
		{
			If (xStartDate<CurrDate)||((xStartDate=CurrDate)&&(xStartTime<=CurrTime)) {
				Set xIsOverStep=1
			}
		} Else {
			If (xStartDate<CPWOutDate)||((xStartDate=CPWOutDate)&&(xStartTime<=CPWOutTime)) {
				Set xIsOverStep=1
			}
		}
		//w CPWOutDate_"///"_CPWOutTime,!
		//w EstEpStepDR_"///"_xIsCurrStep_"///"_xStartDate_"///"_xStartTime_"///"_xEndDate_"///"_xEndTime_"///"_xEstTime_"///"_xIsOverStep,!
		Set return=return_$lb($lb(EstEpStepDR,xIsCurrStep,xStartDate,xStartTime,xEndDate,xEndTime,xEstTime,EstCompStepList,xIsOverStep))
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  更新User.DHCMRClinicalPathWayEstimate
/// Table：       User.DHCMRClinicalPathWayEstimate
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinPathWaysEstimate).Update("3^2||1||1^2011-03-18 15:26～2011-03-22 00:00^9")
ClassMethod Update(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Set aPathWayID=$p(argInStr,"^",1)
	Set aEpStepID=$p(argInStr,"^",2)
	Set aEpStepDateFrom=$p(argInStr,"^",3)
	Set aEpStepDateTo=$p(argInStr,"^",4)
	Set aSaveUser=$p(argInStr,"^",5)
	Quit:(aPathWayID="")||(aEpStepID="")||(aEpStepDateFrom="")||(aEpStepDateTo="") return
	
	Set return=-2
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	Set CPWID=objPathWay.CPWPathwayDR.%Id()
	Set MRAdm=objPathWay.CPWMRADMDR
	Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	//Set AdmDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	//Set AdmTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Quit:(AdmDate="")||(AdmTime="") return
	
	Set aDateFrom=$zdh($p(aEpStepDateFrom," ",1),3)
	Set aTimeFrom=$zth($p(aEpStepDateFrom," ",2),2)
	Set aDateTo=$zdh($p(aEpStepDateTo," ",1),3)
	Set aTimeTo=$zth($p(aEpStepDateTo," ",2),1)
	If (aDateFrom>aDateTo)||((aDateFrom=aDateTo)&&(aTimeFrom>aTimeTo)) {
		Set return=-2.1
		Quit return  //开始时间大于结束时间
	}ElseIf (aDateFrom<AdmDate)||((aDateFrom=AdmDate)&&(aTimeFrom<AdmTime)) {
		Set return=-2.2
		Quit return  //开始时间小于入院时间
	}Else{
		Set aEstTime=((aDateTo-aDateFrom)*24*60)+((aTimeTo-aTimeFrom)\60)
	}
	
	Set return=-3
	Set ChildSub=$o(^DHCMR("CPW",aPathWayID,"EST",""),-1)
	If ChildSub="" {
		Set return=-3.1
		Set EstEpStepID=objPathWay.CPWPathwayEpStepDR.%Id()
		If EstEpStepID=aEpStepID {
			Set EstStartDate=aDateFrom
			Set EstStartTime=aTimeFrom
		}Else{
			Set EstStartDate=objPathWay.CPWInDate
			Set EstStartTime=objPathWay.CPWInTime
		}
		Set EstTimes=..GetEpStepTimes(EstEpStepID)
		Quit:EstTimes="" return
		Set EstTimesCnt=$listlength(EstTimes)
		For EstTimesInd=1:1:EstTimesCnt {
			Set EstTime=$list(EstTimes,EstTimesInd)
			If $list(EstTime,1)=aEpStepID {
				Set $list(EstTimes,EstTimesInd)=$lb(aEpStepID,aEstTime,"")
			}
		}
	}Else{
		Set return=-3.2
		Set objEst=##class(User.DHCMRClinicalPathWayEstimate).%OpenId(aPathWayID_"||"_ChildSub)
		Quit:'$IsObject(objEst) return
		Set EstEpStepID=objEst.CPWEEpStepDR.%Id()
		Set EstStartDate=objEst.CPWEStartDate
		Set EstStartTime=objEst.CPWEStartTime
		Set EstTimes=""
		Set EstTimesCnt=objEst.CPWETimes.Count()
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=objEst.CPWETimes.GetAt(EstTimesInd)
			If $IsObject(objEstTime) {
				Set EstEpStepDR=objEstTime.EstEpStepDR.%Id()
				Set EstTime=objEstTime.EstTime
				Set EstCompList=objEstTime.CPWCompStepList
				If EstEpStepDR=aEpStepID {
					Set EstTimes=EstTimes_$lb($lb(aEpStepID,aEstTime,EstCompList))
				}Else{
					Set EstTimes=EstTimes_$lb($lb(EstEpStepDR,EstTime,EstCompList))
				}
			}
		}
	}
	
	Set return=-4
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EstEpStepID)
	Quit:objEpStep="" return
	
	TStart
	Set return=-5
	Set obj=##class(User.DHCMRClinicalPathWayEstimate).%New()
	Quit:'$IsObject(obj) return
	
	Set return=-6
	Set HeadEpStepDR=""
	Set EstTimesCnt=$listlength(EstTimes)
	For EstTimesInd=1:1:EstTimesCnt {
		Set objEstTime=$list(EstTimes,EstTimesInd)
		Set EstEpStepDR=$list(objEstTime,1)
		Set:EstTimesInd=1 HeadEpStepDR=EstEpStepDR
		Set EstEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EstEpStepDR)
		Quit:EstEpStep=""
		Set EstTime=$list(objEstTime,2)
		Set EstCompList=$list(objEstTime,3)
		Set objEstTimes=##class(User.DHCMRClinicalPathWayEstTimes).%New()
		If $IsObject(objEstTimes){
			Set objEstTimes.EstEpStepDR=EstEpStep
			Set objEstTimes.EstTime=EstTime
			Set objEstTimes.CPWCompStepList=EstCompList
		}
		If objEstTimes'="" Do objEstTimes.%Close()
		Do obj.CPWETimes.Insert(objEstTimes)
	}
	
	If HeadEpStepDR=aEpStepID {
		Set EstStartDate=aDateFrom
		Set EstStartTime=aTimeFrom
	}
	
	Set obj.CPWEParRef=objPathWay
	Set obj.CPWEEpStepDR=objEpStep
	Set obj.CPWEStartDate=EstStartDate
	Set obj.CPWEStartTime=EstStartTime
	Set obj.CPWEDate=+$h
	Set obj.CPWETime=$p($h,",",2)
	Set obj.CPWEUserDR=aSaveUser
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-999
   		TRollBack
	} Else {
		Set return=+obj.%Id()
		TCommit
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##Class(web.DHCCPW.MR.ClinPathWaysEstimate).GetEpStepTimes("8||2||1")
ClassMethod GetEpStepTimes(aEpStepID As %String) As %String
{
	New (aEpStepID)
	Set return=""
	Quit:aEpStepID="" return
	
	Set $ZT="GetEpStepTimesErr"
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"GetEpStepTimes")
	
	Set EpID="",aCPWID=+aEpStepID
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
		
		Set StepID=""
		For {
			Set StepID=$o(^DHCMRC("CPW",aCPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set StepRowid=aCPWID_"||"_EpID_"||"_StepID
			Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowid)
			Continue:'$IsObject(objStep)
			Set StepNo=objStep.CPWSDayNumber
			Set tmpStepNo=""
			If StepNo'="" {
				Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
				Set StepNo=tmpStepNo
			}
			Set StepDays=objStep.CPWSDay
			Set:StepDays="" StepDays=1
			Set StepUnit=objStep.CPWSUnit
			If StepUnit="H" {
				Set StepDays=StepDays*60
			} ElseIf StepUnit="M" {
				Set StepDays=StepDays
			} Else {
				Set StepDays=StepDays*24*60
			}
			Set ^TMP(ZIndex,JIndex,"GetEpStepTimes",EpNo,StepNo,StepRowid)=StepDays
		}
	}
	
	Set EpNo="",flg=0
	For {
		Set EpNo=$o(^TMP(ZIndex,JIndex,"GetEpStepTimes",EpNo))
		Quit:EpNo=""
		Set StepNo=""
		For {
			Set StepNo=$o(^TMP(ZIndex,JIndex,"GetEpStepTimes",EpNo,StepNo))
			Quit:StepNo=""
			Set StepRowid=""
			For {
				Set StepRowid=$o(^TMP(ZIndex,JIndex,"GetEpStepTimes",EpNo,StepNo,StepRowid))
				Quit:StepRowid=""
				Continue:(flg=0)&&(StepRowid'=aEpStepID)
				Set flg=1
				Set StepDays=+$g(^TMP(ZIndex,JIndex,"GetEpStepTimes",EpNo,StepNo,StepRowid))
				Set return=return_$lb($lb(StepRowid,StepDays,""))
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetEpStepTimes")
	
	Quit return
	
GetEpStepTimesErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2011-07-21
/// Description:  取原始的表单步骤列表
/// Input：       argPathWayID:入径记录ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysEstimate","QryPrimalEpSteps","1")
Query QryPrimalEpSteps(argPathWayID As %String) As %Query(ROWSPEC = "EpStepRowID:%String,EpStepNo:%String,EpStepDesc:%String,EpStepEstTime:%String,EpStepDay:%String,EpRowID:%String,EpDesc:%String")
{
}

ClassMethod QryPrimalEpStepsExecute(ByRef qHandle As %Binary, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	Quit:'$IsObject(objPathWay.CPWPathwayDR) $$$OK
	Set CPWID=objPathWay.CPWPathwayDR.%Id()
	Set IsOffShootCPW=objPathWay.CPWPathwayDR.CPWOffShoot
	
	Set EstTimes=""
	Set EstID=$o(^DHCMR("CPW",argPathWayID,"EST",""),-1)
	Set EstRowid=argPathWayID_"||"_EstID
	Set objEst=..GetObjById(EstRowid)
	If $IsObject(objEst) {
		Set EstTimesCnt=objEst.CPWETimes.Count()
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=objEst.CPWETimes.GetAt(EstTimesInd)
			If $IsObject(objEstTime) {
				Set EstEpStepDR=objEstTime.EstEpStepDR.%Id()
				Set EstTime=objEstTime.EstTime
				Set EstTimes=EstTimes_$lb(EstEpStepDR)
			}
		}
	}
	
	//有步骤调整记录或分支型路径
	//左侧显示步骤列表内容
	If ((+EstID)>0)||(IsOffShootCPW["Y")
	{
		Set EpID=0
		For {
			Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
			Quit:EpID=""
			
			Set EpRowid=CPWID_"||"_EpID
			Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpRowid)
			Continue:'$IsObject(objEp)
			Set EpDesc=objEp.EPDesc
			Set EpNo=+objEp.EPEpisode
			Set tmpEpNo=""
			If EpNo'="" {
				Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
				Set EpNo=tmpEpNo
			}
			Set StepID=0
			For {
				Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
				Quit:StepID=""
				
				Set StepRowid=CPWID_"||"_EpID_"||"_StepID
				Continue:$listfind(EstTimes,StepRowid)'=0  //已经加载的步骤不显示
				Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowid)
				Continue:'$IsObject(objStep)
				Set StepDesc=objStep.CPWSDesc
				Set StepDay=+objStep.CPWSDay
				Set StepNo=+objStep.CPWSDayNumber
				Set tmpStepNo=""
				If StepNo'="" {
					Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
					Set StepNo=tmpStepNo
				}
				Set StepNo=EpNo_"-"_StepNo_"-"_StepRowid
				Set StepDayUnit=objStep.CPWSUnit
				Set EstTime=0
				Set:(StepDayUnit="D")||(StepDayUnit="") EstTime=StepDay*24*60
				Set:StepDayUnit="H" EstTime=StepDay*60
				Set:StepDayUnit="M" EstTime=StepDay
				Set:(StepDayUnit="D")||(StepDayUnit="") StepDayUnit="天"
				Set:StepDayUnit="H" StepDayUnit="小时"
				Set:StepDayUnit="M" StepDayUnit="分钟"
				Set StepDay=StepDay_" "_StepDayUnit
				
				Set Data=$lb(StepRowid,StepNo,StepDesc,EstTime,StepDay,EpRowid,EpDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPrimalEpStepsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrimalEpStepsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPrimalEpStepsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrimalEpStepsExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2011-07-21
/// Description:  取调整后的表单步骤列表
/// Input：       argPathWayID:入径记录ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysEstimate","QryEstimateEpSteps","1")
Query QryEstimateEpSteps(argPathWayID As %String) As %Query(ROWSPEC = "EpStepRowID:%String,EpStepNo:%String,EpStepDesc:%String,EpStepEstTime:%String,EpStepDay:%String,EpRowID:%String,EpDesc:%String,CompStepList:%String")
{
}

ClassMethod QryEstimateEpStepsExecute(ByRef qHandle As %Binary, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	Quit:'$IsObject(objPathWay.CPWPathwayDR) $$$OK
	Set CPWID=objPathWay.CPWPathwayDR.%Id()
	Set IsOffShootCPW=objPathWay.CPWPathwayDR.CPWOffShoot
	
	Set CompList=""
	For CompListInd=1:1:objPathWay.CPWCompList.Count() {
		Set CompCPWID=objPathWay.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CompCPWID)
		Continue:'$IsObject(objCPW)
		Set CPWDesc=objCPW.CPWDesc
		Continue:CPWDesc=""
		
		Set CompList=CompList_$lb($lb(CompCPWID,CPWDesc))
	}
	
	Set EstTimes=""
	Set EstID=$o(^DHCMR("CPW",argPathWayID,"EST",""),-1)
	If ((+EstID)>0)||(IsOffShootCPW["Y") {
		//有步骤调整记录或分支型路径
		//右侧显示诊疗列表内容
		Set EstRowid=argPathWayID_"||"_EstID
		Set objEst=..GetObjById(EstRowid)
		If $IsObject(objEst) {
			Set EstTimesCnt=objEst.CPWETimes.Count()
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=objEst.CPWETimes.GetAt(EstTimesInd)
				If $IsObject(objEstTime) {
					Set StepRowid=objEstTime.EstEpStepDR.%Id()
					Set EpRowid=$p(StepRowid,"||",1)_"||"_$p(StepRowid,"||",2)		
					Set CompStepStr=""
					For compStepIndex=1:1:objEstTime.CPWCompStepList.Count() {
						Set CompStepID=objEstTime.CPWCompStepList.GetAt(compStepIndex)
						Continue:CompStepID=""
						Set CompStepStr=CompStepStr_","_CompStepID
					}
					Set:CompStepStr'="" CompStepStr=$e(CompStepStr,2,$l(CompStepStr))
					Set EstTime=+objEstTime.EstTime
					Set EstTimeD=EstTime\(60*24)
					Set EstTimeH=(EstTime-(EstTimeD*60*24))\60
					Set EstTimeM=EstTime-(EstTimeD*60*24)-(EstTimeH*60)
					Set StepDay=""
					Set:EstTimeD>0 StepDay=StepDay_EstTimeD_"天"
					Set:EstTimeH>0 StepDay=StepDay_EstTimeH_"小时"
					Set:EstTimeM>0 StepDay=StepDay_EstTimeM_"分钟"
					Set:StepDay="" StepDay="0天"
					Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpRowid)
					Continue:'$IsObject(objEp)
					Set EpDesc=objEp.EPDesc
					Set EpNo=+objEp.EPEpisode
					Set tmpEpNo=""
					If EpNo'="" {
						Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
						Set EpNo=tmpEpNo
					}
					Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowid)
					Continue:'$IsObject(objStep)
					Set StepDesc=objStep.CPWSDesc
					Set StepNo=+objStep.CPWSDayNumber
					Set tmpStepNo=""
					If StepNo'="" {
						Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
						Set StepNo=tmpStepNo
					}
					Set StepNo=EpNo_"-"_StepNo_"-"_StepRowid
					
					Set Data=$lb(StepRowid,StepNo,StepDesc,EstTime,StepDay,EpRowid,EpDesc,CompStepStr)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} Else {
		//无步骤调整记录或非分支型路径
		//右侧显示诊疗列表内容
		Set EpID=0
		For {
			Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
			Quit:EpID=""
			
			Set EpRowid=CPWID_"||"_EpID
			Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpRowid)
			Continue:'$IsObject(objEp)
			Set EpDesc=objEp.EPDesc
			Set EpNo=+objEp.EPEpisode
			Set tmpEpNo=""
			If EpNo'="" {
				Set $p(tmpEpNo,"0",5-$l(EpNo))=EpNo
				Set EpNo=tmpEpNo
			}
			Set StepID=0
			For {
				Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
				Quit:StepID=""
				
				Set StepRowid=CPWID_"||"_EpID_"||"_StepID
				Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowid)
				Continue:'$IsObject(objStep)
				Set StepDesc=objStep.CPWSDesc
				Set StepDay=+objStep.CPWSDay
				Set StepNo=+objStep.CPWSDayNumber
				Set tmpStepNo=""
				If StepNo'="" {
					Set $p(tmpStepNo,"0",5-$l(StepNo))=StepNo
					Set StepNo=tmpStepNo
				}
				Set StepNo=EpNo_"-"_StepNo_"-"_StepRowid
				Set StepDayUnit=objStep.CPWSUnit
				Set EstTime=0
				Set:(StepDayUnit="D")||(StepDayUnit="") EstTime=StepDay*24*60
				Set:StepDayUnit="H" EstTime=StepDay*60
				Set:StepDayUnit="M" EstTime=StepDay
				Set:(StepDayUnit="D")||(StepDayUnit="") StepDayUnit="天"
				Set:StepDayUnit="H" StepDayUnit="小时"
				Set:StepDayUnit="M" StepDayUnit="分钟"
				Set StepDay=StepDay_" "_StepDayUnit
				
				Set Data=$lb(StepRowid,StepNo,StepDesc,EstTime,StepDay,EpRowid,EpDesc,"")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryEstimateEpStepsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEstimateEpStepsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEstimateEpStepsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEstimateEpStepsExecute ]
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

/// w ##Class(web.DHCCPW.MR.ClinPathWaysEstimate).BuildEstStepsJsonHeader(1)
ClassMethod BuildEstStepsJsonHeader(argPathWayID) As %String
{
	New (argPathWayID)
	Set return=""
	
	Set $ZT="BuildEstStepsJsonHeaderErr"
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	Set CompList=""
	For CompListInd=1:1:objPathWay.CPWCompList.Count() {
		Set CompCPWID=objPathWay.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CompCPWID)
		Continue:'$IsObject(objCPW)
		Set CPWDesc=objCPW.CPWDesc
		Continue:CPWDesc=""
		
		Set CompList=CompList_$lb($lb(CompCPWID,CPWDesc))
	}
	
	Set gridHeader=""
	Set gridHeader=gridHeader_"var gridHeader=["
	Set gridHeader=gridHeader_"	{header: '',align: 'center',colspan: 1}"
	Set gridHeader=gridHeader_"	,{header: '',align: 'center',colspan: 1}"
	Set gridHeader=gridHeader_"	,{header: '',align: 'center',colspan: 1}"
	Set gridHeader=gridHeader_"	,{header: '',align: 'center',colspan: 1}"
	Set gridHeader=gridHeader_"	,{header: '',align: 'center',colspan: "_$ll(CompList)_"}"
	Set gridHeader=gridHeader_"];"
	
	Set storeFields=""
	Set storeFields=storeFields_"var storeFields=["
	Set storeFields=storeFields_"	{name: 'EpStepRowID', mapping: 'EpStepRowID'}"
	Set storeFields=storeFields_"	,{name: 'EpStepNo', mapping: 'EpStepNo'}"
	Set storeFields=storeFields_"	,{name: 'EpStepDesc', mapping: 'EpStepDesc'}"
	Set storeFields=storeFields_"	,{name: 'EpStepDay', mapping: 'EpStepDay'}"
	Set storeFields=storeFields_"	,{name: 'EpRowID', mapping: 'EpRowID'}"
	Set storeFields=storeFields_"	,{name: 'EpDesc', mapping: 'EpDesc'}"
	Set storeFields=storeFields_"	,{name: 'EpStepEstTime', mapping: 'EpStepEstTime'}"
	Set storeFields=storeFields_""
	For i=1:1:$ll(CompList)
	{
		Set CompCPWID=$list($list(CompList,i),1)
		Set storeFields=storeFields_"	,{name: 'Comp"_CompCPWID_"', mapping: 'Comp"_CompCPWID_"'}"
	}
	Set storeFields=storeFields_"];"
	
	Set gridColumn=""
	Set gridColumn=gridColumn_"var gridColumn=["
	Set gridColumn=gridColumn_" {header: '步骤', width: 100, dataIndex: 'EpStepDesc', sortable: false}"
	Set gridColumn=gridColumn_" ,{header: '参考时间', width: 60, dataIndex: 'EpStepDay', sortable: false}"
	For i=1:1:$ll(CompList)
	{
		Set CompCPWID=$list($list(CompList,i),1)
		Set CompCPWDesc=$list($list(CompList,i),2)
		Set gridColumn=gridColumn_"	,new Ext.grid.CheckColumn({header: '"_CompCPWDesc_"',width: 100,sortable: false,dataIndex: 'Comp"_CompCPWID_"'})"
	}
	Set gridColumn=gridColumn_"];"
	
	Set return=gridHeader_" "_gridColumn_" "_storeFields
	Quit return
	
BuildEstStepsJsonHeaderErr
	Quit ""
}

/// w ##Class(web.DHCCPW.MR.ClinPathWaysEstimate).BuildEstStepsJsonStore("1")
ClassMethod BuildEstStepsJsonStore(argPathWayID As %String) As %String
{
	New (argPathWayID)
	Set return=0,rstCount=0
	
	Set $ZT="BuildEstStepsJsonStoreErr"
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	Set CompList=""
	For CompListInd=1:1:objPathWay.CPWCompList.Count() {
		Set CompCPWID=objPathWay.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CompCPWID)
		Continue:'$IsObject(objCPW)
		Set CPWDesc=objCPW.CPWDesc
		Continue:CPWDesc=""
		
		Set CompList=CompList_$lb($lb(CompCPWID,CPWDesc))
	}
	
	Write "{record:[",!
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "web.DHCCPW.MR.ClinPathWaysEstimate"
	Set rset.QueryName = "QryEstimateEpSteps"
	Do rset.Execute(argPathWayID)
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
			Write:rstCount>0 ","
			Set json=""
			Set json=json_"{"
			Set json=json_"EpStepRowID:'"_rset.Data("EpStepRowID")_"'"
			Set json=json_",EpStepNo:'"_rset.Data("EpStepNo")_"'"
			Set json=json_",EpStepDesc:'"_rset.Data("EpStepDesc")_"'"
			Set json=json_",EpStepDay:'"_rset.Data("EpStepDay")_"'"
			Set json=json_",EpRowID:'"_rset.Data("EpRowID")_"'"
			Set json=json_",EpDesc:'"_rset.Data("EpDesc")_"'"
			Set json=json_",EpStepEstTime:'"_rset.Data("EpStepEstTime")_"'"
			Set CompStepList=rset.Data("CompStepList")
			
			For i=1:1:$ll(CompList)
			{
				Set CompValue=0
				Set CompCPWID=$list($list(CompList,i),1)
				For j=1:1:$l(CompStepList,",")
				{
					Set CompStepID=+$p(CompStepList,",",j)
					Set:CompCPWID=CompStepID CompValue=1
				}
				Set json=json_",Comp"_CompCPWID_":"_CompValue_""
			}
			Set json=json_"}"
			Write json,!
			Set rstCount=rstCount+1
		}Else{ Quit }
	}
	Write "],total : "_rstCount_"}"
	
	Set return=1
	Quit return
	
BuildEstStepsJsonStoreErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-07-21
/// Description:  取并发症路径表单
/// Input：       argPathWayID:入径记录ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysEstimate","QryPrimalComp","1")
Query QryPrimalComp(argPathWayID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String")
{
}

ClassMethod QryPrimalCompExecute(ByRef qHandle As %Binary, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	Set CompList=""
	For CompListInd=1:1:objPathWay.CPWCompList.Count() {
		Set CompCPWID=objPathWay.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Set CompList=CompList_$lb(CompCPWID)
	}
	
	Set CPWDID=0
	For {
		Set CPWDID=$o(^DHCMRC("CPWD",CPWDID))
		Quit:CPWDID=""
		
		Set objCPWD=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
		If $IsObject(objCPWD){
			Set Code=objCPWD.CPWDCode
			Set Desc=objCPWD.CPWDDesc
			Continue:'$IsObject(objCPWD.CPWDCPWTypeDR)
			Continue:(objCPWD.CPWDCPWTypeDR.CLPTCode'="SYNDROME")
			
			Set Active=$s(objCPWD.CPWDActive["Y":"Yes",1:"No")
			Continue:Active'["Y"
			Set DateFrom=objCPWD.CPWDDateFrom
			Set DateTo=objCPWD.CPWDDateTo
			Continue:(DateFrom'="")&&((+DateFrom) > (+$h))
			Continue:(DateTo'="")&&((+DateTo) < (+$h))
			Set VerID=objCPWD.CPWDVersion
			Continue:VerID=""
			Continue:$listfind(CompList,VerID)'=0
			
			Set Data=$lb(VerID,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPrimalCompClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrimalCompExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPrimalCompFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrimalCompExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2011-07-21
/// Description:  取路径对应并发症表单
/// Input：       argPathWayID:入径记录ID
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysEstimate","QryEstimateComp","1")
Query QryEstimateComp(argPathWayID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String")
{
}

ClassMethod QryEstimateCompExecute(ByRef qHandle As %Binary, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	Set CompList=""
	For CompListInd=1:1:objPathWay.CPWCompList.Count() {
		Set CompCPWID=objPathWay.CPWCompList.GetAt(CompListInd)
		Continue:CompCPWID=""
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CompCPWID)
		Continue:'$IsObject(objCPW)
		Set CPWDesc=objCPW.CPWDesc
		
		Set Data=$lb(CompCPWID,CPWDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEstimateCompClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEstimateCompExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEstimateCompFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEstimateCompExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2011-07-22
/// Description:  更新User.DHCMRClinicalPathWayEstimate
/// Table：       User.DHCMRClinicalPathWayEstimate
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinPathWaysEstimate).UpdateEstimate("1^8||1||1/802/68,67$8||2||1/2880/67$8||3||1/2880/68$8||5||1/2880/^208")
ClassMethod UpdateEstimate(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Set aPathWayID=$p(argInStr,"^",1)
	Set aEstInfo=$p(argInStr,"^",2)
	Set aSaveUser=$p(argInStr,"^",3)
	Quit:(aPathWayID="")||(aEstInfo="")||(aSaveUser="") return
	
	Set return=-2
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	Set CPWID=objPathWay.CPWPathwayDR.%Id()
	Set EstStartDate=objPathWay.CPWInDate
	Set EstStartTime=objPathWay.CPWInTime
	Set ChildSub=$o(^DHCMR("CPW",aPathWayID,"EST",""),-1)
	If ChildSub'="" {
		Set objEst=..GetObjById(aPathWayID_"||"_ChildSub)
		Quit:'$IsObject(objEst) return
		Set EstStartDate=objEst.CPWEStartDate
		Set EstStartTime=objEst.CPWEStartTime
		Quit:(EstStartDate="")||(EstStartTime="") return
	}
	
	Set return=-3
	Set EstEpStepID=$p($p(aEstInfo,"$",1),"/",1)  //起始步骤
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EstEpStepID)
	Quit:objEpStep="" return
	
	TStart
	Set return=-4,flg=0
	Set obj=##class(User.DHCMRClinicalPathWay).%OpenId(aPathWayID)
	Set obj.CPWPathwayEpStepDR=objEpStep
	Set obj.CPWUpdateDate=+$h
	Set obj.CPWUpdateTime=$p($h,",",2)
	Set obj.CPWUpdateUserDR=aSaveUser
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		TRollBack
   		Set flg=-1
	}
	Do obj.%Close()
	Quit:flg<0 return
	
	Set return=-5
	Set obj=##class(User.DHCMRClinicalPathWayEstimate).%New()
	For EstTimesIndex=1:1:$l(aEstInfo,"$")
	{
		Set EstEpStepDR=$p($p(aEstInfo,"$",EstTimesIndex),"/",1)  //步骤
		Set objEstEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EstEpStepDR)
		Set EstTime=$p($p(aEstInfo,"$",EstTimesIndex),"/",2)      //步骤时间
		Set EstCompList=$p($p(aEstInfo,"$",EstTimesIndex),"/",3)     //并发症步骤
		
		Set objEstTimes=##class(User.DHCMRClinicalPathWayEstTimes).%New()
		If $IsObject(objEstTimes){
			Set objEstTimes.EstEpStepDR=objEstEpStep
			Set objEstTimes.EstTime=EstTime
			For EstCompListIndex=1:1:$l(EstCompList,",") {
				Set EstCompCPWStepID=$p(EstCompList,",",EstCompListIndex)
				Continue:EstCompCPWStepID=""
				//**************************************************
				//目前情况，合并症只定义一个步骤
				//传进来的参数是合并症ID，转成合并症步骤ID
				Set EstCompCPWID=+EstCompCPWStepID
				Set EstCompCPWEpID=$o(^DHCMRC("CPW",EstCompCPWID,"EP",0))
				Continue:EstCompCPWEpID=""
				Set EstCompCPWStepID=$o(^DHCMRC("CPW",EstCompCPWID,"EP",EstCompCPWEpID,"STEP",0))
				Continue:EstCompCPWStepID=""
				Set EstCompCPWEpStepID=EstCompCPWID_"||"_EstCompCPWEpID_"||"_EstCompCPWStepID
				//**************************************************
				Do objEstTimes.CPWCompStepList.Insert(EstCompCPWEpStepID)
			}
		}
		Do objEstTimes.%Close()
		Do obj.CPWETimes.Insert(objEstTimes)
	}
	Set obj.CPWEParRef=objPathWay
	Set obj.CPWEEpStepDR=objEpStep
	Set obj.CPWEStartDate=EstStartDate
	Set obj.CPWEStartTime=EstStartTime
	Set obj.CPWEDate=+$h
	Set obj.CPWETime=$p($h,",",2)
	Set obj.CPWEUserDR=aSaveUser
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-999
   		TRollBack
   		Set flg=-1
	} Else {
		Set return=+obj.%Id()
	}
	Do obj.%Close()
	Quit:flg<0 return
	
	TCommit
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-26
/// Description:  删除调整步骤前的检查
///               产生实施记录后不允许再删除，签名后不允许再删除
/// Table：       User.DHCMRClinicalPathWayEstimate
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinPathWaysEstimate).CheckEstStepToDel("1","8||1||1")
ClassMethod CheckEstStepToDel(argPathWayID As %String, argStepID As %String) As %String
{
	New (argPathWayID,argStepID)
	Set return=""
	Quit:(argPathWayID="")||(argStepID="") return
	
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(argStepID)
	Quit:'$IsObject(objEpStep) return
	Set StepDesc=objEpStep.CPWSDesc
	
	//产生实施记录后不允许再删除
	//^DHCMRi(0,"IMPL","IndexStepDR",10,"8||1||1",1)
	Set SubID=0,IsHaveImpl="N"
	For {
		Set SubID=$o(^DHCMRi(0,"IMPL","IndexStepDR",argPathWayID,argStepID,SubID))
		Quit:SubID=""
		Quit:IsHaveImpl="Y"
		Set objImplement=##class(web.DHCCPW.MR.Implement).GetObjById(argPathWayID_"||"_SubID)
		Continue:'$IsObject(objImplement)
		Set Active=objImplement.CPWEActive
		Continue:Active["N"
		Set IsHaveImpl="Y"
	}
	Set:IsHaveImpl="Y" return=return_"实施记录,"
	
	//产生签名记录后不允许再删除
	//^DHCMRi(0,"SIGN","IndexEpStep",1,"8||1||1",1)
	Set SubID=0,IsHaveSign="N"
	For {
		Set SubID=$o(^DHCMRi(0,"SIGN","IndexEpStep",argPathWayID,argStepID,SubID))
		Quit:SubID=""
		Quit:IsHaveSign="Y"
		Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(argPathWayID_"||"_SubID)
		Continue:'$IsObject(objSign)
		Set Active=objSign.CPWSActive
		Continue:Active["N"
		Set IsHaveSign="Y"
	}
	Set:IsHaveSign="Y" return=return_"签名记录,"
	
	//产生变异记录后不允许再删除
	//^DHCMRi(0,"VAR","IndexEpStep",1,"8||2||1",1)
	Set SubID=0,IsHaveVar="N"
	For {
		Set SubID=$o(^DHCMRi(0,"VAR","IndexEpStep",argPathWayID,argStepID,SubID))
		Quit:SubID=""
		Quit:IsHaveVar="Y"
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(argPathWayID_"||"_SubID)
		Continue:'$IsObject(objVariance)
		Set UpdoFlag=objVariance.CPWVUpdoFlag
		Continue:UpdoFlag["Y"
		Set IsHaveVar="Y"
	}
	Set:IsHaveVar="Y" return=return_"变异记录,"
	
	Set:return'="" return="步骤 "_StepDesc_" 已产生"_return_"不允许再删除!"
	Quit return
}

}
