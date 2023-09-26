/// creator:lulin
/// createdate:2019-11-25
/// description:敏感指标获取HIS数据
Class web.NurSensHISComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:根据类型获取HIS科室或病区信息【对应单独登录版本的方法】
/// Date:2019-11-22
/// Table:
/// Input:
/// Output：
/// Others:d ##Class(%ResultSet).RunQuery("web.NurSensHISComm","FindCTLocList","","")
Query FindCTLocList(typ As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCTLocListExecute(ByRef qHandle As %Binary, typ As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s input=$zcvt(input,"U")
	s ret="",count=0
	s tmp=""
	//获取接口数据
	d ##class(web.NurSensDHCCHISComm).GetCTLocList(.tmp)
	s locid="" f  s locid=$O(tmp(locid)) q:locid=""  d
	.s tRet=tmp(locid)
	.s LocCode=$P(tRet,"^",2)
	.s LocDesc=$P(tRet,"^",3)
	.s LocType=$P(tRet,"^",4)
	.q:(input'="")&&($zcvt(LocDesc,"U")'[input)
	.q:(typ'="")&&(typ'=LocType)
	.s wardid=$O(^DHCNS.DB.NsWardI("CTLoc"," "_locid,""))
	.i wardid'="" s locflag="true"
	.e  s locflag="false"
	.s locId=$O(^DHCNS.DB.NsWardLocI("Loc",""_locid,""))
	.i wardid'="" s locflag="true"
	.e  s locflag="false"
	.s locContant=##class(web.NurSensUtilComm).ToChineseSpell(LocDesc)
	.s ret="LocId|"_locid_"^LocCode|"_LocCode_"^LocDesc|"_LocDesc_"^LocFlag|"_locflag_"^LocContant|"_locContant
	.d OutCTLocList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCTLocList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCTLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCTLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTLocListExecute ]
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

/// Creator:lulin
/// Description:根据HIS科室获取科室名称
/// Date:2019-11-22
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensHISComm).GetCTLocDescById(1)
ClassMethod GetCTLocDescById(locid As %String = "") As %String
{
	q:locid="" ""
	d ##class(web.NurSensDHCCHISComm).GetCTLocList(.tmp)
	s locDesc=$p($g(tmp(locid)),"^",3)
	q locDesc
}

/// Creator:lulin
/// Description:判断HIS工号和密码是否正确
/// Date:2019-11-26
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod ConfirmPassword(userCode As %String = "", password As %String = "") As %String
{
	q ##class(web.NurSensDHCCHISComm).ConfirmPassword(userCode,password)
}

}
