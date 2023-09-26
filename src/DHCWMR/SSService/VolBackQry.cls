/// 名称: DHCWMR.SSService.VolBackQry
/// 描述: 回收病历查询服务
/// 编写者：zhufei
/// 编写日期: 2015-04-03
Class DHCWMR.SSService.VolBackQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-04-03
/// Description:  回收病历统计
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolBackQry","QryVolBackStat","4","7","2015-03-31","2015-03-31","0","195")
Query QryVolBackStat(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String) As %Query(ROWSPEC = "StatLocID:%String,StatLocDesc:%String,DischCnt:%String,Dis1DBackCnt:%String,Dis2DBackCnt:%String,Dis3DBackCnt:%String,Dis7DBackCnt:%String,Dis1DBackRatio:%String,Dis2DBackRatio:%String,Dis3DBackRatio:%String,Dis7DBackRatio:%String,DeathCnt:%String,Dth6DBackCnt:%String,Dth6DBackRatio:%String")
{
}

ClassMethod QryVolBackStatExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aLocGrpID,aLocID)
	
	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
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
				
				Set StatLocID=AdmLoc
				If DeathDate="" {
					Set num=$i(arrLocStatResult(1,StatLocID,"出院人数"))
					Set num=$i(arrLocStatResult(2,"合计","出院人数"))
				}Else{
					Set num=$i(arrLocStatResult(1,StatLocID,"死亡人数"))
					Set num=$i(arrLocStatResult(2,"合计","死亡人数"))
				}
				Continue:BackDate=""
				
				//算迟归天数
				Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,BackDate)  //假日数
				Set BackDays=BackDate-DischDate-HolidaysConut
				Set:BackDays<0 BackDays=0
				
				If DeathDate="" {
					Set:BackDays<=1 num=$i(arrLocStatResult(1,StatLocID,"1日回收"))
					Set:BackDays<=2 num=$i(arrLocStatResult(1,StatLocID,"2日回收"))
					Set:BackDays<=3 num=$i(arrLocStatResult(1,StatLocID,"3日回收"))
					Set:BackDays<=7 num=$i(arrLocStatResult(1,StatLocID,"7日回收"))  //fix bug 6640
					
					Set:BackDays<=1 num=$i(arrLocStatResult(2,"合计","1日回收"))
					Set:BackDays<=2 num=$i(arrLocStatResult(2,"合计","2日回收"))
					Set:BackDays<=3 num=$i(arrLocStatResult(2,"合计","3日回收"))
					Set:BackDays<=7 num=$i(arrLocStatResult(2,"合计","7日回收"))     //fix bug 6640
				} Else {
					Set:BackDays<=6 num=$i(arrLocStatResult(1,StatLocID,"6日回收"))
					
					Set:BackDays<=6 num=$i(arrLocStatResult(2,"合计","6日回收"))
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
		Set Dis1DBackCnt=+$g(arrLocStatResult(1,xStatLocID,"1日回收"))
		Set Dis2DBackCnt=+$g(arrLocStatResult(1,xStatLocID,"2日回收"))
		Set Dis3DBackCnt=+$g(arrLocStatResult(1,xStatLocID,"3日回收"))
		Set Dis7DBackCnt=+$g(arrLocStatResult(1,xStatLocID,"7日回收"))
		If DischCnt>0 {
			Set Dis1DBackRatio=$fn((Dis1DBackCnt/DischCnt)*100,"",2)_"%"
			Set Dis2DBackRatio=$fn((Dis2DBackCnt/DischCnt)*100,"",2)_"%"
			Set Dis3DBackRatio=$fn((Dis3DBackCnt/DischCnt)*100,"",2)_"%"
			Set Dis7DBackRatio=$fn((Dis7DBackCnt/DischCnt)*100,"",2)_"%"
		} Else {
			Set Dis1DBackRatio="-"
			Set Dis2DBackRatio="-"
			Set Dis3DBackRatio="-"
			Set Dis7DBackRatio="-"
		}
		
		Set DeathCnt=+$g(arrLocStatResult(1,xStatLocID,"死亡人数"))
		Set Dth6DBackCnt=+$g(arrLocStatResult(1,xStatLocID,"6日回收"))
		If DeathCnt>0 {
			Set Dth6DBackRatio=$fn((Dth6DBackCnt/DeathCnt)*100,"",2)_"%"
		} Else {
			Set Dth6DBackRatio="-"
		}
		
		Set Data=$lb(xStatLocID,StatLocDesc,DischCnt,Dis1DBackCnt,Dis2DBackCnt,Dis3DBackCnt,Dis7DBackCnt,Dis1DBackRatio,Dis2DBackRatio,Dis3DBackRatio,Dis7DBackRatio,DeathCnt,Dth6DBackCnt,Dth6DBackRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set DischCnt=+$g(arrLocStatResult(2,"合计","出院人数"))
	Set Dis1DBackCnt=+$g(arrLocStatResult(2,"合计","1日回收"))
	Set Dis2DBackCnt=+$g(arrLocStatResult(2,"合计","2日回收"))
	Set Dis3DBackCnt=+$g(arrLocStatResult(2,"合计","3日回收"))
	Set Dis7DBackCnt=+$g(arrLocStatResult(2,"合计","7日回收"))
	If DischCnt>0 {
		Set Dis1DBackRatio=$fn((Dis1DBackCnt/DischCnt)*100,"",2)_"%"
		Set Dis2DBackRatio=$fn((Dis2DBackCnt/DischCnt)*100,"",2)_"%"
		Set Dis3DBackRatio=$fn((Dis3DBackCnt/DischCnt)*100,"",2)_"%"
		Set Dis7DBackRatio=$fn((Dis7DBackCnt/DischCnt)*100,"",2)_"%"
	} Else {
		Set Dis1DBackRatio="-"
		Set Dis2DBackRatio="-"
		Set Dis3DBackRatio="-"
		Set Dis7DBackRatio="-"
	}
	
	Set DeathCnt=+$g(arrLocStatResult(2,"合计","死亡人数"))
	Set Dth6DBackCnt=+$g(arrLocStatResult(2,"合计","6日回收"))
	If DeathCnt>0 {
		Set Dth6DBackRatio=$fn((Dth6DBackCnt/DeathCnt)*100,"",2)_"%"
	} Else {
		Set Dth6DBackRatio="-"
	}
	
	Set Data=$lb("-","合计",DischCnt,Dis1DBackCnt,Dis2DBackCnt,Dis3DBackCnt,Dis7DBackCnt,Dis1DBackRatio,Dis2DBackRatio,Dis3DBackRatio,Dis7DBackRatio,DeathCnt,Dth6DBackCnt,Dth6DBackRatio)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Kill arrLocStatResult
	
	Quit $$$OK
}

ClassMethod QryVolBackStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolBackStatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolBackStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolBackStatExecute ]
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
