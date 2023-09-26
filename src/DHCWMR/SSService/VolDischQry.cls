/// 名称: DHCWMR.SSService.VolDischQry
/// 描述: 出院病历查询服务
/// 编写者：李阳
/// 编写日期: 2014-09-03
Class DHCWMR.SSService.VolDischQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     李阳
/// CreatDate：   2014-09-03
/// Description:  出院病历查询
/// Table：       Pa_Adm、DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
///               LocID ：科室ID
///               BackDays ：回收天数
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolDischQry","QryVolumeList","2","7","","","0","","0")
Query QryVolumeList(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aBackDays As %String) As %Query(ROWSPEC = "VolID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,ChiefProfessor:%String,Professor:%String,VistingDoctor:%String,ResidentDoctor:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,BackDays:%String,EncryptLevel:%String,PatLevel:%String,IsDeathPat:%String,DeathDate:%String")
{
}

ClassMethod QryVolumeListExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aBackDays As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aLocGrpID,aLocID,aBackDays)
	
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
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	Kill ^TMP($zn,$j,"QryVolumeList")
	
	If aBackDays=0 {  //未回收病历查询
		//add by zf 20150327 自动生成出院待回收病历
		Set flg=##class(DHCWMR.SSService.VolDischSrv).ProcDischVolume(aMrTypeID)
		
		Set xDate=0
		For {
			Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate"," A",xDate))
			Quit:xDate=""
			
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate"," A",xDate,xVolID))
				Quit:xVolID=""
				
				Set Data=..BuildVolume(xVolID)
				Continue:Data=""
				
				Set cLocDesc=$list(Data,10)
				Set cDischDate=$list(Data,14)
				Set cIndex=$i(^TMP($zn,$j,"QryVolumeList"))
				Set ^TMP($zn,$j,"QryVolumeList"," "_cLocDesc," "_cDischDate,cIndex)=Data
			}
		}
	} ElseIf aBackDays<0 {  //出院病历查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		//Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(aDateFrom,aDateTo)  //假日数
		Set xStepCode=""
		For {
			Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
			Quit:xStepCode=""
			Continue:xStepCode["C"  //临时与在院病历都过滤掉
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID)
					Continue:Data=""
					
					Set cLocDesc=$list(Data,10)   //修改取值错误
					Set cDischDate=$list(Data,14)
					Set cIndex=$i(^TMP($zn,$j,"QryVolumeList"))
					Set ^TMP($zn,$j,"QryVolumeList"," "_cLocDesc," "_cDischDate,cIndex)=Data
				}
			}
		}
	} ElseIf aBackDays=1 {  //已回收病历查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		//Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(aDateFrom,aDateTo)  //假日数
		Set xStepCode=""
		For {
			Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
			Quit:xStepCode=""
			Continue:(xStepCode["C")||(xStepCode["A")  //临时与在院病历都过滤掉
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode,xDate,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID)
					Continue:Data=""
					
					Set cLocDesc=$list(Data,10)
					Set cDischDate=$list(Data,14)
					Set cIndex=$i(^TMP($zn,$j,"QryVolumeList"))
					Set ^TMP($zn,$j,"QryVolumeList"," "_cLocDesc," "_cDischDate,cIndex)=Data
				}
			}
		}
	} ElseIf aBackDays>1 {  //迟归病历查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
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
					
					Set Data=..BuildVolume(xVolID)
					Continue:Data=""
					
					Set cLocDesc=$list(Data,10)
					Set cDischDate=$list(Data,14)
					Set cIndex=$i(^TMP($zn,$j,"QryVolumeList"))
					Set ^TMP($zn,$j,"QryVolumeList"," "_cLocDesc," "_cDischDate,cIndex)=Data
				}
			}
		}
	}
	
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,"QryVolumeList",xLocDesc))
		Quit:xLocDesc=""
		Set xDischDate=""
		For {
			Set xDischDate=$o(^TMP($zn,$j,"QryVolumeList",xLocDesc,xDischDate))
			Quit:xDischDate=""
			
			Set xIndex=0
			For {
				Set xIndex=$o(^TMP($zn,$j,"QryVolumeList",xLocDesc,xDischDate,xIndex))
				Quit:xIndex=""
				
				Set Data=$g(^TMP($zn,$j,"QryVolumeList",xLocDesc,xDischDate,xIndex))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP($zn,$j,"QryVolumeList")
	
	Quit $$$OK
}

ClassMethod QryVolumeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolumeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeListExecute ]
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

ClassMethod BuildVolume(aVolID As %String) As %List
{
	Set return=""
	Quit:aVolID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Quit:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID return
	
	Set DischDate=objVol.SVDischDate
	Quit:(aDateFrom'="")&&(aDateFrom>DischDate) return
	Quit:(aDateTo'="")&&(aDateTo<DischDate) return
	
	Set BackDate=objVol.SVBackDate
	Set:BackDate="" BackDate=+$h
	//Set BackDays=BackDate-DischDate
	Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,BackDate)  //假日数  //modify by pylian
	Set BackDays=BackDate-DischDate-HolidaysConut
	Set:BackDays<0 BackDays=0
	Quit:(aBackDays>1)&(BackDays<=aBackDays) return  //update by zf 20151202 只有aBackDays>1,才检查迟归天数
	Set BackDays=BackDays_"天"
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	;Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
	;Set:BackDate'="" BackDate=$zd(BackDate,3)
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时")
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Set AdmLoc=$p(VolAdmStr,",",3)
	Set AdmWard=$p(VolAdmStr,",",4)
	Set AdmHosp=$p(VolAdmStr,",",5)
    If (AdmHosp'="")&&(aHospID'="") {
		Quit:(aHospID'[(","_AdmHosp_",")) return  //检查院区是否符合
    }
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	If EpisodeID'="" {
		Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
		Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
		Quit:VisitStatus="C" return
	}
	Set DischDept=objVolAdm.VPDischDept
	Set:DischDept'="" AdmLoc=DischDept
    Set DischWard=objVolAdm.VPDischWard
	Set:DischWard'="" AdmWard=DischWard
	If aLocID'="" {
    	Quit:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|")) return
    }
	
	Set PapmiNo=""
	Set:PatientID'="" PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	//Set Age=objVolAdm.VPAge
	//统一调用年龄计算方法
	Set tmpDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	Set tmpTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,tmpDate,tmpTime)	//返回“*岁*月*天”
	
	//Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(EpisodeID) //入院科室病区
    //Set AdmLoc=$p(tmpDeptWard,",",1)
	Set AdmLocDesc=""
	Set:AdmLoc'="" AdmLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	//Set AdmWard=$p(tmpDeptWard,",",2)
	Set AdmWardDesc=""
	Set:AdmWard'="" AdmWardDesc=$p($g(^CTLOC(+AdmWard)),"^",2)
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	Set AdmDate=objVolAdm.VPAdmitDate
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set (ChiefProfessor,Professor,VistingDoctor,ResidentDoctor)=""
	/* 标准版中不取值 项目上根据需要和实际情况取值	
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set ChiefProfessor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.056",.ArrGlossary)	//科主任签名
	Set Professor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.137",.ArrGlossary)	//主任（副主任）医师签名
	Set VistingDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.138",.ArrGlossary)	//主治医师签名
	Set ResidentDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.141",.ArrGlossary)	//住院医师签名
	*/
	
	Set EprStatus=##class(DHCWMR.IO.FromEprSrv).GetMedRecordStatus(EpisodeID)				//医生护士提交
	Set EprDocStatus=+$p(EprStatus,"^",2)
	Set EprDocStatusDesc=$s(EprDocStatus=1:"是",1:"否")
	Set EprNurStatus=+$p(EprStatus,"^",1)
	Set EprNurStatusDesc=$s(EprNurStatus=1:"是",1:"否")
	//是否死亡患者
	Set DeathDate=##class(DHCWMR.IO.FromMedSrv).GetDeathDateTime(EpisodeID)
	Set IsDeathPat=$s(DeathDate'="":"是",1:"否")
	Set:DeathDate'="" DeathDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DeathDate)

	Set return=$lb(aVolID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,IdentityCode)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(ChiefProfessor,Professor,VistingDoctor,ResidentDoctor)
	Set return=return_$lb(EprDocStatus,EprDocStatusDesc,EprNurStatus,EprNurStatusDesc,BackDays)
	Set return=return_$lb(EncryptLevel,PatLevel,IsDeathPat,DeathDate)
	Quit return
}

/// Creator：     刘宇辉
/// CreatDate：   2015-09-17
/// Description:  科室出院病历回收查询
/// Table：       Pa_Adm、DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolDischQry","QryLocDischData","2","7","2010-1-1","2015-10-10")
Query QryLocDischData(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aLocNotBackFlag As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,DisNum:%String,NotBackNum:%String,BackNum:%String,VolID:%String,PatName:%String,PapmiNo:%String,MrNo:%String,Sex:%String,Age:%String,AdmDate:%String,DischDate:%String,BackDate:%String")
{
}

ClassMethod QryLocDischDataExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aLocNotBackFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
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
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryLocDischData")
	
	Set xStepCode=""
	For {
		Set xStepCode=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xStepCode))
		Quit:xStepCode=""
		Continue:xStepCode["C"  //临时过滤掉
		
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
				Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
				Continue:EpisodeID=""
				Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
			    Set AdmWard=$p($g(^PAADM(+EpisodeID)),"^",70)
			    Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
			   
			    Continue:(aLocNotBackFlag'="")&&(xStepCode'["A")
				Continue:(aLocID'=AdmLoc)&&(aLocID'="")&&(aLocID'="合计")
				
			    Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
			    Continue:(aHospID'="")&&(aHospID'[(","_AdmHospID_","))
		    		
				Set DischDate=objVol.SVDischDate
				Continue:(aDateFrom'="")&&(aDateFrom>DischDate)
				Continue:(aDateTo'="")&&(aDateTo<DischDate)
				
				Set:aLocID'="" ^TMP(ZIndex,JIndex,"QryLocDischData",aLocID,"LocDisch",xVolID)=EpisodeID	//科室出院患者信息
				Set:aLocID'="" ^TMP(ZIndex,JIndex,"QryLocDischData","合计","LocDisch",xVolID)=EpisodeID	//合计科室出院患者信息
				 
				Set num=$i(^TMP(ZIndex,JIndex,"QryLocDischData",AdmLoc,"LocDischNum"))	//科室出院人数
				Set num=$i(^TMP(ZIndex,JIndex,"QryLocDischData","合计","LocDischNum"))	//合计出院人数
				If (xStepCode["A") {
					Set num=$i(^TMP(ZIndex,JIndex,"QryLocDischData",AdmLoc,"LocNotBackNum"))	//未回收人数
					Set num=$i(^TMP(ZIndex,JIndex,"QryLocDischData","合计","LocNotBackNum"))	//合计未回收人数
				}else{
					Set num=$i(^TMP(ZIndex,JIndex,"QryLocDischData",AdmLoc,"LocBackNum"))	//回收人数
					Set num=$i(^TMP(ZIndex,JIndex,"QryLocDischData","合计","LocBackNum"))	//合计回收人数
				}
			}
		}
	}
	
	If (aLocID="")
	{
		Set LocID=0
		For {
			Set LocID=$o(^TMP(ZIndex,JIndex,"QryLocDischData",LocID))
			Quit:LocID=""
			If (LocID)="合计" {
				Set LocDesc="合计"
			}Else {
				Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
				Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			}
			Set DisNum=+$g(^TMP(ZIndex,JIndex,"QryLocDischData",LocID,"LocDischNum"))
			Set NotBackNum=+$g(^TMP(ZIndex,JIndex,"QryLocDischData",LocID,"LocNotBackNum"))
			Set BackNum=+$g(^TMP(ZIndex,JIndex,"QryLocDischData",LocID,"LocBackNum"))
		
			Set Data=$lb(LocID,LocDesc,DisNum,NotBackNum,BackNum)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	} else {
		Set VolID=""
		For {
			Set VolID=$o(^TMP(ZIndex,JIndex,"QryLocDischData",aLocID,"LocDisch",VolID))
			Quit:VolID=""
			
			Set EpisodeID=+$g(^TMP(ZIndex,JIndex,"QryLocDischData",aLocID,"LocDisch",VolID))
			
			Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
			Continue:VisitStatus="C" 
			
			Set LocDesc=$p($g(^CTLOC(aLocID)),"^",2)
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			
			Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
			Continue:PatientID="" 
			Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
			Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
			Set Sex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
			Set:Sex'="" Sex=$p($g(^CT("SEX",+Sex)),"^",2)
			Set Birthday=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	
			//update by zf 20150228 统一调用年龄计算方法
			//Set tmpDate=$p($g(^PAADM(+EpisodeID)),"^",6)
			//Set tmpTime=$p($g(^PAADM(+EpisodeID)),"^",7)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
   			Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	        Set tmpDate=$p(AdmDateTime,"^",1)
	        Set tmpTime=$p(AdmDateTime,"^",2)
			Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,tmpDate,tmpTime)	//返回“*岁*月*天”
			
			//Set AdmDate=$p($g(^PAADM(+EpisodeID)),"^",6)
			Set AdmDate=tmpDate
			;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
			
			Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolID)
			Continue:'$IsObject(objVol) 
			Continue:objVol.SVIsActive'=1 
			Continue:'$IsObject(objVol.SVMainDr) 
			Continue:objVol.SVMainDr.SMIsActive'=1 
			Continue:'$IsObject(objVol.SVMainDr.SMMrType) 
			Set OrdStep=objVol.SVOrdStep
			Set MrNo=objVol.SVMainDr.SMMrNo
			Set DischDate=objVol.SVDischDate
			;Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
			Set BackDate=objVol.SVBackDate
			;Set:BackDate'="" BackDate=$zd(BackDate,3)
			Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
			
			Set Data=$lb(aLocID,LocDesc,"","","",VolID,PatName,PapmiNo,MrNo,Sex,Age,AdmDate,DischDate,BackDate)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1	
		}
	}
	Quit $$$OK
}

ClassMethod QryLocDischDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocDischDataExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocDischDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocDischDataExecute ]
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
