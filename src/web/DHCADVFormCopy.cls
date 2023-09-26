/// 表单复制
/// zhouxin
/// 2017-10-13
Class web.DHCADVFormCopy Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// d ##class(web.DHCADVFormCopy).copyForm("reqreqreqreq","reqreqreqreq",822)
/// 复制表单
ClassMethod copyForm(code, name, id, hospdr)
{
	n (code, name,id,hospdr)
	s $zt="err"
	s tmpId=+$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(code),""))
	q:+tmpId'=0 1
	
	s data=^User.DHCAdvFormNameD(id)
	s formNameObj=##class(User.DHCAdvFormName).%New()
	s formNameObj.version=1
	s formNameObj.name=name
	s formNameObj.code=code
	s formNameObj.jsPath=$lg(data,5)
	s formNameObj.type=$lg(data,6)
	i +$lg(data,7)'=0 d formNameObj.catSetObjectId($lg(data,7))
	s formNameObj.active=$lg(data,8)
	s formNameObj.width=$lg(data,9)
	i +hospdr'=0 d formNameObj.hospdrSetObjectId(hospdr)
	d formNameObj.%Save()
	s hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_AdvFormName",formNameObj.%Id(),hospdr)
 	q:hospflag'=0 -3
	d ##class(web.DHCADVFormCopy).syncForm(0,0,formNameObj.%Id(),id)
	q 0
err
  q 2
}

/// 复制子表单
ClassMethod syncForm(formParef, oldFormParef, formName, oldFormName)
{
	
	n (formParef, oldFormParef, formName, oldFormName)
	s version=$List(^User.DHCAdvFormNameD(oldFormName),4)
	s form=""
	f  s form=$o(^User.DHCAdvFormI("IndexNameVersionParef",oldFormName," "_version," "_oldFormParef,form)) q:form=""  d
	.
	.s data=^User.DHCAdvFormD(form)
	.s advFromObj=##class(User.DHCAdvForm).%New()
	.d advFromObj.formDicSetObjectId($List(data,4))
	.d advFromObj.formNameSetObjectId(formName)
	.s advFromObj.parRef=formParef
	.s advFromObj.rowStyle=$List(data,8)
	.s advFromObj.rowType=$List(data,7)
	.s advFromObj.version=1
	.d advFromObj.%Save()
	.d ..syncFormAttr(form,advFromObj.%Id())
	.d ..syncForm(advFromObj.%Id(),form,formName,oldFormName)
}

ClassMethod syncFormAttr(form, newForm)
{
	
	n (form,newForm)
	s attrDic=""
	f  s attrDic=$o(^User.DHCADVFormAttrI("IndexItmDic",form,attrDic)) q:attrDic=""  d
	.
	.s oldAttrId=""
	.f  s oldAttrId=$o(^User.DHCADVFormAttrI("IndexItmDic",form,attrDic,oldAttrId)) q:oldAttrId=""  d
	..
	..s newAttrObj=##class(User.DHCAdvFormAttr).%New()
	..D newAttrObj.formDicSetObjectId(attrDic)
	..D newAttrObj.formItmSetObjectId(newForm)
	..s newAttrObj.print=$List(^User.DHCADVFormAttrD(oldAttrId),6)
	..s newAttrObj.printSeq=$List(^User.DHCADVFormAttrD(oldAttrId),5)
	..s newAttrObj.required=$List(^User.DHCADVFormAttrD(oldAttrId),4)
	..s newAttrObj.style=$ListGet(^User.DHCADVFormAttrD(oldAttrId),8)
	..d newAttrObj.%Save()
}

}
