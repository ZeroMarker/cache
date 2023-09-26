/// ClassName:    DtPortal.MD.MD39LayedMedical
/// Description:  病历迟归
/// Creator：     maxiangping
/// CreatDate:    2018-1-2
Class DtPortal.MD.MD39LayedMedical Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description	:	MD39.01.01 查询一段时间内的某一个类型的病历迟归科室分布
/// Input		:	院区id	
/// 				类型	T：三日  S：七日
/// 				开始时间	YYYY-MM-dd
/// 				结束时间	YYYY-MM-dd
/// Return		:	科室描述:科室id:病历数
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD39LayedMedical","MD390101","2","T","2019-01-01","2019-01-31")
Query MD390101(HospID As %String, LayType As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "locDesc:%String,locId:%String,num:%String,LayType:%String")
{
}

ClassMethod MD390101Execute(ByRef qHandle As %Binary, HospID As %String, LayType As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill ^CacheTemp($zn,$j,"MD390101")
	
	Quit:(StartDate="")||(EndDate="") $$$OK
	
	Set:HospID'="" HospID=","_HospID_","

	Set:StartDate["-" StartDate=$zdh(StartDate, 3)
	Set:StartDate["/" StartDate=$zdh(StartDate, 4)
	Set:EndDate["-" EndDate=$zdh(EndDate, 3)
	Set:EndDate["/" EndDate=$zdh(EndDate, 4)	
	
	Set MyTypeID = 7
	Set LayDays=$s(LayType="T":3,LayType="S":7,1:3)
	
	Set xStepCode=""
	For {
		Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
		Quit:xStepCode=""
		Continue:(xStepCode["C")  //临时病历过滤掉
		
		Set xDate=StartDate-1
		For {
			Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate))
			Quit:xDate=""
			Quit:xDate>EndDate
			
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
				Continue:objVol.SVMainDr.SMMrType.%Id()'=MyTypeID
				
				Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
				Continue:VolAdmStr=""
				Set VolAdmID=$p(VolAdmStr,",",1)
				Set EpisodeID=$p(VolAdmStr,",",2)
				Set AdmLoc=$p(VolAdmStr,",",3)
				Set AdmWard=$p(VolAdmStr,",",4)
				//Set AdmHosp=$p(VolAdmStr,",",5)   
				Set AdmHosp=$p($g(^CTLOC(AdmLoc)),"^",22)   //通过科室取院区
				If (AdmHosp'="")&&(HospID'="") {
					Continue:(HospID'[(","_AdmHosp_","))  //检查院区是否符合	
				}
				
				Set DischDate=objVol.SVDischDate
				Set BackDate=objVol.SVBackDate
				Set:BackDate="" BackDate=+$h
				if (BackDate<(DischDate+30)){ //小于30天获取节假日判断，否则已经超过7天归档了--由于获取假日数服务可能慢，所以此处优化---bmz20190923
					Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,BackDate)  //假日数  //modify by pylian
					Set BackDays=BackDate-DischDate-HolidaysConut
					Set:BackDays<0 BackDays=0
					Continue:BackDays<=LayDays
				}
				
				
				Set Num=$i(^CacheTemp($zn,$j,"MD390101",AdmLoc))
			}
		}
	}
	
	Set LocID=""
	For {
		Set LocID=$o(^CacheTemp($zn,$j,"MD390101",LocID))
		Quit:(LocID="")
		
		Set LocDesc = $p($g(^CTLOC(+LocID)),"^",2)
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set LayCount=$g(^CacheTemp($zn,$j,"MD390101",LocID))
		
		Set ^||CacheTemp(repid,ind)=$lb(LocDesc,LocID,LayCount,LayType)
		Set ind=ind+1
	}
	
	Kill ^CacheTemp($zn,$j,"MD390101")
	
	Quit $$$OK
}

/// Description	:	MD39.01.02 查询某一段时间内的某一类型的某一科室病例迟归的患者明细分布		
/// Input		:	类型	T：三日  S：七日
/// 				开始时间	YYYY-MM-dd
/// 				结束时间	YYYY-MM-dd
/// 				科室ID
/// Return		:	床号:姓名:性别:病案号:生命体征:出院诊断
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD39LayedMedical","MD390102","T","2019-01-01","2019-01-11",156)
Query MD390102(LayType As %String, StartDate As %String, EndDate As %String, LocID As %String) As DtPortal.Query(ROWSPEC = "+EpisodeID,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,wardDesc,Diagnosis,DischDate,BackDate")
{
}

ClassMethod MD390102Execute(ByRef qHandle As %Binary, LayType As %String, StartDate As %String, EndDate As %String, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Quit:(LocID="")||(StartDate="")||(EndDate="") $$$OK
	
	Set:StartDate["-" StartDate=$zdh(StartDate, 3)
	Set:StartDate["/" StartDate=$zdh(StartDate, 4)
	Set:EndDate["-" EndDate=$zdh(EndDate, 3)
	Set:EndDate["/" EndDate=$zdh(EndDate, 4)	
	
	Set MyTypeID = 7
	Set LayDays=$s(LayType="T":3,LayType="S":7,1:3)
	
	Set xStepCode=""
	For {
		Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
		Quit:xStepCode=""
		Continue:(xStepCode["C")  //临时病历过滤掉
		
		Set xDate=StartDate-1
		For {
			Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate))
			Quit:xDate=""
			Quit:xDate>EndDate
			
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
				Continue:objVol.SVMainDr.SMMrType.%Id()'=MyTypeID
				
				Set MrNo=objVol.SVMainDr.SMMrNo
				
				Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
				Continue:VolAdmStr=""
				Set VolAdmID=$p(VolAdmStr,",",1)
				Set EpisodeID=$p(VolAdmStr,",",2)
				Set AdmLoc=$p(VolAdmStr,",",3)
				Continue:AdmLoc'=LocID
				
				Set DischDate=objVol.SVDischDate
				Set BackDate=objVol.SVBackDate
				set BackDateN=BackDate
				Set:BackDate="" BackDate=+$h
				Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,BackDate)  //假日数
				Set BackDays=BackDate-DischDate-HolidaysConut
				Set:BackDays<0 BackDays=0
				Continue:BackDays<=LayDays
				
				Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
				Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
				Set SexID=$p($g(^PAPER(PatientID,"ALL")),"^",7)
				Set Sex=""
				Set:SexID'="" Sex=$p($g(^CT("SEX",SexID)),"^",2)
				
				set childsub=""
				for{
					set childsub=$o(^PAADM(+EpisodeID,"TRANS",childsub),-1)
					set bedDr=$p(^PAADM(+EpisodeID,"TRANS",childsub),"^",8)
					if bedDr'="" {
						set BedID=bedDr
						q
						}
					} 
				
    			
    			Set:BedID'="" Bed=$p($g(^PAWARD(+BedID,"BED",$p(BedID,"||",2))),"^",1)
    			
    			//生命体征，出院诊断
  
    			set DischDate=$zd(DischDate,3)
    			set BackDate=""
    			set:+BackDateN'=0 BackDate=$zd(BackDateN,3)
    			set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
			 	set bedCode=$p(patInfoStr,"^",1)
			 	set name=$p(patInfoStr,"^",2)
			 	set sex=$p(patInfoStr,"^",3)
			 	set age=$p(patInfoStr,"^",4)
			 	set medicareNo=$p(patInfoStr,"^",5)   															//病案号
			 	set admReason=$p(patInfoStr,"^",6)    															//费用类型
			 	set regNo=$p(patInfoStr,"^",7)   																//登记号
			 	set nurseDesc=$p(patInfoStr,"^",12)																//主管护士
			 	set docDesc=$p(patInfoStr,"^",11)																//主管医生
				set locDesc=$p(patInfoStr,"^",9)																//科室描述
				set wardDesc=$p(patInfoStr,"^",10)		
    			Set Diagnosis=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(EpisodeID)
				
				Set ^||CacheTemp(repid,ind)=$lb(+EpisodeID,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,wardDesc,Diagnosis,DischDate,BackDate)
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

}
