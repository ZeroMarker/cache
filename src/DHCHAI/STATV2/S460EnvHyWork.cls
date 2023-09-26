/// 名称: DHCHAI.STATV2.S460EnvHyWork
/// 描述: 环境卫生学监测工作量统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S460EnvHyWork Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-26
/// Description:  环境卫生学监测工作量(主表)
/// Table：       DHCHAI.IR.EnviHyReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aMonitorLocID : 监测科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S460EnvHyWork","QryEnvHyWork","1|3|4","2022-08-01","2022-08-09","")
Query QryEnvHyWork(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,EvReportCnt:%Integer,SpecimenCnt:%Integer,AEvReportCnt:%Integer,ASpecimenCnt:%Integer,TEvReportCnt:%Integer,TSpecimenCnt:%Integer,HEvReportCnt:%Integer,HSpecimenCnt:%Integer,OEvReportCnt:%Integer,OSpecimenCnt:%Integer,XEvReportCnt:%Integer,XSpecimenCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryEnvHyWorkExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryEnvHyWork"
	Kill ^TMP($zn,$j,NIndex)
 	
 	For xMonitorDate = aDateFrom:1:aDateTo{
	 	Set xEvRepID = ""
	 	For {
			Set xEvRepID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xMonitorDate,xEvRepID))
			Quit:xEvRepID="" 
			Set EvRepData = $g(^DHCHAI.IR.EnviHyReportD(xEvRepID))
			Continue:EvRepData=""
			Set StatusDr = $li(EvRepData,4)
			Continue:StatusDr=""
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusDr))
			Continue:$li(StatusData,2)=0 // 删除状态过滤
			Set SpecimenNum = $li(EvRepData,10)
			Set EHItemDr = $li(EvRepData,3)
			Continue:EHItemDr=""
			Set ItemData = $g(^DHCHAI.IR.EnviHyObjectD(EHItemDr))
			Set ItemTypeDr = $li(ItemData,3)
			Continue:ItemTypeDr=""
			Set ItemTypeData=$g(^DHCHAI.BT.DictionaryD(ItemTypeDr))
			Set ItemType= $li(ItemTypeData,3)
			Set:(ItemType'="空气")&(ItemType'="物表")&(ItemType'="手")&(ItemType'="新冠标本") ItemType="其他"
			//监测科室EHMonitorLocDr
			Set LocDr = $li(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(aMonitorLocID'=LocDr)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $li(LocData,3)
			Set HospDr	= $Li(LocData,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)	// 院区过滤
			Set ApplyUser = $li(EvRepData,9)
			Continue:ApplyUser=""
			// 监测数量
			Set num=$i(^TMP($zn,$j,NIndex,LocDr,"EvReportCnt"))
			// 标本数量
			Set SpecimenCnt=$g(^TMP($zn,$j,NIndex,LocDr,"SpecimenCnt"))
			Set ^TMP($zn,$j,NIndex,LocDr,"SpecimenCnt")=SpecimenCnt+SpecimenNum
				
			// 分类监测数量
			Set num=$i(^TMP($zn,$j,NIndex,LocDr,"SpecimenType",ItemType,"EvReportCnt"))
			// 分类标本数量
			Set SpecimenTypeCnt=$g(^TMP($zn,$j,NIndex,LocDr,"SpecimenType",ItemType,"SpecimenCnt"))
			Set ^TMP($zn,$j,NIndex,LocDr,"SpecimenType",ItemType,"SpecimenCnt")=SpecimenTypeCnt+SpecimenNum
	 	}
	}

	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
	
		Set LocData	= $g(^DHCHAI.BT.LocationD(xLocID))
		Set LocDesc = $li(LocData,3)
			
		Set EvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"EvReportCnt"))  		//监测数量
		Set SpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenCnt"))  		//标本数量
		Continue:(EvReportCnt=0)
		
		//空气、物表、手、其他 监测数量、标本数量
		Set (AEvReportCnt,ASpecimenCnt,TEvReportCnt,TSpecimenCnt,HEvReportCnt,HSpecimenCnt,OEvReportCnt,OSpecimenCnt,XEvReportCnt,XSpecimenCnt)=""  
		Set AEvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","空气","EvReportCnt"))  		//监测数量
		Set ASpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","空气","SpecimenCnt"))  		//标本数量			
        Set TEvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","物表","EvReportCnt"))  		//监测数量
		Set TSpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","物表","SpecimenCnt"))  		//标本数量			

		Set HEvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","手","EvReportCnt"))  		    //监测数量
		Set HSpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","手","SpecimenCnt"))  		  //标本数量			
		Set OEvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","其他","EvReportCnt"))  		//监测数量
		Set OSpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","其他","SpecimenCnt"))  		//标本数量			
		Set XEvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","新冠标本","EvReportCnt"))  	//监测数量
		Set XSpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenType","新冠标本","SpecimenCnt"))  	//标本数量		
		Set Data=$lb(xLocID,LocDesc,EvReportCnt,SpecimenCnt,AEvReportCnt,ASpecimenCnt,TEvReportCnt,TSpecimenCnt,HEvReportCnt,HSpecimenCnt,OEvReportCnt,OSpecimenCnt,XEvReportCnt,XSpecimenCnt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1

	}	
	Kill ^TMP($zn,$j,NIndex)  
	Quit $$$OK
}

ClassMethod QryEnvHyWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvHyWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnvHyWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvHyWorkExecute ]
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

/// Creator：     zhugz
/// CreatDate：   2019-11-26
/// Description:  环境卫生学明细表
/// Table：       DHCHAI.IR.EnviHyReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aMonitorLocID : 监测科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S460EnvHyWork","QryEnvHyWorkDtl","","2020-08-13","2021-01-13","")
Query QryEnvHyWorkDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Query(ROWSPEC = "EvRepID:%String,ItemDesc:%String,LocDesc:%String,StatusDesc:%String,ItemObjDesc:%String,MonitorDate:%String,SpecTypeDesc:%String,SpecimenNum:%String,APUserName:%String,Standard:%String") [ SqlProc ]
{
}

ClassMethod QryEnvHyWorkDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Status
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
			
			Set EvRepData = $g(^DHCHAI.IR.EnviHyReportD(xEvRepID))
			Continue:EvRepData=""
			Set StatusDr = $li(EvRepData,4)
			Continue:StatusDr=""
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusDr))
			Continue:$li(StatusData,2)=0 // 删除状态过滤
			//监测科室EHMonitorLocDr
			Set LocDr = $li(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(LocDr'=aMonitorLocID)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $li(LocData,3)
			Set HospDr	= $Li(LocData,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)	// 院区过滤
						
			Set StatusDesc	= $li(StatusData,3)
			Set SpecimenNum = $li(EvRepData,10) //标本数量
			Set MonitorDate = $li(EvRepData,5) 	//监测日期
			Set:MonitorDate'="" MonitorDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
			Set ItemDr		= $li(EvRepData,2)
			Continue:ItemDr=""
			Set ItemObjDr	= $li(EvRepData,3)
			Continue:ItemObjDr=""
			Set ItemObjTxt	= $li(EvRepData,26)
			Set ItemData	= $g(^DHCHAI.IR.EnviHyItemD(ItemDr))
			Set ItemDesc	= $li(ItemData,2)
			Set ItemObjData=""
			Set:ItemObjDr'="" ItemObjData	= $g(^DHCHAI.IR.EnviHyObjectD(ItemObjDr))
			Set ItemObjDesc="",SpecTypeDr="",SpecTypeDesc=""
			Set:ItemObjData'="" ItemObjDesc=$li(ItemObjData,2)
			Set:ItemObjData'="" SpecTypeDr=$li(ItemObjData,3)
			if (SpecTypeDr'="") {
					Set SpecTypeDicData=$g(^DHCHAI.BT.DictionaryD(SpecTypeDr))
					Set SpecTypeDesc=$li(SpecTypeDicData,3)
				}
			Set:ItemObjTxt'="" ItemObjDesc=ItemObjDesc_"["_ItemObjTxt_"]"
			Set ApplyUser	= $li(EvRepData,9)
			Continue:ApplyUser=""
			Set ApplyUserData= $g(^DHCHAI.BT.SysUserD(ApplyUser))
			Set APUserName	= $li(ApplyUserData,3)
			Set StandardDr	= $li(EvRepData,15)
			Set Standard="未录入"
			Set:StandardDr'="" Standard	= $li($g(^DHCHAI.BT.DictionaryD(StandardDr)),3)
			Set Data=$lb(xEvRepID,ItemDesc,LocDesc,StatusDesc,ItemObjDesc,MonitorDate,SpecTypeDesc,SpecimenNum,APUserName,Standard)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}	  
	Quit $$$OK
}

ClassMethod QryEnvHyWorkDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvHyWorkDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnvHyWorkDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvHyWorkDtlExecute ]
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
