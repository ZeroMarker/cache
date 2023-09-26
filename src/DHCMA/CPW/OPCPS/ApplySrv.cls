/// 名称: DHCMA.CPW.OPCPS.ApplySrv
/// 描述: 门诊临床路径不入径查询服务类
/// 编写者：dengshaopeng
/// 编写日期: 2019-11-13
Class DHCMA.CPW.OPCPS.ApplySrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2019-11-13
/// Description:  通过申请日期查询申请、审核信息
/// Table：       DHCMA.CPW.CP.PathwayApply
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.ApplySrv","QryNotInPathInfo","01/03/2019","12/12/2019","","")
Query QryNotInPathInfo(aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String) As %Query(ROWSPEC = "xVisitID:%String,ApplyID:%String,EpisodeID:%String,PatientID:%String,PaadmID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,CPWDesc:%String,LocID:%String,LocDesc:%String,Reason:%String,ApplyTxt:%String,AppUserDesc:%String,ApplyDate:%String,MobilePhone:%String,UserCode:%String") [ SqlProc ]
{
}

ClassMethod QryNotInPathInfoExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospID As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^TEMPYK("QryNotInPathInfo")=$LB(aDateFrom,aDateTo,aHospID,aLocID)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	
 	Set xLocID=""
 	For {
	 	Set xLocID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfInLocDate",xLocID))
	 	Quit:xLocID=""
	 	
	 	Continue:(aLocID'="")&&(aLocID'=xLocID)
	 	Set xInDate=""
	 	For {
		 	Set xInDate=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfInLocDate",xLocID,xInDate))
		 	Quit:xInDate=""
		 	
		 	Continue:(xInDate<aDateFrom)||(xInDate>aDateTo)
		 	Set xVisitID=""
		 	For {
			 	Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfInLocDate",xLocID,xInDate,xVisitID))
			 	Quit:xVisitID=""
			 	
			 	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
			 	Continue:'$IsObject(objVisit)
			 	Set EpisodeID=objVisit.CPEpisodeID
			 	Set VisitStatus=##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).GetPathStatus(EpisodeID)
			 	
			 	Continue:VisitStatus'="T"					//只检查最新状态是未入径状态的记录
			 	
			 	Set objApply=objVisit.CPApplyDr
			 	Continue:'$IsObject(objApply)
			 	Continue:objApply.CPIsActive'=1
			 	
			 	Set ApplyID=objApply.%Id()
			 	Set PathwayStatus=objVisit.CPPathwayDr.CPStatus
			 	Set CPWDesc=objVisit.CPPathwayDr.CPFormDr.FormPathDr.BTDesc
			 	
			 	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
				Continue:'$IsObject(objPat)
				Set PatientID=objPat.PAPatientID
				Set PaadmID=$p(EpisodeID,"!!",1)
				Set PapmiNo=objPat.PAPapmiNo
				Set PatName=objPat.PAPatName
				Set PatSex=objPat.PASex
				Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
				Set PatAge=objPat.PAAge
			 		
				Set (TypeDesc,Reason,ApplyTxt,LocID,LocDesc,WardID,WardDesc,AppUserDesc,IsVerify,VerNote,VerDate,VerUserID,VerUserDesc,ApplyDate)=""
				Set LocID=objApply.CPLocID
				Set:$IsObject(objApply.CPTypeDr) TypeDesc=objApply.CPTypeDr.BTDesc
				Continue:(TypeDesc'="")&&(TypeDesc'="未入径原因")						
				
				Set Reason=objApply.CPReasonDr.BTDesc
				Set ApplyTxt=objApply.CPApplyTxt
					
				Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(LocID)
				Set:$IsObject(objLoc) LocDesc=objLoc.BTDesc
				Set xHospID=+$p($g(^CTLOC(($p(LocID,"!!",1)))),"^",22)
	 			Continue:(aHospID'="")&&(aHospID'[xHospID)
	 	
				Set AppUser=objApply.CPActUserID
				If ((AppUser="")||(AppUser="undefined")) {
					Set AppUser=objPat.PAAdmDocID	//不明原因，申请人为空
					Set objUser=##class(DHCMA.Util.EP.CareProv).GetObjByOID(AppUser)
					Set:$IsObject(objUser) AppUserDesc=objUser.BTDesc
					Set MobilePhone=$p($g(^CTPCP(+AppUser,3)),"^",6)
					Set UserCode=objUser.BTCode
				} Else {
					Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(AppUser)
					Set:$IsObject(objUser) AppUserDesc=objUser.BTDesc
					Set CareProvID=objUser.BTCareProvID
					Set MobilePhone=$p($g(^CTPCP(+CareProvID,3)),"^",6)
					Set UserCode=objUser.BTCode
				}
				
				Set ApplyDate=xInDate
				Set ApplyDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
					
				Set Data=$lb(xVisitID,ApplyID,EpisodeID,PatientID,PaadmID,PapmiNo,PatName,PatSex,PatAge,CPWDesc,LocID,LocDesc,Reason,ApplyTxt,AppUserDesc,ApplyDate,MobilePhone,UserCode)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1	
			 }
		 }	
	 }
 	
 	Quit $$$OK
}

ClassMethod QryNotInPathInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNotInPathInfoExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNotInPathInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNotInPathInfoExecute ]
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
