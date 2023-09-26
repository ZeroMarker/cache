/// 表单分类字典表
/// zhouxin
/// 2017-09-26
Class web.DHCADVFormCat Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2017-07-15
/// Description:： 保存或者新增表单分类
/// Table：        FormName
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCAdVFormCat).saveOrUpdate("")
ClassMethod saveOrUpdate(str)
{
 
	n (str)	
	s code=$p(str,"^",1)
	s name=$p(str,"^",2)
	s ID=+$p(str,"^",3)

	s tmpId=$o(^User.DHCAdvFormCatI("IndexCode",##class(web.DHCADVAction).ALPHAUP(code),"")) 

	//新增
	q:(ID=0)&&(+tmpId'=0) 11

	//修改
	q:(ID'=0)&&(+tmpId'=0)&&(+tmpId'=ID) 12 
	i +ID=0 d
	.s obj=##class(User.DHCAdvFormCat).%New()
	e  d
	.s obj=##class(User.DHCAdvFormCat).%OpenId(ID)
	.d obj.%Reload()
	s obj.code=code
	s obj.name=name
	s sc=obj.%Save()
	i $$$ISERR(sc) q -2
	q 0
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 批量保存或者修改表单
/// Table：        FormName
/// Input：	       code^name^style^ID$$code^name^style^ID
/// Return：       保存成功 0，其他 失败
/// w ##class(web.FormName).save("")
ClassMethod save(params)
{
    n (params)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..saveOrUpdate(str)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Err
	TRollback
	w $ze
	q -1
}

/// 输出datagrid
/// w ##class(web.DHCADVFormCat).listGrid("12","1")
ClassMethod listGrid(rows As %String, page As %String, queryCode = "", queryName = "", hospID = "")
{
  
  n (rows,page,queryCode,queryName,hospID)
  s End = page*rows
  s Start=(page-1)*rows+1
  s queryCode=##class(web.DHCADVAction).ALPHAUP(queryCode)
  s count=0,cat=""
  w "{""rows"":["
  f  s cat=$o(^User.DHCAdvFormCatD(cat)) q:cat=""  d
  .q:+cat=0
  .s data=^User.DHCAdvFormCatD(cat)
  .s code=$LIST(data,2)
  .s name=$LIST(data,3)
  .
  .q:(queryName'="")&($f(name,queryName)=0)
  .q:(queryCode'="")&($f(##class(web.DHCADVAction).ALPHAUP(code),queryCode)=0)
  .s count=count+1
  .q:count<Start
  .q:count>End
  .w $case(count,Start:"",:",")
  .s tmpObj={}
  .s tmpObj.ID=cat
  .s tmpObj.code=code
  .s tmpObj.name=name
  .w tmpObj.%ToJSON()
  w "],""total"":"_count_"}"
  q ""
}

/// 输出combo
ClassMethod listCombo(q = "")
{
  
  n (q)
  s Start=1
  s End=10
  s count=0,cat=""
  w "["
  f  s cat=$o(^User.DHCAdvFormCatD(cat)) q:cat=""  d
  .q:+cat=0
  .s data=^User.DHCAdvFormCatD(cat)
  .s name=$LIST(data,3)
  .
  .q:(q'="")&($f(name,q)=0)
  .s count=count+1
  .q:count<Start
  .q:count>End
  .w $case(count,Start:"",:",")
  .s tmpObj={}
  .s tmpObj.value=cat
  .s tmpObj.text=name
  .w tmpObj.%ToJSON()
  w "]"
  q ""
}

/// Creator：      congyue
/// CreatDate：    2019-12-16
/// Description:： 删除表单分类
/// Table：        FormCat
/// Return：       删除成功 0，其他 失败
ClassMethod remove(id)
{
    n (id)
    q:$d(^User.DHCAdvFormNameI("IndexCat",id)) "-1"
	s sc=##class(User.DHCAdvFormCat).%DeleteId(id)
 	i $$$ISERR(sc) q sc
	q 0
}

}
