Class web.DHCEventModel Extends websys.Abstract
{

/// d ##class(%ResultSet).RunQuery("web.DHCEventModel","Find","ANOPPri","","","")
Query Find(Code, Desc, Type, Active) As websys.Query(CONTAINID = 1, ROWSPEC = "ModelRowId:%String,ModelActive:%String,ModelCode:%String,ModelDesc:%String,ModelFiledSet:%String,ModelNote:%String,ModelType:%String")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code, Desc, Type, Active) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set ModelRowId=""
	Set Code = $zcvt(Code,"U")
	for {
		Set ModelRowId = $Order(^User.DHCEventModelD(ModelRowId))
		Quit:ModelRowId=""
		If $d(^User.DHCEventModelD(ModelRowId),g){
			Set ModelCode = $lg(g,2)
			Set ModelDesc = $lg(g,3)
			// 2020-05-12 审计界面-模块放大镜-查询代码或描述
			Continue:(Code'="")&&($zcvt(ModelCode,"U")'[Code)&&($zcvt(ModelDesc,"U")'[Code)
			Continue:(Desc'="")&&(ModelDesc'[Desc)
			Set ModelActive = $lg(g,4)
			Continue:(Active'="")&&(ModelActive'=Active)
			Set ModelType = $lg(g,5)
			Set ModelTypeDesc = ..GetTypeDesc(ModelType)
			Continue:(Type'="")&&(ModelType'=Type)&&(ModelTypeDesc'=Type)
			set ModelType=ModelTypeDesc
			Set ModelFiledSet = $tr($lg(g,6),$C(0),"")
			Set ModelNote = $tr($lg(g,7),$C(0),"")
			Set ^CacheTemp(repid,ind)=$lb(ModelRowId,ModelActive,ModelCode,ModelDesc,ModelFiledSet,ModelNote,ModelType)
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod Save(RowId, Code, Desc, Active, FiledSet, Note, Type)
{
	If RowId>0{
		Set Obj = ##class(User.DHCEventModel).%OpenId(RowId)
	}else{
		if $d(^User.DHCEventModelI("Code",$zu(28,Code,7))) Quit "CodeExist"
		Set Obj = ##class(User.DHCEventModel).%New()
	}
	Set Obj.ModelActive = Active
	Set Obj.ModelCode = Code
	Set Obj.ModelDesc = Desc
	Set Obj.ModelFiledSet = FiledSet
	Set Obj.ModelNote = Note
	Set Obj.ModelType = ..GetTypeCode(Type)
	Set sc = Obj.%Save()
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set rtn = Obj.%Id(),Obj=""
	Quit rtn
}

ClassMethod Del(RowId)
{
	Quit:RowId="" ""
	Quit:0=$d(^User.DHCEventModelD(RowId)) "NotExistRecord"
	set sc = ##class(User.DHCEventModel).%DeleteId(RowId)
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Quit RowId
}

ClassMethod GetTypeDesc(Code)
{
	Quit $case(Code,"Q":"查询","L":"登录","V":"浏览","P":"打印","O":"操作",:Code)
}

ClassMethod GetTypeCode(Desc)
{
	Quit $case(Desc,"查询":"Q","登录":"L","浏览":"V","打印":"P","操作":"O",:Desc)
}

ClassMethod GetTypeJson()
{
	Set json = ##class(ext.util.JsonObject).%New()
	Set rtn = json.Put("Code","L").Put("Desc","登录").Json()
	Set rtn = rtn_","_json.Put("Code","P").Put("Desc","打印").Json()
	Set rtn = rtn_","_json.Put("Code","Q").Put("Desc","查询").Json()
	Set rtn = rtn_","_json.Put("Code","V").Put("Desc","浏览").Json()
	Set rtn = rtn_","_json.Put("Code","O").Put("Desc","操作").Json()
	Do json.Clear()
	Set json=""
	Quit "["_rtn_"]"
}

/// @return 0表示未激活. 其它表示激活
ClassMethod ValidModelCode(ModelCode)
{
	Quit:ModelCode="" 0
	Set ModelCode = $zu(28,ModelCode,7,32768)
	Set ModelId = $O(^User.DHCEventModelI("Code",ModelCode,""))
	Quit:+ModelId=0 0
	Set ModelActive = $lg(^User.DHCEventModelD(ModelId),4)
	Quit:ModelActive'="Y" 0
	Quit ModelId
}

}
