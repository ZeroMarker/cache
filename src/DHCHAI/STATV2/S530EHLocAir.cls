/// 名称: DHCHAI.STATV2.S530EHLocAir
/// 描述: 科室空气消毒效果监测汇总表
/// 编写者：zhugz
/// 编写日期: 2019-11-12
Class DHCHAI.STATV2.S530EHLocAir Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-27
/// Description:  科室空气消毒效果监测汇总表
/// Table：       
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据 
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S530EHLocAir","QryLocAir","","2018-08-13","2021-02-13","")
Query QryLocAir(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Query(ROWSPEC = "xLocID:%String,LocDesc:%String,EvReportCnt:%Integer,PointLocCnt:%Integer,NoPointLocCnt:%Integer,PointLocPassCnt:%Integer,NoPointLocPassCnt:%Integer,PointLocPassRatio:%String,NoPointLocPassRatio:%String,UnPointLocPassCnt:%Integer,UnNoPointLocPassCnt:%Integer,UnPointLocPassRatio:%String,UnNoPointLocPassRatio:%String") [ SqlProc ]
{
}

ClassMethod QryLocAirExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryLocAir"
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
			Set ItemDr		= $li(EvRepData,2)
			Set ItemData	= $g(^DHCHAI.IR.EnviHyItemD(ItemDr))
			Set ItemDesc	= $li(ItemData,2)
			Set ItemTypeDr	= $li(ItemData,14)
			Set ItemTypeData= $g(^DHCHAI.BT.DictionaryD(ItemTypeDr))
			Set ItemTypeDesc= $li(ItemTypeData,3)
			Continue:(ItemTypeDesc'["重点科室空气消毒效果监测")
			Set ( PointLoc,NoPointLoc)=0  //重点科室、非重点科室
			Set:ItemTypeDesc="重点科室空气消毒效果监测" PointLoc=1
			Set:ItemTypeDesc="非重点科室空气消毒效果监测" NoPointLoc=1
			Set SpecimenNum = $li(EvRepData,10)
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
			Set:PointLoc=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"PointLoc"))
			Set:NoPointLoc=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"NoPointLoc"))
			// 合格数量
			if (StandardFlg=1) {
				Set:PointLoc=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"PointLocPass"))
				Set:NoPointLoc=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"NoPointLocPass"))
			}
			// 不合格数量
			if (UnStandardFlg=1) {
				Set:PointLoc=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"UnPointLocPass"))
				Set:NoPointLoc=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"UnNoPointLocPass"))
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
			
		Set EvReportCnt  		=+$g(^TMP($zn,$j,NIndex,xLocID,"EvReportCnt"))  		//监测数量
		Set PointLocCnt  		=+$g(^TMP($zn,$j,NIndex,xLocID,"PointLoc"))  			//重点科室空气消毒效果监测数量
		Set NoPointLocCnt  		=+$g(^TMP($zn,$j,NIndex,xLocID,"NoPointLoc"))  			//非重点科室空气消毒效果监测数量
		Set PointLocPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"PointLocPass"))  		//重点科室空气消毒效果监测合格数量
		Set NoPointLocPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"NoPointLocPass"))  		//非重点科室空气消毒效果监测合格数量
		Set UnPointLocPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"UnPointLocPass"))  		//重点科室空气消毒效果监测不合格数量
		Set UnNoPointLocPassCnt =+$g(^TMP($zn,$j,NIndex,xLocID,"UnNoPointLocPass"))  	//非重点科室空气消毒效果监测不合格数量
		
		Set (PointLocPassRatio,NoPointLocPassRatio,UnPointLocPassRatio,UnNoPointLocPassRatio)="0.00%"
		Set:PointLocCnt>0 PointLocPassRatio=$fn((PointLocPassCnt/PointLocCnt)*100,"",2)_"%"	//合格率
		Set:NoPointLocCnt>0 NoPointLocPassRatio=$fn((NoPointLocPassCnt/NoPointLocCnt)*100,"",2)_"%"	
		Set:UnPointLocPassCnt>0 UnPointLocPassRatio=$fn((UnPointLocPassCnt/PointLocCnt)*100,"",2)_"%"	//合格率
		Set:UnNoPointLocPassCnt>0 UnNoPointLocPassRatio=$fn((UnNoPointLocPassCnt/NoPointLocCnt)*100,"",2)_"%"	
		Continue:(EvReportCnt=0)
		Set Data=$lb(xLocID,LocDesc,EvReportCnt,PointLocCnt,NoPointLocCnt,PointLocPassCnt,NoPointLocPassCnt,PointLocPassRatio,NoPointLocPassRatio,UnPointLocPassCnt,UnNoPointLocPassCnt,UnPointLocPassRatio,UnNoPointLocPassRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Kill ^TMP($zn,$j,NIndex)  
	Quit $$$OK
}

ClassMethod QryLocAirClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocAirExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocAirFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocAirExecute ]
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
/// CreatDate：   2019-11-27
/// Description:  科室空气消毒效果监测明细表
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aDimensKey：统计维度 
/// 			  aStandard ：合格、""(全部),不合格
/// 			  aItemTypeDesc:项目分类（重点科室空气消毒效果监测、非重点科室空气消毒效果监测）
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S530EHLocAir","QryLocAirDtl","2018-08-13","2021-2-13","")
Query QryLocAirDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String, aStandard As %String = "", aItemTypeDesc As %String = "") As %Query(ROWSPEC = "EvRepID:%String,ItemDesc:%String,LocDesc:%String,StatusDesc:%String,ItemObjDesc:%String,MonitorDate:%String,SpecTypeDesc:%String,SpecimenNum:%String,APUserName:%String,Standard:%String") [ SqlProc ]
{
}

ClassMethod QryLocAirDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String, aStandard As %String = "", aItemTypeDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set:aHospIDs="0" aHospIDs=""
	
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
			Set ItemDr		= $li(EvRepData,2)
			Set ItemData	= $g(^DHCHAI.IR.EnviHyItemD(ItemDr))
			Set ItemDesc	= $li(ItemData,2)
			Set ItemTypeDr	= $li(ItemData,14)
			Set ItemTypeData= $g(^DHCHAI.BT.DictionaryD(ItemTypeDr))
			Set ItemTypeDesc= $li(ItemTypeData,3)
			Continue:(ItemTypeDesc'["重点科室空气消毒效果监测")
			Continue:(aItemTypeDesc'="")&&(aItemTypeDesc'=ItemTypeDesc)
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
			
			Set ItemObjDr	= $li(EvRepData,3)
			Set ItemObjTxt	= $li(EvRepData,26)
			Set ItemObjData=""
			Set:ItemObjDr'="" ItemObjData= $g(^DHCHAI.IR.EnviHyObjectD(ItemObjDr))
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

ClassMethod QryLocAirDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocAirDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocAirDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocAirDtlExecute ]
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
