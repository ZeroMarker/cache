/// 查询临床路径变异情况
Class web.DHCCPW.MR.CtrVarianceQry Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyang
/// CreatDate：   2011-02-14
/// Description:  通过StepID查询临床路径患者的变异记录
/// Input：       PathWayID(出入径记录ID),StepRowID(路径步骤ID)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.CtrVarianceQry","QueryByStepID","2","")
Query QueryByStepID(argPathWayID As %String, argStepRowID As %String) As %Query(ROWSPEC = "ID:%String,CPWVDate:%String:保存日期,CPWVTime:%String:保存时间,CPWVCategory:%String:变异类型,CPWVReason:%String:变异原因,CPWVEpisode:%String:对应阶段,CPWVEpStep:%String:步骤,CPWVNote:%String:备注,CPWVUser:%String:保存医生")
{
}

ClassMethod QueryByStepIDExecute(ByRef qHandle As %Binary, argPathWayID As %String, argStepRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)	
	
	//^DHCMR("CPW",{ClinPathWays.ID},"VAR",{ChildSub})
	Quit:argPathWayID="" $$$OK
	Quit:'$d(^DHCMR("CPW",argPathWayID,"VAR")) $$$OK
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) $$$OK
	
	Set ChildSub=""
	For {
		Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub),-1)
		Quit:ChildSub=""
		Set CPWVID=argPathWayID_"||"_ChildSub
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
		If $IsObject(objVariance){
			
			If $IsObject(objVariance.CPWVEpisodeDR){
				Set CPWVEpisodeDR=objVariance.CPWVEpisodeDR.%Id()
				Set CPWVEpisodeDesc=objVariance.CPWVEpisodeDR.EPDesc
			}
			If $IsObject(objVariance.CPWVEpStepDR){
				Set CPWVEpStepDR=objVariance.CPWVEpStepDR.%Id()
				Continue:(argStepRowID'="")&&(argStepRowID'=CPWVEpStepDR)
				Set CPWVEpStepDesc=objVariance.CPWVEpStepDR.CPWSDesc
			}
			If $IsObject(objVariance.CPWVCategoryDR)
			{
				Set CPWVCategoryDR=objVariance.CPWVCategoryDR.%Id()
				Set CPWVCategoryDesc=objVariance.CPWVCategoryDR.VCDesc
			}
			
			If $IsObject(objVariance.CPWVReasonDR)
			{
				Set CPWVReasonDR=objVariance.CPWVReasonDR.%Id()
				Set CPWVReasonDesc=objVariance.CPWVReasonDR.VRDesc
			}
			
			Set CPWVUserDR=objVariance.CPWVUserDR
			Set CPWVUserDesc=$p($g(^SSU("SSUSR",+CPWVUserDR)),"^",2)
			
			Set CPWVDate=objVariance.CPWVDate
			Set CPWVTime=objVariance.CPWVTime
			Set CPWVNote=objVariance.CPWVNote
			Set CPWVDate=$zd(+CPWVDate,3)
			Set CPWVTime=$zt(+CPWVTime,2)
			
			Set CPWVDoctorDR=objVariance.CPWVDoctorDR
			Set CPWVDoctorDesc=$p($g(^CTPCP(+CPWVDoctorDR,1)),"^",2)
			
			Set Data=$lb(CPWVID,CPWVDate,CPWVTime,CPWVCategoryDesc,CPWVReasonDesc,CPWVEpisodeDesc,CPWVEpStepDesc,CPWVNote,CPWVDoctorDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryByStepIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByStepIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByStepIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByStepIDExecute ]
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
