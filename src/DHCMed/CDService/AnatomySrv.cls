/// 名称 : DHCMed.CDService.AnatomySrv
/// 描述 : 解剖学编码字典服务类 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2020-02-25
Class DHCMed.CDService.AnatomySrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-02-25
/// Description:  查询解剖学编码字典
/// Table：       DHCMed.CD.CRAnatomy
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.AnatomySrv","QryAnatomy","")
Query QryAnatomy(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,CRCode:%String,CRDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryAnatomyExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCMed.CD.CRAnatomyI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCMed.CD.CRAnatomyI("IndexCode",xCode,xID))
			Quit:xID=""
			
			Set obj = ##class(DHCMed.CD.CRAnatomy).GetObjById(xID)
			Continue:'$Isobject(obj)
			Set IsActive = obj.CRIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActDesc =$s(IsActive=1:"是",1:"否")
			Set Code     = $ZCVT(obj.CRCode,"U")
			Set Desc     = obj.CRDesc
			Continue:((aAlias'="")&&(Code'[aAlias)&&(Desc'[aAlias))
			Set Resume   = obj.CRResume
			Set Data = $lb(xID,Code,Desc,IsActive,IsActDesc,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	
	
	Quit $$$OK
}

ClassMethod QryAnatomyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAnatomyExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAnatomyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAnatomyExecute ]
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
