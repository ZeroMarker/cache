Import sqluser

/// 表单字典维护
/// zhouxin
/// 2017-09-26
Class web.DHCADVFormDic Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2017-07-15
/// Description:： 保存或者新增表单字典
/// Table：        FormDic
/// Return：       保存成功 0，其他 失败
ClassMethod saveOrUpdate(str)
{
 
 n (str)	
 s field=$p(str,"^",1)
 s title=$p(str,"^",2)
 s style=$p(str,"^",3)
 s ID=+$p(str,"^",4)
 s parRef=+$p(str,"^",5)
 s url=$p(str,"^",6)
 s value=$p(str,"^",7)
 s newline=$p(str,"^",8)
 
 s width=$p(str,"^",9)
 s height=$p(str,"^",10)
 s cols=$p(str,"^",11)
 s rows=$p(str,"^",12)
 s cat=$p(str,"^",13)
 s sameLevel=$CASE($p(str,"^",14),0:"",:$p(str,"^",14))
 s hiddenValue=$p(str,"^",15)
 s hiddenSub=$CASE($p(str,"^",16),0:"",:$p(str,"^",16))
 s:+$p(str,"^",17)'="0" cat=$p(str,"^",17)
 s subDicSameLine=$CASE($p(str,"^",18),0:"",:$p(str,"^",18))
 s canCopy=$CASE($p(str,"^",19),0:"",:$p(str,"^",19))
 s displayTitle=$CASE($p(str,"^",20),0:"",:$p(str,"^",20))
 s seq=+$p(str,"^",21)
 s userEdit=$CASE($p(str,"^",22),0:"",:$p(str,"^",22))
 s subDicTile=$p(str,"^",23) //hxy 2018-06-06
 s hidden=$p(str,"^",24)
 s alphaupField=##class(web.DHCADVAction).ALPHAUP(field)
 s alphaupTitle=##class(web.DHCADVAction).ALPHAUP(title)
 
 //只有label的title可以为空
 //q:(alphaupTitle="")&&(style'="label") -10
 q:(alphaupField="")&&(parRef=0) -10
 s tmpId=0
 i alphaupField'="" d
 .s tmpId=$o(^User.DHCAdvFormDicI("IndexField",alphaupField,""))
 
 // 新增重复判断
 q:(ID=0)&&(+tmpId'=0) -11
 // 修改重复判断
 q:(ID'=0)&&(+tmpId'=0)&&(+tmpId'=ID) -12
 
 i +ID=0 d
 .s obj=##class(User.DHCAdvFormDic).%New()
 e  d
 .s obj=##class(User.DHCAdvFormDic).%OpenId(ID)
 .d obj.%Reload()
 
 s obj.field=field
 s obj.style=style
 s obj.title=title
 s obj.url=url
 s obj.parRef=parRef
 s obj.value=value
 s obj.newLine=newline
 s obj.width=width
 s obj.height=height
 s obj.textarerows=rows
 s obj.cols=cols
 s obj.sameLevel=sameLevel
 s obj.hiddenValue=hiddenValue
 s obj.hiddenSub=hiddenSub
 s obj.cat=cat
 s obj.subDicSameLine=subDicSameLine
 s obj.canCopy=canCopy
 s obj.displayTitle=displayTitle
 s obj.seq=seq
 s obj.userEdit=userEdit
 s obj.hidden=hidden
 s obj.subDicTile=subDicTile //hxy 2018-06-06
 s sc=obj.%Save()
 i $$$ISERR(sc) q -1
 //新增子元素,如果子元素field为空，自动生成field
 i (parRef'=0)&&(alphaupField="")&&(ID=0) d
 .s obj.field=$List(^User.DHCAdvFormDicD(parRef),2)_"-"_obj.%Id()
 .s sc=obj.%Save()
 q 0
}

/// 自动生成label元素
ClassMethod saveLabel(str)
{
	n (str)
	s ret=0
	s style=$p(str,"^",3)
	//子节点不增加
	q:+$p(str,"^",5)'=0 ret
	//只是新增的时候插入label
	q:+$p(str,"^",4)'=0 ret
	
	i (style="select-change")||(style="easyui-combobox")||(style="input")||(style="textarea")||(style="easyui-datebox"){
		s $p(str,"^",3)="label"
		s $p(str,"^",1)=$p(str,"^",1)_"-label"
		s ret=..saveOrUpdate(str)
	}
	q ret
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 批量保存或者修改表单字典
/// Table：        FormDic
/// Input：	       field^title^style^ID^parRef^url$$field^title^style^ID^parRef^url
/// Return：       保存成功 0，其他 失败
/// d ##class(User.FormDic).%BuildIndices()
ClassMethod save(params)
{
    n (params)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	f i=1:1:len q:ret'=0  d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..saveLabel(str)
	.s ret=..saveOrUpdate(str)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// 表单字典根元素 输出json格式数据
ClassMethod listGrid(rows As %String, page As %String, queryStyle = "", queryField = "", queryType = "", queryForm = "", userEdit = "")
{
  
  n (rows,page,queryStyle,queryField,queryType,queryForm,userEdit)
  s End = page*rows
  s Start=(page-1)*rows+1
  
  d ..CreateIndex()
  s count=0,dic=""
  w "{""rows"":["
  f  s dic=$o(^User.DHCAdvFormDicI("IndexParef"," 0",dic)) q:dic=""  d
  .s data=^User.DHCAdvFormDicD(dic)
  .s field=$ListGet(data,2)
  .s style=$ListGet(data,3)
  .s title=$ListGet(data,4)
  .s tmpUserEdit=$ListGet(data,22)
  .s:tmpUserEdit=0 tmpUserEdit=""
  .s subDicSameLine=$ListGet(data,22)
  .q:..CheckDicFormName(dic,queryForm)=1
  .q:(queryStyle'="")&&(queryStyle'=style)
  .q:(queryField'="")&&($f(field,queryField)=0)&&($f(title,queryField)=0)
  .s url=..EvalJSON($ListGet(data,5))
  .q:(queryType="Y")&(..checkDicType(dic)=0)
  .q:(userEdit=1)&($ListGet(data,22)'="Y")
  .s cat=$ListGet(data,14)
  .q:(+cat'=0)&&($ListGet(^User.DHCAdvFormNameD(cat),8)'="Y")
  .s attribute=""
  .s count=count+1
  .q:count<Start
  .q:count>End
  .w $case(count,Start:"",:",")
  .w "{"
  .w """ID"":"_dic_","
  .w """field"":"""_field_""","
  .w """title"":"""_..EvalJSON(title)_""","
  .w """style"":"""_..EvalJSON(style)_""","
  .w """parRef"":"""_..EvalJSON($ListGet(data,6))_""","
  .w """value"":"""_..EvalJSON($ListGet(data,7))_""","
  .w """newLine"":"""_..EvalJSON($ListGet(data,8))_""","
  .w """width"":"""_..EvalJSON($ListGet(data,10))_""","
  .w """height"":"""_..EvalJSON($ListGet(data,11))_""","
  .w """cols"":"""_..EvalJSON($ListGet(data,12))_""","
  .w """rows"":"""_..EvalJSON($ListGet(data,13))_""","
  .w """sameLevel"":"""_..EvalJSON($ListGet(data,15))_""","
  .w """hiddenValue"":"""_..EvalJSON($ListGet(data,16))_""","
  .w """hiddenSub"":"""_..EvalJSON($ListGet(data,17))_""","
  .w """subDicSameLine"":"""_..EvalJSON($ListGet(data,18,""))_""","
  .w """canCopy"":"""_..EvalJSON($LISTGET(data,19,""))_""","
  .w """displayTitle"":"""_..EvalJSON($ListGet(data,20,""))_""","
  .w """cat"":"""_..EvalJSON($ListGet(data,14))_""","
  .w """seq"":"""_..EvalJSON($ListGet(data,21))_""","
  .w """subDicTile"":"""_..EvalJSON($ListGet(data,24))_"""," //hxy 2018-06-06
  .w """userEdit"":"""_..EvalJSON(tmpUserEdit)_""","
  .i (+$ListGet(data,14)'=0)&&($d(^User.DHCAdvFormNameD($ListGet(data,14)))) d
  ..w """catDesc"":"""_..EvalJSON($ListGet(^User.DHCAdvFormNameD($ListGet(data,14)),3))_""","
  .e  d
  ..w """catDesc"":"""_..EvalJSON($ListGet(data,14))_""","
  .w """url"":"""_url_""","
  .w """attribute"":"""_url_""""
  .w "}"
  w "],""total"":"_count_"}"
  q ""
}

ClassMethod checkDicType(dic)
{
	n (dic)

	q:+($o(^User.DHCAdvFormDicI("IndexParef"," "_dic,"")))=0 0
	
	s type=$ListGet(^User.DHCAdvFormDicD(dic),3)
	s url=$ListGet(^User.DHCAdvFormDicD(dic),5)
	q:(type'="form")&&(url="") 1
	
	s subDic="",ret=0
	f  s subDic=$o(^User.DHCAdvFormDicI("IndexParef"," "_dic,subDic)) q:subDic=""  d
	.s type=$ListGet(^User.DHCAdvFormDicD(subDic),3)
	.s url=$ListGet(^User.DHCAdvFormDicD(subDic),5)
	.s:(type'="form")&&(url="") ret=1
	q ret
}

/// 已tree的形式显示字典元素子元素
ClassMethod listTree(id, text = "")
{
  
  n (id,text)
  s dic="",count=0
  w "["
  f  s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,dic)) q:dic=""  d
  .q:..checkTree(dic,text)'=1
  .w $case(count,0:"",:",")
  .s data=^User.DHCAdvFormDicD(dic)
  .w "{"
  .w """id"":"_dic_","
  .w """text"":"""_$ListGet(data,4)_"("_$ListGet(data,3)_")"_""","
  .w """parRef"":"""_$ListGet(data,6)_""","
  .w """style"":"""_$ListGet(data,3)_""","
  .w """field"":"""_$ListGet(data,2)_""""
  .d ..listChildren(dic,text)
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

/// 递归调用的子方法
ClassMethod listChildren(id, text = "")
{
  
    n (id,text)
    s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,""))
	q:+subId=0
	s subId="",i=0
	w ",""children"":["
	f  s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,subId)) q:subId=""  d
	.q:..checkTree(subId,text)'=1
	.w $case(i,0:"",:",")
	.s data=^User.DHCAdvFormDicD(subId)
	.w "{"
  	.w """id"":"_subId_","
    .w """text"":"""_$ListGet(data,4)_"("_$ListGet(data,3)_")"_""","
    .w """parRef"":"""_$ListGet(data,6)_""","
    .w """style"":"""_$ListGet(data,3)_""","
    .w """field"":"""_$ListGet(data,2)_""""
  	.d ..listChildren(subId,text)
    .w "}"
    .s i=i+1
	w "]"
}

/// 判断子元素是否存在
ClassMethod checkTree(id, text = "")
{
	
	n (id, text)
	s isExistFlag=0
	q:text="" 1
	s text=$ZCVT(text,"U")
	/// 不存在下级节点
	s ID=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,""))
	i ID="" D
	.s desc=$ZCVT($ListGet(^User.DHCAdvFormDicD(id),4),"U")
	.s code=$ZCVT($ListGet(^User.DHCAdvFormDicD(id),2),"U")
	.i (desc[text)||(code[text) D
	..s isExistFlag=1

	Q:ID="" isExistFlag

	s ID=""
	f  s ID=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,ID))  q:(ID="")||(isExistFlag=1)  d
	.s isExistFlag=..checkTree(ID,text)
	Q isExistFlag
}

/// 返回需要修改的实体
/// d ##class(web.DHCADVFormDic).findById(67509)
ClassMethod findById(id)
{
	n (id)
	s data=^User.DHCAdvFormDicD(id)
	s ret=$LISTTOSTRING(data,"^",1)
	s len=$LENGTH(ret)
	w $e(ret,2,len),!
	q ""
}

/// 返回需要修改的实体
ClassMethod remove(id)
{
	n (id)
	 s sc=##class(User.DHCAdvFormDic).%DeleteId(id)
	 s ret=..deleteFormDicLink(id) ;绑定删除
 	i $$$ISERR(sc) q -2
	q 0
}

/// 输出datagrid类型
ClassMethod saveDataGrid(id, formId)
{
	n (id,formId)
	
	w "<div>"
	s exist=0,i=0,subId=""
	f  s subId=$o(^FORMDIC(0,"PARREF"," "_id,subId)) q:(subId="")||(exist=1)  d
	.s:$p(^FORMDIC(subId),"^",7)="Y" exist=1
	.q:exist=1
	.
	.s tmpObj=##class(User.FormDic).%New()
	.s tmpObj.field=$p(^FORMDIC(subId),"^",1)
	.s tmpObj.style=$p(^FORMDIC(subId),"^",2)
	.s tmpObj.title=$p(^FORMDIC(subId),"^",3)
	.s tmpObj.url=$p(^FORMDIC(subId),"^",4)
	.s tmpObj.value=$p(^FORMDIC(subId),"^",6)
	.s tmpObj.width=$p(^FORMDIC(subId),"^",9)
	.s tmpObj.height=$p(^FORMDIC(subId),"^",10)
	.s tmpObj.cols=$p(^FORMDIC(subId),"^",11)
	.s tmpObj.textarerows=$p(^FORMDIC(subId),"^",12)
	.s tmpObj.parRef=id
	.s:i=0 tmpObj.newLine="Y"
	.s sc=tmpObj.%Save()
	.s width=$case($p(^FORMDIC(subId),"^",9),"":171,:$p(^FORMDIC(subId),"^",9))
	.s heigh=$case($p(^FORMDIC(subId),"^",10),"":20,:$p(^FORMDIC(subId),"^",10))
	.w "<label >"_$p(^FORMDIC(subId),"^",3)_"</label>&nbsp;&nbsp;&nbsp;&nbsp;"
	.w "<input type='text' class='"_$p(^FORMDIC(subId),"^",2)_"'  "
	.w "style='width:"_width_";height:"_heigh_"'" 
	.w " name='"_formId_"."_tmpObj.%Id()_"' "
	.w " data-options=""valueField:'value',textField:'text',url:'"_$p(^FORMDIC(subId),"^",4)_"'"" " 
	.w " value='"_$p(^FORMDIC(subId),"^",6)_"'  />"
	.s i=i+1
	w "</div>"
	q ""
}

/// 返回json表单元素类型
/// d ##class(web.DHCADVFormDic).listFormType()
ClassMethod listFormType()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","easyui-combobox").Put("text","easyui-combobox"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","easyui-datebox").Put("text","easyui-datebox"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","easyui-datetimebox").Put("text","easyui-datetimebox"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","input").Put("text","input"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","panel").Put("text","panel"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","fieldset").Put("text","fieldset"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","radio").Put("text","radio"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","checkbox").Put("text","checkbox"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","radio-date").Put("text","radio-date"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","radio-input").Put("text","radio-input"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","checkbox-input").Put("text","checkbox-input"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","radio-select").Put("text","radio-select"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","checkbox-select").Put("text","checkbox-select"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","checkbox-date").Put("text","checkbox-date"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","label").Put("text","label"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","textarea").Put("text","textarea"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","datagrid").Put("text","datagrid"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","select-change").Put("text","select-change"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","button").Put("text","button"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","form").Put("text","form"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","tab").Put("text","tab"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","popModel").Put("text","popModel"))
  //d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","compare-datagrid").Put("text","compare-datagrid"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","upload").Put("text","upload"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","table").Put("text","table"))	
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","popSelect").Put("text","popSelect"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","img").Put("text","img"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// 返回json表单元素类型
/// d ##class(web.DHCADVFormDic).listState()
ClassMethod listState()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// 返回json表单元素分类
/// d ##class(web.DHCADVFormDic).listFormCat()
ClassMethod listFormCat(HospDr = "")
{
  s array=[]
  s otherItm={}
  s otherItm.value="OTHER"
  s otherItm.text="OTHER"
  d array.%Set(array.%Size(), otherItm)
  s comItm={}
  s comItm.value="COMMON"
  s comItm.text="COMMON"
  d array.%Set(array.%Size(), comItm)
  
  s form=""
  f  s form=$o(^User.DHCAdvFormNameD(form)) q:form=""  d
  .q:+form=0
  .s formhosp=$lg(^User.DHCAdvFormNameD(form),10)
  .q:(formhosp'="")&&(HospDr'="")&&(formhosp'=HospDr)
  .s itm={}
  .s itm.value=form
  .s itm.text=$List(^User.DHCAdvFormNameD(form),3)
  .q:$List(^User.DHCAdvFormNameD(form),8)'="Y"
  .d array.%Set(array.%Size(), itm)
  w array.%ToJSON()
  q ""
}

/// 返回字典元素一级子元素
/// d ##class(web.FormDic).listDicFirstLevel(797)
ClassMethod listDicFirstLevel(id)
{
	n (id)
	  
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    s listObj=##class(%ListOfObjects).%New()
	s itm=""
	f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
	.s title=$LIST(^User.DHCAdvFormDicD(itm),4)
	.q:"Y"=$LISTGET(^User.DHCAdvFormDicD(itm),23)
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",itm).Put("text",title))
    w jsonObj.ListToJson(listObj)
    q ""
}

ClassMethod getUrlValue(url, id)
{
	n (url,id)
	s ret=""
	s par=$p(url,"?",2)
	s ClassName=$p($p(par,"&",1),"=",2)
	s MethodName=$p($p(par,"&",2),"=",2)

	Q:'##class(websys.Conversions).IsValidClassName(ClassName)
	Q:'##class(websys.Conversions).IsValidMethodName(ClassName,MethodName)
	set myobj=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_MethodName,0)
	Q:'$IsObject(myobj) ""
	set FormalSpecParsed = myobj.FormalSpecParsed
	set paramStr = ""
	for tmp=1:1:$ll(FormalSpecParsed) d
	.set paramName = $lg($lg(FormalSpecParsed,tmp),1)
	.set paramStr = paramStr_$case(paramStr,"":"",:",")_##class(web.FormDic).GetParValueByKey(paramName,par)

	Set code="Set rs=##class("_ClassName_")."_MethodName_"("_paramStr_")"
	XECUTE code
	q:$g(rs)="" id
	s arry=[].%FromJSON(rs)
	set iter = arry.%GetIterator()

   	while iter.%GetNext(.key, .value) {
		i (value.%Get("id")=id){
			s ret=value.%Get("text")
		}
	
   	}
   	q ret
}

ClassMethod GetParValueByKey(key, par)
{
	n (key, par)
	s ret=""
	f i=3:1:$l(par,"&") d 
	.
	.s tmp=$p(par,"&",i)
	.i $p(tmp,"=",1)=key d
	..s ret=$p(tmp,"=",2)
	q ret
}

ClassMethod writeSubDic(formid, id, recordId = "")
{
	n (formid,id,recordId,%session)
	/// 判断当前元素的父元素是否设置 子元素同级显示   因为当前元素本身就是隐藏子元素的父元素，所以不需要取 当前元素的配置
	;s dicdata=^User.DHCAdvFormDicD(id)
	;s ppref=$LIST(dicdata,6)
	;i ppref'=0 d
	;.i $LIST(^User.DHCAdvFormDicD(ppref),15)'="Y" d  
   	;..w "<ul>"
	;..w "<li >"
	/// 判断当前元素是否设置 子元素同级显示
	i $LIST(^User.DHCAdvFormDicD(id),15)'="Y" d  
   	.w "<ul>"
	.w "<li >"
	
	w "<div style='margin-top: 5px;'>"

	s parref=id
	
	//普通元素的子元素输出
	s itm="",width=##class(User.DHCAdvForm).GetColumnWidth(parref,"")
	f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_parref,itm)) q:itm=""  d
	.s newLine=$LIST(^User.DHCAdvFormDicD(itm),8)
	.i newLine="Y" d  w "</div><div style='margin-top: 5px;'>"
	.d ##class(User.DHCAdvForm).ToElementHtml(itm,formid,recordId,width,"Y")
	
	w "</div>"
	
	/// 判断当前元素的父元素是否设置 子元素同级显示   因为当前元素本身就是隐藏子元素的父元素，所以不需要取 当前元素的配置
	;i ppref'=0 d
	;.i $LIST(^User.DHCAdvFormDicD(ppref),15)'="Y" d 
	;..w "</li>"
	;..w "</ul>"
	
	/// 判断当前元素是否设置 子元素同级显示
	i $LIST(^User.DHCAdvFormDicD(id),15)'="Y" d 
	.w "</li>"
	.w "</ul>"
	
    q ""
}

ClassMethod getPrintSubDatagrid(formId, id, row = "", recordid = "")
{
	n (id,formId,row,recordid)
	
	s:row="" row=$i(^DHCSTCOMMON("FORMDIC","DATAGRID",formId,id))  
	w "<tr>"
	s itm=""
	f  s itm=$o(^FORMDIC(0,"PARREF",id,itm)) q:itm=""  d
	.s style=$p(^FORMDIC(itm),"^",2)
	.s dicField=$p(^FORMDIC(itm),"^",1)
	.s field=formId_"."_itm_"."_row
	.s url=$p(^FORMDIC(itm),"^",4)
	.s title=$p(^FORMDIC(itm),"^",3)
	.s value=$p(^FORMDIC(itm),"^",6)
	.s dicWidth=$p(^FORMDIC(itm),"^",9)
	.s dicHeight=$p(^FORMDIC(itm),"^",10)
	.s dicWidth=$case(dicWidth,"":171,:dicWidth)
	.s dicHeight=$case(dicHeight,"":20,:dicHeight)
	.i recordid'="" d
	..s recordItmId=+$o(^User.FormRecordItmI("IndexRowKey",recordid,formId,$p(^FORMDIC(itm),"^",5),row,itm,""))
	..i recordItmId'=0 d
	...s value=$LIST(^User.FormRecordItmD(recordItmId),4)
	.w "<td >"	
	.w value
	.w "</td>"
	w "</tr>"
    q ""
}

ClassMethod listLayTree(id)
{
  
  n (id)
  s dicData=^User.DHCAdvFormDicD(id)
  w "[{"
  w """id"":"_id_","
  w """name"":"""_$LIST(dicData,4)_"("_$LIST(dicData,3)_")"_""","
  w """title"":"""_$LIST(dicData,4)_""","
  w """style"":"""_$LIST(dicData,3)_""","
  w """field"":"""_$LIST(dicData,2)_""""
  w ",""children"":"	
  s dic="",count=0
  w "["
  f  s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,dic)) q:dic=""  d
  .w $case(count,0:"",:",")
  .w "{"
  .w """id"":"_dic_","
  .w """name"":"""_$LIST(^User.DHCAdvFormDicD(dic),4)_"("_$LIST(^User.DHCAdvFormDicD(dic),3)_")"_""","
  .w """title"":"""_$LIST(^User.DHCAdvFormDicD(dic),4)_""","
  .w """style"":"""_$LIST(^User.DHCAdvFormDicD(dic),3)_""","
  .w """field"":"""_$LIST(^User.DHCAdvFormDicD(dic),2)_""""
  .d ..listLaySubTree(dic)
  .w "}"
  .s count=count+1
  w "]"
  w "}]"
  q ""
}

ClassMethod listLaySubTree(id)
{
  
    n (id)
    s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,""))
	q:+subId=0
	s subId="",i=0
	w ",""children"":["
	f  s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,subId)) q:subId=""  d
	.w $case(i,0:"",:",")
	.w "{"
  	.w """id"":"_subId_","
    .w """name"":"""_$LIST(^User.DHCAdvFormDicD(subId),4)_"("_$LIST(^User.DHCAdvFormDicD(subId),3)_")"_""","
    .w """title"":"""_$LIST(^User.DHCAdvFormDicD(subId),4)_""","
    .w """style"":"""_$LIST(^User.DHCAdvFormDicD(subId),3)_""","
    .w """field"":"""_$LIST(^User.DHCAdvFormDicD(subId),2)_""""
  	.d ..listLaySubTree(subId)
    .w "}"
    .s i=i+1
	w "]"
}

/// d ##class(web.DHCADVFormDic).getSubDic(165310,48)
ClassMethod getSubDic(formItm, dic, ret = "")
{
	n (formItm, dic, ret)
	s attr=$o(^User.DHCADVFormAttrI("IndexItmDic",formItm,dic,""))
	i +attr'=0 d
	.s data=^User.DHCADVFormAttrD(attr)
	.i ret'="" d
	..s ret=ret_"~"_$LISTTOSTRING(data,"|",1)
	.e  d
	..s ret=$LISTTOSTRING(data,"|",1)
	//w ret
	s subDic=""
	f  s subDic=$o(^User.DHCAdvFormDicI("IndexParef"," "_dic,subDic)) q:subDic=""  d
	.s ret=..getSubDic(formItm,subDic,ret)
	q ret
}

ClassMethod getDicHiddenValue(dic)
{
	n (dic)
	w $LIST(^User.DHCAdvFormDicD(dic),16)
	q ""
}

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ##class(ext.util.String).Replace(mystr,"\", "\\")
	
	s mystr = ##class(ext.util.String).Replace(mystr,"""", "\""")
	
	//s mystr = ##class(ext.util.String).Replace(mystr,"'", "\'")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(13), "")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(10), "")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(0), "")
	q mystr
}

ClassMethod Testlq(id As %String) As %String
{
	;s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,"")) 
	s parref1=$lg(^User.DHCAdvFormDicD(id),6)
	s parref2=$lg(^User.DHCAdvFormDicD(parref1),6)
	
	s exitflag=0,tmpsubnum=0
	s tmpsub=""
	f  s tmpsub=$o(^User.DHCAdvFormDicI("IndexParef"," "_parref2,tmpsub)) q:(tmpsub="")||(exitflag=1)  d
	.s tmpsubnum=tmpsubnum+1
	.i tmpsub=parref1 d
	..s exitflag=1
	.q:exitflag=1
	
	s parref2=$lg(^User.DHCAdvFormDicD(parref1),6)
	s parref3=$lg(^User.DHCAdvFormDicD(parref2),6)
	
	s dicdesc=""
	s tmpsubnum2=0
	s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_parref3,""))
	s tmpsub="" 
	f  s tmpsub=$o(^User.DHCAdvFormDicI("IndexParef"," "_dic,tmpsub)) q:(tmpsub="")||(dicdesc'="")  d  
	.s tmpsubnum2=tmpsubnum2+1
	.i tmpsubnum=tmpsubnum2 d 
	..s dicdesc=$lg(^User.DHCAdvFormDicD(tmpsub),4)
	.q:dicdesc'="" 
	
	q dicdesc
}

/// 判断字典元素是否在该表单中出现
ClassMethod CheckDicFormName(dic = 0, formname = 0) As %String
{
	n (dic,formname)
	q:+formname=0 0
	q:+dic=0 0
	s version=$ListGet(^User.DHCAdvFormNameD(formname),4)
	s form=+$o(^User.DHCAdvFormI("IndexDic",formname," "_version,dic,""))
	q:form'=0 0
	q 1
}

/// 生成索引
ClassMethod CreateIndex() As %String
{
	i +$o(^User.DHCAdvFormI("IndexDic",""))=0 d
	.d ##class(User.DHCAdvForm).%BuildIndices($ListBuild("IndexDic"))
}

/// Description: 查询绑定数据的类别树
/// Creator:     Wangxuejian
/// CreateDate:  2018-08-21
/// Table: 		 DHC_MedAdrRepEventItm  DHC_MedAdrRepEvent
/// Input:  	 空
/// Output:  	 DHC_MedAdrRepEventItm（子表） DHC_MedAdrRepEvent（主表） 表中的数据信息   
/// Others:		 w ##class(web.DHCADVFormDic).QueryTypeTree("12","1","")
ClassMethod QueryTypeTree(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    k ^TMP("DHCADV","web.DHCADVFormDic","QueryTypeTree",pid) //k掉临时global
    s PID="",h=0,count=0
    F  S PID=$o(^DHCMEDADREVT(PID)) Q:PID=""  D
    .Q:PID=0
	.S childId=""
	.S childId=$o(^DHCMEDADREVTI(PID,"MADREVI",childId))
	.S Code=$p(^DHCMEDADREVT(PID),"^",1) //代码
	.S Desc=$p(^DHCMEDADREVT(PID),"^",2) //描述
	.S TempStr=PID_"^"_0_"^"_Desc_"^"_""_"^"_""_"^"_Code_"^"_""
	.S h=h+1
	.S ^TMP("DHCADV","web.DHCADVFormDic","QueryTypeTree",pid,h)=TempStr
	.S childId="", Id=0
	.F  S childId=$o(^DHCMEDADREVTI(PID,"MADREVI",childId)) Q:childId=""  D
	..S Code=$p(^DHCMEDADREVTI(PID,"MADREVI",childId),"^",1)  //代码
	..S Desc=$p(^DHCMEDADREVTI(PID,"MADREVI",childId),"^",2)  //描述
	..S Level=$p(^DHCMEDADREVTI(PID,"MADREVI",childId),"^",4) //级别
	..S Levelrowid=$p(^DHCMEDADREVTI(PID,"MADREVI",childId),"^",5) //上一级别的rowid
	..i Levelrowid'["||" d
	...s Levelrowid=0
	..i Levelrowid=0 d
	...s PCode=$p(^DHCMEDADREVT(PID),"^",1)
	..e  d
	...s chId=$p(Levelrowid,"||",2)
	...s PCode=$p(^DHCMEDADREVTI(PID,"MADREVI",chId),"^",1)  //父节点代码
	..s:childId'="" Id=PID_"||"_childId      //获取子表存储的id
	..S Active=$p(^DHCMEDADREVTI(PID,"MADREVI",childId),"^",3) //是否可用
	..S h=h+1
	..S TempStr=PID_"^"_Id_"^"_Desc_"^"_Level_"^"_Levelrowid_"^"_Code_"^"_PCode
	..S ^TMP("DHCADV","web.DHCADVFormDic","QueryTypeTree",pid,h)=TempStr
	S mdate=""
	Q:h=0 ##class(web.DHCADVMEDEVENTADD).getJsonEmptySign() //输出json结尾符
	S Title="PID^ID^text^Level^Levelrowid^Code^PCode"  //PID :主表id  ID:子表存储的id，主表默认为0  Levelrowid：上一级别的id
	///转换数据为Json格式
	//W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	W ##class(web.DHCADVMEDEVENTADD).getJsonStartSign(h)
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVFormDic","QueryTypeTree",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVFormDic","QueryTypeTree",pid,index))
	.S count = count+1
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVMEDEVENTADD).getJsonEndSign()  //输出json结尾符
	k ^TMP("DHCADV","web.DHCADVFormDic","QueryTypeTree",pid) //k掉临时global
	Q ""
}

/// Creator：      wangxuejian
/// CreatDate：    2018-08-23
/// Description:： 保存绑定数据到（DHC_AdvFormDic）
/// Table：        DHC_AdvFormDic
/// Input：	       field^title^style^$$...||parRef||pLabel
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCADVFormDic).saveTypeTree("advDevice^器械不良事件^checkbox^$$QX01^器械01^checkbox^advDevice$$QX01-01^器械01-01^checkbox^QX01||99903||QX-label")
ClassMethod saveTypeTree(params)
{
    n (params)
    s str=$p(params,"||",1)
    s parRef=$p(params,"||",2)  //lab的id
    s pLabel=$p(params,"||",3)  //lab的code
  	s $Zt="Error"
  	TStart
  	s ret=0,Id=0
  	s len=$l(str,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s mainTypeStr=$p(str,"$$",i)
  	.s Pcode=$p(mainTypeStr,"^",4) //父节点的code（数据源的）
  	.s linkID="",linkdicid="",parRefFiled=""  // 根据父节点code在 DHC_AdvFormDicLink 表里面取相应的父节点对应的最新元素id（一个code可能绑定多个元素），根据元素id获取元素表（DHC_AdvFormDic）对应的filed 
  	.s:Pcode'="" linkID=$o(^DHCADVFDLINK(0,"SourceCode",Pcode,""),-1)
  	.s:linkID'="" linkdicid=$p(^DHCADVFDLINK(linkID),"^",1)
  	.s:linkdicid'="" parRefFiled=$LIST(^User.DHCAdvFormDicD(linkdicid),2)  // 父节点code 在元素白表中的filed
  	.i parRefFiled'="" d
  	..;s Pcode=pLabel_"-"_parRefcode     //将label增加到前缀
  	..;s alphaupField=##class(web.DHCADVAction).ALPHAUP(Pcode)
  	..s parRef=linkdicid ;$o(^User.DHCAdvFormDicI("IndexField",alphaupField,""))  //插入父节点
  	.s code=$p(mainTypeStr,"^",1)  //当前code
  	.s title=$p(mainTypeStr,"^",2)
  	.s style=$p(mainTypeStr,"^",3)
  	.s:parRefFiled="" code=pLabel_"-"_code
  	.s:parRefFiled'="" code=parRefFiled_"-"_code      //需要保存到dic表里面的code
  	.s alphaupField=##class(web.DHCADVAction).ALPHAUP(code)
  	.s Id=$o(^User.DHCAdvFormDicI("IndexField",alphaupField,"")) //是否被插入了
  	.s NmainTypeStr=code_"^"_title_"^"_style_"^"_Id  //插入dic表的新字符串
  	.s ret=..saveMaintType(NmainTypeStr,parRef)
  	.s alphaupField=##class(web.DHCADVAction).ALPHAUP(code)
  	.s code=$p(mainTypeStr,"^",1)  //当前code
  	.s Id=$o(^User.DHCAdvFormDicI("IndexField",alphaupField,"")) //获取插入的dic表的id
  	.i Id'="" d       //插入数据源
  	..s tmpStr=Id_"^"_code
  	..s return=..inserFormDicLink(tmpStr)
  	.s parRef=$p(params,"||",2)
	i ret'=0 TRollback
	q:ret'=0 ret
	TCOMMIT
	q ret
Error
	TRollback
	q -1
}

/// Description: 增加数据源
/// CreateDate:  2018-08-23
/// Table:		 DHC_AdvFormDicLink
/// Input:  	 DataList: 以字符"^"分割,格式为:formdic的id, 数据源code
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVFormDic).inserFormDicLink("^81^ceshi^ceshi^Y")
ClassMethod inserFormDicLink(DataList As %String) As %String
{
	N (DataList)
	S dicId=$p(DataList,"^",1)
	S code=$p(DataList,"^",2)
	s id=$o(^DHCADVFDLINK(0,"FormDic",dicId,"")) //该条记录是否被绑定
	i id="" d                         //如果没有绑定进行绑定
 	.&SQL(INSERT INTO DHC_AdvFormDicLink(FDL_FormDic_Dr, FDL_SourceCode) VALUES(:dicId,:code))
 	e  d
 	.s SQLCODE="-100"
 	Q SQLCODE
}

/// Creator：      wangxuejian
/// CreatDate：    2018-08-23
/// Description:： 维护的数据保存到DHC_AdvFormDic
/// Table：        DHC_AdvFormDic
/// Input：	       field^title^style^parRef
/// Return：       保存成功 0，其他 失败
/// d ##class(web.DHCADVFormDic).saveMaintType()
ClassMethod saveMaintType(str, parRef)
{
 n (str,parRef)
 s field=$p(str,"^",1)
 s title=$p(str,"^",2)
 s style=$p(str,"^",3)
 s ID=$p(str,"^",4)
 s alphaupField=##class(web.DHCADVAction).ALPHAUP(field)
 s alphaupTitle=##class(web.DHCADVAction).ALPHAUP(title)
 q:(alphaupField="")&&(parRef=0) -10
 s tmpId=0
 i alphaupField'="" d
 .s tmpId=$o(^User.DHCAdvFormDicI("IndexField",alphaupField,""))
 // 新增重复判断
 q:(ID=0)&&(+tmpId'=0) -11
 //修改重复项
 q:(ID'=0)&&(+tmpId'=0)&&(+tmpId'=ID) -12
 i +ID=0 d
 .s obj=##class(User.DHCAdvFormDic).%New()
 e  d
 .s obj=##class(User.DHCAdvFormDic).%OpenId(ID)
 .d obj.%Reload()
 
 s obj.field=field
 s obj.style=style
 s obj.title=title
 s obj.parRef=parRef
 s sc=obj.%Save()
 i $$$ISERR(sc) q -1
 //新增子元素,如果子元素field为空，自动生成field
 i (parRef'=0)&&(alphaupField="")&&(ID=0) d
 .s obj.field=$List(^User.DHCAdvFormDicD(parRef),2)_"-"_obj.%Id()
 .s sc=obj.%Save()
 q 0
}

/// Description: 删除数据源
/// CreateDate:  2018-08-28
/// Table:		 DHC_AdvFormDicLink
/// Input:  	 DataList: dicId
/// Others:		 w ##class(web.DHCADVFormDic).deleteFormDicLink("^81^ceshi^ceshi^Y")
ClassMethod deleteFormDicLink(dicId As %String) As %String
{
	N (dicId)
	s id=$o(^DHCADVFDLINK(0,"FormDic",dicId,"")) //是否有该条记录
	i id'="" d                         //如果没有删除该条记录
 	.&SQL(Delete From DHC_AdvFormDicLink Where FDL_RowID=:id)
 	e  d
 	.s SQLCODE="-100"
 	Q SQLCODE
}

}
