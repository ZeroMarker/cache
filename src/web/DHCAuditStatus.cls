Class web.DHCAuditStatus Extends websys.Abstract
{

/// d ##class(%ResultSet).RunQuery("web.DHCEventModel","Find","","","","")
Query Find(Code, Desc) As websys.Query(CONTAINID = 1, ROWSPEC = "StatusRowId:%String,StatusCode:%String,StatusDesc:%String")
{
}

/// by wuqk 2011-05-27 未完成，全查；RUDesc 响应单位 关系不清楚
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code, Desc) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set StatusRowId=""
	for {
		Set StatusRowId = $Order(^User.DHCAuditStatusD(StatusRowId))
		Quit:StatusRowId=""
		If $d(^User.DHCAuditStatusD(StatusRowId),g){
			Set StatusCode = $lg(g,2)
			Continue:(Code'="")&&($zcvt(StatusCode,"U")'[$zcvt(Code,"U"))
			Set StatusDesc = $lg(g,3)
			Continue:(Desc'="")&&(StatusDesc'[Desc)
			Set ^CacheTemp(repid,ind)=$lb(StatusRowId,StatusCode,StatusDesc)
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod Save(RowId, Code, Desc)
{
	If RowId>0{
		Set Obj = ##class(User.DHCAuditStatus).%OpenId(RowId)
	}else{
		if $d(^User.DHCAuditStatusI("Code",$zu(28,Code,7))) Quit "CodeExist"
		Set Obj = ##class(User.DHCAuditStatus).%New()
	}
	Set Obj.StatusCode = Code
	Set Obj.StatusDesc = Desc
	Set sc = Obj.%Save()
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set rtn = Obj.%Id(),Obj=""
	Quit rtn
}

ClassMethod Del(RowId)
{
	Quit:RowId="" ""
	Quit:0=$d(^User.DHCAuditStatusD(RowId)) "NotExistRecord"
	set sc = ##class(User.DHCAuditStatus).%DeleteId(RowId)
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Quit RowId
}

}
