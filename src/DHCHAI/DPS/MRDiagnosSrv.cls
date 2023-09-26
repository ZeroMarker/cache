/// 名称: DHCHAI.DPS.MRDiagnosSrv
/// 描述: 诊断信息相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-09-01
Class DHCHAI.DPS.MRDiagnosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-09-01
/// Description:  查询患者诊断名称列表
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       EpisodeDr DHCHAI.DP.PAAdm.%Id()
///               aDiagType  诊断类型：C008入院诊断  PRE初步诊断 DIS出院诊断
/// 				  aDiagSource 诊断来源
/// Return：      诊断名称列表
/// w ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR("6","DIS")
ClassMethod GetMRDiagnosByDR(aEpisodeDr As %String, aDiagType As %String = "", aDiagSource As %String = "") As %String
{
	New (aEpisodeDr,aDiagType,aDiagSource)
	Set return=""
	Quit:(aEpisodeDr="") return
	Set DiagList=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Set objDig=##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
		Continue:'$isobject(objDig)
		Set IsActive = objDig.MRIsActive
		Continue:IsActive'=1
		
		Set MRDiagTpCode = objDig.MRDiagTpCode
		Continue:(aDiagType'="")&&(aDiagType'[MRDiagTpCode)
		Set MRDiagSource = objDig.MRDiagSource
		Continue:(aDiagSource'="")&&(aDiagSource'=MRDiagSource)
		Set MRDiagICD10  = objDig.MRDiagICD10
		Set MRDiagDesc   = objDig.MRDiagDesc
		Set MRDiagTpDesc = objDig.MRDiagTpDesc
		Set MRDiagDate   = objDig.MRDiagDate
		Set:MRDiagDate'="" MRDiagDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MRDiagDate)
		Continue:$listfind(DiagList,MRDiagDesc)
		Set DiagList = DiagList_$lb(MRDiagDesc)
	}
	If DiagList'=""{
		for ind = 1:1:$ll(DiagList){
			Set return = return_","_$lg(DiagList,ind)
		}
		Set:return'="" return=$e(return,2,$l(return)) 
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-01
/// Description:  查询患者诊断名称列表
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       aEpisodeDr DHCHAI.DP.PAAdm.%Id()
///               aDiagType 
/// 				  aDiagSource
/// Return：      
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.MRDiagnosSrv","QryDiagByEpisodeID","6","","C")
Query QryDiagByEpisodeID(aEpisodeDr As %String, aDiagType As %String = "", aDiagSource As %String = "") As %Query(ROWSPEC = "ID:%String,ICD10:%String,DiagDesc:%String,DiagTpCode:%String,DiagTpDesc:%String,DiagDate:%String,DiagTime:%String,DiagNote:%String,DiagSource:%String") [ SqlProc ]
{
}

ClassMethod QryDiagByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeDr As %String, aDiagType As %String = "", aDiagSource As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeDr="") $$$OK
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
		Continue:'$isobject(obj)
		Set IsActive = obj.MRIsActive
		Continue:IsActive'=1
		
		Set SCode	 	= obj.MRSCode
		Set ICD10  		= obj.MRDiagICD10
		Set DiagDesc   	= obj.MRDiagDesc
		Set DiagTpCode  = obj.MRDiagTpCode
		Set DiagTpDesc 	= obj.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		Continue:(aDiagType'="")&(aDiagType'[DiagTpCode)
		
		Set DiagDate    = obj.MRDiagDate
		Set:DiagDate'="" DiagDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DiagDate)
		Set DiagNote    = obj.MRDiagNote
		Set DiagSource  = obj.MRDiagSource
		Continue:(aDiagSource'="")&&(aDiagSource'=DiagSource)
		Set DiagSource = $s(DiagSource="C":"临床",DiagSource="E":"首页",1:"编目")
		Set DiagTime    = obj.MRDiagTime
		Set:DiagTime'="" DiagTime=$zt(DiagTime)
		Set Data=$lb(xID,ICD10,DiagDesc,DiagTpCode,DiagTpDesc,DiagDate,DiagTime,DiagNote,DiagSource)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryDiagByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagByEpisodeIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDiagByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagByEpisodeIDExecute ]
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
