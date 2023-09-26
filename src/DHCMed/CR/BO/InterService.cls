/// 名称: DHCMed.CR.BO.InterService
/// 描述: 外部接口服务
/// 编写者：wuqk
/// 编写日期: 2012-12-03
Class DHCMed.CR.BO.InterService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2012-12-03
/// Description:  根据接口Id获取接口对象
/// Table：       DHCMed.CR.PO.Interface
/// Input：       dicId：接口Id
/// Return：      
/// w ##class(DHCMed.CR.BO.InterService).getObjectById(1)
ClassMethod getObjectById(id As %String) As DHCMed.CR.PO.Interface
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CR.PO.Interface).%ExistsId(+id) return
	set obj=##Class(DHCMed.CR.PO.Interface).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2012-11-30
/// Description:  根据接口代码判断接口是否存在
/// Table：       DHCMed.CR.PO.Interface
/// Input：       InterfaceCode：接口代码
/// Return：      
/// w ##class(DHCMed.CR.BO.InterService).getIdByCode("SSUser")
ClassMethod getIdByCode(InterfaceCode As %String) As %Integer
{
	new (InterfaceCode)
	quit:InterfaceCode="" 0
	quit:'$d(^DHCMed.CR.PO.InterfaceI("InterfaceCodeIndex"," "_$ZCVT(InterfaceCode,"U"))) 0
	set id = $o(^DHCMed.CR.PO.InterfaceI("InterfaceCodeIndex"," "_$ZCVT(InterfaceCode,"U"),""))
	quit id
}

/// Creator：     wuqk
/// CreatDate：   2012-11-30
/// Description:  根据接口代码获取接口对象
/// Table：       DHCMed.CR.PO.Interface
/// Input：       InterfaceCode：接口代码
/// Return：      
/// w ##class(DHCMed.CR.BO.InterService).getObjectByCode("SSUser")
ClassMethod getObjectByCode(InterfaceCode As %String) As DHCMed.CR.PO.Interface
{
	new (InterfaceCode)
	set return=""
	set id=..getIdByCode(InterfaceCode)
	quit:id=0 return
	set return=..getObjectById(id)
	quit return
}

/// 名称: QueryPropertyByCode
/// 描述: 查询接口返回类的属性列表
/// 编写者：wuqk
/// Input : 
///        InterfaceCode 接口代码
/// Table : DHCMed.CR.PO.Interface
/// Output ：
/// 编写日期: 2012-12-03
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.BO.InterService","QueryPropertyByCode","SSUser")
Query QueryPropertyByCode(InterfaceCode As %String) As %Query(ROWSPEC = "PropertyName:%String,Description:%String")
{
}

ClassMethod QueryPropertyByCodeExecute(ByRef qHandle As %Binary, InterfaceCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set objInterface = ..getObjectByCode(InterfaceCode)
 	quit:'$IsObject(objInterface) $$$OK
 	
 	set returnType = objInterface.ReturnType
 	quit:'##class(%Dictionary.CompiledClass).%ExistsId(returnType) $$$OK
 	set dcc = ##class(%Dictionary.CompiledClass).%OpenId(returnType)
 	
 	set cnt = dcc.Properties.Count()
 	for i=1:1:cnt {
	 	set pdef=dcc.Properties.GetAt(i)
		set propertyName=pdef.Name
		//w !,propertyName
		continue:propertyName["%"
		set Description=$p(pdef.Description," ")
		set:Description="" Description=propertyName
		set ^CacheTemp(repid,ind)=$lb(propertyName,Description)
		set ind=ind+1
	 } 	
 	
	Quit $$$OK
}

ClassMethod QueryPropertyByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPropertyByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPropertyByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPropertyByCodeExecute ]
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

/// Creator：     mxp
/// CreatDate：   2012-12-14
/// Description:  根据ID获取接口信息
/// Table：       DHCMed.CR.PO.Interface
/// Input：       ID:    接口ID
///               separete: 指定的分隔符
/// Return：      字符串形式的接口信息
/// w ##class(DHCMed.CR.BO.InterService).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..getObjectById(id)
	set:$g(separete)="" separete="^"
	if $IsObject(obj){
		set return=obj.%Id()_separete
		set return=return_obj.CategoryCode_separete
		set return=return_obj.InterfaceCode_separete
		set return=return_obj.InterfaceName_separete
		set return=return_obj.Arguments_separete
		set return=return_obj.InterfaceClassMethod_separete
		set return=return_obj.ReturnType_separete
		set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRFInterfaceCate",obj.CategoryCode,"1")
		set CategoryName=objDic.Description
		set return=return_CategoryName
		;set return=obj.ToString($g(separete))
	}	
	quit return
}

///  Creator：     mxp
///  CreatDate：   2012-12-14
///  Description:  保存外部接口
///  Table：       DHCMed.CR.PO.Interface
///  Input：       各属性列表 ^分隔
///  Return：      成功：返回id，失败：返回<0的代码
///  d ##class(DHCMed.CR.BO.InterService).update()
ClassMethod update(InStr)
{
	New (InStr)
	Set return=0
	Quit:InStr="" return
	
	Set separete="^"
	Set ID=$p(InStr,separete,1)
	Set InterfaceCode=$p(InStr,separete,3)

	Set:ID="" ID=$o(^DHCMed.CR.PO.InterfaceI("InterfaceCodeIndex"," "_$ZCVT(InterfaceCode,"U"),0))
	
	If ID="" {
		Set obj=##class(DHCMed.CR.PO.Interface).%New()
	}Else{
		Set obj=##class(DHCMed.CR.PO.Interface).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CategoryCode=$p(InStr,separete,2)
	Set obj.InterfaceCode=InterfaceCode
	Set obj.InterfaceName=$p(InStr,separete,4)
	Set obj.Arguments=$p(InStr,separete,5)
	Set obj.InterfaceClassMethod=$p(InStr,separete,6)
	Set obj.ReturnType=$p(InStr,separete,7)
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     maxp
/// CreatDate：   2012-12-17
/// Description:  查询函数信息
/// Table：       DHCMed.CR.PO.Interface
/// Input:		  
/// Output:       ID,CategoryCode,InterfaceCode,InterfaceName,Arguments,ClassMethod,ReturnType
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.BO.InterService","QueryAllInterfaces")
Query QueryAllInterfaces(dicCode As %String, dicName As %String) As %Query(ROWSPEC = "ID:%String,CategoryName:%String,InterfaceCode:%String,InterfaceName:%String,Arguments:%String,ClassMethod:%String,ReturnType:%String")
{
}

ClassMethod QueryAllInterfacesExecute(ByRef qHandle As %Binary, dicCode As %String, dicName As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    s id=""
    f  s id=$o(^DHCMed.CR.PO.InterfaceD(id)) q:id=""  d
    .s obj=##class(DHCMed.CR.PO.Interface).%OpenId(id)
    .s $li(data,1)=id
    .;s $li(data,2)=obj.CategoryCode
    .s objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRFInterfaceCate",obj.CategoryCode,"1")
	.s CategoryName=objDic.Description
	.s $li(data,2)=CategoryName
    .s $li(data,3)=obj.InterfaceCode
    .s $li(data,4)=obj.InterfaceName
    .s $li(data,5)=obj.Arguments
    .s $li(data,6)=obj.InterfaceClassMethod
    .s $li(data,7)=obj.ReturnType
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()

	Quit $$$OK
}

ClassMethod QueryAllInterfacesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllInterfacesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryAllInterfacesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllInterfacesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

}
