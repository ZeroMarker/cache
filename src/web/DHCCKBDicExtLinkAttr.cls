Import SQLUSER

/// Creator：      sufan
/// CreatDate：    2020-12-01
/// Description:： 外部字典属性维护
Class web.DHCCKBDicExtLinkAttr Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	获取附加属性的源
/// Input：     实体ID,属性关联CODE
/// Return:		各个数据的类型
/// w ##class(web.DHCCKBDicExtLinkAttr).GetAddAttrSource("","DataSource","","dicGroupFlag")
ClassMethod GetAddAttrSource(queryDicID, AttrLinkCode, AttrId = "", queryDicCode = "")
{
	n (queryDicID,AttrLinkCode,AttrId,queryDicCode)	
	i queryDicID="" s queryDicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryDicCode),""))
	Q:queryDicID="" ""
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID))  d			  ///取属性关联
	.s queryDicID=$lg($g(^CT.CKB.PDSS.CommonDictionD(queryDicID)),5)
	
	Q:queryDicID="" ""
	s SourceList=""
	s LinkAttrId=""
	for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,LinkAttrId)) Q:(LinkAttrId="")  d
	.s AttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),2)
	.Q:AttrLinkCode'=AttrCode
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,LinkAttrId,AttrId))  Q:AttrId=""  d
	..
	..Q:AttrId=""
	..s SourceId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..i SourceList="" s SourceList=SourceId
	..e  s SourceList=SourceList_","_SourceId
	Q SourceList
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	取属性关联
/// Input：     实体ID,属性关联CODE
/// Return:		各个数据的类型
/// w ##class(web.DHCCKBDicExtLinkAttr).GetAddAttrCode("77954","LinkProp","49")
ClassMethod GetAddAttrCode(queryDicID, AttrLinkCode, AttrId = "")
{
	n (queryDicID,AttrLinkCode,AttrId)
	
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID))  d			  ///取属性关联
	.s queryDicID=$lg($g(^CT.CKB.PDSS.CommonDictionD(queryDicID)),5)
	Q:queryDicID="" ""
	
	s TypeId=##class(web.DHCCKBCommon).GetDataType()
	s LinkAttrCode=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",queryDicID,TypeId))  d
	.s dicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,TypeId,""))
	.Q:dicAttrId=""
	.s DataTypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dicAttrId)),4)
	.Q:DataTypeId=""
	.s LinkAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DataTypeId)),2)
	Q LinkAttrCode
}

/// Creator:    sufan
/// CreateDate: 2019-06-18
/// Descript:   附加属性维护
/// Input：     属性ID
/// w ##class(web.DHCCKBDicExtLinkAttr).QueryAddLinkAttr(30,1,"146460^KnowType^ExtraProp")
ClassMethod QueryAddLinkAttr(rows As %String, page As %String, params As %String)
{
	n (rows, page, params)
	s ^qnptmp=params
	s End = page*rows
	s Start=(page-1)*rows+1
	s EntyId=$p(params,"^",1)		  		  	//实体ID 
	s extraAttr=$p(params,"^",2)			  	//知识类别代码
	s AddAttrCode=$p(params,"^",3)			  	//属性代码
	Q:EntyId="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)				
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s Id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AddAttrCode),""))  // 附加属性id
  
  	///取公共附加属性
	s AttrID=""
	for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(Id,3),AttrID)) Q:AttrID=""  d
	.s DLADicDr=EntyId		// 关联表实体id  药品->附加属性->知识类型
	.s DLAAttrCodeDr=AttrID	// 关联表AttrCode
	.s DLAAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),2)
	.s DLAAttrCodeCDDesc=""
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),5)
	.s:DLAAttrCodeDr'="" DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),3) 	  //描述
	.s:(DLAAttrCodeCDDesc="")&&(LinkId'="") DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	.//取附加属性值  可能有多个
	.s DLAAttrDr="",DLAResult="",DLAAttrDesc=""
	.s ID=""
	.for  s ID=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,AttrID,ID))	  Q:ID=""   d	//关联表id
	..s ListData = $g(^CKB.PDSS.DicExtLinkAttrD(ID))
	..s AttrDr= $lg(ListData,4)	
	..s DLAResult= $lg(ListData,5)
	..s AttrDesc=""
	..i +AttrDr'="0" s AttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrDr)),3)
	..q:(+AttrDr'="0")&(AttrDesc="")
	..i +AttrDr="0" s AttrDesc=$s(DLAResult="Y":"是",DLAResult="N":"否",1:DLAResult)
	..i DLAAttrDr="" s DLAAttrDr=AttrDr
	..e  s DLAAttrDr=DLAAttrDr_","_AttrDr
	..i DLAAttrDesc="" s DLAAttrDesc=AttrDesc
	..e  s DLAAttrDesc=DLAAttrDesc_","_AttrDesc
	.s ListData=ID_"^"_DLADicDr_"^"_DLAAttrCodeDr_"^"_DLAAttrCodeCDDesc_"^"_DLAAttrDr_"^"_DLAAttrDesc_"^"_DLAResult_"^"_DLAAttrCode
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryAddLinkAttr",pid,h)=ListData
		

	///取特有附加属性 走附加属性的模板关联
	s LinkTempId=##class(web.DHCCKBCommon).GetTempLinkId()			//取模板关联Id  
	i $d(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,LinkTempId))   d
	.s dlaRowId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,LinkTempId,""))	
	.s Id=$lg(^CKB.PDSS.DicExtLinkAttrD(dlaRowId),4)
	.s AttrID=""
	.for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(Id,3),AttrID)) Q:AttrID=""  d
	..s DLADicDr=EntyId		// 关联表实体id  药品->附加属性->知识类型
	..s DLAAttrCodeDr=AttrID	// 关联表AttrCode
	..s DLAAttrCodeCDDesc=""
	..s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),5)
	..s:DLAAttrCodeDr'="" DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),3) 	  //描述
	..s:(DLAAttrCodeCDDesc="")&&(LinkId'="") DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..s:DLAAttrCodeDr'="" DLAAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),2)
	..s:(DLAAttrCode="")&&(LinkId'="") DLAAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	..//取附加属性值  可能有多个
	..s DLAAttrDr="",DLAResult="",DLAAttrDesc=""
	..s ID=""
	..for  s ID=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,AttrID,ID))	  Q:ID=""   d	//关联表id
	...s Data = $g(^CKB.PDSS.DicExtLinkAttrD(ID))	
	...s AttrDr= $lg(Data,4)
	...s DLAResult=$lg(Data,5)		
	...i +AttrDr'="0" s AttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrDr)),3)
	...i +AttrDr="0" s AttrDesc=$s(DLAResult="Y":"是",DLAResult="N":"否",1:DLAResult)
	...i DLAAttrDr="" s DLAAttrDr=AttrDr
	...e  s DLAAttrDr=DLAAttrDr_","_AttrDr
	...i DLAAttrDesc="" s DLAAttrDesc=AttrDesc
	...e  s DLAAttrDesc=DLAAttrDesc_","_AttrDesc
	..s ListData=ID_"^"_DLADicDr_"^"_DLAAttrCodeDr_"^"_DLAAttrCodeCDDesc_"^"_DLAAttrDr_"^"_DLAAttrDesc_"^"_DLAResult_"^"_DLAAttrCode
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryAddLinkAttr",pid,h)=ListData
	
	
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult^DLAAttr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryAddLinkAttr",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryAddLinkAttr",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	保存可编辑附加属性
/// Input：     实体ID,附加属性ID,属性值
/// Return:		0：成功，其他：失败
/// w ##class(web.DHCCKBDicExtLinkAttr).SaveUpdate("39^35^144^144","1")
ClassMethod SaveUpdate(params, flag)
{
	n (params,flag)
	s ^temptets("33")=$lb(params,flag)
	s $ZT="ErrMsg"
	TS
	s Err=0
	s Len=$l(params,"&&")
	for i=1:1:Len  Q:Err'=0  d
	.s TempStr=$p(params,"&&",i)
	.s AttrId=$p(TempStr,"^",1)			//属性ID
	.s AddAttrId=$p(TempStr,"^",2)		//附加属性ID
	.s DataId=$p(TempStr,"^",3)
	.s AddAttrCode=$p(TempStr,"^",5)
	.i flag=1  d
	..s:AddAttrCode'="DataSource" LinkAttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",AttrId,AddAttrId,""))
	..s:AddAttrCode="DataSource" LinkAttrId=$o(^CKB.PDSS.DicExtLinkAttrI("AttrAll",AttrId,AddAttrId,DataId,""))
	.e  d
	..s LinkAttrId=$o(^CKB.PDSS.DicExtLinkAttrI("AttrAll",AttrId,AddAttrId,DataId,""))
	.i LinkAttrId=""  d
	..s Err=..InsAttrLink(TempStr)
	.e   d
	..s Err=..UpdAttrLink(LinkAttrId,TempStr)
	.Q:Err'=0
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
ErrMsg
	tro
	q -1
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	保存可编辑附加属性
/// Input：     实体ID,附加属性ID,属性值
/// Return:		0：成功，其他：失败
/// w ##class(web.DHCCKBDicExtLinkAttr).InsAttrLink()
ClassMethod InsAttrLink(ListData)
{
	n (ListData)
	s AttrId=$p(ListData,"^",1)
	s AddAttrId=$p(ListData,"^",2)
	s DataId=$p(ListData,"^",3)
	s:+DataId=0 DataId=""
	s Text=$p(ListData,"^",4)
	s:+DataId'=0 Text=""
	&sql(insert into CKB_PDSS.DicExtLinkAttr (DLA_DicExt_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result) values(:AttrId,:AddAttrId,:DataId,:Text))
	Q SQLCODE
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	保存可编辑附加属性
/// Input：     实体ID,附加属性ID,属性值
/// Return:		0：成功，其他：失败
/// w ##class(web.DHCCKBDicExtLinkAttr).UpdAttrLink()
ClassMethod UpdAttrLink(LinkAttrId, ListData)
{
	n (LinkAttrId,ListData)
	s AttrId=$p(ListData,"^",1)
	s AddAttrId=$p(ListData,"^",2)
	s DataId=$p(ListData,"^",3)
	s:+DataId=0 DataId=""
	s Text=$p(ListData,"^",4)
	s:+DataId'=0 Text=""
	&sql(update CKB_PDSS.DicExtLinkAttr set DLA_DicExt_Dr=:AttrId,DLA_AttrCode=:AddAttrId,DLA_Attr_Dr=:DataId,DLA_Result=:Text where DLA_RowID=:LinkAttrId)
	Q SQLCODE
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	删除附加属性
/// Input:		属性ID,附加属性串
/// w ##class(web.DHCCKBDicExtLinkAttr).CancelAddAttr(10,12)
ClassMethod CancelAddAttr(EntyId, AddAttrList)
{
	n (EntyId,AddAttrList)
	s ^temptest("444")=$lb(EntyId,AddAttrList)
	s Err=0
	TS
	s Len=$l(AddAttrList,",")
	for i=1:1:Len  Q:Err'=0  d
	.s AddAttrId=$p(AddAttrList,"^",i)
	.&sql(delete from CKB_PDSS.DicExtLinkAttr where DLA_DicExt_Dr=:EntyId and DLA_AttrCode=:AddAttrId)
	.s Err=SQLCODE
	.Q:Err'=0
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryExtDicLInkAttrVal",pid)
	k ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid)
}

/// Creator:    sufan
/// CreateDate: 2020-12-01
/// Descript:	取外部项目字典数据
/// Input:		属性ID,附加属性串
/// w ##class(web.DHCCKBDicExtLinkAttr).QueryExtDic()
ClassMethod QueryExtDic(q = "", drugType = "")
{
	n (q,drugType)
	s count = 0
	w "["
	s dicID = ""    
	f  s dicID = $o(^CKB.PDSS.ExtDictionD(dicID))  q:dicID=""  d
	.q:dicID=0
	.s extData = $g(^CKB.PDSS.ExtDictionD(dicID))	
	.s EDCode = $lg(extData,2) 
	.q:EDCode'["Data"
	.s EDDesc = $lg(extData,3)
	.q:1=##class(web.DHCCKBCommon).CheckDrugType(drugType,EDDesc)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(EDDesc))
	.q:(q'="")&($zcvt(EDCode,"U")'[q)&(EDDesc'[q)&(pinDicDesc'[$zcvt(q,"U"))
	.s EDType = $lg(extData,4) 
	.s EDHospID = $lg(extData,5)
	.s EDRowID = dicID
	.s ListData=dicID_"^"_EDCode_"^"_EDDesc
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^code^text",ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^code^text",ListData)	
	w "]"
	Q ""
}

/// Description:	获取实体的属性列表
/// Creator:		sufan 
/// CreateDate:		2019-07-10	
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBDicExtLinkAttr).QueryExtDicLInkAttrVal("30","1","146460^146472")
ClassMethod QueryExtDicLInkAttrVal(rows, page, params) As %String
{
	n (rows, page, params)
 	s ^temptest("params")=$lb(rows, page, params)
	s end = page*rows
	s start=(page-1)*rows+1
	s dictionId = $p(params,"^",1)		  	//字典id
	s dicId = $p(params,"^",2)									//药品id
	Q:dictionId="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
				
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	d ..killTmpGlobal(pid) //k掉临时globalD
	s linkProId = ##class(web.DHCCKBCommon).GetLinkProp()
	s dicLinkId = ##class(web.DHCCKBDicExtLinkAttr).GetDicLinkAttr(dictionId,linkProId)  
	 
	s isAddValPropId = ##class(web.DHCCKBCommon).GetIsAddValueProp()		// 是否需要维护属性值
	s dataTypeId = ##class(web.DHCCKBCommon).GetDataType()												// 数据展现类型
 
	Q:dicLinkId="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	
    s h=0,linkRowId="" 
	for  s linkRowId = $o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",dictionId,linkProId,linkRowId)) Q:linkRowId=""  d
	.s attrParref = $lg(^CKB.PDSS.DicExtLinkAttrD(linkRowId),4)												// 属性集合
	.d ##class(web.DHCCKBDiction).SortAttrByOrd(attrParref,pid,0)			//sufan 2020-04-08 排序
	.s index = ""
	.f  s index = $o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrParref,index))  q:index=""  d
	..s attrId = +$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrParref,index))
	..s tmpAttrId = attrId
	..s attrLinkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrId)),5)
	..i attrLinkId'="" s tmpAttrId = attrLinkId	// 没有属性值，属性值link其他属性 
	..// 判断是否需要维护属性值
	..s tmpLinkId = "",addValueId = "",addValueFlag = ""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrId,isAddValPropId)) s tmpLinkId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrId,isAddValPropId,""))
	..i tmpLinkId'="" s addValueId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkId)),4)
	..s:addValueId'="" addValueFlag = $lg($g(^CT.CKB.PDSS.CommonDictionD(addValueId)),3)
	..q:$g(addValueFlag)="N"
	..//数据展现形式
	..s tmpLinkId = ""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrId,dataTypeId))  s tmpLinkId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrId,dataTypeId,""))
	..s dicDatatypeId = ""
	..i tmpLinkId'="" s dicDatatypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkId)),4)
	..s dataType=""
	..i dicDatatypeId'="" s dataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicDatatypeId)),2)	// 具体属性的数据类型
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrId)),2)
	..s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrId)),3)
	..//取维护的属性值
	..s attrValue=..QueryAttrValue(dicId,attrId)
	..///取值结束
	..s h=h+1
	..s data=attrId_"^"_attrCode_"^"_attrDesc_"^"_dataType_"^"_attrValue
	..s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryExtDicLInkAttrVal",pid,h)=data

	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S listTitle="attrID^attrCode^attrDesc^dataType^AttrValue"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryExtDicLInkAttrVal",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryExtDicLInkAttrVal",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBDicExtLinkAttr).QueryAttrValue(107471,4009)
ClassMethod QueryAttrValue(EntyId, AttrCodeId)
{
	n (EntyId,AttrCodeId)
	s Ret=""
	s Ret=..GetAttrValue(EntyId,AttrCodeId)						//取关联属性
	s LinkId=""
	i Ret="" s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)		
	i LinkId'="" s Ret=..GetAttrValue(EntyId,LinkId)			//取本身
	Q Ret
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBDicExtLinkAttr).GetAttrValue(107471,4009)
ClassMethod GetAttrValue(EntyId, AttrCodeId)
{
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s h=0
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId))  d		//属性关联
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	..s AttrId=""
	..for  s AttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,subId,AttrId))  Q:AttrId=""  d
	...s ListData = $g(^CKB.PDSS.DicExtLinkAttrD(AttrId))
	...s dicAttrCode= $lg(ListData,3) 
	...s dicAttrId= $lg(ListData,4)
	...s dicRes= $lg(ListData,5)
	...s GroupFlag=$lg(ListData,6)
	...s Desc=""
	...i dicAttrId'="" d
	....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....s DicLinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:DicLinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),3)
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(GroupFlag))  d
	....s GroupArr(GroupFlag)=GroupArr(GroupFlag)_ListData
	...e  d
	....s GroupArr(GroupFlag)=ListData
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId))  Q:AttrId=""  d
	..s ListData = $g(^CKB.PDSS.DicExtLinkAttrD(AttrId))
	..s LinkAttrId= $lg(ListData,4)	
	..s Res= $lg(ListData,5)	
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),3)
	...s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),5)
	...s:LinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	..s GroupFlag=$lg(ListData,6)		//成组标识
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_","_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData
	s QuitList=""
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""   s QuitList=data 
	.e  s QuitList=QuitList_","_data 
	k GroupArr
	Q QuitList
}

/// Descript:取字典关联的属性
/// Creator:sufan
/// CreateDate:2020-12-04
/// Input:字典Id
/// Output:关联的属性Id
/// w ##class(web.DHCCKBDicExtLinkAttr).GetDicLinkAttr()
ClassMethod GetDicLinkAttr(dictionId, linkProId)
{
	n (dictionId,linkProId)
	s linkAttrId=""
	s linkAttrId = $o(^CKB.PDSS.DicExtLinkAttrI("AttrAll",dictionId,linkProId,""))
	Q linkAttrId
}

/// Creator：      sufan
/// CreatDate：    2020-12-04
/// Description:： 根据类型存储数据
/// Table：        DHC_CKBDicExtLinkAttr,DHC_CKBExtDiction
/// Others：       w ##class(web.DHCCKBDicExtLinkAttr).saveDicAttrByType("^107471^41^^1111^^","text","11879^8^1^290^2","113.140.81.66")
ClassMethod saveDicAttrByType(ListData, Type, LoginInfo, ClientIPAddress)
{
	n (ListData,Type,LoginInfo,ClientIPAddress)
	s LgUserID=$p(LoginInfo,"^",1)
	s LgHospID=$p(LoginInfo,"^",5)
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s ListData=##class(web.DHCCKBDicExtLinkAttr).dealListData(pid,ListData,Type)
	TS
	s Err=0
	i Type="datagrid"  d
	.s Err=..saveGridData(ListData,LgUserID,LgHospID,ClientIPAddress)
	e  d
	.s Err=..saveTextData(ListData,LgUserID,LgHospID,ClientIPAddress)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        DHC_CKBDicExtLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).saveGridData("0^679^26947^^笔错类")
ClassMethod saveGridData(ListData, LgUserID = "", LgHospID = "", ClientIPAddress = "")
{
	n (ListData,LgUserID,LgHospID,ClientIPAddress)
	s Err=0
	TS
	s Len=$l(ListData,"&&")
	s ^kmltest=ListData
	for i=1:1:Len  q:Err<0  d
	.s TempList=$p(ListData,"&&",i)
	.q:..IsExistAttrValueId(TempList) //kml 2020-01-20 属性值是否存在
	.s AttrId=$p(TempList,"^",1)
	.s EntyId=$p(TempList,"^",2)
	.s AttrCodeId=$p(TempList,"^",3)
	.Q:Err<0
	.i +AttrId="0" d
	..s Err=..InsDicAttr(TempList)				//保存
	..s DicAttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicExtLinkAttr", DicAttrId, "add", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log")
	.e  d
	..s Err=..UpdateAttr(AttrId,TempList)		//更新
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicExtLinkAttr", AttrId, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log")
	i Err'=0 tro 
	q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存实例别名关联
ClassMethod InsDicAttr(ListData)
{
	n (ListData)
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrCode=$p(ListData,"^",3)		//属性Code
	s AttrId=$p(ListData,"^",4) 		//属性ID
	s Result=$p(ListData,"^",5) 		//备注
	s GroupFlag=$p(ListData,"^",6) 		//同组标识
	&sql(insert into CKB_PDSS.DicExtLinkAttr (DLA_DicExt_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result,DLA_GroupFlag)
	     values (:EntyId,:AttrCode,:AttrId,:Result,:GroupFlag))
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
ClassMethod UpdateAttr(AttrId, ListData)
{
	n (AttrId,ListData)
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrCodeId=$p(ListData,"^",3)		//属性ID
	s LinkAttrId=$p(ListData,"^",4) 	//元素code
	s ResText=$p(ListData,"^",5) 		//元素code
	&sql(update CKB_PDSS.DicExtLinkAttr set DLA_DicExt_Dr=:EntyId,DLA_AttrCode=:AttrCodeId,DLA_Attr_Dr=:LinkAttrId,DLA_Result=:ResText where DLA_RowID=:AttrId)
	Q SQLCODE
}

/// Creator：      kemaolin
/// CreatDate：    2020-01-20
/// Description:： 判断datagrid属性值Id是否已经存在
/// Return:        0 不存在，1 存在
/// Table：        CT_CKB_PDSS.DicLinkAttr
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).IsExistAttrValueId("0^50007^22367^3924^^364244^")
ClassMethod IsExistAttrValueId(TempList)
{
	n (TempList)
	
	s EntyId=$p(TempList,"^",2)  //实体ID
	s EntyAttrId=$p(TempList,"^",3)  //属性ID
	s AttrValueId=$p(TempList,"^",4) //属性值id
	s Result=$p(TempList,"^",5)
	Q:(Result="")&&(AttrValueId="")&&($d(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,EntyAttrId))) 1
	s GroupNum=$p(TempList,"^",6) 	//组号
	s tempId=""
	i (AttrValueId'="")&&(GroupNum="") d
	.f  s tempId =$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,EntyAttrId,tempId)) q:(tempId="")||(tempId=AttrValueId)  d
	q (AttrValueId'="")&&(tempId=AttrValueId)
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).saveTextData("0^27^57^^111")
ClassMethod saveTextData(ListData, LgUserID, LgHospID, ClientIPAddress)
{
	n (ListData,LgUserID,LgHospID,ClientIPAddress)
	TS
	s Err=0
	s Len=$l(ListData,"&&")
	for i=1:1:Len  Q:Err'=0  d
	.s tempList=$p(ListData,"&&",i)
	.s EntyId=$p(tempList,"^",2)
	.s AttrCodeId=$p(tempList,"^",3)
	.s DicAttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	.i +DicAttrId="0"  d
	..s Err=..InsText(tempList)
	..s DicAttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicExtLinkAttr", DicAttrId, "add", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log")
	.e  d
	..s Err=..UpdText(DicAttrId,ListData)
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicExtLinkAttr", DicAttrId, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log")
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsText("130^104^3333")
ClassMethod InsText(ListData)
{
	n (ListData)
	s EntyId=$p(ListData,"^",2)				//实例ID
	s AttrCode=$p(ListData,"^",3)			//属性ID
	s AttrId=$p(ListData,"^",4)				//属性ID
	s TextContent=$p(ListData,"^",5)		//值域
	&sql(insert into CKB_PDSS.DicExtLinkAttr (DLA_DicExt_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result)
		values(:EntyId,:AttrCode,:AttrId,:TextContent))
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsText(10,1,"77^91")
ClassMethod UpdText(DicAttrId, ListData)
{
	n (DicAttrId,ListData)

	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrCode=$p(ListData,"^",3)			//属性ID
	s AttrId=$p(ListData,"^",4)	
	s TextContent=$p(ListData,"^",5)	//值域
	&sql(update CKB_PDSS.DicExtLinkAttr set DLA_Attr_Dr=:AttrId,DLA_Result=:TextContent where DLA_RowID=:DicAttrId)
	Q SQLCODE
}

/// Creator:    sufan
/// CreateDate: 2019-12-02
/// Descript:	保存之前重新组织数据
/// Input：     
/// Return:	
/// w ##class(web.DHCCKBDicLinkAttr).dealListData(1,"0^196^42^^&&^196^42^4023^GenerNamePropId^0^","datagrid")	
ClassMethod dealListData(pid, ListData, Type)
{
	n (pid,ListData,Type)
	s Len=$l(ListData,"&&")
	s QuitList=""
	s EntyId=$p($p(ListData,"&&",1),"^",2)    //实体ID	 具体药品，阿莫西林等
	s AttrId=$p($p(ListData,"&&",1),"^",3)    //属性ID   如成分，别名等
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	
	if Type="datagrid"  d   //grid数据处理
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),5)
	.if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,LinkPropId)) d
	..for i=1:1:Len  d
	...Q:i<=1
	...s TempStr=$p(ListData,"&&",i)
	...s Idstr=$p(TempStr,"^",1)	//id
	...i +Idstr'=0  d
	....s Id=$p(Idstr,"&",i-1)
	...e   s Id=+Idstr				 
	...s AttrValueId=$p(TempStr,"^",4)		 //值
	...s AttrCode=$p(TempStr,"^",5)			 //值title
	...s ResText=""							 //备注
	...i $e(AttrCode,$l(AttrCode)-1,$l(AttrCode))="Id" s AttrCode=$e(AttrCode,1,$l(AttrCode)-2)
	...s DataType=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(AttrCode,"","DataTypeProp")
	...s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",AttrCode)
	...s:source'="" DataType="combobox"
	...i DataType'="combobox"  d
	....s ResText=AttrValueId				//文本
	....s AttrValueId=""
	...s AttrDicId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AttrCode),""))
	...s GroupNum=$p(TempStr,"^",6)
	...s GroupFlag=$p(TempStr,"^",7)
	...s params=Id_"^"_EntyId_"^"_AttrDicId_"^"_AttrValueId_"^"_ResText_"^"_(pid+GroupNum)_"^"_GroupFlag
	...i QuitList="" s QuitList=Id_"^"_EntyId_"^"_AttrId_"^^^^"_"&&"_params
	...e  s QuitList=QuitList_"&&"_params
	.e  if (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId))) d
	..for i=1:1:Len  d
	...Q:i<=1
	...s TempStr=$p(ListData,"&&",i)
	...s Idstr=$p(TempStr,"^",1)	//id
	...i +Idstr'=0  d
	....s Id=$p(Idstr,"&",i-1)
	...e   s Id=+Idstr				 
	...s AttrValueId=$p(TempStr,"^",4)		 //值
	...s AttrCode=$p(TempStr,"^",5)			 //值title
	...s ResText=""							 //备注
	...i $e(AttrCode,$l(AttrCode)-1,$l(AttrCode))="Id" s AttrCode=$e(AttrCode,1,$l(AttrCode)-2)
	...s DataType=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(AttrCode,"","DataTypeProp")
	...s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",AttrCode)
	...s:source'="" DataType="combobox"
	...i DataType'="combobox"  d
	....s ResText=AttrValueId				//文本
	....s AttrValueId=""
	...s AttrDicId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AttrCode),""))
	...s GroupNum=$p(TempStr,"^",6)
	...s GroupFlag=$p(TempStr,"^",7)
	...s params=Id_"^"_EntyId_"^"_AttrDicId_"^"_AttrValueId_"^"_ResText_"^"_(pid+GroupNum)_"^"_GroupFlag
	...i QuitList="" s QuitList=Id_"^"_EntyId_"^"_AttrId_"^^^^"_"&&"_params
	...e  s QuitList=QuitList_"&&"_params
	.e  d							  //组织数据串 实体属性直接关联
	..for i=1:1:Len  d
	...Q:i<=1
	...s TempStr=$p(ListData,"&&",i)
	...s Idstr=$p(TempStr,"^",1)	//id
	...i +Idstr'=0  d
	....s Id=$p(Idstr,"&",i-1)
	...e   s Id=+Idstr	
	...s AttrValueId=$p(TempStr,"^",4)
	...s AttrCode=$p(TempStr,"^",5)			 //值title
	...s ResText=""							 //备注
	...i $e(AttrCode,$l(AttrCode)-1,$l(AttrCode))="Id" s AttrCode=$e(AttrCode,1,$l(AttrCode)-2)
	...s DataType=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(AttrCode,"","DataTypeProp")
	...s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",AttrCode)
	...s:source'="" DataType="combobox"
	...i (DataType'="combobox") d
	....s ResText=AttrValueId				//文本
	....s AttrValueId=""
	...s params=Id_"^"_EntyId_"^"_AttrId_"^"_AttrValueId_"^"_ResText
	...i QuitList="" s QuitList=params
	...e  s QuitList=QuitList_"&&"_params
	e  d			//其他数据处理
	.for i=1:1:Len  d
	..
	..s TempStr=$p(ListData,"&&",i)
	..s Id=+$p(TempStr,"^",1)
	..s AttrValueId=$p(TempStr,"^",4)
	..s ResText=$p(TempStr,"^",5)								 //备注
	..s params=Id_"^"_EntyId_"^"_AttrId_"^"_AttrValueId_"^"_ResText
	..i QuitList="" s QuitList=params
	..e  s QuitList=QuitList_"&&"_params						
	
	Q QuitList
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 查询datagrid数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicExtLinkAttr).QueryEntyAttr("30","1","107471^74532","datagrid","")
ClassMethod QueryEntyAttr(rows = 10, page = 1, params As %String, Type = "", dicCode = "")
{
	n (rows,page,params,Type,dicCode)
	s ^temptest("147")=$lb(rows,page,params,Type,dicCode)
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)  
	s EntyId=$p(params,"^",1)
	s Attrcode=$p(params,"^",2)
	s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Attrcode)),5)
	s count=0,num=0
	s h=0
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	if Type="datagrid"  d
	.if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId)) d
	..s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId,""))
	..s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	..s subId=""
	..for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	...s dlaRowId=""
	...for  s dlaRowId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,subId,dlaRowId))  Q:dlaRowId=""  d
	....s ListData = $g(^CKB.PDSS.DicExtLinkAttrD(dlaRowId))	
	....s dicAttrCode= $lg(ListData,3)		//知识类别 
	....s dicAttrId= $lg(ListData,4)		//属性ID
	....s dicRes= $lg(ListData,5)		//备注
	....s dicGroupFlag= $lg(ListData,6)	//成组标识
	....i dicAttrId'="" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....e  s ListData="^"_dicRes
	....i $d(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag))  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)_"^"_ListData
	.....s $p(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)=$p(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)_"&"_dlaRowId
	....e  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=dlaRowId_"^"_ListData
	....s h=h+1
	.e  if (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId))) d
	..s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId,""))
	..s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	..s subId=""
	..for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	...s dlaRowId=""
	...for  s dlaRowId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,subId,dlaRowId))  Q:dlaRowId=""  d
	....s Data = $g(^CKB.PDSS.DicExtLinkAttrD(dlaRowId))	
	....s dicAttrCode= $lg(Data,3)	//知识类别 
	....s dicAttrId= $lg(Data,4)	//属性ID
	....s dicRes=$lg(Data,5) //备注
	....s dicGroupFlag= $lg(Data,6) //成组标识
	....i dicAttrId'="" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....e  s ListData="^"_dicRes
	....i $d(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag))  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)_"^"_ListData
	.....s $p(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)=$p(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)_"&"_dlaRowId
	....e  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=dlaRowId_"^"_ListData
	....s h=h+1
	.e  d			//未关联属性的
	..s dlaRowId=""
	..for  s dlaRowId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,Attrcode,dlaRowId))  Q:dlaRowId=""  d
	...s TmpData = $g(^CKB.PDSS.DicExtLinkAttrD(dlaRowId))		
	...s dicAttrCode= $lg(TmpData,3)   //知识类别 
	...s dicAttrId= $lg(TmpData,4)		//属性ID
	...s dicRes= $lg(TmpData,5)		//备注
	...s dicGroupFlag=$lg(TmpData,6)	//成组标识
	...i +dicAttrId'="0" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	...e  s ListData=dicAttrId_"^"_dicRes
	...s num=num+1
	...s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,num)=dlaRowId_"^"_ListData
	...s h=h+1
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",EntyId,Attrcode,AttrId))  Q:AttrId=""  d
	..s TmpData = $g(^CKB.PDSS.DicExtLinkAttrD(AttrId))		
	..s dicAttrCode= $lg(TmpData,3)
	..s dicAttrId= $lg(TmpData,4)
	..s dicRes= $lg(TmpData,5) 
	..s dicGroupFlag= $lg(TmpData,6)
	..i dicAttrId'="" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	..e  s ListData=dicAttrId_"^"_dicRes
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,h)=AttrId_"^"_ListData
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	w "["
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId))  d
	.s title="Id^"_##class(web.DHCCKBDicLinkAttr).getTileList(Attrcode)_"^dicGroupFlag"
	e  i (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId)))  d
	.s title="Id^"_##class(web.DHCCKBDicLinkAttr).getTileList(LinkId)_"^dicGroupFlag"
	e  d
	.s title="Id^"_##class(web.DHCCKBDicLinkAttr).getTileList(Attrcode)_"^dicGroupFlag"

	
	s index=""
	for  s index=$o(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCCKB","web.DHCCKBDicExtLinkAttr","QueryEntyAttr",pid,index))_"^"_index
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	w "]"
	d ..killTmpGlobal(pid)  
	q ""
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 按类型删除数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicExtLinkAttr).DelData(10,1,"77^91")
ClassMethod DelData(params)
{
	n (params)
	s Len=$l(params,"&")
	s Err=0
	for i=1:1:Len  q:Err'=0  d
	.s Id=$p(params,"&",i)
	.&sql(delete from CKB_PDSS.DicExtLinkAttr where DLA_RowID=:Id)
	.s Err=SQLCODE
	.Q:Err'=0
	Q Err
}

}
