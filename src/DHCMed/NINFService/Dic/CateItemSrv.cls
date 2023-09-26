/// 名称: DHCMed.NINFService.Dic.CateItemSrv
/// 描述: 分类项目的常用操作
/// 编写者：zhufei
/// 编写日期: 2013-06-23
Class DHCMed.NINFService.Dic.CateItemSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-23
/// Description:  查询分类项目列表
/// Table：       DHCMed.NINF.Dic.CateItem
/// Input：       aCateCode 分类代码
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.CateItemSrv","QryCateItemByCate","")
Query QryCateItemByCate(aCateCode As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String,ItemCateCode:%String,ItemActive:%String,ItemResume:%String")
{
}

ClassMethod QryCateItemByCateExecute(ByRef qHandle As %Binary, aCateCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCateCode="" $$$OK
 	
 	Set xItemCode=""
 	For {
	 	Set xItemCode=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(aCateCode,"U"),xItemCode))
	 	Quit:xItemCode=""
	 	
	 	Set xItemID=0
	 	For {
			Set xItemID=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(aCateCode,"U"),xItemCode,xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCMed.NINF.Dic.CateItem).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			
			Set ItemCode=objItem.Code
			Set ItemDesc=objItem.Description
			Set ItemCateCode=objItem.Category
			Set ItemActive=objItem.Active
			Set ItemResume=objItem.ResumeText
			
			Set Data=$lb(xItemID,ItemCode,ItemDesc,ItemCateCode,ItemActive,ItemResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryCateItemByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCateItemByCateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCateItemByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCateItemByCateExecute ]
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
/// CreatDate：   2012-06-23
/// Description:  查询项目字典列表
/// Table：       
/// Input：       aCateCode 分类代码     aAlias 别名
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.CateItemSrv","QryItemDicByType","MDRPY001","弗氏耶尔森菌")
Query QryItemDicByType(aCateCode As %String, aAlias As %String) As %Query(ROWSPEC = "DicID:%String,DicCode:%String,DicDesc:%String,DicActive:%String,DicResume:%String")
{
}

ClassMethod QryItemDicByTypeExecute(ByRef qHandle As %Binary, aCateCode As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCateCode="" $$$OK
 	
 	If $e(aCateCode,1,6)="MDRANT" {
	 	//update by zf 20160308 数据池相关程序修改(检验)
		Set xID=0
		For {
			Set xID=$o(^DHCMed.DC.LIS.BTAntibioticsD(xID))
			Quit:xID=""
			
			Set obj=##class(DHCMed.DC.LIS.BTAntibiotics).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.Active'=1
			Set AntiCode=obj.Code
			Set AntiName=obj.CName
			Continue:(aAlias'="")&&($zcvt(AntiName,"U")'[$zcvt(aAlias,"U"))
			
			Continue:$d(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(aCateCode,"U")," "_$zcvt(AntiCode,"U")))
			
			Set Data=$lb(AntiCode,AntiCode,AntiName,1,"")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} ElseIf $e(aCateCode,1,5)="MDRPY" {
		//update by zf 20160308 数据池相关程序修改(检验)
		Set xID=0
		For {
			Set xID=$o(^DHCMed.DC.LIS.BTOrganismD(xID))
			Quit:xID=""
			
			Set obj=##class(DHCMed.DC.LIS.BTOrganism).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.Active'=1
			Set PyCode=obj.Code
			Set PyName=obj.CName
			Continue:(aAlias'="")&&($zcvt(PyName,"U")'[$zcvt(aAlias,"U"))
			
			Continue:$d(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(aCateCode,"U")," "_$zcvt(PyCode,"U")))
			
			Set Data=$lb(PyCode,PyCode,PyName,1,"")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		
	}
 	
	Quit $$$OK
}

ClassMethod QryItemDicByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemDicByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemDicByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemDicByTypeExecute ]
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
