Import SQLUser

Class web.DHCCLCTemplate Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 插入模板分类
ClassMethod InsertCLCTemplateCat(code, desc, ctlocId, groupId, userId, module) As %String
{
	q:code="" "代码不能为空!"
	q:desc="" "描述不能为空!"
	q:ctlocId="" "科室不能为空!"
	q:module="" "单据不能为空!"
	s code=$$ALPHAUP^SSUTIL4(code)
	s objDHCCLCTemplateCat=##class(User.DHCCLCTemplateCat).%New()
	s objDHCCLCTemplateCat.TMPLCCode=code
	s objDHCCLCTemplateCat.TMPLCDesc=desc
	s objDHCCLCTemplateCat.TMPLCCtlocDr=ctlocId
	s objDHCCLCTemplateCat.TMPLCGroupDr=groupId
	s objDHCCLCTemplateCat.TMPLCUserDr=userId
	s objDHCCLCTemplateCat.TMPLCModule=module
	s saveStatus=objDHCCLCTemplateCat.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s DHCCLCTemplateCatId=objDHCCLCTemplateCat.%Id()
	d objDHCCLCTemplateCat.%Close()
	q 0
}

ClassMethod UpdateCLCTemplateCat(rowId, code, desc, ctlocId, groupId, userId, module) As %String
{
	q:rowId="" "rowId不能为空!"
	q:code="" "代码不能为空!"
	q:desc="" "描述不能为空!"
	q:ctlocId="" "科室不能为空!"
	q:module="" "单据不能为空!"
	s code=$$ALPHAUP^SSUTIL4(code)
	s objDHCCLCTemplateCat=##class(User.DHCCLCTemplateCat).%OpenId(rowId)
	s objDHCCLCTemplateCat.TMPLCCode=code
	s objDHCCLCTemplateCat.TMPLCDesc=desc
	s objDHCCLCTemplateCat.TMPLCCtlocDr=ctlocId
	s objDHCCLCTemplateCat.TMPLCGroupDr=groupId
	s objDHCCLCTemplateCat.TMPLCUserDr=userId
	s objDHCCLCTemplateCat.TMPLCModule=module
	s updateStatus=objDHCCLCTemplateCat.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s DHCCLCTemplateCatId=objDHCCLCTemplateCat.%Id()
	d objDHCCLCTemplateCat.%Close()
	q 0
}

ClassMethod DeleteCLCTemplateCat(rowId) As %String
{
	q:rowId="" "rowId不能为空!"
	;q:'##class(User.DHCCLCTemplateCat).%ExistsId(rowId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCCLCTemplateCat).%DeleteId(rowId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Query FindCLCTemplateCat() As %Query(ROWSPEC = "rowId:%String,code:%String,desc:%String,ctlocId:%String,ctlocDesc:%String,groupDr:%String,groupDesc:%String,userId:%String,userDesc:%String,module:%String,moduleCode:%String")
{
}

ClassMethod FindCLCTemplateCatExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rowId=0
 	s ctlocDesc="",groupDesc="",userDesc=""
	f  s rowId=$o(^DHCCLC("TemplCat",rowId)) q:rowId=""  d
	.s code=$li(^DHCCLC("TemplCat",rowId),1)
	.s desc=$li(^DHCCLC("TemplCat",rowId),2)
	.s ctlocId=$li(^DHCCLC("TemplCat",rowId),3)
	.i ctlocId'="" s ctlocDesc=$p($g(^CTLOC(ctlocId)),"^",2)
	.s groupDr=$li(^DHCCLC("TemplCat",rowId),4)
	.i groupDr'="" s groupDesc=$p($g(^SSU("SSGRP",groupDr)),"^",1)
	.s userId=$li(^DHCCLC("TemplCat",rowId),5)
	.i userId'="" s userDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	.s moduleCode=$li(^DHCCLC("TemplCat",rowId),6)
	.s module=""
	.s codeId="" f  s codeId=$o(^DHCCLCPCode("TempCat",codeId)) q:codeId=""  d
	..q:moduleCode'=$p(^DHCCLCPCode("TempCat",codeId),"^",1)
	..s module=$p(^DHCCLCPCode("TempCat",codeId),"^",2)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(rowId,code,desc,ctlocId,ctlocDesc,groupDr,groupDesc,userId,userDesc,module,moduleCode)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCLCTemplateCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCTemplateCatExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCLCTemplateCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCTemplateCatExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 插入模板
ClassMethod InsertCLCTemplate(code, desc, tmplcDr, additionalCode, data, anailable, seqMode, seqNo, note, userId) As %String
{
	q:code="" "代码不能为空!"
	q:desc="" "描述不能为空!"
	q:tmplcDr="" "tmplcDr不能为空!"
	q:'##class(User.DHCCLCTemplateCat).%ExistsId(tmplcDr) "记录不存在!"
	s code=$$ALPHAUP^SSUTIL4(code)
	s date=+$h,time=$p($h,",",2)
	s objDHCCLCTemplateCat=##class(User.DHCCLCTemplateCat).%OpenId(tmplcDr)
	s objDHCCLCTemplate=##class(User.DHCCLCTemplate).%New()
	s objDHCCLCTemplate.TMPLCode=code
	s objDHCCLCTemplate.TMPLDesc=desc
	s objDHCCLCTemplate.TMPLTMPLCDr=objDHCCLCTemplateCat
	s objDHCCLCTemplate.TMPLAdditionalCode=additionalCode
	s objDHCCLCTemplate.TMPLData=data
	s objDHCCLCTemplate.TMPLAvailable=anailable
	s objDHCCLCTemplate.TMPLSeqMode=seqMode
	s objDHCCLCTemplate.TMPLSeqNo=seqNo
	s objDHCCLCTemplate.TMPLNote=note
	s objDHCCLCTemplate.TMPLUpdateUserDr=userId
	s objDHCCLCTemplate.TMPLUpdateDate=date
	s objDHCCLCTemplate.TMPLUpdateTime=time
	s saveStatus=objDHCCLCTemplate.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s DHCCLCTemplateId=objDHCCLCTemplate.%Id()
	d objDHCCLCTemplate.%Close()
	d objDHCCLCTemplateCat.%Close()
	q 0
}

ClassMethod UpdateCLCTemplate(rowId, code, desc, tmplcDr, additionalCode, data, anailable, seqMode, seqNo, note, userId) As %String
{
	q:rowId="" "rowId不能为空!"
	q:code="" "代码不能为空!"
	q:desc="" "描述不能为空!"
	q:tmplcDr="" "tmplcDr不能为空!"
	q:'##class(User.DHCCLCTemplateCat).%ExistsId(tmplcDr) "记录不存在!"
	s code=$$ALPHAUP^SSUTIL4(code)
	s date=+$h,time=$p($h,",",2)
	s objDHCCLCTemplateCat=##class(User.DHCCLCTemplateCat).%OpenId(tmplcDr)
	s objDHCCLCTemplate=##class(User.DHCCLCTemplate).%OpenId(rowId)
	s objDHCCLCTemplate.TMPLCode=code
	s objDHCCLCTemplate.TMPLDesc=desc
	s objDHCCLCTemplate.TMPLTMPLCDr=objDHCCLCTemplateCat
	s objDHCCLCTemplate.TMPLAdditionalCode=additionalCode
	s objDHCCLCTemplate.TMPLData=data
	s objDHCCLCTemplate.TMPLAvailable=anailable
	s objDHCCLCTemplate.TMPLSeqMode=seqMode
	s objDHCCLCTemplate.TMPLSeqNo=seqNo
	s objDHCCLCTemplate.TMPLNote=note
	s objDHCCLCTemplate.TMPLUpdateUserDr=userId
	s objDHCCLCTemplate.TMPLUpdateDate=date
	s objDHCCLCTemplate.TMPLUpdateTime=time
	s updateStatus=objDHCCLCTemplate.%Save()
	s ^tmpck(2)=updateStatus
	q:(+updateStatus=0) "数据修改失败!"
	s DHCCLCTemplateId=objDHCCLCTemplate.%Id()
	d objDHCCLCTemplate.%Close()
	d objDHCCLCTemplateCat.%Close()
	q 0
}

/// code:%String,desc:%String,tmplcDr:%String,tmplcdesc:%String,additionalCode:%String,data:%String,anailable:%String,seqMode:%String,seqNo:%String,note:%String,userId:%String,username:%String,date:%String,time:%String,rowId:%String
Query FindCLCTemplate() As %Query(ROWSPEC = "code:%String,desc:%String,tmplcDr:%String,tmplcdesc:%String,additionalCode:%String,data:%String,anailable:%String,seqMode:%String,seqNo:%String,note:%String,userId:%String,username:%String,date:%String,time:%String,rowId:%String,isanailable:%String")
{
}

ClassMethod FindCLCTemplateExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rowId=0
 	s ctlocDesc="",groupDesc="",userDesc=""
	f  s rowId=$o(^DHCCLC("Template",rowId)) q:rowId=""  d
	.s code=$li(^DHCCLC("Template",rowId),1)
	.s desc=$li(^DHCCLC("Template",rowId),2)
	.s tmplcdesc=""
	.s tmplcDr=$li(^DHCCLC("Template",rowId),3)
	.i ((tmplcDr'="")&($d(^DHCCLC("TemplCat",tmplcDr)))) s tmplcdesc=$li(^DHCCLC("TemplCat",tmplcDr),2)
	.s additionalId=$li(^DHCCLC("Template",rowId),4)
	.s additionalCode=$p(^ORC("ANMET",additionalId),"^",2)
	.s data=$li(^DHCCLC("Template",rowId),5)
	.s isanailable=$li(^DHCCLC("Template",rowId),6)
	.q:isanailable'="1"
	.s anailable=""
	.s codeId="" f  s codeId=$o(^DHCCLCPCode("InActive",codeId)) q:codeId=""  d
	..q:isanailable'=$p(^DHCCLCPCode("InActive",codeId),"^",1)
	..s anailable=$p(^DHCCLCPCode("InActive",codeId),"^",2)
	.s seqMode=$li(^DHCCLC("Template",rowId),7)
	.s seqNo=$li(^DHCCLC("Template",rowId),8)
	.s note=$li(^DHCCLC("Template",rowId),9)
	.s username=""
	.s userId=$li(^DHCCLC("Template",rowId),10)
	.i userId'="" s username=$p($g(^SSU("SSUSR",userId)),"^",2)
	.s date=$zd($li(^DHCCLC("Template",rowId),11),3)
	.s time=$zt($li(^DHCCLC("Template",rowId),12))
	.d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow2
	s Data=$lb(code,desc,tmplcDr,tmplcdesc,additionalCode,data,anailable,seqMode,seqNo,note,userId,username,date,time,rowId,isanailable)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCLCTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCTemplateExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCLCTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCTemplateExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLCTemplate","GetTmplcDesc")
Query GetTmplcDesc() As %Query(ROWSPEC = "rowId:%String,desc:%String")
{
}

ClassMethod GetTmplcDescExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s rowId=0
 	
	f  s rowId=$o(^DHCCLC("TemplCat",rowId)) q:rowId=""  d
	.s code=$li(^DHCCLC("TemplCat",rowId),1)
	.s desc=$li(^DHCCLC("TemplCat",rowId),2)
	.d OutputRow3
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow3
	s Data=$lb(rowId,desc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetTmplcDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTmplcDescExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetTmplcDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTmplcDescExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query GetAnType(node) As %Query(ROWSPEC = "id:%String,anDesc:%String")
{
}

ClassMethod GetAnTypeExecute(ByRef qHandle As %Binary, node As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s ^tmpck(1)=node
	q:node="" ""
	s id=0
	f  s id=$o(^ORC(node,id)) q:id=""  d
	.s anDesc=$p(^ORC(node,id),"^",2)
	.d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow4
	s Data=$lb(id,anDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAnTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnTypeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAnTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##class(web.DHCCLCTemplate).GetTemplateByAnType("AN","17")
ClassMethod GetTemplateByAnType(moduleCode As %String, anTypeDr As %String) As %String
{
	q:moduleCode="" "模板分类不能为空!"
	q:anTypeDr="" "麻醉方法不能为空!"
	S ^tempck("template")=moduleCode_"#"_anTypeDr
	s retStr=""
	s tmpCatDr="" f  s tmpCatDr=$o(^DHCCLC("TemplCat",tmpCatDr)) q:tmpCatDr=""  d
	.q:moduleCode'=$li(^DHCCLC("TemplCat",tmpCatDr),6)
	.s moduleDesc=$p($G(^DHCCLCPCode("TempCat",tmpCatDr)),"^",2)
	.s tmplateDr="" f  s tmplateDr=$o(^DHCCLC("Template",tmplateDr)) q:tmplateDr=""  d
	..s anmodeId=$li(^DHCCLC("Template",tmplateDr),4)
	..q:("|"_anTypeDr_"|")'[("|"_anmodeId_"|")
	..q:$li(^DHCCLC("Template",tmplateDr),6)'="1"
	..s code=$li(^DHCCLC("Template",tmplateDr),1)
	..s desc=$li(^DHCCLC("Template",tmplateDr),2)
	..s seqNo=$li(^DHCCLC("Template",tmplateDr),8)
	..s note=$li(^DHCCLC("Template",tmplateDr),9)
	..s anTypeDesc=$p($g(^ORC("ANMET",anmodeId)),"^",2)
	..i retStr="" s retStr=code_$c(3)_desc_$c(3)_note_$c(3)_moduleDesc
	..e  s retStr=retStr_"^"_code_$c(3)_desc_$c(3)_note_$c(3)_moduleDesc
	q retStr
}

}
