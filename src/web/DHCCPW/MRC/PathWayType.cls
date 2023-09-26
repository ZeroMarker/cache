/// 名称: web.DHCCPW.MRC.PathWayType
/// 描述：对临床路径类型的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-04-26
Class web.DHCCPW.MRC.PathWayType Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  根据ID取临床路径类型字典
/// Table：       User.DHCMRCClinPathType
/// Input：       ID:    User.DHCMRCClinPathType.Id
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.PathWayType).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathType
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathType).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-04-26
/// Description:此Query是用来得到临床路径类型的全部记录
/// Table:User.DHCMRCClinPathType
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWayType","GetPathWayType")
Query GetPathWayType(DescArg As %String) As %Query(ROWSPEC = "Rowid:%String,code:%String,desc:%String")
{
}

ClassMethod GetPathWayTypeExecute(ByRef qHandle As %Binary, DescArg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	s DescArg=$g(DescArg) 
	Set TypeID=0
	For {
		Set TypeID=$o(^DHCMRC("CLPT",TypeID))
		Quit:TypeID=""
		Set objType=..GetObjById(TypeID)
		If $IsObject(objType){
			Set Code=objType.CLPTCode
			Set Desc=objType.CLPTDesc
			continue:Desc'[DescArg
			Set Data=$lb(TypeID,Code,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetPathWayTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWayTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPathWayTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWayTypeExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCCPW.MRC.PathWayType).CheckTypeCode("01",2)
ClassMethod CheckTypeCode(argCode As %String, argTypeID As %String)
{
	New (argCode,argTypeID)
	Set return=0
	Quit:argCode="" return
	
	Set TypeID=0
	For {
		Set TypeID=$o(^DHCMRC("CLPT",TypeID))
		Quit:(TypeID="")||(return=1)
		Continue:(argTypeID'="")&&(argTypeID=TypeID)
		Set objType=..GetObjById(TypeID)
		If $IsObject(objType){
			Set Code=objType.CLPTCode
			Set Desc=objType.CLPTDesc
			Continue:argCode'=Code
			Set return=1
		}
	}
	
	Quit return
}

ClassMethod AddType(argCode As %String, argDesc As %String)
{
	New (argCode,argDesc)
	Set return=-1
	Quit:(argCode="")||(argDesc="") return
	
	Set argDesc=$tr(argDesc,"^","")
	Set InputStr=""_"^"_argCode_"^"_argDesc
	Set return=..Update(InputStr)
	Quit return
}

ClassMethod UpdateType(argID As %String, argCode As %String, argDesc As %String)
{
	New (argID,argCode,argDesc)
	Set return=-1
	Quit:(argID="")||(argCode="")||(argDesc="") return
	
	Set argCode=$tr(argCode,"^","")
	Set argDesc=$tr(argDesc,"^","")
	Set InputStr=argID_"^"_argCode_"^"_argDesc
	Set return=..Update(InputStr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-01-29
/// Description:  更新User.DHCMRCClinPathType
/// Table：       User.DHCMRCClinPathType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCCPW.MRC.PathWayType).Update("Rowid^Code^Desc")
ClassMethod Update(argInStr As %String) As %String
{
	new (argInStr)
	set return=-1
	set id=$p(argInStr,"^",1)
	if id="" {
		set obj=##class(User.DHCMRCClinPathType).%New()
	} else {
		set obj=##class(User.DHCMRCClinPathType).%OpenId(id)
		quit:obj="" return
	}
	set obj.CLPTCode=$p(argInStr,"^",2)
	set obj.CLPTDesc=$p(argInStr,"^",3)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// w ##class(web.DHCCPW.MRC.PathWayType).DeleteType(2)
ClassMethod DeleteType(argId As %String)
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRCClinPathType).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// w ##class(web.DHCCPW.MRC.PathWayType).GetAllType()
ClassMethod GetAllType() As %String
{
	New
	Set return=""
	
	Set TypeID=0
	For {
		Set TypeID=$o(^DHCMRC("CLPT",TypeID))
		Quit:TypeID=""
		Set objType=..GetObjById(TypeID)
		If $IsObject(objType){
			Set Code=objType.CLPTCode
			Set Desc=objType.CLPTDesc
			Set Desc=$tr(Desc,"^","")
			Set Desc=$tr(Desc,$c(0),"")
			Set Desc=$tr(Desc,$c(10),"")
			Set Desc=$tr(Desc,$c(13),"")
			Set return=return_","_TypeID_"^"_Desc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

}
