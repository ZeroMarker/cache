/// 名称: DHCMed.NINFService.Dic.MapPosDia
/// 描述: 感染部位与感染诊断关联的常用操作
/// 编写者：zhufei
/// 编写日期: 2012-08-09
Class DHCMed.NINFService.Dic.MapPosDia Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-08-09
/// Description:  保存感染部位与感染诊断关联
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       aInfPositions  : 感染部位
///               aInfDiagnoses  : 感染诊断
/// Return：      return<=0 保存失败
/// w ##class(DHCMed.NINFService.Dic.MapPosDia).SaveMapPosDia("1","2")
ClassMethod SaveMapPosDia(aInfPositions As %String, aInfDiagnoses As %String) As %String
{
	New (aInfPositions,aInfDiagnoses)
	Set return=0,Count=0
	Quit:(aInfPositions="")||(aInfDiagnoses="") return
	
	Set $ZT="SaveMapPosDiaErr"
	
	For indPos=1:1:$l(aInfPositions,"^") {
		Set InfPosID=$p(aInfPositions,"^",indPos)
		Continue:InfPosID=""
		Set objInfPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(InfPosID)
		Continue:'$IsObject(objInfPos)
		
		For indDiag=1:1:$l(aInfDiagnoses,"^") {
			Set InfDiagID=$p(aInfDiagnoses,"^",indDiag)
			Continue:InfDiagID=""
			Set objInfDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(InfDiagID)
			Continue:'$IsObject(objInfDiag)
			
			Set MapID=$o(^DHCMed.NINFDi("MapPosDia",0,"IndexPosDiag",InfPosID,InfDiagID,0))
			
			Set InputStr=MapID_"^"_InfPosID_"^"_InfDiagID
			Set flg=##Class(DHCMed.NINF.Dic.MapPosDia).Update(InputStr,"^")
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
SaveMapPosDiaErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-08-09
/// Description:  删除感染部位与感染诊断关联
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       aInfPositions  : 感染部位
///               aInfDiagnoses  : 感染诊断
/// Return：      return<=0 保存失败
/// w ##class(DHCMed.NINFService.Dic.MapPosDia).DeleteMapPosDia("1","1")
ClassMethod DeleteMapPosDia(aInfPositions As %String, aInfDiagnoses As %String) As %String
{
	New (aInfPositions,aInfDiagnoses)
	Set return=0,Count=0
	Quit:(aInfPositions="")||(aInfDiagnoses="") return
	
	Set $ZT="DeleteMapPosDiaErr"
	
	For indPos=1:1:$l(aInfPositions,"^") {
		Set InfPosID=$p(aInfPositions,"^",indPos)
		Continue:InfPosID=""
		Set objInfPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(InfPosID)
		Continue:'$IsObject(objInfPos)
		
		For indDiag=1:1:$l(aInfDiagnoses,"^") {
			Set InfDiagID=$p(aInfDiagnoses,"^",indDiag)
			Continue:InfDiagID=""
			Set objInfDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(InfDiagID)
			Continue:'$IsObject(objInfDiag)
			
			Set MapID=$o(^DHCMed.NINFDi("MapPosDia",0,"IndexPosDiag",InfPosID,InfDiagID,0))
			Continue:MapID=""
			
			Set flg=##Class(DHCMed.NINF.Dic.MapPosDia).DeleteById(MapID)
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
DeleteMapPosDiaErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询院感部位
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.MapPosDia","QryDiagByInfPos","2","Y")
Query QryDiagByInfPos(aInfPosID As %String, aIsViewAll As %String) As %Query(ROWSPEC = "MapID:%String,IPRowID:%String,IPCode:%String,IPDesc:%String,IDRowID:%String,IDCode:%String,IDDesc:%String,IsChecked:%String")
{
}

ClassMethod QryDiagByInfPosExecute(ByRef qHandle As %Binary, aInfPosID As %String, aIsViewAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aInfPosID="" $$$OK
 	
 	If aIsViewAll="Y" {
	 	Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCMed.NINFDi("InfDia",0,"IndexCode",xCode))
		 	Quit:xCode=""
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCMed.NINFDi("InfDia",0,"IndexCode",xCode,xID))
			 	Quit:xID=""
			 	
			 	Set (MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc)=""
			 	Set MapID=$o(^DHCMed.NINFDi("MapPosDia",0,"IndexPosDiag",aInfPosID,xID,0))
			 	If MapID'="" {
				 	Set objMap=##class(DHCMed.NINF.Dic.MapPosDia).GetObjById(MapID)
					Continue:'$IsObject(objMap)
				 	Continue:'$IsObject(objMap.MPDInfPosDr)
				 	Set IPRowID=objMap.MPDInfPosDr.%Id()
				 	Set IPCode=objMap.MPDInfPosDr.IPCode
				 	Set IPDesc=objMap.MPDInfPosDr.IPDesc
				 	Set IPActive=objMap.MPDInfPosDr.IPActive
				 	Set:IPActive'=1 IPDesc="*"_IPDesc
				 	Continue:'$IsObject(objMap.MPDInfDiaDr)
				 	Set IDRowID=objMap.MPDInfDiaDr.%Id()
				 	Set IDCode=objMap.MPDInfDiaDr.IDCode
				 	Set IDDesc=objMap.MPDInfDiaDr.IDDesc
				 	Set IDActive=objMap.MPDInfDiaDr.IDActive
				 	Set:IDActive'=1 IDDesc="*"_IDDesc
				 	Set IsChecked=1
				} Else {
					Set obj=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Set IDRowID=obj.%Id()
				 	Set IDCode=obj.IDCode
				 	Set IDDesc=obj.IDDesc
				 	Set IDActive=obj.IDActive
				 	Set:IDActive'=1 IDDesc="*"_IDDesc
				 	Set IsChecked=0
				}
				
				Set Data=$lb(MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc,IsChecked)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} Else {
	 	Set MapID=0
	 	For {
		 	Set MapID=$o(^DHCMed.NINFDi("MapPosDia",0,"IndexInfPos",aInfPosID,MapID))
		 	Quit:MapID=""
		 	
		 	Set objMap=##class(DHCMed.NINF.Dic.MapPosDia).GetObjById(MapID)
		 	Continue:'$IsObject(objMap)
		 	Continue:'$IsObject(objMap.MPDInfPosDr)
		 	Set IPRowID=objMap.MPDInfPosDr.%Id()
		 	Set IPCode=objMap.MPDInfPosDr.IPCode
		 	Set IPDesc=objMap.MPDInfPosDr.IPDesc
		 	Set IPActive=objMap.MPDInfPosDr.IPActive
		 	Set:IPActive'=1 IPDesc="*"_IPDesc
		 	Continue:'$IsObject(objMap.MPDInfDiaDr)
		 	Set IDRowID=objMap.MPDInfDiaDr.%Id()
		 	Set IDCode=objMap.MPDInfDiaDr.IDCode
		 	Set IDDesc=objMap.MPDInfDiaDr.IDDesc
		 	Set IDActive=objMap.MPDInfDiaDr.IDActive
		 	Set:IDActive'=1 IDDesc="*"_IDDesc
		 	Set IsChecked=1
		 	
		 	Set Data=$lb(MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	
	Quit $$$OK
	
BuildData
}

ClassMethod QryDiagByInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagByInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiagByInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagByInfPosExecute ]
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
