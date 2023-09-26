/// 名称：DHCMA.CPW.OPCPS.PathwaySrv
/// 描述：门诊临床路出入径查询相关业务类
/// 编写者：dengshaopeng
/// 编写日期：2019-10-29
Class DHCMA.CPW.OPCPS.PathwaySrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2019-10-29
/// Description:  根据时间、科室、日期类型等获取门诊临床路径出入径相关信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aDateType、aDateFrom、aDateTo、aStatus、aLocID、aWardID、aHospID
/// Return：	  
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.PathwaySrv","QryOPCPWByDate","1","2019-02-16","2019-10-28","","","","2")
Query QryOPCPWByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate,InHospDate:%String,PatCost:%String") [ SqlProc ]
{
}

ClassMethod QryOPCPWByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set IndexName=$Case(aDateType,"1":"IdxofInLocDate","2":"IdxofOutLocDate")
	Set xLocID=""
	For {
		 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID))
		 	Quit:xLocID=""
		 	
		 	Continue:(aLocID'="")&&(aLocID'=$p(xLocID,"!!",1))
		 	Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
		 	Continue:(aHospID'="")&&(aHospID'[xHospID)
		 	
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
			 		Continue:(aStatus'="")&&(aStatus'[Status)
			 		//Continue:objPathway.CPFormDr.FormPathDr.BTAdmType'["O"			//路径所设置就诊类型
			 		
			 		Set AdmID=$p(objPathway.CPEpisodeID,"!!",1)
					Set AdmType=$p($g(^PAADM(AdmID)),"^",2)  							//病人初次入径时就诊类型
					Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(AdmID)
					Set CfgAdmType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPGetInAdmType",AdmHospID)	//门诊路径准入就诊类型									
 					Continue:CfgAdmType'[AdmType
			 		
			 		Set CPWData= ..GetPathwayData(objPathway)
			 		Set EpisodeID=objPathway.CPEpisodeID
			 		Set PatData= ..GetPatData(EpisodeID)
			 		
					Set Data=$lb(ind)_CPWData_PatData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 	}
		 	}
	}
 	
 	Quit $$$OK
}

ClassMethod QryOPCPWByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPCPWByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPCPWByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPCPWByDateExecute ]
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

/// Creator：     dengshaopeng
/// CreatDate：   2019-10-29
/// Description:  根据路径ID、病人ID获取相关路径Visit信息
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       aPathWayID
/// Return：	  
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.PathwaySrv","QryOPCPWVisitByaPathWayID","339","28")
Query QryOPCPWVisitByaPathWayID(aPatientID As %String, aPathWayID As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,DiagnoseC:%String,DiagnoseF:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate,InHospDate:%String,PatCost:%String") [ SqlProc ]
{
}

ClassMethod QryOPCPWVisitByaPathWayIDExecute(ByRef qHandle As %Binary, aPatientID As %String, aPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathWayID="")||(aPatientID="") $$$OK
 	
 	Set xVisitID=""
	For	{
	 	Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPathwayDr",aPathWayID,xVisitID))
		Quit:xVisitID=""
		 	
		Set objPathwayVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
		Continue:'$IsObject(objPathwayVisit)
		
		Set AdmType=objPathwayVisit.CPFormDr.FormPathDr.BTAdmType
		//Continue:AdmType'["O"
			 		
		Set PathVisitData= ..GetVisitData(objPathwayVisit)
		Set EpisodeID=objPathwayVisit.CPEpisodeID
		Set PatData= ..GetPatData(EpisodeID)
			 		
		Set Data=$lb(ind)_PathVisitData_PatData
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
 	
 	Quit $$$OK
}

ClassMethod QryOPCPWVisitByaPathWayIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPCPWVisitByaPathWayIDExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPCPWVisitByaPathWayIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPCPWVisitByaPathWayIDExecute ]
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

/// Creator：     dengshaopeng
/// CreatDate：   2019-10-29
/// Description:  根据时间、科室、日期类型等获取门诊临床路径出入径相关信息
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aDateType、aDateFrom、aDateTo、aStatus、aLocID、aWardID、aHospID
/// Return：	  
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.PathwaySrv","QryOPCPWVisitByDate","1","2019-02-16","2019-10-28","","","","2")
Query QryOPCPWVisitByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String) As %Query(ROWSPEC = "ind:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String,DiagnoseC:%String,DiagnoseF:%String,aEpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate,InHospDate:%String,PatCost:%String") [ SqlProc ]
{
}

ClassMethod QryOPCPWVisitByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aLocID As %String, aWardID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	
 	Set IndexName=$Case(aDateType,"1":"IdxofInLocDate","2":"IdxofOutLocDate")
	Set xLocID=""
	For {
	 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayI(IndexName,xLocID))
	 	Quit:xLocID=""
	 	
	 	Continue:(aLocID'="")&&(aLocID'=$p(xLocID,"!!",1))
	 	Set xHospID=+$p($g(^CTLOC(($p(xLocID,"!!",1)))),"^",22)
	 	Continue:(aHospID'="")&&(aHospID'[xHospID)
	 	
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
		 		//Continue:objPathway.CPFormDr.FormPathDr.BTAdmType'["O"				//路径所设置就诊类型
		 		Set Status=objPathway.CPStatus
		 		Continue:(aStatus'="")&&(aStatus'[Status)
		 		Set AdmID=$p(objPathway.CPEpisodeID,"!!",1)
				Set AdmType=$p($g(^PAADM(AdmID)),"^",2)  							//病人初次入径时就诊类型									
				
				Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(AdmID)
				Set CfgAdmType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPGetInAdmType",AdmHospID)	//门诊路径准入就诊类型
				Continue:CfgAdmType'[AdmType
				
			 	Set PatID=$p($g(^PAADM(AdmID)),"^",1)
			 		
				Set xVisitID=""
				For {
					Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPathwayDr",xCPWID,xVisitID))
					Quit:xVisitID=""
					
					Set objPathwayVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
					Continue:'$IsObject(objPathwayVisit)
					Set PathVisitData= ..GetVisitData(objPathwayVisit)
					Set EpisodeID=objPathwayVisit.CPEpisodeID
					Set PatData= ..GetPatData(EpisodeID)
					
					Set Data=$lb(ind)_PathVisitData_PatData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	
				}
		 	}
	 	}
	}
 	
 	Quit $$$OK
}

ClassMethod QryOPCPWVisitByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPCPWVisitByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPCPWVisitByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPCPWVisitByDateExecute ]
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
/// w ##class(DHCMA.CPW.CP.Pathway).GetPathwayData(1)
ClassMethod GetPathwayData(objPathway As DHCMA.CPW.CP.Pathway) As %List
{
	New (objPathway)
	Set return=$Lb("")
	Quit:'$IsObject(objPathway) return
	
	Set CPWID=objPathway.%Id()
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc		//当前路径名称
	Set EpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc		//当前阶段
	
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
	
	Set Data=$lb(CPWID,CPWDesc,EpisDesc,CPWStatus)
	Set Data=Data_$lb(InDate,InTime,InUserDesc,InLocDesc,OutDate,OutTime,OutUserDesc,OutLocDesc)
	
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
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
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
	set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set Data=$lb(aEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,InHospDate,PatCost)
	Set return=Data
	
	Quit return
}

/// Creator：     dengshaopeng
/// CreatDate：   2019-10-29
/// Description:  取就诊出入径信息
/// Table：       DHCMA.CPW.CP.PathwayVisit
/// Input：       objPathway : DHCMA.CPW.CP.PathwayVisit
/// Return：      返回List
/// w ##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).GetVisitData(1)
ClassMethod GetVisitData(objVisit As DHCMA.CPW.CP.PathwayVisit) As %List
{
	New (objVisit)
	Set return=$Lb("")
	Quit:'$IsObject(objVisit) return
	
	Set CPWID=objVisit.%Id()
	Set CPWDesc=objVisit.CPFormDr.FormPathDr.BTDesc			//当前路径名称
	Set EpisDesc=objVisit.CPEpisDr.CPFormEpDr.EpDesc		//当前阶段
	
	Set CPWStatus=objVisit.CPStatus
	//T不入径、I就诊入径、U作废
	Set CPWStatus=$Case(CPWStatus,"T":"不入径","I":"就诊入径","U":"作废",:"")
	
	Set InDate=objVisit.CPInDate
	Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
	Set InTime=objVisit.CPInTime
	Set:InTime'="" InTime=$zt(InTime,1)
	Set InUserID=objVisit.CPInUserID
	Set InUserDesc=""
	If ((InUserID="")||(InUserID="undefined")) {
		set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(objVisit.CPEpisodeID)
		Set InUserID=objPat.PAAdmDocID	//不明原因，申请人为空
		Set objUser=##class(DHCMA.Util.EP.CareProv).GetObjByOID(InUserID)
		Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
	} Else {
		Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
		Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
	}
	Set InLocID=objVisit.CPInLocID
	Set:((InLocID="")||(InLocID="undefined")) InLocID=objPat.PAAdmLocID	//不明原因，申请科室为空
	Set InLocDesc=""
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
	Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
	Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
	Set InDiags = objVisit.CPInDiags
	
	if (InDiags'=""){
		For ind=1:1:$l(InDiags,",") 
		{
			
			Set xInDiags =$p(InDiags,",",ind)
			Continue:xInDiags=""
			Set InDiagsDesc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetDiagDesc(xInDiags)
			
			Set ICDID= $p($g(^MR($p(xInDiags,"||",1),"DIA",$p(xInDiags,"||",2))),"^",1)
			Set ICDCata = ##class(DHCMA.CPW.IO.FromDoc).GetDiagnosCat(ICDID)
			Set:ICDCata="西医" DiagnoseF=InDiagsDesc
			Set:ICDCata="中医" DiagnoseC=InDiagsDesc
		}
	}
		
	Set Data=$lb(CPWID,CPWDesc,EpisDesc,CPWStatus)
	Set Data=Data_$lb(InDate,InTime,InUserDesc,InLocDesc,OutDate,OutTime,OutUserDesc,OutLocDesc,DiagnoseC,DiagnoseF)
	
	Set return=Data
	Quit return
}

}
