/// 名称: DHCHAI.STATV2.S471EnvHyQua
/// 描述: 环境卫生学监测合格率统计表
/// 编写者：zzl
/// 编写日期: 2023-04-04
Class DHCHAI.STATV2.S471EnvHyQua Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
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
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S471EnvHyQua","QryEnvHyQua","","2022-01-01","2022-12-30","")
Query QryEnvHyQua(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String = "") As %Query(ROWSPEC = "xSpecTypeDr:%String,SpecTypeDesc:%String,ItemID:%String,ItemDesc:%String,EvReportCnt:%Integer,StandardCnt:%Integer,UnStandardCnt:%Integer,StandardRatio:%String,UnStandardRatio:%String,Reason:%String") [ SqlProc ]
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
			Set StatusDr = $lg(EvRepData,4)
			Continue:StatusDr=""
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusDr))
			Set StatusDesc	= $lg(StatusData,3)
			Continue:StatusDesc'["结果"   //非审核结果、录入结果的 不参与统计
			Set SpecimenNum = $lg(EvRepData,10)
			Set ItemDr		= $lg(EvRepData,2)
			Continue:ItemDr=""
			
			//监测科室EHMonitorLocDr
			Set LocDr = $lg(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(aMonitorLocID'=LocDr)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $lg(LocData,3)
			Set HospDr	= $lg(LocData,8)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)	// 院区过滤
			//申请人
			Set APUserName=""
			Set ApplyUser	= $lg(EvRepData,9)
			Continue:ApplyUser=""
			Set ApplyUserData= $g(^DHCHAI.BT.SysUserD(ApplyUser))
			Set APUserName	= $lg(ApplyUserData,3)
			
			Set StandardFlg=0,Standard=""
			Set StandardDr	= $lg(EvRepData,15)
			Set:StandardDr'="" Standard	= $lg($g(^DHCHAI.BT.DictionaryD(StandardDr)),3)
			Set:Standard="合格" StandardFlg=1
			//标本类型,项目名称
			Set ItemObjDr	= $lg(EvRepData,3)
			Set ItemObjData="" //监测对象
			Set:ItemObjDr'="" ItemObjData	= $g(^DHCHAI.IR.EnviHyObjectD(ItemObjDr))
			Set ItemObjDesc="",SpecTypeDr="",SpecTypeDesc=""
			Set:ItemObjData'="" ItemObjDesc=$lg(ItemObjData,2)
			Set:ItemObjData'="" SpecTypeDr=$lg(ItemObjData,3)
			
			
			if (SpecTypeDr'="") {
					Set SpecTypeDicData=$g(^DHCHAI.BT.DictionaryD(SpecTypeDr))
					Set SpecTypeDesc=$lg(SpecTypeDicData,3) //标本类型
					// 监测数量
					Set num=$i(^TMP($zn,$j,NIndex,SpecTypeDr,ItemDr,"EvReportCnt"))
					// 合格数量
					if (StandardFlg=1) {
						Set num=$i(^TMP($zn,$j,NIndex,SpecTypeDr,ItemDr,"StandardCnt"))
					}
					else{
						Set Val=##class(DHCHAI.IR.EnviHyReCheck).GetValue(xEvRepID)
        				Set Reason=$p(Val,"^",1)
        				Set BarCode=""
        				Set BarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(xEvRepID)
						Set num=$i(^TMP($zn,$j,NIndex,SpecTypeDr,ItemDr,"UnStandardCnt"))
	 
						Set ReasonStr=LocDesc_"|"_ItemObjDesc_"|"_BarCode_"|"_APUserName_"|"_Reason //科室名称|监测对象|申请号|申请人|不合格原因
						Set:Reason'="" ^TMP($zn,$j,NIndex,SpecTypeDr,ItemDr,"UnReason")=$g(^TMP($zn,$j,NIndex,SpecTypeDr,ItemDr,"UnReason"))_","_ReasonStr
						
						}
				}
			
		}
	}
	// 输出Data
	Set xSpecTypeDr=""
	For {
		Set xSpecTypeDr=$o(^TMP($zn,$j,NIndex,xSpecTypeDr))
		Quit:xSpecTypeDr=""
	    
	    Set xItemDr=""
	    For{
		    Set xItemDr=$o(^TMP($zn,$j,NIndex,xSpecTypeDr,xItemDr))
		    Quit:xItemDr=""
		    Set SpecTypeDicData=$g(^DHCHAI.BT.DictionaryD(xSpecTypeDr))
			Set SpecTypeDesc=$lg(SpecTypeDicData,3)
			Set ItemData	= $g(^DHCHAI.IR.EnviHyItemD(xItemDr)) //监测项目
			Set ItemDesc	= $lg(ItemData,2) //项目名称
			Set EvReportCnt  =+$g(^TMP($zn,$j,NIndex,xSpecTypeDr,xItemDr,"EvReportCnt"))		//监测数量
			Set StandardCnt  =+$g(^TMP($zn,$j,NIndex,xSpecTypeDr,xItemDr,"StandardCnt"))		//合格数量
			Set UnStandardCnt  =+$g(^TMP($zn,$j,NIndex,xSpecTypeDr,xItemDr,"UnStandardCnt"))  		//不合格数量
		    Set Reason=$g(^TMP($zn,$j,NIndex,xSpecTypeDr,xItemDr,"UnReason"))
            Set:Reason'="" Reason= $e(Reason,2,$l(Reason))
			Continue:(EvReportCnt=0)
			Set StandardRatio="0.00%"
			Set:EvReportCnt>0 StandardRatio=$fn((StandardCnt/EvReportCnt)*100,"",2)_"%"			//合格率
			Set UnStandardRatio="0.00%"
			Set:EvReportCnt>0 UnStandardRatio=$fn((UnStandardCnt/EvReportCnt)*100,"",2)_"%"			//不合格率
			Set Data=$lb(xSpecTypeDr,SpecTypeDesc,xItemDr,ItemDesc,EvReportCnt,StandardCnt,UnStandardCnt,StandardRatio,UnStandardRatio,Reason)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
	    }

	}	
	Kill ^TMP($zn,$j,NIndex)  
	Quit $$$OK
}

ClassMethod QryEnvHyQuaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvHyQuaExecute ]
{
	Set repid=$liST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnvHyQuaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvHyQuaExecute ]
{
	set AtEnd=$liST(qHandle,1)
 	set repid=$liST(qHandle,2)
 	set ind=$liST(qHandle,3)
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
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S471EnvHyQua","QryEnvHyQuaDtl","","2018-05-09","2021-05-09","","","")
Query QryEnvHyQuaDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String, aItemID As %String, aStandard As %String = "") As %Query(ROWSPEC = "EvRepID:%String,ItemDesc:%String,LocDesc:%String,StatusDesc:%String,ItemObjDesc:%String,MonitorDate:%String,SpecTypeDesc:%String,SpecimenNum:%String,APUserName:%String,Standard:%String") [ SqlProc ]
{
}

ClassMethod QryEnvHyQuaDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocID As %String, aItemID As %String, aStandard As %String = "") As %Status
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
			Set StatusDr = $lg(EvRepData,4)
			Continue:StatusDr=""
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusDr))
			Set StatusDesc	= $lg(StatusData,3)
			Continue:StatusDesc'["结果"   //非审核结果、录入结果的 不参与统计
			//监测科室EHMonitorLocDr
			Set LocDr = $lg(EvRepData,30)
			Continue:LocDr=""
			Continue:(aMonitorLocID'="")&&(aMonitorLocID'=LocDr)
			Set LocData	= $g(^DHCHAI.BT.LocationD(LocDr))
			Set LocDesc = $lg(LocData,3)
			Set HospDr	= $lg(LocData,8)
			
			Continue:(aHospIDs'="")&($liSTfind(aHospIDs,HospDr)<1)	// 院区过滤
			
			Set SpecimenNum = $lg(EvRepData,10) //标本数量
			Set MonitorDate = $lg(EvRepData,5) 	//监测日期
			Set:MonitorDate'="" MonitorDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
			Set ItemDr		= $lg(EvRepData,2) //监测项目
			Continue:ItemDr=""
			Continue:(aItemID'="")&&(aItemID'=ItemDr)
			Set ItemObjDr	= $lg(EvRepData,3) //监测对象
			Set ItemObjTxt	= $lg(EvRepData,26)
			Set ItemData	= $g(^DHCHAI.IR.EnviHyItemD(ItemDr))
			Set ItemDesc	= $lg(ItemData,2)
			Set ItemObjData=""
			Set:ItemObjDr'="" ItemObjData	= $g(^DHCHAI.IR.EnviHyObjectD(ItemObjDr))
			Set ItemObjDesc="",SpecTypeDr="",SpecTypeDesc=""
			Set:ItemObjData'="" ItemObjDesc=$lg(ItemObjData,2)
			Set:ItemObjData'="" SpecTypeDr=$lg(ItemObjData,3)
			if (SpecTypeDr'="") {
				
				Set SpecTypeDicData=$g(^DHCHAI.BT.DictionaryD(SpecTypeDr))
				Set SpecTypeDesc=$lg(SpecTypeDicData,3)
				}
			Set:ItemObjTxt'="" ItemObjDesc=ItemObjDesc_"["_ItemObjTxt_"]"
			Set ApplyUser	= $lg(EvRepData,9)
			Continue:ApplyUser=""
			Set ApplyUserData= $g(^DHCHAI.BT.SysUserD(ApplyUser))
			Set APUserName	= $lg(ApplyUserData,3)
			Set StandardDr	= $lg(EvRepData,15)
			Set Standard="未录入",StandardCode=""
			Set:StandardDr'="" Standard	= $li($g(^DHCHAI.BT.DictionaryD(StandardDr)),3)
			Set:StandardDr'="" StandardCode	= $li($g(^DHCHAI.BT.DictionaryD(StandardDr)),2)
			Continue:(aStandard'="")&(aStandard'=StandardCode)
			Set BarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(xEvRepID)
			Set Data=$lb(BarCode,ItemDesc,LocDesc,StatusDesc,ItemObjDesc,MonitorDate,SpecTypeDesc,SpecimenNum,APUserName,Standard)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}	  
	Quit $$$OK
}

ClassMethod QryEnvHyQuaDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvHyQuaDtlExecute ]
{
	Set repid=$liST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnvHyQuaDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvHyQuaDtlExecute ]
{
	set AtEnd=$liST(qHandle,1)
 	set repid=$liST(qHandle,2)
 	set ind=$liST(qHandle,3)
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
