Import sqluser

/// 表单的导入和导出
/// zhouxin
/// 2017-10-13
Class web.DHCADVFormExport Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 导出数据
/// zhouxin
/// 2017-10-13
/// w ##class(web.DHCADVFormExport).exportFormName(934)
ClassMethod exportFormName(id)
{
	n (id)
	s pid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("web.DHCADVFormExport","export",pid)
	s main=$LISTTOSTRING(^User.DHCAdvFormNameD(id),"^",1)
	s version=$LIST(^User.DHCAdvFormNameD(id),4)
    
	s form="",count=0,dicCount=0
	f  s form=$o(^User.DHCAdvFormI("IndexNameVersion",id,version,form)) q:form=""  d
	.s count=count+1
	.s formStr=$LISTTOSTRING(^User.DHCAdvFormD(form),"^",1)_"^"_form
	.s $p(formStr,"^",1)=form
	.//导出布局
	.s ^TMP("web.DHCADVFormExport","export",pid,count)=formStr
	.s dicStr=""
	.s dic=+$List(^User.DHCAdvFormD(form),4)
	.i dic'=0 d
	..
	..//导出字典
	..s dicCount=+$o(^TMP("web.DHCADVFormExport","exportDic",pid,""),-1)+1
	..s dicStr=$LISTTOSTRING(^User.DHCAdvFormDicD(dic),"^",1)
	..s $p(dicStr,"^",1)=dic
	..s dicStr=##class(ext.util.String).EvalJSON(dicStr)
	..s ^TMP("web.DHCADVFormExport","exportDic",pid,dicCount)=dicStr
	..//导出attr
	..s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",form,dic,""))
	..i attr'=0 d
	...s attrCount=+$o(^TMP("web.DHCADVFormExport","exportAttr",pid,""),-1)+1
	...s ^TMP("web.DHCADVFormExport","exportAttr",pid,attrCount)=##class(ext.util.String).EvalJSON($LISTTOSTRING(^User.DHCADVFormAttrD(attr),"^",1))
	..d ..countFormDic(pid,dic,form)
	s dicCount=+$o(^TMP("web.DHCADVFormExport","exportDic",pid,""),-1)
	s attrCount=+$o(^TMP("web.DHCADVFormExport","exportAttr",pid,""),-1)
	w pid_","_count_","_dicCount_","_attrCount_","_main
	q ""
}

/// 统计字典条目数
ClassMethod countFormDic(pid, dic, form)
{
	n (pid,dic,form)
	s subDic=""
	f  s subDic=$o(^User.DHCAdvFormDicI("IndexParef"," "_dic,subDic)) q:subDic=""  d
	.s count=+$o(^TMP("web.DHCADVFormExport","exportDic",pid,""),-1)+1
	.s dicStr=$LISTTOSTRING(^User.DHCAdvFormDicD(subDic),"^",1)
	.s $p(dicStr,"^",1)=subDic
	.s dicStr=##class(ext.util.String).EvalJSON(dicStr)
	.s ^TMP("web.DHCADVFormExport","exportDic",pid,count)=dicStr
	.//导出attr
	.s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",form,subDic,""))
	.i attr'=0 d
	..s attrCount=+$o(^TMP("web.DHCADVFormExport","exportAttr",pid,""),-1)+1
	..s ^TMP("web.DHCADVFormExport","exportAttr",pid,attrCount)=##class(ext.util.String).EvalJSON($LISTTOSTRING(^User.DHCADVFormAttrD(attr),"^",1))
	.d ..countFormDic(pid,subDic,form)
	q ""
}

ClassMethod exportForm(pid, count)
{
	n (pid,count)
	w ^TMP("web.DHCADVFormExport","export",pid,count)
	k ^TMP("web.DHCADVFormExport","export",pid,count)
	q ""
}

ClassMethod exportFormDic(pid, count)
{
	n (pid,count)
	w ^TMP("web.DHCADVFormExport","exportDic",pid,count)
	k ^TMP("web.DHCADVFormExport","exportDic",pid,count)
	q ""
}

ClassMethod exportFormAttr(pid, count)
{
	n (pid,count)
	w ^TMP("web.DHCADVFormExport","exportAttr",pid,count)
	k ^TMP("web.DHCADVFormExport","exportAttr",pid,count)
	q ""
}

/// 获取pid
/// zhouxin
/// 2017-10-17
/// w ##class(web.DHCADVFormExport)importForm(1)
ClassMethod importPid()
{

	s pid=##class(web.DHCADVCOMMON).NewPid()
	w pid
	q ""
}

/// 导入数据
/// zhouxin
/// 2017-10-17
ClassMethod importData(pid, row, data, dicFlag)
{
	n (pid,row,data,dicFlag)
	s dicId=0
	i +dicFlag=1 d
	.s ^TMP("web.DHCADVFormExport","importDic",pid,row)=data
	.i $p(data,"^",2)'="" d
	..s dicId=+$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP($p(data,"^",2)),""))
	e  i +dicFlag=2 d
	.s ^TMP("web.DHCADVFormExport","importAttr",pid,row)=data
	e  d
	.s ^TMP("web.DHCADVFormExport","import",pid,row)=data
	i dicId=0 d
	.w 0
	e  d
	.w 1
	q ""
}

/// 检查表单代码是否存在
ClassMethod checkFormName(pid)
{
	s formNameStr=^TMP("web.DHCADVFormExport","import",pid,1)
	s formNameCode=$P(formNameStr,"^",2)
	s formNameId=$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(formNameCode),""))
	w +formNameId
	q ""
}

/// 导入数据
/// zhouxin
/// 2017-10-17
/// w ##class(web.DHCADVFormExport).import(18)
ClassMethod import(pid, HospDr = "")
{
	n (pid,HospDr)
	
	k ^TMP("web.DHCADVFormExport","oldDicToNewDic",pid)
	k ^TMP("web.DHCADVFormExport","oldParfToNewParfId",pid)
	
	s $zt="err"
	TStart
	s formNameStr=^TMP("web.DHCADVFormExport","import",pid,1)
	s formNameCode=$P(formNameStr,"^",2)
	s formNameId=+$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(formNameCode),""))

	i +formNameId'=0 d
	.;&sql(delete from DHC_AdvForm WHERE formName=:formNameId)  ;2020-09-25 cy 导入不影响以前版本的表单
	.s formNameObj=##class(User.DHCAdvFormName).%OpenId(formNameId)
	e  d
	.s formNameObj=##class(User.DHCAdvFormName).%New()
	s newversion=$o(^User.DHCAdvFormI("IndexNameVersion",formNameId,""),-1)+1  ;2020-09-25 cy 导入不影响以前版本的表单
	///导入表单名称表
	s formNameObj.code=$P(formNameStr,"^",2)
	s formNameObj.name=$P(formNameStr,"^",3)
	s formNameObj.jsPath=$P(formNameStr,"^",5)
	s formNameObj.type=$P(formNameStr,"^",6)
	s formNameObj.version=newversion  ;2020-09-25 cy 导入不影响以前版本的表单
	s formNameObj.active="N" ;2021-07-09 cy 导入表单默认不可用 需要使用时手动修改数据
	i +HospDr'=0 d
	.d formNameObj.hospdrSetObjectId(HospDr)  ;2021-06-29 cy 导入时医院也存储
	d formNameObj.%Save()
	s formNameId=formNameObj.%Id()
	s hospflag=0 ;2021-06-29 cy 导入时医院也存储
	s:+HospDr'=0 hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_AdvFormName",formNameId,HospDr)
	q:(+HospDr'=0)&&(hospflag'=0) -3
	
	//删除已存在元素的子元素 2019-06-14 cy修改 存在的子元素不删除
	/*s dicCount=""
	f  s dicCount=$o(^TMP("web.DHCADVFormExport","importDic",pid,dicCount)) q:dicCount=""  d
	.
	.s dicStr=^TMP("web.DHCADVFormExport","importDic",pid,dicCount)
	.q:"dicstart"=dicStr
	.q:+$p(dicStr,"^",1)=0
	.s dicId=+$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP($p(dicStr,"^",2)),""))
	.i dicId'=0 d
	..&sql(delete from DHC_AdvFormDic where parRef=:dicId)*/
		
	
	///导入表单字典表
	s dicCount=""
	f  s dicCount=$o(^TMP("web.DHCADVFormExport","importDic",pid,dicCount)) q:dicCount=""  d
	.
	.s dicStr=^TMP("web.DHCADVFormExport","importDic",pid,dicCount)
	.q:"dicstart"=dicStr
	.q:+$p(dicStr,"^",1)=0
	.s dicId=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP($p(dicStr,"^",2)),""))
	.i +dicId=0 d
	..s dicObj=##class(User.DHCAdvFormDic).%New()
	.e  d
	..s dicObj=##class(User.DHCAdvFormDic).%OpenId(+dicId)
	.s dicObj.field=$p(dicStr,"^",2)
	.s dicObj.style=$p(dicStr,"^",3)
	.s dicObj.title=$p(dicStr,"^",4)
	.s dicObj.url=$p(dicStr,"^",5)
	.s dicObj.parRef=$p(dicStr,"^",6)
	.s dicObj.value=$p(dicStr,"^",7)
	.s dicObj.newLine=$p(dicStr,"^",8)
	.//s dicObj.code=$p(dicStr,"^",9)
	.s dicObj.width=$p(dicStr,"^",10)
	.s dicObj.height=$p(dicStr,"^",11)
	.s dicObj.cols=$p(dicStr,"^",12)
	.s dicObj.textarerows=$p(dicStr,"^",13)
	.i +$p(dicStr,"^",14)=0 d
	..s dicObj.cat=$p(dicStr,"^",14)
	.e  d
	..s dicObj.cat=formNameId
	.s dicObj.sameLevel=$p(dicStr,"^",15)
	.s dicObj.hiddenValue=$p(dicStr,"^",16)
	.s dicObj.hiddenSub=$p(dicStr,"^",17)
	.s dicObj.subDicSameLine=$p(dicStr,"^",18)
	.s dicObj.canCopy=$p(dicStr,"^",19)
	.s dicObj.displayTitle=$p(dicStr,"^",20)
	.s dicObj.seq=$p(dicStr,"^",21)
	.s dicObj.userEdit=$p(dicStr,"^",22)
	.s dicObj.hidden=$p(dicStr,"^",23)
	.d dicObj.%Save()
	.s dicId=dicObj.%Id()
	.//存储元素新id
	.s ^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,$p(dicStr,"^",1))=dicId
	
	//更新字典表父子结构
	s dicCount=""
	f  s dicCount=$o(^TMP("web.DHCADVFormExport","importDic",pid,dicCount)) q:dicCount=""  d
	.s dicStr=^TMP("web.DHCADVFormExport","importDic",pid,dicCount)
	.q:"dicstart"=dicStr
	.q:dicStr="attrstart"
	.q:$p(dicStr,"^",1)=""
	.s newDicId=^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,$p(dicStr,"^",1))
	.q:newDicId=""
	.s newDicObj=##class(User.DHCAdvFormDic).%OpenId(newDicId)
	.i +newDicObj.parRef'=0 d
	..i $d(^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,+newDicObj.parRef)) d
	...s newDicObj.parRef=^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,+newDicObj.parRef)
	...d newDicObj.%Save()
	
	///导入表单布局表
	s row=1
	f  s row=$o(^TMP("web.DHCADVFormExport","import",pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("web.DHCADVFormExport","import",pid,row)
	.s formStr=$p(str,",",1)
	.s formObj=##class(User.DHCAdvForm).%New()
	.s formObj.rowStyle=$p(formStr,"^",8)
	.s formObj.rowType=$p(formStr,"^",7)
	.s formObj.version=newversion  ;2020-09-25 cy 导入不影响以前版本的表单
	.s formObj.parRef=$p(formStr,"^",5)
	.d formObj.formNameSetObjectId(formNameId)
	.i +$p(formStr,"^",4)>0 d
	..s newDic=^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,$p(formStr,"^",4))
	..d formObj.formDicSetObjectId(newDic)
	.d formObj.%Save()
	.s oldFormParId=$p(formStr,"^",11)
	.//旧的表单id和新的表单id对照global
	.//新表单表中父表单id存的是旧表单id
	.s:oldFormParId'="" ^TMP("web.DHCADVFormExport","oldParfToNewParfId",pid,oldFormParId)=formObj.%Id()
	.s:$p(formStr,"^",1)'="" ^TMP("web.DHCADVFormExport","oldFormToNew",pid,$p(formStr,"^",1))=formObj.%Id()
	
	s form="",count=0
	f  s form=$o(^User.DHCAdvFormI("IndexNameVersion",formNameId,newversion,form)) q:form=""  d  ;2020-09-25 cy 导入不影响以前版本的表单
	.
	.s formObj=##class(User.DHCAdvForm).%OpenId(form)
	.//更新关联父表id为新表的id
	.s oldFormparRId=+formObj.parRef
	.i +oldFormparRId'=0 d
	..i $d(^TMP("web.DHCADVFormExport","oldParfToNewParfId",pid,oldFormparRId)) d
	...s formObj.parRef=+^TMP("web.DHCADVFormExport","oldParfToNewParfId",pid,oldFormparRId)
	.//更新关联字典id为新表的id
	.s oldDic=+formObj.formDic

	.d formObj.%Save()
	
	//导入表单属性
	s attrCount=""
	f  s attrCount=$o(^TMP("web.DHCADVFormExport","importAttr",pid,attrCount)) q:attrCount=""  d
	.s attrStr=^TMP("web.DHCADVFormExport","importAttr",pid,attrCount)
	.q:attrStr="attrstart"
	.s oldForm=$p(attrStr,"^",2)
	.s oldDic=$p(attrStr,"^",3)
	.//删除的元素或form
	.q:'$d(^TMP("web.DHCADVFormExport","oldFormToNew",pid,oldForm))
	.q:'$d(^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,oldDic))
	.s newForm=^TMP("web.DHCADVFormExport","oldFormToNew",pid,oldForm)
	.s newDic=^TMP("web.DHCADVFormExport","oldDicToNewDic",pid,oldDic)
	.s required=$p(attrStr,"^",4)
	.s printSeq=$p(attrStr,"^",5)
	.s print=$p(attrStr,"^",6)
	.s style=$p(attrStr,"^",8)
	.s attrObj=##class(User.DHCAdvFormAttr).%New()
	.
	.d attrObj.formDicSetObjectId(newDic)
	.d attrObj.formItmSetObjectId(newForm)
	.s attrObj.print=print
	.s attrObj.printSeq=printSeq
	.s attrObj.required=required
	.s attrObj.style=style
    .d attrObj.%Save()
	TCommit
	
	k ^TMP("web.DHCADVFormExport","oldDicToNewDic",pid)
	k ^TMP("web.DHCADVFormExport","oldParfToNewParfId",pid)
	k ^TMP("web.DHCADVFormExport","oldFormToNew",pid)
	k ^TMP("web.DHCADVFormExport","import",pid)
	k ^TMP("web.DHCADVFormExport","importDic",pid)
	k ^TMP("web.DHCADVFormExport","importAttr",pid)
	w 0
	q ""
err
 TROLLBACK
 w $ze
 q ""
}

}
