/// 名称: DHCMA.CPW.CPS.ApplySrv
/// 描述: 临床路径申请审核相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2018-09-14
Class DHCMA.CPW.CPS.ApplySrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-14
/// Description:  通过申请日期查询申请、审核信息
/// Table：       DHCMA.CPW.CP.PathwayApply
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.ApplySrv","QryApplyInfo","","01/10/2019","10/10/2019","","","")
Query QryApplyInfo(aTypeID As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aNotIn As %String = "") As %Query(ROWSPEC = "ind:%String,Parref:%String,SubID:%String,TypeDesc:%String,Reason:%String,ApplyTxt:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,AppUserDesc:%String,IsVerify:%String,StatusDesc:%String,VerNote:%String,VerDate:%String,VerUserID:%String,VerUserDesc:%String,ApplyDate:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,CPWDesc:%String,PatientID:%String,PaadmID:%String,MobilePhone:%String,UserCode:%String,PathStatus:%String") [ SqlProc ]
{
}

ClassMethod QryApplyInfoExecute(ByRef qHandle As %Binary, aTypeID As %String, aDateFrom As %String, aDateTo As %String, aStatus As %String, aHospID As %String, aLocID As %String, aNotIn As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	
 	Set xTypeID=""
 	For {
 		Set xTypeID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofActDate",xTypeID))
 		Quit:xTypeID=""
 		//Continue:(aTypeID'="")&&(aTypeID'=xTypeID)
 		
 		Set xDate=aDateFrom-1
 		For {		
			Set xDate=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofActDate",xTypeID,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xParref=""
			For {
				Set xParref=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofActDate",xTypeID,xDate,xParref))
				Quit:xParref=""
				
				Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xParref)
				Continue:'$IsObject(objPathway)
				Set EpisodeID=objPathway.CPEpisodeID
				set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
				Continue:'$IsObject(objPat)
				Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
				//过滤门诊，只显示住院数据		
				Continue:objPat.PAAdmType="O"
				Set PatientID=objPat.PAPatientID
				Set PaadmID=$p(EpisodeID,"!!",1)
				Set PapmiNo=objPat.PAPapmiNo
				Set MrNo=objPat.PAMrNo
				Set PatName=objPat.PAPatName
				Set PatSex=objPat.PASex
				Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
				Set PatAge=objPat.PAAge
				Set PathStatus=$Case(objPathway.CPStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请","T":"不入径",:"")
				
				Continue:((aNotIn'="")&&(PathStatus'=""))
				Set xID=""
				For {
					Set xID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofActDate",xTypeID,xDate,xParref,xID))
					Quit:xID=""
					
					Set obj=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(xParref_"||"_xID)
					Continue:'$IsObject(obj)
					Continue:'obj.CPIsActive
					
					Set (TypeDesc,Reason,ApplyTxt,LocID,LocDesc,WardID,WardDesc,AppUserDesc,IsVerify,VerNote,VerDate,VerUserID,VerUserDesc,ApplyDate)=""
					Set LocID=obj.CPLocID
					Set:((LocID="")||(LocID="undefined")) LocID=objPat.PAAdmLocID	//不明原因，申请科室为空
					Continue:(aLocID'="")&&(aLocID'=($p(LocID,"!!",1)))
					
					Set TypeDesc=obj.CPTypeDr.BTDesc
					Set:TypeDesc="未入径原因" TypeDesc="不入径申请"
					Set:TypeDesc="出径原因" TypeDesc="出径申请"
					Set:TypeDesc="作废原因" TypeDesc="作废申请"
					if (aTypeID'=""){
						//入径出径筛选 objAppType 
						Set objAppType=##class(DHCMA.Util.BT.Dictionary).GetObjById(aTypeID)
						Continue:'$IsObject(objAppType)
						Set aTypeDesc=objAppType.BTDesc
						Continue:(aTypeDesc'="")&&(aTypeDesc'=TypeDesc)
					}
					Set Reason=obj.CPReasonDr.BTDesc
					Set ApplyTxt=obj.CPApplyTxt
					
					Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(LocID)
					Set:$IsObject(objLoc) LocDesc=objLoc.BTDesc
					Set xHospID=+$p($g(^CTLOC(($p(LocID,"!!",1)))),"^",22)
	 				Continue:(aHospID'="")&&(aHospID'[xHospID)
	 	
					Set WardID=obj.CPWardID
					Set objWard=##class(DHCMA.Util.EP.Location).GetObjByOID(WardID)
					Set:$IsObject(objWard) WardDesc=objWard.BTDesc
					Set AppUser=obj.CPActUserID
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
					Set IsVerify=obj.CPIsVerify
				
					Set StatusDesc=$Case(IsVerify,"0":"拒绝","1":"同意","":"申请")
					if (aStatus'=""){
						//状态筛选
						Set objAppStatus=##class(DHCMA.Util.BT.Dictionary).GetObjById(aStatus)
						Continue:'$IsObject(objAppStatus)
						Set aStatusDesc=objAppStatus.BTDesc
						Continue:(aStatusDesc'="")&&(aStatusDesc'=StatusDesc)
					}
					Set VerNote=""
					Set:StatusDesc="拒绝" VerNote=obj.CPVerNote
					Set VerDate=obj.CPVerDate
					Set VerDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(VerDate)
					Set VerUserID=obj.CPVerUserID
					Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(VerUserID_"!!"_SYSDr)
					Set:$IsObject(objUser) VerUserDesc=objUser.BTDesc
					Set ApplyDate=xDate
					Set ApplyDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
					
					Set Data=$lb(ind,xParref,xID,TypeDesc,Reason,ApplyTxt,LocID,LocDesc,WardID,WardDesc,AppUserDesc,IsVerify,StatusDesc,VerNote,VerDate,VerUserID,VerUserDesc,ApplyDate,EpisodeID,PapmiNo,MrNo,PatName,PatSex,PatAge,CPWDesc,PatientID,PaadmID,MobilePhone,UserCode,PathStatus)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
 	}
 	
 	Quit $$$OK
}

ClassMethod QryApplyInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryApplyInfoExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryApplyInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryApplyInfoExecute ]
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

/// Creator：     luotiantian
/// CreatDate：   2019-10-10
/// Description:  取临床路径状态及操作信息
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       EpisodeID
/// Return：      "":未入径   不为空:入径
/// w ##class(DHCMA.CPW.CPS.ApplySrv).GetStatusByFormID("200!!1","13")
ClassMethod GetStatusByFormID(aEpisodeID As %String, aFormID As %String = "") As %String
{
	New (aEpisodeID,aFormID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set PathFormID=objPathway.CPFormDr.%Id()
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc
	Set CPWStatus=objPathway.CPStatus
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请",:"")
	Quit:CPWStatus="" return
	Quit:((aFormID'="")&&(PathFormID'=aFormID)) return
	Quit CPWStatus
}

}
