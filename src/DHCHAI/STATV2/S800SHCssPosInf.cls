/// 名称: DHCHAI.STATV2.S800SHCssPosInf
/// 描述: 实时现患率住院患者医院感染部位例次占比统计表
/// 编写者：zhoubo
/// 编写日期: 2019-12-26
Class DHCHAI.STATV2.S800SHCssPosInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-12-30
/// Description:  感染部位例次占比统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 			  aStaType ：科室/病区类型
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S800SHCssPosInf","QryCSSInfPos","","2019-12-30","2019-12-30","W")
Query QryCSSInfPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aInfType As %String = "") As %Query(ROWSPEC = "PosDesc:%String,InfDiagDesc:%String,InfDiagCount:%String") [ SqlProc ]
{
}

ClassMethod QryCSSInfPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aInfType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryCSSInfPos"
	Kill ^TMP($zn,$j,NIndex)
    //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	
	Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
	For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		
		//获取感染信息
		Set InfDateFrom = $p(TransDates,",",1)
		Set InfDateTo   = $p(TransDates,",",$l(TransDates,","))
		Set INFInfo =##class(DHCHAI.STATV2.S450SHCSSPosBac).GetInfPosInfo(Paadm,InfDateFrom,InfDateTo,aInfType)
		
		For indxi=1:1:$l(INFInfo,"#") {
			Set tmpInfPosBact = $p(INFInfo,"#",indxi)
			Continue:tmpInfPosBact=""
			Set InfPosDescs = $p(tmpInfPosBact,",",1)
			Set Bacterias   = $p(tmpInfPosBact,",",2)
			
			For indxxi=1:1:$l(InfPosDescs,"|") {
				Set tmpPos = $p(InfPosDescs,"|",indxxi)
				Continue:tmpPos=""
				Set PosDesc=$p(tmpPos,"^",2)
				Set tPosDesc=$p(tmpPos,"^",5)
				Set ^TMP($zn,$j,NIndex,"InfPosList",PosDesc)=tPosDesc
				// 记录感染部位数量
				Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",PosDesc))
			}
		}
    }
	Set xDiag = ""
 	For {
		Set xDiag = $o(^TMP($zn,$j,NIndex,"InfPosList",xDiag))
		Quit:xDiag=""	
	
		Set InfDiagDesc=xDiag
		Set InfDiagCount =+$g(^TMP($zn,$j,NIndex,"InfPosCount",xDiag))
		Set PosDesc      =$g(^TMP($zn,$j,NIndex,"InfPosList",xDiag))
		Set Data=$lb(PosDesc,InfDiagDesc,InfDiagCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCSSInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSInfPosExecute ]
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
