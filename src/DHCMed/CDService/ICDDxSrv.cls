/// 名称 : DHCMed.CDService.ICDDxSrv
/// 描述 : 肿瘤诊断字典服务类 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2019-02-20
Class DHCMed.CDService.ICDDxSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-20
/// Description:  查询肿瘤诊断字典
/// Table：       DHCMed.CD.CRICDDx
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.ICDDxSrv","QryICDDx","")
Query QryICDDx(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,CRCode:%String,CRDesc:%String,FullName:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryICDDxExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	Set xCode = ""
	For{
		Set xCode = $o(^DHCMed.CD.CRICDDxI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCMed.CD.CRICDDxI("IndexCode",xCode,xID))
			Quit:xID=""
			
			Set objICD = ##class(DHCMed.CD.CRICDDx).GetObjById(xID)
			Continue:'$Isobject(objICD)
			Set IsActive = objICD.CRIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActDesc =$s(IsActive=1:"是",1:"否")
			Set Code     = $ZCVT(objICD.CRCode,"U")
			Set Desc     = objICD.CRDesc
			Set FullName = objICD.CRFullName
			Set FullName     = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.CD.CRICDDx","CRDesc","",FullName)
			Continue:((aAlias'="")&&(Code'[aAlias)&&(FullName'[aAlias))
		    Set Resume   = objICD.CRResume
			Set Data = $lb(xID,Code,Desc,FullName,IsActive,IsActDesc,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryICDDxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDxExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICDDxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDxExecute ]
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

/// Creator：     pylian
/// CreatDate：   2019-02-20
/// Description:  根据代码查询肿瘤诊断字典(用于根据部位编码查找诊断)
/// Table：       DHCMed.CD.CRICDDx
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.ICDDxSrv","QryICDByCode","")
Query QryICDByCode(aCode As %String, aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,CRCode:%String,CRDesc:%String,FullName:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryICDByCodeExecute(ByRef qHandle As %Binary, aCode As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set aCode = $ZCVT(aCode,"U")
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.CD.CRICDDxD(xID))
		Quit:xID=""
		Set objICD = ##class(DHCMed.CD.CRICDDx).GetObjById(xID)
		Continue:'$Isobject(objICD)
		Set IsActive = objICD.CRIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		Set IsActDesc =$s(IsActive=1:"是",1:"否")
		Set Code     = $ZCVT(objICD.CRCode,"U")
		Continue:(aCode'="")&&(aCode'=Code)
		Set Desc     = objICD.CRDesc
		Set FullName = objICD.CRFullName
	    Set Resume   = objICD.CRResume
		Set Data = $lb(xID,Code,Desc,FullName,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryICDByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICDByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDByCodeExecute ]
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
