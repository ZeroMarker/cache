/// 名称: 		DHCMA.CPW.BTS.ApplyExamRecDtlSrv
/// 描述: 		表单发布审核回复明细服务类
/// 编写者：	yankai
/// 编写日期: 	2021-12-27
Class DHCMA.CPW.BTS.ApplyExamRecDtlSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-12-27
/// Description:  获取审核明细当前角色^审核结果^审核意见
/// Table：       DHCMA.CPW.BT.ApplyExamRecDtl
/// Input：       ApplyExamRecDtlID
/// Return：      
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecDtlSrv).GetRoleName("3||3")  
ClassMethod GetRoleName(aRecDtlID As %String) As %String
{
	New (aRecDtlID)
	Set return=""
	Quit:aRecDtlID="" return
	
	Set objRecDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(aRecDtlID)
	Quit:'$IsObject(objRecDtl) return
	Quit:'$IsObject(objRecDtl.BTExamRoleDr)
	Set RoleName=objRecDtl.BTExamRoleDr.BTDesc
	Set ExamResult=objRecDtl.BTExamResult
	Set ExamOpinion=objRecDtl.BTExamOpinion
	
	Set return=RoleName_"^"_ExamResult_"^"_ExamOpinion
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-05-25
/// Description:  查询指定角色下各状态发布审核的记录
/// Table：       DHCMA.CPW.BT.ApplyExamRec,DHCMA.CPW.BT.ApplyExamRecDtl
/// Input：       aRoleIDStr:"^"多角色拼接
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.ApplyExamRecDtlSrv","QryPubExamRec","4","-1","2!!1","","","")
Query QryPubExamRec(aRoleIDStr As %String, aStatus As %String, aHospID As %String, aDateFrom As %String = "", aDateTo As %String = "", aApplyLoc As %String = "") As %Query(ROWSPEC = "ind:%String,xFormID:%String,PathDesc:%String,FormVerNo:%String,aRoleID:%String,RoleName:%String,RolePrior:%String,xRecID:%String,xRecDtlID:%String,ApplyLoc:%String,ApplyUser:%String,ApplyDateTime:%String,ExamResult:%String,ExamOpinion:%String,ExamUser:%String,ExamDateTime:%String")
{
}

ClassMethod QryPubExamRecExecute(ByRef qHandle As %Binary, aRoleIDStr As %String, aStatus As %String, aHospID As %String, aDateFrom As %String = "", aDateTo As %String = "", aApplyLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Set ^TEMPYK("QryPubExamRec")=$lb(aRoleIDStr,aStatus,aDateFrom,aDateTo,aHospID,aApplyLoc)
 	Quit:(aRoleIDStr="")||(aStatus="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom'="")&&(aDateTo'="")&&(aDateFrom>aDateTo) $$$OK
 	
 	For idx=1:1:$l(aRoleIDStr,","){
		Set aRoleID=$p(aRoleIDStr,",",idx)
		
		Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(aRoleID)
 		Continue:'$IsObject(objRole)
		Set RoleName=objRole.BTDesc
		Set RolePrior=objRole.BTPriority
		
 		Set xFormID=""
 		For {
		 	Set xFormID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",xFormID))
		 	Quit:xFormID=""
		 	
			//取该角色基于当前表单的最新申请记录即可
			Set xRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",xFormID,aRoleID,""),-1)
			Continue:xRecID=""
			
			Set objRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(xRecID)
			Continue:'$IsObject(objRec)
			Continue:+objRec.BTApplyHosp'=+aHospID
			Continue:(aDateFrom'="")&&(aDateFrom>objRec.BTApplyDate)
			Continue:(aDateTo'="")&&(aDateTo<objRec.BTApplyDate)
			Continue:(aApplyLoc'="")&&(aApplyLoc'=objRec.BTApplyLoc)
			
			//最新申请下该角色的记录
			Set xSubDtlID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",xFormID,aRoleID,xRecID,""),-1)
			Set xRecDtlID=xRecID_"||"_xSubDtlID
			Set objRecDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(xRecDtlID)
			Continue:'$IsObject(objRecDtl)
			Continue:(aStatus'="")&&(aStatus'=objRecDtl.BTExamResult)
		
			Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(xFormID)
			Continue:'$IsObject(objForm)
			Continue:'$IsObject(objForm.FormPathDr)
			Continue:objForm.FormIsActive'=1													//作废版本无需处理
			Set PathDesc=objForm.FormPathDr.BTDesc												//路径名称
			Set FormVerNo="V"_$fn(objForm.FormVersion,"",1)										//版本
			Set ApplyLoc=objRec.BTApplyLoc
			Set objApplyLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(ApplyLoc)
			Set:$IsObject(objApplyLoc) ApplyLoc=objApplyLoc.BTDesc								//申请科室
			Set ApplyUser=objRec.BTApplyUser
			Set objApplyUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ApplyUser)
			Set:$IsObject(objApplyUser) ApplyUser=objApplyUser.BTDesc							//申请人
			Set ApplyDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objRec.BTApplyDate)	//申请日期
			Set ApplyTime=$zt(objRec.BTApplyTime,1)
			Set ApplyDateTime=ApplyDate_" "_ApplyTime
			Set ExamResult=objRecDtl.BTExamResult
			Set ExamOpinion=objRecDtl.BTExamOpinion												//审核意见
			Set ExamUser=objRecDtl.BTExamUser													//审核人
			Set objExamUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ExamUser)
			Set:$IsObject(objExamUser) ExamUser=objExamUser.BTDesc	
			Set (ExamDate,ExamTime,ExamDateTime)=""
			If objRecDtl.BTExamResult'=-1{
				Set ExamDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objRecDtl.BTExamDate)	//审核日期
				Set ExamTime=$zt(objRecDtl.BTExamTime,1)
				Set ExamDateTime=ExamDate_" "_ExamTime
			}
			
			Set Data=$lb(ind,xFormID,PathDesc,FormVerNo,aRoleID,RoleName,RolePrior,xRecID,xRecDtlID,ApplyLoc,ApplyUser,ApplyDateTime,ExamResult,ExamOpinion,ExamUser,ExamDateTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		
 		}		
	}
 	
	Quit $$$OK
}

ClassMethod QryPubExamRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPubExamRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPubExamRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPubExamRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
