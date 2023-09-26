/// 名称: DHCMed.EPDService.ReferralRepSrv
/// 描述: 肺结核病人转诊单打印
/// 编写者：jiangpengpeng
/// 编写日期: 2016-07-22
Class DHCMed.EPDService.ReferralRepSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-11
/// Description:  肺结核病人转诊单打印
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.ReferralRepSrv).ExportReferralRep("fillxlSheet","1")
ClassMethod ExportReferralRep(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=1
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.EPD.ReferralRep).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	//第二联
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatName,"O","JS")_"',4,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatSex,"O","JS")_"',4,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatAge,"O","JS")_"',4,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatMrNo,"O","JS")_"',4,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatAddress,"O","JS")_"',5,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatPhoneNo,"O","JS")_"',6,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.FamilyName,"O","JS")_"',6,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.WorkAddress,"O","JS")_"',7,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralHosp,"O","JS")_"',9,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralDoc,"O","JS")_"',10,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralDate,"O","JS")_"',11,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralAdd,"O","JS")_"',12,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralPhone,"O","JS")_"',12,18);"
	&javascript<#(retval)#>
	
	Set ReferralReason = objRep.ReferralReason
	if ReferralReason'=""{
		Set objReferralReason = ##class(DHCMed.SS.Dictionary).GetObjById(ReferralReason)
		Set:$IsObject(objReferralReason) ReferralReason = objReferralReason.Description
	}
	If (ReferralReason["有") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',8,6);"
		&javascript<#(retval)#>
	} ElseIf (ReferralReason["或") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',8,12);"
		&javascript<#(retval)#>
	} ElseIf (ReferralReason["出院") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',8,18);"
		&javascript<#(retval)#>
	}
	
	//第三联
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatName,"O","JS")_"',18,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatSex,"O","JS")_"',18,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatAge,"O","JS")_"',18,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatMrNo,"O","JS")_"',18,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatAddress,"O","JS")_"',19,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatPhoneNo,"O","JS")_"',20,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.FamilyName,"O","JS")_"',20,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.WorkAddress,"O","JS")_"',21,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralHosp,"O","JS")_"',23,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralDoc,"O","JS")_"',24,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralDate,"O","JS")_"',25,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralAdd,"O","JS")_"',26,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralPhone,"O","JS")_"',26,18);"
	&javascript<#(retval)#>
	Set ReferralReason = objRep.ReferralReason
	if ReferralReason'=""{
		Set objReferralReason = ##class(DHCMed.SS.Dictionary).GetObjById(ReferralReason)
		Set:$IsObject(objReferralReason) ReferralReason = objReferralReason.Description
	}
	If (ReferralReason["有") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',22,6);"
		&javascript<#(retval)#>
	} ElseIf (ReferralReason["或") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',22,12);"
		&javascript<#(retval)#>
	} ElseIf (ReferralReason["出院"){
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',22,18);"
		&javascript<#(retval)#>
	}
	//第一联
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatName,"O","JS")_"',32,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatSex,"O","JS")_"',32,12);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatAge,"O","JS")_"',32,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatMrNo,"O","JS")_"',32,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatAddress,"O","JS")_"',33,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.PatPhoneNo,"O","JS")_"',34,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.FamilyName,"O","JS")_"',34,18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.WorkAddress,"O","JS")_"',35,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralHosp,"O","JS")_"',37,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralDoc,"O","JS")_"',38,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralDate,"O","JS")_"',39,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralAdd,"O","JS")_"',40,6);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ReferralPhone,"O","JS")_"',40,18);"
	&javascript<#(retval)#>
	Set ReferralReason = objRep.ReferralReason
	if ReferralReason'=""{
		Set objReferralReason = ##class(DHCMed.SS.Dictionary).GetObjById(ReferralReason)
		Set:$IsObject(objReferralReason) ReferralReason = objReferralReason.Description
	}
	If (ReferralReason["有") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',36,6);"
		&javascript<#(retval)#>
	} ElseIf (ReferralReason["或") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',36,12);"
		&javascript<#(retval)#>
	} ElseIf (ReferralReason["出院") {
		Set retval=itmjs_"(xlSheet,'☑"_$ZCVT("","O","JS")_"',36,18);"
		&javascript<#(retval)#>
	}
	
	Quit Count
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.CDService.PrintService).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// Creator：     yukai
/// CreatDate：   2019-05-17
/// Description:  根据日期查询肺结核转诊单
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ReferralRepSrv","QryRefRepByDate","2019-04-01","2019-05-19","")
Query QryRefRepByDate(aFromDate As %String, aToDate As %String, aRepStatus As %String, aHospital As %String) As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,ReportTime:%String,PatName:%String,PatSex:%String,PatAge:%String,PatAddress:%String,PatPhoneNo:%String,FamilyName:%String,WorkAddress:%String,EpisodeID:%String,PatMrNo:%String,ReferralReason:%String,ReferralHosp:%String,ReferralDoc:%String,ReferralDate:%String,ReferralAdd:%String,ReferralPhone:%String")
{
}

ClassMethod QryRefRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aRepStatus As %String, aHospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.EPD.ReferralRepI("ReportDateIndex",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate	
		Set xRepID=""
		For {
			Set xRepID=$o(^DHCMed.EPD.ReferralRepI("ReportDateIndex",xDate,xRepID))
			Quit:xRepID=""
			Set objRep=##class(DHCMed.EPD.ReferralRep).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			
			Set (RepStatusDesc,ReportUser,ReportDate,ReportTime)=""
			Set (PatName,PatSex,PatAge,PatAddress,PatPhoneNo,FamilyName,WorkAddress)=""
			Set (EpisodeID,PatMrNo,ReferralReason,ReferralHosp,ReferralDoc,ReferralDate,ReferralAdd,ReferralPhone)=""
			if ($IsObject(objRep.ReportStatus)){
				Set RepStatusID=objRep.ReportStatus.%Id()
				Continue:((aRepStatus'="")&&(aRepStatus'[RepStatusID))
				Set RepStatusDesc=objRep.ReportStatus.Description
			}
			
			Set ReportUserDr=objRep.ReportUser
			If (ReportUserDr'=""){
				set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUserDr)
				If ($IsObject(objUser)){
					set ReportUser=objUser.Name
					Set:ReportUser'="" ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",ReportUser)
			
				}
			}
			Set ReportDate=objRep.ReportDate
			Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
			Set ReportTime=objRep.ReportTime
			Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
						
			Set PatName=objRep.PatName
			Set PatSex=objRep.PatSex
			Set:PatSex'="" PatSex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
				
			Set PatAge=objRep.PatAge
			Set PatAddress=objRep.PatAddress
			Set PatPhoneNo=objRep.PatPhoneNo
			Set FamilyName=objRep.FamilyName
			Set WorkAddress=objRep.WorkAddress
			
			Set EpisodeID=objRep.EpisodeID
			if aHospital'="" {
				Set PAData=$g(^PAADM(+EpisodeID))
				Set DepartmentID=$p(PAData,"^",4)
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(DepartmentID,aHospital)
				continue:flg<1
			}
			Set PatMrNo=objRep.PatMrNo
			Set ReferralDoc=objRep.ReferralDoc
			Set ReferralReasonDr=objRep.ReferralReason
			if (ReferralReasonDr'=""){
				Set RefReaObj=##class(DHCMed.SS.Dictionary).GetObjById(ReferralReasonDr)
				Set:$IsObject(RefReaObj) ReferralReason=RefReaObj.Description	
			}
			Set ReferralHosp=objRep.ReferralHosp
			Set ReferralHosp = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc","",ReferralHosp)
			Set ReferralDate=objRep.ReferralDate
			Set ReferralAdd=objRep.ReferralAdd
			Set ReferralPhone=objRep.ReferralPhone
			
			Set Data=$lb(ind,xRepID,RepStatusDesc,ReportUser,ReportDate,ReportTime)
			Set Data=Data_$lb(PatName,PatSex,PatAge,PatAddress,PatPhoneNo,FamilyName,WorkAddress)
			Set Data=Data_$lb(EpisodeID,PatMrNo,ReferralReason,ReferralHosp,ReferralDoc,ReferralDate,ReferralAdd,ReferralPhone)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryRefRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRefRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
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

/// Creator：     yukai
/// CreatDate：   2019-05-17
/// Description:  根据日期查询肺结核转诊单
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ReferralRepSrv","QryRefRepByEpisode","23")
Query QryRefRepByEpisode(aEpisodeID As %String) As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,ReportTime:%String,PatName:%String,PatSex:%String,PatAge:%String,PatAddress:%String,PatPhoneNo:%String,FamilyName:%String,WorkAddress:%String,EpisodeID:%String,PatMrNo:%String,ReferralReason:%String,ReferralHosp:%String,ReferralDoc:%String,ReferralDate:%String,ReferralAdd:%String,ReferralPhone:%String")
{
}

ClassMethod QryRefRepByEpisodeExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.EPD.ReferralRepI("EpisodeIDIndex"," "_aEpisodeID,xRepID))
		Quit:xRepID=""
		Set objRep=##class(DHCMed.EPD.ReferralRep).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		
		Set (RepStatusDesc,ReportUser,ReportDate,ReportTime)=""
		Set (PatName,PatSex,PatAge,PatAddress,PatPhoneNo,FamilyName,WorkAddress)=""
		Set (EpisodeID,PatMrNo,ReferralReason,ReferralHosp,ReferralDoc,ReferralDate,ReferralAdd,ReferralPhone)=""
		
		Set RepStatusID=objRep.ReportStatus.%Id()
		Set RepStatusDesc=objRep.ReportStatus.Description
		Set RepStatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",RepStatusDesc)
		Set ReportUserDr=objRep.ReportUser
		If (ReportUserDr'=""){
			set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUserDr)
			If ($IsObject(objUser)){
				set ReportUser=objUser.Name
				Set:ReportUser'="" ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",ReportUser)
			}
		}
		Set ReportDate=objRep.ReportDate
		Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set ReportTime=objRep.ReportTime
		Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
					
		Set PatName=objRep.PatName
		Set PatSex=objRep.PatSex
		Set PatAge=objRep.PatAge
		Set PatAddress=objRep.PatAddress
		Set PatPhoneNo=objRep.PatPhoneNo
		Set FamilyName=objRep.FamilyName
		Set WorkAddress=objRep.WorkAddress
		
		Set PatMrNo=objRep.PatMrNo
		Set ReferralDoc=objRep.ReferralDoc
		Set ReferralReasonDr=objRep.ReferralReason
		if (ReferralReasonDr'=""){
			Set RefReaObj=##class(DHCMed.SS.Dictionary).GetObjById(ReferralReasonDr)
			Set:$IsObject(RefReaObj) ReferralReason=RefReaObj.Description	
			}
		Set ReferralHosp=objRep.ReferralHosp
		Set ReferralDate=objRep.ReferralDate
		Set ReferralAdd=objRep.ReferralAdd
		Set ReferralPhone=objRep.ReferralPhone
		
		Set Data=$lb(ind,xRepID,RepStatusDesc,ReportUser,ReportDate,ReportTime)
		Set Data=Data_$lb(PatName,PatSex,PatAge,PatAddress,PatPhoneNo,FamilyName,WorkAddress)
		Set Data=Data_$lb(EpisodeID,PatMrNo,ReferralReason,ReferralHosp,ReferralDoc,ReferralDate,ReferralAdd,ReferralPhone)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryRefRepByEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRefRepByEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
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
