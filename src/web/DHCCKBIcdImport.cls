Import sqluser

Class web.DHCCKBIcdImport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: sunhuiyong
/// CreatDate: 2020-01-10
/// Description: 导入ICD10疾病关联对照
/// Table: d ##class(web.DHCCKBIcdImport).SaveIcdRowData("shy_疾病测试0001^shy_ICD0001^shy_ICD疾病00001关联",2)
ClassMethod SaveIcdRowData(rowData, hospID)
{
	n (rowData,hospID)
	s ^temptest("1222")=$lb(rowData,hospID)
	TS
	;k ^TMPERR("DHCCKB","ICD")
	s successNum=0,errNum=0
	s err=0,msg=""
	s rowdata=rowData
	s Desc=$p(rowdata,"^",1)
	s ICDCode=$p(rowdata,"^",2)
	s ICDDesc=$p(rowdata,"^",3)
	//一、判断所取数据第一列是否存在疾病字典  id:115   改进用代码取--2020-01-15 测试问题
	i ..QueryDicByID(115,0,Desc)="N"  d
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	.i Desc="" s err=1,msg="疾病字典代码/描述不存在，请检查数据或者列头"
	.i err=1 s errNum=errNum+1
	.q:err=1
	.s obj.CDCode=Desc
	.s obj.CDDesc=Desc
	.d obj.CDParrefDrSetObjectId("115")
	.s sc=obj.%Save()
	.s drugid=obj.%Id()
	.d obj.%Close()
	e  d
	.s drugid=..QueryDicByID(115,0,Desc)
	//二、判断所取数据第二三列是否存在ICD字典  id:26938  改进用代码取--2020-01-15 测试问题
	i ..QueryDicByID(26938,0,ICDCode)="N"  d
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	.i (ICDCode="")&(ICDDesc="") s err=1,msg="ICD代码/描述不存在，请检查数据或者列头"
	.i err=1 s errNum=errNum+1
	.s obj.CDCode=ICDCode
	.s obj.CDDesc=ICDDesc
	.d obj.CDParrefDrSetObjectId("26938")
	.s sc=obj.%Save()
	.s ICDid=obj.%Id()
	.d obj.%Close()
	e  d
	.s ICDid=..QueryDicByID(26938,0,ICDCode)
	//三、插入关联关系表
	;i ..QueryLinkOther(Desc,ICDCode)="Y"  d
	;.s err=2,msg="关联关系已存在，请确认存入数据是否重复"
	;.i err=2  s errNum=errNum+1
	;e   d 
	s obj=##class(CKB.PDSS.ComContrast).%New()
	s obj.CCLibCode=Desc                                        //HIS诊断
	s obj.CCLibDesc=Desc                                        //HIS诊断
	s obj.CCHisCode=ICDCode
	s obj.CCHisDesc=ICDDesc                      
	s obj.CCDicType=##class(web.DHCCKBCommon).GetDiseaseData()  //获取疾病字典ID
	//s obj.CCHospId=hospID
	s sc=obj.%Save()
	d obj.%Close()
	s successNum = successNum+1
	//三、插入属性关联表
	;i ..QueryLink(ICDid,drugid)="Y"  d
	;.s err=2,msg="关联关系已存在，请确认存入数据是否重复"
	;.i err=2  s errNum=errNum+1
	;e   d 
	;.s obj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	;.d obj.DLADicDrSetObjectId(drugid)
	;.d obj.DLAAttrCodeSetObjectId(##class(web.DHCCKBCommon).GetIcdAttrCodeId())
	;.d obj.DLAAttrDrSetObjectId(ICDid)
	;.s sc=obj.%Save()
	;.d obj.%Close()
	;.s successNum = successNum+1
	//s outObj={}
	
	s JsonObj=##class(web.DHCCKBJsonObject).%New()  //sufan 2020-04-02 修改json对象格式
	i (successNum'=0) 	d
	.d JsonObj.Put("code","success")
	.d JsonObj.Put("successNum",successNum)
	.d JsonObj.Put("errNum",errNum)
	.d JsonObj.Put("msg","")
	.//d outObj.%Set("code","success").%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	.TC
	e  d
	.d JsonObj.Put("code","err")
	.d JsonObj.Put("successNum",successNum)
	.d JsonObj.Put("errNum",errNum)
	.d JsonObj.Put("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	.//d outObj.%Set("code","err").%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	.TRO
	;w "导入数据总条数："_successNum_"错误条数："_errNum_" "_msg,!
	;w outObj.%ToJSON()
	//q outObj.%ToJSON()
	w JsonObj.JsonNoOp()
	q ""
}

/// Creator: sunhuiyong
/// CreatDate: 2020-01-10
/// Description: 导入ICD10疾病关联对照
/// Table: d ##class(web.DHCCKBIcdImport).SaveIcd("shy_疾病测试01^shy_ICD01^shy_ICD疾病01关联")
ClassMethod SaveIcd(impAllData, rowcount)
{
	n (impAllData, rowcount)
	TS
	s:rowcount>1 rowcount=rowcount-1
	s successNum=0,errNum=0,AllNum=0
	f i=1:1:rowcount  d
	.s err=0,msg=""
	.s rowdata=$p(impAllData,"@@",i)
	.s Desc=$p(rowdata,"^",1)
	.s ICDCode=$p(rowdata,"^",2)
	.s ICDDesc=$p(rowdata,"^",3)
	.//一、判断所取数据第一列是否存在疾病字典  id:115   改进用代码取--2020-01-15 测试问题
	.i ..QueryDicByID(115,0,Desc)="N"  d
	..s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	..i Desc="" s err=1,msg="疾病字典代码/描述不存在，请检查数据或者列头"
	..i err=1 d SetTroInfo
	..q:err=1
	..s obj.CDCode=Desc
	..s obj.CDDesc=Desc
	..d obj.CDParrefDrSetObjectId("115")
	..s sc=obj.%Save()
	..s drugid=obj.%Id()
	..d obj.%Close()
	.e  d
	..s drugid=..QueryDicByID(115,0,Desc)
	.//二、判断所取数据第二三列是否存在ICD字典  id:26938  改进用代码取--2020-01-15 测试问题
	.i ..QueryDicByID(26938,0,ICDCode)="N"  d
	..s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	..i (ICDCode="")&(ICDDesc="") s err=1,msg="ICD代码/描述不存在，请检查数据或者列头"
	..i err=1 d SetTroInfo
	..s obj.CDCode=ICDCode
	..s obj.CDDesc=ICDDesc
	..d obj.CDParrefDrSetObjectId("26938")
	..b ;shy
	..s sc=obj.%Save()
	..s ICDid=obj.%Id()
	..d obj.%Close()
	.b ;shy2
	.e  d
	..s ICDid=..QueryDicByID(26938,0,ICDCode)
	.//三、插入属性关联表
	.i ..QueryLink(ICDid,drugid)="Y"  d
	..s err=2,msg="关联关系已存在，请确认存入数据是否重复"
	..i err=2  d
	...;s errNum=errNum+1
	...;s ^TMPERR("DHCCKB","ICD",errNum)=AllNum_"^"_msg
	.e   d 
	..s obj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	..d obj.DLADicDrSetObjectId(drugid)
	..d obj.DLAAttrCodeSetObjectId(##class(web.DHCCKBCommon).GetIcdAttrCodeId())
	..d obj.DLAAttrDrSetObjectId(ICDid)
	..s sc=obj.%Save()
	..d obj.%Close()
	..;w ##class(web.DHCCKBCommon).GetIcdAttrCodeId()
	..;i $$$ISOK(sc'=1)  d SetTroInfo
	..s successNum = successNum+1
	.s AllNum =AllNum+1
	;s:successNum'=0 successNum=successNum-1
	//s outObj={}
	s JsonObj=##class(web.DHCCKBJsonObject).%New()  //sufan 2020-04-02 修改json对象格式
	i (successNum'=0) 	d
	.d JsonObj.Put("code","success")
	.d JsonObj.Put("total",AllNum)
	.d JsonObj.Put("successNum",successNum)
	.d JsonObj.Put("errNum",errNum)
	.d JsonObj.Put("msg","")
	.;d outObj.%Set("code","success").%Set("total",AllNum).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	e  d
	.d JsonObj.Put("code","err")
	.d JsonObj.Put("total",AllNum)
	.d JsonObj.Put("successNum",successNum)
	.d JsonObj.Put("errNum",errNum)
	.d JsonObj.Put("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	.;d outObj.%Set("code","err").%Set("total",AllNum).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	i (AllNum = successNum)&(err = 0)  d
	.;TC
	e  d
	.tro
	;w "导入数据总条数："_successNum,!
	tro
	;q outObj.%ToJSON()
	w JsonObj.JsonNoOp()
	q ""

SetTroInfo
	;tro
	;s errNum=errNum+1
	s ^TMPERR("DHCCKB","ICD",errNum)=AllNum_"^"_msg
	Quit
}

/// Description:	检测字典表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-01-10	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）,描述
/// return:			存在：ID    不存在：N
/// other:			w ##class(web.DHCCKBIcdImport).QueryDicByID(26938,0,"")
ClassMethod QueryDicByID(id As %String = "", parrefFlag As %String = "", parDesc = "") As %String
{
	n (id,parrefFlag,parDesc)
	s h = 0
	q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+id=0 ""
	q:parDesc="" "N"
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""||h>0  d
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(parDesc=dicDesc)||(parDesc=dicCode) h = dicID 
	q:h=0 "N"	
    q:h>0 h
}

/// Creator:Shy
/// 返回导入错误信息
/// global: ^TMPERR("DHCCKB","ICD",ID)
/// debug: d ##class(web.DHCCKBIcdImport).GetErrList()
ClassMethod GetErrList(rows As %String = 20, page As %String = 1) As %String
{
	n (rows,page)	

	s end = page*rows
	s start=(page-1)*rows+1
	s pid=	$d(^TMPERR("DHCCKB","ICD"))
	b ;err
	;q:pid=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	;q:pid=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) // 输出json结尾符
	;b ;err2
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()	// 输出json前缀串
	s count=0
	s title="AllNum^msg"
	set index=""	
	f  s index=$order(^TMPERR("DHCCKB","ICD",index)) q:index=""  d
	.s listData=$get(^TMPERR("DHCCKB","ICD",index))
	.q:listData=""
	.s AllNum=$p(listData,"^",1)
	.s msg=$p(listData,"^",2)
	.s tmpData=AllNum_"^"_msg
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	k ^TMPERR("DHCCKB","ICD")
	q ""
}

/// Description:	检测关联表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-01-15
/// Input:			idcID    drugID
/// return:			存在:Y    不存在：N
/// other:			w ##class(web.DHCCKBIcdImport).QueryLink("1","6")
ClassMethod QueryLink(attrdr As %String = "", dicdr As %String = "") As %String
{
	n (attrdr,dicdr)
	s result=""
	q:attrdr="" 
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",attrdr)) "N"
	;b ;err
	s dlaid=""   f  s dlaid=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",attrdr,dlaid))   q:dlaid=""  d
	.s Linkdicdr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaid)),2)
	.s:dicdr=Linkdicdr result = "Y" 
	.;b ;shy
    q:result="Y" result
    q "N"
}

/// Creator:		Sunhuiyong 
/// CreateDate:		2020-01-15
/// Input:			LibCode    HisCode
/// return:			存在:Y    不存在：N
/// other:			w ##class(web.DHCCKBIcdImport).QueryLinkOther("shy_疾病01","shy_ICD01")
ClassMethod QueryLinkOther(LibCode As %String = "", HisCode As %String = "") As %String
{
	n (LibCode,HisCode)
	q:HisCode=""
	q:LibCode="" 
	q:'$d(^CKB.PDSS.ComContrastI("LibCode",LibCode,HisCode)) "N"
    q "Y"
}

/// Description:	存入错误信息
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-01-15
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBIcdImport).SaveErr()
ClassMethod SaveErr(errorRow As %String = "") As %String
{
	n (errorRow)
	s ^TMPERR("DHCCKB","ICD",errorRow)="第"_errorRow_"条^"_"表数据有空值或标题不对应"
}

/// Creator: sunhuiyong
/// CreatDate: 2020-03-02
/// Description: 导入药品信息（火神山）
/// Table: d ##class(web.DHCCKBIcdImport).SavedrugRowData("666^知识库疾病测试666^his疾病代码666^his666",2)
ClassMethod SavedrugRowData(rowData, hospID)
{
	n (rowData,hospID)
	TS
	;k ^TMPERR("DHCCKB","ICD")
	s successNum=0,errNum=0
	s err=0,msg=""
	s rowdata=rowData
	s Code=$p(rowdata,"^",1)
	s Desc=$p(rowdata,"^",2)
	s HISCode=$p(rowdata,"^",3)
	s HISDesc=$p(rowdata,"^",4)
	//一、保存HIS对照数据 

	s obj=##class(CKB.PDSS.ExtDiction).%New()
	i (HISCode="")&(HISDesc="") s err=1,msg="HIS代码/HIS描述不存在，请检查数据或者列头是否存在空值"
	i err=1 s errNum=errNum+1
	s obj.EDCode=HISCode
	s obj.EDDesc=HISDesc
	s obj.EDType="DrugData"        //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
	s obj.EDHospital=hospID
	s sc=obj.%Save()
	d obj.%Close()
	//三、插入关联关系表
	;i ..QueryLinkOther(Desc,ICDCode)="Y"  d
	;.s err=2,msg="关联关系已存在，请确认存入数据是否重复"
	;.i err=2  s errNum=errNum+1
	;e   d 
	s obj=##class(CKB.PDSS.ComContrast).%New()
	s obj.CCLibCode=Code                                        //知识库
	s obj.CCLibDesc=Desc                                        //知识库
	s obj.CCHisCode=HISCode                                     //HISd代码
	s obj.CCHisDesc=HISDesc                                     //HIS描述
	s obj.CCDicType=##class(web.DHCCKBCommon).GetDrugData()  //获取药品字典ID  
	s obj.CCHospId=hospID
	s sc=obj.%Save()
	d obj.%Close()
	s successNum = successNum+1
	//三、插入属性关联表
	;i ..QueryLink(ICDid,drugid)="Y"  d
	;.s err=2,msg="关联关系已存在，请确认存入数据是否重复"
	;.i err=2  s errNum=errNum+1
	;e   d 
	;.s obj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	;.d obj.DLADicDrSetObjectId(drugid)
	;.d obj.DLAAttrCodeSetObjectId(##class(web.DHCCKBCommon).GetIcdAttrCodeId())
	;.d obj.DLAAttrDrSetObjectId(ICDid)
	;.s sc=obj.%Save()
	;.d obj.%Close()
	;.s successNum = successNum+1
	//s outObj={}
	s JsonObj=##class(web.DHCCKBJsonObject).%New()  //sufan 2020-04-02 修改json对象格式
	i (successNum'=0) 	d
	.d JsonObj.Put("code","success")
	.d JsonObj.Put("successNum",successNum)
	.d JsonObj.Put("errNum",errNum)
	.d JsonObj.Put("msg","")
	.;d outObj.%Set("code","success").%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	.TC
	e  d
	.d JsonObj.Put("code","err")
	.d JsonObj.Put("successNum",successNum)
	.d JsonObj.Put("errNum",errNum)
	.d JsonObj.Put("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	.;d outObj.%Set("code","err").%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	.TRO
	;w "导入数据总条数："_successNum_"错误条数："_errNum_" "_msg,!
	;w outObj.%ToJSON()
	;q outObj.%ToJSON()
	w JsonObj.JsonNoOp()
	q ""
}

/// Descript:导出对照数据
/// Creator:sufan
/// CreateDate:2020-07-20
/// w ##Class(websys.Query).ToExcel("对照数据","web.DHCCKBIcdImport","QueryContraData","94^DrugData")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryContraData","97^DrugData") 
Query QueryContraData(params) As websys.Query(ROWSPEC = "libCode:%String:知识库数据代码,libDesc:%String:知识库数据描述,hisCode:%String:项目数据代码,hisDesc:%String:项目数据描述,note:%String:备注,hospDesc:%String:医院,type:%String:字典")
{
}

ClassMethod QueryContraDataExecute(ByRef qHandle As %Binary, params) As %Status
{
	n (qHandle,params)
	s ^temptest("123")=$lb(params)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	//libCode,libDesc,hisCode,hisDesc,note,hospDesc,type
	s hosp = $p(params,"^",1)
	s typeCode = $p(params,"^",2)
	s extId = "0"
	for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,typeCode,extId))  Q:extId=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	.s hisCode = $lg(extData,2)				//hiscode
	.;s hisCode = $tr(hisCode,",","")
	.s hisDesc = $lg(extData,3)				//hisdesc
	.s hisDesc = $p(hisDesc,"||",1)
	.s type = $lg(extData,4) 				//字典
	.s extHosp = $lg(extData,5)				//医院
	.s hospDesc = $p(^CT("HOSP",extHosp),"^",2)
	.s note = ""
	.s conDicId = ""
	.for  s conDicId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),conDicId))  Q:conDicId=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(conDicId))
	..s libCode = $lg(conData,2) 
	..s libDesc = $lg(conData,3)
	..s hisCode = "S"_hisCode
	..set ^CacheTemp(repid,ind)=$lb(libCode,libDesc,hisCode,hisDesc,note,hospDesc,type)
	..set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:补充icd代码并导出
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("诊断匹配数据","web.DHCCKBIcdImport","QueryIcdCodeImp","C:\Users\Administrator\Desktop\matchdiag.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryIcdCodeImp","C:\Users\Administrator\Desktop\matchdiag.txt") 
Query QueryIcdCodeImp(filepath) As websys.Query(ROWSPEC = "libCode:%String:知识库数据代码,libDesc:%String:知识库数据描述,icdCode:%String:项目数据代码,icdDesc:%String:项目数据描述,hospCode:%String:医院,note:%String:备注")
{
}

ClassMethod QueryIcdCodeImpExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k icdArr
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s icdList = $tr(onerow,$c(9),del)
	.s count=count+1
	.Q:count=1
	.s icdArr(count) = icdList
	c filepath 

	s index = "",h = 0
	for  s index = $o(icdArr(index))  Q:index=""  d
	.s dataList = icdArr(index)
	.s libCode = $p(dataList,"^",1)
	.s libDesc = $p(dataList,"^",2)
	.s icdDesc = $p(dataList,"^",3)
	.s hospCode = $p(dataList,"^",4)
	.s note = ""
	.s icdId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),""),-1)
	.s icdCode = ""
	.s:icdId'="" icdCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(icdId)),2)
	.s contraId = ""
	.s h = h+1
	.set ^CacheTemp(repid,ind)=$lb(libCode,libDesc,icdCode,icdDesc,hospCode,note)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:处理未和最末级对照的诊断数据
/// w ##class(web.DHCCKBIcdImport).ReaMatchIcdData()
ClassMethod ReaMatchIcdData()
{
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s conType = "115"
	s conId = ""
	for  s conId = $o(^CKB.PDSS.ComContrastI("Type",conType,conId))  Q:conId=""  d
	.s conData = $g(^CKB.PDSS.ComContrastD(conId))
	.s libCode = $lg(conData,2)
	.s libDesc = $lg(conData,3) 
	.s hisCode = $lg(conData,4) 
	.s hisDesc = $lg(conData,5)
	.s dicType = $lg(conData,6) 
	.s hosp = $lg(conData,7) 
	.s list = libCode_"^"_libDesc_"^"_dicType_"^"_hosp
	.d ..LastNode(hisCode,pid,list,conId,hisDesc)
	Q ""
}

/// Descript:判断是否为末级节点
/// w ##class(web.DHCCKBIcdImport).LastNode(205983,1)
ClassMethod LastNode(hisCode, pid, list, conId, hisDesc)
{
	n (hisCode,pid,list,conId,hisDesc)
	s ret = 0
	s dicId = ""
	for dicId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(hisCode),dicId))  Q:dicId=""  d
	.s parrId = ..GetRoot(dicId)
	.Q:parrId'=26938
	.Q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",dicId))
	.s ^TMP("DHCCKB","web.DHCCKBIcdImport","LastNode",pid,conId) = hisCode_"^"_hisDesc_"^"_list
	.s ret = ..GetLastNode(dicId,pid,list)
	Q ret
}

/// w ##class(web.DHCCKBIcdImport).GetLastNode(205983,1)
ClassMethod GetLastNode(parrId, pid, list)
{
	n (parrId,pid,list)
	
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parrId,dicId))  Q:dicId=""  d
	.i '$d(^CT.CKB.PDSS.CommonDictionI("Parref",dicId))  d
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	..s ^TMP("DHCCKB","web.DHCCKBIcdImport","GetLastNode",pid,dicId) = dicCode_"^"_dicDesc_"^"_list
	.e  d
	..d ..GetLastNode(dicId,pid,list)
	Q ""
}

/// Descript:取字典的根节点
/// w ##class(web.DHCCKBIcdImport).GetRoot(205983)
ClassMethod GetRoot(dicId)
{
	n (dicId)
	w dicId,!
	s rootId = ""
	i '$d(^CT.CKB.PDSS.CommonDictionI("Parref",dicId)) d
	.s rootId = dicId
	Q:rootId'="" rootId
	s parref =  $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),4)
	s:parref="" rootId = dicId
	Q:parref="" rootId
	s rootId = ..GetRoot(parref)
	Q rootId
}

/// Descript:补充icd代码并导出
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("诊断修复数据","web.DHCCKBIcdImport","QueryIcdReaMatch",263696699)
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryIcdCodeImp","C:\Users\Administrator\Desktop\matchdiag.txt") 
Query QueryIcdReaMatch(pid) As websys.Query(ROWSPEC = "index:%String:数据id,libCode:%String:知识库数据代码,libDesc:%String:知识库数据描述,icdCode:%String:项目数据代码,icdDesc:%String:项目数据描述,hospCode:%String:医院,note:%String:备注")
{
}

ClassMethod QueryIcdReaMatchExecute(ByRef qHandle As %Binary, pid) As %Status
{
	n (qHandle,pid)

	Set repid=$I(^CacheTemp)	
	Set ind=1


	s index = "",h = 0
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","GetLastNode",pid,index))  Q:index=""  d
	.s dataList = ^TMP("DHCCKB","web.DHCCKBIcdImport","GetLastNode",pid,index)
	.s libCode = $p(dataList,"^",3)
	.s libDesc = $p(dataList,"^",4)
	.s icdCode = $p(dataList,"^",1)
	.s icdDesc = $p(dataList,"^",2)
	.s hospCode = $p(dataList,"^",6)
	.s h = h+1
	.set ^CacheTemp(repid,ind)=$lb(index,libCode,libDesc,icdCode,icdDesc,hospCode)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:补充icd代码并导出
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("需删除对照数据","web.DHCCKBIcdImport","QueryConData",263703084)
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryIcdCodeImp","C:\Users\Administrator\Desktop\matchdiag.txt") 
Query QueryConData(pid) As websys.Query(ROWSPEC = "index:%String:数据id,libCode:%String:知识库数据代码,libDesc:%String:知识库数据描述,icdCode:%String:项目数据代码,icdDesc:%String:项目数据描述,hospCode:%String:医院,note:%String:备注")
{
}

ClassMethod QueryConDataExecute(ByRef qHandle As %Binary, pid) As %Status
{
	n (qHandle,pid)

	Set repid=$I(^CacheTemp)	
	Set ind=1


	s index = "",h = 0
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","LastNode",pid,index))  Q:index=""  d
	.s dataList = ^TMP("DHCCKB","web.DHCCKBIcdImport","LastNode",pid,index)
	.s libCode = $p(dataList,"^",3)
	.s libDesc = $p(dataList,"^",4)
	.s icdCode = $p(dataList,"^",1)
	.s icdDesc = $p(dataList,"^",2)
	.s hospCode = $p(dataList,"^",6)
	.s h = h+1
	.set ^CacheTemp(repid,ind)=$lb(index,libCode,libDesc,icdCode,icdDesc,hospCode)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:基本药物匹配
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("基药关联数据","web.DHCCKBIcdImport","QueryEssDrugMatch","D:\jbywlb.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryEssDrugMatch","D:\jbywlb.txt") 
Query QueryEssDrugMatch(filepath) As websys.Query(ROWSPEC = "libCode:%String:知识库药品代码,libDesc:%String:知识库药品描述,libAppNo:%String:知识库批准文号,hisCode:%String:基药代码,hisDesc:%String:基药描述,hisAppNo:%String:基药批准文号,hisEssFlag:%String:基药标识,dictionId:%String:药品类型,dicId:%String:数据Id")
{
}

ClassMethod QueryEssDrugMatchExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryEssDrugMatch")
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s essList = $tr(onerow,$c(9),del)
	.s drugCode = $p(essList,"^",1)
	.s drugDesc = $p(essList,"^",5)
	.s appNo = $p(essList,"^",16)
	.s appNo = ##class(web.DHCCKBIcdImport).GetApproNo(appNo)
	.Q:appNo=""
	.s essFlag = $p(essList,"^",17)
	.s count=count+1
	.Q:count=1
	.s ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryEssDrugMatch",appNo) = drugCode_"^"_drugDesc_"^"_appNo_"^"_essFlag
	c filepath 
	
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s chnDrugDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s approNumId = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s dicTionList = drugDataId_"^"_chnDrugDataId
	s h = 0
	for ids=1:1:2  d
	.s dictionId = $p(dicTionList,"^",ids)
	.b   //11
	.s dicId = ""
	.for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,dicId))  Q:dicId=""  d
	..s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	..s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	..s libAppNo = ##class(web.DHCCKBEditProp).QueryAttrValue(dicId,approNumId)
	..;b:libAppNo["H42021983"   //12
	..s libAppNoex = ##class(web.DHCCKBIcdImport).GetApproNo(libAppNo)
	..Q:libAppNoex=""
	..Q:'$d(^TMP("DHCCKB","web.DHCCKBIcdImport","QueryEssDrugMatch",libAppNoex))
	..s hisList = ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryEssDrugMatch",libAppNoex)
	..s hisCode = $p(hisList,"^",1)
	..s hisDesc = $p(hisList,"^",2)
	..s hisAppNo = $p(hisList,"^",3)
	..s hisEssFlag = $p(hisList,"^",4)
	..s h = h+1
	..s ^TMP("DHCCKB","web.DHCCKBIcdImport","appData",h) = libCode_"^"_libDesc_"^"_libAppNo_"^"_hisCode_"^"_hisDesc_"^"_hisAppNo_"^"_hisEssFlag_"^"_dictionId_"^"_dicId
	b   //222
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","appData",index))   Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBIcdImport","appData",index)
	.set ^CacheTemp(repid,ind)=$listfromstring(data,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:根据ASCII去掉批准文号的汉字
/// w ##class(web.DHCCKBIcdImport).GetApproNo("国药准字-H41023915")
ClassMethod GetApproNo(ApproNo)
{
	Q:ApproNo="" ""
	s appNo = ""
	s len = $l(ApproNo)
	for i=1:1:len  d
	.s tmpval = $e(ApproNo,i)
	.Q:$a(tmpval)=45
	.Q:(($a(tmpval)>=19968) && ($a(tmpval)<=40869))
	.i appNo = "" s appNo = tmpval
	.e  s appNo = appNo_tmpval
	Q appNo
}

/// Descript:更新药品基本药物标识
/// Creator:sufan
/// CreateDate:2022-05-10
/// w ##class(web.DHCCKBIcdImport).updEssDrugFlag("D:\temp\基药关联数据.txt")
ClassMethod updEssDrugFlag(filepath)
{
	S count = 0
	k esDrugArr
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s essList = $tr(onerow,$c(9),del)
	.s datatype = $p(essList,"^",8)
	.s dataId = $p(essList,"^",9)
	.s count=count+1
	.Q:count=1
	.s esDrugArr(dataId) = dataId_"^"_datatype
	c filepath 
	b   //22
	s index = "1"
	for  s index = $o(esDrugArr(index))  Q:index=""  d
	.s essdata = esDrugArr(index)
	.s dicId = $p(essdata,"^",1)
	.s dictype = $p(essdata,"^",2)
	.s attrCode = 111255
	.s:dictype="81790" attrCode = 255494
	.s attrDicId = 26852
	.s res = ""
	.;b  //11
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicId,attrCode))  d
	..s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicId,attrCode,""))
	..&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:attrDicId,DLA_Result=:res where DLA_RowID=:attrId)
	.e  d
	..&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:dicId,:attrCode,:attrDicId))
	Q ""
}

/// Descript:带量采购药品匹配
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("基药关联数据","web.DHCCKBIcdImport","QueryPurchDrugMatch","D:\jbywlb.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryPurchDrugMatch","D:\jbywlb.txt") 
Query QueryPurchDrugMatch(filepath) As websys.Query(ROWSPEC = "libCode:%String:知识库药品代码,libDesc:%String:知识库药品描述,libAppNo:%String:知识库批准文号,hisCode:%String:基药代码,hisDesc:%String:基药描述,hisAppNo:%String:基药批准文号,hisEssFlag:%String:基药标识,dictionId:%String:药品类型,dicId:%String:数据Id")
{
}

ClassMethod QueryPurchDrugMatchExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryPurchDrugMatch")
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s essList = $tr(onerow,$c(9),del)
	.s drugCode = $p(essList,"^",1)
	.s drugDesc = $p(essList,"^",5)
	.s appNo = $p(essList,"^",16)
	.s appNo = ##class(web.DHCCKBIcdImport).GetApproNo(appNo)
	.Q:appNo=""
	.s essFlag = $p(essList,"^",17)
	.s count=count+1
	.Q:count=1
	.s ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryPurchDrugMatch",appNo) = drugCode_"^"_drugDesc_"^"_appNo_"^"_essFlag
	c filepath 
	
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s chnDrugDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s approNumId = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s dicTionList = drugDataId_"^"_chnDrugDataId
	s h = 0
	for ids=1:1:2  d
	.s dictionId = $p(dicTionList,"^",ids)
	.b   //11
	.s dicId = ""
	.for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,dicId))  Q:dicId=""  d
	..s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	..s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	..s libAppNo = ##class(web.DHCCKBEditProp).QueryAttrValue(dicId,approNumId)
	..;b:libAppNo["H42021983"   //12
	..s libAppNoex = ##class(web.DHCCKBIcdImport).GetApproNo(libAppNo)
	..Q:libAppNoex=""
	..Q:'$d(^TMP("DHCCKB","web.DHCCKBIcdImport","QueryEssDrugMatch",libAppNoex))
	..s hisList = ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryEssDrugMatch",libAppNoex)
	..s hisCode = $p(hisList,"^",1)
	..s hisDesc = $p(hisList,"^",2)
	..s hisAppNo = $p(hisList,"^",3)
	..s hisEssFlag = $p(hisList,"^",4)
	..s h = h+1
	..s ^TMP("DHCCKB","web.DHCCKBIcdImport","appData",h) = libCode_"^"_libDesc_"^"_libAppNo_"^"_hisCode_"^"_hisDesc_"^"_hisAppNo_"^"_hisEssFlag_"^"_dictionId_"^"_dicId
	b   //222
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","appData",index))   Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBIcdImport","appData",index)
	.set ^CacheTemp(repid,ind)=$listfromstring(data,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:导出未匹配的诊断
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("未对照适应症","web.DHCCKBIcdImport","QueryicdMatch",115)
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryicdMatch",115) 
Query QueryicdMatch(parref) As websys.Query(ROWSPEC = "icdCode:%String:适应症代码,icdDesc:%String:适应症描述")
{
}

ClassMethod QueryicdMatchExecute(ByRef qHandle As %Binary, parref) As %Status
{
	n (qHandle,parref)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s count = 0
	s h=0
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicId))   Q:dicId=""  d
	.q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.s h=h+1
	.s icdCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s icdDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.Q:$D(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(icdDesc)))
	.s count=count+1
	.set ^CacheTemp(repid,ind)=$lb(icdCode,icdDesc)
	.set ind=ind+1	
	b
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:导入泰安项目提供的基药数据
/// w ##class(web.DHCCKBIcdImport).updEssDrugFlagByPro("D:\temp\在用基本药物导出（去除非基药）.txt")
ClassMethod updEssDrugFlagByPro(filepath, hospCode = "TASZXYYGXYYQ")
{
	n (filepath,hospCode)
	S count = 0
	k proDatArr
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s essList = $tr(onerow,$c(9),del)
	.s drugCode = $p(essList,"^",1)
	.s drugDesc = $p(essList,"^",2)
	.s essFlag = $p(essList,"^",26)
	.Q:essFlag'="Y"
	.i drugCode["'" d
	..s drugCode = $e(drugCode,2,$l(drugCode))
	.s count=count+1
	.Q:count=1
	.s proDatArr(drugCode) = drugCode_"^"_drugDesc_"^"_essFlag
	c filepath 
	Q:hospCode="" 0
	s hospId = $o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospCode),""))
	Q:hospId=""
	///取对照数据
	k hisArr
	s dicCode = ""
	for  s dicCode = $o(proDatArr(dicCode))  Q:dicCode=""  d
	.s dataList = proDatArr(dicCode)
	.s dataCode = $p(dataList,"^",1)
	.s dataDesc = $p(dataList,"^",2)
	.s dataFlag = $p(dataList,"^",3)
	.s retData = ..IsProjectUse(dataCode,hospCode)
	.s useFlag = $p(retData,"^",1)
	.i useFlag'=1 s ^temptest("DHCCKB","web.DHCCKBIcdImport","updEssDrugFlagByPro",dataCode) = dataList
	.Q:useFlag'=1
	.s libCode = $p(retData,"^",2)
	.s hisArr(libCode) = libCode
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s chneDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s index = "1"
	for  s index = $o(hisArr(index))  Q:index=""  d
	.s essdata = hisArr(index)
	.s dicCode = $p(essdata,"^",1)
	.s drugId = ##class(web.DHCCKBCommon).GetDicIdByCode(dicCode,drugDataId)
	.s chnDrugId = ##class(web.DHCCKBCommon).GetDicIdByCode(dicCode,chneDataId)
	.s dicId = "",attrCode=""
	.i +drugId'="0"  d
	..s dicId = drugId
	..s attrCode = 111255
	.e   d
	..s dicId = chnDrugId
	..s attrCode = 255494
	.Q:+dicId="0"
	.s attrDicId = 26852
	.s res = ""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicId,attrCode))  d
	..s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicId,attrCode,""))
	..&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:attrDicId,DLA_Result=:res where DLA_RowID=:attrId)
	.e  d
	..&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:dicId,:attrCode,:attrDicId))
	Q ""
}

ClassMethod IsProjectUse(hisCode, inhospCode = "TASZXYYGXYYQ")
{
	n (hisCode, inhospCode)
	s existFlag = 0
	s libCode = ""
	s conId = ""
	for  s conId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),conId))  Q:(conId="")||(existFlag=1)  d
	.s listData =$g(^CKB.PDSS.ComContrastD(conId))
	.s hospId =  $lg(listData,7)
	.Q:+hospId="0"
	.s hospCode = $p(^CT("HOSP",hospId),"^",1)
	.Q:(inhospCode'="")&&(hospCode'=inhospCode)
	.s existFlag = 1
	.s libCode =  $lg(listData,2)
	Q existFlag_"^"_libCode
}

/// Descript:毒麻药品
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("毒麻药","web.DHCCKBIcdImport","QueryPurchDrugMatch","D:\jbywlb.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryPurchDrugMatch","D:\jbywlb.txt") 
Query QueryPoisDrugMatch(filepath) As websys.Query(ROWSPEC = "libCode:%String:知识库药品代码,libDesc:%String:知识库药品描述,libAppNo:%String:知识库批准文号,hisCode:%String:基药代码,hisDesc:%String:基药描述,hisAppNo:%String:基药批准文号,hisEssFlag:%String:基药标识,dictionId:%String:药品类型,dicId:%String:数据Id")
{
}

ClassMethod QueryPoisDrugMatchExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryPoisDrugMatch")
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s essList = $tr(onerow,$c(9),del)
	.s drugCode = $p(essList,"^",1)
	.s drugDesc = $p(essList,"^",5)
	.s drughxm = $p(essList,"^",6)
	.s appNo = $p(essList,"^",16)
	.s appNo = ##class(web.DHCCKBIcdImport).GetApproNo(appNo)
	.s mzyp = $p(essList,"^",17)
	.s dyljsyp = $p(essList,"^",18)
	.s deljsyp = $p(essList,"^",19)
	.s dxyp = $p(essList,"^",20)
	.s fsxyp = $p(essList,"^",21)
	.s count=count+1
	.Q:count=1
	.s ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryPoisDrugMatch",drugCode) = drugCode_"^"_drugDesc_"^"_drughxm_"^"_appNo_"^"_mzyp_"^"_dyljsyp_"^"_deljsyp_"^"_dxyp_"^"_fsxyp
	c filepath 
	
	s generNamePropId = ##class(web.DHCCKBCommon).GetGenerNameProp()
	s generNameDicId = ##class(web.DHCCKBCommon).GetGeneralData()
	s h = 0
	s dicCode = ""
	for  s dicCode = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","QueryPoisDrugMatch",dicCode))  Q:dicCode=""  d
	.s dataList = ^TMP("DHCCKB","web.DHCCKBIcdImport","QueryPoisDrugMatch",dicCode)
	.s hxcf = $p(dataList,"^",3)
	.s hxcfId = ##class(web.DHCCKBCommon).GetDicIdByDesc(hxcf,generNameDicId)
	.i hxcfId = 0 s ^TMP("DHCCKB","web.DHCCKBIcdImport","nohxcf",dicCode) = dataList
	.Q:hxcfId=0
	..s ^TMP("DHCCKB","web.DHCCKBIcdImport","appData",h) = libCode_"^"_libDesc_"^"_libAppNo_"^"_hisCode_"^"_hisDesc_"^"_hisAppNo_"^"_hisEssFlag_"^"_dictionId_"^"_dicId
	b   //222
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","appData",index))   Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBIcdImport","appData",index)
	.set ^CacheTemp(repid,ind)=$listfromstring(data,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:匹配导入用药指导内容
/// CreateDate:2021-04-10
/// Creator:sufan 
/// w ##class(web.DHCCKBIcdImport).readTetFile()
ClassMethod readTetFile(filepath, tmpArr)
{
	n (filepath,tmpArr)
	S count = 0
	q:filepath="" $$$OK
	s del = "!!"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s count=count+1
	.Q:count=1
	.s guidLsit = $replace(onerow,$c(9),del)
	.s tmpArr(count) = guidLsit
	c filepath 
	q ""
}

/// Descript:导入逸曜适应症关系
/// Creator:sufan
/// CreateDate:2022-05-26
/// w ##class(web.DHCCKBIcdImport).ImportDiagData("D:\temp\诊断标准数据带ICD编码-0726.txt") 
ClassMethod ImportDiagData(filepath)
{
	n (filepath)
	k tmpArr
	d ..readTetFile(filepath,.tmpArr)
	s count = 0
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s index = ""
	for  s index = $o(tmpArr(index))  Q:index=""  d
	.s deaseDesc = $p(tmpArr(index),"^",1)
	.s otherNameOne = $p(tmpArr(index),"^",2)
	.s otherNameTwo = $p(tmpArr(index),"^",3)
	.s otherNameThr = $p(tmpArr(index),"^",4)
	.s otherNameFor = $p(tmpArr(index),"^",5)
	.s otherNameFiv = $p(tmpArr(index),"^",6)
	.s icdList = $p(tmpArr(index),"^",7)
	.d ..handIcdData(pid,deaseDesc,otherNameOne,otherNameTwo,otherNameThr,otherNameFor,otherNameFiv,icdList,.count)
	
	s h = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","handIcdData",pid,index))  Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBIcdImport","handIcdData",pid,index)
	.s deaseNewDesc = $p(data,"^",1)
	.s otherNewNameOne = $p(data,"^",2)
	.s otherNewNameTwo = $p(data,"^",3)
	.s otherNewNameThr = $p(data,"^",4)
	.s otherNewNameFor = $p(data,"^",5)
	.s otherNewNameFiv = $p(data,"^",6)
	.s icdNewCode = $p(data,"^",7)
	.s icdNewDesc = $p(data,"^",8)
	.s icdNewList = $p(data,"^",9)
	.s dicDescId = ##class(web.DHCCKBCommon).GetDicIdByCode(deaseNewDesc,"115")
	.s dicOneId = ##class(web.DHCCKBCommon).GetDicIdByCode(otherNewNameOne,"115")
	.s dicTwoId = ##class(web.DHCCKBCommon).GetDicIdByCode(otherNewNameTwo,"115")
	.s dicThrId = ##class(web.DHCCKBCommon).GetDicIdByCode(otherNewNameThr,"115")
	.s dicForId = ##class(web.DHCCKBCommon).GetDicIdByCode(otherNewNameFor,"115")
	.s dicFivId = ##class(web.DHCCKBCommon).GetDicIdByCode(otherNewNameFiv,"115")
	.s descindex = deaseNewDesc_icdNewCode
	.s notFlag = ""
	.s list = ""
	.i (deaseNewDesc'="")&&(dicDescId=0)   d
	..s $p(data,"^",1) = $p(data,"^",1)_"&"_"不存在"
	..s notFlag = 0
	.i (deaseNewDesc'="")&&(dicDescId'=0)   d
	..s $p(data,"^",1) = ""
	..s icdindex = deaseNewDesc_icdNewCode
	..s ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,icdindex) = deaseNewDesc_"^"_deaseNewDesc_"^"_icdNewCode_"^"_icdNewDesc
	.//疾病名称
	.i (otherNewNameOne'="")&&(dicOneId=0)   d
	..s $p(data,"^",2) = $p(data,"^",2)_"&"_"不存在"
	..s notFlag = 0
	.i (otherNewNameOne'="")&&(dicOneId'=0)   d
	..s $p(data,"^",2) = ""
	..s icdindex = otherNewNameOne_icdNewCode
	..s ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,icdindex) = otherNewNameOne_"^"_otherNewNameOne_"^"_icdNewCode_"^"_icdNewDesc
	.//疾病别名1
	.i (otherNewNameTwo'="")&&(dicTwoId=0)   d
	..s $p(data,"^",3) = $p(data,"^",3)_"&"_"不存在"
	..s notFlag = 0
	.i (otherNewNameTwo'="")&&(dicTwoId'=0)   d
	..s $p(data,"^",3) = ""
	..s icdindex = otherNewNameTwo_icdNewCode
	..s ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,icdindex) = otherNewNameTwo_"^"_otherNewNameTwo_"^"_icdNewCode_"^"_icdNewDesc
	.//疾病别名2
	.i (otherNewNameThr'="")&&(dicThrId=0)   d
	..s $p(data,"^",4) = $p(data,"^",4)_"&"_"不存在"
	..s notFlag = 0
	.i (otherNewNameThr'="")&&(dicThrId'=0)   d
	..s $p(data,"^",4) = ""
	..s icdindex = otherNewNameThr_icdNewCode
	..s ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,icdindex) = otherNewNameThr_"^"_otherNewNameThr_"^"_icdNewCode_"^"_icdNewDesc
	.//疾病别名3
	.i (otherNewNameFor'="")&&(dicForId=0)   d
	..s $p(data,"^",5) = $p(data,"^",5)_"&"_"不存在"
	..s notFlag = 0
	.i (otherNewNameFor'="")&&(dicForId'=0)   d
	..s $p(data,"^",5) = ""
	..s icdindex = otherNewNameFor_icdNewCode
	..s ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,icdindex) = otherNewNameFor_"^"_otherNewNameFor_"^"_icdNewCode_"^"_icdNewDesc
	.//疾病别名5
	.i (otherNewNameFiv'="")&&(dicFivId=0)   d
	..s $p(data,"^",6) = $p(data,"^",6)_"&"_"不存在"
	..s notFlag = 0
	.i (otherNewNameFiv'="")&&(dicFivId'=0)   d
	..s $p(data,"^",6) = ""
	..s icdindex = otherNewNameFiv_icdNewCode
	..s ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,icdindex) = otherNewNameFiv_"^"_otherNewNameFiv_"^"_icdNewCode_"^"_icdNewDesc
	.i notFlag=0 s ^TMP("web.DHCCKBIcdImport","ImportDiagData",pid,deaseNewDesc) = data
	
	
	b   //11
	s count = 0
	s inIndex = ""
	for  s inIndex = $o(^TMP("web.DHCCKBIcdImport","ImportDiag",pid,inIndex))  Q:inIndex=""  d
	.s indata = ^TMP("web.DHCCKBIcdImport","ImportDiag",pid,inIndex)
	.s libCode = $p(indata,"^",1)
	.Q:libCode=""
	.s libDesc = $p(indata,"^",2)
	.s hisCode = $p(indata,"^",3)
	.s hisDesc = $p(indata,"^",4)
	.q:hisCode=""
	.;Q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc)))
	.s icdExtId = ..GetIdListByDesc(hisCode,hisDesc,"26938")
	.b:icdExtId=213878
	.i +icdExtId = 0  d
	..s parref = 205985
	..&sql(insert into CT_CKB_PDSS.CommonDiction (CD_Code,CD_Desc,CD_Parref_Dr) values (:hisCode,:hisDesc,:parref))
	.s count = count+1
	.s params = ..getConList(indata)
	.s loginInfo = "11870^8^1^291^2"
	.s operator = $p(loginInfo,"^",1)
	.s clientIP = "127.0.0.1"
	.s selHospId = "120"
	.s conExistFlag = ..IsExitConRelation(libDesc)
	.i conExistFlag=1  d
	..s id = ##class(web.DHCCKBCommon).GetDicIdByCode(libDesc,"115")
	..s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",id,"sourceyy",operator,"","","D",selHospId,clientIP,"acc")
	.s ret = ..saveConDataBat(params,loginInfo,clientIP,selHospId)
	Q count
}

/// Descript:处理icd串
ClassMethod handIcdData(pid, deaseDesc, otherNameOne, otherNameTwo, otherNameThr, otherNameFor, otherNameFiv, icdList, count)
{
	n (pid,deaseDesc,otherNameOne,otherNameTwo,otherNameThr,otherNameFor,otherNameFiv,icdList,count)
	s icdList = $p(icdList,":",2)
	s icdLen = $l(icdList,"【")
	
	for i=1:1:icdLen   d
	.s icdStr = $p(icdList,"【",i)
	.s ^temptest("icdStr") = icdStr
	.Q:icdStr=" "
	.s icdCode = $p(icdStr,"】",1)
	.s icdCode = $tr(icdCode," ","")
	.s icdDesc = $p(icdStr,"】",2)
	.s icdDesc = $tr(icdDesc," ","")
	.s listData = deaseDesc_"^"_otherNameOne_"^"_otherNameTwo_"^"_otherNameThr_"^"_otherNameFor_"^"_otherNameFiv_"^"_icdCode_"^"_icdDesc_"^"_icdList
	.s count = count+1
	.s ^TMP("DHCCKB","web.DHCCKBIcdImport","handIcdData",pid,count) = listData
	Q ""
}

/// Descript:获取icd对照串
/// w ##class(web.DHCCKBIcdImport).getConList("上呼吸道感^上呼吸道感染^J00-J06^急性上呼吸道感染^213878")
ClassMethod getConList(data)
{
	n (data)
	s dicCode = $p(data,"^",1)
	s dicDesc = $p(data,"^",2)
	s icdCode = $p(data,"^",3)
	s icdDesc = $p(data,"^",4)
	s type= 115
	s parId = 26938
	s idList = ..GetIdListByDesc(icdCode,icdDesc,parId)
	Q:idList="" ""
	s length = $l(idList,"^")
	s params = ""
	for i=1:1:length   d
	.s id = $p(idList,"^",i)
	.;Q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",id))
	.s list = dicCode_"^"_dicDesc_"^"_icdCode_"^"_icdDesc_"^"_type_"^"_id
	.i params = "" s params = list
	.e  s params = params_"&&"_list
	Q params
}

/// Descript:根据描述取id
/// w ##class(web.DHCCKBIcdImport).GetIdListByDesc("B15.0","甲型肝炎，伴有肝昏迷","26938")
ClassMethod GetIdListByDesc(icdCode, icdDesc, parId)
{
	n (icdCode,icdDesc,parId)
	s ret=""
	s icdCode=$SYSTEM.Util.Collation(icdCode,6)
	q:icdCode="" ""
	
	s dicId = ""
	
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(icdCode),id))	q:id=""  d
	.s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(id)
	.q:(parId'="")&(parId'=tmpparref)
	.s descId = ""
	.for  s descId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),descId)) Q:descId=""  d
	..s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(descId)
	..q:(parId'="")&(parId'=tmpparref)
	..Q:id'=descId
	..s dicId = descId
	Q dicId
		
	/*s icdDesc=$SYSTEM.Util.Collation(icdDesc,6)
	q:icdDesc="" ""

	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),id))	q:id=""  d
	.s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(id)
	.q:(parId'="")&(parId'=tmpparref)
	.s ret = id
	Q:dicId=ret dicId
	
	//处理特殊符号
	s ret = ""
	s icdDesc = $tr(icdDesc,",","，")
	s icdDesc=$SYSTEM.Util.Collation(icdDesc,6)
	q:icdDesc="" ""
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),id))	q:id=""  d
	.s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(id)
	.q:(parId'="")&(parId'=tmpparref)
	.s ret = id
	Q:dicId=ret dicId
	
	//处理特殊符号
	s ret = ""
	s icdDesc = $tr(icdDesc,"，",",")
	s icdDesc=$SYSTEM.Util.Collation(icdDesc,6)
	q:icdDesc="" ""
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),id))	q:id=""  d
	.s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(id)
	.q:(parId'="")&(parId'=tmpparref)
	.s ret = id
	Q:dicId=ret dicId
	
	//处理特殊符号
	s ret = ""
	s icdDesc = $tr(icdDesc,"（","(")
	s icdDesc = $tr(icdDesc,"）",")")
	s icdDesc=$SYSTEM.Util.Collation(icdDesc,6)
	q:icdDesc="" ""
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),id))	q:id=""  d
	.s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(id)
	.q:(parId'="")&(parId'=tmpparref)
	.s ret = id
	Q:dicId=ret dicId
	
	//处理特殊符号
	s ret = ""
	s icdDesc = $tr(icdDesc,"(","（")
	s icdDesc = $tr(icdDesc,")","）")
	s icdDesc=$SYSTEM.Util.Collation(icdDesc,6)
	q:icdDesc="" ""
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(icdDesc),id))	q:id=""  d
	.s tmpparref=##class(web.DHCCKBRuleImport).GetDicParrefId(id)
	.q:(parId'="")&(parId'=tmpparref)
	.s ret = id
	Q:dicId=ret dicId

	q ret*/
}

/// Descript：判断该疾病在库里是否存在对照关系
ClassMethod IsExitConRelation(libDesc)
{
	n (libDesc)
	Q:'$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc))) 1
	Q 0
}

/// Descript:保存
/// w ##class(web.DHCCKBIcdImport).saveConDataBat("上呼吸道感^上呼吸道感染^J00-J06^急性上呼吸道感染^115^213878","11870^8^1^291^2","127.0.0.1",120)
ClassMethod saveConDataBat(params, loginInfo, clientIP, selHospId)
{
	n (params,loginInfo,clientIP,selHospId)
	
	s params = ##class(web.DHCCKBComContrast).dealDeaseData(params)

	s ret = 0
	s length = $l(params,"&&")
	for i=1:1:length d
	.s listdata = $p(params,"&&",i)
	.s libcode = $p(listdata,"^",1)  //知识库代码
    .s libdesc = $p(listdata,"^",2)  //知识库描述
    .s hiscode = $p(listdata,"^",3)  //His代码
    .s hisdesc = $p($p(listdata,"^",4),"||",1)  //His描述 药品||厂家 取前半段
    .s dictype = $p(listdata,"^",5)  //实体类型
    .s operator = $p(loginInfo,"^",1)
    .s hospital = selHospId
    .Q:libdesc=""
    .q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libdesc),$$UPPER^SSUTIL4(hisdesc)))
    .s obj=##class(CKB.PDSS.ComContrast).%New()
	.s obj.CCLibCode = libcode
	.s obj.CCLibDesc = libdesc
	.s obj.CCHisCode = hiscode
	.s obj.CCHisDesc = hisdesc
	.s obj.CCDicType = dictype
	.s obj.CCHospital = hospital
	.s sc=obj.%Save()
	.d obj.%Close()
	.i $$$ISOK(sc) d
	..s id = obj.%Id()
	..s addflag=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBComContrast",id,"add",operator,"","","D",hospital,clientIP,"acc")
	..// 保存后自动授权
	..s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBComContrast",id,"grantAuth",operator,"","","D",hospital,clientIP,"acc")
	..// 保存后加特殊标记sourceyy
	..s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBComContrast",id,"sourcebgdata02",operator,"","","D",hospital,clientIP,"acc")
	Q ret
}

/// Descript:导出库里不存在的疾病
/// Creator:sufan
/// CreateDate:2022-05-26
/// w ##Class(websys.Query).ToExcel("未对照适应症3","web.DHCCKBIcdImport","QueryicdNoMatch",278840722)
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryicdNoMatch",275191167) 
Query QueryicdNoMatch(pid) As websys.Query(ROWSPEC = "f1:%String:西医疾病,f2:%String:别名1,f3:%String:别名2,f4:%String:别名3,f5:%String:别名4,f6:%String:别名5,f6:%String:ICD代码,f7:%String:ICD1,f8:%String:ICD诊断,f9:%String:ICD诊断")
{
}

ClassMethod QueryicdNoMatchExecute(ByRef qHandle As %Binary, pid) As %Status
{
	n (qHandle,pid)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s count = 0
	s h=0
	s index = ""
	for  s index = $o(^TMP("web.DHCCKBIcdImport","ImportDiagData",pid,index))  Q:index=""  d
	.s h=h+1
	.s data = ^TMP("web.DHCCKBIcdImport","ImportDiagData",pid,index)
	.set ^CacheTemp(repid,ind)=$listfromstring(data,"^")
	.set ind=ind+1	
	b
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:补充和分类对照的icd诊断
/// w ##class(web.DHCCKBIcdImport).SuppIcdDic()
ClassMethod SuppIcdDic()
{
	s ret = ""
	s dicType = 115
	s conId = ""
	for  s conId = $o(^CKB.PDSS.ComContrastI("Type",dicType,conId))  Q:conId=""  d
	.s conData = $g(^CKB.PDSS.ComContrastD(conId))
	.s libCode = $lg(conData,2) 
	.s libDesc = $lg(conData,3) 
	.s hisCode = $lg(conData,4) 
	.s hisDesc = $lg(conData,5) 
	.s indata = libCode_"^"_libDesc_"^"_hisCode_"^"_hisDesc
	.s params = ..getConList(indata)
	.q:params=""
	.s loginInfo = "11870^8^1^291^2"
	.s operator = $p(loginInfo,"^",1)
	.s clientIP = "127.0.0.1"
	.s selHospId = "120"
	.s ret = ..saveConDataBat(params,loginInfo,clientIP,selHospId)
	Q ret
}

/// Descript:项目药品用到的疾病
/// Input:本系统医院名称
/// w ##class(web.DHCCKBIcdImport).MangeDeaseUseNum("TASZXYYGXYYQ") 
ClassMethod MangeDeaseUseNum(hospCode)
{
	n (hospCode)
	s inHospId = $o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospCode),""))
	Q:$g(inHospId)="" "医院代码有误，请核对！"
	s drugTypeList = "105^81790"
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s drugTotNum = 0
	k deaArr
	for i=1:1:2  d
	.s typeId = $p(drugTypeList,"^",i)
	.s conId = ""
	.for  s conId = $o(^CKB.PDSS.ComContrastI("Type",typeId,conId))  Q:conId=""  d
	..s conData =$g(^CKB.PDSS.ComContrastD(conId))
	..s hospId = $lg(conData,7)
	..Q:hospId'=inHospId
	..s drugTotNum = drugTotNum+1
	..s libDesc = $lg(conData,3)
	..s dicId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,typeId)
	..Q:+dicId=0
	..s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	..s ruleDicId = ""
	..for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicId,ruleDicId))  Q:ruleDicId=""  d
	...s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	...s ruleLabFlag = ..IsLabCatRule(ruleId,"RuleIndic")
	...Q:ruleLabFlag=0
	...s ruleDataId = ""
	...for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Rule",ruleId,ruleDataId))  Q:ruleDataId=""  d
	....s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	....Q:(leftDic'=6)&&(leftDic'=82166)
	....s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)
	....Q:rightDic=""
	....s deaArr(rightDic) = rightDic
	....s rdease = $lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	....i '$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(rdease)))   d
	.....s listData = rdease_"#"_ruleId
	.....i $d(^TMP("DHCCKB","web.DHCCKBIcdImport","DRUG",pid,drugDesc))   d
	......s ^TMP("DHCCKB","web.DHCCKBIcdImport","DRUG",pid,drugDesc) = ^TMP("DHCCKB","web.DHCCKBIcdImport","DRUG",pid,drugDesc)_"&"_listData
	.....e  d
	......s ^TMP("DHCCKB","web.DHCCKBIcdImport","DRUG",pid,drugDesc) = listData
	
	//计算疾病数量
	s deasNum = 0,conNum = 0,unconNum = 0,drugNum = 0
	s deaIndex = ""
	for  s deaIndex = $o(deaArr(deaIndex))  Q:deaIndex=""  d
	.s deasNum = deasNum+1
	.s deasDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(deaIndex)),3)
	.i $d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(deasDesc))) s conNum = conNum+1
	.i '$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(deasDesc))) s unconNum = unconNum+1
	.i '$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(deasDesc)))  d
	..s ^TMP("DHCCKB","web.DHCCKBIcdImport","MangeDeaseUseNum",pid,deaIndex) = deasDesc
	
	//计算未对照疾病涉及的药品数量
	s drugIndex = ""
	for  s drugIndex = $o(^TMP("DHCCKB","web.DHCCKBIcdImport","DRUG",pid,drugIndex))  Q:drugIndex=""  d
	.s drugNum = drugNum+1

	//计算导入的对照关系涉及的项目药品数量
	k drugArr
	k newDeaArr 
	s newconNum = 0,invDrugNum = 0
	s deaconId = ""
	for  s deaconId = $o(^CKB.PDSS.ComContrastI("Type",115,deaconId))  Q:deaconId=""  d
	.s conData = $g(^CKB.PDSS.ComContrastD(deaconId))
	.s hospitalId = $lg(conData,7)
	.Q:hospitalId'=inHospId
	.s newconNum = newconNum+1
	.s libDesc = $lg(conData,3)
	.s libDicId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,115)
	.Q:$d(newDeaArr(libDicId))
	.s newDeaArr(libDicId) = libDicId
	.s newruelId = ""
	.for  s newruelId = $o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",+libDicId,newruelId)) Q:newruelId=""  d
	..s ruDrugId = ##class(web.DHCCKBIcdImport).getRuleLinkDrug(newruelId)
	..Q:ruDrugId=""
	..s drugArr(ruDrugId) = ruDrugId
	
	b   //11
	s drugIndex = ""
	for  s drugIndex = $o(drugArr(drugIndex)) Q:drugIndex=""  d
	.Q:..IsProDrug(drugIndex,inHospId)'=1
	.s invDrugNum = invDrugNum+1
	
	k ^TMP("DHCCKB","web.DHCCKBIcdImport","DRUG",pid)
	k ^TMP("DHCCKB","web.DHCCKBIcdImport","MangeDeaseUseNum",pid)
	s retList = "项目药品适应症规则涉及的疾病："_deasNum_" ;项目适应症规则涉及的疾病对照数量："_conNum_" ;项目适应症规则涉及的疾病未对照数量："_unconNum_" ;项目药品总数："_drugTotNum
	s retList = retList_" ;项目未对照疾病涉及的药品数量："_drugNum_" ;新导入对照关系涉及的药品数量："_invDrugNum
	b   //222
	Q retList
}

/// Descript:判断规则是否在对应目录下
ClassMethod IsLabCatRule(ruleId, catCode)
{
	n (ruleId,catCode)
	s existFlag = 0
	s catId = ##class(web.DHCCKBCommon).GetDicIdByCode(catCode,"49551")
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,dicId)) Q:(dicId="")||(existFlag=1)  d
	.Q:dicId'=catId
	.s existFlag = 1
	Q existFlag
}

/// Descript:获取规则关联药品id
/// w ##class(web.DHCCKBIcdImport).getRuleLinkDrug(195491)
ClassMethod getRuleLinkDrug(ruleId)
{
	n (ruleId)
	s existFlag = ..IsLabCatRule(ruleId,"RuleIndic")
	Q:existFlag'=1 ""
	s drugId = ""
	s parId = ""
	for  s parId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,parId)) Q:parId=""  d
	.Q:(parId'=105)&&(parId'=81790)
	.s ruledicId = ""
	.for  s ruledicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,parId,ruledicId))  Q:ruledicId=""  d
	..s drugId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruledicId)),3)

	Q drugId
}

/// Descript:判断药品是否是对应项目的
ClassMethod IsProDrug(drugId, hospId)
{
	
	n (drugId,hospId)
	s isFlag = 0
	s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	Q:drugDesc="" isFlag
	s hisDesc = ""
	for  s hisDesc = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(drugDesc),hisDesc))  Q:(hisDesc="")||(isFlag=1)  d
	.s conId = ""
	.for  s conId = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(drugDesc),hisDesc,conId)) Q:(conId="")||(isFlag=1)  d
	..s hospitalId = $lg(^CKB.PDSS.ComContrastD(conId),7)
	..Q:hospitalId'=hospId
	..s isFlag=1
	Q isFlag
}

/// Descript:更新疾病里含有特殊符号，导致和知识库不一致的对照关系
/// w ##class(web.DHCCKBIcdImport).updConData()
ClassMethod updConData()
{
	s deaconId = "0"
	s count = 0
	for  s deaconId = $o(^CKB.PDSS.ComContrastI("Type",115,deaconId))  Q:deaconId=""  d
	.s conData = $g(^CKB.PDSS.ComContrastD(deaconId))
	.s libCode = $lg(conData,2) 
	.s libDesc = $lg(conData,3) 
	.s libDicId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,115)
	.Q:libDicId=0
	.s newLibCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(libDicId)),2)
	.s newLibDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(libDicId)),3)
	.Q:(libCode=newLibCode)&&(libDesc=newLibDesc)
	.s count = count+1
	.&sql(update CKB_PDSS.ComContrast set CC_LibCode=:newLibCode,CC_LibDesc=:newLibDesc where CC_RowID=:deaconId)
	.w libDesc,!
	Q count
}

/// w ##class(web.DHCCKBIcdImport).CalDeaseNum()
ClassMethod CalDeaseNum()
{
	s count = ""
	k conArr
	s conId = ""
	for  s conId = $o(^CKB.PDSS.ComContrastI("Type",115,conId))  Q:conId=""  d
	.s libCode = $lg(^CKB.PDSS.ComContrastD(conId),2)
	.s libId = ##class(web.DHCCKBCommon).GetDicIdByCode(libCode,115)
	.Q:+libId="0"
	.s isEnable = ##class(web.DHCCKBCommon).IsEnabled(libId)
	.Q:isEnable'=1
	.s count = count+1
	.s conArr(libId) = libId
	
	s dcount = 0
	s index = ""
	for  s index = $o(conArr(index)) Q:index=""  d
	.s dcount = dcount+1
	W count,!
	W dcount,!
	Q ""
}

/// Descript:导入cdss和大数据的icd匹配关系
/// CreateDate:2022-07-08
/// Creator:sufan 
/// w ##class(web.DHCCKBIcdImport).ImpCdssDiagData("D:\temp\诊断标准数据带ICD编码-修正.txt","BGDATA") 
ClassMethod ImpCdssDiagData(filepath, node)
{
	n (filepath,node)
	k ^TMP("DHCCKB","handIcdReaData",node)
	k tmpArr
	d ..readTetFile(filepath,.tmpArr)
	b    ///222
	s count = 0
	s index = ""
	for  s index = $o(tmpArr(index))  Q:index=""  d
	.s deaseCode = $replace($p(tmpArr(index),"!!",1)," ","")
	.s deaseDesc = $replace($p(tmpArr(index),"!!",2)," ","")
	.s icdList = $p(tmpArr(index),"!!",3)
	.s realation = $replace($p(tmpArr(index),"!!",4)," ","")
	.s retList = ..handIcdReaData(deaseCode,deaseDesc,icdList,realation,node,.count)
	Q count
}

ClassMethod handIcdReaData(libCode, libDesc, icdList, realation, node, count)
{
	n (libCode,libDesc,icdList,realation,node,count)
	s len = $l(icdList,"^")
	for i=1:1:len   d
	.s trueFlag = 0
	.s icdStr = $p(icdList,"^",i)
	.s icdStr = $replace(icdStr,"：",":")
	.s icdCode = $replace($p(icdStr,":",1)," ","")
	.s icdDesc = $replace($p(icdStr,":",2)," ","")
	.s conList = libCode_"^"_libDesc_"^"_icdCode_"^"_icdDesc_"^"_realation
	.s index = libCode_"^"_libDesc_"^"_icdCode_"^"_icdDesc
	.Q:(libCode="")||(libDesc="")
	.i (libCode="")||(libDesc)||(icdCode="")||(icdDesc="") d
	..s ^TMP("DHCCKB","handIcdReaData","ERRDATA",node,index) = conList
	..s trueFlag = -1
	.Q:trueFlag=-1
	.s count = count+1
	.s ^TMP("DHCCKB","handIcdReaData",node,index) = conList
	q ""
}

/// Descript:计算已存在项目
/// w ##class(web.DHCCKBIcdImport).CalConDataNum() 
ClassMethod CalConDataNum()
{
	s count = 0,connum = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","handIcdReaData","BGDATA",index)) Q:index=""  d
	.s listdata = ^TMP("DHCCKB","handIcdReaData","BGDATA",index)
	.s libcode = $p(listdata,"^",1)  //知识库代码
    .s libdesc = $p(listdata,"^",2)  //知识库描述
    .s hiscode = $p(listdata,"^",3)  //His代码
    .s hisdesc = $p($p(listdata,"^",4),"||",1)  //His描述 药品||厂家 取前半段
    .s count = count+1
    .q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libdesc),$$UPPER^SSUTIL4(hisdesc)))
    .s connum = connum+1
    Q count_"&"_connum
}

/// Descript:取cdss和大数据的icd关系交集
/// CreateDate:2022-07-08
/// Creator:sufan 
/// w ##class(web.DHCCKBIcdImport).GetInterData() 
ClassMethod GetInterData()
{
	s count = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","handIcdReaData","CDSS",index)) Q:index=""   d
	.s data = ^TMP("DHCCKB","handIcdReaData","CDSS",index)
	.i $d(^TMP("DHCCKB","handIcdReaData","BGDATA",index))  d
	..s ^TMP("DHCCKB","GetInterData",index) = data
	..s count = count+1
	Q count
}

/// Descript:计算交集里涉及的疾病
/// CreateDate:2022-07-08
/// Creator:sufan 
/// w ##class(web.DHCCKBIcdImport).GetConDease() 
ClassMethod GetConDease()
{
	k conArr
	s count = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","GetInterData",index)) Q:index=""  d
	.s data = ^TMP("DHCCKB","GetInterData",index)
	.s libCode = $p(data,"^",1)
	.i $d(^TMP("DHCCKB","GetConDease",libCode))  d
	..s $p(^TMP("DHCCKB","GetConDease",libCode),"^",2) = $p(^TMP("DHCCKB","GetConDease",libCode),"^",2)+1
	.e  d
	..s ^TMP("DHCCKB","GetConDease",libCode) = libCode _"^"_ 1
	..s count = count+1
	Q count
}

/// Descript:导出新增的疾病及对照关系数量
/// Creator:sufan
/// CreateDate:2022-05-26
/// w ##Class(websys.Query).ToExcel("对照关系数量","web.DHCCKBIcdImport","QueryMatchNum")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBIcdImport","QueryMatchNum") 
Query QueryMatchNum() As websys.Query(ROWSPEC = "f1:%String:疾病名称,f2:%String:对照数量")
{
}

ClassMethod QueryMatchNumExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s count = 0
	s h=0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","GetConDease",index))  Q:index=""  d
	.s h=h+1
	.s data = ^TMP("DHCCKB","GetConDease",index)
	.set ^CacheTemp(repid,ind)=$listfromstring(data,"^")
	.set ind=ind+1	
	b
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:导出交集关系
/// CreateDate:2022-07-08
/// Creator:sufan 
/// w ##class(web.DHCCKBIcdImport).importData()
ClassMethod importData()
{
	s index = ""
	for  s index = $o(^TMP("DHCCKB","GetInterData",index))  Q:index=""  d
	.s indata = ^TMP("DHCCKB","GetInterData",index)
	.s ret = ..ImpIcdData(indata)
	Q ""
}

/// Descript:导入cdss数据[2022-07-26]
/// CreateDate:2022-07-08
/// Creator:sufan 
/// w ##class(web.DHCCKBIcdImport).importBgData()
ClassMethod importBgData()
{
	s index = ""
	for  s index = $o(^TMP("DHCCKB","handIcdReaData","BGDATA",index))  Q:index=""  d
	.s indata = ^TMP("DHCCKB","handIcdReaData","BGDATA",index)
	.s ret = ..ImpIcdData(indata)
	Q ""
}

/// 诊断导入公共方法
ClassMethod ImpIcdData(indata)
{
	s params = ..getConList(indata)
	s loginInfo = "11870^8^1^291^2"
	s operator = $p(loginInfo,"^",1)
	s clientIP = "127.0.0.1"
	s selHospId = "120"
	s ret = ..saveConDataBat(params,loginInfo,clientIP,selHospId)
	Q ""
}

/// Descript:导入毒麻精药品标记
/// w ##class(web.DHCCKBIcdImport).SignDrugAttr("D:\temp\dmjdruglist.txt")
ClassMethod SignDrugAttr(filepath)
{
	n (filepath)
	k tmpArr
	d ..readTetFile(filepath,.tmpArr)
	s generalDataId = ##class(web.DHCCKBCommon).GetGeneralData()
	s narcoticDrugId = ##class(web.DHCCKBCommon).GetDicIdByCode("NarcoticDrug")
	s psyiDrugId = ##class(web.DHCCKBCommon).GetDicIdByCode("PsychotropicDrugsOfCategoryI")
	s psyiiDrugId = ##class(web.DHCCKBCommon).GetDicIdByCode("PsychotropicDrugsOfCategoryII")
	s toxMedId = ##class(web.DHCCKBCommon).GetDicIdByCode("ToxicDrugsForMedicalUse")
	s radioactiId = ##class(web.DHCCKBCommon).GetDicIdByCode("RadioactiveDrug")
	s trueId = 26852
	s index = ""
	for  s index = $o(tmpArr(index))  Q:index=""  d
	.s listData = tmpArr(index)
	.s hxm = $p(listData,"!!",6)
	.s mzyp = $p(listData,"!!",17)
	.s dyljsyp = $p(listData,"!!",18)
	.s deljsyp = $p(listData,"!!",19)
	.s dxypyp = $p(listData,"!!",20)
	.s fsxyp = $p(listData,"!!",21)
	.s hxmList = ""
	.s hxmId = ##class(web.DHCCKBCommon).GetDicIdByDesc(hxm,generalDataId)
	.s:hxmId=0 ^temptest("DHCCKB","hxmwk",hxmId) = hxm
	.s $LIST(hxmList,*+1) = hxmId
	.s drugList = ..GetDrugListByGenName(hxmList)
	.s:$listlength(drugList)<1 ^temptest("DHCCKB","ypwk",hxmId) = hxm
	.Q:$listlength(drugList)<1 
	.for i=1:1:$listlength(drugList)  d
	..s drugId = $list(drugList,i)
	..;Q:drugId'=130607
	..i mzyp'=""  d
	...B:drugId=130607	///1
	...s mzattrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,narcoticDrugId,""))
	...i mzattrId=""  d
	....&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:drugId,:narcoticDrugId,:trueId))
	...e  d
	....&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:trueId where DLA_RowID=:mzattrId)
	..i dyljsyp'=""  d
	...B:drugId=130607	///2
	...s dyljsypId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,psyiDrugId,""))
	...i dyljsypId=""  d
	....&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:drugId,:psyiDrugId,:trueId))
	...e  d
	....&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:trueId where DLA_RowID=:dyljsypId)
	..i deljsyp'=""  d
	...B:drugId=130607	///3
	...s deljsypId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,psyiiDrugId,""))
	...i deljsypId=""  d
	....&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:drugId,:psyiiDrugId,:trueId))
	...e  d
	....&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:trueId where DLA_RowID=:deljsypId)
	..i dxypyp'=""  d
	...B:drugId=130607	///4
	...s dxypypId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,toxMedId,""))
	...i dxypypId=""  d
	....&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:drugId,:toxMedId,:trueId))
	...e  d
	....&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:trueId where DLA_RowID=:dxypypId)
	..i fsxyp'=""  d
	...B:drugId=130607		///5
	...s fsxypId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,radioactiId,""))
	...i fsxypId=""  d
	....&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values (:drugId,:radioactiId,:trueId))
	...e  d
	....&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:trueId where DLA_RowID=:fsxypId)
}

ClassMethod GetDrugListByGenName(generIdList, hospitalId = "")
{
	n (generIdList,hospitalId)
	k DrugList
	s DrugList = ""
	Q:$listlength(generIdList)=0 DrugList
	s len = $listlength(generIdList)
	for i=1:1:len  d
	.s generId = $list(generIdList,i)
	.Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",generId))
	.s attrId = ""
	.for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",generId,attrId)) Q:attrId=""  d
	..s DrugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	..Q:+DrugId=0    
	..Q:'$d(^CT.CKB.PDSS.CommonDictionD(DrugId))
	..Q:0=##class(web.DHCCKBCommon).IsEnabled(DrugId)	// 过滤停用
	..s conFlag = ##class(web.DHCCKBComContrast).IsSysContrast(DrugId,hospitalId)
	..;Q:conFlag=0
	..s $LIST(DrugList,*+1)=DrugId
	Q DrugList
}

}
