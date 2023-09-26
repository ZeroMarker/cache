/// 名称: DHCWMR.SSService.VolLateQry
/// 描述: 迟归病历查询服务
/// 编写者：zhufei
/// 编写日期: 2014-12-29
Class DHCWMR.SSService.VolLateQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-12-29
/// Description:  迟归病历统计
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolLateQry","QryVolLateStat","4","7","2014-07-01","2014-07-03")
Query QryVolLateStat(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String) As %Query(ROWSPEC = "StatLocID:%String,StatLocDesc:%String,DischCnt:%String,Dis1DLateCnt:%String,Dis2DLateCnt:%String,Dis3DLateCnt:%String,Dis7DLateCnt:%String,Dis1DLateRatio:%String,Dis2DLateRatio:%String,Dis3DLateRatio:%String,Dis7DLateRatio:%String,DeathCnt:%String,Dth6DLateCnt:%String,Dth6DLateRatio:%String")
{
}

ClassMethod QryVolLateStatExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aLocGrpID,aLocID)
	
	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	Kill arrLocStatResult
	Set xStepCode=""
	For {
		Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
		Quit:xStepCode=""
		Continue:(xStepCode["C")  //临时病历过滤掉
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate,xVolID))
				Quit:xVolID=""
				
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:objVol.SVIsActive'=1
				Continue:'$IsObject(objVol.SVMainDr)
				Continue:objVol.SVMainDr.SMIsActive'=1
				Continue:'$IsObject(objVol.SVMainDr.SMMrType)
				Continue:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID
				
				Set DischDate=objVol.SVDischDate
				Continue:(aDateFrom'="")&&(aDateFrom>DischDate)
				Continue:(aDateTo'="")&&(aDateTo<DischDate)
				Set BackDate=objVol.SVBackDate
				Set:BackDate="" BackDate=+$h
				
				Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
				Continue:VolAdmStr=""
				Set VolAdmID=$p(VolAdmStr,",",1)
				Set EpisodeID=$p(VolAdmStr,",",2)
				Set AdmLoc=$p(VolAdmStr,",",3)
				Continue:AdmLoc=""
				Set AdmWard=$p(VolAdmStr,",",4)
				Set AdmHosp=$p(VolAdmStr,",",5)
			    If (AdmHosp'="")&&(aHospID'="") {
					Continue:(aHospID'[(","_AdmHosp_",")) //检查院区是否符合
			    }
				If aLocID'="" {
			    	Continue:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|"))
			    }
				
				//取死亡时间
				Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
				Continue:'$IsObject(objVolAdm)
				Set DeathDate=objVolAdm.VPDeathDate
				
				//算迟归天数
				Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,BackDate)  //假日数
				Set BackDays=BackDate-DischDate-HolidaysConut
				Set:BackDays<0 BackDays=0
				
				Set StatLocID=AdmLoc
				If DeathDate="" {
					Set num=$i(arrLocStatResult(1,StatLocID,"出院人数"))
					Set:BackDays>1 num=$i(arrLocStatResult(1,StatLocID,"1日迟归"))
					Set:BackDays>2 num=$i(arrLocStatResult(1,StatLocID,"2日迟归"))
					Set:BackDays>3 num=$i(arrLocStatResult(1,StatLocID,"3日迟归"))
					Set:BackDays>7 num=$i(arrLocStatResult(1,StatLocID,"7日迟归"))  //fix bug 6640
					
					Set num=$i(arrLocStatResult(2,"合计","出院人数"))
					Set:BackDays>1 num=$i(arrLocStatResult(2,"合计","1日迟归"))
					Set:BackDays>2 num=$i(arrLocStatResult(2,"合计","2日迟归"))
					Set:BackDays>3 num=$i(arrLocStatResult(2,"合计","3日迟归"))
					Set:BackDays>7 num=$i(arrLocStatResult(2,"合计","7日迟归"))     //fix bug 6640
				} Else {
					Set num=$i(arrLocStatResult(1,StatLocID,"死亡人数"))
					Set:BackDays>6 num=$i(arrLocStatResult(1,StatLocID,"6日迟归"))
					
					Set num=$i(arrLocStatResult(2,"合计","死亡人数"))
					Set:BackDays>6 num=$i(arrLocStatResult(2,"合计","6日迟归"))
				}
			}
		}
	}
	
	Set xStatLocID=0
	For {
		Set xStatLocID=$o(arrLocStatResult(1,xStatLocID))
		Quit:xStatLocID=""
		Set StatLocDesc=$p($g(^CTLOC(+xStatLocID)),"^",2)
		Set:$p(StatLocDesc,"-",2)'="" StatLocDesc=$p(StatLocDesc,"-",2)
		
		Set DischCnt=+$g(arrLocStatResult(1,xStatLocID,"出院人数"))
		Set Dis1DLateCnt=+$g(arrLocStatResult(1,xStatLocID,"1日迟归"))
		Set Dis2DLateCnt=+$g(arrLocStatResult(1,xStatLocID,"2日迟归"))
		Set Dis3DLateCnt=+$g(arrLocStatResult(1,xStatLocID,"3日迟归"))
		Set Dis7DLateCnt=+$g(arrLocStatResult(1,xStatLocID,"7日迟归"))
		If DischCnt>0 {
			Set Dis1DLateRatio=$fn((Dis1DLateCnt/DischCnt)*100,"",2)_"%"
			Set Dis2DLateRatio=$fn((Dis2DLateCnt/DischCnt)*100,"",2)_"%"
			Set Dis3DLateRatio=$fn((Dis3DLateCnt/DischCnt)*100,"",2)_"%"
			Set Dis7DLateRatio=$fn((Dis7DLateCnt/DischCnt)*100,"",2)_"%"
		} Else {
			Set Dis1DLateRatio="-"
			Set Dis2DLateRatio="-"
			Set Dis3DLateRatio="-"
			Set Dis7DLateRatio="-"
		}
		
		Set DeathCnt=+$g(arrLocStatResult(1,xStatLocID,"死亡人数"))
		Set Dth6DLateCnt=+$g(arrLocStatResult(1,xStatLocID,"6日迟归"))
		If DeathCnt>0 {
			Set Dth6DLateRatio=$fn((Dth6DLateCnt/DeathCnt)*100,"",2)_"%"
		} Else {
			Set Dth6DLateRatio="-"
		}
		
		Set Data=$lb(xStatLocID,StatLocDesc,DischCnt,Dis1DLateCnt,Dis2DLateCnt,Dis3DLateCnt,Dis7DLateCnt,Dis1DLateRatio,Dis2DLateRatio,Dis3DLateRatio,Dis7DLateRatio,DeathCnt,Dth6DLateCnt,Dth6DLateRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set DischCnt=+$g(arrLocStatResult(2,"合计","出院人数"))
	Set Dis1DLateCnt=+$g(arrLocStatResult(2,"合计","1日迟归"))
	Set Dis2DLateCnt=+$g(arrLocStatResult(2,"合计","2日迟归"))
	Set Dis3DLateCnt=+$g(arrLocStatResult(2,"合计","3日迟归"))
	Set Dis7DLateCnt=+$g(arrLocStatResult(2,"合计","7日迟归"))
	If DischCnt>0 {
		Set Dis1DLateRatio=$fn((Dis1DLateCnt/DischCnt)*100,"",2)_"%"
		Set Dis2DLateRatio=$fn((Dis2DLateCnt/DischCnt)*100,"",2)_"%"
		Set Dis3DLateRatio=$fn((Dis3DLateCnt/DischCnt)*100,"",2)_"%"
		Set Dis7DLateRatio=$fn((Dis7DLateCnt/DischCnt)*100,"",2)_"%"
	} Else {
		Set Dis1DLateRatio="-"
		Set Dis2DLateRatio="-"
		Set Dis3DLateRatio="-"
		Set Dis7DLateRatio="-"
	}
	
	Set DeathCnt=+$g(arrLocStatResult(2,"合计","死亡人数"))
	Set Dth6DLateCnt=+$g(arrLocStatResult(2,"合计","6日迟归"))
	If DeathCnt>0 {
		Set Dth6DLateRatio=$fn((Dth6DLateCnt/DeathCnt)*100,"",2)_"%"
	} Else {
		Set Dth6DLateRatio="-"
	}
	
	Set Data=$lb("-","合计",DischCnt,Dis1DLateCnt,Dis2DLateCnt,Dis3DLateCnt,Dis7DLateCnt,Dis1DLateRatio,Dis2DLateRatio,Dis3DLateRatio,Dis7DLateRatio,DeathCnt,Dth6DLateCnt,Dth6DLateRatio)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill arrLocStatResult
	
	Quit $$$OK
}

ClassMethod QryVolLateStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolLateStatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolLateStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolLateStatExecute ]
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

/// Creator：     maxp
/// CreatDate：   2018-2-27
/// Description:  迟归病历统计明细
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
/// 				  aLocGrpID : 科室组
/// 				  aLocID ：科室ID
/// 				  aLateDay : 迟归天数	
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolLateQry","QryVolLateStatDtl","4","7","2014-07-01","2014-07-03")
Query QryVolLateStatDtl(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aLateDay As %String) As %Query(ROWSPEC = "VolID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PatName:%String,PapmiNo:%String,Sex:%String,Age:%String,IDCode:%String,DeptDesc:%String,WardDesc:%String,AdmitDate:%String,AdmitTime:%String,DischDate:%String,DischTime:%String,BackDate:%String,LateDays:%Integer,DoctorName:%String,DeathDate:%String")
{
}

ClassMethod QryVolLateStatDtlExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aLateDay As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set:+aLocID=0 aLocID=""
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	Set xStepCode=""
	For {
		Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
		Quit:xStepCode=""
		Continue:(xStepCode["C")  //临时病历过滤掉
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate,xVolID))
				Quit:xVolID=""
				
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:objVol.SVIsActive'=1
				Continue:'$IsObject(objVol.SVMainDr)
				Continue:objVol.SVMainDr.SMIsActive'=1
				Continue:'$IsObject(objVol.SVMainDr.SMMrType)
				Continue:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID
				
				Set DischDate=objVol.SVDischDate
				Continue:(aDateFrom'="")&&(aDateFrom>DischDate)
				Continue:(aDateTo'="")&&(aDateTo<DischDate)
				Set BackDate=objVol.SVBackDate
				Set:BackDate="" BackDate=+$h
				
				Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
				Continue:VolAdmStr=""
				Set VolAdmID=$p(VolAdmStr,",",1)
				Set EpisodeID=$p(VolAdmStr,",",2)
				Set AdmLoc=$p(VolAdmStr,",",3)
				Continue:AdmLoc=""
				Set AdmWard=$p(VolAdmStr,",",4)
				Set AdmHosp=$p(VolAdmStr,",",5)
			    If (AdmHosp'="")&&(aHospID'="") {
					Continue:(aHospID'[(","_AdmHosp_",")) //检查院区是否符合
			    }
				If aLocID'="" {
			    	Continue:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|"))
			    }
				
				//取死亡时间
				Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
				Continue:'$IsObject(objVolAdm)
				Set DeathDate=objVolAdm.VPDeathDate
				
				//算迟归天数
				Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,BackDate)  //假日数
				Set BackDays=BackDate-DischDate-HolidaysConut
				Set:BackDays<0 BackDays=0
				//Continue:BackDays<=(+aLateDay)
				If aLateDay<0 {
					Continue:DeathDate=""
				}else{
					Continue:(aLateDay'=6)&&(DeathDate'="")
					Continue:(aLateDay=6)&&(DeathDate="")
					Continue:(aLateDay>0)&&(BackDays<=aLateDay)
				}
				
				Set MrNo=objVol.SVMainDr.SMMrNo
				Set PatName   = objVolAdm.VPPatName
				Set PatientID = objVolAdm.VPPatientID
				Set PapmiNo   = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
				Set Sex = objVolAdm.VPSex
				Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")  //年龄
				Set IDCode=objVolAdm.VPIdentityCode //身份证
				Set AdmitDate=objVolAdm.VPAdmitDate
				Set:AdmitDate'="" AdmitDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmitDate)
				Set AdmitTime=objVolAdm.VPAdmitTime
				Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
				//Set AdmitDeptDesc=objVolAdm.VPAdmitDeptDesc
				//Set AdmitWardDesc=objVolAdm.VPAdmitWardDesc
				Set AdmitDeptDesc=$p($g(^CTLOC(AdmLoc)),"^",2)
				Set:AdmitDeptDesc["-" AdmitDeptDesc=$p(AdmitDeptDesc,"-",2)
				Set AdmitWardDesc=$p($g(^CTLOC(AdmWard)),"^",2)
				Set:AdmitWardDesc["-" AdmitWardDesc=$p(AdmitWardDesc,"-",2)
				Set DischTime = objVolAdm.VPDischTime
				Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
				Set:DischTime'="" DischTime=$zt(DischTime,2)
				Set BackDate=objVol.SVBackDate
				Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
				Set DoctorID = $p($g(^PAADM(EpisodeID)),"^",9)
				Set docData=$g(^CTPCP(+DoctorID,1))
				Set DoctorName = $p(docData,"^",2)
				Set:DeathDate'="" DeathDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DeathDate)
				
				Set Data=$lb(xVolID,EpisodeID,PatientID,MrNo,PatName,PapmiNo,Sex,Age,IDCode,AdmitDeptDesc,AdmitWardDesc,AdmitDate,AdmitTime,DischDate,DischTime,BackDate,BackDays,DoctorName,DeathDate)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryVolLateStatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolLateStatDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolLateStatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolLateStatDtlExecute ]
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

}
