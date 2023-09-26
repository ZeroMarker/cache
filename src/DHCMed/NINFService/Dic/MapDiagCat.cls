/// 名称: DHCMed.NINFService.Dic.MapDiagCat
/// 描述: 感染诊断与感染诊断子分类关联的常用操作
/// 编写者：zhufei
/// 编写日期: 2014-04-30
Class DHCMed.NINFService.Dic.MapDiagCat Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-04-30
/// Description:  保存感染诊断与感染诊断子分类关联
/// Table：       DHCMed.NINF.Dic.MapDiagCat
/// Input：       aInfDiags  : 感染诊断
///               aDiagCats  : 诊断子分类
/// Return：      return<=0 保存失败
/// w ##class(DHCMed.NINFService.Dic.MapDiagCat).SaveMapDiagCat("2","4114")
ClassMethod SaveMapDiagCat(aInfDiags As %String, aDiagCats As %String) As %String
{
	New (aInfDiags,aDiagCats)
	Set return=0,Count=0
	Quit:(aInfDiags="")||(aDiagCats="") return
	
	Set $ZT="SaveMapDiagCatErr"
	
	For indDiag=1:1:$l(aInfDiags,"^") {
		Set InfDiagID=$p(aInfDiags,"^",indDiag)
		Continue:InfDiagID=""
		Set objInfDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(InfDiagID)
		Continue:'$IsObject(objInfDiag)
		
		For indCat=1:1:$l(aDiagCats,"^") {
			Set InfDiagCatID=$p(aDiagCats,"^",indCat)
			Continue:InfDiagCatID=""
			Set objInfDiagCatDic=##class(DHCMed.SS.Dictionary).GetObjById(InfDiagCatID)
			Continue:'$IsObject(objInfDiagCatDic)
			
			Set MapID=$o(^DHCMed.NINFDi("MapDiagCat",0,"IndexInfDiagCat",InfDiagID,InfDiagCatID,0))
			
			Set InputStr=MapID_"^"_InfDiagID_"^"_InfDiagCatID
			Set flg=##Class(DHCMed.NINF.Dic.MapDiagCat).Update(InputStr,"^")
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
SaveMapDiagCatErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2014-04-30
/// Description:  删除感染诊断与感染诊断子分类关联
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       aInfDiags  : 感染诊断
///               aDiagCats  : 诊断子分类
/// Return：      return<=0 保存失败
/// w ##class(DHCMed.NINFService.Dic.MapDiagCat).DeleteMapDiagCat(2,4114)
ClassMethod DeleteMapDiagCat(aInfDiags As %String, aDiagCats As %String) As %String
{
	New (aInfDiags,aDiagCats)
	Set return=0,Count=0
	Quit:(aInfDiags="")||(aDiagCats="") return
	
	Set $ZT="DeleteMapDiagCatErr"
	
	For indDiag=1:1:$l(aInfDiags,"^") {
		Set InfDiagID=$p(aInfDiags,"^",indDiag)
		Continue:InfDiagID=""
		Set objInfDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(InfDiagID)
		Continue:'$IsObject(objInfDiag)
		
		For indCat=1:1:$l(aDiagCats,"^") {
			Set InfDiagCatID=$p(aDiagCats,"^",indCat)
			Continue:InfDiagCatID=""
			Set objInfDiagCatDic=##class(DHCMed.SS.Dictionary).GetObjById(InfDiagCatID)
			Continue:'$IsObject(objInfDiagCatDic)
			
			Set MapID=$o(^DHCMed.NINFDi("MapDiagCat",0,"IndexInfDiagCat",InfDiagID,InfDiagCatID,0))
			
			Set flg=##Class(DHCMed.NINF.Dic.MapDiagCat).DeleteById(MapID)
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
DeleteMapDiagCatErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2014-04-30
/// Description:  查询感染诊断子分类
/// Table：       DHCMed.NINF.Dic.InfDiagnose，DHCMed.NINF.Dic.MapPosDia
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.MapDiagCat","QryInfDiagCat","1","N")
Query QryInfDiagCat(aInfDiagID As %String, aIsViewAll As %String) As %Query(ROWSPEC = "MapID:%String,IDRowID:%String,IDCode:%String,IDDesc:%String,IDCRowID:%String,IDCCode:%String,IDCDesc:%String,IsChecked:%String")
{
}

ClassMethod QryInfDiagCatExecute(ByRef qHandle As %Binary, aInfDiagID As %String, aIsViewAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aInfDiagID="" $$$OK
 	
 	Set Code="NINFInfDiagCategory"
 	
 	If aIsViewAll="Y" {
	 	Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_$zcvt(Code,"U"),xCode))
		 	Quit:xCode=""
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_$zcvt(Code,"U"),xCode,xID))
			 	Quit:xID=""
			 	
			 	Set (MapID,IDRowID,IDCode,IDDesc,IDCRowID,IDCCode,IDCDesc)=""
			 	Set MapID=$o(^DHCMed.NINFDi("MapDiagCat",0,"IndexInfDiagCat",aInfDiagID,xID,0))
			 	If MapID'="" {
				 	Set objMap=##class(DHCMed.NINF.Dic.MapDiagCat).GetObjById(MapID)
					Continue:'$IsObject(objMap)
				 	Continue:'$IsObject(objMap.MDCInfDiagDr)
				 	Set IDRowID=objMap.MDCInfDiagDr.%Id()
				 	Set IDCode=objMap.MDCInfDiagDr.IDCode
				 	Set IDDesc=objMap.MDCInfDiagDr.IDDesc
				 	Set IDActive=objMap.MDCInfDiagDr.IDActive
				 	Set:IDActive'=1 IDDesc="*"_IDDesc
				 	
				 	Continue:'$IsObject(objMap.MDCInfDiagCatDr)
				 	Set IDCRowID=objMap.MDCInfDiagCatDr.%Id()
				 	Set IDCCode=objMap.MDCInfDiagCatDr.Code
				 	Set IDCDesc=objMap.MDCInfDiagCatDr.Description
				 	Set IDCActive=objMap.MDCInfDiagCatDr.Active
				 	Set:IDCActive'=1 IDCDesc="*"_IDCDesc
				 	Set IsChecked=1
				} Else {
					Set obj=##class(DHCMed.SS.Dictionary).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Set IDCRowID=obj.%Id()
				 	Set IDCCode=obj.Code
				 	Set IDCDesc=obj.Description
				 	Set IDCActive=obj.Active
				 	Set:IDCActive'=1 IDCDesc="*"_IDCDesc
				 	Set IsChecked=0
				}
				
				Set Data=$lb(MapID,IDRowID,IDCode,IDDesc,IDCRowID,IDCCode,IDCDesc,IsChecked)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} Else {
	 	Set MapID=0
	 	For {
		 	Set MapID=$o(^DHCMed.NINFDi("MapDiagCat",0,"IndexInfDiag",aInfDiagID,MapID))
		 	Quit:MapID=""
		 	Set objMap=##class(DHCMed.NINF.Dic.MapDiagCat).GetObjById(MapID)
		 	Continue:'$IsObject(objMap)
		 	Continue:'$IsObject(objMap.MDCInfDiagDr)
		 	Set IDRowID=objMap.MDCInfDiagDr.%Id()
		 	Set IDCode=objMap.MDCInfDiagDr.IDCode
		 	Set IDDesc=objMap.MDCInfDiagDr.IDDesc
		 	Set IDActive=objMap.MDCInfDiagDr.IDActive
		 	Set:IDActive'=1 IDDesc="*"_IDDesc
		 	
		 	Continue:'$IsObject(objMap.MDCInfDiagCatDr)
		 	Set IDCRowID=objMap.MDCInfDiagCatDr.%Id()
		 	Set IDCCode=objMap.MDCInfDiagCatDr.Code
		 	Set IDCDesc=objMap.MDCInfDiagCatDr.Description
		 	Set IDCActive=objMap.MDCInfDiagCatDr.Active
		 	Set:IDCActive'=1 IDCDesc="*"_IDCDesc
		 	Set IsChecked=1
		 	
		 	Set Data=$lb(MapID,IDRowID,IDCode,IDDesc,IDCRowID,IDCCode,IDCDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	
	Quit $$$OK
}

ClassMethod QryInfDiagCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiagCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiagCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiagCatExecute ]
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
