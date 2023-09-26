Import sqluser

/// 表单辅助操作类
/// 2017-09-22
/// zhouxin
Class web.DHCADVAction Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 从旧表中同步表单基础数据
/// d ##class(web.DHCADVAction).getDataFromOld()
/// d ##class(web.DHCADVAction).clearData()
ClassMethod getDataFromOld()
{
	//清除数据
	d ##class(web.DHCADVAction).clearData()
	w "数据清除成功!",!
	//同步字典表
	d ##class(web.DHCADVAction).syncDic()
	//同步表单名称和表单分类
	d ##class(web.DHCADVAction).syncFormName()
	//同步表单布局表
	d ##class(web.DHCADVAction).syncForm()
	//更新表单字典表的所属表单
	d ##class(web.DHCADVAction).updateDicCat()
}

/// 清除数据
ClassMethod clearData()
{
	&sql(delete from DHC_AdvFormName)
	&sql(delete from DHC_AdvFormCat)
	&sql(delete from DHC_AdvForm)
	&sql(delete from DHC_AdvFormDic)
	&sql(delete from DHC_AdvFormAttr)
}

/// 同步字典表
ClassMethod syncDic(oldParef = 0, newParef = 0)
{
	
	n (oldParef,newParef)
	s oldDicId=""
	f  s oldDicId=$o(^FORMDIC(0,"PARREF",oldParef,oldDicId)) q:oldDicId=""  d
	.q:+oldDicId=0
	.s advDicObj=##class(User.DHCAdvFormDic).%New()
	.s advDicObj.field=$p(^FORMDIC(oldDicId),"^",1)
	.s advDicObj.style=$p(^FORMDIC(oldDicId),"^",2)
	.s advDicObj.title=$p(^FORMDIC(oldDicId),"^",3)
	.s advDicObj.url=$p(^FORMDIC(oldDicId),"^",4)
	.//s oldParef=$p(^FORMDIC(oldDicId),"^",5)
	.//q:(+oldParef'=0)&&('$d(^FORMDIC(oldParef)))
	.s advDicObj.parRef=newParef
	.s advDicObj.value=$p(^FORMDIC(oldDicId),"^",6)
	.s advDicObj.newLine=$p(^FORMDIC(oldDicId),"^",7)
	.s advDicObj.width=$p(^FORMDIC(oldDicId),"^",9)
	.s advDicObj.height=$p(^FORMDIC(oldDicId),"^",10)
	.s advDicObj.cols=$p(^FORMDIC(oldDicId),"^",11)
	.s advDicObj.rows=$p(^FORMDIC(oldDicId),"^",12)
	.s advDicObj.sameLevel=$p(^FORMDIC(oldDicId),"^",14)
	.s advDicObj.hiddenValue=$p(^FORMDIC(oldDicId),"^",15)
	.s advDicObj.hiddenSub=$p(^FORMDIC(oldDicId),"^",16)
	.s advDicObj.cat=$p(^FORMDIC(oldDicId),"^",13)
	.d advDicObj.%Save()
	.d ..syncDic(oldDicId,advDicObj.%Id())
	w "同步字典表成功",!
}

/// 同步表单名称和表单分类
ClassMethod syncFormName()
{
	s num=0
	//表单表
	s formName=""
	f  s formName=$o(^FORMNAME(formName)) q:formName=""  d
	.q:formName=0
	.s code=$p(^FORMNAME(formName),"^",1)
	.s version=$p(^FORMNAME(formName),"^",3)
	.s advFromNameId=$o(^User.DHCAdvFormNameI("IndexCode",$SYSTEM.Util.Collation(code,6),""))
	.i +advFromNameId=0 d
	..s advFormNameObj=##class(User.DHCAdvFormName).%New()
	.e  d
	..s advFormNameObj=##class(User.DHCAdvFormName).%OpenId(advFromNameId)
	.//b
	.s advFormNameObj.code=code
	.s advFormNameObj.name=$p(^FORMNAME(formName),"^",2)
	.s advFormNameObj.version=version
	.s advFormNameObj.jsPath=$p(^FORMNAME(formName),"^",4)
	.s advFormNameObj.type=$p(^FORMNAME(formName),"^",5)
	.//表单分类
	.s oldCatId=$p(^FORMNAME(formName),"^",6)
	.i +oldCatId'=0 d
	..s formCatCode=$LIST(^User.FormCatD(oldCatId),2)
	..s newCatId=$o(^User.DHCAdvFormCatI("IndexCode",$SYSTEM.Util.Collation(formCatCode,6),""))
	..i +newCatId=0 d
	...s catObj=##class(User.DHCAdvFormCat).%New()
	...s catObj.code=$LIST(^User.FormCatD(oldCatId),2)
	...s catObj.name=$LIST(^User.FormCatD(oldCatId),3)
	...d catObj.%Save()
	...s newCatId=catObj.%Id()
	..d advFormNameObj.catSetObjectId(newCatId)
	.
	.d advFormNameObj.%Save()
	.s num=num+1
	w "同步表单名称表成功："_num_"条",!
}

/// 同步表单布局表
ClassMethod syncForm()
{

	//表单布局表
	
	s formName=""
	f  s formName=$o(^FORMNAME(formName)) q:formName=""  d
	.q:formName=0
	.s code=$p(^FORMNAME(formName),"^",1)
	.s version=$p(^FORMNAME(formName),"^",3)
	.s advFromNameId=$o(^User.DHCAdvFormNameI("IndexCode",$SYSTEM.Util.Collation(code,6),""))
	.
	.s form=""
	.f  s form=$o(^FORM(0,"VERSION",formName,version,0,form)) q:form=""  d
	..
	..
	..s oldDicId=+$p(^FORM(form),"^",3)
	..q:'$d(^FORMDIC(oldDicId))
	..s advFromObj=##class(User.DHCAdvForm).%New()
	..i oldDicId'=0 d
	...
	...s dicField=$p(^FORMDIC(oldDicId),"^",1)
	...s newDicId=$o(^User.DHCAdvFormDicI("IndexField",$SYSTEM.Util.Collation(dicField,6),""))
	...//表单字典表
	...i +newDicId=0 d
	....w "err:oldDicId:"_oldDicId,!
	...e  d
	....d advFromObj.formDicSetObjectId(newDicId)
	..d advFromObj.formNameSetObjectId(advFromNameId)
	..s advFromObj.parRef=0
	..s advFromObj.rowStyle=$p(^FORM(form),"^",7)
	..s advFromObj.rowType=$p(^FORM(form),"^",6)
	..s advFromObj.version=$p(^FORM(form),"^",8)
	..d advFromObj.%Save()
	..d ..syncFormAttr(form,advFromObj.%Id())
	..d ..syncFormSub(form,advFromObj.%Id(),formName,advFromNameId,version)
}

ClassMethod syncFormSub(paref, newParef, formName, newFormName, version)
{
	n (paref,newParef,formName,newFormName,version)
	

	s form=""
	f  s form=$o(^FORM(0,"VERSION",formName,version,paref,form)) q:form=""  d
	.
	.s oldDicId=+$p(^FORM(form),"^",3)
	.q:'$d(^FORMDIC(oldDicId))
	.s advFromObj=##class(User.DHCAdvForm).%New()
	.i oldDicId'=0 d
	..s dicField=$p(^FORMDIC(oldDicId),"^",1)
	..s newDicId=$o(^User.DHCAdvFormDicI("IndexField",$SYSTEM.Util.Collation(dicField,6),""))
	..i +newDicId=0 d
	...w "err:oldDicId:"_oldDicId,!
	..e  d
	...d advFromObj.formDicSetObjectId(newDicId)
	.d advFromObj.formNameSetObjectId(newFormName)
	.s advFromObj.parRef=newParef
	.s advFromObj.rowStyle=$p(^FORM(form),"^",7)
	.s advFromObj.rowType=$p(^FORM(form),"^",6)
	.s advFromObj.version=$p(^FORM(form),"^",8)
	.d advFromObj.%Save()
	.d ..syncFormAttr(form,advFromObj.%Id())
	.d ..syncFormSub(form,advFromObj.%Id(),formName,newFormName,version)
}

/// 表单元素属性
ClassMethod syncFormAttr(form, newForm)
{
	
	n (form,newForm)
	s attrDic=""
	f  s attrDic=$o(^User.FormAttrI("IndexItmDic",form,attrDic)) q:attrDic=""  d
	.
	.s dicField=$p(^FORMDIC(attrDic),"^",1)
	.s newDicId=$o(^User.DHCAdvFormDicI("IndexField",$SYSTEM.Util.Collation(dicField,6),""))
	.s oldAttrId=""
	.f  s oldAttrId=$o(^User.FormAttrI("IndexItmDic",form,attrDic,oldAttrId)) q:oldAttrId=""  d
	..
	..s newAttrObj=##class(User.DHCAdvFormAttr).%New()
	..D newAttrObj.formDicSetObjectId(newDicId)
	..D newAttrObj.formItmSetObjectId(newForm)
	..s newAttrObj.print=$List(^User.FormAttrD(oldAttrId),6)
	..s newAttrObj.printSeq=$List(^User.FormAttrD(oldAttrId),5)
	..s newAttrObj.required=$List(^User.FormAttrD(oldAttrId),4)
	..d newAttrObj.%Save()
}

/// 更新表单字典分类
ClassMethod updateDicCat()
{
	s dic=""
	f  s dic=$o(^User.DHCAdvFormDicD(dic)) q:dic=""  d
	.
	.s cat=$List(^User.DHCAdvFormDicD(dic),14)
	.q:+cat=0
	.
	.s oldFormNameCode=$p(^FORMNAME(cat),"^",1)
	.s newFormName=$o(^User.DHCAdvFormNameI("IndexCode",$SYSTEM.Util.Collation(oldFormNameCode,6),""))
	.
	.s dicObj=##class(User.DHCAdvFormDic).%OpenId(dic)
	.s dicObj.cat=newFormName
	.d dicObj.%Save()
}

/// ##class(web.DHCADVAction).ALPHAUP()
ClassMethod ALPHAUP(par)
{
	q $SYSTEM.Util.Collation(par,6)
	//q $$ALPHAUP^SSUTIL4(par)
}

/// Descript:      保存表单元素(支持bootstrap的grid)
/// Creator:       zhouxin
/// CreatDate；    2017-7-3
/// w ##class(web.DHCAction).SaveFormGrid("col-md-6#5@children1>col-md-8*children2>col-sm-3:&col-sm-9:11,10$col-md-4*!col-md-6#")
ClassMethod SaveFormGrid(str As %String, id = "")
{
	
	n (str,id)
	//k ^FORM
	q:id="" "表单不能为空"
	s $zt="Err"
	//s ^ZXZX(str)=id
	TS
	
	
	s formNameObj=##class(User.DHCAdvFormName).%OpenId(id)
	d formNameObj.%Reload()
	s version=+formNameObj.version+1
	s formNameObj.version=version
	s sc=formNameObj.%Save()
	
	d ..removeFormAttr(formNameObj.%Id())
	s ret=0
	f row=1:1:$l(str,"^") d
	.
	.s form=##class(User.DHCAdvForm).%New()
	.s form.formName=formNameObj
	.s form.rowType="row"
	.s form.rowStyle="row"
	.s form.version=version
	.s sc=form.%Save()
	.If $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	.q:ret'=0
	.s subStr=$p(str,"^",row)
	.s parRef=form.%Id()
	.//一行的多少列
	.f column=1:1:$l(subStr,"!") d
	..q:ret'=0
	..s tmp=$p(subStr,"!",column)
	..//每列占多少百分比
	..s style=$p(tmp,"#",1)
	..//每列的值
	..s value=$p(tmp,"#",2)
	
	..s form=##class(User.DHCAdvForm).%New()
	..s form.formName=formNameObj
	..s form.rowType="column"
	..s form.parRef=parRef
	..s form.rowStyle=style
	..s form.version=version
	..s sc=form.%Save()
	..If $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	..q:ret'=0
	..s columnParRef=form.%Id()
	..f sub=1:1:$l(value,"@") d
	...q:ret'=0
	...s tmp1=$p(value,"@",sub)
	...q:tmp1=""
	...s form=##class(User.DHCAdvForm).%New()
	...s form.formName=formNameObj
	...s form.rowType="element"
	...s form.parRef=columnParRef
	...s form.rowStyle=style
	...s form.version=version
	...i ($f(tmp1,"children1>")=0)&&(+tmp1>0) d
	....s form.formDic=##class(User.DHCAdvFormDic).%OpenId($p(tmp1,"~",1))
	....s sc=form.%Save()
	....d ..SaveFormAttr(form.%Id(),tmp1)
	...e  d
	....s form.rowType="row"
	....s form.rowStyle="row"
	....s sc=form.%Save()
	...If $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	...//判断子节点
	...
	...i $f(tmp1,"children1>")>0 d
	....s parRef2=form.%Id()
	....s childrenValue=$p(tmp1,"children1>",2)
	....//b 7
	....f sub2=1:1:$l(childrenValue,"$") d
	.....
	.....s tmp2=$p(childrenValue,"$",sub2)
	.....s style2=$p(tmp2,"*",1)
	.....s value2=$p(tmp2,"*",2)
	.....s form=##class(User.DHCAdvForm).%New()
	.....s form.formName=formNameObj
	.....s form.rowType="column"
	.....s form.parRef=parRef2
	.....s form.rowStyle=style2
	.....s form.version=version
	.....s sc=form.%Save()
	.....If $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	.....q:ret'=0
	.....s columnParRef2=form.%Id()
	.....//b 111111
	.....f sub3=1:1:$l(value2,"%") d
	......q:ret'=0
	......s value3=$p(value2,"%",sub3)
	......q:value3=""
	......s form=##class(User.DHCAdvForm).%New()
	......s form.formName=formNameObj
	......s form.rowType="element"
	......s form.parRef=columnParRef2
	......s form.rowStyle=style2
	......s form.version=version
	......//b 33
	......i ($f(value3,"children2>")=0)&&(+value3>0) d
	.......s form.formDic=##class(User.DHCAdvFormDic).%OpenId($p(value3,"~",1))
	.......s sc=form.%Save()
	.......d ..SaveFormAttr(form.%Id(),value3)
	......e  d
	.......s form.rowType="row"
	.......s form.rowStyle="row"
	.......s sc=form.%Save()
	......i $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	......//b 44
	......i $f(value3,"children2>")>0 d
	.......s parRef3=form.%Id()
	.......s childrenValue4=$p(value3,"children2>",2)
	.......//b 2
	.......f sub4=1:1:$l(childrenValue4,"&") d
	........s tmp4=$p(childrenValue4,"&",sub4)
	........s style4=$p(tmp4,"+",1)
	........s value4=$p(tmp4,"+",2)
	........s form=##class(User.DHCAdvForm).%New()
	........s form.formName=formNameObj
	........s form.rowType="column"
	........s form.parRef=parRef3
	........s form.rowStyle=style4
	........s form.version=version
	........s sc=form.%Save()
	........If $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	........s columnParRef3=form.%Id()
	........//b 3
	........f sub5=1:1:$l(value4,",") d
	.........q:ret'=0
	.........q:$p(value4,",",sub5)=""
	.........s form=##class(User.DHCAdvForm).%New()
	.........s form.formName=formNameObj
	.........s form.rowType="element"
	.........s form.parRef=columnParRef3
	.........s form.rowStyle=style4
	.........s form.version=version
	.........s:+$p(value4,",",sub5)>0 form.formDic=##class(User.DHCAdvFormDic).%OpenId($p($p(value4,",",sub5),"~",1))
	.........s sc=form.%Save()
	.........d ..SaveFormAttr(form.%Id(),$p(value4,",",sub5))
	.........If $$$ISERR(sc)  s ret=$System.Status.GetErrorText(sc)
	i ret'=0 d
	.TRO
	q:ret'=0 ret
	TC
	q 0
Err
  TRO
  q $ze
}

// 保存表单附加属性

ClassMethod SaveFormAttr(newItmId As %String = "", str = "")
{
	
	n (newItmId,str)
	//s ^ZXZX(newItmId)=str
	s len=$l(str,"~")
	f i=2:1:len d
	.
	.s tmp=$p(str,"~",i)
	.q:tmp=""
	.s dicId=$p(tmp,"|",3)
	.q:dicId=""
	.q:+dicId=0
	.s requird=$p(tmp,"|",4)
	.s printSeq=$p(tmp,"|",5)
	.s print=$p(tmp,"|",6)
	.s style=$p(tmp,"|",8)
	.q:(requird="")&&(print="")&&(printSeq="")&&(style="")
	.s obj=##class(User.DHCAdvFormAttr).%New()
	.d obj.formDicSetObjectId(dicId) 
	.d obj.formItmSetObjectId(newItmId)
	.s obj.required=requird
	.s obj.print=print
	.s obj.printSeq=printSeq
	.s obj.style=style
	.d obj.%Save()
}

// 删除表单附加属性

ClassMethod removeFormAttr(formName As %String = "")
{
	n (formName)
	//&sql( delete from DHC_AdvFormAttr where formItm->formName=:formName)
}

}
