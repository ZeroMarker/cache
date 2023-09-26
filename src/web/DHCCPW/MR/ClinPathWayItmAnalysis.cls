/// 名称：web.DHCCPW.MR.ClinPathWayItmAnalysis
/// 描述：临床路径项目统计(路径外医嘱、必选项目未执行、可选项目已执行)
/// 编写者：zhufei
/// 编写日期：2011-11-22
Class web.DHCCPW.MR.ClinPathWayItmAnalysis Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-11-22
/// Description:  临床路径相关信息
/// Return:       $lb() 或 ""
ClassMethod BuildCPWData(argPathWayID As %String) As %List
{
	New (argPathWayID)
	Set return=""
	Set obj=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(obj) return
	Set MRAdm=obj.CPWMRADMDR
	Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	If $IsObject(obj.CPWPathwayDR)
	{
		Set PathwayDR=obj.CPWPathwayDR.%Id()
		Set PathWayDesc=obj.CPWPathwayDR.CPWDesc
	}
	Set Status=obj.CPWStatus
	Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
    If $IsObject(objPaadm)
    {
	    If $IsObject(objPaadm.PAADMPAPMIDR)
	    {
		    Set objPatient=objPaadm.PAADMPAPMIDR
		    Set PatientID=objPatient.%Id()
		    //Set PapmiNo=objPatient.PAPMINo
		    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		    Set PatName=objPatient.PAPMIName
		    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
			Set Birthday=objPatient.PAPMIDOB
		    Set:Birthday'="" Birthda=$zd(Birthday,3)
			
		    //update by zf 20150228 统一调用年龄计算方法
		    Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”

		    Set PersonalID=objPatient.PAPMIID
		}
		
	    //Set AdmitDate=objPaadm.PAADMAdmDate
	    //Set AdmitTime=objPaadm.PAADMAdmTime
	    //upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	    //Set DisDate=objPaadm.PAADMDischgDate
	    //Set DisTime=objPaadm.PAADMDischgTime
	    //Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DisDate=$p(DischDateTime,"^",1)
		Set DisTime=$p(DischDateTime,"^",2)
	    If DisDate'="" {
		    Set AdmDays=DisDate-AdmitDate
	    } Else {
			Set AdmDays=+$h-AdmitDate
		}
	    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	    Set:DisDate'="" DisDate=$zd(DisDate,3)
	    Set:DisTime'="" DisTime=$zt(DisTime,1)
	    If $IsObject(objPaadm.PAADMDepCodeDR)
	    {
		    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
		    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		}
	    If $IsObject(objPaadm.PAADMCurrentWardDR)
	    {
		    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
		    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		}
		If $IsObject(objPaadm.PAADMAdmDocCodeDR)
		{
			Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
		}
		Set AdmStatus=objPaadm.PAADMVisitStatus
	}
	
	//路径信息
	Set Data=$lb($g(argPathWayID))
	Set Data=Data_$lb($g(Paadm))
	Set Data=Data_$lb($g(PathWayDesc))
	Set Data=Data_$lb($g(StatusDesc))
    Set Data=Data_$lb($g(PatientID))
    Set Data=Data_$lb($g(PapmiNo))
    Set Data=Data_$lb($g(PatName))
    Set Data=Data_$lb($g(Sex))
    Set Data=Data_$lb($g(Birthday))
    Set Data=Data_$lb($g(Age))
    Set Data=Data_$lb($g(PersonalID))
	Set Data=Data_$lb($g(AdmitDate))
	Set Data=Data_$lb($g(AdmitTime))
	Set Data=Data_$lb($g(DisDate))
	Set Data=Data_$lb($g(DisTime))
	Set Data=Data_$lb($g(AdmLoc))
	Set Data=Data_$lb($g(AdmWard))
	Set Data=Data_$lb($g(AdmDoc))
    
	Quit Data
}

/// Creator：     zhufei
/// CreatDate：   2011-11-22
/// Description:  统计病种路径情况
/// Input：       DateFrom(开始日期),DateTo(结束日期),AdmLoc(科室),CPWDs(路径)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWayItmAnalysis","QryItemExecRatio","2011-11-25","2011-11-28","","")
Query QryItemExecRatio(argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Query(ROWSPEC = "PathWayID:%String,Paadm:%String,CPWDicDesc:%String,StatusDesc:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmDoc:%String,VarReason:%String,ExtraType:%String,ExtraDesc:%String,Num:%String")
{
}

ClassMethod QryItemExecRatioExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"VarReasonByOut")
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID))
		Quit:CPWID=""
		For OutDate=argDateFrom:1:argDateTo {
			Set OutTime=0
			For {
				Set OutTime=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID,OutDate,OutTime))
				Quit:OutTime=""
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexPathWayOutDate",CPWID,OutDate,OutTime,PathWayID))
					Quit:PathWayID=""
					
					Set (Paadm,AdmLoc,AdmWard)=""
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set MRAdm=objPathWay.CPWMRADMDR
						Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:Paadm=""
					
					Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
					If $IsObject(objPaadm)
					{
						If $IsObject(objPaadm.PAADMDepCodeDR)
					    {
						    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
						}
					    If $IsObject(objPaadm.PAADMCurrentWardDR)
					    {
						    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
						    {
							    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
							}
						}
					}
					If objPaadm'="" Do objPaadm.%Close()
					Continue:(argLocID'="")&&(argLocID'=AdmLoc)
					Continue:(argWardID'="")&&(argWardID'=AdmWard)
					Set SubID=""
					For {
						Set SubID=$o(^DHCMR("CPW",PathWayID,"VAR",SubID))
						Quit:SubID=""
						Set VarianceID=PathWayID_"||"_SubID
						Set VarReasonDR=""
						Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
						Continue:'$IsObject(objVariance)
						Set VUpdoFlag=objVariance.CPWVUpdoFlag
						Continue:VUpdoFlag["N"
						If $IsObject(objVariance.CPWVReasonDR) {
							Set VarReasonDR=objVariance.CPWVReasonDR.%Id()
						}
						Continue:VarReasonDR=""
						Set ^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID)=""
						Set VExtraValues=objVariance.CPWVExtraValues
						For indExtra=1:1:$l(VExtraValues,",") {
							Set VExtraValue=$p(VExtraValues,",",indExtra)
							Continue:VExtraValue=""
							Set (ArcimID,EpStepID)=""
							If VExtraValue["ARCIM:" {
								Set VExtraValueID=$p(VExtraValue,":",2)
								Set ArcimID=$p(VExtraValueID,"-",1)
								Set EpStepID=$p(VExtraValueID,"-",2)
							}
							If VExtraValue["OEITEM:" {
								Set VExtraValueID=$p(VExtraValue,":",2)
								Set OEOrdItemID=$p(VExtraValueID,"-",1)
								Set ArcimID=$p($g(^OEORD(+OEOrdItemID,"I",+$p(OEOrdItemID,"||",2),1)),"^",2)
								Set EpStepID=$p(VExtraValueID,"-",2)
							}
							Set:((ArcimID'="")&&(EpStepID'="")) ^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID,"OEITEM",+VarReasonDR,ArcimID)=""
							Set (CPWItemID,EpStepID)=""
							If VExtraValue["CPWITM:" {
								Set VExtraValueID=$p(VExtraValue,":",2)
								Set CPWItemID=$p(VExtraValueID,"-",1)
								Set EpStepID=$p(VExtraValueID,"-",2)
							}
							Set:((CPWItemID'="")&&(EpStepID'="")) ^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID,"CPWITM",VarReasonDR,CPWItemID)=""
						}
					}
				}
			}
		}
	}
	
	Set PathWayID=0,num=0
	For {
		Set PathWayID=$o(^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID))
		Quit:PathWayID=""
		Set Data=..BuildCPWData(PathWayID)
		Set EpStepID=0
		For {
			Set EpStepID=$o(^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID))
			Quit:EpStepID=""
			Set VarReasonDR=""
			For {
				Set VarReasonDR=$o(^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID,"OEITEM",VarReasonDR))
				Quit:VarReasonDR=""
				Set VarReason=$list($g(^DHCMRC("VR",+VarReasonDR)),3)
				Continue:VarReason=""
				Set ArcimID=""
				For {
					Set ArcimID=$o(^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID,"OEITEM",VarReasonDR,ArcimID))
					Quit:ArcimID=""
					Set ExtraDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
					Continue:ExtraDesc=""
					Set ExtraType="路径外医嘱"
					Set num=num+1
					Set ^CacheTemp(repid,ind)=Data_$lb(VarReason,"路径外医嘱",ExtraDesc,num)
					Set ind=ind+1
				}
			}
			Set VarReasonDR=""
			For {
				Set VarReasonDR=$o(^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID,"CPWITM",VarReasonDR))
				Quit:VarReasonDR=""
				Set VarReason=$list($g(^DHCMRC("VR",+VarReasonDR)),3)
				Continue:VarReason=""
				Set ItemID=""
				For {
					Set ItemID=$o(^TMP(ZIndex,JIndex,"VarReasonByOut",PathWayID,EpStepID,"CPWITM",VarReasonDR,ItemID))
					Quit:ItemID=""
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemID)
					Continue:'$IsObject(objItem)
					Set ExtraDesc=objItem.CPWSIDesc
					Continue:ExtraDesc=""
					Set IsMust=objItem.CPWSIIsMust
					Set ExtraType=$s(IsMust["Y":"可选项目执行",1:"必选项目未执行")
					Set num=num+1
					Set ^CacheTemp(repid,ind)=Data_$lb(VarReason,ExtraType,ExtraDesc,num)
					Set ind=ind+1
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"VarReasonByOut")
	
	Quit $$$OK
}

ClassMethod QryItemExecRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemExecRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemExecRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemExecRatioExecute ]
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
