Import SQLUser

Class web.DHCCKBComQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询维护的数据模板
/// Creator:sufan
/// CreateDate:2020-08-06
/// w ##class(web.DHCCKBComQuery).QueryTreeList()
ClassMethod QueryTreeList()
{
	s dirTemp = ##class(web.DHCCKBCommon).GetDirTemp() 
	s count = 0
	w "["
	s id="" 
	for  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dirTemp,id)) q:id=""  d
	.s text = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s count = count+1
	.i count = 1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",id_"^"_text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",id_"^"_text)
	w "]"
	q ""
}

/// Descript:取中西药数据
/// Creator:sufan
/// CreateDate:2020-08-06
/// w ##class(web.DHCCKBComQuery).QueryDrugList()
ClassMethod QueryDrugList(q = "")
{
	n (q)
	s medDrugDicId = ##class(web.DHCCKBCommon).GetDrugData()
	
	s chnDrugDicId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s dicIdList = medDrugDicId_"^"_chnDrugDicId
	s length = $l(dicIdList,"^")
	s count = 0
	w "["
	for i=1:1:length  d
	.s dicId = $p(dicIdList,"^",i)
	.s Id = ""
	.for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicId,Id))  Q:Id=""  d
	..s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	..Q:(q'="")&&(desc'[q)
	..s count = count+1
	..Q:(q="")&&(count>100)
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	w "]"
	q ""
}

/// Descript:取厂家数据
/// Creator:sufan
/// CreateDate:2020-08-06
/// w ##class(web.DHCCKBComQuery).QueryManufactList()
ClassMethod QueryManufactList(q = "")
{
	n (q)
	s manufactId = ##class(web.DHCCKBCommon).GetManufacturerData()
	s count = 0
	w "["
	s Id = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",manufactId,Id))  Q:Id=""  d
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	.Q:(q'="")&&(desc'[q)
	.s count = count+1
	.Q:(q="")&&(count>100)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	w "]"
	q ""
}

/// Descript:取剂型数据
/// Creator:sufan
/// CreateDate:2020-08-06
/// w ##class(web.DHCCKBComQuery).QueryDosformList()
ClassMethod QueryDosformList(q = "")
{
	n (q)
	s dosformId = ##class(web.DHCCKBCommon).GetFormData()
	s count = 0
	w "["
	s Id = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dosformId,Id))  Q:Id=""  d
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	.Q:(q'="")&&(desc'[q)
	.s count = count+1
	.Q:(q="")&&(count>100)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	w "]"
	q ""
}

/// Descript:按照设置的模板取数据
/// Creator:sufan
/// CreateDate:2020-02-14
/// 动态输出模板的datagrid的数据
/// w ##class(web.DHCCKBComQuery).ListModelData("77900","1","30","注射用青霉素钠^^")
ClassMethod ListModelData(parent, page, rows, params)
{
	
	n (parent,page,rows,params)
	s ^temptest("3157")=$lb(parent, page, rows, params)
    s start=(page-1)*rows+1	
    s end=page*rows
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()			//取数据源Id
	s TempEleId=##class(web.DHCCKBCommon).GetTempEleId()
	s PrimaryKey=##class(web.DHCCKBCommon).GetPrimaryKey()			//主键
	s drugDesc = $p(params,"^",1)
	s manufactor = $p(params,"^",2)
	s doseform = $p(params,"^",3)
	s PaDataId=""
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",PropIdStr=""					//取每列的数据源以及组织输出title
	s id="" f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",parent,TempEleId,id),-1) q:id=""  d
	.s link=+id  ;+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.q:link=0
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,PrimaryKey))  d
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,PrimaryKey,""))
	..s DictionId=##class(web.DHCCKBRangeCat).GetAddAttrSource(link,"DataSource")
	..s AttrFlagId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..s:$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrFlagId)),3)="Y" PaDataId=DictionId
	.i PropIdStr=""  d
	..s PropIdStr=id
	.e  d
	..s PropIdStr=PropIdStr_"^"_id
	.s dic=id  ;+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic_"Id"
	.
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dic_"^"_dicStr	
										///每列的数据源串，默认以第一个的数据源为索引取值
	k ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelData")
	///默认以第一个的数据源为索引取值
	b  //222
	k AtrrValueList
	s ParDicId=$p(dicStr,"^",1)
	s ListData=""
	s h=0
	s DicId=""
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",PaDataId,DicId))  Q:DicId=""  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	.s Alias="" ;##class(web.DHCCKBRuleIndex).GetDrugAlias(DicId)			//取别名
	.s QuitStr=Desc_Code_Alias
	.Q:##class(web.DHCCKBCommon).IsEnabled(DicId)=0
	.Q:(drugDesc'="")&&(QuitStr'[drugDesc)	
	.s ListData=..GetPropValue(DicId,PropIdStr)
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelData",pid,h)=ListData

	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s count=0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBComQuery","ListModelData",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCCKB","web.DHCCKBComQuery","ListModelData",pid,Index)
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	k ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelData")
	q ""
}

/// Descript:取属性值
/// Creator:sufan
/// CreateDate:2020-02-14
/// w ##class(web.DHCCKBRuleIndex).GetPropValue(150,"81224^44^40")
ClassMethod GetPropValue(DicId, PropList)
{
	n (DicId,PropList)
	s Len=$L(PropList,"^")
	s ListData=""
	k PropValList
	k PropAttrList
	i Len>1  d
	.for i=2:1:Len  d
	..s PropId=$p(PropList,"^",i)
	..s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(PropId)),5)
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,PropId))   d
	...s Index=DicId_"^"_PropId	
	...s LinkAttrId=""		
	...for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,PropId,LinkAttrId))  Q:LinkAttrId=""  d
	....s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)		//属性值
	....i AttrId'=""  d									//取属性值
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	.....i $d(PropAttrList(Index)) s PropAttrList(Index)=PropAttrList(Index)_"&"_AttrId
	.....e  s PropAttrList(Index)=AttrId
	....e   d											//取备注
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),5)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...i ListData="" s ListData=DicId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...e  s ListData=ListData_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	..e  i (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,LinkId))) d
	...s Index=DicId_"^"_LinkId	
	...s LinkAttrId=""
	...for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,LinkId,LinkAttrId))  Q:LinkAttrId=""  d
	....s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)		//属性值
	....i AttrId'=""  d									//取属性值
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	.....i $d(PropAttrList(Index)) s PropAttrList(Index)=PropAttrList(Index)_"&"_AttrId
	.....e  s PropAttrList(Index)=AttrId
	....e  d
	.....s AttrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),5)
	.....i $d(PropValList(Index))  s PropValList(Index)=PropValList(Index)_"&"_AttrValue
	.....e  s PropValList(Index)=AttrValue
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...i ListData="" s ListData=DicId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)_"^"_DicId_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	...e  s ListData=ListData_"^"_$g(PropValList(Index))_"^"_$g(PropAttrList(Index))
	..e  d
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	...s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	...s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	...s RuleImg=$s(ruleFlag=1:Img,1:"")
	...i ListData="" s ListData=DicId_"^"_DicDesc_"^"_DicId
	e  d
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(DicId)		//判断是否有规则
	.s Img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	.s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s RuleImg=$s(ruleFlag=1:Img,1:"")
	.s ListData=DicId_"^"_RuleImg_DicDesc_"^"_DicId
	k PropValList
	k PropAttrList
	Q ListData
}

/// Description: 统计 系统中大于70岁的规则
/// Creator:     yuliping
/// CreateDate:  2021-05-19
/// Input:  	 
/// Return: 	 报告表数据
/// Others:		 d ##class(web.DHCCKBComQuery).ListModelDataNew(81839,1,10,"")
ClassMethod ListModelDataNew(parent, page, rows, Input)
{
	n (parent, page, rows, Input)
	s pid=##class(web.DHCCKBCommonUtil).NewPid()

	//1.清空global
	k ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid)
	
	//2.取数据前的准备
	s modalData = ..getModalData(parent)  //取输出列 
	s PaDataId = $p(modalData,"$",1)      //药品字典大类
	s dicStr = $p(modalData,"$",2)		  //药品输出列
	s TitleStr = $p(modalData,"$",3)	  //药品输出列title
	s CDRowID = ..getRuleExt(pid,"年龄","年^岁")   //类型id，顺便单位存入global
	
	//3.取数据
	s num = ..initRuleData(pid, PaDataId, CDRowID, Input)  			
	
	//4.输出json
	d ..jsonRuleData(page, rows, pid, num, dicStr, TitleStr)         
	
	//5.清除数据
	k ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid)
	
	q ""
}

/// Description: 统计年龄大于70岁 取判断的类型id, 单位id
/// Creator:     yuliping
/// CreateDate:  2021-05-19
/// Return: 	 报告表数据
/// Others:		 w ##class(web.DHCCKBComQuery).getModalData(81839)
ClassMethod getRuleExt(pid, Type, unit)
{
	
	n (pid,Type,unit)
	
	q:Type="" ""
	s CDRowID = ""
	s CDRowID= $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4("年龄"),"")) //类型
	s listExt = "年^岁"  //把年 岁的id存进global,后面判断单位用
	f i=1:1:2 d
	.s Desc = $p(listExt,"^",i)
	.s RightExt = ""
	.f  s RightExt = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(Desc),RightExt)) q:RightExt=""  d //单位
	..q:RightExt=""
	..s:'$d(^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid,"RightExt",RightExt)) ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid,"RightExt",RightExt)=0
	
	q CDRowID
}

/// Description: 统计年龄大于70岁  数据存入global
/// Creator:     yuliping
/// CreateDate:  2021-05-19
/// Return: 	 报告表数据
/// Others:		 d ##class(web.DHCCKBComQuery).initRuleData(81839,1,10,"")
ClassMethod initRuleData(pid, PaDataId, CDRowID, Input)
{
	
	n (pid, PaDataId, CDRowID, Input)
	s num=0
	s RightAge = ""
	s ID = 0
	f  s ID = $o(^CT.CKB.PDSS.RuleDataD(ID)) q:ID=""  d
	.s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ID)),4)   //过滤去掉不是年龄的
	.q:leftDic'=CDRowID
	.s thisExt =$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)
	.q:thisExt=""
	.q:'$d(^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid,"RightExt",thisExt))
	.q:$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)<70  //过滤年龄小于70
	.s ruleID = $lg($g(^CT.CKB.PDSS.RuleDataD(ID)),2)  //规则ID
	.s ruleStatus = $lg($g(^CT.CKB.PDSS.RuleD(ruleID)),4)
	.q:((ruleStatus="CancelRelease")||(ruleStatus="Remove"))  //过滤 取消发布、删除状态的规则
	.s ruleDic = "",flag = 0,thisDicID=""
	.f  s ruleDic = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,ruleDic)) q:ruleDic=""  d
	..s QuitStr=""
	..i $lg($g(^CT.CKB.PDSS.CommonDictionD(ruleDic)),3)="禁忌证" s flag=1
	..s DicID = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,ruleDic,""))
	..s dicParent = $lg($g(^CT.CKB.PDSS.RuleDicD(DicID)),4)
	..s thisDic = $lg($g(^CT.CKB.PDSS.RuleDicD(DicID)),3)
	..q:(PaDataId'=dicParent)
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(thisDic)),3)
	..s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(thisDic)),2)
	..s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(thisDic)			//取别名
	..s QuitStr=Desc_Code_Alias
	..q:(Input'="")&&(QuitStr'[Input)  //查询内容过滤
	..s:((dicParent=105)||(dicParent=81790)) thisDicID=thisDic  //只取西药 中成药
	.q:flag=0
	.q:thisDicID=""
	.s num = num+1
	.s ^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid,"Dic",thisDicID)=""
	
	q num
}

/// Description: 统计年龄大于70岁 取输出列
/// Creator:     yuliping
/// CreateDate:  2021-05-19
/// Return: 	 报告表数据
/// Others:		 w ##class(web.DHCCKBComQuery).getModalData(81839)
ClassMethod getModalData(parent)
{
	n (parent)
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()			//取数据源Id
	s TempEleId=##class(web.DHCCKBCommon).GetTempEleId()
	s PrimaryKey=##class(web.DHCCKBCommon).GetPrimaryKey()			//主键
	s PaDataId=""
	s dic=0,TitleStr="ID",columnCount=1,dicStr="",PropIdStr=""	
	
	//取每列的数据源以及组织输出title
	s id="" 
	f  s id=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",parent,TempEleId,id),-1) q:id=""  d
	.s link=+id  ;+$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",DataSource,id,""))
	.q:link=0
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,PrimaryKey))  d
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,PrimaryKey,""))
	..s DictionId=##class(web.DHCCKBRangeCat).GetAddAttrSource(link,"DataSource")
	..s AttrFlagId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..s:$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrFlagId)),3)="Y" PaDataId=DictionId
	.i PropIdStr=""  d
	..s PropIdStr=id
	.e  d
	..s PropIdStr=PropIdStr_"^"_id
	.s dic=id  ;+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic
	.s columnCount=columnCount+1
	.s $p(TitleStr,"^",columnCount)=dic_"Id"
	.i dicStr="" d
	..s dicStr=dic
	.e  d
	..s dicStr=dic_"^"_dicStr	

	q PaDataId_"$"_dicStr_"$"_TitleStr
}

/// Description: 统计年龄大于70岁 输出json
/// Creator:     yuliping
/// CreateDate:  2021-05-19
/// Return: 	 报告表数据
/// Others:		 w ##class(web.DHCCKBComQuery).jsonRuleData()
ClassMethod jsonRuleData(page, rows, pid, num, dicStr, TitleStr)
{
	
	n (page, rows, pid, num, dicStr, TitleStr)
	
	s start=(page-1)*rows+1	
    s end=page*rows

	q:num=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(num)	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(num) // 输出json前缀串
	s count=0
	s Index=""
	f  s Index=$o(^TMP("DHCCKB","web.DHCCKBComQuery","ListModelDataNew",pid,"Dic",Index))  Q:Index=""  d
	.s count=count+1
	.q:(count<start)||(count>end)
	.s Data=..GetPropValue(Index,dicStr)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	q ""
}

/// Description: 统计药师工作量
/// Creator:     yuliping
/// CreateDate:  2021-05-20
/// Return: 	 药师，确定药物的个数，确定规则的个数
/// Others:		 d ##class(web.DHCCKBComQuery).listPharmacistWork(1,30,"2021-01-01","2022-01-13")
ClassMethod listPharmacistWork(page, rows, StDate, EndDate)
{
	n (StDate,EndDate)
	k ^y
	s pid=##class(web.DHCCKBCommonUtil).NewPid()

	//1.初始化global
	k ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid)
	
	//2.1 取数据授权表数据  数据存入global
	s num = ..getPhaWorkData(StDate, EndDate, pid)
	
	//2.2 取规则日志数据   数据存入global
	s numRule = ..getRuleLogData(StDate, EndDate, pid)
	s num = num + numRule  //总数
	
	//3.输出json
	d ..jsonPharWord(num,pid)
	
	//4.清空global
	k ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid)
	
	q ""
}

/// Description: 统计药师工作量 输入存入global
/// Creator:     yuliping
/// CreateDate:  2021-05-20
ClassMethod getPhaWorkData(StDate, EndDate, pid)
{
	
	n (StDate,EndDate,pid)
	s DrugData= ##class(web.DHCCKBCommon).GetDrugData()
	s ChineseID=##class(web.DHCCKBCommon).GetChineseHMData()
	s ChineseDrugID=##class(web.DHCCKBCommon).GetChineseDrugData()
	k ^TMP("DHCCKB","web.DHCCKBComQuery","PhaWorkData",pid)
	s as=0
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	s num = 0
	f date=StDate:1:EndDate d
	.s LogRowID = ""
	.f  s LogRowID = $o(^CKB.PDSS.DicLogI("Date",date,LogRowID)) q:LogRowID=""  d
	..s listData = $g(^CKB.PDSS.DicLogD(LogRowID))
	..s status = $lg(listData,4)
	..s dicID =  $lg(listData,3)  //实体ID
	..q:dicID=0
	..q:'((status="confirm")||(status="add")||(status="edit"))    //取确认、新增、修改数据
	..s dic = $lg(listData,2) //操作类型
	..s dics=dic
	..q:'((dic="DHC_CKBCommonDiction")||(dic="DHC_CKBRule")||(dic="DHC_CKBDicLinkAttr"))   //只取规则和字典
	..i dic="DHC_CKBDicLinkAttr"  d  //字典属性，需要去对应的实体
	...s:$d(^CT.CKB.PDSS.DicLinkAttrD(dicID)) dicID = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(dicID)),2)
	...i status="add" s status="edit"   //只维护属性，不算新增药物
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(dicID))&&((dic'="DHC_CKBRule"))
	..s operator = $lg(listData,5)   //操作人
	..q:'$d(^SSU("SSUSR",operator))
	..s dataDR = $lg(listData,3)
	..;s status = ..getRuleLogData(dataDR, operator, dic) //新增还是修改
	..s dic = $case(dic,"DHC_CKBCommonDiction":1,"DHC_CKBDicLinkAttr":1,"DHC_CKBRule":2,"":"")  //1 药品，2规则 方便排序
	..s flag=0  // 药品判断归属,西药 成药 中医饮片
	..i dic=1 d
	...s par=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	...i ((par=DrugData)||(par=ChineseID)||(par=ChineseDrugID)) s flag=1
	..q:(dic=1)&&(flag=0)
	..i (operator=11866)&(dics="DHC_CKBCommonDiction")&(status="add") s as=as+1
	..q:$d(^TMP("DHCCKB","web.DHCCKBComQuery","PhaWorkData",pid,date,operator,dicID,status))   //当天一个药物一个人只记录一个操作状态
	..s ^TMP("DHCCKB","web.DHCCKBComQuery","PhaWorkData",pid,date,operator,dicID,status)=1
	..i $d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status)) d
	...s ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status) = ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status) +1
	..e  s ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status) = 1 
	..s num = num + 1
	
	b
	k ^TMP("DHCCKB","web.DHCCKBComQuery","PhaWorkData",pid)
	q num
}

/// Description: 取规则日志数据 输入存入global
/// Creator:     yuliping
/// CreateDate:  2021-05-20
/// w ##class(web.DHCCKBComQuery).getLogStatus(118057,11867,"DHC_CKBCommonDiction")
ClassMethod getRuleLogData(StDate, EndDate, pid)
{
	n (StDate,EndDate,pid)
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	k ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid)
	s num = 0
	f date=StDate:1:EndDate d
	.s LogRowID = ""
	.f  s LogRowID = $o(^CKB.PDSS.RuleLogI("Date",date,LogRowID)) q:LogRowID=""  d
	..s logData = $g(^CKB.PDSS.RuleLogD(LogRowID))
	..s status = $lg(logData,6)
	..q:'((status="Release")||(status="CancelRelease"))    //取发布、取消发布
	..s status = $case(status,"Release":"add","CancelRelease":"edit","":"")
	..s operator = $lg(logData,3)    //操作人
	..q:operator=""
	..s ruleID = $lg(logData,2)   //规则id
	..q:'$d(^SSU("SSUSR",operator))
	..s dic =2  //1 药品，2规则 方便排序
	..q:($d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid,date,operator,ruleID,status)))   //一条规则，当天一个状态只算一次
	..s ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid,date,operator,ruleID,status)=1
	..q:$d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid,date,operator,ruleID,"edit"))&&(status="add")  //取消发布，又发布的，算修改，把新增状态过滤掉，否则会加到新增数据里
	..i $d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid,date,operator,ruleID,"edit"))&&$d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid,date,operator,ruleID,"add")) d     //新增和修改都有，新增数据减1，算到修改里
	...s ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,"add")=^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,"add")-1
	..i $d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status)) d
	...s ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status) = ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status) +1
	..e  s ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,operator,dic,status) = 1 
	..s num = num + 1
	
	k ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistDate",pid)

	q num
}

/// Description: 统计药师工作量 输出json
/// Creator:     yuliping
/// CreateDate:  2021-05-20
/// w ##class(web.DHCCKBComQuery).jsonPharWord()
ClassMethod jsonPharWord(num, pid)
{
	n (num,pid)
	
	s start=1	
    s end=10000
	b
	q:num=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(num)	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串

	s TitleStr = "Operator^Diction^addNum^editNum^confirmNum^allNum"
	s count=0
	s UserID = ""
	f  s UserID = $o(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID)) q:UserID=""  d
	.s status = "",dic="",addAllnum = 0,editAllNum=0,confirmAllNum=0,countNum = 0
	.f  s dic = $o(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic)) q:dic=""  d
	..s addNum=0,editNum=0,confirmNum=0,allNum = 0   //新增数量、修改数量、确认数量、合计
	..s:$d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic,"add")) addNum = ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic,"add")
	..s:$d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic,"edit")) editNum = ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic,"edit")
	..s:$d(^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic,"confirm")) confirmNum = ^TMP("DHCCKB","web.DHCCKBComQuery","PharmacistWorkload",pid,UserID,dic,"confirm")
	..s count=count+1
	..;q:(count<start)||(count>end)
	..s allNum = addNum+editNum+confirmNum+allNum  //本行合计
	..s addAllnum = addAllnum + addNum				//新增数量
	..s editAllNum = editAllNum +editNum			//修改数量
	..s confirmAllNum = confirmNum + confirmAllNum	//确认数量
	..s countNum =allNum+countNum
	..s user = $p(^SSU("SSUSR",UserID),"^",2)
	..s dicDesc = $case(dic,1:"药物",2:"规则","":"")
	..s Data =user_"^"_dicDesc_"^"_addNum_"^"_editNum_"^"_confirmNum_"^"_allNum
	..i count=start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,Data)
	.s mData=""
	.s count=count+1
	.;q:(count<start)||(count>end)
	.s mData = user_"^合计^"_addAllnum_"^"_editAllNum_"^"_confirmAllNum_"^"_countNum
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,mData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(TitleStr,mData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) 	// 输出json结尾符	

	q ""
}

/// Description: 适应症禁忌症查询
/// Creator:     yuliping
/// CreateDate:  2021-05-20
/// w ##class(web.DHCCKBComQuery).listDrug(1,10,2,"高血压",2)
ClassMethod listDrug(page = 1, rows = 10, queryType = "", queryPar = "", userInfo)
{
	
	n (page, rows, queryType,queryPar,userInfo)
	s start=(page-1)*rows+1
 	s end=page*rows

	i queryType=2 s queryType="适应症"
	i queryType=3 s queryType="禁忌证"
  	s TitleStr="id^incDesc^incSpec^incPackage^incManf^Indication^Contraindication^Ingredient^GenerName^HospUsed^indication"
  	s contr=##class(web.DHCCKBCommon).GetDrugContrNew() 				 //kml 禁忌症属性
  	s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 //kml 适应症属性
	w "{""rows"":["
	s count = 0
	s CDRowID= $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(queryType),"")) //类型
	s dicRowId = ""
	f  s dicRowId = $o(^CT.CKB.PDSS.RuleDicI("Dic",CDRowID,dicRowId)) q:dicRowId=""  d
	.s parfDr = $lg($g(^CT.CKB.PDSS.RuleDicD(dicRowId)),4)
	.s ruleID = $lg($g(^CT.CKB.PDSS.RuleDicD(dicRowId)),2)
	.s ruleDataID = "",flag =0
	.f  s ruleDataID = $o(^CT.CKB.PDSS.RuleDataI("Rule",ruleID,ruleDataID)) q:ruleDataID=""  d
	..q:$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)'=6  //西医疾病
	..s comdicId = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8)
	..q:comdicId=""
	..s comdicDesc  = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),9)  //输入的疾病
	..i $d(^CT.CKB.PDSS.CommonDictionD(comdicId)) s comdicId =$lg($g(^CT.CKB.PDSS.CommonDictionD(comdicId)),3)
	..s comdicId=comdicId_comdicDesc
	..q:comdicId'[queryPar
	..s flag = 1
	.q:flag=0
	.s DrugrowId = ""
	.s DrugrowId = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,CDRowID))
	.s:DrugrowId="" DrugrowId= $o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,CDRowID),-1)
	.q:DrugrowId=""
	.s id = DrugrowId
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,Indic,1) //kml   sufan2020-05-11 新增参数用于区分是导航界面
	.i Indication=""  d
	..s Indication=##class(web.DHCCKBDrugVO).GetFunIndicat(id)	//取功能主治 sufan 2020-07-09 
	.i (queryType="适应症") d
	..s Indication=$replace(Indication,queryPar,"<font color='red'>"_queryPar_"</font>")
	.s Contraindication=""
	.i (queryType="禁忌证") d
	..s Contraindication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,contr,1) //kml sufan2020-05-11 新增参数用于区分是导航界面
	..i Contraindication=""  d
	...s Contraindication=##class(web.DHCCKBDrugVO).GetDrugContra(id)	//取禁忌	sufan 2020-07-09
	..s Contraindication=$replace(Contraindication,queryPar,"<font color='red'>"_queryPar_"</font>")
	.s contrastFlag = 0  //是否对照
	.s contrastFlag = ##class(web.DHCCKBComContrast).CheckFlag(code,desc,userInfo)
	.s clickTimes = 0  //点击次数
	.s clickTimes = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(id,userInfo)
	.s incManf="",incSpec="",incPackage=""
	.s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(id)   	//成分
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(id)			//通用名
	.s ProName=##class(web.DHCCKBDrugVO).GetProName(id)				//商品名]
	.s GenerFromName = ##class(web.DHCCKBDrugVO).GetGenerFromName(id) //通用名带剂型
	.s Prop =##class(web.DHCCKBDrugVO).GetSpecificationProp(id)    //规格
	.s facturer=##class(web.DHCCKBDrugVO).GetManufacturer(id)
	.i GenerFromName="" s GenerFromName=desc
	.i contrastFlag=1 s GenerFromName = GenerFromName_"<font color='red'>【本院在用】</font>"
	.s HospUsed=""
	.s:contrastFlag=1 HospUsed="本院在用"
	.s DrugDatas="DrugData"
	.s tmp=id_"^"_GenerFromName_"^"_GenerName_"^"_ProName_"^"_Ingredient_"^"_Prop_"^"_Indication_"^"_facturer_"^"_DrugDatas_"^"_HospUsed_"^"_Contraindication
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,tmp)

	w "],""total"":"_count_"}"
  	q ""
}

}
