/// Description:	药品基本信息导入及展现类
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
Class web.DHCCKBUpLoadDrug Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取药品列表信息
/// Creator:		QuNianpeng
/// CreateDate:		2019-03-12
/// Input:			代码^描述
/// return:			药品信息串
/// other:			
/// w ##class(web.DHCCKBUpLoadDrug).QueryDrugList(20,1,"")
ClassMethod QueryDrugList(rows As %String, page As %String, params As %String) As %String
{
		
	n (rows,page,params)
	

	s end = page*rows
	s start=(page-1)*rows+1
	s queryCode=$p(params,"^",1)
	s queryCode=$zcvt(queryCode,"U")
	s queryDesc=$p(params,"^",2)
	s queryDesc=$zcvt(queryDesc,"U")
	
	s queryAttrCode="ProName^GenName^Factory"
	s queryAttrCode=$zcvt(queryAttrCode,"U")
	
	s pid = ##Class(web.DHCCKBCommonUtil).NewPid()	
	s h=0
	
	s typeCode="Drug"
	s type=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(typeCode),""),-1)
	q:type="" "[]"
	s dicId="" f  s dicId=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",type,dicId))  q:dicId=""  d
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(queryCode'="")&&($zcvt(dicCode,"U")'[queryCode)
	.q:(queryDesc'="")&&(($zcvt(dicDesc,"U")'[queryDesc)&(pinDesc'[queryDesc))
	.s value=""
	.s tmpData=""
	.s (generKey,proName,factory)=""
	.s linkDr="" f  s linkDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicId,linkDr))  q:linkDr=""  d
	..q:linkDr=""
	..s linkAttrCodeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkDr)),3)
	..q:linkAttrCodeDr=""
	..s linkAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkAttrCodeDr)),2)
	..s linkAttrCode=$zcvt(linkAttrCode,"U")
	..q:queryAttrCode'[linkAttrCode
	..s value=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkDr)),5)
	..
	..i linkAttrCode="GENNAME" s generKey=value
	..i linkAttrCode="PRONAME" s proName=value
	..i linkAttrCode="FACTORY" s factory=value
	.
	.s tmpData=dicId_"^"_dicCode_"^"_dicDesc_"^"_generKey_"^"_proName_"^"_factory
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBUpLoadDrug","QueryDrugList",pid,h)=tmpData	// 实体id,实体编码,实体名称,通用名,商品名,厂家
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) // 输出json结尾符
	q:h=0 "" 
	
	s count=0
	s listTitle="dicId^dicCode^dicDesc^generKey^proName^factory"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h)	// 输出json前缀串
	s index=""	f  s index=$o(^TMP("DHCCKB","web.DHCCKBUpLoadDrug","QueryDrugList",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBUpLoadDrug","QueryDrugList",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid)
	q ""
}

/// Description:	获取Pid
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
/// Input:			
/// return:			
/// other:			
/// w ##class(web.DHCCKBUpLoadDrug).QueryDrugList(20,1,"")
/// w ##class(web.DHCADVFormExport)importForm(1)
ClassMethod UploadPid()
{

	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	w pid
	q ""
}

/// Description:	临时存储数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
/// Input:			pid,行,数据
/// return:			
/// other:			
/// w ##class(web.DHCCKBUpLoadDrug)UploadTmpData(20,1,"")
ClassMethod UploadTmpData(pid, row, data) As %String
{
	n (pid,row,data)

	s ^TMP("DHCCKB","web.DHCCKBUpLoadDrug","UploadData",pid,row)=data

	q ""
}

/// Description:	导入数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			
/// w ##class(web.DHCCKBUpLoadDrug).UploadData(26)
ClassMethod UploadData(pid) As %String
{
	n (pid)

	// 通用名(含剂型) 是否存在,存在保存属性即可.   不存在则新建后,在保存
	
	s $zt="err"
	TStart

	s row=1
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBUpLoadDrug","UploadData",pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("DHCCKB","web.DHCCKBUpLoadDrug","UploadData",pid,row)
	.s num=$p(str,"[next]",1)
	.s generKey=$p(str,"[next]",2)
	.s generCode=$p(str,"[next]",4)
	.s generDesc=$p(str,"[next]",3)
	.s proName=$p(str,"[next]",5)
	.s factory=$p(str,"[next]",6)
	.
	.i $d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(generDesc)))  d			// 通用名是否存在,存在保存属性即可. 不存在则新建后,在保存
	..s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(generDesc),""))
	.e  d
	..s dicObj=##class(CT.CKB.PDSS.CommonDiction).%New()	
	..s dicObj.CDCode=generCode
	..s dicObj.CDDesc=generDesc
	..B
	..s cdType=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("Drug"),""))
	..q:cdType=""
	..s dicObj.CDType=##class(CT.CKB.PDSS.CommonDiction).%OpenId(cdType)
	..d dicObj.%Save()
	..s dicID=dicObj.%Id()
	..
	.	
	.s len=$l(str,"[next]")
	.f i=2:1:len d
	..s linkAttrObj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	..s value=$p(str,"[next]",i)
	..s attrCode=$case(i,2:"GenName",5:"ProName",6:"Factory",:"")
	..q:(i=3)||(i=4)
	..q:attrCode=""
	..s linkAttrObj.DLADicDr=##class(CT.CKB.PDSS.CommonDiction).%OpenId(dicID)
	..s attrId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(attrCode),""))	// attr属性代码,固定
	..q:attrId=""
	..s linkAttrObj.DLAAttrCode=##class(CT.CKB.PDSS.CommonDiction).%OpenId(attrId)
	..s linkAttrObj.DLAResult=value
	..d linkAttrObj.%Save()	
	
	TCommit	
	
	w 0
	d ..killTmpGlobal(pid)
	
	q ""
err
 TROLLBACK
 w $ze
 q ""
}

ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	
	k ^TMP("DHCCKB","web.DHCCKBUpLoadDrug","UploadData",pid)
	k ^TMP("DHCCKB","web.DHCCKBUpLoadDrug","QueryDrugList",pid)
}

}
