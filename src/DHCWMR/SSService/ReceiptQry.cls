/// 名称: DHCWMR.SSService.ReceiptQry
/// 描述: 接诊日志查询服务
/// 编写者：zhufei
/// 编写日期: 2014-09-20
Class DHCWMR.SSService.ReceiptQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2014-09-01
/// Description:  接诊日志查询
/// Table：       Pa_Adm、DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       HospID ：医院ID
///               AdmType ：就诊类型
///               DateFrom ：开始日期
///               DateTo ：结束日期
///               LocID ：科室ID
/// d ##class(%ResultSet).RunQuery("DHCWMR.SSService.ReceiptQry","QuryReceiptByDate","2","I","2015-03-20","2015-03-31","","27")
Query QuryReceiptByDate(aHospID As %String, aAdmType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aRegNo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatName:%String,PapmiNo:%String,Sex:%String,AdmType:%String,AdmLocID:%String,AdmLoc:%String,AdmWard:%String,AdmDate:%String,AdmTime:%String,VolumeID:%String,MrTypeID:%String,MrNo:%String,MrClass:%String,ReceiptType:%String,MainID:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QuryReceiptByDateExecute(ByRef qHandle As %Binary, aHospID As %String, aAdmType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aRegNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind = 1
	
	//Set ^ZF=$lb(aHospID,aAdmType,aDateFrom,aDateTo,aLocID,aRegNo)
	
	Quit:(aAdmType="") $$$OK
	Set aAdmType="#"_aAdmType_"#"
	Set:aHospID'="" aHospID=","_aHospID_","
	
	If aRegNo'="" {
		Set PatientID=##Class(DHCWMR.SSService.CommonSrv).GetPatientID(aRegNo)
		Quit:PatientID="" $$$OK
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^PAPERdr(PatientID,"ADM",xAdmType))
			Quit:xAdmType=""
			Continue:aAdmType'[("#"_xAdmType_"#")
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAPERdr(PatientID,"ADM",xAdmType,xPaadm))
				Quit:xPaadm=""
				
		    	Set EpisodeID=xPaadm
				Set AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
		    	Set AdmType=$s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="I":"住院",1:"")
		    	Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
		    	Continue:(VisitStatus'="A")&&(VisitStatus'="D")  //update by zf 2015-04-01
		    	Continue:$p($g(^PAADM(+EpisodeID)),"^",75)'=""	//婴儿不建病案
	    		
		    	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    	Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
		    	Set Sex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
		    	Set:Sex'="" Sex=$p($g(^CT("SEX",+Sex)),"^",2)
	    		
	    		Set (EncryptLevel,PatLevel)=""
				Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
				Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
				Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	    		
		    	Set AdmDate=$p($g(^PAADM(+EpisodeID)),"^",6)
		    	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		    	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
		    	Set AdmTime=$p($g(^PAADM(+EpisodeID)),"^",7)
		    	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			    Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
		    	Set AdmLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
		    	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		    	Set AdmWard=$p($g(^PAADM(+EpisodeID)),"^",70)
		    	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
		    	Set AdmWardDesc=$p($g(^CTLOC(+AdmWard)),"^",2)
		    	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
		    	Continue:(aLocID'="")&&((AdmLoc'=aLocID)&&(AdmWard'=aLocID))
		    	Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
		    	Continue:(aHospID'="")&&(aHospID'[(","_AdmHospID_","))
	    		
				Set xVolID="",MrNo="",MrTypeID="",VolumeID=""
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_xPaadm,xVolID))
					Quit:xVolID=""
					Quit:MrNo'=""
					
					Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
					Continue:'$IsObject(objVol)
					Continue:objVol.SVIsActive'=1
					Set objMain=objVol.SVMainDr
					Continue:'$IsObject(objMain)
					Continue:objMain.SMIsActive'=1
					Continue:'$IsObject(objMain.SMMrType)
					Set MrTypeID=objMain.SMMrType.%Id()
					Set MrNo=objMain.SMMrNo
					Set VolumeID=xVolID
				}
				If MrNo="" {
					Set NoTypeID=##class(DHCWMR.SSService.ReceiptSrv).GetNoTypeByAdm(EpisodeID)
					Continue:NoTypeID=""
					Set MrTypeID=$p(NoTypeID,"||",1)
					Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(PatientID,MrTypeID)
				}
				Continue:MrTypeID=""
				
				Set MrClass="",ReceiptType="",MainID=""
				Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
				Continue:'$IsObject(objMrType)
				Set MrClass=objMrType.MTMrClass.MCCode
				Set ReceiptType=objMrType.MTReceiptType.SDCode
				If (MrClass="O")&&(ReceiptType="M") {
					Set objMain=##class(DHCWMR.SS.Main).GetObjByMrNo(MrTypeID,MrNo)
					If $IsObject(objMain) {
						Set MainID=objMain.%Id()
					}
				}
				
	    		Set Data=$lb(EpisodeID,PatientID,PatName,PapmiNo,Sex,AdmType,AdmLoc,AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,VolumeID,MrTypeID,MrNo,MrClass,ReceiptType,MainID,EncryptLevel,PatLevel)
	    		Set ^CacheTemp(repid,ind)=Data
	    		Set ind=ind+1
			}
		}
	} Else {
		;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
		;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
		Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
		Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
		Set:aDateFrom'="" aDateFrom=+aDateFrom
		;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
		;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
		Set:aDateTo'="" aDateTo=+aDateTo
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=""
	    	For {
		    	Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
		    	Quit:xPaadm=""
	    		
		    	Set EpisodeID=xPaadm
				Set AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
		    	Continue:aAdmType'[("#"_AdmType_"#")
		    	Set AdmType=$s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="I":"住院",1:"")
		    	Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
		    	Continue:(VisitStatus'="A")&&(VisitStatus'="D")  //update by zf 2015-04-01
		    	Continue:$p($g(^PAADM(+EpisodeID)),"^",75)'=""	//婴儿不建病案
	    		
		    	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
		    	Continue:PatientID=""
		    	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    	Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
		    	Set Sex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
		    	Set:Sex'="" Sex=$p($g(^CT("SEX",+Sex)),"^",2)
	    		
	    		Set (EncryptLevel,PatLevel)=""
				Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
				Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
				Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	    		
		    	Set AdmDate=$p($g(^PAADM(+EpisodeID)),"^",6)
		    	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		    	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
		    	Set AdmTime=$p($g(^PAADM(+EpisodeID)),"^",7)
		    	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			    Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
			    Set AdmLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
		    	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		    	Set AdmWard=$p($g(^PAADM(+EpisodeID)),"^",70)
		    	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
		    	Set AdmWardDesc=$p($g(^CTLOC(+AdmWard)),"^",2)
		    	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
		    	Continue:(aLocID'="")&&((AdmLoc'=aLocID)&&(AdmWard'=aLocID))
		    	Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
		    	Continue:(aHospID'="")&&(aHospID'[(","_AdmHospID_","))
	    		
				Set xVolID="",MrNo="",MrTypeID="",MainID="",VolumeID=""
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_xPaadm,xVolID))
					Quit:xVolID=""
					Quit:MrNo'=""
					
					Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
					Continue:'$IsObject(objVol)
					Continue:objVol.SVIsActive'=1
					Set objMain=objVol.SVMainDr
					Continue:'$IsObject(objMain)
					Continue:objMain.SMIsActive'=1
					Continue:'$IsObject(objMain.SMMrType)
					Set MrTypeID=objMain.SMMrType.%Id()
					Set MrNo=objMain.SMMrNo
					Set VolumeID=xVolID
				}
				If MrNo="" {
					Set NoTypeID=##class(DHCWMR.SSService.ReceiptSrv).GetNoTypeByAdm(EpisodeID)
					Continue:NoTypeID=""
					Set MrTypeID=$p(NoTypeID,"||",1)
					Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(EpisodeID,MrTypeID)
				}
				Continue:MrTypeID=""
				
				Set MrClass="",ReceiptType="",MainID=""
				Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
				Continue:'$IsObject(objMrType)
				Set MrClass=objMrType.MTMrClass.MCCode
				Set ReceiptType=objMrType.MTReceiptType.SDCode
				If (MrClass="O")&&(ReceiptType="M") {
					Set objMain=##class(DHCWMR.SS.Main).GetObjByMrNo(MrTypeID,MrNo)
					If $IsObject(objMain) {
						Set MainID=objMain.%Id()
					}
				}
				
	    		Set Data=$lb(EpisodeID,PatientID,PatName,PapmiNo,Sex,AdmType,AdmLoc,AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,VolumeID,MrTypeID,MrNo,MrClass,ReceiptType,MainID,EncryptLevel,PatLevel)
	    		Set ^CacheTemp(repid,ind)=Data
	    		Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QuryReceiptByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuryReceiptByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuryReceiptByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuryReceiptByDateExecute ]
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
