/// 名称: DHCMA.CPW.IO.FromCIS
/// 描述: 临床路径获取临床组（手麻）接口
/// 编写者：yankai
/// 编写日期: 2021-04-28
Class DHCMA.CPW.IO.FromCIS Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：      	yankai
/// CreatDate：    	2021-4-29
/// Description： 	根据就诊RowId获取本次就诊最新手术
/// Table：        	CIS_AN.OperSchedule,CIS_AN.OperList,ORC_Operation
/// Input:					EpisodeID - 就诊表RowId
/// Return：       	JSON字符串
/// w ##class(DHCMA.CPW.IO.FromCIS).GetOperListByCIS("12345")
ClassMethod GetOperListByCIS(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetOperListByCISErr"
	//检查手麻接口程序是否存在，不存在返回空
	Set ret=##class(%Dictionary.MethodDefinition).%ExistsId("CIS.AN.SRV.OperService||GetLastOperInfoByAdm")
	Quit:ret=0 return
	
	Set operInfo=##class(CIS.AN.SRV.OperService).GetLastOperInfoByAdm(aEpisodeID)		//返回本次就诊的最新手术信息
	Quit:operInfo="" return
	
	Set operArr=##class(%DynamicObject).%FromJSON(operInfo)
	Set iter=operArr.%GetIterator()
	while iter.%GetNext(.key,.value){
		Set OPSId = value.OPSID								//手术申请RowId
		Set OperSdl=##class(CIS.AN.OperSchedule).%OpenId(OPSId)
		Set OperType=OperSdl.SourceType										 
		Do:OperType'="B" operArr.%Remove(key)				//手术类型：B:择期，E:急诊，D:日间；过滤急诊、日间，只保留择期手术	
	}
	
	Quit operArr.%ToJSON()
	
GetOperListByCISErr
	Quit ""
}

/// Creator：      	yankai
/// CreatDate：    	2021-4-30
/// Description： 	用于取消手术申请时,检查是否应提示退出路径
/// Table：        	
/// Input:			aEpisodeID：就诊RowId；aOperIDs:手术申请中的手术ID串
/// Return：       	是:1^路径描述，否:0
/// w ##class(DHCMA.CPW.IO.FromCIS).CheckIsExistInCPW(24)
ClassMethod CheckIsExistInCPW(aEpisodeID As %String, aOperIDs As %String) As %String
{
	New (aEpisodeID,aOperIDs)
	Set return=0
	Quit:(aEpisodeID="")||(aOperIDs="") return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}

	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)		
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
		
	If objPathway.CPStatus="I"{
		Quit:'$IsObject(objPathway.CPFormDr) return
		Quit:'$IsObject(objPathway.CPFormDr.FormPathDr) return
		Set PathDesc=objPathway.CPFormDr.FormPathDr.BTDesc
		Set TrigOper=objPathway.CPTrigOper
		Set listTrigOper=$lfs(TrigOper,",")
		
		For indx=1:1:$l(aOperIDs,","){
			Quit:return'=0
			Set xOperID=$p(aOperIDs,",",indx)
			Set objOper=##class(User.ORCOperation).%OpenId(xOperID)
			Set ICDCode=objOper.OPERICD10
			Set:$lf(listTrigOper,ICDCode)>0 return=1_"^"_PathDesc	
		}	
	}
	
	Quit return
}

}
