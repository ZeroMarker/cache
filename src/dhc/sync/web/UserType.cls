Class dhc.sync.web.UserType Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("dhc.sync.web.UserType","Find","","","")
Query Find(Code, Name, Active) As websys.Query(CONTAINID = 1, ROWSPEC = "TypeRowId:%String,TypeCode:%String,TypeName:%String,TypeActive:%String")
{
}

/// by wuqk 2011-05-27 未完成，全查；RUDesc 响应单位 关系不清楚
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code, Name, Active) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set TypeRowId=""
	for {
		Set TypeRowId = $Order(^dhcsyncUserTypeD(TypeRowId))
		Quit:TypeRowId=""
		If $d(^dhcsyncUserTypeD(TypeRowId),g){
			Set TypeCode = $lg(g,2)
			Continue:(Code'="")&&(TypeCode'[Code)
			Set TypeName = $lg(g,3)
			Continue:(Name'="")&&(TypeName'[Name)
			Set TypeActive = $lg(g,4)
			Continue:(Active'="")&&(TypeActive'=Active)
			Set $list(g,1)=TypeRowId
			Set ^CacheTemp(repid,ind)=g
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod Save(RowId, Code, Name, Active)
{
	If RowId>0{
		Set Obj = ##class(dhc.sync.data.UserType).%OpenId(RowId)
	}else{
		If $d(^dhcsyncUserTypeI("SyncUserTypeCode",Code))>0 {
			Quit "-100^"_Code_"已存在"
		}
		Set Obj = ##class(dhc.sync.data.UserType).%New()
	}
	Set Obj.Code = Code
	Set Obj.Name = Name
	Set Obj.IsValid=Active
	Set sc = Obj.%Save()
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set rtn = Obj.%Id(),Obj=""
	Quit rtn
}

ClassMethod Del(RowId)
{
	Quit:RowId="" ""
	set sc = ##class(dhc.sync.data.UserType).%DeleteId(RowId)
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Quit RowId
}

}
