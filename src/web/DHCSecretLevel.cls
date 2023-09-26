Class web.DHCSecretLevel Extends websys.Abstract
{

Query Find(Code, Desc, Alias) As websys.Query(CONTAINID = 1, ROWSPEC = "LevelRowId:%String,LevelCode:%String,LevelDesc:%String,LevelAlias:%String")
{
}

/// by wuqk 2011-05-27 未完成，全查；RUDesc 响应单位 关系不清楚
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code, Desc, Alias) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set LevelRowId=""
	for {
		Set LevelRowId = $Order(^User.DHCSecretLevelD(LevelRowId))
		Quit:LevelRowId=""
		If $d(^User.DHCSecretLevelD(LevelRowId),g){
			Set LevelCode = $lg(g,2)
			Continue:(Code'="")&&(LevelCode'[Code)
			Set LevelDesc = $lg(g,3)
			Continue:(Desc'="")&&(LevelDesc'[Desc)
			Set LevelAlias = $lg(g,4)
			Continue:(Alias'="")&&(LevelAlias'[Alias)
			Set ^CacheTemp(repid,ind)=$lb(LevelRowId,LevelCode,LevelDesc,LevelAlias)
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod Save(RowId, Code, Desc, Alias)
{
	Quit:Code="" "代码不能为空"
	Quit:Desc="" "描述不能为空"
	Quit:Alias="" "别名不能为空"
	If RowId>0{
		Set Obj = ##class(User.DHCSecretLevel).%OpenId(RowId)
	}else{
		if $d(^User.DHCSecretLevelI("Code",$zu(28,Code,7))) Quit "CodeExist"
		Set Obj = ##class(User.DHCSecretLevel).%New()
	}
	Set Obj.LevelCode = Code
	Set Obj.LevelDesc = Desc
	Set Obj.LevelAlias = Alias
	Set sc = Obj.%Save()
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set rtn = Obj.%Id(),Obj=""
	Quit rtn
}

ClassMethod Del(RowId)
{
	Quit:RowId="" ""
	Quit:0=$d(^User.DHCSecretLevelD(RowId)) "NotExistRecord"
	set sc = ##class(User.DHCSecretLevel).%DeleteId(RowId)
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Quit RowId
}

/// 获得最低密级
ClassMethod GetLowLevel()
{
	Set SecretLevelCode=$O(^User.DHCSecretLevelI("Code",""))
	Quit:SecretLevelCode="" ""
	Set SecretLevelRowId=$O(^User.DHCSecretLevelI("Code",SecretLevelCode,""))
	Quit:+SecretLevelRowId=0 ""
	Set SecretLevelCode=$lg(^User.DHCSecretLevelD(SecretLevelRowId),2)
	Quit SecretLevelCode
}

}
