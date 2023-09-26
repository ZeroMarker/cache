/// 名称: DHCMed.CR.BO.FunctionService
/// 描述: Javascript函数服务
/// 编写者：mxp
/// 编写日期: 2012-12-14
Class DHCMed.CR.BO.FunctionService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     mxp
/// CreatDate：   2012-12-14
/// Description:  根据函数Id获取函数对象
/// Table：       DHCMed.CR.PO.Function
/// Input：       dicId：函数Id
/// Return：      
/// w ##class(DHCMed.CR.BO.FunctionService).getObjectById(1)
ClassMethod getObjectById(id As %String) As DHCMed.CR.PO.Function
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CR.PO.Function).%ExistsId(+id) return
	set obj=##Class(DHCMed.CR.PO.Function).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     mxp
/// CreatDate：   2012-12-14
/// Description:  根据ID获取函数信息
/// Table：       DHCMed.CR.PO.Function
/// Input：       ID:    函数ID
///               separete: 指定的分隔符
/// Return：      字符串形式的函数信息
/// w ##class(DHCMed.CR.BO.FunctionService).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..getObjectById(id)
	set:$g(separete)="" separete="^"
	if $IsObject(obj){
		set return=obj.%Id()_separete
		set return=return_obj.name_separete
		set return=return_obj.caption_separete
		set return=return_obj.type_separete
		set return=return_obj.data_separete
		set return=return_obj.description
		;set return=obj.ToString($g(separete))
	}	
	quit return
}

///  Creator：     mxp
///  CreatDate：   2012-12-14
///  Description:  保存函数对象
///  Table：       DHCMed.CR.PO.Function
///  Input：       各属性列表 ^分隔
///  Return：      成功：返回id，失败：返回<0的代码
///  d ##class(DHCMed.CR.BO.FunctionService).update()
ClassMethod update(InStr)
{
	New (InStr)
	Set return=0
	Quit:InStr="" return
	
	Set separete="^"
	Set ID=$p(InStr,separete,1)
	
	If ID="" {
		Set obj=##class(DHCMed.CR.PO.Function).%New()
	}Else{
		Set obj=##class(DHCMed.CR.PO.Function).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.name=$p(InStr,separete,2)
	Set obj.caption=$p(InStr,separete,3)
	Set obj.type=$p(InStr,separete,4)
	Set obj.data=$p(InStr,separete,5)
	Set obj.description=$p(InStr,separete,6)
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

/// Creator：     mxp
/// CreatDate：   2012-12-14
/// Description:  删除函数
/// Table：       DHCMed.CR.PO.Function
/// Input：       函数Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.CR.PO.Function).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     maxp
/// CreatDate：   2012-12-17
/// Description:  查询函数信息
/// Table：       DHCMed.CR.PO.Function
/// Input:		  
/// Output:       ID,name,caption,type,data,description
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.BO.FunctionService","QueryAllFunctions")
Query QueryAllFunctions() As %Query(ROWSPEC = "ID:%String,Name:%String,Caption:%String,Type:%String,Description:%String")
{
}

ClassMethod QueryAllFunctionsExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    s id=""
    f  s id=$o(^DHCMed.CR.PO.FunctionD(id)) q:id=""  d
    .s obj=##class(DHCMed.CR.PO.Function).%OpenId(id)
    .s $li(data,1)=id
    .s $li(data,2)=obj.name
    .s $li(data,3)=obj.caption
    .s $li(data,4)=obj.type
    .;s $li(data,5)=obj.data
    .s $li(data,5)=obj.description
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()

	Quit $$$OK
}

ClassMethod QueryAllFunctionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllFunctionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryAllFunctionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllFunctionsExecute ]
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
