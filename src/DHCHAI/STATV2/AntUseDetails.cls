/// 名称: DHCHAI.STATV2.AntUseDetails
/// 描述: 患者抗菌药物使用统计类
/// 编写者：zhugz
/// 编写日期: 2019-11-21
Class DHCHAI.STATV2.AntUseDetails Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-21
/// Description:  查询患者抗菌药物（全身用药）医嘱列表（主要用于出院患者）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aEpisodeID：就诊ID
/// 			  aUsePurpose:用药目的 （治疗、预防）   
/// 			  aKSS：管制分类（KSS1，KSS2，KSS3）   
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.AntUseDetails","QryOutPatAntInfo","526")
Query QryOutPatAntInfo(aEpisodeID As %String, aUsePurpose As %String = "", aKSS As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,xOrdItemID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String,CareProvDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOutPatAntInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aUsePurpose As %String = "", aKSS As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aEpisodeID="" $$$OK

	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	Set AdmDate = $lg(PAAdmData,20)
	Set DischDate = $lg(PAAdmData,26)
	Quit:(AdmDate="")||(DischDate="") $$$OK
	
	Set PatData=..BuildPaadmData(aEpisodeID)
	Quit:PatData="" $$$OK
	Set AntiUseArr=..GetAntUseInfo(aEpisodeID,AdmDate,DischDate)
	For AntInd=1:1:AntiUseArr.Count() {
		Set OrderInfo=AntiUseArr.GetAt(AntInd)
		Set UsePurpose=$li(OrderInfo,11)
		Set KSS=$li(OrderInfo,13)
		Continue:(aUsePurpose'="")&&((","_aUsePurpose_",")'[(","_UsePurpose_","))
		Continue:(aKSS'="")&&(aKSS'[KSS)
		
		//抗菌药物级别英文转化为中文
		Set DrgPoison  = $li(OrderInfo,13)
		Set:DrgPoison="KSS1" DrgPoison="非限制使用级"
		Set:DrgPoison="KSS2" DrgPoison="限制使用级"
		Set:DrgPoison="KSS3" DrgPoison="特殊使用级"
		Set $li(OrderInfo,13)=DrgPoison
	    //日期类型转化
	    Set OrdDateTime  = $li(OrderInfo,6)
		Set SttDateTime  = $li(OrderInfo,7)
		Set EndDateTime  = $li(OrderInfo,10)
		Set OrdDate=$p(OrdDateTime," ",1)
		Set OrdTime=$p(OrdDateTime," ",2)
		Set SttDate=$p(SttDateTime," ",1)
		Set SttTime=$p(SttDateTime," ",2)
		Set EndDate=$p(EndDateTime," ",1)
		Set EndTime=$p(EndDateTime," ",2)
		Set:OrdDate'="" OrdDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
		Set:SttDate'="" SttDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set:OrdTime'="" OrdTime=$zt(OrdTime)
        Set:SttTime'="" SttTime=$zt(SttTime)
	    Set:EndTime'="" EndTime=$zt(EndTime)
	    Set OrdDateTime =OrdDate_" "_OrdTime
    	Set SttDateTime =SttDate_" "_SttTime
		Set EndDateTime =EndDate_" "_EndTime
		Set $li(OrderInfo,6)=OrdDateTime
		Set $li(OrderInfo,7)=SttDateTime
		Set $li(OrderInfo,10)=EndDateTime
		
		Set OrdItemID=$lg(OrderInfo,1)
		Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdItemID))
		//取医师类型
		Set OrdDocDesc =$lg(OrdItemData,14)  //ID|Code|Desc
		Set OEDocDr=""
		Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
		Set CarPrvTpId="",CarPrvTpDesc=""
		Set:OEDocDr'="" CarPrvTpId=$p(^CTPCP(OEDocDr,1),"^",4)	//CTCarPrvTp
		Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)
        Set OrderInfo=OrderInfo_$lb(CarPrvTpDesc)
		Set Data=PatData_OrderInfo
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOutPatAntInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutPatAntInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutPatAntInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutPatAntInfoExecute ]
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
/// CreatDate：   2019-11-21
/// Description:  住院患者：按日期+维度查询抗菌药物（全身用药）医嘱列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem
/// Input:        aDateFrom:开始日期
/// 		      aDateTo：结束日期
/// 		      aDimensKey：维度(该次就诊 在某个维护信息内的抗菌药物使用情况)
/// 		      aEpisodeID：就诊ID
/// 		      aTransID：转科ID
/// 			  aUsePurpose: 用药目的
/// 			  aKSS：管制分类
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.AntUseDetails","QryInPatAntInfo","2020-02-01","2020-04-30","0001-07-0024-W-4","2662","","","","KSS3")
Query QryInPatAntInfo(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aEpisodeID As %String = "", aTransID As %String = "", aUsePurpose As %String = "", aKSS As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,TransLocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,xOrdItemID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String") [ SqlProc ]
{
}

ClassMethod QryInPatAntInfoExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aEpisodeID As %String = "", aTransID As %String = "", aUsePurpose As %String = "", aKSS As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDimensKey="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	//同期在科、在病区
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set ListLocArray=..GetTransInfoByLocDate(aDateFrom,aDateTo,StatType,"","I") //某段时间的在科人数
    For index1=1:1:ListLocArray.Count() {  
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		Set TransID   	= $LIST(TransInfo,1)
		Set TransDate  	= $LIST(TransInfo,2)
		Set OutLocDate 	= $LIST(TransInfo,3)			
		Set Paadm  		= $LIST(TransInfo,4)	
		Set TransLocID 	= $LIST(TransInfo,5)
		//可以在维度内 对就诊和转科的传惨进行过滤
		Continue:(aEpisodeID'="")&&(Paadm'=aEpisodeID)
		Continue:(aTransID'="")&&(TransID'=aTransID)
		Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
		Continue:TranData=""
		Set LocData = $g(^DHCHAI.BT.LocationD(TransLocID))
		Set TransLocDesc=$li(LocData,3)
		Set HospDr=$li(LocData,8)
		//  医院过滤
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&&(TransLocID'=aLocDr)
		//如果转科起止日期大于统计日期，以统计日期计算
		Set TransTime = $li(TranData,8)
		Set OutLocTime =$li(TranData,11)
		Set DateFrom=TransDate,DateTo=OutLocDate,TimeFrom=TransTime,TimeTo=OutLocTime
		Set:TransDate<aDateFrom DateFrom = aDateFrom,TimeFrom=""
		Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo,TimeTo=""
		//患者基本信息
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
	    //转科信息 
	    Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
		Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	    Set:TransTime'="" TransTime=$zt(TransTime)
	    Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
	    Set TransDateTime =TransDate_" "_TransTime
		Set OutLocDateTime =OutLocDate_" "_OutLocTime
		Set TransInfo=$lb(TransID,GroupDr,GroupDesc,TransLocID,TransLocDesc,TransDateTime,OutLocDateTime)
		//获取抗菌药物使用信息
		Set AntUseFlg="",CureUseFlg="",PreUseFlg=""
		Set AntUseArr =..GetAntUseInfo(Paadm,DateFrom,DateTo,TimeFrom,TimeTo)	
		for AntInd=1:1:AntUseArr.Count(){
				Set OrderInfo=AntUseArr.GetAt(AntInd)
				Set UsePurpose	= $li(OrderInfo,11)
				Set KSS			= $li(OrderInfo,13)
				Continue:(aUsePurpose'="")&&((","_aUsePurpose_",")'[(","_UsePurpose_","))
				Continue:(aKSS'="")&&(aKSS'[KSS)
				Set Data=PatData_TransInfo_OrderInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		}	
	}
	Quit $$$OK
}

ClassMethod QryInPatAntInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInPatAntInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInPatAntInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInPatAntInfoExecute ]
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
