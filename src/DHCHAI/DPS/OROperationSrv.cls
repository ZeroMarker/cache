/// 名称: DHCHAI.DPS.OROperationSrv
/// 描述: 手术相关服务
/// 编写者：zhufei
/// 编写日期: 2017-08-17
Class DHCHAI.DPS.OROperationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-17
/// Description:  根据就诊号取手术日期
/// Table：       DHCHAI.DP.OROperation
/// Input：       aEpisodeID ：就诊号
/// Output:       返回List
/// w ##class(DHCHAI.DPS.OROperationSrv).GetOperaDates(235)
ClassMethod GetOperaDates(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set objOpera=##class(DHCHAI.DP.OROperation).GetObjById(xID)
		Continue:'$IsObject(objOpera)
		Continue:objOpera.ORIsActive'=1
		Set OperDate=objOpera.OROperDate
		Continue:OperDate=""
		Continue:$listfind(return,OperDate)>0
		Set return=return_$lb(OperDate)
	}
	Quit return
}

}
