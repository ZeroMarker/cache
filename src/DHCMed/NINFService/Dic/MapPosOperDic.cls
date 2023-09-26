/// 名称: DHCMed.NINFService.Dic.MapPosOperDic
/// 描述: 感染部位与侵害性操作关联的常用操作
/// 编写者：LiuYH
/// 编写日期: 2012-12-23
Class DHCMed.NINFService.Dic.MapPosOperDic Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LiuYH
/// CreatDate：   2012-12-23
/// Description:  保存感染部位与侵害性操作关联
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       aInfPositions  : 感染部位
///               aOperDic  : 侵害性操作
/// Return：      return<=0 保存失败
/// w ##class(DHCMed.NINFService.Dic.MapPosOperDic).SaveMapPosOper("1","2")
ClassMethod SaveMapPosOper(aInfPositions As %String, aOperDic As %String) As %String
{
	New (aInfPositions,aOperDic)
	Set return=0,Count=0
	Quit:(aInfPositions="")||(aOperDic="") return
	
	Set $ZT="SaveMapPosOperDicErr"
	
	For indPos=1:1:$l(aInfPositions,"^") {
		Set InfPosID=$p(aInfPositions,"^",indPos)
		Continue:InfPosID=""
		Set objInfPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(InfPosID)
		Continue:'$IsObject(objInfPos)
		
		For indDiag=1:1:$l(aOperDic,"^") {
			Set InfOperDicID=$p(aOperDic,"^",indDiag)
			Continue:InfOperDicID=""
			Set objInfOperDic=##class(DHCMed.SS.Dictionary).GetObjById(InfOperDicID)
			Continue:'$IsObject(objInfOperDic)
			
			Set MapID=$o(^DHCMed.NINFDi("MapPosOpr",0,"IndexPosOper",InfPosID,InfOperDicID,0))
			
			Set InputStr=MapID_"^"_InfPosID_"^"_InfOperDicID
			Set flg=##Class(DHCMed.NINF.Dic.MapPosOperDic).Update(InputStr,"^")
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
SaveMapPosOperDicErr
	Quit "-999"
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-23
/// Description:  删除感染部位与侵害性操作关联
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       aInfPositions  : 感染部位
///               aOperDic  : 侵害性操作
/// Return：      return<=0 保存失败
/// w ##class(DHCMed.NINFService.Dic.MapPosOperDic).DeleteMapPosOper(11,1531)
ClassMethod DeleteMapPosOper(aInfPositions As %String, aOperDic As %String) As %String
{
	New (aInfPositions,aOperDic)
	Set return=0,Count=0
	Quit:(aInfPositions="")||(aOperDic="") return
	
	Set $ZT="DeleteMapPosOperErr"
	
	For indPos=1:1:$l(aInfPositions,"^") {
		Set InfPosID=$p(aInfPositions,"^",indPos)
		Continue:InfPosID=""
		Set objInfPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(InfPosID)
		Continue:'$IsObject(objInfPos)
		
		For indDiag=1:1:$l(aOperDic,"^") {
			Set InfOperDicID=$p(aOperDic,"^",indDiag)
			Continue:InfOperDicID=""
			Set objInfOperDicID=##class(DHCMed.SS.Dictionary).GetObjById(InfOperDicID)
			Continue:'$IsObject(objInfOperDicID)
			
			Set MapID=$o(^DHCMed.NINFDi("MapPosOpr",0,"IndexPosOper",InfPosID,InfOperDicID,0))
			Continue:MapID=""
			
			Set flg=##Class(DHCMed.NINF.Dic.MapPosOperDic).DeleteById(MapID)
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
DeleteMapPosOperErr
	Quit "-999"
}

/// Creator：     LiuYH
/// CreatDate：   2012-05-26
/// Description:  查询院感部位
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.MapPosOperDic","QryOperByInfPos0","1","Y")
Query QryOperByInfPos0(aInfPosID As %String, aIsViewAll As %String) As %Query(ROWSPEC = "MapID:%String,IPRowID:%String,IPCode:%String,IPDesc:%String,IDRowID:%String,IDCode:%String,IDDesc:%String,IsChecked:%String")
{
}

ClassMethod QryOperByInfPos0Execute(ByRef qHandle As %Binary, aInfPosID As %String, aIsViewAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aInfPosID="" $$$OK
 	
 	If aIsViewAll="Y" {
	 	Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," NINFINFINVASIVEOPER",xCode))
		 	Quit:xCode=""
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," NINFINFINVASIVEOPER",xCode,xID))
			 	Quit:xID=""
			 	
			 	Set (MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc)=""
			 	Set MapID=$o(^DHCMed.NINFDi("MapPosOpr",0,"IndexPosOper",aInfPosID,xID,0))
			 	If MapID'="" {
				 	Set objMap=##class(DHCMed.NINF.Dic.MapPosOperDic).GetObjById(MapID)
					Continue:'$IsObject(objMap)
				 	Continue:'$IsObject(objMap.MPDInfPosDr)
				 	Set IPRowID=objMap.MPDInfPosDr.%Id()
				 	Set IPCode=objMap.MPDInfPosDr.IPCode
				 	Set IPDesc=objMap.MPDInfPosDr.IPDesc
				 	Set IPActive=objMap.MPDInfPosDr.IPActive
				 	Set:IPActive'=1 IPDesc="*"_IPDesc
				 	Continue:'$IsObject(objMap.MPDInfOper)
				 	Set IDRowID=objMap.MPDInfOper.%Id()
				 	Set IDCode=objMap.MPDInfOper.Code
				 	Set IDDesc=objMap.MPDInfOper.Description
				 	Set IDActive=objMap.MPDInfOper.Active
				 	Set:IDActive'=1 IDDesc="*"_IDDesc
				 	Set IsChecked=1
				} Else {
					Set obj=##class(DHCMed.SS.Dictionary).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Set IDRowID=obj.%Id()
				 	Set IDCode=obj.Code
				 	Set IDDesc=obj.Description
				 	Set IDActive=obj.Active
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
		 	Set MapID=$o(^DHCMed.NINFDi("MapPosOpr",0,"IndexInfPos",aInfPosID,MapID))
		 	Quit:MapID=""
		 	Set objMap=##class(DHCMed.NINF.Dic.MapPosOperDic).GetObjById(MapID)
		 	Continue:'$IsObject(objMap)
		 	Continue:'$IsObject(objMap.MPDInfPosDr)
		 	Set IPRowID=objMap.MPDInfPosDr.%Id()
		 	Set IPCode=objMap.MPDInfPosDr.IPCode
		 	Set IPDesc=objMap.MPDInfPosDr.IPDesc
		 	Set IPActive=objMap.MPDInfPosDr.IPActive
		 	Set:IPActive'=1 IPDesc="*"_IPDesc

		 	Continue:'$IsObject(objMap.MPDInfOper)
		 	Set IDRowID=objMap.MPDInfOper.%Id()
		 	Set IDCode=objMap.MPDInfOper.Code
		 	Set IDDesc=objMap.MPDInfOper.Description
		 	Set IDActive=objMap.MPDInfOper.Active
		 	Set:IDActive'=1 IDDesc="*"_IDDesc
		 	Set IsChecked=1
		 	
		 	Set Data=$lb(MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	
	Quit $$$OK
}

ClassMethod QryOperByInfPos0Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperByInfPos0Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperByInfPos0Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperByInfPos0Execute ]
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

/// Creator：     LiuYH
/// CreatDate：   2012-05-26
/// Description:  查询院感部位
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.MapPosOperDic","QryOperByInfPos1","1","")
Query QryOperByInfPos1(aInfPosID As %String, aValues As %String) As %Query(ROWSPEC = "IDRowID:%String,IDCode:%String,IDDesc:%String,IsChecked:%String")
{
}

ClassMethod QryOperByInfPos1Execute(ByRef qHandle As %Binary, aInfPosID As %String, aValues As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aInfPosID="") $$$OK
 	Set tmpValues=""
 	For indVal=1:1:$length(aValues,",")
 	{
	 	Set tmpValue=$p(aValues,",",indVal)
	 	Continue:tmpValue=""
	 	Set tmpValues=tmpValues_$lb(tmpValue)
	}
 	
 	Set Count=0
 	Set MapID="",tmpValues1=""
 	For {
 		Set MapID=$o(^DHCMed.NINFDi("MapPosOpr",0,"IndexInfPos",aInfPosID,MapID))
		Quit:MapID=""
 		Set objMap=##class(DHCMed.NINF.Dic.MapPosOperDic).GetObjById(MapID)
	 	Continue:'$IsObject(objMap)
	 	Continue:'$IsObject(objMap.MPDInfPosDr)
	 	Continue:'$IsObject(objMap.MPDInfOper)
	 	
	 	Set IDRowID=objMap.MPDInfOper.%Id()
	 	Set IDCode=objMap.MPDInfOper.Code
	 	Set IDDesc=objMap.MPDInfOper.Description
	 	Set IDActive=objMap.MPDInfOper.Active
	 	Continue:IDActive'=1
	 	
	 	If ($listfind(tmpValues,IDRowID)>0) {
		 	Set IsChecked=1
		} Else {
			Set IsChecked=0
		}
		
		Set Count=Count+1
	 	Set tmpValues1=tmpValues1_$lb(IDRowID)
	 	
	 	Set Data=$lb(IDRowID,IDCode,IDDesc,IsChecked)
	 	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	If Count<1 {
	 	Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," NINFINFINVASIVEOPER",xCode))
		 	Quit:xCode=""
		 	
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," NINFINFINVASIVEOPER",xCode,xID))
			 	Quit:xID=""
			 	
			 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
			 	Continue:'$IsObject(objDic)
			 	
			 	Set IDRowID=objDic.%Id()
			 	Set IDCode=objDic.Code
			 	Set IDDesc=objDic.Description
			 	Set IDActive=objDic.Active
			 	Continue:IDActive'=1
			 	
			 	If ($listfind(tmpValues,IDRowID)>0) {
				 	Set IsChecked=1
				} Else {
					Set IsChecked=0
				}
				
			 	Set tmpValues1=tmpValues1_$lb(IDRowID)
			 	
			 	Set Data=$lb(IDRowID,IDCode,IDDesc,IsChecked)
			 	Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
 	}
 	
 	For indRec=1:1:$listlength(tmpValues) {
	 	Set tmpValue=$list(tmpValues,indRec)
	 	Continue:tmpValue=""
	 	Continue:($listfind(tmpValues1,tmpValue)>0)
	 	
	 	Set objOper=##class(DHCMed.SS.Dictionary).GetObjById(tmpValue)
	 	Continue:'$IsObject(objOper)
	 	Set IDRowID=objOper.%Id()
	 	Set IDCode=objOper.Code
	 	Set IDDesc=objOper.Description
	 	Set IsCheck=1
	 	
	 	Set Data=$lb(IDRowID,IDCode,IDDesc,IsChecked)
	 	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryOperByInfPos1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperByInfPos1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperByInfPos1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperByInfPos1Execute ]
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
