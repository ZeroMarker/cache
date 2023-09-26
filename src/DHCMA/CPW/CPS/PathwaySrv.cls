/// 名称: DHCMA.CPW.CPS.PathwaySrv
/// 描述: 出入径综合服务类
/// 编写者：jiangpengpeng
/// 编写日期: 2018-11-27
Class DHCMA.CPW.CPS.PathwaySrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  按日期查询出入径信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
///               
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwaySrv","QryCPWByDate","3","2021-01-01","2021-09-13","","","","2!!1")
Query QryCPWByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String, aRegNo As %String, aMrNo As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,ExecReasonList:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate,InHospDate:%String,PatCost:%String") [ SqlProc ]
{
}

ClassMethod QryCPWByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String, aRegNo As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!"_SYSDr
 	Set:(aWardID'="")&&(aWardID'["!!") aWardID=aWardID_"!!"_SYSDr
 	Set:(aHospID'="")&&(aHospID'["!!") aHospID=aHospID_"!!"_SYSDr
	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set IndexName=$Case(aDateType,"1":"IdxofInLocDate","2":"IdxofOutLocDate","3":"IdxOfDischDate")
 	Set:((aWardID'="")&&(aLocID="")) IndexName=$Case(aDateType,"1":"IdxofInWardDate","2":"IdxofOutWardDate","3":"IdxOfDischDate")
 	If (aDateType=1)||(aDateType=2){
	 	Set xLocID=""
	 	For {
		 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID))
		 	Quit:xLocID=""
		 	//科室过滤
		 	if (aLocID'=""){
			 	Continue:(aLocID'="")&&(aLocID'=xLocID)
			 	Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
			 	Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=xHospID)
		 	}
 			//病区过滤
	 		if (aWardID'=""){
		 		Continue:(aWardID'="")&&(aWardID'=xLocID)
		 		Set LocID=+$p($g(^PAWARD(($p(aWardID,"!!",1)))),"^",5)
			 	Set xHospID=+$p($g(^CTLOC(($p(LocID,"!!",1)))),"^",22)
			 	Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=xHospID)
		 	}
		 	Set xDate=aDateFrom-1
		 	For {
			 	Set xDate=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate))
			 	Quit:xDate=""
			 	Quit:xDate>aDateTo
			 	
			 	Set xCPWID=""
			 	For {
			 		Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID,xDate,xCPWID))
			 		Quit:xCPWID=""
			 		
			 		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
			 		Continue:'$IsObject(objPathway)
				 	
			 		Set Status=objPathway.CPStatus
			 		Continue:(Status'="I")&&(Status'="C")&&(Status'="O")		// 非入径/完成/出径不显示
			 		Continue:(aStatus'="")&&(aStatus'[Status)
			 		
			 		Set CPWData=..GetCPWData(objPathway)
			 		Set EpisodeID=objPathway.CPEpisodeID
			 		Set PatData=..GetPatData(EpisodeID)
			 		Continue:(aRegNo'="")&&(aRegNo'=$lg(PatData,3))		// 登记号过滤
			 		Continue:(aMrNo'="")&&(aMrNo'=$lg(PatData,4))		// 病案号过滤
			 		
			 		//过滤门诊
			 		Set PAAdmType=$lg(PatData,12)
			 		Continue:PAAdmType="O"
			 		
					Set Data=$lb(ind)_CPWData_PatData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 	}
		 	}
	 	}
	}ElseIf (aDateType=3){
    	Set xDate=aDateFrom-1
    	For {
    		Set xDate=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate))
    		Quit:xDate=""
    		Quit:xDate>aDateTo
    	
    		Set xEpisodeID=""
    		For {
    			Set xEpisodeID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate,xEpisodeID))
    			Quit:xEpisodeID=""
    			
    			Set AdmInfo=$g(^DHCMA.Util.EPx.EpisodeD(xEpisodeID))
    			Continue:AdmInfo=""
    			Set Status=$Lg(AdmInfo,5)
    			Continue:Status'="D"
    			Set AdmLocID=$Lg(AdmInfo,25)
    			//Continue:(aLocID'="")&&(aLocID'=AdmLocID)
    			//病区过滤
    			Set WardID=$Lg(AdmInfo,26)
    			//Continue:(aWardID'="")&&(aWardID'=WardID)
		 		Set AdmHospID=+$p($g(^CTLOC(($p(AdmLocID,"!!",1)))),"^",22)
		 		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=AdmHospID)
    			
    			Set EpisodeID=$Lg(AdmInfo,2)
    			Set xPathwayID=""
	    		For {
	    			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,xPathwayID))
	    			Quit:xPathwayID=""
	    			
	    			Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
	    			Continue:'$IsObject(objPathway)
	    			Set Status=objPathway.CPStatus
	    			Continue:(Status'="I")&&(Status'="C")&&(Status'="O")		// 非入径/完成/出径不显示
			 		Continue:(aStatus'="")&&(aStatus'[Status)
			 		Continue:(aLocID'="")&&(aLocID'=objPathway.CPInLocID)
			 		Continue:(aWardID'="")&&(aLocID'=objPathway.CPInWardID)
			 		Set CPWData=..GetCPWData(objPathway)
			 		Set PatData=..GetPatData(EpisodeID)
			 		Continue:(aRegNo'="")&&(aRegNo'=$lg(PatData,3))		// 登记号过滤
			 		Continue:(aMrNo'="")&&(aMrNo'=$lg(PatData,4))		// 病案号过滤
			 		
			 		//过滤门诊
			 		Set PAAdmType=$lg(PatData,12)
			 		Continue:PAAdmType="O"
			 		
					Set Data=$lb(ind)_CPWData_PatData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
	    		}
    		}
    	}	
	}Else {
			
	}
 	
 	
 	Quit $$$OK
}

ClassMethod QryCPWByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  取出入径信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       objPathway : DHCMA.CPW.CP.Pathway
/// Return：      返回List
/// w ##class(DHCMA.CPW.CP.Pathway).GetCPWData(1)
ClassMethod GetCPWData(objPathway As DHCMA.CPW.CP.Pathway) As %List
{
	New (objPathway)
	Set return=$Lb("")
	Quit:'$IsObject(objPathway) return
	
	Set CPWID=objPathway.%Id()
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc		//当前路径名称
	Set EpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc		//当前阶段
	Set ExecDescList="",ExecReasonList=""										//切换路径名称^
	Set xExecID=""
	For {
		Set xExecID=$o(^DHCMA.CPW.CP.PathwayI("EXEC","IdxofParRef",CPWID,xExecID))
		Quit:xExecID=""
		
		Set objExec=##class(DHCMA.CPW.CP.PathwayExec).GetObjById(CPWID_"||"_xExecID)
		Continue:'$IsObject(objExec)
		
		Set ExecDesc=objExec.CPFormDr.FormPathDr.BTDesc		//切换前路径名称
		Set ExecDescList=ExecDescList_"^"_ExecDesc
		Set ExecReason=objExec.CPExecNote
		Set:ExecReason'="" ExecReasonList=ExecReasonList_"^"_ExecReason
	}
	Set:ExecDescList'="" ExecDescList=$e(ExecDescList,2,$l(ExecDescList))
	Set:ExecReasonList'="" ExecReasonList=$e(ExecReasonList,2,$l(ExecReasonList))
	Set CPWStatus=objPathway.CPStatus
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请",:"")
	
	Set InDate=objPathway.CPInDate
	Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
	Set InTime=objPathway.CPInTime
	Set:InTime'="" InTime=$zt(InTime,1)
	Set InUserID=objPathway.CPInUserID
	Set InUserDesc=""
	If ((InUserID="")||(InUserID="undefined")) {
		set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(objPathway.CPEpisodeID)
		Set InUserID=objPat.PAAdmDocID	//不明原因，申请人为空
		Set objUser=##class(DHCMA.Util.EP.CareProv).GetObjByOID(InUserID)
		Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
	} Else {
		Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
		Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
	}
	Set InLocID=objPathway.CPInLocID
	Set:((InLocID="")||(InLocID="undefined")) InLocID=objPat.PAAdmLocID	//不明原因，申请科室为空
	Set InLocDesc=""
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
	Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
	Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
	
	Set OutDate=objPathway.CPOutDate
	Set OutDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OutDate)
	Set OutTime=objPathway.CPOutTime
	Set:OutTime'="" OutTime=$zt(OutTime,1)
	Set OutUserID=objPathway.CPOutUserID
	Set OutUserDesc=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OutUserID)
	Set:$IsObject(objUser) OutUserDesc=objUser.BTDesc
	Set OutLocID=objPathway.CPOutLocID
	Set OutLocDesc=""
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(OutLocID)
	Set:$IsObject(objLoc) OutLocDesc=objLoc.BTDesc
	Set:OutLocDesc["-" OutLocDesc=$p(OutLocDesc,"-",2)
	
	Set Data=$lb(CPWID,CPWDesc,EpisDesc,ExecDescList,CPWStatus)
	Set Data=Data_$lb(InDate,InTime,InUserDesc,InLocDesc,OutDate,OutTime,OutUserDesc,OutLocDesc,ExecReasonList)
	
	Set return=Data
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  取患者信息
/// Table：       
/// Input：       EpisodeID
/// Return：      返回List
/// w ##class(DHCMA.CPW.CPS.PathwaySrv).GetPatData(784659)
ClassMethod GetPatData(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=$Lb("")
	Quit:aEpisodeID="" return
	
	//Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)		// 该方法信息延迟
	Set objPat=##class(DHCMA.Util.EPx.Episode).GetXObjByOID(aEpisodeID)		// 可以获取实时就诊信息
	Quit:'$IsObject(objPat) return
	
	Set PatientID=objPat.PAPatientID
	Set PapmiNo=objPat.PAPapmiNo
	Set MrNo=objPat.PAMrNo
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set AdmDate=objPat.PAAdmDate
	Set DischDate=objPat.PADischDate
	Set InHospDate=$Case(DischDate'="",1: DischDate-AdmDate,0:+$H-AdmDate)   //住院天数
	Set:InHospDate=0 InHospDate=1
	Set InHospDate=InHospDate_"(天)"
	Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	
	Set paadm=$p(aEpisodeID,"!!",1)
	Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(paadm)
	Set PatCost=$p(Feestr,"^",1)_"元"		//住院总费用。。。
	//增加过滤门诊
	Set PAAdmType=objPat.PAAdmType

	Set Data=$lb(aEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,InHospDate,PatCost,PAAdmType)
	Set return=Data
	
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-11-9
/// Description:  在院患者查询出入径信息
/// Table：       
/// Input：                     
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwaySrv","QryAdmInHos","2!!1","")
Query QryAdmInHos(aHospID As %String, aLocID As %String, aStatus As %String) As %Query(ROWSPEC = "BTLocID:%String,BTLocDesc:%String,BTCount:%String,BTCPWCount:%String,BTFormCount:%String,BTIsVar:%String,BTCost:%String,BTAdmDays:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInHosExecute(ByRef qHandle As %Binary, aHospID As %String, aLocID As %String, aStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryAdmInHos"
    Kill ^TMP($zn,$j,NIndex)
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!"_SYSDr
 	Set:(aHospID'="")&&(aHospID'["!!") aHospID=aHospID_"!!"_SYSDr
 	Set xLoc=""
 	For{
	 	Set xLoc = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc))
	 	Quit:xLoc=""
	 	Continue:(+aLocID'="0")&&(+aLocID'=xLoc)
	 	Set xHospID=+$p($g(^CTLOC((+xLoc))),"^",22)
		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=xHospID)
		Set LocObj=##class(DHCMA.Util.EP.Location).GetObjByOID(xLoc_"!!"_SYSDr)
    	Continue:(LocObj.BTType'="E")||(LocObj.BTDesc["体检")
	 	Set xDate=""
	 	For{
		 	Set xDate = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc,xDate))
	 		Quit:xDate=""
	 		Set xTime=""
	 		For{
		 		Set xTime = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc,xDate,xTime))
	 			Quit:xTime=""
	 			Set xPaadm=""
				For{
					Set xPaadm = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc,xDate,xTime,xPaadm))
	 				Quit:xPaadm=""
	 				Set MatherFlag=$p($g(^PAADM(xPaadm)),"^",75)
					Continue:(MatherFlag'="")
					Set AdmLocID=xLoc_"!!"_SYSDr
					Set ^TMP($zn,$j,NIndex,AdmLocID,"Count")=$g(^TMP($zn,$j,NIndex,AdmLocID,"Count"))+1	//在院人数
					Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
				 	Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
					Continue:xPathwayID=""
					Set objCPW=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
					Continue:'$IsObject(objCPW)
					Set Status=objCPW.CPStatus
					Continue:Status="T"
					Continue:(aStatus'="")&&(aStatus'[Status)
					Continue:'$IsObject(objCPW.CPFormDr.FormPathDr)
					Set FeeStr=##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(+EpisodeID)	//住院总费用
			    	Set AdmFees=$p(FeeStr,"^",1)
			    	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
					Set IsVar=..GetVarFlag(xPathwayID)
					if (+IsVar=1){
						Set ^TMP($zn,$j,NIndex,AdmLocID,"IsVar")=$g(^TMP($zn,$j,NIndex,AdmLocID,"IsVar"))+1	//变异人数
					}
					Set AdmDate=objPat.PAAdmDate
					Set DischDate=objPat.PADischDate
					Set InHospDate=$Case(DischDate'="",1: DischDate-AdmDate,0:+$H-AdmDate)   //住院天数
					Set:InHospDate=0 InHospDate=1
			    	Set FormCost=objCPW.CPFormDr.FormCost			//参考费用
					Set FormDays=objCPW.CPFormDr.FormDays			//参考住院日
			    	if (AdmFees>FormCost){
				    	Set ^TMP($zn,$j,NIndex,AdmLocID,"Cost")=$g(^TMP($zn,$j,NIndex,AdmLocID,"Cost"))+1	//费用超标人数
				    }
				    if (InHospDate>FormDays){
				    	Set ^TMP($zn,$j,NIndex,AdmLocID,"AdmDays")=$g(^TMP($zn,$j,NIndex,AdmLocID,"AdmDays"))+1	//住院天数超标人数
				    }
					Set FormPathID=objCPW.CPFormDr.FormPathDr.%Id()
					Set ^TMP($zn,$j,NIndex,AdmLocID,"CPWCount")=$g(^TMP($zn,$j,NIndex,AdmLocID,"CPWCount"))+1	//入径人数
					Set FormPathList=$g(^TMP($zn,$j,NIndex,AdmLocID,"FormPathList"))
					if ((","_FormPathList_",")'[(","_FormPathID_",")){
						Set ^TMP($zn,$j,NIndex,AdmLocID,"FormPathList")=$g(^TMP($zn,$j,NIndex,AdmLocID,"FormPathList"))_","_FormPathID
						Set ^TMP($zn,$j,NIndex,AdmLocID,"FormCount")=$g(^TMP($zn,$j,NIndex,AdmLocID,"FormCount"))+1	//路径数
					}
				}
		 	}
		}
	}

	Set xLoc=""
	For{
		Set Count="",CPWCount="",FormCount="",IsVar="",Cost="",AdmDays=""
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
		Set Count=+$g(^TMP($zn,$j,NIndex,xLoc,"Count"))			//在院人数
		Set CPWCount=+$g(^TMP($zn,$j,NIndex,xLoc,"CPWCount"))		//入径人数
		Set FormCount=+$g(^TMP($zn,$j,NIndex,xLoc,"FormCount"))	//路径数
		Set IsVar=+$g(^TMP($zn,$j,NIndex,xLoc,"IsVar"))		//变异人数
		Set Cost=+$g(^TMP($zn,$j,NIndex,xLoc,"Cost"))		//费用超标人数
		Set AdmDays=+$g(^TMP($zn,$j,NIndex,xLoc,"AdmDays"))		//住院天数超标人数
		Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(xLoc)
		Continue:'$IsObject(objLoc)
		Set LocDesc=objLoc.BTDesc	//科室名称
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set Data=$lb(xLoc,LocDesc,Count,CPWCount,FormCount,IsVar,Cost,AdmDays)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
 	
 	Quit $$$OK
}

ClassMethod QryAdmInHosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInHosExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInHosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInHosExecute ]
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

/// Creator：     zqy
/// CreatDate：   2022-11-9
/// Description:  在院患者查询出入径信息明细
/// Table：       
/// Input：                     
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwaySrv","QryAdmInHosDetail","2!!1","")
Query QryAdmInHosDetail(aHospID As %String, aLocID As %String) As %Query(ROWSPEC = "EpisodeID:%String,BTPathDesc:%String,BTFormCost:%String,BTFormDays:%String,BTPatName:%String,BTPatSex:%String,BTAdmDocName:%String,BTPatAge:%String,BTAdmDate:%String,BTCPInDate:%String,BTEpisDesc:%String,BTInCPWDate:%String,BTInHospDate:%String,BTPatCost:%String,BTDrugCost:%String,BTPerItem:%String,BTVarDesc:%String,Status:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInHosDetailExecute(ByRef qHandle As %Binary, aHospID As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aHospID="")||(aLocID="") $$$OK
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!"_SYSDr
 	Set:(aHospID'="")&&(aHospID'["!!") aHospID=aHospID_"!!"_SYSDr
	Set xDate="",xLoc=$p(aLocID,"!!",1)
	Set xHospID=+$p($g(^CTLOC((+aLocID))),"^",22)
	Quit:(aHospID'="")&&($p(aHospID,"!!",1)'=xHospID)
 	For{
	 	Set xDate = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc,xDate))
 		Quit:xDate=""
 		Set xTime=""
 		For{
	 		Set xTime = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc,xDate,xTime))
 			Quit:xTime=""
 			Set xPaadm=""
			For{
				Set xPaadm = $o(^PAADMi("AdmTypeCurrLoc","I",xLoc,xDate,xTime,xPaadm))
 				Quit:xPaadm=""
 				Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
 				Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
				Continue:xPathwayID=""
				Set objCPW=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
				Continue:'$IsObject(objCPW)
				Set Status=objCPW.CPStatus
				Continue:Status="T"
				Continue:'$IsObject(objCPW.CPFormDr.FormPathDr)
				Set Status=$Case(Status,"I":"入径","O":"出径","C":"完成","T":"不入径","U":"作废","P":"预约","A":"申请",:"")
				set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
				Continue:'$IsObject(objPat)
				Continue:objPat.PAVisitStatus'="A"
				Set PatName=objPat.PAPatName	//姓名
				Set PatSex=objPat.PASex
				Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")	//姓别
				Set docData=$g(^CTPCP(+$p(^PAADM(+EpisodeID),"^",9),1))
				Set AdmDocName=$p(docData,"^",2)
				Set PatAge=objPat.PAAge			//年龄
				Set AdmDate=objPat.PAAdmDate	//入院日期
				Set CPInDate=objCPW.CPInDate	//入径日期
				Set EpisDesc=objCPW.CPEpisDr.CPFormEpDr.EpDesc	//所处步骤
				Set InCPWDate=+$H-CPInDate   //入径天数
				Set:InCPWDate=0 InCPWDate=1
				Set InHospDate=+$H-AdmDate   //在院天数
				Set:InHospDate=0 InHospDate=1
				Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
				Set CPInDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(CPInDate)
				Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(+EpisodeID)
				Set PatCost=$p(Feestr,"^",1)		//总费用
				Set:PatCost="" PatCost=0 
				Set:PatCost=0 DrugCost="0.00%"
				Set:PatCost'=0 DrugCost=$fn($p(Feestr,"^",2)/PatCost,"",2)*100_"%"	//药费比例
				Set retItemCount=..GetCPWItemCount(xPathwayID)
				Set ExeReqCount=$p(retItemCount,"^",1)
				Set ExeOptCount=$p(retItemCount,"^",2)
				Set PerformCount=ExeReqCount+ExeOptCount
				Set ReqCount=$p(retItemCount,"^",3)
				Set OptCount=$p(retItemCount,"^",4)
				Set TotalCount=ReqCount+OptCount
				Set:TotalCount=0 PerItem="0.00%"
				Set:TotalCount'=0 PerItem=$fn(PerformCount/TotalCount,"",2)*100_"%"
				Set IsVar=..GetVarFlag(xPathwayID)
				Set VarDesc=$Case(IsVar,"1":"是","0":"否",:"")
				Set PathDesc=objCPW.CPFormDr.FormPathDr.BTDesc	//路径名称
				Set Version=objCPW.CPFormDr.FormVersion
				Set Version=+Version_".0"						//版本
				Set PathDesc=PathDesc_" "_Version
				Set FormCost=objCPW.CPFormDr.FormCost			//参考费用
				Set FormDays=objCPW.CPFormDr.FormDays			//参考住院日
				Set:FormCost="" FormCost=0
				Set:FormDays="" FormDays=0
				Set Data=$lb(EpisodeID,PathDesc,FormCost,FormDays,PatName,PatSex,AdmDocName,PatAge,AdmDate,CPInDate,EpisDesc,InCPWDate,InHospDate,PatCost,DrugCost,PerItem,VarDesc,Status)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
 		}
 	}
 	Quit $$$OK
}

ClassMethod QryAdmInHosDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInHosDetailExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInHosDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInHosDetailExecute ]
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

/// Creator：     zqy
/// CreatDate：   2022-11-9
/// Modify:		  增加可选项目总数、必选项目总数输出，修改返回格式	---Modified By yankai 2023-03-30
/// Description:  取患者所入路径项目相关数量
/// Table：       
/// Input：       aPathwayID:出入径记录ID
/// Return：      已执行必选项目数^已执行可选项目数^必选项目总数^可选项目总数
/// w ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWItemCount(784659)
ClassMethod GetCPWItemCount(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return = ""
	Quit:aPathwayID="" return
	
	//执行项目
 	Set xCPFormItem="",ExeReqCount=0,ExeOptCount=0,ReqCount=0,OptCount=0
 	For{
		Set xCPFormItem=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,xCPFormItem))
	 	Quit:xCPFormItem=""
	 		
	 	Set xPathwayImpl=""
	 	For{
		 	Set xPathwayImpl=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,xCPFormItem,xPathwayImpl))
	 		Quit:xPathwayImpl=""
	 		
	 		Set objPathwayImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xPathwayImpl)
	 		Continue:'$IsObject(objPathwayImpl)
	 		Continue:objPathwayImpl.CPIsActive'=1
	 		Continue:objPathwayImpl.CPPathwayComplDr'=""		// 执行的合并症的项目不计算在内 Modified by yankai 20230330
	 		Continue:'$IsObject(objPathwayImpl.CPFormItemDr)
	 		Set objCPFormItem=objPathwayImpl.CPFormItemDr
	 		If objCPFormItem.ItemIsOption=1{		// 可选项目
		 		Set OptCount = OptCount + 1
		 		Set:objPathwayImpl.CPIsImp=1 ExeOptCount=ExeOptCount+1	
		 	}Else{
			 	Set ReqCount = ReqCount + 1
			 	Set:objPathwayImpl.CPIsImp=1 ExeReqCount=ExeReqCount+1	
			 }
		}
	}
	
	Set return=ExeReqCount_"^"_ExeOptCount_"^"_ReqCount_"^"_OptCount
 	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-11-9
/// Description:  判断入径患者是否发生变异
/// Modify:		  增加变异类型返回：正变异:P；负变异:N；正负变异都存在:PN	---Modified by yankai 2023-03-30
/// Table：       
/// Input：       aPathwayID:出入径记录ID
/// Return：      是否变异(变异:1；未变异:0)^变异类型(正变异:P；负变异:N；正负变异都存在:PN)
/// w ##class(DHCMA.CPW.CPS.PathwaySrv).GetVarFlag(3)
ClassMethod GetVarFlag(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=""
	Quit:aPathwayID="" return
	
	Set xVarID="",varFlg=0,varType=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"VAR",xVarID))
		Quit:xVarID=""
		
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
 		Continue:'$IsObject(objVar.CPVariatDr)
	 	Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
	 	Set varFlg=1
	 	Set rsnType=objVar.CPVariatDr.BTIsExactly
	 	If rsnType=1{						// 正变异
		 	Set:varType'["N" varType="P"
			Set:varType["N" varType="PN"
		}Else{								// 负变异
			Set:varType'["P" varType="N"
			Set:varType["P" varType="PN"	
		}
	}
	
	Set return = varFlg_"^"_varType
 	Quit return
}

}
