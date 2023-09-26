/// 名称: DHCWMR.SSService.ReviewQry
/// 描述: 病历复核查询服务
/// 编写者：zhufei
/// 编写日期: 2015-01-28
Class DHCWMR.SSService.ReviewQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  病历复核查询
/// Table：       Pa_Adm、DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
///               LocGrpID ：科室组ID
///               LocID ：科室ID
///               QryFlag ：查询标记
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.ReviewQry","QryVolumeList","4","7","","","","0")
Query QryVolumeList(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aQryFlag As %String) As %Query(ROWSPEC = "VolID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,ChiefProfessor:%String,Professor:%String,VistingDoctor:%String,ResidentDoctor:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String,EncryptLevel:%String,PatLevel:%String,FinishFlag:%String")
{
}

ClassMethod QryVolumeListExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aQryFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo,aLocGrpID,aLocID,aQryFlag)
	
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
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"RV")  //病历复核
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set WorkItemID=objWFItem.WFIItem.%Id()
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	If aQryFlag<1 {  //复核未通过病历查询
		Set xDate=0
		For {
			Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate"," D",xDate))
			Quit:xDate=""
			
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate"," D",xDate,xVolID))
				Quit:xVolID=""
				
				Set Data=..BuildVolume(xVolID)
				Continue:Data=""
				
				Set flg=##class(DHCWMR.SSService.VolumeSrv).CheckStatus(xVolID,WorkItemID)
				Continue:flg>1	//检查是否复核通过
				
				Set FinishFlag=0
				Set Data=Data_$lb(FinishFlag)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} Else {  //复核通过病历查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
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
					
					Set flg=##class(DHCWMR.SSService.VolumeSrv).CheckStatus(xVolID,WorkItemID)
					Continue:flg<2	//检查是否复核通过
					
					Set FinishFlag=1
					Set Data=Data_$lb(FinishFlag)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
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

/// Creator：     zhouruimeng
/// CreatDate：   2015-03-08
/// Description:  病历复核不通过查询
/// Table：       Pa_Adm、DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.ReviewQry","QueryReViewStat","2","7","2016-05-30","2016-05-31")
Query QueryReViewStat(aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "StatLocID:%String,StatLocDesc:%String,DischCnt:%String,BackCnt:%String,UnReViewCnt:%String,BackRatio:%String,UnReViewRatio:%String")
{
}

ClassMethod QueryReViewStatExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aDateFrom,aDateTo)
	
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
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"RC")  //病案回收
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set RCWorkItemID=objWFItem.WFIItem.%Id()
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"UR")  //复核不通过
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set URWorkItemID=objWFItem.WFIItem.%Id()
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"RV")  //病历复核
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set RVWorkItemID=objWFItem.WFIItem.%Id()
	
	Kill arrLocStatResult
	
	Set xDate=0
	For {
		Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate"," D",xDate))
		Quit:xDate=""
			
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate"," D",xDate,xVolID))
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
			
			Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
			Continue:VolAdmStr=""
			Set VolAdmID=$p(VolAdmStr,",",1)
			Set EpisodeID=$p(VolAdmStr,",",2)
			Set AdmLoc=$p(VolAdmStr,",",3)
			Set AdmWard=$p(VolAdmStr,",",4)
			Set AdmHosp=$p(VolAdmStr,",",5)
		    If (AdmHosp'="")&&(aHospID'="") {
				Continue:(aHospID'[(","_AdmHosp_",")) //检查院区是否符合
		    }
		    
			Set StatLocID=AdmWard
			Set num=$i(arrLocStatResult(1,StatLocID,"出院人数"))
			Set num=$i(arrLocStatResult(2,"合计","出院人数"))
			
			//病案回收
			Set RCStatus=##class(DHCWMR.SSService.VolumeSrv).CheckStatus(xVolID,RCWorkItemID)
			If RCStatus>0 {
				Set num=$i(arrLocStatResult(1,StatLocID,"回收人数"))
				Set num=$i(arrLocStatResult(2,"合计","回收人数"))
			}
			
			//复核通过
			Set RVStatus=##class(DHCWMR.SSService.VolumeSrv).CheckStatus(xVolID,RVWorkItemID)
			If RVStatus<1 {
				//复核不通过
				Set URStatus=##class(DHCWMR.SSService.VolumeSrv).CheckStatus(xVolID,URWorkItemID)
				If URStatus>0 {
					Set num=$i(arrLocStatResult(1,StatLocID,"复核不通过"))
					Set num=$i(arrLocStatResult(2,"合计","复核不通过"))
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
		Set BackCnt=+$g(arrLocStatResult(1,xStatLocID,"回收人数"))
		Set UnReViewCnt=+$g(arrLocStatResult(1,xStatLocID,"复核不通过"))
		
		If BackCnt>0 {
			Set UnReViewRatio=$fn((UnReViewCnt/BackCnt)*100,"",2)_"%"
		} Else {
			Set UnReViewRatio="0.00%"
		}
		If DischCnt>0{
			Set BackRatio=$fn((BackCnt/DischCnt)*100,"",2)_"%"
		} Else {
			Set BackRatio="0.00%"
		}
		
		Set Data=$lb(xStatLocID,StatLocDesc,DischCnt,BackCnt,UnReViewCnt,BackRatio,UnReViewRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
		
	Set DischCnt=+$g(arrLocStatResult(2,"合计","出院人数"))
	Set BackCnt=+$g(arrLocStatResult(2,"合计","回收人数"))
	Set UnReViewCnt=+$g(arrLocStatResult(2,"合计","复核不通过"))
		
	If BackCnt>0 {
		Set UnReViewRatio=$fn((UnReViewCnt/BackCnt)*100,"",2)_"%"
	} Else {
		Set UnReViewRatio="0.00%"
	}
		
	If DischCnt>0{
		Set BackRatio=$fn((BackCnt/DischCnt)*100,"",2)_"%"
	} Else {
		Set BackRatio="0.00%"
	}
		
	Set Data=$lb("-","合计",DischCnt,BackCnt,UnReViewCnt,BackRatio,UnReViewRatio)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Kill arrLocStatResult
		
	Quit $$$OK
}

ClassMethod QueryReViewStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReViewStatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReViewStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReViewStatExecute ]
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
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	Quit:(aDateFrom'="")&&(aDateFrom>DischDate) return
	Quit:(aDateTo'="")&&(aDateTo<DischDate) return
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
	If aLocID'="" {
    	Quit:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|")) return
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
	Set PapmiNo=""
	Set:PatientID'="" PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	Set Age=objVolAdm.VPAge
	
    Set AdmLoc=objVolAdm.VPAdmitDept
	Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
    Set AdmWard=objVolAdm.VPAdmitWard
	Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
    Set DischDept=objVolAdm.VPDischDept
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
    Set DischWard=objVolAdm.VPDischWard
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDept'="" AdmLoc=DischDept
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWard'="" AdmWard=DischWard
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
	
		
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set ChiefProfessor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.056",.ArrGlossary)	//科主任签名
	Set Professor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.137",.ArrGlossary)	//主任（副主任）医师签名
	Set VistingDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.138",.ArrGlossary)	//主治医师签名
	Set ResidentDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.141",.ArrGlossary)	//住院医师签名

	Set EprStatus=##class(DHCWMR.IO.FromEprSrv).GetMedRecordStatus(EpisodeID)
	Set EprDocStatus=+$p(EprStatus,"^",2)
	Set EprDocStatusDesc=$s(EprDocStatus=1:"是",1:"否")
	Set EprNurStatus=+$p(EprStatus,"^",1)
	Set EprNurStatusDesc=$s(EprNurStatus=1:"是",1:"否")
	Set EprPdfStatus=+$p(EprStatus,"^",3)
	Set EprPdfStatusDesc=$s(EprPdfStatus=1:"是",1:"否")
	
	Set return=$lb(aVolID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(ChiefProfessor,Professor,VistingDoctor,ResidentDoctor)
	Set return=return_$lb(EprDocStatus,EprDocStatusDesc,EprNurStatus,EprNurStatusDesc,EprPdfStatus,EprPdfStatusDesc)
	Set return=return_$lb(EncryptLevel,PatLevel)
	Quit return
}

}
