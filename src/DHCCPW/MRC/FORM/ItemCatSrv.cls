/// 名称: DHCCPW.MRC.FORM.ItemCatSrv
/// 描述: 临床路径表单项目分类相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-11
Class DHCCPW.MRC.FORM.ItemCatSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:      zhufei
/// CreatDate:    2015-06-11
/// Description:  查询表单项目分类（大类+子类）
/// Table:        User.DHCMRCStepItemSubCategory
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.ItemCatSrv","QryItemSubCat","")
Query QryItemSubCat(aCatID As %String) As %Query(ROWSPEC = "SCID:%String,SCCode:%String,SCDesc:%String,SCDateFrom:%String,SCDateTo:%String,SCPower:%String,SCPowerDesc:%String,CatID:%String,CatDesc:%String")
{
}

ClassMethod QryItemSubCatExecute(ByRef qHandle As %Binary, aCatID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCatID=0
	For {
		Set xCatID=$o(^DHCMRC("SIC",xCatID))
		Quit:xCatID=""
		Continue:(aCatID'="")&&(aCatID'=xCatID)
		
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMRC("SIC",xCatID,"SUB",xSubID))
			Quit:xSubID=""
			
			Set SCID=xCatID_"||"_xSubID
			Set objSubCat=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(SCID)
			Continue:'$IsObject(objSubCat)
			
			Set SCCode=objSubCat.SISCCode
			Set SCDesc=objSubCat.SISCDesc
			Set SCDateFrom=objSubCat.SISCDateFrom
			Set SCDateTo=objSubCat.SISCDateTo
			Continue:(SCDateFrom'="")&&(SCDateFrom>+$h)
			Continue:(SCDateTo'="")&&(SCDateTo<+$h)
			Set:SCDateFrom'="" SCDateFrom=$zd(SCDateFrom,3)
			Set:SCDateTo'="" SCDateTo=$zd(SCDateTo,3)
			Set SCPower=objSubCat.SISCPower
			Set SCPowerDesc=##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("ItemSubCatPower",SCPower)
			Set CatDesc=objSubCat.SISCParRef.SICDesc
			
			Set Data=$lb(SCID,SCCode,SCDesc,SCDateFrom,SCDateTo,SCPower,SCPowerDesc,xCatID,CatDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryItemSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemSubCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryItemSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemSubCatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
