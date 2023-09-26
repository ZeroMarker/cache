/// 名称: DHCHAI.STAT.S520EHObjSur
/// 描述: 物体表面消毒效果监测汇总表
/// 编写者：liyi
/// 编写日期: 2018-06-28
Class DHCHAI.STAT.S520EHObjSur Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2018-06-28
/// Description:  物体表面消毒效果监测汇总表
/// Table：       
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAT.S520EHObjSur","QryEHObjSur","","2018-08-13","2019-08-13","","8","合格","外科手消毒效果监测")
Query QryEHObjSur(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocTypeID As %String = "", aApplyLocID As %String = "", aStandardDesc As %String = "", aItemTypeDesc As %String = "") As %Query(ROWSPEC = "EvRepID:%String,LocTypeID:%String,LocTypeDesc:%String,Item:%String,SpecimenType:%String,ItemObj:%String,RepStatus:%String,MonitorDate:%String,ApplyDate:%String,ApplyTime:%String,ApplyLocID:%String,ApplyLoc:%String,ApplyUser:%String,SpecimenNum:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLoc:%String,RepUser:%String,StandardID:%String,Standard:%String,Resume:%String,ItemTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryEHObjSurExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocTypeID As %String = "", aApplyLocID As %String = "", aStandardDesc As %String = "", aItemTypeDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK

 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	
 	For xMonitorDate = aDateFrom:1:aDateTo{
	 	Set xEvRepID = ""
	 	For {
			Set xEvRepID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xMonitorDate,xEvRepID))
			Quit:xEvRepID="" 
			
			Set objEvRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xEvRepID)
			Continue:'$IsObject(objEvRep)
			
			Set objApplyLoc = objEvRep.EHApplyLocDr
			Continue:'$IsObject(objApplyLoc)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,objApplyLoc.BTHospDr.%Id())<1)	// 院区过滤
			
			Set LocDesc2 = objApplyLoc.BTDesc2
			Set LocDesc = objApplyLoc.BTDesc
			Set ApplyLocID = objApplyLoc.%Id()
			Set ApplyLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			Continue:(aApplyLocID'="")&&(aApplyLocID'=ApplyLocID)
			
			If ($IsObject(objApplyLoc.BTGroupDr)){
				Set LocTypeDesc = objApplyLoc.BTGroupDr.BTDesc  // 科室分类
				Set LocTypeID = objApplyLoc.BTGroupDr.%Id()
			}Else {
				Set LocTypeDesc="其他科"
				Set LocTypeID = "-1"
			}
			Continue:(aLocTypeID'="")&&(aLocTypeID'=LocTypeID)
			
			Set objStatus = objEvRep.EHRepStatus
			Continue:'$IsObject(objStatus)
			Continue:objStatus.BTCode=0 // 删除状态过滤
			Set RepStatus =objStatus.BTDesc
			 
			Set objItem = objEvRep.EHItemDr
			Continue:'$IsObject(objItem)
			Continue:'$IsObject(objItem.EHItemTypeDr)
		
			Continue:(objItem.EHItemTypeDr.BTDesc'="重点科室物体表面洁净度监测")&&(objItem.EHItemTypeDr.BTDesc'="非重点科室物体表面洁净度监测")
		
			Continue:(aItemTypeDesc'="")&&(aItemTypeDesc'=objItem.EHItemTypeDr.BTDesc)
			Set ItemTypeDesc=objItem.EHItemTypeDr.BTDesc
			
			Set Item = objItem.EHItemDesc
			Set SpecimenType=""
			If $IsObject(objEvRep.EHItemDr.EHSpecimenTypeDr){
				Set SpecimenType = objEvRep.EHItemDr.EHSpecimenTypeDr.BTDesc
			}
			
			Set ItemObj = ""
			Set objItemObj = objEvRep.EHItemObjDr
			If $IsObject(objItemObj){
				Set ItemObj = objItemObj.EHObjDesc
			}
			Set MonitorDate = objEvRep.EHMonitorDate
			Set:MonitorDate'="" MonitorDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
			Set ApplyDate = objEvRep.EHApplyDate
			Set:ApplyDate'="" ApplyDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
			Set ApplyTime = objEvRep.EHApplyTime
			Set:ApplyTime'="" ApplyTime=$zt(ApplyTime)
			Set objApplyUser = objEvRep.EHApplyUserDr
			Set ApplyUser = ""
			If $IsObject(objApplyUser){
				Set ApplyUser = objApplyUser.BTDesc
			}
			Set RepDate = objEvRep.EHRepDate
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set RepTime = objEvRep.EHRepTime
			Set:RepTime'="" RepTime=$zt(RepTime)
			Set objRepLoc = objEvRep.EHRepLocDr
			Set RepLoc = "",RepLocID=""
			If $IsObject(objRepLoc){
				Set RepLoc = objRepLoc.BTDesc
				Set RepLocID = objRepLoc.%Id()
			}
			Set objRepUser = objEvRep.EHRepUserDr
			Set RepUser = ""
			If $IsObject(objRepUser){
				Set RepUser = objRepUser.BTDesc
			}
			Set objStandard = objEvRep.EHStandard
			Set Standard = "",StandardID=""
			If $IsObject(objStandard){
				Set Standard = objStandard.BTDesc
				Set StandardID = objStandard.%Id()
			}
			Continue:(aStandardDesc'="")&&(aStandardDesc'=Standard)
			
			Set SpecimenNum = objEvRep.EHSpecimenNum
			Set objResume = objEvRep.EHResume
			Set Data=$lb(xEvRepID,LocTypeID,LocTypeDesc,Item,SpecimenType,ItemObj,RepStatus,MonitorDate,ApplyDate,ApplyTime,ApplyLocID,ApplyLoc,ApplyUser,SpecimenNum,RepDate,RepTime,RepLocID,RepLoc,RepUser,StandardID,Standard,Resume,ItemTypeDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryEHObjSurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEHObjSurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEHObjSurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEHObjSurExecute ]
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
