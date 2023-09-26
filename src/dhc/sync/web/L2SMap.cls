Class dhc.sync.web.L2SMap Extends %RegisteredObject
{

ClassMethod Save(LocCode, SystemCode)
{
	Quit:LocCode="" ""
	Quit:SystemCode="" ""
	ts
	Set RowId = $O(^dhcsyncL2SMapI("L2SMapIndex",LocCode,SystemCode,""))
	If RowId>0 {
		Set Obj = ##class(dhc.sync.data.L2SMap).%OpenId(RowId)
		Set OperateType = "U" ;Upd
		Set State = 3 ;修改
	}Else {
		 Set Obj = ##class(dhc.sync.data.L2SMap).%New()
		 Set Obj.SystemCode = SystemCode
		 Set Obj.LocCode = LocCode
		Set OperateType="A" ;Add
		Set State = 1	;新增
	}
	Set Obj.State = State
	Set sc = Obj.%Save()
	If $$$ISERR(sc) tro  Set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set RowId = Obj.%Id(),Obj=""
	Set State = $case(State,3:"修改",1:"新增",2:"删除",:State)
	Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("dhc.sync.data.L2SMap","dhc.sync.web.L2SMap","科室同步成功" ,
		LocCode,"科室同步到"_SystemCode_"系统",OperateType,State) 
	If rtn="添加失败!" tro  quit "-100^SaveChangeLog"
	tc
	Quit RowId
}

}
