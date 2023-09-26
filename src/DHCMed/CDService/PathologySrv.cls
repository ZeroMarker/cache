/// 名称 : DHCMed.CDService.PathologySrv
/// 描述 : 病理类型字典服务类 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2019-02-20
Class DHCMed.CDService.PathologySrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-20
/// Description:  查询病理类型字典
/// Table：       DHCMed.CD.CRPathology
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.PathologySrv","QryPathology","")
Query QryPathology(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,CRCode:%String,CRDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryPathologyExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.CD.CRPathologyD(xID))
		Quit:xID=""
		
		Set obj = ##class(DHCMed.CD.CRPathology).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set IsActive = obj.CRIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		Set IsActDesc =$s(IsActive=1:"是",1:"否")
		Set Code     = $ZCVT(obj.CRCode,"U")
		Set Desc     = obj.CRDesc
		Set Desc     = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.CD.CRPathology","CRDesc","",Desc)
		Continue:((aAlias'="")&&(Code'[aAlias)&&(Desc'[aAlias))
		Set Resume   = obj.CRResume
		Set Data = $lb(xID,Code,Desc,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPathologyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathologyExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPathologyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathologyExecute ]
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

}
