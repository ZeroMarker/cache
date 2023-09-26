/// 名称: DHCMed.NINFService.Aim.CtlocOperSrv
/// 描述: 目标性监测主题关联科室
/// 编写者：lyh
/// 编写日期: 2012-08-17
Class DHCMed.NINFService.Aim.CtlocOperSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 通过目标性监测主题获取关联科室信息
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.CtlocOperSrv","QryLocActiveByType","ICU")
Query QryLocActiveByType(AimType As %String = "", LocType As %String) As %Query(ROWSPEC = "LocID:%String,Type:%String,LocDesc:%String,IsActive:%String")
{
}

ClassMethod QryLocActiveByTypeExecute(ByRef qHandle As %Binary, AimType As %String = "", LocType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:AimType="" $$$OK
	
	s LocID=0
	f  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	.s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
	.q:'$IsObject(LocObj)
	.s Type=LocObj.Type
	.q:(LocType'="")&(Type'=LocType)
	.s LocDesc=LocObj.Descs
	.s IsActive="N"
	.s:$d(^DHCMed.NINF.Aim.CtlocOperI("AimType"," "_AimType," "_LocID," Y")) IsActive="Y"
	.s Data=$lb(LocID,Type,LocDesc,IsActive)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QryLocActiveByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocActiveByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocActiveByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocActiveByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 更新目标性监测主题关联科室
ClassMethod UpdateCtlocOperInfo(InStr As %String) As %String
{
	n (InStr)	
	
	s ret="",ID=""
	
	s AimType=$p(InStr,"^",2)
	s CtlocID=$p(InStr,"^",3)
	s IsActive=$p(InStr,"^",4)
	
	q:(AimType="")||(CtlocID="")||(IsActive="") ret
	
	s:IsActive'="Y" IsActive="N"
	
	i $d(^DHCMed.NINF.Aim.CtlocOperI("TypeLoc"," "_AimType," "_CtlocID)) d
	.s ID=$o(^DHCMed.NINF.Aim.CtlocOperI("TypeLoc"," "_AimType," "_CtlocID,""),-1)
	
	s ret=##class(DHCMed.NINF.Aim.CtlocOper).Update(ID_"^"_AimType_"^"_CtlocID_"^"_IsActive)
	
	q ret
}

/// 判断科室是否有目标性监测报告权限
ClassMethod IsAimLoc(AimType As %String, LocID As %String) As %String
{
	n (AimType,LocID)
	
	s ret=-1
	
	q:(AimType="")||(LocID="") ret
	
	s:$d(^DHCMed.NINF.Aim.CtlocOperI("AimType"," "_AimType," "_LocID," Y")) ret=1
	
	q ret
}

}
