Import sqluser

/// 维护表单名称类
/// zhouxin
/// 2017-09-26
Class web.DHCADVFormName Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2017-07-15
/// Description:： 保存或者新增表单
/// Table：        FormName
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCADVFormName).saveOrUpdate("")
ClassMethod saveOrUpdate(str)
{
 
 n (str)	
 s code=$p(str,"^",1)
 s name=$p(str,"^",2)
 s version=+$p(str,"^",3)
 s jsPath=$p(str,"^",4)
 s ID=+$p(str,"^",5)
 s type=$p(str,"^",6)
 s cat=$p(str,"^",7)
 s active=$p(str,"^",9)
 s width=$p(str,"^",10)	
 s formhosp=$p(str,"^",11)	
 s tmpId=$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(code),""))
 
 //新增
 q:(ID=0)&&(+tmpId'=0) 11
 
 //修改
 q:(ID'=0)&&(+tmpId'=0)&&(+tmpId'=ID) 12
 i +ID=0 d
 .s obj=##class(User.DHCAdvFormName).%New()
 .s version=1
 e  d
 .s obj=##class(User.DHCAdvFormName).%OpenId(ID)
 .d obj.%Reload()
 s obj.code=code
 s obj.name=name
 s obj.jsPath=jsPath
 s obj.type=type
 i +cat'=0 d
 .d obj.catSetObjectId(cat)
 i +cat=0 d
 .d obj.catSetObjectId("")
 s obj.active=active
 s obj.width=width
 i +formhosp'=0 d
 .d obj.hospdrSetObjectId(formhosp)
 s sc=obj.%Save()
 i $$$ISERR(sc) q -2
 /// 2021-06-18 cy 多院区改造 管控数据保存
 s dataId=obj.%Id()
 s hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_AdvFormName",dataId,formhosp)
 q:hospflag'=0 -3
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

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 查询表单
ClassMethod listGrid(rows As %String, page As %String, queryCode = "", queryName = "", queryType = "", queryStr = "", hosp = "")
{
  
  n (rows,page,queryCode,queryName,queryType,queryStr,hosp)
  s:queryType="" queryType="Y"
  s:queryType="A" queryType=""
  s End = page*rows
  s Start=(page-1)*rows+1
  s queryCode=##class(web.DHCADVAction).ALPHAUP(queryCode)
  s queryStr=##class(web.DHCADVAction).ALPHAUP(queryStr)
  s count=0,form=""
  w "{""rows"":["
  f  s form=$o(^User.DHCAdvFormNameD(form)) q:form=""  d
  .q:+form=0
  .s data=^User.DHCAdvFormNameD(form)
  .s code=$lg(data,2)
  .s name=$lg(data,3)
  .s type=$lg(data,6)
  .s active=$lg(data,8)
  .s formhosp=$lg(data,10)
  .q:(queryName'="")&&($f(name,queryName)=0)
  .q:(queryCode'="")&&($f(##class(web.DHCADVAction).ALPHAUP(code),queryCode)=0)
  .q:(queryType'="")&&(queryType'=type)
  .q:(queryStr'="")&&($f(##class(web.DHCADVAction).ALPHAUP(name),queryStr)=0)&&($f(##class(web.DHCADVAction).ALPHAUP(code),queryStr)=0)
  .q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_AdvFormName",form,hosp,"")'="Y"
  .s count=count+1
  .q:count<Start
  .q:count>End
  .w $case(count,Start:"",:",")
  .
  .
  .w "{"
  .w """ID"":"_form_","
  .w """code"":"""_code_""","
  .w """name"":"""_$List(data,3)_""","
  .w """version"":"""_$List(data,4)_""","
  .w """jsPath"":"""_$List(data,5)_""","
  .w """width"":"""_$ListGet(data,9)_""","
  .w """type"":"""_type_""","
  .s catId=$List(data,7)
  .s catDesc=""
  .i +catId'=0 d
  ..w """cat"":"""_catId_""","
  ..i $d(^User.DHCAdvFormCatD(catId)) d
  ...s catDesc=$LIST(^User.DHCAdvFormCatD(catId),3)
  .w """catDesc"":"""_catDesc_""","
  .w """HospDr"":"""_formhosp_""","
  .w """active"":"""_active_""""
  .w "}"
  w "],""total"":"_count_"}"
  q ""
}

/// Creator：      zhouxin
/// CreatDate：    2017-11-21
/// Description:： 删除表单
/// Table：        FormName
/// Return：       删除成功 0，其他 失败
ClassMethod remove(id)
{
    n (id)
	d ##class(User.DHCAdvFormName).%DeleteId(id)
	&sql(delete from DHC_AdvForm WHERE formName=:id)
	/// 2021-06-18 cy 多院区改造 管控数据删除
	s hospflag=##Class(web.DHCADVCOMMON).DeleteHospitals("DHC_AdvFormName",id)
	q:hospflag'=1 -3
	q 0
}

/// Creator：      zhouxin
/// CreatDate：    2018-03-16
/// Description:： 查询表单
ClassMethod listCombo(q = "", HospDr = "")
{
  s q=##class(web.DHCADVAction).ALPHAUP(q)
  s form="",count=0
  w "["
  f  s form=$o(^User.DHCAdvFormNameD(form)) q:form=""  d
  .q:+form=0
  .s data=^User.DHCAdvFormNameD(form)
  .s code=$List(data,2)
  .s name=$List(data,3)
  .s active=$List(data,8)
  .s formhosp=$lg(data,10)
  .q:(HospDr'="")&&(formhosp'="")&&(formhosp'=HospDr)
  .q:active'="Y"
  .s QuitCode=##class(web.DHCINSUPort).GetCNCODE(name,4,"")   //sufan 2019-11-04 
  .s QuitCode=QuitCode_$$ALPHAUP^SSUTIL4(name)
  .q:(q'="")&&(QuitCode'[q)
  .i count'=0 w ","
  .w "{"
  .w """value"":"_form_","
  .w """text"":"""_$List(data,3)_""""
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

/// Creator：      cy
/// CreatDate：    2021-04-13
/// Description:： 获取表单信息标识(表单关联医院为空则显示在任何医院下，关联医院不为空则显示在具体医院下)
/// Table：        DHC_AdvFormName
/// Return：       0:不匹配 1：匹配
/// w ##class(web.DHCADVFormName).CheckFormName("11","2")
ClassMethod CheckFormName(code, HospDr)
{
    n (code,HospDr)
    s flag=0
    s code=##class(web.DHCADVAction).ALPHAUP(code)
    q:code="" flag
	s formnameid=$o(^User.DHCAdvFormNameI("IndexCode",code,"")) 
	q:+formnameid=0 1
	s:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_AdvFormName",formnameid,HospDr,"")="Y" flag=1
	q flag
}

}
