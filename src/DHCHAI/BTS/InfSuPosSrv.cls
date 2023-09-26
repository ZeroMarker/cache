/// 名称: DHCHAI.BTS.InfSuPosSrv
/// 描述: 疑似诊断服务类
/// 编写者：zhufei
/// 编写日期: 2017-05-04
Class DHCHAI.BTS.InfSuPosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-04
/// Description:  根据类型和关键词筛查疑似诊断
/// Table：       DHCHAI.BT.InfSuPos、DHCHAI.BT.InfSuPosExt
/// Input：       aTypeCode:  类型代码
///               aKeyword: 关键词
/// Return：      返回String
/// w ##class(DHCHAI.BTS.InfSuPosSrv).GetInfSuPos("Specimen","痰")
ClassMethod GetInfSuPos(aTypeCode As %String, aKeyword As %String) As %String
{
	New (aTypeCode,aKeyword)
	Set return=""
	Quit:(aTypeCode="")||(aKeyword="") return
	
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfSuPosKeyTpye",aTypeCode)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set xID=$o(^DHCHAI.BT.InfSuPosExtI("IdxofKeyWord",TypeDr,aKeyword,0))
	Quit:xID="" return
	Set obj=##class(DHCHAI.BT.InfSuPosExt).GetObjById(xID)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.BTSuPosDr) return
	Set return=obj.BTSuPosDr.%Id()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-04-04
/// Description:  查询医院感染疑似诊断（部位）表
/// Table：       DHCHAI.BT.InfSuPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfSuPosSrv","QryInfSuPos")
Query QryInfSuPos() As %Query(ROWSPEC = "ID:%String,Diagnos:%String,InfPosID:%String,InfPosCode:%String,InfPosDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String")
{
}

ClassMethod QryInfSuPosExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xDiag = ""
	For {
		Set xDiag = $o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos",xDiag))
		Quit:xDiag=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos",xDiag,xID))
			Quit:xID=""
			Set objInfSuPos = ##class(DHCHAI.BT.InfSuPos).GetObjById(xID)
			Continue:'$isobject(objInfSuPos)
			
			Set Diagnos = objInfSuPos.BTDiagnos
			Set (InfPosCode,InfPosDesc) = ""
			If $IsObject(objInfSuPos.BTInfPosDr) {	
				Set InfPosID =  objInfSuPos.BTInfPosDr.%Id()  
				Set InfPosCode = objInfSuPos.BTInfPosDr.BTCode
				Set InfPosDesc = objInfSuPos.BTInfPosDr.BTDesc
		    }
			Set ActDate = objInfSuPos.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objInfSuPos.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set (ActUserCode,ActUserDesc) = ""
			If $IsObject(objInfSuPos.BTActUserDr) {	   
				Set ActUserCode = objInfSuPos.BTActUserDr.BTCode
				Set ActUserDesc = objInfSuPos.BTActUserDr.BTDesc
		    }
					
			Set Data = $lb(xID,Diagnos,InfPosID,InfPosCode,InfPosDesc,ActDate,ActTime,ActUserCode,ActUserDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryInfSuPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSuPosExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfSuPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSuPosExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-05-15
/// Description:  导入感染疑似诊断（部位）
/// Table：       DHCHAI.BT.InfSuPos
/// Input：       疑似感染诊断名称和感染部位名称,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.BTS.InfSuPosSrv).ImportInfSuPos("下呼吸道感染^呼吸系统","^")
ClassMethod ImportInfSuPos(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set InfSuPosDesc=$p(aInput,aSeparate,1)  //疑似感染诊断名称
	Set InfPosDesc=$p(aInput,aSeparate,2)    //感染部位名称
	
	Quit:(InfSuPosDesc="") return
	Set InfPosID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",InfPosDesc,0))
	Quit:InfPosID="" return
	Set InputStr=""                       
	Set InputStr=InputStr_aSeparate_InfSuPosDesc
	Set InputStr=InputStr_aSeparate_InfPosID
	Set InputStr=InputStr_aSeparate_""
	Set InputStr=InputStr_aSeparate_""
	Set InputStr=InputStr_aSeparate_""
	Set return=##Class(DHCHAI.BT.InfSuPos).Update(InputStr, aSeparate)
	
	Quit return
}

}
