/// 名称: DHCMed.CR.BO.Dictionary
/// 描述: 字典服务服务
/// 编写者：wuqk
/// 编写日期: 2012-11-29
Class DHCMed.CR.BO.Dictionary Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2012-11-29
/// Description:  查询字典的返回列
/// Table：       DHCMed.CR.PO.Dic
/// Input：       dicCode：字典代码
/// Return：      
/// w ##class(DHCMed.CR.BO.Dictionary).getFields("arcim")
ClassMethod getFields(dicCode As %String) As %Library.ListOfObjects
{
	set ret =##class(%Library.ListOfObjects).%New()
	quit:dicCode="" ret
	quit:'$d(^DHCMed.CR.PO.DicI("IndexCode"," "_$ZCVT(dicCode,"U"))) ret
	set dicId = $O(^DHCMed.CR.PO.DicI("IndexCode"," "_$ZCVT(dicCode,"U"),""))
	set objDic = ##class(DHCMed.CR.PO.Dic).%OpenId(dicId)
	set fields = objDic.fields
	quit:fields="" ret
	for index=1:1:$l(fields,",") {
		set objField = ##class(DHCMed.CR.BO.Field).%New()
		set objField.Name = $p($p(fields,",",index),":",1)
		set objField.Type = $p($p(fields,",",index),":",2)
		set objField.cName = $p($p(fields,",",index),":",3)
		set:objField.cName="" objField.cName=objField.Name
		do ret.Insert(objField)
	}
	
	q ret
}

/// Creator：     wuqk
/// CreatDate：   2012-11-30
/// Description:  根据字典Id获取字典对象
/// Table：       DHCMed.CR.PO.Dic
/// Input：       dicId：字典Id
/// Return：      
/// w ##class(DHCMed.CR.BO.Dictionary).getObjectById(1)
ClassMethod getObjectById(id As %String) As DHCMed.CR.PO.Dic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CR.PO.Dic).%ExistsId(+id) return
	set obj=##Class(DHCMed.CR.PO.Dic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2012-11-30
/// Description:  根据字典代码判断字典是否存在
/// Table：       DHCMed.CR.PO.Dic
/// Input：       dicCode：字典代码
/// Return：      
/// w ##class(DHCMed.CR.BO.Dictionary).getIdByCode("arcim")
ClassMethod getIdByCode(dicCode As %String) As %Integer
{
	new (dicCode)
	quit:dicCode="" 0
	quit:'$d(^DHCMed.CR.PO.DicI("IndexCode"," "_$ZCVT(dicCode,"U"))) 0
	set id = $o(^DHCMed.CR.PO.DicI("IndexCode"," "_$ZCVT(dicCode,"U"),""))
	quit id
}

/// Creator：     wuqk
/// CreatDate：   2012-11-30
/// Description:  根据字典代码获取字典对象
/// Table：       DHCMed.CR.PO.Dic
/// Input：       dicCode：字典代码
/// Return：      
/// w ##class(DHCMed.CR.BO.Dictionary).getObjectByCode("arcim")
ClassMethod getObjectByCode(dicCode As %String) As DHCMed.CR.PO.Dic
{
	new (dicCode)
	set return=""
	set id=..getIdByCode(dicCode)
	quit:id=0 return
	set return=..getObjectById(id)
	quit return
}

/// Creator：     mxp
/// CreatDate：   2012-12-14
/// Description:  根据ID获取字典信息
/// Table：       DHCMed.CR.PO.Dic
/// Input：       ID:    字典ID
///               separete: 指定的分隔符
/// Return：      字符串形式的字典信息
/// w ##class(DHCMed.CR.BO.Dictionary).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..getObjectById(id)
	set:$g(separete)="" separete="^"
	if $IsObject(obj){
		set return=obj.%Id()_separete
		set return=return_obj.dicCode_separete
		set return=return_obj.dicName_separete
		set return=return_obj.className_separete
		set return=return_obj.queryName_separete
		set return=return_obj.fields_separete
		set return=return_obj.formalSpec
		;set return=obj.ToString($g(separete))
	}	
	quit return
}

///  Creator：     mxp
///  CreatDate：   2012-12-14
///  Description:  保存字典对象
///  Table：       DHCMed.CR.PO.Dic
///  Input：       各属性列表 ^分隔
///  Return：      成功：返回id，失败：返回<0的代码
///  d ##class(DHCMed.CR.BO.Dictionary).update()
ClassMethod update(InStr)
{
	New (InStr)
	Set return=0
	Quit:InStr="" return
	
	Set separete="^"
	Set ID=$p(InStr,separete,1)
	Set dicCode=$p(InStr,separete,2)
	//特殊处理,主要是针对字典代码dicCode唯一
	Set:ID="" ID=$o(^DHCMed.CR.PO.DicI("IndexCode"," "_$ZCVT(dicCode,"U"),0))
	
	If ID="" {
		Set obj=##class(DHCMed.CR.PO.Dic).%New()
	}Else{
		Set obj=##class(DHCMed.CR.PO.Dic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.dicCode=dicCode
	Set obj.dicName=$p(InStr,separete,3)
	Set obj.className=$p(InStr,separete,4)
	Set obj.queryName=$p(InStr,separete,5)
	Set obj.fields=$p(InStr,separete,6)
	Set obj.formalSpec=$p(InStr,separete,7)
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
/// CreatDate：   2012-12-14
/// Description:  通过字典代码、字典名称查询字典信息
/// Table：       DHCMed.CR.PO.Dic
/// Input:		  dicCode:字典代码,dicName：字典名称
/// Output:       ID,DicCode,DicName,ClassName,QueryName,Fields,FormalSpec
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.BO.Dictionary","QueryAllDic","","")
Query QueryAllDic(dicCode As %String, dicName As %String) As %Query(ROWSPEC = "ID:%String,DicCode:%String,DicName:%String,ClassName:%String,QueryName:%String,Fields:%String,FormalSpec:%String")
{
}

ClassMethod QueryAllDicExecute(ByRef qHandle As %Binary, dicCode As %String, dicName As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    s id=""
    f  s id=$o(^DHCMed.CR.PO.DicD(id)) q:id=""  d
    .s objDic=##class(DHCMed.CR.PO.Dic).%OpenId(id)
    .q:(dicCode'="")&(objDic.dicCode'[dicCode)
    .q:(dicName'="")&(objDic.dicName'[dicName)
    .s $li(data,1)=id
    .s $li(data,2)=objDic.dicCode
    .s $li(data,3)=objDic.dicName
    .s $li(data,4)=objDic.className
    .s $li(data,5)=objDic.queryName
    .s $li(data,6)=objDic.fields
    .s $li(data,7)=objDic.formalSpec
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do objDic.%Close()

	Quit $$$OK
}

ClassMethod QueryAllDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryAllDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllDicExecute ]
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

///  Creator：     mxp
///  CreatDate：   2012-12-24
///  Description:  根据类名、Query名获取query方法的参数列表、字段列表
///  Table：       
///  Input：       className：类名  queryName：Query名
///  Return：      query方法的参数列表、字段列表
///  w ##class(DHCMed.CR.BO.Dictionary).GetQueryInfo("web.Teacher","QueryTeachers")
ClassMethod GetQueryInfo(className As %String, queryName As %String) As %String
{
	s return=""
	set dcc = ##class(%Dictionary.CompiledClass).%OpenId(className)
	if $IsObject(dcc){
		set count = dcc.Queries.Count() 
		q:count=0 ""
		for index=1:1:count {
			#dim qdf As %Dictionary.CompiledQuery
			set qdf = dcc.Queries.GetAt(index)
			set name = qdf.Name
			continue:name'=queryName
			set type = qdf.Type
			set formalSpec = qdf.FormalSpec
			set fields = ""
			if type = "%Library.Query" {
				set fields = qdf.Parameters.GetAt("ROWSPEC")
			}
			elseif type= "%Library.SQLQuery" {
				set ColNames = qdf.ColNames
				for i=1:1:$ll(ColNames) {
					set $p(fields,",",i) = $li(ColNames,i)
				}
			}
			s return=return_name_"^"_formalSpec_"^"_fields
		}
	}		
	quit return
}

///  Creator：     mxp
///  CreatDate：   2012-12-24
///  Description:  根据类名获取该类中的query方法列表
///  Table：       
///  Input：       className：类名
///  Return：      query方法列表
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.BO.Dictionary","GetAllQuerys","web.Teacher")
Query GetAllQuerys(className As %String) As %Query(ROWSPEC = "ID:%String,Name:%String")
{
}

ClassMethod GetAllQuerysExecute(ByRef qHandle As %Binary, className As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    q:className="" $$$OK
	set dcc = ##class(%Dictionary.CompiledClass).%OpenId(className)
	if $IsObject(dcc){
		set count = dcc.Queries.Count() 
		q:count=0 ""
		for index=1:1:count {
			#dim qdf As %Dictionary.CompiledQuery
			set qdf = dcc.Queries.GetAt(index)
			set name = qdf.Name
		    s $li(data,1)=index
		    s $li(data,2)=name
		    s ^CacheTemp(repid,ind)=data
		    s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetAllQuerysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllQuerysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAllQuerysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllQuerysExecute ]
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
