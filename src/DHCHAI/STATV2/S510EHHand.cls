/// 名称: DHCHAI.STATV2.S510EHHand
/// 描述: 医护人员手消毒效果监测汇总表
/// 编写者：zhugz
/// 编写日期: 2019-11-11
Class DHCHAI.STATV2.S510EHHand Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-27
/// Description:  医护人员手消毒效果监测汇总表
/// Table：       
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aLocType : 统计类型-科室/病区
/// 			  aQryCon  ：是否筛选有效数据 
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S510EHHand","QryEHHand","","2019-08-13","2021-2-13","")
Query QryEHHand(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Query(ROWSPEC = "xLocID:%String,LocDesc:%String,EvReportCnt:%Integer,SurgeryHandCnt:%Integer,HygienicHandCnt:%Integer,SurgeryHandPassCnt:%Integer,HygienicHandPassCnt:%Integer,SurgeryPassRatio:%String,HygienicPassRatio:%String,UnSurgeryHandPassCnt:%Integer,UnHygienicHandPassCnt:%Integer,UnSurgeryPassRatio:%String,UnHygienicPassRatio:%String") [ SqlProc ]
{
}

ClassMethod QryEHHandExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryEHHand"
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
			Continue:(ItemTypeDesc'["外科手")&&(ItemTypeDesc'["卫生手")
			Set (SurgeryHand,HygienicHand)=0  //外科手、卫生手
			Set:ItemTypeDesc["外科手" SurgeryHand=1
			Set:ItemTypeDesc["卫生手" HygienicHand=1
			Set SpecimenNum = $li(EvRepData,10)
			//监测科室EHMonitorLocDr
			Set LocDr = $li(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(LocDr'=aMonitorLocID)
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
			Set:SurgeryHand=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"SurgeryHand"))
			Set:HygienicHand=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"HygienicHand"))
			// 合格数量
			if (StandardFlg=1) {
				Set:SurgeryHand=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"SurgeryHandPass"))
				Set:HygienicHand=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"HygienicHandPass"))
			}
			// 不合格数量
			if (UnStandardFlg=1) {
				Set:SurgeryHand=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"UnSurgeryHandPass"))
				Set:HygienicHand=1 num=$i(^TMP($zn,$j,NIndex,LocDr,"UnHygienicHandPass"))
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
		Set SurgeryHandCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"SurgeryHand"))  		//外科手监测数量
		Set HygienicHandCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"HygienicHand"))  		//卫生手监测数量
		Set SurgeryHandPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"SurgeryHandPass"))  		//外科手合格数量
		Set HygienicHandPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"HygienicHandPass"))  		//卫生手合格数量
		Set UnSurgeryHandPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"UnSurgeryHandPass"))  		//外科手不合格数量
		Set UnHygienicHandPassCnt  	=+$g(^TMP($zn,$j,NIndex,xLocID,"UnHygienicHandPass"))  		//卫生手不合格数量
		Set (SurgeryPassRatio,HygienicPassRatio,UnSurgeryPassRatio,UnHygienicPassRatio)="0.00%"
		Set:SurgeryHandCnt>0 SurgeryPassRatio=$fn((SurgeryHandPassCnt/SurgeryHandCnt)*100,"",2)_"%"			//合格率
		Set:HygienicHandCnt>0 HygienicPassRatio=$fn((HygienicHandPassCnt/HygienicHandCnt)*100,"",2)_"%"	
		Set:UnSurgeryHandPassCnt>0 UnSurgeryPassRatio=$fn((UnSurgeryHandPassCnt/SurgeryHandCnt)*100,"",2)_"%"			//合格率
		Set:UnHygienicHandPassCnt>0 UnHygienicPassRatio=$fn((UnHygienicHandPassCnt/HygienicHandCnt)*100,"",2)_"%"	
		Continue:(EvReportCnt=0)
		Set Data=$lb(xLocID,LocDesc,EvReportCnt,SurgeryHandCnt,HygienicHandCnt,SurgeryHandPassCnt,HygienicHandPassCnt,SurgeryPassRatio,HygienicPassRatio,UnSurgeryHandPassCnt,UnHygienicHandPassCnt,UnSurgeryPassRatio,UnHygienicPassRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Kill ^TMP($zn,$j,NIndex)  
	Quit $$$OK
}

ClassMethod QryEHHandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEHHandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEHHandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEHHandExecute ]
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
/// Description:  医护人员手消毒效果监测明细表
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// 			  aDimensKey：统计维度 
/// 			  aStandard ：合格、""(全部),不合格
/// 			  aItemTypeDesc ：项目分类关键字 卫生手/外科手/""(卫生手+外科手)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S510EHHand","QryEHHandDtl","2019-08-13","2019-12-13","0001-07-0011-E-4")
Query QryEHHandDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "", aStandard As %String = "", aItemTypeDesc As %String = "", aStaType As %String = "W") As %Query(ROWSPEC = "EvRepID:%String,ItemDesc:%String,LocDesc:%String,StatusDesc:%String,ItemObjDesc:%String,MonitorDate:%String,SpecTypeDesc:%String,SpecimenNum:%String,APUserName:%String,Standard:%String") [ SqlProc ]
{
}

ClassMethod QryEHHandDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "", aStandard As %String = "", aItemTypeDesc As %String = "", aStaType As %String = "W") As %Status
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
			Set ItemDr		= $li(EvRepData,2)
			Set ItemData	= $g(^DHCHAI.IR.EnviHyItemD(ItemDr))
			Set ItemDesc	= $li(ItemData,2)
			Set ItemTypeDr	= $li(ItemData,14)
			Set ItemTypeData= $g(^DHCHAI.BT.DictionaryD(ItemTypeDr))
			Set ItemTypeDesc= $li(ItemTypeData,3)
			Continue:(ItemTypeDesc'["外科手")&&(ItemTypeDesc'["卫生手")
			Continue:(aItemTypeDesc'="")&&(ItemTypeDesc'[aItemTypeDesc)
			//监测科室EHMonitorLocDr
			Set LocDr = $li(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(LocDr'=aMonitorLocID)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $li(LocData,3)
			Set HospDr	= $Li(LocData,8)
			
			Set BTTypeDr= $Li(LocData,5)
			Set TypeData= $g(^DHCHAI.BT.DictionaryD(BTTypeDr))
			Set BTCode	=$Li(TypeData,2)
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

ClassMethod QryEHHandDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEHHandDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEHHandDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEHHandDtlExecute ]
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
