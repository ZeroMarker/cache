/// 名称: DHCMed.NINFService.Dic.HandHyProducts
/// 描述: 手卫生用品维护
/// 编写者：zhufei
/// 编写日期: 2012-07-19
Class DHCMed.NINFService.Dic.HandHyProducts Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-07-19
/// Description:  查询手卫生用品
/// Table：       DHCMed.NINF.Dic.HandHyProducts
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.HandHyProducts","QryHandHyProducts","","")
Query QryHandHyProducts(aCode As %String, aDesc As %String) As %Query(ROWSPEC = "HHPID:%String,HHPCode:%String,HHPDesc:%String,HHPDesc1:%String,HHPPinyin:%String,HHPSpec:%String,HHPUnit:%String,HHPActive:%String,HHPActiveDesc:%String,HHPResume:%String,HHPGroupID:%String,HHPGroupDesc:%String")
{
}

ClassMethod QryHandHyProductsExecute(ByRef qHandle As %Binary, aCode As %String, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aCode=$zcvt(aCode,"U")
 	Set aDesc=$zcvt(aDesc,"U")
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFD("HHP",xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMed.NINF.Dic.HandHyProducts).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set HHPCode=obj.HHPCode
	 	Continue:(aCode'="")&&(HHPCode'[aCode)
	 	Set HHPDesc=obj.HHPDesc
	 	Continue:(aDesc'="")&&($zcvt(HHPDesc,"U")'[aDesc)
	 	Set HHPDesc1=obj.HHPDesc1
	 	Set HHPPinyin=obj.HHPPinyin
	 	Set HHPSpec=obj.HHPSpec
	 	Set HHPUnit=obj.HHPUnit
	 	Set HHPActive=obj.HHPActive
	 	Set HHPActiveDesc=$s(HHPActive=1:"是",1:"否")
	 	Set HHPResume=obj.HHPResume
	 	If $IsObject(obj.HHPGroup) {
		 	Set HHPGroupID=obj.HHPGroup.%Id()
		 	Set HHPGroupDesc=obj.HHPGroup.Description
		} Else {
			Set HHPGroupID=""
		 	Set HHPGroupDesc=""
		}
	 	
	 	Set Data=$lb(xID,HHPCode,HHPDesc,HHPDesc1,HHPPinyin,HHPSpec,HHPUnit,HHPActive,HHPActiveDesc,HHPResume,HHPGroupID,HHPGroupDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHandHyProductsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyProductsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHandHyProductsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyProductsExecute ]
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
/// CreatDate：   2013-07-22
/// Description:  查询手卫生用品
/// Table：       DHCMed.NINF.Dic.HandHyProducts
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.HandHyProducts","QryHHPToCombo","",1)
Query QryHHPToCombo(aAlias As %String, aActive As %String = "1") As %Query(ROWSPEC = "HHPID:%String,HHPCode:%String,HHPDesc:%String,HHPDescX:%String,HHPDesc1:%String,HHPPinyin:%String,HHPSpec:%String,HHPUnit:%String,HHPActive:%String,HHPActiveDesc:%String,HHPResume:%String") [ SqlProc ]
{
}

ClassMethod QryHHPToComboExecute(ByRef qHandle As %Binary, aAlias As %String, aActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aAlias=$zcvt(aAlias,"U")
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFD("HHP",xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMed.NINF.Dic.HandHyProducts).GetObjById(xID)
	 	Continue:'$IsObject(obj)
		Set HHPCode=obj.HHPCode
	 	Set HHPDesc=obj.HHPDesc
	 	Set HHPDesc1=obj.HHPDesc1
	 	Set HHPPinyin=obj.HHPPinyin
		Continue:(aAlias'="")&&(HHPCode'[aAlias)&&(HHPPinyin'[aAlias)&&($zcvt(HHPDesc,"U")'[aAlias)
	 	Set HHPSpec=obj.HHPSpec
	 	Set HHPUnit=obj.HHPUnit
	 	Set HHPActive=obj.HHPActive
	 	Continue:(aActive'="")&&(HHPActive'=aActive)
	 	Set HHPActiveDesc=$s(HHPActive=1:"是",1:"否")
	 	Set HHPResume=obj.HHPResume
	 	Set HHPDescX=HHPDesc_"("_HHPSpec_")"
	 	
	 	Set Data=$lb(xID,HHPCode,HHPDesc,HHPDescX,HHPDesc1,HHPPinyin,HHPSpec,HHPUnit,HHPActive,HHPActiveDesc,HHPResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHHPToComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHHPToComboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHHPToComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHHPToComboExecute ]
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
