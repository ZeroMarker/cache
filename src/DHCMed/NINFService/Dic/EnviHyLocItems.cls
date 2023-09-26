/// 名称: DHCMed.NINFService.Dic.EnviHyLovItems
/// 描述: 环境卫生学项目关联科室的常用操作
/// 编写者：Jeff
/// 编写日期: 2014-07-04
Class DHCMed.NINFService.Dic.EnviHyLocItems Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     Jeff
/// CreatDate：   2014-07-04
/// Description:  保存环境卫生学项目和关联的科室
/// Table：       DHCMed.NINF.Dic.EnviHyLocItems
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.EnviHyLocItems).SaveRec("2^1^50000N/(AXT)^1^test","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	Set EHLILocDr=$p(aInput,aSeparate,2)
	Quit:EHLILocDr="" return
	Set return=##Class(DHCMed.NINF.Dic.EnviHyLocItems).Update(aInput,aSeparate)
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     Jeff
/// CreatDate：   2014-07-04
/// Description:  查询环境卫生学项目关联科室
/// Table：       DHCMed.NINFService.Dic.EnviHyLocItems
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyLocItems","QryEnviHyItemsByLoc","12","23")
Query QryEnviHyItemsByLoc(aLocID As %String, aIsActive As %String) As %Query(ROWSPEC = "EHLIID:%String,EnviHyLocID:%String,EnviHyLoc:%String,EnviHyItemID:%String,EnviHyItem:%String,EnviHyNorms:%String,EnviHyNormCnt:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QryEnviHyItemsByLocExecute(ByRef qHandle As %Binary, aLocID As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem",xLocID))
		Quit:xLocID=""
		Continue:(aLocID'="")&&(" "_aLocID'=xLocID)
		
		Set xItemID=0
		For {
			Set xItemID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem",xLocID,xItemID))
			Quit:xItemID=""
			
			Set xID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem",xLocID,xItemID,0))
			Continue:xID=""
			
			Set objEHLocItems=##class(DHCMed.NINF.Dic.EnviHyLocItems).GetObjById(xID)
			Continue:'$IsObject(objEHLocItems) 
			
			Set EnviHyLocID=objEHLocItems.EHLILocDr
			Continue:(aLocID'="")&&(EnviHyLocID'=aLocID)
			Set objEHLILocDr=##class(DHCMed.Base.Ctloc).GetObjById(EnviHyLocID)
			Quit:'$IsObject(objEHLILocDr)
			Set EnviHyLoc=objEHLILocDr.Descs
			
			Set objEHLIItemDr=objEHLocItems.EHLIItemDr
			Quit:'$IsObject(objEHLIItemDr)
			Set EnviHyItemID=objEHLIItemDr.%Id()
			Set EnviHyItem=objEHLIItemDr.EHIDesc
			
			Set EnviHyNorms=objEHLocItems.EHLINorms
			Set IsActive=objEHLocItems.EHLIIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActiveDesc=$s(IsActive=1:"是",IsActive=0:"否")
			Set ResumeText=objEHLocItems.EHLIResume
			
			If EnviHyNorms="" {
				Set EnviHyNormCnt="全部"
			} Else {
				Set EnviHyNormCnt=$l(EnviHyNorms,"#")_"项"
			}
			
			Set Data=$lb(xID,EnviHyLocID,EnviHyLoc,EnviHyItemID,EnviHyItem,EnviHyNorms,EnviHyNormCnt,IsActive,IsActiveDesc,ResumeText)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryEnviHyItemsByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyItemsByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnviHyItemsByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyItemsByLocExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  查询环境卫生学结果判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyLocItems","QryEnviHyNormsByLocItem","1","21","1")
Query QryEnviHyNormsByLocItem(aLocID As %String, aItemID As %String, aIsViewAll As %String) As %Query(ROWSPEC = "NormID:%String,EHNCateg:%String,SpecimenTypeID:%String,SpecimenType:%String,EHNRange:%String,EHNNorm:%String,ItemObj:%String,EHNNormMin:%String,EHNNormMax:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,IsActive:%String,IsLocNorm:%String")
{
}

ClassMethod QryEnviHyNormsByLocItemExecute(ByRef qHandle As %Binary, aLocID As %String, aItemID As %String, aIsViewAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aLocID="")||(aItemID="") $$$OK
 	
 	Set EHLocNorms="",EHLocItem=""
 	Set xEHLIID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem"," "_aLocID,aItemID,0))
 	If xEHLIID'="" {
	 	Set objEHLI=##class(DHCMed.NINF.Dic.EnviHyLocItems).GetObjById(xEHLIID)
	 	If $IsObject(objEHLI){
		 	Set EHLocNorms=objEHLI.EHLINorms  //#分隔
		 	Set EHLocItem=objEHLI.EHLIItemDr.%Id()
		}
 	}
 	
 	Set xMapID=0
 	For {
		Set xMapID=$o(^DHCMed.NINFD("EHI",aItemID,"MAP",xMapID))
		Quit:xMapID=""
		
		Set objMap=##class(DHCMed.NINF.Dic.EnviHyItmMap).GetObjById(aItemID_"||"_xMapID)
		Continue:'$IsObject(objMap)
		Set IsActive=objMap.EHIMIsActive
		Continue:IsActive'=1
		
		Set objNorm=objMap.EHIMNorm
		Continue:'$IsObject(objNorm)
		
		Set NormID=objNorm.%Id()
		If $IsObject(objNorm.EHNCateg){
			Set EHNCateg=objNorm.EHNCateg.Description
		}
		If $IsObject(objNorm.SpecimenType){
			Set SpecimenTypeID=objNorm.SpecimenType.%Id()
			Set SpecimenType=objNorm.SpecimenType.Description
		}
		Set EHNRange=objNorm.EHNRange
		Set EHNNorm=objNorm.EHNNorm
		Set IsActive=objNorm.EHNIsActive
		Set SpecimenNum=objNorm.SpecimenNum
		Set CenterNum=objNorm.CenterNum
		Set SurroundNum=objNorm.SurroundNum
		Set EHNNormMin=objNorm.EHNNormMin
		Set EHNNormMax=objNorm.EHNNormMax
		Set ItemObj=objNorm.ItemObj
		
		Set IsLocNorm=0
		Set tmpEHLocNorms="#"_EHLocNorms_"#"
		Set tmpNormID="#"_NormID_"#"
		Set:(tmpEHLocNorms[tmpNormID) IsLocNorm=1
		Continue:(aIsViewAll'=1)&&(IsLocNorm=0)
		
		Set Data=$lb(NormID,EHNCateg,SpecimenTypeID,SpecimenType,EHNRange,EHNNorm,ItemObj,EHNNormMin,EHNNormMax,SpecimenNum,CenterNum,SurroundNum,IsActive,IsLocNorm)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEnviHyNormsByLocItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyNormsByLocItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyNormsByLocItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyNormsByLocItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     Jeff
/// CreatDate：   2014-07-04
/// Description:  [下拉框]查询环境卫生学项目关联科室
/// Table：       DHCMed.NINFService.Dic.EnviHyLocItems
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyLocItems","QryEHItemsByLoc","1")
Query QryEHItemsByLoc(aLocID As %String) As %Query(ROWSPEC = "EnviHyItemID:%String,EnviHyItem:%String")
{
}

ClassMethod QryEHItemsByLocExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aLocID="" $$$OK
	
	Set EHLocItemsFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHLocItemsFlag","")
	Set EHLocItemsFlag=+EHLocItemsFlag
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCMed.NINFD("EHI",xItemID))
		Quit:xItemID=""
		
		If EHLocItemsFlag=1 {
			Set LocItemID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem"," "_aLocID,xItemID,0))
			Continue:LocItemID=""
			Set objEHLocItems=##class(DHCMed.NINF.Dic.EnviHyLocItems).GetObjById(LocItemID)
			Continue:'$IsObject(objEHLocItems)
			Set IsActive=objEHLocItems.EHLIIsActive
			Continue:IsActive'=1
		}
		
		Set objItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set EnviHyItem=objItem.EHIDesc
		Set IsActive=objItem.EHIActive
		Continue:IsActive'=1
		
		Set Data=$lb(xItemID,EnviHyItem)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEHItemsByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEHItemsByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEHItemsByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEHItemsByLocExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  查询环境卫生学结果判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyLocItems","QryEHNormsByLocItem","1","21","1")
Query QryEHNormsByLocItem(aLocID As %String, aItemID As %String) As %Query(ROWSPEC = "NormID:%String,EHNCateg:%String,SpecimenTypeID:%String,SpecimenType:%String,EHNRange:%String,EHNNorm:%String,ItemObj:%String,EHNNormMin:%String,EHNNormMax:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String")
{
}

ClassMethod QryEHNormsByLocItemExecute(ByRef qHandle As %Binary, aLocID As %String, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aLocID="")||(aItemID="") $$$OK
 	
 	Set EHLocNorms="",EHLocItem=""
 	Set xEHLIID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem"," "_aLocID,aItemID,0))
 	If xEHLIID'="" {
	 	Set objEHLI=##class(DHCMed.NINF.Dic.EnviHyLocItems).GetObjById(xEHLIID)
	 	If $IsObject(objEHLI){
		 	Set EHLocNorms=objEHLI.EHLINorms  //#分隔
		 	Set EHLocItem=objEHLI.EHLIItemDr.%Id()
		}
 	}
 	
	Set EHLocItemsFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINF-EHLocItemsFlag","")
	Set EHLocItemsFlag=+EHLocItemsFlag
	
 	Set xMapID=0
 	For {
		Set xMapID=$o(^DHCMed.NINFD("EHI",aItemID,"MAP",xMapID))
		Quit:xMapID=""
		
		Set objMap=##class(DHCMed.NINF.Dic.EnviHyItmMap).GetObjById(aItemID_"||"_xMapID)
		Continue:'$IsObject(objMap)
		Set IsActive=objMap.EHIMIsActive
		Continue:IsActive'=1
		Set IsActive=objMap.ParRef.EHIActive
		Continue:IsActive'=1
		
		Set objNorm=objMap.EHIMNorm
		Continue:'$IsObject(objNorm)
		
		Set NormID=objNorm.%Id()
		If $IsObject(objNorm.EHNCateg){
			Set EHNCateg=objNorm.EHNCateg.Description
		}
		If $IsObject(objNorm.SpecimenType){
			Set SpecimenTypeID=objNorm.SpecimenType.%Id()
			Set SpecimenType=objNorm.SpecimenType.Description
		}
		Set EHNRange=objNorm.EHNRange
		Set EHNNorm=objNorm.EHNNorm
		Set IsActive=objNorm.EHNIsActive
		Continue:IsActive'=1
		Set SpecimenNum=objNorm.SpecimenNum
		Set CenterNum=objNorm.CenterNum
		Set SurroundNum=objNorm.SurroundNum
		Set EHNNormMin=objNorm.EHNNormMin
		Set EHNNormMax=objNorm.EHNNormMax
		Set ItemObj=objNorm.ItemObj
		
		If EHLocItemsFlag=1 {
			Set IsLocNorm=0
			If EHLocNorms'="" {
				Set tmpEHLocNorms="#"_EHLocNorms_"#"
				Set tmpNormID="#"_NormID_"#"
				Set:(tmpEHLocNorms[tmpNormID) IsLocNorm=1
			} ElseIf EHLocItem'="" {
				Set IsLocNorm=1
			} Else {}
			Continue:IsLocNorm'=1
		}
		
		Set Data=$lb(NormID,EHNCateg,SpecimenTypeID,SpecimenType,EHNRange,EHNNorm,ItemObj,EHNNormMin,EHNNormMax,SpecimenNum,CenterNum,SurroundNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEHNormsByLocItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEHNormsByLocItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEHNormsByLocItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEHNormsByLocItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
