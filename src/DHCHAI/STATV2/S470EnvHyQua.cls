/// 名称: DHCHAI.STATV2.S470EnvHyQua
/// 描述: 环境卫生学监测合格率统计表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S470EnvHyQua Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-26
/// Description:  环境卫生学监测合格率
/// Table：       
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aMonitorLocID : 监测科室
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S470EnvHyQua","QryEnvHyQua","","2019-08-13","2019-12-13","")
Query QryEnvHyQua(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Query(ROWSPEC = "xLocID:%String,LocDesc:%String,EvReportCnt:%Integer,StandardCnt:%Integer,StandardRatio:%String,UnStandardCnt:%Integer,UnStandardRatio:%String") [ SqlProc ]
{
}

ClassMethod QryEnvHyQuaExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryEnvHyQua"
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
			Set StatusDesc	= $li(StatusData,3)
			Continue:StatusDesc'["结果"   //非审核结果、录入结果的 不参与统计
			Set SpecimenNum = $li(EvRepData,10)
			Set ItemDr		= $li(EvRepData,2)
			Continue:ItemDr=""
			//监测科室EHMonitorLocDr
			Set LocDr = $li(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(aMonitorLocID'=LocDr)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $li(LocData,3)
			Set HospDr	= $Li(LocData,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)	// 院区过滤
			
			Set StandardFlg=0,Standard="",UnStandardFlg=""
			Set StandardDr	= $li(EvRepData,15)
			Set:StandardDr'="" Standard	= $li($g(^DHCHAI.BT.DictionaryD(StandardDr)),2)
			Set:Standard=1 StandardFlg=1
			Set:Standard=0 UnStandardFlg=1
			
			// 监测数量
			Set num=$i(^TMP($zn,$j,NIndex,LocDr,"EvReportCnt"))
			// 合格数量
			if (StandardFlg=1) {
				Set num=$i(^TMP($zn,$j,NIndex,LocDr,"StandardCnt"))
			}
			if (UnStandardFlg=1) {
				Set num=$i(^TMP($zn,$j,NIndex,LocDr,"UnStandardCnt"))
			}
		}
	}
	// 输出Data
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
	
		Set LocData	= $g(^DHCHAI.BT.LocationD(xLocID))
		Set LocDesc = $li(LocData,3)
			
		Set EvReportCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"EvReportCnt"))  		//监测数量
		Set SpecimenCnt  =+$g(^TMP($zn,$j,NIndex,xLocID,"SpecimenCnt"))  		//标本数量
		Continue:(EvReportCnt=0)
		
		Set EvReportCnt  		=+$g(^TMP($zn,$j,NIndex,xLocID,"EvReportCnt"))  		//监测数量
		Set StandardCnt  		=+$g(^TMP($zn,$j,NIndex,xLocID,"StandardCnt"))  		//合格数量
		Set StandardRatio="0.00%"
		Set:EvReportCnt>0 StandardRatio=$fn((StandardCnt/EvReportCnt)*100,"",2)_"%"			//合格率
		Continue:(EvReportCnt=0)
		Set UnStandardCnt  		=+$g(^TMP($zn,$j,NIndex,xLocID,"UnStandardCnt"))  		//不合格数量
		Set UnStandardRatio="0.00%"
		Set:EvReportCnt>0 UnStandardRatio=$fn((UnStandardCnt/EvReportCnt)*100,"",2)_"%"			//不合格率
		
		Set Data=$lb(xLocID,LocDesc,EvReportCnt,StandardCnt,StandardRatio,UnStandardCnt,UnStandardRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Kill ^TMP($zn,$j,NIndex)  
	Quit $$$OK
}

ClassMethod QryEnvHyQuaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvHyQuaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnvHyQuaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvHyQuaExecute ]
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
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aMonitorLocID : 监测科室
/// 			  aStandard ：合格、""(全部),不合格
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S470EnvHyQua","QryEnvHyQuaDtl","","2018-05-09","2021-05-09","","")
Query QryEnvHyQuaDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String, aStandard As %String = "") As %Query(ROWSPEC = "EvRepID:%String,ItemDesc:%String,LocDesc:%String,StatusDesc:%String,ItemObjDesc:%String,MonitorDate:%String,SpecTypeDesc:%String,SpecimenNum:%String,APUserName:%String,Standard:%String") [ SqlProc ]
{
}

ClassMethod QryEnvHyQuaDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String, aStandard As %String = "") As %Status
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
			Set StatusDesc	= $li(StatusData,3)
			Continue:StatusDesc'["结果"   //非审核结果、录入结果的 不参与统计
			//监测科室EHMonitorLocDr
			Set LocDr = $li(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(aMonitorLocID'=LocDr)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $li(LocData,3)
			Set HospDr	= $Li(LocData,8)
			
			Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)	// 院区过滤
			
			Set SpecimenNum = $li(EvRepData,10) //标本数量
			Set MonitorDate = $li(EvRepData,5) 	//监测日期
			Set:MonitorDate'="" MonitorDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
			Set ItemDr		= $li(EvRepData,2)
			Continue:ItemDr=""
			Set ItemObjDr	= $li(EvRepData,3)
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
			Set Standard="未录入",StandardCode=""
			Set:StandardDr'="" Standard	= $li($g(^DHCHAI.BT.DictionaryD(StandardDr)),3)
			Set:StandardDr'="" StandardCode	= $li($g(^DHCHAI.BT.DictionaryD(StandardDr)),2)
			Continue:(aStandard'="")&(aStandard'=StandardCode)
			Set Data=$lb(xEvRepID,ItemDesc,LocDesc,StatusDesc,ItemObjDesc,MonitorDate,SpecTypeDesc,SpecimenNum,APUserName,Standard)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}	  
	Quit $$$OK
}

ClassMethod QryEnvHyQuaDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvHyQuaDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnvHyQuaDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvHyQuaDtlExecute ]
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
