Import sqluser

/// Creator:		qunianpeng
/// Description:	安全用药临时问题处理类
/// Date:			2021-05-07
Class web.DHCCKBTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		qunianpeng
/// CreatDate:		2020-05-07
/// Description:： 	增加处方应付字典数据,从关联表中的处方应付中抽取
/// Input:
/// Other:	w ##class(web.DHCCKBTest).AddPrescriptionCopeData()
ClassMethod AddPrescriptionCopeData()
{
	
	s loginInfo = "11877^6^1^289^2"
	s clientIP = "111.18.245.55"
	s count = 0 
	s sucessNum = 0
	s attrCodeProp = ##class(web.DHCCKBCommon).GetDicIdByCode("PrescriptionCopeProp")	// 处方应付的属性id
	s prescriptionCopeData = ##class(web.DHCCKBCommon).GetDicIdByCode("PrescriptionCopeData")	// 处方应付的字典id
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",+attrCodeProp)) ""
	s linkID = ""
	f  s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",attrCodeProp,linkID))	q:linkID=""  d
	.s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),5)
	.q:result=""
	.s params = "^"_result_"^"_result_"^"_prescriptionCopeData
	.s count = count + 1
	.s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(params,"",loginInfo,clientIP)
	.i ret=0 s sucessNum = sucessNum + 1
	
	w "count="_count_","_"successNum="_sucessNum,!
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2020-05-07
/// Description:： 	修改关联表中的处方应付数据，将文本修改成对应的处方应付字典数据id
/// Input:
/// Other:	w ##class(web.DHCCKBTest).UpdateLinkPrescriptionCope()
ClassMethod UpdateLinkPrescriptionCope()
{
	
	s count = 0 
	s sucessNum = 0
	s attrCodeProp = ##class(web.DHCCKBCommon).GetDicIdByCode("PrescriptionCopeProp")	// 处方应付的属性id
	s prescriptionCopeData = ##class(web.DHCCKBCommon).GetDicIdByCode("PrescriptionCopeData")	// 处方应付的字典id
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",+attrCodeProp)) ""
	s linkID = ""
	f  s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",attrCodeProp,linkID))	q:linkID=""  d
	.s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),5)
	.s tmpAttrDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)
	.q:tmpAttrDr'=""
	.q:result=""
	.s resultID = ##class(web.DHCCKBCommon).GetDicIdByCode(result,prescriptionCopeData)
	.s count = count + 1
	.s ret = ..UpdateDicLinkForPrescCope(resultID,linkID)
	.i ret=0 s sucessNum = sucessNum + 1
	
	w "count="_count_","_"successNum="_sucessNum,!
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2020-05-07
/// Description:： 	修改关联表中的处方应付数据
/// Input:
/// Other:	w ##class(web.DHCCKBTest).AddPrescriptionCopeData()
ClassMethod UpdateDicLinkForPrescCope(attrDr, linkID)
{
	n (attrDr,linkID)
	s result = ""
	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:attrDr,DLA_Result=:result where DLA_RowID=:linkID )
	
	q SQLCODE
}

/// Description:	将码表中的数据重新编码,然后将编码和现在的码表的关系存储起来(用于提供给第三方使用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBTest).CompileCode()
ClassMethod CompileCode() As %String
{
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //西药
 	s ret1 = ..CompileDrugCode(DrugData,"XY")
 	
  	s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() // 中成药
 	s ret2 = ..CompileDrugCode(DrugData,"ZCY")
 	
 	s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() 	// 中药饮片 
	s ret3 = ..CompileDrugCode(DrugData,"ZYYP")
 	
	q "西药:"_ret1_",中成药:"_ret2_":中药饮片:"_ret3
}

/// Description:	将码表中的数据重新编码,然后将编码和现在的码表的关系存储起来(用于提供给第三方使用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			药品字典id,药品标识
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBTest).CompileDrugCode()
/// w ##class(web.DHCCKBTest).test()
ClassMethod CompileDrugCode(parref, flag) As %String
{
	n (parref,flag)
	s count = 0
	ts
	s exitFlag = 0
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id)) q:(id="")||(exitFlag=1)  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s newCode = $select(flag="XY":##Class(web.DHCCKBCommonCom).XYCode(),flag="ZCY":##Class(web.DHCCKBCommonCom).ZCYCode(),flag="ZYYP":##Class(web.DHCCKBCommonCom).ZYYPCode(),1:"")
	.q:newCode=""
	.s ret=..SaveComDictionExt(newCode,id)
	.i +ret<=0 s exitFlag=1
	.q:exitFlag=1
	.s count = count + 1
	
	i exitFlag'=0 tro
	e  tc
	
	q count
}

ClassMethod SaveComDictionExt(newCode, dicRowID) As %String
{
	n (newCode,dicRowID)
	&SQL(INSERT INTO CKB_PDSS.ComDictionExt VALUES (:newCode,:dicRowID))
	q %ROWID
}

/// Description:	处理错误的对照关系
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			//DrugData ChineseDrugData
/// w ##Class(web.DHCCKBTest).AutoDealErrContrast("D:\知识图谱\测试数据\包医-西医(导入错误).txt","DrugData","106")
/// w ##Class(web.DHCCKBTest).AutoDealErrContrast("D:\知识图谱\测试数据\包医-中成药(导入错误).txt","ChineseDrugData","106")
ClassMethod AutoDealErrContrast(filepath As %String, dataType As %String, hospId As %String) As %String
{
	/* 读取错误的文件 */
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
		
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1	
	.s Err=""
	.q:hCount=1
	.s ^TMP("DHCCKB","web.DHCCKBTest","DealErrContrast",hCount)=impDataList
	.s ^TMP("DHCCKB","web.DHCCKBTest","DealErrContrast",hCount)=impDataList
	c filepath 
	
	s count = 0 
	s index =""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBTest","DealErrContrast",index))  q:index=""  d
	.s data = $g(^TMP("DHCCKB","web.DHCCKBTest","DealErrContrast",index))
	.q:data=""
	.s libCode = $p(data,"^",1)
	.s libDesc = $p(data,"^",2)
	.s extCode = $p(data,"^",3)	
	.s extDesc = $p(data,"^",4)
	./* 处理外部代码表的数据 */
	.s ret = ..DealErrExtData(extCode,extDesc,dataType,hospId)
	./* 处理关联表对应的日志 */
	.s dicType = ##class(web.DHCCKBCommon).GetDicIdByCode(dataType)
	.s ret = ..DealErrDicLog(libCode,libDesc,extCode,extDesc,dicType,hospId)
	./* 处理对照表的数据 */
	.s ret = ..DealErrContrast(libCode,libDesc,extCode,extDesc,dicType,hospId)
	.s count = count +1
	
	k ^TMP("DHCCKB","web.DHCCKBTest","DealErrContrast")
	q count
}

/// Description:	处理错误的外部代码表
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBTest).CompileDrugCode()
/// w ##class(web.DHCCKBTest).DealErrExtData("测试通用名","测试通用名","DrugData",106)
ClassMethod DealErrExtData(extCode As %String, extDesc As %String, dataType As %String, hospId As %String) As %String
{
	n (extCode,extDesc,dataType,hospId)
	s tmpDesc = extDesc_"||"
	
	&sql(delete from CKB_PDSS.ExtDiction where ED_Code=:extCode and ED_Type=:dataType and ED_Hospital=:hospId and (ED_Desc=:extDesc or ED_Desc=:tmpDesc) )
	
	q SQLCODE
}

/// Description:	处理错误的对照关系的日志
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			
/// other:			
/// w ##class(web.DHCCKBTest).DealErrDicLog("测试通用名(复制)","测试通用名(复制)","测试通用名","测试通用名",105,106)
ClassMethod DealErrDicLog(libCode As %String, libDesc As %String, hisCode As %String, hisDesc As %String, dicType As %String, hospId As %String) As %String
{
	n (libCode, libDesc, hisCode , hisDesc, dicType, hospId)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CC_RowID FROM CKB_PDSS.ComContrast Where "
	s sqlStr = sqlStr_"  CC_LibCode='"_libCode_"' And"
	s sqlStr = sqlStr_"  CC_LibDesc='"_libDesc_"' And"
	s sqlStr = sqlStr_"  CC_HisCode='"_hisCode_"' And"
	s sqlStr = sqlStr_"  CC_HisDesc='"_hisDesc_"' And"
	s sqlStr = sqlStr_"  CC_DicType='"_dicType_"' And"
	s sqlStr = sqlStr_"  CC_Hospital='"_hospId_"' "
    d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	While(result.Next())
	{	
		s RowId = result.Data("CC_RowID")	
		s dic = "CKB_PDSS.ComContrast"
		&sql(delete from CKB_PDSS.DicLog where DLG_Dic=:dic and DLG_Data_Dr=:RowId)
	
	}

	q ""
}

/// Description:	处理错误的对照关系
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBTest).CompileDrugCode()
/// w ##class(web.DHCCKBTest).DealErrContrast("测试通用名(复制)","测试通用名(复制)","测试通用名","测试通用名",105,106)
ClassMethod DealErrContrast(libCode As %String, libDesc As %String, hisCode As %String, hisDesc As %String, dicType As %String, hospId As %String) As %String
{
	n (libCode, libDesc, hisCode , hisDesc, dicType, hospId)
	
	&sql(delete from CKB_PDSS.ComContrast where CC_LibCode=:libCode and CC_LibDesc=:libDesc and CC_HisCode=:hisCode and CC_HisDesc=:hisDesc and CC_DicType=:dicType and CC_Hospital=:hospId)
	//&sql(delete from CKB_PDSS.ComContrast where CC_LibCode=:libCode and CC_LibDesc=:libDesc and CC_HisCode=:hisCode and CC_HisDesc=:hisDesc and CC_DicType=:dicType )
	
	q SQLCODE
}

/// Description:	处理错误的对照关系
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			
/// other:			
/// w ##class(web.DHCCKBTest).UPdateConst()
ClassMethod UPdateConst() As %String
{
	
	s type="111",count=0
	s id=""
	f  s id= $o(^CKB.PDSS.ComContrastI("Type",type,id)) q:id=""  d
	.s hosp=$lg(^CKB.PDSS.ComContrastD(id),7)
	.q:hosp'=108
	.s newHosp=2
	.s count = count + 1
	.&SQL(UPDATE CKB_PDSS.ComContrast SET CC_Hospital =:newHosp WHERE CC_RowID =:id)
	q count
}

/// Description:	处理错误的对照关系
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBTest).CompileDrugCode()
/// w ##class(web.DHCCKBTest).UpDateContrastDesc("D:\药品处理广西.txt")
ClassMethod UpDateContrastDesc(filepath As %String) As %String
{
	n (filepath)
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath

	s end=0,hCount=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""	
	.s impDataList=$tr(onerow,$c(9),del)
	.s hisCode1 = $p(impDataList,"^",1)
	.s HisDesc1 = $p(impDataList,"^",2)
	.q:(hisCode1="")||(HisDesc1="")
	.S hCount=hCount+1	
	.q:hCount=1
	.s ^TMP("web.DHCCKB","test",hisCode1)=HisDesc1
	
	c filepath 

	s count = 0,sucCount = 0
	s typeList = $lb(105,81790)
	s len = $listlength(typeList)
	f i=1:1:len d
	.s type = $listget(typeList,i)
	.s id = ""
	.f  s id=$o(^CKB.PDSS.ComContrastI("Type",type,id))  q:id=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(id)) 
	..s hosp = $lg(conData,7)
	..q:hosp'="108"
	..s hisCode = $lg(conData,4)
	..s hisDesc = $lg(conData,5)
	..q:'$d(^TMP("web.DHCCKB","test",hisCode))
	..s newHisDesc =$g(^TMP("web.DHCCKB","test",hisCode))
	..q:newHisDesc=""
	..&SQL(UPDATE CKB_PDSS.ComContrast SET CC_HisDesc =:newHisDesc WHERE CC_RowID =:id)
	..i SQLCODE=0 s sucCount=sucCount+1
	..s count = count + 1
	
	k ^TMP("web.DHCCKB","test")
	q count_":"_sucCount
}

/// Description:	处理错误的对照关系
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-06	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBTest).CompileDrugCode()
/// w ##class(web.DHCCKBTest).UpDateExtByContrast()
ClassMethod UpDateExtByContrast() As %String
{
#;	SELECT * FROM CKB_PDSS.ExtDiction WHERE ED_Hospital=2 AND  ED_Type ="DrugData" AND ED_Code IN (
#;
#;SELECT CC_HisCode AS testCode,CC_HisDesc FROM CKB_PDSS.ComContrast WHERE CC_Hospital=2 AND CC_DicType=105
#;
#;)
#;	}105
	//'81790'
	//'81862'105	DrugData
	//  81790	ChineseDrugData
	// 81862	ChineseHerbalMedicineData

	s hosp = "108"
	s type = "ChineseDrugData"
	s count = 0 
	s id = ""
	f  s id = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,id)) q:id=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(id))
	.s hisCode = $lg(extData,2)
	.s hisDesc = $lg(extData,3)
	.q:'$d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode)))
	.s conID = ""
	.f  s conID=$o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),conID)) q:(conID="")  d
	..s conData = $g(^CKB.PDSS.ComContrastD(conID)) 
	..s conHosp = $lg(conData,7)
	..q:hosp'=conHosp
	..s conType = $lg(conData,6)
	..q:conType'=81790
	..s conHisDesc=$lg(conData,5)
	..q:conHisDesc=""
	..&SQL(UPDATE CKB_PDSS.ExtDiction SET ED_Desc =:conHisDesc WHERE ED_RowID =:id)
	..s count = count + 1
	
	q count
}

/// Description:	导入哈医大溶媒规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-08-07	
/// Input:			
/// return:			
/// other:			
/// w ##class(web.DHCCKBTest).ImportSolventRule("D:\知识图谱\哈医大溶媒数据对照结果20210907(处理格式11).txt")
ClassMethod ImportSolventRule(filepath As %String) As %String
{
	n (filepath)
	k ^TMP("web.DHCCKB","ImportSolventRule")
	
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath

	s end=0,hCount=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""	
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1	
	.q:hCount=1
	.s ^TMP("web.DHCCKB","ImportSolventRule",hCount)=impDataList
	c filepath 
		
	s count = 0,ret=0
	s index = ""
	f  s index = $o(^TMP("web.DHCCKB","ImportSolventRule",index)) q:(index="")||(ret'=0)  d
	.s dataList = $g(^TMP("web.DHCCKB","ImportSolventRule",index))
	.q:dataList=""
	.s ruleStr=..GetSolventRule(dataList)
	.q:ruleStr=""
	.s ret = ##class(web.DHCCKBRuleMaintain).save(ruleStr)
	.q:ret'=0
	.s mainID = $o(^DHCCKBRULEMAINTAIN(""),-1)
	.s groupID = $lg($g(^CT.CKB.PDSS.RuleDMAINTAIN(+mainID)),"^",3)
	.s msg = ##class(web.DHCCKBRule).SubmitRule(groupID,"11877^6^1^289^2")
	.s msg = {}.%FromJSON(msg) 
	.i msg.code'="success" s ret=-1
	.q:ret'=0
	.s count = count + 1 
	
	k ^TMP("web.DHCCKB","ImportSolventRule")
	q "共"_hCount_"条规则,导入成功:"_count_"条规则"
}

/// Description:	溶媒模板规则整理
/// Creator:		QuNianpeng 
/// CreateDate:		2021-08-07	
/// 组号^属性列对应的实际值^属性ID^模板ID^标记
/// "143631068^测试通用名(复制)^81224^91203^0$$
ClassMethod GetSolventRule(Data As %String) As %String
{
	n (Data)
	s RuleStr = ""
	
	s DrugProp = ##class(web.DHCCKBCommon).GetDicIdByCode("MedDrugNameProp")
	s TmpID = ##class(web.DHCCKBCommon).GetDicIdByDesc("溶媒溶液(西药)")
	s DrugPreMet = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugPreMet") // 给药途径		
	s SingleSolMass = ##class(web.DHCCKBCommon).GetDicIdByCode("SingleSolMass") // 单支溶质量
	s SolventProp = ##class(web.DHCCKBCommon).GetDicIdByCode("SolventProp") // 溶媒名称
	s NeceSolMed = ##class(web.DHCCKBCommon).GetDicIdByCode("NeceSolMed") 	// 是否必用溶媒药品
	s Solventvolume = ##class(web.DHCCKBCommon).GetDicIdByCode("Solventvolume") // 单支溶媒体积
	s SolventDensity = ##class(web.DHCCKBCommon).GetDicIdByCode("SolventDensity") // 单支溶媒浓度
	s SingleOrdVehVol = ##class(web.DHCCKBCommon).GetDicIdByCode("SingleOrdVehVol") // 单次医嘱对应溶媒量
	s SolutionProp =  ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionProp") // 溶液名称(处方通用名
	s NeceSolDrug = ##class(web.DHCCKBCommon).GetDicIdByCode("NeceSolDrug") // 是否必用溶液药品
	s SolutionVolume = ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionVolume") // 单支溶液体积
	s SolutionDensity = ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionDensity") // 单支溶液浓度
	s SingleOrdCorQua =  ##class(web.DHCCKBCommon).GetDicIdByCode("SingleOrdCorQua") // 单次医嘱对应溶液量
	s AuxDrugsNum =  ##class(web.DHCCKBCommon).GetDicIdByCode("AuxDrugsNum") // 辅助用药个数
	s WarnMessage = ##class(web.DHCCKBCommon).GetDicIdByCode("WarnMessage") // 提示信息
	
	s DrugName = $p(Data,"^",1) // 药品
	q:DrugName="" ""
	s DrugId = ..GetDicIdByDesc(DrugName)
	s DrugParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),4)
	s DrugParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugParref)),3)
		
	i DrugParref["中成药" d 
	.s TmpID = ##class(web.DHCCKBCommon).GetDicIdByDesc("溶媒溶液(中成药)") 
	.s DrugProp = ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugNameProp")
	.s DrugPreMet = $o(^CT.CKB.PDSS.CommonDictionI("Link",DrugPreMet,"")) // 给药途径		
	.s SingleSolMass = $o(^CT.CKB.PDSS.CommonDictionI("Link",SingleSolMass,"")) // 单支溶质量
	.s SolventProp =$o(^CT.CKB.PDSS.CommonDictionI("Link",SolventProp,"")) // 溶媒名称
	.s NeceSolMed = $o(^CT.CKB.PDSS.CommonDictionI("Link",NeceSolMed,"")) 	// 是否必用溶媒药品
	.s Solventvolume = $o(^CT.CKB.PDSS.CommonDictionI("Link",Solventvolume,"")) // 单支溶媒体积
	.s SolventDensity = $o(^CT.CKB.PDSS.CommonDictionI("Link",SolventDensity,"")) // 单支溶媒浓度
	.s SingleOrdVehVol = $o(^CT.CKB.PDSS.CommonDictionI("Link",SingleOrdVehVol,"")) // 单次医嘱对应溶媒量
	.s SolutionProp = $o(^CT.CKB.PDSS.CommonDictionI("Link",SolutionProp,"")) // 溶液名称(处方通用名
	.s NeceSolDrug =$o(^CT.CKB.PDSS.CommonDictionI("Link",NeceSolDrug,"")) // 是否必用溶液药品
	.s SolutionVolume =$o(^CT.CKB.PDSS.CommonDictionI("Link",SolutionVolume,"")) // 单支溶液体积
	.s SolutionDensity = $o(^CT.CKB.PDSS.CommonDictionI("Link",SolutionDensity,"")) // 单支溶液浓度
	.s SingleOrdCorQua = $o(^CT.CKB.PDSS.CommonDictionI("Link",SingleOrdCorQua,"")) // 单次医嘱对应溶液量
	.s AuxDrugsNum = $o(^CT.CKB.PDSS.CommonDictionI("Link",AuxDrugsNum,"")) // 辅助用药个数
	
	s LiquidConfig = ##class(web.DHCCKBCommon).GetDicIdByDesc("液体配置") 
	s RuleStr = "^"_DrugName_"^"_DrugProp_"^"_TmpID_"^"_0
	s RuleStr = RuleStr _"$$"_"^"_"液体配置"_"^"_LiquidConfig_"^"_TmpID_"^"_0

	s DrugPreMetValue = $p(Data,"^",2)		// 给药途径		
	i DrugPreMetValue'="" s RuleStr = RuleStr _"$$"_"^"_DrugPreMetValue_"^"_DrugPreMet_"^"_TmpID_"^"_0
	
	s SingleSolMassValue = $p(Data,"^",3) // 单支溶质量
	i SingleSolMassValue'="" s RuleStr = RuleStr _"$$"_"^"_SingleSolMassValue_"^"_SingleSolMass_"^"_TmpID_"^"_0
	
	s SolventPropValue = $p(Data,"^",4) // 溶媒名称
	i SolventPropValue'="" s RuleStr = RuleStr _"$$"_"^"_SolventPropValue_"^"_SolventProp_"^"_TmpID_"^"_0
	
	s NeceSolMedValue = $p(Data,"^",5) 	// 是否必用溶媒药品
	i NeceSolMedValue="1" s RuleStr = RuleStr _"$$"_"^"_"Y"_"^"_NeceSolMed_"^"_TmpID_"^"_0
	
	s SolventvolumeValue = $p(Data,"^",6) // 单支溶媒体积
	i SolventvolumeValue'="" s RuleStr = RuleStr _"$$"_"^"_SolventvolumeValue_"^"_Solventvolume_"^"_TmpID_"^"_0
	
	s SolventDensityValue = $p(Data,"^",7) // 单支溶媒浓度
	i SolventDensityValue'="" s RuleStr = RuleStr _"$$"_"^"_SolventDensityValue_"^"_SolventDensity_"^"_TmpID_"^"_0
	
	s SingleOrdVehVolValue = $p(Data,"^",8) // 单次医嘱对应溶媒量
	i SingleOrdVehVolValue'="" s RuleStr = RuleStr _"$$"_"^"_SingleOrdVehVolValue_"^"_SingleOrdVehVol_"^"_TmpID_"^"_0
	
	s SolutionPropValue =  $p(Data,"^",9) // 溶液名称(处方通用名
	i SolutionPropValue'="" s RuleStr = RuleStr _"$$"_"^"_SolutionPropValue_"^"_SolutionProp_"^"_TmpID_"^"_0
	
	s NeceSolDrugValue = $p(Data,"^",10) // 是否必用溶液药品
	i NeceSolDrugValue="1" s RuleStr = RuleStr _"$$"_"^"_"Y"_"^"_NeceSolDrug_"^"_TmpID_"^"_0
	
	s SolutionVolumeValue = $p(Data,"^",11) // 单支溶液体积
	i SolutionVolumeValue'="" s RuleStr = RuleStr_"$$"_"^"_SolutionVolumeValue_"^"_SolutionVolume_"^"_TmpID_"^"_0
	
	s SolutionDensityValue = $p(Data,"^",12) // 单支溶液浓度
	i SolutionDensityValue'="" s RuleStr = RuleStr _"$$"_"^"_SolutionDensityValue_"^"_SolutionDensity_"^"_TmpID_"^"_0
	
	s SingleOrdCorQuaValue =  $p(Data,"^",13) // 单次医嘱对应溶液量
	i SingleOrdCorQuaValue'="" s RuleStr = RuleStr _"$$"_"^"_SingleOrdCorQuaValue_"^"_SingleOrdCorQua_"^"_TmpID_"^"_0
	
	s AuxDrugsNumValue =  $p(Data,"^",14) // 辅助用药个数
	i AuxDrugsNumValue'="" s RuleStr = RuleStr _"$$"_"^"_AuxDrugsNumValue_"^"_AuxDrugsNum_"^"_TmpID_"^"_0
	
	s WarnMessageValue = $p(Data,"^",18) // 提示信息
	i WarnMessageValue'="" s RuleStr = RuleStr _"$$"_"^"_WarnMessageValue_"^"_WarnMessage_"^"_TmpID_"^"_0
	
	q RuleStr
}

ClassMethod GetDicIdByDesc(desc As %String) As %String
{
	n (desc)
	s desc=$SYSTEM.Util.Collation(desc,6)
	q:desc="" ""
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()
	s chineseData =##class(web.DHCCKBCommon).GetChineseDrugData()
	s chinHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s dataList = $lb(drugData,chineseData,chinHMData)
	s ret=0
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc),id))	q:id=""  d
	.s tmpparref=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.q:$listfind(dataList,tmpparref)=0
	.s ret=id

	q ret
}

/// Creator:		qunianpeng
/// CreatDate:		2020-05-07
/// Description:： 	增加处方应付字典数据,从关联表中的处方应付中抽取
/// Input:
/// Other:	w ##class(web.DHCCKBTest).CleanMonasterByDate("2021-09-13")
ClassMethod CleanMonasterByDate(date As %String) As %String
{
	s date = $zdh(date,3)
	
	s rowID = "",count = 0
	f  s rowID = $o(^CKB.PDSS.MonMasterI("CreateDate",date,rowID)) q:rowID=""  d
	.i $d(^CKB.PDSS.MonQueListI("Parref",rowID)) d
	..s monQue = ""
	..f  s monQue=$o(^CKB.PDSS.MonQueListI("Parref",rowID,monQue)) q:monQue=""  d // CKB_PDSS.MonQueList
	...&sql(delete from CKB_PDSS.MonQueList where CM_RowID=:monQue)
	.
	.i $d(^CKB.PDSS.MonFunListI("Parrf",rowID)) d
	..s monFun = ""
	..f  s monFun=$o(^CKB.PDSS.MonFunListI("Parrf",rowID,monFun)) q:monFun=""  d // CKB_PDSS.MonFunList
	...&sql(delete from CKB_PDSS.MonFunList where CM_RowID=:monFun)
	.
	.i $d(^CKB.PDSS.MonRuleListI("Parref",rowID)) d
	..s monRule = ""
	..f  s monRule=$o(^CKB.PDSS.MonFunListI("Parrf",rowID,monRule)) q:monRule=""  d // CKB_PDSS.MonRuleList
	...&sql(delete from CKB_PDSS.MonRuleList where CM_RowID=:monRule)
	.
	.
	.&sql(delete from CKB_PDSS.MonMaster where CM_RowID=:rowID)
	.s count = count + 1
	.w count,!
	
	q count
}

/// Description:	中药饮片知识数据更新
/// Creator:		qunianpeng
/// CreateDate:		2021-09-15
/// Input:			filepath：文件路径, loginInfo:登录信息(取一个登录界面中的loginInfo:登录信息), clientIPAddress:客户端ip
/// return:			
/// other:	w ##class(web.DHCCKBTest).ImportChineseHMKnowDatas("D:\临时数据\饮片库修改内容-0914（格式处理）.csv","11877^6^1^289^2","113.140.81.66")
ClassMethod ImportChineseHMKnowDatas(filepath, loginInfo, clientIPAddress) As %String
{
	n (filepath, loginInfo, clientIPAddress)
	k ^TMP("DHCCKB","web.DHCCKBTest","ImportChineseHMKnowDatas")
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	d ..ReadChHMDataByFile(pid,filepath)	// 先从后台导入数据
	s err = 0

	s row ="",count = 0 
	f  s row = $o(^TMP("DHCCKB","web.DHCCKBTest","ImportChineseHMKnowDatas",pid,row))  q:(row="")||(err'=0)  d
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBTest","ImportChineseHMKnowDatas",pid,row))
	.s err=..SaveDrugInstructions(rowData, loginInfo, clientIPAddress)	// 保存药品说明书信息
	.s count = count + 1
	.s:err'=0 err = err + 1

	w "共"_count_"条数据."_"失败"_err_"条."
	q ""
}

/// Description:	中药饮片字典数据从后台修改规则
/// Creator:		qunianpeng
/// CreateDate:		2021-09-15
/// Input:			filepath：文件路径
/// return:			
/// other:	w ##class(web.DHCCKBTest).ReadChHMDataByFile(1,"D:\知识图谱\中药饮片标准库字典.csv")
ClassMethod ReadChHMDataByFile(pid, filepath) As %String
{
	n (pid, filepath)	
	s count = 0,total = 0
	s parref = ##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片字典id
	
	
	s file=##class(%File).%New(filepath)
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s total = total + 1
		i total = 1  d
		.s title = Line
		continue:total<=2
		s data=""
		f k=1:1:$length(Line,",") d // excel中单元格里存在英文逗号时，会导致导入的数据串行
		.s code = $p(title,",",k)
		.s value = $p(Line,",",k)
		.s tmpValue = code_$c(1)_value
		.i data=""  s data = tmpValue
		.e  s data = data_$c(2)_tmpValue
		// 将数据处理成 code_$c(1)_value的形式

		s ^TMP("DHCCKB","web.DHCCKBTest","ImportChineseHMKnowDatas",pid,total) = data
		
	}
	d file.%Close()
	
	q ""
}

/// Description:	保存中药饮片说明书信息
/// Creator:		qunianpeng
/// CreateDate:		2021-01-25
/// Input:			filepath：文件路径
/// return:			
/// other:	w ##class(web.DHCCKBTest).ReadChHMDataByFile("D:\临时数据\饮片库修改内容-0914（格式处理）.csv","11863^8^1^291^2","127.0.0.1")
ClassMethod SaveDrugInstructions(rowData, loginInfo, clientIPAddress) As %String
{
	n (rowData,loginInfo,clientIPAddress)
	s userId = $p(loginInfo,"^",1)
	
	s dataObj=..DrugStrToObj(rowData)	// 知识str转换成Obj
	q:dataObj.%Size()=0 ""		// 空对象
	s ret = 0 
	s drugCode = dataObj.%Get("itmCode")	
	s drugDesc = dataObj.%Get("itmDesc")
	s drugCode = $case((drugCode="无")||(drugCode=""),1:drugDesc,:drugCode)
	s parref = ##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片字典id
	q:(drugCode="")||(drugDesc="") -1

	/*判断药品是否存在*/
	s itmDescNew = dataObj.itmDescNew
	s drugId = 0
	i drugCode'=drugDesc s drugId = ##class(web.DHCCKBCommon).GetDicIdByCode(drugCode,parref)
	i drugId = 0 s drugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugDesc,parref)
	i drugId = 0 d 
	.s drugDesc = $replace(drugDesc,"（","(")
	.s drugDesc = $replace(drugDesc,"）",")")
	.s drugId=##class(web.DHCCKBCommon).GetDicIdByDesc(drugDesc,parref)
	i drugId=0 s drugId=##class(web.DHCCKBCommon).GetDicIdByCode(drugDesc,parref)
	i drugId=0 s drugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(itmDescNew,parref)

	i (+drugId'=0) d 	/*药品存在,有停用标志，强制停用(没有处理被引用)*/	
	.i (itmDescNew="停用")  d	
	..s ret = ##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",drugId,"stop",userId,"","","","",clientIPAddress,"log")
	..q:ret'=0
	.e  d 	/*药品存在,没有停用标志，修改数据*/
	..// 修改药品名称
	..s newDrugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),2)
	..s newDrugDesc = $case(itmDescNew'="",1:itmDescNew,:drugDesc)
	..s dataList = drugId _"^"_ newDrugCode _"^"_ newDrugDesc _"^"_ parref _"^"_""	
	..s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dataList,"",loginInfo,clientIPAddress)
	..// 修改说明书
	..s ret = ..SaveDrugInfo(dataObj, drugId,loginInfo, clientIPAddress)
	e  d /*药品不存在,需要新增药品和数据*/	
	.s newDrugCode = $case((drugCode="无")||(drugCode=""),1:drugDesc,:drugCode)
	.s dicStr = ""_"^"_newDrugCode_"^"_drugDesc_"^"_parref_"^"_""		
	.s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dicStr,"",loginInfo,clientIPAddress)	// 保存药品信息
	.q:(ret'=0)&(ret'=-98)&(ret'=-99) // 保存失败
	.s drugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugDesc,parref)	// 药品id
	.q:drugId=0 
	.s ret = ..SaveDrugInfo(dataObj, drugId,loginInfo, clientIPAddress)
	b:ret'=0
	q ret
}

/// 特定格式的字符串转换为对象 		//	通用名$c(1)阿莫西林 [next] 剂型2$c(1) 片剂	
/// w ##class(web.DHCCKBComImport).StrToObj("编码1"_$c(1)_"11111[next]药品商品名1"_$c(1)_"阿莫西林").%ToJSON()
ClassMethod DrugStrToObj(mData, type = "") As %String
{
	n (mData,type)
	
	s spec=$c(2)
	s del=$c(1)
	s len=$length(mData,spec)
	s dataObj={}

	f i=1:1:len	d
	.s tmpData=$p(mData,spec,i)
	.s key=$p(tmpData,del,1)
	.s value=$p(tmpData,del,2)
	.d dataObj.%Set(key,value)
	
	q dataObj
}

/// Description:	保存中药饮片说明书信息
/// Creator:		qunianpeng
/// CreateDate:		2021-01-25
/// Input:			filepath：文件路径
/// return:			
/// other:	w ##class(web.DHCCKBComImport).ReadChHMDataByFile("D:\饮片药嘱系统数据信息整理-标准库1.csv","11863^8^1^291^2","127.0.0.1")
ClassMethod SaveDrugInfo(dataObj, drugId, loginInfo, clientIPAddress) As %String
{
	n (dataObj,drugId,loginInfo,clientIPAddress)
	s err = 0
	set iter = dataObj.%GetIterator()
	while iter.%GetNext(.key, .value) { 
		s isExistFlag = 0
		s value = $replace(value,"（","(")
		s value = $replace(value,"）",")")
		continue:(key="num")||(key="itmCode")||(key="itmDesc")
		continue:(key'="SecondNameNew")&&(key["New")
		continue:(value="")||(value="无")
		set newKey = key_"New"
		if dataObj.%Get(newKey)'="" d //需要更新
		.s value = dataObj.%Get(newKey)
		.s isExistFlag = 1	
		
		if (key["SecondName")  d 
		.s ret = ..SaveSecondData(drugId,value,loginInfo,clientIPAddress,isExistFlag)
		.i ret'=0 s err=err+1
		e  if key["PrescriptionCopeProp"  d 
		.s ret = ..SavePreCopePropData(drugId,value,key,loginInfo,clientIPAddress,isExistFlag)
		.i ret'=0 s err=err+1
		e  d
		.// 直接保存关系
		.s propId = ..GetPropIdByCode(key)
		.i isExistFlag= 1 d	// 对于需要更新的属性，先删除原属性值
		..d ..DeleteLinkPropValue(drugId,propId)
		.		
		.i (key="IsConcoctProp")||(key="IsCostlyProp") d
		..s value=$select(value="0":"否",value="1":"是",1:value)
		.q:value=0
		.s listData = "^"_drugId_"^"_propId_"^^"_value_"^^"
		.s dataType = "text"
		.i (key="DivisionProp")||(key="FunIndicat_L")||(key="RuleUsage_L")||(key="RuleContr_L")||(key="RuleMatNeAt_L") s dataType="textarea"
		.i (key="MedNotifyProp")||(key="ConcoctMethodProp")||(key="FoodContrProp") s dataType="textarea"
		.s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,dataType,loginInfo,clientIPAddress)
		.i ret'=0 s err=err+1		
	}
	
	q err
}

/// 保存别名字典
/// w ##class(web.DHCCKBComImport).SaveSecondData()
ClassMethod SaveSecondData(drugID, str, loginInfo, clientIPAddress, isExistFlag) As %String
{
	n (drugID,str,loginInfo,clientIPAddress,isExistFlag)
	s parref = ##class(web.DHCCKBCommon).GetOtherName()
	s chHMPropId = ##class(web.DHCCKBCommon).GetChinaHMedicineProp()
	s comProp = ##class(web.DHCCKBCommon).GetDicIdByCode("ComProp")
	s otherNameProp = ..GetPropIdByLinkCode("OtherNameProp",chHMPropId,comProp)	//别名属性
	d ..DeleteLinkPropValue(drugID,otherNameProp)	// 对于需要更新的属性，先删除原属性值
		
	s listTitle = "0^"_drugID_"^"_otherNameProp_"^^"
	s listData = ""
	f k =1:1:$length(str,"、")  d
	.s value = $p(str,"、",k)
	.q:value=""
	.q:value="无"
	.//s dicStr = ""_"^"_value_"^"_value_"^"_parref_"^"_""
	.//s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dicStr,"",loginInfo,clientIPAddress)	// 保存别名
	.//q:(ret'=0)&(ret='-98)&(ret'=-99) 
	.//s dicID = ##class(web.DHCCKBCommon).GetDicIdByDesc(value,parref)
	.//q:+dicID=0
	.// 保存关联关系
	.s data = "^"_drugID_"^"_otherNameProp_"^"_value_"^"_"OtherNamePropId^0^"
	.i listData = "" s listData = data
	.e  s listData = listData_"&&"_data

	s listData = listTitle_"&&"_listData
	//b //别名
	s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"datagrid",loginInfo,clientIPAddress)

	q ret
}

ClassMethod GetPropIdByLinkCode(key, parref, linkParref) As %String
{
	n (key,parref,linkParref)
	s linkPropId = ##class(web.DHCCKBCommon).GetDicIdByCode(key,linkParref)	// 原本所在的位置
	q:+linkPropId=0 0
	s id = "",exitFlag=0,propId=0
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Link",linkPropId,id))  q:(id="")||(exitFlag=1)  d
	.q:+id=0
	.i $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)=parref s exitFlag=1
	.s propId=id
	
	q propId
}

/// 获取属性代码
/// w ##class(web.DHCCKBTest).GetPropIdByCode("PrescriptionCopeProp")
ClassMethod GetPropIdByCode(key) As %String
{
	n (key)
	s chHMPropId = ##class(web.DHCCKBCommon).GetChinaHMedicineProp()
	s propId = 0
	i key["_L" d	// 在药品目录下找属性id
	.s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	.s propId=..GetPropIdByLinkCode($p(key,"_L",1),chHMPropId,drugLibaryData) 

	q:propId'=0 propId
	//1. 优先在中药饮片属性下找,找不到在西药属性下找
	s propId = ##class(web.DHCCKBCommon).GetDicIdByCode(key,chHMPropId)	
	s drugProp = ##class(web.DHCCKBCommon).GetDrugProp()
	i +propId=0  s propId=..GetPropIdByLinkCode(key,chHMPropId,drugProp) 
	
	q propId
}

ClassMethod DeleteLinkPropValue(drugId, propId)
{
	n (drugId,propId)
	
	&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:drugId and DLA_AttrCode=:propId)
	
	q SQLCODE
}

/// 保存处方应付字典
/// w ##class(web.DHCCKBComImport).SaveSecondData()
ClassMethod SavePreCopePropData(drugID, str, key, loginInfo, clientIPAddress, isExistFlag) As %String
{
	n (drugID,str,key,loginInfo,clientIPAddress,isExistFlag)
	s propId = ##class(web.DHCCKBTest).GetPropIdByCode(key)
	q:+propId=0 ""
	s parref = ##class(web.DHCCKBCommon).PrescriptionCopeData()
	d ..DeleteLinkPropValue(drugID,propId)	// 对于需要更新的属性，先删除原属性值
	s ret = 0
	s listTitle = "0^"_drugID_"^"_propId_"^^"
	s listData = ""
	f k =1:1:$length(str,"、")  d
	.s value = $p(str,"、",k)
	.q:value=""
	.q:value="无"
	.s dicStr = ""_"^"_value_"^"_value_"^"_parref_"^"_""
	.s ret = ##class(web.DHCCKBDiction).SaveUpdateNew(dicStr,"",loginInfo,clientIPAddress)	// 保存别名
	.q:(ret'=0)&(ret'=-98)&(ret'=-99) 
	.s dicID = ##class(web.DHCCKBCommon).GetDicIdByDesc(value,parref)
	.q:+dicID=0
	.// 保存关联关系
	.s data = "^"_drugID_"^"_propId_"^"_dicID_"^"_"PrescriptionCopeProp"_"^0^"
	.i listData = "" s listData = data
	.e  s listData = listData_"&&"_data
	q:listData="" ""
	s listData = listTitle_"&&"_listData
	s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"datagrid",loginInfo,clientIPAddress)
	q ret
}

/// Other:	w ##class(web.DHCCKBTest).testrule()
ClassMethod testrule()
{
	s rule = ""
	f  s rule=$o(^CT.CKB.PDSS.RuleD(rule))  q:rule=""  d
	.q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",rule))
	.s existFlag = 0
	.s dicID=""
	.f  s dicID=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dicID)) q:(dicID="")||(existFlag=1)  d
	..s rulediciD="" 
	..f  s rulediciD=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,rulediciD))  q:(rulediciD="")||(existFlag=1)  d 
	...q:$d(^CT.CKB.PDSS.RuleDicD(rulediciD))
	...s existFlag = 1
	.
	.i existFlag=1 d 
	..w rule,!
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-02
/// Description:： 	批量取消发布导入的溶媒规则
/// Input:
/// Other:	w ##class(web.DHCCKBTest).CleanSolventRule("11871^8^1^289^2")
ClassMethod CleanSolventRule(loginInfo)
{
	n (loginInfo)

	s dicID = ##class(web.DHCCKBCommon).GetDicIdByDesc("液体配置")	// 液体配置
	q:dicID="" ""
	
	s successCount = 0, errCount = 0
	s ruleDic = ""
	f  s ruleDic = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDic))  q:ruleDic=""  d
	.s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDic)),2)
	.q:+rule=0
	.q:'$d(^CT.CKB.PDSS.RuleD(rule))
	.s rmark = $lg($g(^CT.CKB.PDSS.RuleD(rule)),2)
	.q:rmark'="(溶媒导入)"
	.//s ^TmpQnpClean(rule) = ""
	.s ret=##class(web.DHCCKBRuleSave).ReleaseStatus(rule,loginInfo,"CancelRelease")
	.i ret=0 s successCount = successCount + 1
	.i ret'=0 s errCount = errCount + 1

	q "共处理规则:"_(successCount+errCount)_"条。"_"成功:"_successCount_"条。"_"失败:"_errCount_"条。"
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-04
/// Description:： 	重新生成溶媒溶液规则
/// Input:	 		// 规则备注写(重新生成)
/// Other:	w ##class(web.DHCCKBTest).SetSolventRule("11877^6^1^289^2")
ClassMethod SetSolventRule(loginInfo)
{

	//遍历属于南溪山的溶媒溶液规则
	
	//判断规则是否修改过,修改过则不动,
	//1未修改的则判断规则是否从分词工具拆分,如果是,则删除,生成新规则。并记录新和旧的id
	//2未修改的则判断规则是否从规则编辑中复制而来,则从1的记录中找到新的id,重新生成。并删除之前的复制记录
	n (loginInfo)
	
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()
	s hostital = 115
	s liquidConfigID = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")	// 液体配置
	
	s result = ##class(%Library.ResultSet).%New()	
	
	s sqlStr = "SELECT RD_Rule,RD_Dic,RD_DicParent FROM CT_CKB_PDSS.RuleDic WHERE  RD_Rule IN ("

	s sqlStr = sqlStr_"	SELECT RD_Rule FROM CT_CKB_PDSS.RuleDic WHERE RD_Dic IN ( "
	
	s sqlStr = sqlStr_"		SELECT CD_RowID FROM CT_CKB_PDSS.CommonDiction WHERE CD_Code IN ("
	s sqlStr = sqlStr_" 		SELECT CC_LibCode FROM CKB_PDSS.ComContrast WHERE CC_DicType="_drugData_"AND CC_Hospital="_hostital
	s sqlStr = sqlStr_"		)"
	s sqlStr = sqlStr_"	)"

	s sqlStr = sqlStr_") AND RD_Dic="_liquidConfigID
	
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0,deleteCount = 0
	While(result.Next())
	{	
		s rule = result.Data("RD_Rule")
		s labelID = result.Data("RD_Dic")
		s labelParref = result.Data("RD_DicParent")
		s tmp=rule_"^"_labelID_"^"_labelParref	
		s ruleLog = $o(^CKB.PDSS.RuleLogI("Rule",rule,""),-1)	
		s userId = $lg(^CKB.PDSS.RuleLogD(+ruleLog),3)
		i userId'="" s $p(loginInfo,"^",1)=userId
		//continue:rule'=336329
		// 判断规则是否修改过,修改过则不动
		s flag = ##class(web.DHCCKBCommon).IsRuleUpdateFlag(rule)
		continue:flag=1
		// 获取规则来源
		s ruleSource = ..GetRuleSource(rule)
		i ruleSource ["autoTool"  d	//删除,生成新规则。并记录新和旧的id		
		.s groupId = $p(ruleSource,"^",2)
		.s ruleObj = ##class(web.DHCCKBRule).SubmitRule(groupId,loginInfo) // 规则备注写(重新生成) //{"code":"success","content":"","total":1,"successNum":2,"errNum":0,"msg":"","rule":"295532"}		
		.s tmpObj = ##class(DHCNewPro.COM.Object).%New()
		.s ruleObj = tmpObj.FromJSON(ruleObj)
		.s newRule = ruleObj.rule
		.q:newRule=""
		.s ^TmpSetSolventRule(rule,newRule)="" //// 记录删除的规则
		.s count = count + 1 
		.s ret = ##class(web.DHCCKBRuleSave).RemoveRule(rule) //删除规则
				
		e  i ruleSource [ "ruleCopy"  d //则从1的记录中找到新的id,重新生成。并删除之前的复制记录
		.s sourceId = $p(ruleSource,"^",2) // 获取源id
		.i $d(^TmpSetSolventRule(sourceId))  d	// 判断源id是否存在, 不存在,则去记录删除的规则中找
		..s newSourceId = $o(^TmpSetSolventRule(sourceId,""))
		.e  d
		..s newSourceId = sourceId
		.q:(newSourceId="")||('$d(^CT.CKB.PDSS.RuleD(newSourceId))) // 找不到源id的情况下,则不删除
		.s dicID = ..GetDicIDByRule(rule)
		.s newDicID = dicID //  // 规则备注写(重新生成)
		.s newRule = ##class(web.DHCCKBDrugDetail).SaveSingleRules(dicID, newDicID, userId, loginInfo, rule, loginInfo)	// 复制新的规则 
		.s ret = ##class(web.DHCCKBRuleSave).RemoveRule(rule) //删除规则
		
		.s count = count + 1 
	}

	w "count"_count,!
	Q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-04
/// Description:： 	获取规则的复制来源(规则编辑器复制,规则管理复制,分词工具
/// Input:
/// Other:	w ##class(web.DHCCKBTest).GetRuleSource(336306)
ClassMethod GetRuleSource(rule)
{
	n (rule)
	q:rule="" ""
	s ruleSource = ""
	
	// ^DHCCKBRULEMAINTAIN(0,"Rule",{RM_GroupNo} 增加索引
	i $d(^DHCCKBRULEMAINTAIN(0,"Rule",rule))  d
	.s groupNo = $o(^DHCCKBRULEMAINTAIN(0,"Rule",rule,""))
	.s ruleSource="autoTool"_"^"_groupNo
	
	// ^CKB.PDSS.RuleCopyLogI("RulePurpose") 增加索引
	i $d(^CKB.PDSS.RuleCopyLogI("RulePurpose",rule)) d //
	.s sourceId = $o(^CKB.PDSS.RuleCopyLogI("RulePurpose",rule,""))
	.s ruleSource="ruleCopy"_"^"_sourceId
	
	q ruleSource
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-04
/// Description:： 	使用规则id获取药品id
/// Input:			规则序号
/// Other:	w ##class(web.DHCCKBTest).GetDicIDByRule()
ClassMethod GetDicIDByRule(rule)
{
	n (rule)

	s drugData = ##class(web.DHCCKBCommon).GetDrugData()

	s ruleDicID =  $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,drugData,""))
	s dicID = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicID)),3)
	
	q dicID
}

/// Descript:	导出没有溶媒规则的药品(哈医大、蚌埠一院、南溪山、包医二院)
/// CreateDate:	2020-07-16
/// Creator:	sufan
/// w ##Class(websys.Query).ToExcel("没有溶媒规则的药品new","web.DHCCKBTest","ExportNotSolventDrug","94^106^114^115")
Query ExportNotSolventDrug(hospList) As websys.Query(ROWSPEC = "libCode:%String:系统编码,libDesc:%String:系统描述,hisCode:%String:医院药品编码,hisDesc:%String:医院药品名称,hosp:%String:医院,drugType:%String:药品类型")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBTest","ExportNotSolventDrug","94^106^114^115") 
ClassMethod ExportNotSolventDrugExecute(ByRef qHandle As %Binary, hospList) As %Status
{
	n (qHandle,hospList)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	
	d ..GetNotSolventDrug(.TmpArr,hospList)
	
	set index   =""
	for  set index = $o(TmpArr(index)) quit:index=""  do
	.set listData = $get(TmpArr(index))
	.set ^CacheTemp(repid,ind) = listData
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-04
/// Description:： 	没有溶媒规则的药品(哈医大、蚌埠一院、南溪山、包医二院)
/// Input:			药品列表
/// Other:	w ##class(web.DHCCKBTest).GetNotSolventDrug(hospList)
ClassMethod GetNotSolventDrug(TmpArr, hospList)
{
	n (TmpArr,hospList)
	s hospList = $lfs(hospList,"^")
	s count = 0
	
	s drugTypeList = "105,81790"
	f i=1:1:$L(drugTypeList,",")  d
	.s parref= $p(drugTypeList,",",i)
	.s dicID = ""
	.f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	..//DLA_AttrCode= 40 AND DLA_Attr_Dr IN (81287,4304)
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,40,4304))&&('$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,40,81287))) // 剂型 粉针剂 冻干粉针剂
	..s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	..s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	..s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	..q:libCode=""||(libDesc="")
	..// 判断是否有溶媒规则
	..q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",dicID))
	..s solvetFlag = 0
	..s ruleDic = ""
	..f   s ruleDic = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDic),-1)  q:(ruleDic="")||(solvetFlag=1)  d
	...s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDic)),2)
	...i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,91228)) s solvetFlag=1	 //有溶媒规则
	..
	..q:solvetFlag=1
	..s hisCode = ""
	..f  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(libCode),hisCode))  q:hisCode=""  d
	...s constID = ""
	...f  s constID = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(libCode),$$UPPER^SSUTIL4(hisCode),constID)) q:constID=""  d
	....s listData =$g(^CKB.PDSS.ComContrastD(constID))
	....s hospId = $lg(listData,7)
	....q:$lf(hospList,hospId)=0

	....s hisDesc = $lg(listData,5)
	....s hospDesc = $p(^CT("HOSP",hospId),"^",2)
	....s count = count + 1
	....s TmpArr(count) = $lb(libCode,libDesc,hisCode,hisDesc,hospDesc,parrefDesc)
	

	q ""
	
	
	// 找出药品列表
	f i=1:1:$l(hospList,"^")  d
	.s hospId = $p(hospList,"^",i)
	.s hospDesc = $p(^CT("HOSP",hospId),"^",2)
	.s libDesc = ""
	.f  s libDesc = $o(^CKB.PDSS.ComContrastI("CCHospital",$$UPPER^SSUTIL4(libDesc)))  q:libDesc=""  d	
	..q:libDesc=-100000000000000
	..s hisDesc = ""
	..f  s hisDesc = $o(^CKB.PDSS.ComContrastI("CCHospital",$$UPPER^SSUTIL4(libDesc),hisDesc)) q:hisDesc=""  d
	...q:'$d(^CKB.PDSS.ComContrastI("CCHospital",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc),hospId))
	...s libId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,105)
	...s:libId="" libId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,81790)
	...q:libId=""
	...s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libId)),2)
	...// 判断是否有溶媒规则
	...q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",libId))
	...s solvetFlag = 0
	...s ruleDic = ""
	...f   s ruleDic = $o(^CT.CKB.PDSS.RuleDicI("Dic",libId,ruleDic),-1)  q:(ruleDic="")||(solvetFlag=1)  d
	....s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDic)),2)
	....i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,91228)) s solvetFlag=1
	...
	...q:solvetFlag=1
	...s drugType = $lg($g(^CT.CKB.PDSS.CommonDictionD(libId)),4)
	...s drugType = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugType)),3)
	...s count = count + 1
	...b:libDesc="复方甲氧那明胶囊(上海上药信谊药厂有限公司)"
	...s TmpArr(count) = $lb(libCode,libDesc,hisDesc,hospDesc,drugType)
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-09
/// Description:： 	按照剂型 统计用药指导的规则（已拆分用药指导药品数量、已拆分用药指导的规则数量、未拆分用药指导数量）
/// Input:			
/// Other:	w ##class(web.DHCCKBTest).GetAdviceRuleNum()
/// 导出与适应症不明确列相关内容
Query ExportGetAdviceRuleNumByForm() As websys.Query(ROWSPEC = "f0:%String:项目,f1:%String:药品数量,f2:%String:有用药指导规则药品数量,f3:%String:无用药指导规则药品数量,f4:%String:用药指导规则数量")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBTest","ExportGetAdviceRuleNumByForm") 
/// w ##Class(websys.Query).ToExcel("剂型-用药规则统计","web.DHCCKBTest","ExportGetAdviceRuleNumByForm")
ClassMethod ExportGetAdviceRuleNumByFormExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1


	s drugList = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	
	f i=1:1:$ll(drugList)  d
	.s code = $lg(drugList,i)
	.s drugDataId = ##class(web.DHCCKBCommon).GetDicIdByCode(code)
	.s drugId = ""
	.f  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,drugId))  q:drugId=""  d
	..s form = $lg(##Class(web.DHCCKBCommon).GetProValueListByDrug(drugId,"FormProp","0"))	// 剂型
	..i form="" s form = "空"
	..s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	..s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..s adviceNum = ..CheckAdviceRuleFlag(drugId)	
	..s TmpArr("sumAdviceNum") = $g(TmpArr("sumAdviceNum")) + adviceNum	// 用药指导规则总数量
	..s TmpArr("sumDrugNum") = $g(TmpArr("sumDrugNum")) + 1				// 药品总数		
	..s TmpArr("form",form) = $g(TmpArr("form",form)) + 1			// 按照剂型统计药品		
	..i adviceNum>0  d						
	...s TmpArr("sumHaveAdviceNum") = $g(TmpArr("sumHaveAdviceNum")) + 1	// 已经拆分用药指导规则数量	
	...s TmpArr("form",form,"have") = $g(TmpArr("form",form,"have")) + 1 		 // 剂型中有用药指导规则的药品
	...s TmpArr("form",form,"form") = $g(TmpArr("form",form,"form")) + adviceNum // 剂型中用药指导规则

	s form = ""
	f  s form = $o(TmpArr("form",form))  q:form=""  d
	.s formDrug = +$g(TmpArr("form",form))				// 剂型药品数量
	.s formHaveDrug = +$g(TmpArr("form",form,"have"))	// 剂型中有规则药品数量
	.s formNotHaveDrug = +(formDrug-$g(TmpArr("form",form,"have")))
	.s formRule = +$g(TmpArr("form",form,"form"))
	.s dataList = $lb(form,formDrug,formHaveDrug,formNotHaveDrug,formRule)
	.s ^CacheTemp(repid,ind)=dataList
	.s ind=ind+1	
	
	// 合计
	s outList = ""
	s $list(outList,*+1) = "合计"
	s $list(outList,*+1) = +$g(TmpArr("sumDrugNum"))
	s $list(outList,*+1) = +$g(TmpArr("sumHaveAdviceNum"))
	s $list(outList,*+1) = +$g(TmpArr("sumDrugNum")) - $g(TmpArr("sumHaveAdviceNum"))
	s $list(outList,*+1) = +$g(TmpArr("sumAdviceNum"))
	s ^CacheTemp(repid,ind)=outList
	s ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-09
/// Description:： 	按照剂型 统计用药指导的规则（已拆分用药指导药品数量、已拆分用药指导的规则数量、未拆分用药指导数量）
/// Input:			
/// Other:	w ##class(web.DHCCKBTest).GetAdviceRuleNum()
ClassMethod GetAdviceRuleNumByForm()
{
	
	s drugList = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	
	f i=1:1:$ll(drugList)  d
	.s code = $lg(drugList,i)
	.s drugDataId = ##class(web.DHCCKBCommon).GetDicIdByCode(code)
	.s drugId = ""
	.f  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,drugId))  q:drugId=""  d
	..s form = $lg(##Class(web.DHCCKBCommon).GetProValueListByDrug(drugId,"FormProp","0"))	// 剂型
	..i form="" s form = "空"
	..s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	..s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..s adviceNum = ..CheckAdviceRuleFlag(drugId)	
	..s TmpArr("sumAdviceNum") = $g(TmpArr("sumAdviceNum")) + adviceNum	// 用药指导规则总数量
	..s TmpArr("sumDrugNum") = $g(TmpArr("sumDrugNum")) + 1				// 药品总数		
	
	..s TmpArr("form",form) = $g(TmpArr("form",form)) + 1			// 按照剂型统计药品		
	
	..i adviceNum>0  d						
	...s TmpArr("sumHaveAdviceNum") = $g(TmpArr("sumHaveAdviceNum")) + 1	// 已经拆分用药指导规则数量	
	...s TmpArr("form",form,"have") = $g(TmpArr("form",form,"have")) + 1 		 // 剂型中有用药指导规则的药品
	...s TmpArr("form",form,"form") = $g(TmpArr("form",form,"form")) + adviceNum // 剂型中用药指导规则

	
	s form = ""
	f  s form = $o(TmpArr("form",form))  q:form=""  d
	.s formDrug = $g(TmpArr("form",form))				// 剂型药品数量
	.s formHaveDrug = $g(TmpArr("form",form,"have"))	// 剂型中有规则药品数量
	.s formNotHaveDrug = formDrug-$g(TmpArr("form",form,"have"))
	.s formRule = $g(TmpArr("form",form,"form"))
	.s dataList = $lb(formDrug,formHaveDrug,formNotHaveDrug,formRule)

	s outList = ""
	s $list(outList,*+1) = $g(TmpArr("sumDrugNum"))
	s $list(outList,*+1) = $g(mpArr("sumHaveAdviceNum"))
	s $list(outList,*+1) = $g(TmpArr("sumDrugNum")) - $g(mpArr("sumHaveAdviceNum"))
	s $list(outList,*+1) = $g(TmpArr("sumAdviceNum"))
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-09
/// Description:： 	判断药品是否有用药指导规则
/// Input:			大于0 有 0 没有
/// Other:	w ##class(web.DHCCKBTest).GetAdviceRuleNum()
ClassMethod CheckAdviceRuleFlag(drugId)
{
	n (drugId)
	q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) 0
	
	s adviceId = ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")
	s ret = 0
	s adviceList=""
	s $list(adviceList,*+1)=adviceId
	d ..GetChildDic(adviceId,.adviceList)
	
	s ruleDic = ""
	f  s ruleDic = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDic))  q:ruleDic=""  d
	.s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDic)),2)
	.f i=1:1:$ll(adviceList)  d
	..s tmpAdvice = $lg(adviceList,i)
	..q:tmpAdvice=0
	..i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,tmpAdvice))  d
	...s ret = ret + 1	
	
	q ret
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-09
/// Description:： 	统计用药指导的规则数量
/// Input:			
/// Other:	w ##class(web.DHCCKBTest).GetAdviceRuleNum()
ClassMethod GetAdviceRuleNum()
{
	s adviceId = ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")	
	s adviceList=""
	s $list(adviceList,*+1)=adviceId
	d ..GetChildDic(adviceId,.adviceList)
	
	s ruleList = ""
	f i=1:1:$ll(adviceList)  d
	.s tmpAdvice = $lg(adviceList,i)
	.s ruleDicID = "" 
	.f  s ruleDicID = $o(^CT.CKB.PDSS.RuleDicI("ParentDic",tmpAdvice,ruleDicID))  q:ruleDicID=""  d
	..s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..i $lf(ruleList,rule)=0  d
	...s $list(ruleList,*+1)=rule
	
	
	q $ll(ruleList)
}

ClassMethod GetChildDic(parref, adviceList)
{
	n (parref,adviceList)
	q:parref="" ""
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",parref)) "" 
	
	s id = ""
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id))  q:id=""  d
	.i $lf(adviceList,id)=0 d
	..s $list(adviceList,*+1)=id
	.
	.d ..GetChildDic(id,.adviceList)
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-17
/// Description:： 	中药饮片国家医保编码导入
/// Input:
/// Other:	w ##class(web.DHCCKBTest).ImportChinaCode("D:\国家编码-匹配结果20220215.txt","11871^8^1^289^2","113.140.81.66")
ClassMethod ImportChinaCode(filepath As %String, loginInfo, clientIP) As %String
{

	n (filepath,loginInfo,clientIP)
	
	d ..killStand()	// 清除所有的执行标准
	
	
	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	s allergy=""
	s title=""
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1	
	.q:hCount=1
	.s ^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCode",pid,hCount) = impDataList
	
	c filepath 
	b //1
	
	s chinaData = ##class(web.DHCCKBCommon).GetChineseHMData()	// 中药饮片字典id
	
	s total = hCount-1
	
	s count = 0,success = 0,flag = 0
	f   s count = $o(^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCode",pid,count)) q:count=""  d
	.s data = $g(^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCode",pid,count))
	.q:data=""
	.s newCode = $p(data,"^",1)	// 国家医保编码
	.s hisDrugName = $p(data,"^",2)
	.s sysDrugCode = $p(data,"^",4)	// 知识库编码
	.s sysDrugDesc = $p(data,"^",5)	// 知识库名称
	.s hisFactoy = $p(data,"^",3)	// 标准
	.s sysDrugId = ##class(web.DHCCKBCommon).GetDicIDByCodeAndDesc(sysDrugCode,sysDrugDesc,chinaData)
	.i +sysDrugId=0 d
	..s ^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCodeErr",newCode) = newCode_"^"_hisDrugName_"^"_"系统对照数据错误"
	..s flag=1
	.q:+sysDrugId=0
	.// 增加国家医保编码
	.s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("NationalSICode")
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",sysDrugId,propId)) d	// 已经存在
	..s linkattr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",sysDrugId,propId,""))
	..s oldValue = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkattr)),5)
	..s value = ..GetStandList(oldValue,newCode)
	..//s value = $case(oldValue="",1:newCode,:oldValue_"、"_newCode)
	..&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:value where DLA_RowID=:linkattr)
	..i SQLCODE'=0 d
	...s ^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCodeErr",newCode) = newCode_"^"_hisDrugName_"^"_"医保编码更新数据错误"_SQLCODE
	...s flag=1
	.e  d	// 新增
	..s listData = "^"_sysDrugId_"^"_propId_"^^"_newCode_"^^"
	..s dataType = "text"
	..//s dataType="textarea"
	..s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,dataType,loginInfo,clientIP)
	..i ret'=0 d
	...s ^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCodeErr",newCode) = newCode_"^"_hisDrugName_"^"_"医保编码保存数据错误"_SQLCODE
	...s flag=1
	.
	.// 更新标准
	.s standPropId = 114579
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",sysDrugId,standPropId)) d	// 已经存在
	..s linkattr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",sysDrugId,standPropId,""))
	..s oldValue = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkattr)),5)
	..s newStand = ..GetStandList(oldValue,hisFactoy)
	..s value = newStand
	..&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:value where DLA_RowID=:linkattr)
	..i SQLCODE'=0 d
	...s ^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCodeErr",newCode) = newCode_"^"_hisDrugName_"^"_"标准更新数据错误"_SQLCODE
	...s flag=1
	.e  d	// 新增
	..s listData = "^"_sysDrugId_"^"_standPropId_"^^"_hisFactoy_"^^"
	..s dataType = "text"
	..//s dataType="textarea"
	..s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,dataType,loginInfo,clientIP)
	..i ret'=0 d
	...s ^TMP("DHCCKB","web.DHCCKBTest","ImportChinaCodeErr",newCode) = newCode_"^"_hisDrugName_"^"_"标准保存数据错误"_SQLCODE
	...s flag=1
	.
	.i flag=0 s success = success + 1
	
	w "总计:"_total_"条数据，成功导入:"_success_"条数据"	
	
	quit ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-17
/// Description:： 	清除中药饮片所有的执行标准
/// Input:
ClassMethod killStand()
{
	s chinaData = ##class(web.DHCCKBCommon).GetChineseHMData()	// 中药饮片字典id
	s standPropId = 114579
	s code = 134794
	
	s id = ""
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",chinaData,id)) q:id=""  d
	.&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:id and DLA_AttrCode=:standPropId)
	.&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:id and DLA_AttrCode=:code)


	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-17
/// Description:： 	执行标准去重处理
/// Input:
ClassMethod GetStandList(oldValue, newValue)
{
	n (oldValue,newValue)
	
	s retList = ""
	s oldValue = oldValue_"、"_newValue
	s oldValue = $listfromstring(oldValue,"、")
	f i=1:1:$ll(oldValue) d
	.s value = $lg(oldValue,i)
	.q:$lf(retList,value)'=0
	.s $list(retList,*+1) = value
	
	q $lts(retList,"、")
}

/// Creator:		qunianpeng
/// CreatDate:		2022-02-17
/// Description:： 	移动hisICD诊断到知识库的ICD字典下
/// Input:	w ##class(web.DHCCKBTest).MoveHisICDToSys()
ClassMethod MoveHisICDToSys(lgInfo, clientIP)
{
	// 记录系统的ICD诊断字典中的数据，等待移动后，将这部分数据移动到icd诊断树的其他分类下
	d ..MarkSysICD()
	
	// 获取数据	
	d ..GetData()

	// 存储数据
	d ..SaveICDToSys(lgInfo,clientIP)
	
	// 更新分类
	d ##class(web.DHCCKBTest).UpdateICD()
	
	// 更新记录的系统的ICD诊断字典中的数据指向：icd诊断树的其他分类下
	d ..UpdateOtherICD()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-03-02
/// Description: 	记录系统的ICD诊断字典中的数据，等待移动后，将这部分数据移动到icd诊断树的其他分类下
/// Input:			w ##class(web.DHCCKBTest).MarkSysICD()
ClassMethod MarkSysICD()
{
	
	s parref = ##class(web.DHCCKBCommon).GetDicIdByCode("ICDDiagData")
	
	s id = ""
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id))  q:id=""  d
	.s ^TmpDHCCKBMarkSysICD(id) = ""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-03-02
/// Description: 	获取hisICD诊断的数据
/// Input:  w ##class(web.DHCCKBTest).GetData()
ClassMethod GetData()
{
	
	s hosp = "-100000000000000"	
	s type = "DiseaseData"
	s rootData = $o(^CKB.PDSS.ExtDictionI("SearchCode",type,""))
	s count = 0
	s extID=""
	f  s extID = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,extID))  q:extID=""   d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extID))
	.s extCode = $lg(extData,2)
	.s extDesc = $lg(extData,3)
	.q:extCode="DiseaseData"
	.s parref = $lg(extData,6)
	.i parref=rootData s parref=""
	.s count = count + 1	
	.s ^TmpDHCCKBMoveICDArr("data",extID) = $lb(extCode,extDesc,parref)
	
	s ^TmpDHCCKBMoveICDArr("count",count) = ""
	w count,!
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-03-02
/// Description: 	保存his诊断到知识库icd诊断字典
/// Input:			w ##class(web.DHCCKBTest).SaveICDToSys("11871^8^1^289^2","221.226.32.66")
ClassMethod SaveICDToSys(lgInfo, clientIP)
{
	n (lgInfo,clientIP)
	k ^TMPDHCCKBMarkICD
	s index = ""
	f  s index = $o(^TmpDHCCKBMoveICDArr("data",index))  q:index=""  d
	.s data = $g(^TmpDHCCKBMoveICDArr("data",index))
	.s code = $list(data,1)
	.s desc = $list(data,2)
	.s parref = $List(data,3)
	.//i parref="" s parref=##class(web.DHCCKBCommon).GetDicIdByCode("ICDDiagData")
	.d ..SaveParrefNew(index,"^"_code_"^"_desc_"^"_parref,lgInfo,clientIP)
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-03-02
/// Description:： 	获取知识库icd字典中的诊断id
/// Input:
ClassMethod SaveParrefNew(index, data, lgInfo, clientIP)
{
	n (index,data,lgInfo,clientIP)
	
	s lgUserID = $p(lgInfo,"^",1)
	s lgHospID = $p(lgInfo,"^",5)
	
	s ^TMPDHCCKBMarkICD(index)=""
	
	s id =  ##class(web.DHCCKBDiction).SaveDic(data)
	
	s ^TMPDHCCKBMarkICD("new",id,index)="" 
	s ^TMPDHCCKBMarkICD("old",index,id)="" 
	
	s ret=##class(web.DHCCKBWriteLog).SaveDicLog(id,lgUserID,lgHospID,"add",clientIP) // ret是SQLCODE
	
	s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", id, "grantAuth", lgUserID, "", "", "D", lgHospID, clientIP,"acc")
		
	
	q id
}

/// Creator:		qunianpeng
/// CreatDate:		2022-03-02
/// Description:： 	获取知识库icd字典中的诊断id
/// Input: 	w ##class(web.DHCCKBTest).UpdateICD()
ClassMethod UpdateICD()
{
	s count = 0
	s id = ""
	f  s id = $o(^TMPDHCCKBMarkICD("new",id)) q:id=""  d
	.s oldParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.i oldParref="" s newParref=##class(web.DHCCKBCommon).GetDicIdByCode("ICDDiagData")
	.e  s newParref = $o(^TMPDHCCKBMarkICD("old",oldParref,""))
	.&sql(update CT_CKB_PDSS.CommonDiction set CD_Parref_Dr=:newParref where CD_RowID=:id )
	.s count=count+1	
	
	q count
}

/// Creator:		qunianpeng
/// CreatDate:		2022-03-02
/// Description: 	记录系统的ICD诊断字典中的数据，等待移动后，将这部分数据移动到icd诊断树的其他分类下
/// Input:	w ##class(web.DHCCKBTest).UpdateOtherICD()
ClassMethod UpdateOtherICD()
{
	
	s parref = ##class(web.DHCCKBCommon).GetDicIdByCode("ICDDiagData")
	s newParref = ##class(web.DHCCKBCommon).GetDicIdByCode("其他类",parref)
	s id = ""
	f  s id = $o(^TmpDHCCKBMarkSysICD(id))  q:id=""  d
	.q:id=""
	.&sql(update CT_CKB_PDSS.CommonDiction set CD_Parref_Dr=:newParref where CD_RowID=:id )
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-05-19
/// Description: 	修改禁忌症中特殊人群=“哺乳期”，并且 级别=“禁止”，的这部分，降级为警示
/// 					修改禁忌症中特殊人群=“过敏体质”，级别为提示 (需要执行两次,并切换注释部分的代码)
/// Input:	w ##class(web.DHCCKBTest).UpdateContrRuleLevel()
ClassMethod UpdateContrRuleLevel()
{

	s tmpId = ##class(web.DHCCKBCommon).GetDicIdByCode("哺乳期")
	s contrId =  ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")	// 禁忌症目录
	s RuleContrTwoId =  ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContrTwo")	// 禁忌目录 
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s levelFlagId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")	// 管理级别id
	s warnId = ##class(web.DHCCKBCommon).GetDicIdByCode("warn")	// 管理级别id
	s forbidId = ##class(web.DHCCKBCommon).GetDicIdByCode("forbid")	// 禁止-管理级别id
	
	s allergyId = ##class(web.DHCCKBCommon).GetDicIdByCode("过敏体质者")
	s allergy1Id = ##class(web.DHCCKBCommon).GetDicIdByCode("过敏体质")
	s allergy2Id = ##class(web.DHCCKBCommon).GetDicIdByCode("高过敏体质")
	s allergy3Id = ##class(web.DHCCKBCommon).GetDicIdByCode("过敏体质患者")
	s allergyList = $lb(allergyId,allergy1Id,allergy2Id,allergy3Id)
	s normalId = ##class(web.DHCCKBCommon).GetDicIdByCode("normal")	// 提示-管理级别id
		
				
	s ruleCount = 0
	s drugId = ""
	f  s drugId = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId))  q:drugId=""   d
	.//q:drugId'=81646
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	.q:+parref=0
	.q:(parref'=drugData)&&(parref'=chineseDrugData)	// 只找西药和中药的
	.s rule = ""
	.f  s rule = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,RuleContrTwoId,rule)) q:rule=""  d
	..s markIDList = "", isExistFlag = 0
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..//q:ruleStauts'="Release"
	..s ruleDataID=""
	..f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataID))  q:(ruleDataID="")   d
	...q:ruleDataID=0
	...q:'$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID))
	...s opairth = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),7)
	...s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),8)
	...i (rightDic=tmpId)&&(opairth="Equals") s isExistFlag = 1	// 存在特殊人群等于哺乳期的规则
	...//i ($lf(allergyList,rightDic)'=0)&&(opairth="Equals") s isExistFlag = 1	// 存在特殊人群等于过敏体质的规则
	...s prop = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)
	...i levelFlagId=prop d
	....i $lf(markIDList,ruleDataID)=0 s $List(markIDList,*+1) = ruleDataID	
	..
	..
	..i isExistFlag=1 d
	...f k=1:1:$ll(markIDList)  d
	....s markID = $lg(markIDList,k)
	....s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+markID)),8)
	....q:rightDic'=forbidId
	....&sql(update CT_CKB_PDSS.RuleData set RD_RightDic=:warnId where RD_RowID=:markID)
	....//&sql(update CT_CKB_PDSS.RuleData set RD_RightDic=:normalId where RD_RowID=:markID)
	....s ruleCount=ruleCount+1
	
	q "修改:"_ruleCount_"条规则"
}

/// Creator:      qunianpeng
/// CreatDate:    2022-05-23
/// Description:  审核输出消息整理
/// Input:		 
/// Other:        药品a:相互作用(警示):消息,禁忌症(警示):消息;药品b:用法用量(警示):消息,重复用药(警示):消息;
/// w ##Class(web.DHCCKBTest).ExportAllMsg()
ClassMethod ExportAllMsg()
{
	s date = $lb("66252","66253")
	f num=1:1:$ll(date)  d
	.s stDate=$lg(date,num)
	.s endDate = stDate+1
	.w ##Class(websys.Query).ToExcel("禁止级别处方导出"_stDate,"web.DHCCKBTest","ExportForbidMsg",stDate,endDate)
	
	q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2022-05-23
/// Description:  导出	导出上线以前合理用药模块拦截的信息,患者登记号、姓名、诊断、医嘱信息、拦截信息
/// Input:		 
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBTest","ExportForbidMsg")
/// w ##Class(websys.Query).ToExcel("禁止级别处方导出2022-05-23","web.DHCCKBTest","ExportForbidMsg")
Query ExportForbidMsg(stDate, endDate) As websys.Query(ROWSPEC = "num:%String:序号,patNo:%String:登记号,patName:%String:姓名,patSex:%String:性别,patAge:%String:年龄,patDis:%String:诊断,drugName:%String:药品名称,formProp:%String:剂型,preMet:%String:用法,freq:%String:频率,onceDose:%String:单次剂量,treat:%String:疗程,msg:%String:预警消息")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBTest","ExportForbidMsg") 
ClassMethod ExportForbidMsgExecute(ByRef qHandle As %Binary, stDate, endDate) As %Status
{
	n (qHandle,stDate,endDate)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	b //333444
	//s stDate = +$h-7
	//s endDate = +$h
	s levelList = $lb("normal","tips","warn","forbid")
	
	s passFlag = 0 
	f date = stDate:1:endDate  d
	.q:'$d(^CKB.PDSS.MonMasterI("DatePass",date))
	.s cmRowID = ""
	.f  s cmRowID = $o(^CKB.PDSS.MonMasterI("DatePass",date,passFlag,cmRowID))  q:cmRowID=""  d
	..q:'$d(^CKB.PDSS.MonMasterD(+cmRowID))
	..s monData = $g(^CKB.PDSS.MonMasterD(cmRowID))
	..s manLevel = $lg(monData,8)
	..q:manLevel'="forbid"
	..s adm = $lg(monData,2)
	..//q:adm=""
	..s papmiNo = 0 //$p($g(^PAADM(+adm)),"^",1)
	..s patNo = 0 //$p(^PAPER(papmiNo,"PAT",1),"^",1)	// 登记号
	..s patInfo = $lg(monData,9)
	..s patObj = {}.%FromJSON(patInfo)
	..s patName = patObj.%Get("PatName")
	..s patSex = patObj.%Get("SexProp")
	..s patAge = patObj.%Get("AgeProp")
	..// 疾病 
	..s disease = patObj.%Get("Disease")
	..s patDis = ""
	..f i=0:1:disease.%Size()-1  d
	...s diseaseObj = disease.%Get(i)
	...s tmpDis = diseaseObj.item
	...q:$lf(patDis,tmpDis)'=0
	...s $list(patDis,*+1)=tmpDis
	..s patDis = $lts(patDis,"、")
	..// 提示消息	
	..s outmsgstr = ..OutPutMsg(cmRowID)
	..// 药品信息
	..s drug = patObj.Drug
	..s patDrug = ""
	..f k=0:1:drug.%Size()-1  d
	...s drugObj = drug.%Get(k)
	...s drugName = drugObj.item
	...s drugName = $replace(drugName,",",".")
	...s formProp = drugObj.FromProp
	...s onceDose = drugObj.OnceDose_drugObj.DosUnit
	...s preMet = drugObj.DrugPreMet
	...s preMet = $replace(preMet,",",".")
	...s freq = drugObj.DrugFreq
	...s freq = $replace(freq,",",".")
	...s treat = drugObj.Treatment
	...s outmsgstr = $replace(outmsgstr,$c(10),"")
	...s outmsgstr = $replace(outmsgstr,$c(10),"")
	...s outmsgstr = $replace(outmsgstr,$c(13),"")
	...s listData = $lb(cmRowID,patNo,patName,patSex,patAge,patDis,drugName,formProp,preMet,freq,onceDose,treat,outmsgstr)
	...s ^CacheTemp(repid,ind)= listData
	...s ind=ind+1	
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      qunianpeng
/// CreatDate:    2022-05-23
/// Description:  审核输出消息整理
/// Input:		 
/// Other:        药品a:相互作用(警示):消息,禁忌症(警示):消息;药品b:用法用量(警示):消息,重复用药(警示):消息;
/// w ##Class(web.DHCCKBTest).OutPutMsg(8956669)
ClassMethod OutPutMsg(cmRowID As %String)
{
	n (cmRowID)
	q:cmRowID="" ""
	s msgInfo = $lg(^CKB.PDSS.MonMasterD(+cmRowID),10)
	q:msgInfo="" ""

	s outmsgstr=""
	s msgObj = {}.%FromJSON(msgInfo)	
	s itemsObj = msgObj.items		// 多个药品obj
	f j=0:1:itemsObj.%Size()-1 d
	.s tmpItmObj = itemsObj.%Get(j)
	.s drugOutMsg=""
	.s checkDrug = tmpItmObj.item
	.s warnObj = tmpItmObj.warns
	.s warnmsg = ""
	.f m=0:1:warnObj.%Size()-1 d	// 多个目录obj
	..s tmpWarmObj = warnObj.%Get(m)
	..s keyname = tmpWarmObj.keyname
	..s keyLevel = tmpWarmObj.manLev
	..s rulemsg = ""
	..s rulemsgObj = tmpWarmObj.itms
	..f n=0:1:rulemsgObj.%Size()-1 d
	...s tmpruleObj = rulemsgObj.%Get(n)
	...s outmsgObj = tmpruleObj.itms
	...s outmsg = ""
	...f x=0:1:outmsgObj.%Size()-1 d	// 多个项目obj
	....s tmpOutObj = outmsgObj.%Get(x)
	....s outstr = tmpOutObj.val	// 项目提醒消息
	....q:outstr=""
	....s outstr = $replace(outstr,","," ")
	....s outmsg =$case(outmsg'="",1:outmsg_". "_outstr,:outstr)
	...
	...q:outmsg=""
	...s rulemsg = $case(rulemsg'="",1:rulemsg_"& "_outmsg,:outmsg) 
	..
	..q:rulemsg=""
	..s keymsg = keyname_"("_keyLevel_"):"_outmsg
	..s warnmsg = $case(warnmsg'="",1:warnmsg_$c(11)_keymsg,:keymsg) 
	.
	.q:warnmsg=""
	.s drugOutMsg = checkDrug_":"_warnmsg
	.s outmsgstr = $case(outmsgstr'="",1:outmsgstr_"; "_$c(11)_"    "_drugOutMsg,:drugOutMsg) 
	.s outmsgstr = $replace(outmsgstr,","," ")
	q outmsgstr
}

/// Creator:		qunianpeng
/// CreatDate:		2022-06-07
/// Description:： 	处理对照表数据，将对照表中id为空的数据，按照外部代码表中的数据进行医院id补充
/// Input:
/// Other:	w ##class(web.DHCCKBTest).UpdateContrastHospId()
ClassMethod UpdateContrastHospId()
{
	s hospArr(94) = "HEBYKDXDYFSYY^哈尔滨医科大学第一附属医院"
	s hospArr(95) = "WHSDYYY^武汉市第一医院"
	s hospArr(96) = "jsyczy^江苏盐城中医"
	s hospArr(97) = "WHSDSYY^武汉市第三医院"
	s hospArr(98) = "BJZYY^北京中医院"
	s hospArr(99) = "BJHLYY^北京惠兰医院"
	s hospArr(100) = "SHMZJH^上海美中嘉和医院"
	s hospArr(101) = "SHQDEYY^赛罕区第二医院"
	s hospArr(102) = "GZZCZY^广州增城中医"
	s hospArr(103) = "WHSDYYYO^武汉市第一医院[旧]"
	s hospArr(104) = "'WHSDYYY1^武汉市第一医院一"
	s hospArr(105) = "YLSDEYY^榆林市第二医院"
	s hospArr(106) = "BYEFY^包医二附院"
	
	s drugType = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	
	
	k successArr
	s hospId = ""
	f  s hospId = $o(hospArr(hospId))  q:hospId=""  d
	.f i=1:1:$ll(drugType)  d
	..s type = $lg(drugType,i)
	..s extID = ""
	..f  s extID = $o(^CKB.PDSS.ExtDictionI("Type",hospId,type,extID))  q:extID=""  d
	...s extData = $g(^CKB.PDSS.ExtDictionD(extID))	
	...s hisCode = $lg(extData,2) 
	...s hisDesc = $lg(extData,3) 
	...s hisDesc = $p(hisDesc,"||",1)
	...q:(hisCode="")||(hisDesc="")
	...//q:hisCode'="3005011SLO2"
	...q:'$d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode)))
	...s markConstID = ""
	...s constID = ""
	...f  s constID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),constID))  q:(constID="")||(markConstID'="")  d
	....s conData = $g(^CKB.PDSS.ComContrastD(constID)) 	
	....s constHisDesc = $lg(conData,5)
	....s constHospId = $lg(conData,7) 
	....q:constHospId'=""
	....q:constHisDesc=""
	....q:hisDesc'=constHisDesc
	....s markConstID = constID
	...
	...q:markConstID=""
	...&sql(update CKB_PDSS.ComContrast set CC_Hospital=:hospId where CC_RowID=:markConstID)
	...s successArr(hospId) = $g(successArr(hospId)) + 1
	
	s hospId = ""
	f  s hospId = $o(successArr(hospId))  q:hospId=""  d
	.s hospDesc = $p(hospArr(hospId),"^",2)
	.w hospDesc_":"_$g(successArr(hospId)),!
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-06-07
/// Description:： 	处理字典码表中的药品中名称含有中文符号的数据
/// Input:
/// Other:	w ##class(web.DHCCKBTest).UpdateComDictionDrugSign()
ClassMethod UpdateComDictionDrugSign()
{
	
	s drugType = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	k successArr
	f i=1:1:$ll(drugType)  d
	.s drugTypeCode = $lg(drugType,i)
	.s drugTypeId = ##class(web.DHCCKBCommon).GetDicIdByCode(drugTypeCode)
	.q:drugTypeId=""	
	.s dicID = ""
	.f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugTypeId,dicID)) q:dicID=""  d
	..s libCode= $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	..s libDesc= $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	..q:libCode=""
	..q:libDesc=""
	..i (libCode["（")||(libCode["）")||(libDesc["（")||(libDesc["）") d
	...s libCode = $replace(libCode,"（","(")
	...s libCode = $replace(libCode,"）",")")
	...s libDesc = $replace(libDesc,"（","(")
	...s libDesc = $replace(libDesc,"）",")")
	...&sql(update CT_CKB_PDSS.CommonDiction set CD_Code=:libCode,CD_Desc=:libDesc where CD_RowID=:dicID)
	...s successArr(drugTypeCode) = $g(successArr(drugTypeCode)) + 1
	
	s hospId = ""
	f  s hospId = $o(successArr(hospId))  q:hospId=""  d
	.s hospDesc = $s(hospId="DrugData":"西药字典",hospId="ChineseDrugData":"中成药字典",hospId="ChineseHerbalMedicineData":"中药饮片字典",1:"")
	.w hospDesc_":"_$g(successArr(hospId)),!
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-06-07
/// Description:： 	处理对照表中的药品中名称含有中文符号的数据
/// Input:
/// Other:	w ##class(web.DHCCKBTest).UpdateConstDrugSign()
ClassMethod UpdateConstDrugSign()
{
	s drugType = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	k successArr
	f i=1:1:$ll(drugType)  d
	.s drugTypeCode = $lg(drugType,i)
	.s drugTypeId = ##class(web.DHCCKBCommon).GetDicIdByCode(drugTypeCode)
	.q:drugTypeId=""
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("Type",drugTypeId,constID)) q:constID=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(constID)) 
	..s libCode = $lg(conData,2)
	..s libDesc = $lg(conData,3)
	..q:libCode=""
	..q:libDesc=""
	..i (libCode["（")||(libCode["）")||(libDesc["（")||(libDesc["）") d
	...s libCode = $replace(libCode,"（","(")
	...s libCode = $replace(libCode,"）",")")
	...s libDesc = $replace(libDesc,"（","(")
	...s libDesc = $replace(libDesc,"）",")")
	...&sql(update CKB_PDSS.ComContrast set CC_LibCode=:libCode,CC_LibDesc=:libDesc where CC_RowID=:constID)
	...s successArr(drugTypeCode) = $g(successArr(drugTypeCode)) + 1
	
	s hospId = ""
	f  s hospId = $o(successArr(hospId))  q:hospId=""  d
	.s hospDesc = $s(hospId="DrugData":"西药字典",hospId="ChineseDrugData":"中成药字典",hospId="ChineseHerbalMedicineData":"中药饮片字典",1:"")
	.w hospDesc_":"_$g(successArr(hospId)),!
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-06-22
/// Description:： 	查询规则中,只有一个分支,该分支的节点关系是or,改成and
/// Input:
/// Other:	w ##class(web.DHCCKBTest).UpdateRuleNodeRef()
ClassMethod UpdateRuleNodeRef()
{
	s parent = 0	

	s num = 0
	s rule = ""
	f  s rule = $o(^CT.CKB.PDSS.RuleD(rule)) q:rule=""  d
	.s count = "",existFlag=0
	.s tmpNode = ""
	.s nodeId = ""
	.f  s nodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",0,nodeId))  q:(nodeId="")||(existFlag=1)||(count>1)  d
	..i $d(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",nodeId))	 d	// 存在子节点,说明不是只有一个分支
	...s existFlag = 1
	..q:existFlag=1	
	..s cond = $lg($g(^CT.CKB.PDSS.RuleNodeD(+nodeId)),3)
	..q:cond'="or"
	..s ruleData = ""
	..f  s ruleData = $o(^CT.CKB.PDSS.RuleDataI("Node",nodeId,ruleData)) q:(ruleData="")||(count>1)  d
	...s count = count + 1
	...q:count'=1
	..q:count'=1	
	..s tmpNode = nodeId
	.q:(count'=1)
	.s num = num + 1
	.w rule,!
	.//s value="and"
	.//&SQL(UPDATE CT_CKB_PDSS.RuleNode SET RN_Condition=:value WHERE RN_RowID=:tmpNode)
	
	b //1
	q ""
	// ^CT.CKB.PDSS.RuleNodeI("Parent",{RN_Rule},{RN_Action},+{RN_Parent},{RN_RowId})
}

/// Creator:		qunianpeng
/// CreatDate:		2022-06-24
/// Description:： 	匹配深圳中医匹配上的数据
/// Input:
/// Other:	w ##class(web.DHCCKBTest).MatchSZZYDrug()
/// Other:     d ##class(%ResultSet).RunQuery("web.DHCCKBTest","MatchSZZYDrug")
/// w ##Class(websys.Query).ToExcel("深圳中医数据-除去美康对照部分20220624","web.DHCCKBTest","MatchSZZYDrug")
Query MatchSZZYDrug() As websys.Query(ROWSPEC = "f1:%String:药品编码,f2:%String:药品名称,f3:%String:是否对照")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBTest","MatchSZZYDrug") 
/// @param: pid 进程号
ClassMethod MatchSZZYDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	s filepath = "D:\temp\中药审核规则.txt"
	Set repid=$I(^CacheTemp)	
	Set ind=1	

	K TmpArr
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	s allergy=""
	s title=""
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.s impDataList=$tr(impDataList,$c(10),"")
	.s impDataList=$tr(impDataList,$c(10,13),"")
	.s impDataList=$tr(impDataList,$c(13),"")	
	.s impDataList=$tr(impDataList,"""","")
	.
	.i hCount=1 s title=impDataList
	.s Err=""
	.q:hCount=1
	.s code = $p(impDataList,"^",1)
	.s desc = $p(impDataList,"^",2)
	.s TmpArr("count",hCount)=impDataList
	.s TmpArr("data",code,desc)=""
	
	c filepath 
	
	s conID = ""
	f  s conID = $o(^CKB.PDSS.ComContrastI("HospType",127,81862,conID)) q:conID=""  d
	.s listData = $g(^CKB.PDSS.ComContrastD(conID))
	.s conHisDesc = $lg(listData,5) 
	.s conHisCode = $lg(listData,4)
	.q:(conHisDesc="")||(conHisCode="")
	.q:$d(TmpArr("data",conHisCode,conHisDesc))
	.
	.s data = $lb(conHisCode,conHisDesc)
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1
	
	/*
	k TmpRetArr
	s hospId = 127 // 深圳中医
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s data = $g(TmpArr(index))
	.s hisCode = $p(data,"^",1)
	.s hisDesc = $p(data,"^",2)
	.s existFlag=0
	.s constrID = ""
	.f  s constrID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),constrID))  q:(constrID="")||(existFlag=1)  d
	..s conHisDesc = $lg(^CKB.PDSS.ComContrastD(constrID),5)
	..q:hisDesc'=conHisDesc
	..s conHosp = $lg(^CKB.PDSS.ComContrastD(constrID),7) 
	..q:hospId'=conHosp
	..s existFlag = 1
	.s conFlag = $case(existFlag=1,1:"对照",:"")
	.s TmpRetArr(index) = data_"^"_conFlag

	s index = ""
	f  s index = $o(TmpRetArr(index))  q:index=""  d
	.s data = $g(TmpRetArr(index))
	.s data = $lfs(data,"^")
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1
	*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:		qunianpeng
/// CreatDate:		2022-07-19
/// Description: 	修改液体配置的级别,只要是没修改过,都设置为警示
/// Input:	w ##class(web.DHCCKBTest).UpdateLiquidConfigRuleLevel()
ClassMethod UpdateLiquidConfigRuleLevel()
{

	s liquidConfig =  ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")	// 液体配置目录

	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s levelFlagId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")	// 管理级别id
	s warnId = ##class(web.DHCCKBCommon).GetDicIdByCode("warn")	// 管理级别id
	s forbidId = ##class(web.DHCCKBCommon).GetDicIdByCode("forbid")	// 禁止-管理级别id
	s normalId = ##class(web.DHCCKBCommon).GetDicIdByCode("normal")	// 提示-管理级别id		
				
	s ruleCount = 0
	s drugId = ""
	f  s drugId = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId))  q:drugId=""   d
	.//q:drugId'=81646
	.//q:drugId'=107977
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	.q:+parref=0
	.q:(parref'=drugData)&&(parref'=chineseDrugData)	// 只找西药和中药的
	.s rule = ""
	.f  s rule = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,liquidConfig,rule)) q:rule=""  d
	..s markIDList = "", isExistFlag = 0
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..//q:ruleStauts'="Release"
	..s unique = $lg($g(^CT.CKB.PDSS.RuleD(+rule)),"^",4)
	..q:unique=""
	..s ruleDataID=""
	..f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataID))  q:(ruleDataID="")   d
	...q:ruleDataID=0
	...q:'$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID))
	...q:"Y"=##class(web.DHCCKBImportRuleManage).CheckRuleUpdateFlag(unique)
	...s prop = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)
	...i levelFlagId=prop d
	....i $lf(markIDList,ruleDataID)=0 s $List(markIDList,*+1) = ruleDataID	
	..
	..f k=1:1:$ll(markIDList)  d
	...s markID = $lg(markIDList,k)
	...s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+markID)),8)
	...&sql(update CT_CKB_PDSS.RuleData set RD_RightDic=:warnId where RD_RowID=:markID)
	...s ruleCount=ruleCount+1
	
	q "修改:"_ruleCount_"条规则"
}

/// Creator:		qunianpeng
/// CreatDate:		2022-07-08
/// Description:： 	导出安全用药的web和user类
/// Input:
/// Other:	d ##class(web.DHCCKBTest).ExportDHCCKBAll("web","D:\web_dhcckb_allclass.txt")
/// Other:	d ##class(web.DHCCKBTest).ExportDHCCKBAll("User","D:\User_dhcckb_allclass.txt")
ClassMethod ExportDHCCKBAll(type, filepath)
{
	
	n (type,filepath)
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	k TmpArr
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s hCount = hCount + 1
	.s TmpArr(hCount) = onerow	
	c filepath 

	s index = "" 
	f  s index = $o(TmpArr(index)) q:index=""  d
	.s name = $g(TmpArr(index))
	.q:name=""
	.d $system.OBJ.Export(type_"."_name,"D:\tempxml\"_type_"\"_type_"."_name_ ".xml")
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-07-08
/// Description:： 	按照薏苡仁更新对照数据（只更新给药途径和用药频率）
/// Input:
/// Other:	w ##class(web.DHCCKBTest).UpdateConstByHosp()
ClassMethod UpdateConstByHosp()
{
	
	s preMetData = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugPreMetData")
	s freqData = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugFreqData")
	s dataList = $lb(preMetData,freqData)
	k ^TMPQnpUpdateConstByHosp
	// 根据医院+ type 遍历代码表(给药途径和用药频率)
	// ^CKB.PDSS.ExtDictionI("Type",{ED_Hospital},{ED_Type},{ED_RowID})
	s hospId = "",count = 0 
	f  s hospId = $o(^CT("HOSP",hospId)) q:hospId=""  d
	.//q:hospId'=94
	.f i=1:1:$ll(dataList)  d
	..s typeId = $lg(dataList,i)
	..s typeCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(typeId)),2)
	..q:'$d(^CKB.PDSS.ExtDictionI("Type",+hospId,typeCode))
	..k TmpArr	
	..s extId = "" 
	..f  s extId = $o(^CKB.PDSS.ExtDictionI("Type",+hospId,typeCode,extId)) q:extId=""  d
	...s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	...s extDesc = $lg(extData,3)
	...s:extDesc["||" extDesc = $p(extDesc,"||",1)
	...//q:extDesc'="腰穿"
	...q:extDesc=""
	...s extCode = $lg(extData,2)
	...q:extCode=""
	...q:'$d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(extDesc)))	// 对照表中没有数据，则不处理
	...s constId = "",existFlag = 0,constList = "",constDescList=""
	...f  s constId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(extDesc),constId))  q:(constId="")  d
	....s conData = $g(^CKB.PDSS.ComContrastD(constId)) 
	....s constHospId = $lg(conData,7)
	....s libCode = $lg(conData,2)
	....s libDesc = $lg(conData,3)
	....i constHospId=hospId  d
	.....s existFlag=1 // 判断是否有该医院的对照关系,如果有则不进行数据处理
	.....s TmpArr("hosp",hospId,extDesc,libDesc) = constId
	....
	....q:existFlag=1 	
	....s TmpArr("data",extDesc,libDesc) = $lb(extCode,extDesc,libCode,libDesc,constId)
	..// 所有的记录
	..s hisDesc=""
	..f  s hisDesc=$o(TmpArr("data",hisDesc))  q:hisDesc=""  d
	...s libDesc = ""
	...f  s libDesc=$o(TmpArr("data",hisDesc,libDesc)) q:libDesc=""  d
	....s listData = $g(TmpArr("data",hisDesc,libDesc))
	....s libCode = $lg(listData,3)
	....s libDesc = $lg(listData,4)
	....s extCode = $lg(listData,1)
	....s extDesc = hisDesc
	....s oldConstId = $lg(listData,5)
	....q:$d(TmpArr("hosp",hospId,extDesc,libDesc))
	....&SQL(INSERT INTO CKB_PDSS.ComContrast VALUES (:libCode,:libDesc,:extCode,:extDesc,:typeId,:hospId))
	....s newConstId = %ROWID
	....s ^TMPQnpUpdateConstByHosp(hospId,typeId,extDesc,libDesc)=listData_"^"_newConstId	
	....s count = count + 1
	....q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBComContrast",oldConstId,"grantAuth"))
	....s oldLogId  = $o(^CKB.PDSS.DicLogI("Function","DHC_CKBComContrast",oldConstId,"grantAuth",""))
	....s logDicDr = "DHC_CKBComContrast"
	....s logDataDr = newConstId
	....s listData = $g(^CKB.PDSS.DicLogD(oldLogId))
	....s user = $lg(listData,5)
	....s date = $lg(listData,6)
	....s time = $lg(listData,7)
	....s scope = $lg(listData,8) 
	....s scopeValue = $lg(listData,9)
	....s ip = $lg(listData,10)
	....&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:logDicDr,:logDataDr,"add",:user,:date,:time,:scope,:scopeValue,:ip))
	....&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:logDicDr,:logDataDr,"grantAuth",:user,:date,:time,:scope,:scopeValue,:ip))

	q "新增"_count_"条对照关系"
}

/// Creator:		qunianpeng
/// CreatDate:		2022-07-26
/// Description:： 	导出南溪山药品  不在 泰安中心药品列表中的数据
/// Input:		  
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBTest","ExportMatchHospDrug")
/// w ##Class(websys.Query).ToExcel("南溪山药品和泰安的交集药品列表","web.DHCCKBTest","ExportMatchHospDrug")
/// w ##Class(websys.Query).ToExcel("南溪山药品没有出现在泰安的部分药品列表","web.DHCCKBTest","ExportMatchHospDrug")
Query ExportMatchHospDrug() As websys.Query(ROWSPEC = "f11:%String:医院药品编码,f12:%String:医院药品名称,f1:%String:药品编码,f2:%String:药品名称,f3:%String:药品类型,f4:%String:医院")
{
}

ClassMethod ExportMatchHospDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	s nxsHosp = "115"
	s nxsHospName = "广西壮族自治区南溪山医院"
	s tazxHosp = "120"
	s typelist = $lb("DrugData","ChineseDrugData")

	s count = 0
	f i=1:1:$ll(typelist) d
	.s type = $lg(typelist,i)
	.s typeName = $s(type="DrugData":"西药",type="ChineseDrugData":"中成药",1:"")
	.s typeId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	.q:'$d(^CKB.PDSS.ExtDictionI("Type",nxsHosp,type))
	.s extId = ""
	.f  s extId = $o(^CKB.PDSS.ExtDictionI("Type",nxsHosp,type,extId)) q:extId=""  d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	..s extCode = $lg(extData,2)
	..s extDesc = $lg(extData,3) 
	..s:extDesc["||" extDesc=$p(extDesc,"||",1)
	..q:extCode=""||(extDesc="")	
	..s constId = "" // 南溪山药品找到对照的系统药品
	..f  s constId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode),constId)) q:constId=""  d
	...s conData = $g(^CKB.PDSS.ComContrastD(constId))
	...s libCode = $lg(conData,2)
	...s libDesc = $lg(conData,3) 
	...s:libCode["," libCode = $replace(libCode,",",".")
	...s:libDesc["," libDesc = $replace(libDesc,",",".")
	...q:libCode=""||(libDesc="")
	...q:'$d(^CKB.PDSS.ComContrastI("HospLibCode",tazxHosp,$$UPPER^SSUTIL4(libCode)))	// 南溪山药品在已经泰安对照
	...s count = count + 1
	...w count,!
	...s TmpArr(count) = $lb(extCode,extDesc,libCode,libDesc,typeName,nxsHospName)

	set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.//$c(28)文件分隔符 肉眼不可见，为了在Excel中数据开头是0的可以显示	
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-06-15
/// Descript: 		根据审查项目的值,审查项目获取对照的知识库字典id
/// Input:			his项目描述, 数据类型, 医院id, 是否按照医院走对照关系
/// zw ##Class(web.DHCCKBTest).testDrug()
ClassMethod testDrug() As %String
{

	s TmpArr(1) = "双黄莲口服液(捐赠)10ml*10支||哈药集团三精制药股份有限公司"
	s TmpArr(2) = "麻杏宣肺颗粒8g*6袋(捐赠)||湖南康寿制药有限公司"
	s TmpArr(3) = "龙胆泻肝丸6g*10丸||哈药世一堂药厂"
	s TmpArr(4) = "YXTB-银杏叶片0.2g*24片||石家庄以岭药业股份有限公司"
	s TmpArr(5) = "银黄含片(成都)0.65g*24片||成都地奥制药集团有限公司"
	s TmpArr(6) = "强力枇杷露250ML||哈尔滨市康隆药业有限责任公司"
	s TmpArr(7) = "XEXJKFY-小儿消积止咳口服液10ml*10支||鲁南厚普"
	s TmpArr(8) = "麻仁润肠丸6g*10丸||北京同仁堂股份有限公司同仁堂制药厂"
	s TmpArr(9) = "金水宝片0.42g*24片||江西济民可信药业有限公司"
	s TmpArr(10) = "金菌灵胶囊(烟台)0.25g*36||烟台大洋制药有限公司"
	s TmpArr(11) = "板兰根颗粒10g*20||河北万岁药业有限公司"
	s TmpArr(12) = "云南白药气雾剂85g/30g*1||云南白药股份有限公司"
	s TmpArr(13) = "牛黄上清丸6g*10丸(人工牛黄)||北京同仁堂"
	s TmpArr(14) = "金匮肾气丸||北京同仁堂科技"
	s TmpArr(15) = "连花清瘟颗粒6g*10袋||北京以岭药业有限公司"
	
	s stDate = $p($zts,",",2)
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s data = $g(TmpArr(index))
	.s data = $p(data,"||",1)
	.w ##Class(web.DHCCKBTest).GetComDicId(data,"",94)
	.//w ##Class(web.DHCCKBTest).GetComDicIdNew(data,"",94)
	s endDate = $p($zts,",",2)
	w !
	w endDate-stDate
	w !
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-06-15
/// Descript: 		根据审查项目的值,审查项目获取对照的知识库字典id
/// Input:			his项目描述, 数据类型, 医院id, 是否按照医院走对照关系
/// zw ##Class(web.DHCCKBTest).GetComDicId("透明防水创可贴63MM*25MM*5贴","",94)
/// zw ##Class(web.DHCCKBTest).GetComDicId("苯扎氯铵贴(上海强生有限公司)","","")
/// zw ##Class(web.DHCCKBTest).GetComDicId("主动脉冠状动脉旁路移植，为心脏血管再形成术","","",1)
ClassMethod GetComDicId(itemDesc As %String, type, hospital, isConstFlag = 0) As %String
{
	n (itemDesc,type,hospital,isConstFlag)
	q:(itemDesc="") ""
	//s stDate = $p($zts,",",2)
	s sysIdList = ""
	// 直接从走对照表,并且不考虑医院id(如诊断)
	i isConstFlag=1  d
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(itemDesc),constID))  q:constID=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(constID))
	..s sysCode = $lg(conData,2)
	..s sysDesc = $lg(conData,3)
	..s parref = $lg(conData,6)
	..s sysId = ##class(web.DHCCKBCommon).GetDicIdByCode(sysCode,parref)
	..q:sysId=0
	..q:0=##class(web.DHCCKBCommon).IsEnabled(sysId)	// 过滤数据被停用
	..q:$lf(sysIdList,sysId)'=0
	..s $list(sysIdList,*+1) = sysId
	q:isConstFlag=1 sysIdList
	
	// 根据医院走对照关系
	s existFlag = $d(^CKB.PDSS.ExtDictionI("Desc",+hospital,itemDesc))  // 外部代码表中是否存在	
	i +existFlag=0 d	// 对于在审核界面录入的安全用药系统的名称,可直接遍历码表
	.s sysId = ""
	.f  s sysId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(itemDesc),sysId)) q:sysId=""  d
	..q:$lf(sysIdList,sysId)'=0
	..s $list(sysIdList,*+1) = sysId
	q:(+existFlag=0)&&$ll(sysIdList)>0 sysIdList
	
	// his数据通过外部代码表找对照关系(给药途径、频率等)
	q:+existFlag=0 ""
	s extId = ""	// 外部代码表
	f  s extId = $o(^CKB.PDSS.ExtDictionI("Desc",hospital,itemDesc,extId))	q:extId=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	.q:(type'="")&&(type'= $lg(extData,4)) // 类型过滤
	.s itemCode = $lg(extData,2)
	.q:itemCode=""
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(itemCode),constID))  q:constID=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(constID))
	..s sysCode = $lg(conData,2)
	..s sysDesc = $lg(conData,3) 
	..s parref = $lg(conData,6)
	..s hisDesc = $lg(conData,5)
	..q:hisDesc'=itemDesc
	..s sysId = ##class(web.DHCCKBCommon).GetDicIdByCode(sysCode,parref)
	..q:sysId=0
	..q:0=##class(web.DHCCKBCommon).IsEnabled(sysId)	// 过滤数据被停用
	..q:$lf(sysIdList,sysId)'=0
	..s $list(sysIdList,*+1) = sysId
	
#;	s endDate = $p($zts,",",2)
#;	w !
#;	w endDate-stDate
#;	w !
	q sysIdList
}

/// Descript:	根据审查项目的值,审查项目获取对照的知识库字典id
/// Author：	qunianpeng 2020/3/9 
/// Input:		his项目描述, 审查代码
/// w ##Class(web.DHCCKBTest).GetComDicId("透明防水创可贴63MM*25MM*5贴","DrugData",94)
/// w ##Class(web.DHCCKBTest).GetComDicIdNew("透明防水创可贴63MM*25MM*5贴","Drug",94)
ClassMethod GetComDicIdNew(itemcode As %String, type = "", hospital = "") As %String
{
	n (itemcode,type,hospital)
	Q:itemcode="" ""
#;	s stDate = $p($zts,",",2)
	s sourceData=""
	i type'="" s sourceData=##class(web.DHCCKBCommon).GetDataSourceValue(type)	
	s itemcodeList=##class(web.DHCCKBPassNew).GetKnowBaseCode(itemcode,sourceData,hospital)
	Q:itemcodeList="" ""
	Q:$listlength(itemcodeList)=0 ""
	s ohterDataId=##class(web.DHCCKBCommon).GetOtherName()
	s drugDataId=##class(web.DHCCKBCommon).GetDrugData()
	s chineseDrugDataId=##class(web.DHCCKBCommon).GetChineseDrugData()
	s chinaHMDataId=##class(web.DHCCKBCommon).GetChineseHMData()
	s itmidList=""
	f i=1:1:$listlength(itemcodeList)  d
	.s itemcode=$listget(itemcodeList,i)
	.q:$$ALPHAUP^SSUTIL4(itemcode)=""
	.s dicID=""
	.f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(itemcode),dicID))	q:(dicID="")  d
	..s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..q:parref=""	
	..q:(type'="Drug")&&((+sourceData'=0)&(parref'=sourceData))	
	..q:(type="Drug")&((parref'=drugDataId)&(parref'=chineseDrugDataId))&(parref'=chinaHMDataId)
	..q:(+ohterDataId'=0)&(parref=ohterDataId)	// 过滤掉别名
	..q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)	// 过滤数据被停用
	..q:$listfind(itmidList,dicID)'=0
	..s $list(itmidList,*+1)=dicID

	s itmdescList=""
	f i=1:1:$listlength(itemcodeList)  d
	.s itemcode=$listget(itemcodeList,i)
	.q:$$ALPHAUP^SSUTIL4(itemcode)=""
	.s dicID=""
	.f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(itemcode),dicID))	q:(dicID="")  d
	..s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..q:parref=""
	..q:(+sourceData'=0)&(parref'=sourceData)
	..q:(+ohterDataId'=0)&(parref=ohterDataId)	// 过滤掉别名
	..q:(type="Drug")&((parref'=drugDataId)&(parref'=chineseDrugDataId))&(parref'=chinaHMDataId)
	..q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)	// 过滤数据被停用
	..q:$listfind(itmdescList,dicID)'=0
	..s $list(itmdescList,*+1)=dicID

	s itmidList = ##Class(web.DHCCKBCommonUtil).GetUnionList(itmidList,itmdescList)	
	
#;	s endDate = $p($zts,",",2)
#;	w !
#;	w endDate-stDate
#;	w !
	Q itmidList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-09-15
/// Descript: 		中成药：禁忌->禁忌证, 相互作用->药物相互作用, 药理作用->药理毒理  数据迁移错误数据处理 
/// Input:			
/// w ##Class(web.DHCCKBTest).UpdateDataForDicAttr()
ClassMethod UpdateDataForDicAttr() As %String
{
	/*
	西药  
	禁忌 	4004  		相互作用 	 4134		药理作用  77981
	禁忌证  4126  ok	药物相互作用 3948 ok	药理毒理  78004 ok

	中成药
	禁忌 	81959
	禁忌证  81958 ok  ->4126

	相互作用 81962
	药物相互作用 81961 ok -> 3948

	药理作用 81826
	药理毒理 81827 ok	-> 78004
	*/
	
	// 在中成药中，如果禁忌存在, 禁忌证不存在。则新增了一条数据，新增的id应该是81958, 但是迁移的代码中，写死了4126,导致页面数据加载不出来
	// 处理逻辑：中成药中，如果同时存在81958 和 4126, 则删除81958的数据，并将4126改成81958
	//					   如果只有4126，将4126改成81958
	// 此方法是临时的方法，id是写死的，不能复用，如果需要复用，请确定id是否合适
	s count = 0
	s parref = "81790"
	s dicID = ""
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.//q:dicID'=120019
	.s constOld = $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,81827))
	.s constNew = $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,78004))
	.i (+constNew>0)  d //同时存在81958 和 4126,则删除81958的数据，
	..i (+constOld>0) d
	...s linkID = ""
	...f  s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,81827,linkID))  q:linkID=""  d
	....&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:linkID)	
	..
	..s linkID = ""
	..f  s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,78004,linkID))  q:linkID=""  d
	...s attrCode = 81827
	...&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_AttrCode=:attrCode where DLA_RowID=:linkID )
	...s count = count + 1
	..
	
	q count
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-11-07
/// Descript: 		修改用药指导以外的规则：将规则中的西药名称属性，改为联用西药名称属性
/// Input:			
/// w ##Class(web.DHCCKBTest).UpdateMedDrugNameProp()
ClassMethod UpdateMedDrugNameProp() As %String
{
	s guideId = ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")
	k TmpArr
	d ..GetGuideList(guideId,.TmpArr)
	
	k RuleArr
	s leftDic = ##class(web.DHCCKBCommon).GetDicIdByCode("MedDrugNameProp")
	s ruleDataId = ""
	f  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("IndexLeftDic",leftDic,ruleDataId))  q:ruleDataId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),2)
	.q:$d(RuleArr("rule",ruleId))
	.q:$d(RuleArr("guide",ruleId))
	.s ruleFlag=0
	.s dic = ""
	.f  s dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,dic))  q:(dic="")||(ruleFlag=1)  d
	..i $d(TmpArr(dic)) s ruleFlag = 1,RuleArr("guide",ruleId)=""
	..q:ruleFlag=1
	.i ruleFlag=0 s RuleArr("rule",ruleId)=""
	
	s count = 0 
	s ruleId = ""
	f  s ruleId = $o(RuleArr("rule",ruleId))  q:ruleId=""  d
	.s count = count + 1

	w count  
	q ""
	//^CT.CKB.PDSS.RuleDicI("RuleDic",{RD_Rule},{RD_Dic},{RD_RowId})
	//^CT.CKB.PDSS.RuleDataI("IndexLeftDic",{RD_LeftDic},{RD_RowID})
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-11-07
/// Descript: 		获取用药指导下所有的目录
/// Input:			
/// w ##Class(web.DHCCKBTest).UpdateDataForDicAttr()
ClassMethod GetGuideList(parref, TmpArr) As %String
{
	n (parref,TmpArr)
	
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",parref)) ""
	s rowid = ""
	f  s rowid = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,rowid))  q:rowid=""  d
	.s TmpArr(rowid) = ""
	.d ..GetGuideList(rowid,.TmpArr)
	
	q ""
}

/// w ##Class(web.DHCCKBTest).TmpUpdateData()
ClassMethod TmpUpdateData()
{

	
  	s DrugData=##class(web.DHCCKBCommon).GetDrugData()                //西药字典
  	s ChineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()  //中成药字典
  	s LiquidConfig=##class(web.DHCCKBCommon).GetLiquidConfig()        //液体配置
  	
  	s SolutionProp=##class(web.DHCCKBCommon).GetSolutionProp()        //溶液
  	s Drug=##class(web.DHCCKBCommon).GetDrug()                        //西药
   	s DiluteProp=##class(web.DHCCKBCommon).GetDiluteProp()            //必须稀释后给药
  	
	s PaDataIdStr=DrugData_"^"_ChineseDrugData                        //西药、中成药模板对应数据源(西药字典、中成药字典)
	f k=1:1:2   d
	.s DicId=""
	.s PaDataId=$p(PaDataIdStr,"^",k)
	.for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:(DicId="")  d
	..s FormDesc = ##class(web.DHCCKBEditProp).QueryAttrValue(DicId,40)
	..q:(FormDesc="粉针剂")||(FormDesc="冻干粉针剂")
	..s Err=0
	..s RDID=""
	..f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:RDID=""  d
	...s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	...q:+Rule=0                                                      //无规则过滤
	...q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,LiquidConfig))           //液体配置目录
    ...s ExistFlag=0                                                  //西药的必须稀释后给药 该分支存在标识
    ...s ThisNode=""     										      //获取第一组并且关系的组号Node
	...s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:(RuleDataID="")  d
	....s LeftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)
	....q:LeftDic'=130544
	....q:$d(^CKB.PDSS.RuleDataLogI("RuleData",RuleDataID))
	....&SQL(delete FROM CT_CKB_PDSS.RuleData WHERE RD_RowID=:RuleDataID)
	
	q "成功"
}

/// w ##Class(web.DHCCKBTest).TmpMark()
ClassMethod TmpMark()
{
	s code = "lh",count = 0 
	s stDate = $p($zts,",",2)
	s fs = ""
	f  s fs = $o(^CT.CKB.PDSS.CommonDictionI(0,"FirstWord",fs))  q:fs=""  d
	.i fs[code s count = count + 1

	s fs = ""
	f  s fs = $o(^CT.CKB.PDSS.CommonDictionI("Desc",fs))  q:fs=""  d
	.i fs[code s count = count + 1
	
	s endDate = $p($zts,",",2)
	w endDate-stDate,!
	q ""
}

/// w ##Class(web.DHCCKBTest).exportFileXml()
ClassMethod exportFileXml()
{
	s filepath="D:\web.dhcckb.txt"
	k TmpArrFile
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath

	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=onerow
	.S hCount=hCount+1
	.s TmpArrFile(hCount) = "web."_impDataList
	
	c filepath 
	b //3
	s path = "D:/updatefile/"
	s h = ""
	f  s h=$o(TmpArrFile(h)) q:h=""  d
	.s clskey = $g(TmpArrFile(h))
	.s clsname=clskey
	.s clskey = $p(clskey,".",1,2)	
	.s clspath=path_clskey_".xml"
	.d $system.OBJ.Export(clsname,clspath)
	.d $system.OBJ.Export(clsname,clspath)
	q ""
}

/// w ##class(web.DHCCKBTest).password("qnp")
/// 通过用户名code获取登录密码
ClassMethod password(userCode As %String)
{
	 s ok="",aa="",okk=""
	 s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) //""的下一个索引
	 s pin=$p($G(^SSU("SSUSR",userId)),"^",3) //密码
	 s leng=$l(pin)
	 q:(leng>12) ""  //加密生成超过12位退出
	 f pp=1:1:leng q:okk="1"  d  //a:b:c b到c 从a开始循环
	 .s ppp=..Passco(aa,pp,pin) //aa密码 pp某一位密码 pin 密文
	 .;b
	 .s aa=$p(ppp,"#",1)
	 .s pp=$p(ppp,"#",2)
	 .s okk=$p(ppp,"#",3)
	 q "用户密码是:"_""_aa
}

ClassMethod Passco(aa As %String, pp As %String, pin As %String)
{
 //s ^donghua(1)=aa_"!"_pp_"!"_pin
 s ok="",okk=""
 s p=42
 f d=p:1:126 q:ok="1"  d //从42开始循环
 .s h=$c(d)
 .;b
 .i aa="" s ppp=h
 .e  s ppp=aa_""_h 
 .s len=$l(ppp)
 .s pass=$$ENCR^SSUTIL2(ppp)
 .i pass=pin s ok="1",okk="1" 
 .i $e(pass,1,len)=$e(pin,1,len) s ok="1"
 .i ok'="1" s ppp=aa q
 .i aa="" s aa=h
 .e  s aa=aa_""_h
 q aa_"#"_pp_"#"_okk
}

}
