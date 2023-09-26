/// 表单评分记录服务类
Class DHCMA.CPW.SDS.QCMrListScoreSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMA.CPW.SDS.QCMrListScoreSrv).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCMrListScore
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCMrListScore).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCMrListScore).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SDS.QCMrListScoreSrv).Update("36^6||95^a,b")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set MrListID		= $p(aInputStr,aSeparete,1)		
	Set ItemID      	= $p(aInputStr,aSeparete,2)
	Set ItemVal   		= $p(aInputStr,aSeparete,3)
	Set ValDate			= +$h
	Set ValTime			= $P($h,",",2)
	Set ID=$o(^DHCMA.CPW.SD.QCMrListScoreI("IndexMrItem"," "_MrListID,ItemID,""),-1)
	if (ID="") {
		Set obj=##class(DHCMA.CPW.SD.QCMrListScore).%New()
	}else{
		Set obj=##class(DHCMA.CPW.SD.QCMrListScore).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return	
	Set obj.MrListID	= MrListID
	Set obj.ScoreItem	= ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemID)
	Set obj.ScoreRecords= ItemVal
	Set obj.ScoreDate	= ValDate
	Set obj.ScoreTime	= ValTime	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCMrListScoreSrv).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCMrListScore).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

ClassMethod saveScoreRec(aInput As %String, aQCID As %String, aVerID As %String) As %String
{
	n (aInput,aQCID,aVerID)
	Set return=""
	Set MrListID=$p(aInput,"^",1)
	Set ItemCode=$p(aInput,"^",2)
	Set Records	=$p(aInput,"^",3)
	Set ItemID=""
	Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,ItemCode)
	Set:$IsObject(ItemObj) ItemID=ItemObj.%Id()
	Quit:ItemID="" return
	//清除原有记录
	Set OldID=$o(^DHCMA.CPW.SD.QCMrListScoreI("IndexMrItem"," "_MrListID,ItemID,""),-1)
	d ..DeleteById(OldID)
	//写入新记录
	Set aInput=MrListID_"^"_ItemID_"^"_Records
	Set return=##class(DHCMA.CPW.SDS.QCMrListScoreSrv).Update(aInput)
	Quit return
}

}
