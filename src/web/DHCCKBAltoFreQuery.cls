Import sqluser

Class web.DHCCKBAltoFreQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Descript:存处方数据临时存储
/// Creator:sufan
/// CreateDate:2020-11-06  
/// w ##class(web.DHCCKBAltoFreQuery).getPrescData(1,66123,66129)
ClassMethod getPrescData(pid, stDate, endDate)
{
	n (pid,stDate,endDate)
	s h = 0
	k ^TMP("web.DHCCKBAltoFreQuery","drugName")
	
	for date = stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s exaParam = $lg(monData,9)							//处方
	..q:exaParam["UNDEFINED"
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	..s drugArr = exaParamObj.%Get("Drug")
	..s Hosp =  $lg(monData,12)						//项目名称
	..s length = drugArr.%Size()
	..for k=0:1:length-1  d
 	...s drugObj = drugArr.%Get(k)
 	...s drugName = drugObj.item
 	...q:drugName=""
 	...if $d(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugName)) d      //统计各药品出现总数
 	....s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugName)= ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugName) + 1
 	...else  d 
 	....s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugName)=1 
 	....s h=h+1
 	;...if $d(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp")) d   //判断是否传入项目
	;....s hospnum=""
	;....for  s hospnum= $o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,hospnum)) Q:hospnum=""  d   //取出所选项目
	;.....s hospDesc=$g(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,hospnum))
	;.....if (hospDesc'=Hosp)&&(hospDesc'="") d                      //项目匹配
	;......s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospDesc)=0   //不匹配定义为0
	;.....e  d        
	;......if $d(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospDesc)) d   //多次匹配定义累加
	;.......s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospDesc)=^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospDesc) + 1
	;......e  d                                                                          //第一次匹配定义为1
	;.......s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospDesc)=1
 	q h
}

/// Descript:各药品审核程度
/// Creator:wangxin
/// CreateDate:2020-11-27
/// input:药品名称
/// w ##class(web.DHCCKBAltoFreQuery).auditStatus("注射用苄星青霉素120万U（华北制药股份有限公司）")
ClassMethod auditStatus(drugName)
{
	n (drugName)
	s usage=""            //用法
	s usdosage=""         //用法用量
	s addisease=""        //适应症
	s contraindication="" //禁忌症
	s interaction=""      //相互作用
	s incompatibility=""  //配伍禁忌
	s liquidconfigura=""  //液体配置
	s medicationguides=""  //用药指导
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","auditStatus",drugName)=usage_"^"_usdosage_"^"_addisease_"^"_contraindication_"^"_interaction_"^"_incompatibility_"^"_liquidconfigura_"^"_medicationguides
	
	Q:$d(^TMP("web.DHCCKBAltoFreQuery","drugName",drugName)) ""             //去掉药品重复
	s ^TMP("web.DHCCKBAltoFreQuery","drugName",drugName)=0
		

	s ccrowid=$o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(drugName),""),-1)     //通过药品名称获取id
	q:ccrowid="" ""
 	s LibDesc=$lg(^CKB.PDSS.ComContrastD(ccrowid),3)                                  //获取对照名
 	s cdrowid=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(LibDesc),""))       //通过对照名获取id
 	q:cdrowid="" ""
 
  /*取药品目录*/
	s comDosageId = ##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")									//用法
	s ruleUsageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")									//用法用量
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")									//适应症
	s ruleContrId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")									//禁忌症
	s interEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")								 //相互作用
	s tabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")																 //配伍禁忌
 	s LiquidConfigId = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")			//液体配置
 	s medicationguide = ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")						//用药指导
 
	//判断各目录是否已审核
	if ..QueryRuleCats(cdrowid,comDosageId)=1 d
	.s usage="已审核"
	if ..QueryRuleCats(cdrowid,ruleUsageId)=1 d
	.s usdosage="已审核"
	if ..QueryRuleCats(cdrowid,ruleIndicId)=1 d
	.s addisease="已审核"
	if ..QueryRuleCats(cdrowid,ruleContrId)=1 d
	.s contraindication="已审核"
	if ..QueryRuleCats(cdrowid,interEachId)=1 d
	.s interaction="已审核"
	if ..QueryRuleCats(cdrowid,tabooId)=1 d
	.s incompatibility="已审核"
	if ..QueryRuleCats(cdrowid,LiquidConfigId)=1 d
	.s liquidconfigura="已审核"
	if ..QueryRuleCats(cdrowid,medicationguide)=1 d
	.s medicationguide="已审核"
	s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","auditStatus",drugName)=usage_"^"_usdosage_"^"_addisease_"^"_contraindication_"^"_interaction_"^"_incompatibility_"^"_liquidconfigura_"^"_medicationguides
	q ""
}

/// 判断审核是否全部通过
ClassMethod QueryRuleCats(cdrowid, catid)
{
	n (cdrowid,catid)
 s rdrule="",count=0,h=0
 for  s rdrule=$o(^CT.CKB.PDSS.RuleDicI("Dic",cdrowid,rdrule)) q:rdrule=""  d
 .s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(rdrule)),2)
 .q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,catid))
 .q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",rule,"confirm"))  s count=count+1
 .if (count=0) d
 ..s h=1
 q h
}

/// Descript:各药品出现数量
/// Creator:wangxin
/// CreateDate:2020-11-25 
/// input:开始时间^结束时间  
/// w ##class(web.DHCCKBAltoFreQuery).QueryRuleCat(1,30,"2022-01-14^2022-01-20^")
ClassMethod QueryRuleCat(rows, page, params)
{
	n (rows,page,params)
	s ^tmp("query")=$lb(params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	s HospList = $p(params,"^",3)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s h=0,count=0
	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid)
	s h = ..getPrescData(pid,stDate,endDate)
	Q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	
	//给listTitle赋值
	s listTitle="drugName^drugsNum^usage^usdosage^addisease^contraindication^interaction^incompatibility^liquidconfigura^medicationguides"
 	;if $d(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp")) d
	;.s hospnum=""
	;.for  s hospnum= $o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,hospnum)) Q:hospnum=""  d
	;..s hospDesc=^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,hospnum)
	;..s hospDesc=$$ALPHAUP^SSUTIL4(hospDesc)
	;..S listTitle=listTitle_"^"_hospDesc
	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	
	s drugName=""
	for  s drugName = $o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugName))  Q:drugName=""  d
	.s drugsNum=^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugName)
	.;频率次数排序
	.s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugsNum,drugName) = drugsNum
	
	b   //33
	
	s drugsNum=""
	for  s drugsNum = $o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugsNum),-1)  Q:drugsNum=""  d
	.s drugName=""
	.for  s drugName = $o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData",pid,drugsNum,drugName))  Q:drugName=""  d
	..s catlist=^TMP("DHCCKB","web.DHCCKBAltoFreQuery","auditStatus",drugName)
	..s list = drugName_"^"_drugsNum_"^"_catlist
	..;判断选择项目
	..;if $d(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp")) d
	...;s hospnum=""
	...;for  s hospnum=$o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospnum))  Q:hospnum=""  d
	....;s hospdata=^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum",pid,drugName,hospnum)
	....;s list=list_"^"_hospdata
	..s count = count+1
	..q:(count<Start)||(count>End)
	..i count=Start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","getPrescData")
	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp")
	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hospnum")
	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","auditStatus")
	k ^TMP("web.DHCCKBAltoFreQuery","drugName")
	Q ""
}

/// Descript:取项目数据
/// w ##class(web.DHCCKBAltoFreQuery).QueryHospList("2022-01-14^2022-01-25")
ClassMethod QueryHospList(params)
{
 	n (params)
 	s count = 0
	w "["
	s Id = "0"
	for  s Id = $o(^CT("HOSP",Id))  Q:Id=""  d
	.s desc = $p(^CT("HOSP",Id),"^",2) 
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",desc_"^"_desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",desc_"^"_desc)
	w "]"
	q ""
}

/// Descript:取各项目对比表头信息
/// Creator:wangxin
/// CreateDate:2020-11-26
/// Input:项目名称,是否选中多选
/// w ##class(web.DHCCKBAltoFreQuery).GetColumns("","0")
ClassMethod GetColumns(HospList, agree)
{
	n (HospList,agree)
	s ^temptest("333")=$lb(HospList,agree)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
 	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp")
 	if HospList'=""{
		s length=$l(HospList,",")
		for k= 1:1:length{
			  S hosp=$p(HospList,",",k)
			  s ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,k)=hosp
		}
 	}

	s obj= ##class(%DynamicObject).%New()
	s columns=[]
	s column={}
	s column.field="drugName" 
	s column.title="药品名称" 
 	s column.width="200"
 	d columns.%Push(column)
	
	if $d(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid)) d 
	.if (agree=1) d
	..s column={}
	..s column.field="drugsNum" 
	..s column.title="使用次数" 
 	..s column.width="200"
 	..d columns.%Push(column)
	.s hosp = ""
	.for  s hosp=$o(^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,hosp))  Q:hosp=""  d
	..s hospdesc=^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid,hosp)
	..;s hospdesc=$p(^CT("HOSP",hospid),"^",2)
	..s column={}
	..s title = hospdesc
	..s column.field=$$ALPHAUP^SSUTIL4(title)  
	..s column.title=title 
 	..s column.width="200"
	..d columns.%Push(column)
 	else  d
 	.s column={}
	.s column.field="drugsNum" 
	.s column.title="使用次数" 
 	.s column.width="200"
 	.d columns.%Push(column)

	s column={}
	s column.field="usage" 
	s column.title="用法" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="usdosage" 
	s column.title="用法用量" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="addisease" 
	s column.title="适应症" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="contraindication" 
	s column.title="禁忌症" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="interaction" 
	s column.title="相互作用" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="incompatibility" 
	s column.title="配伍禁忌" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="liquidconfigura" 
	s column.title="液体配置" 
 	s column.width="200"
 	d columns.%Push(column)
 	s column={}
	s column.field="medicationguides" 
	s column.title="用药指导" 
 	s column.width="200"
 	d columns.%Push(column)
 
 	set obj.columns = columns
	set obj.pid = pid
	w obj.%ToJSON()
	k ^TMP("DHCCKB","web.DHCCKBAltoFreQuery","hosp",pid)
	q ""
}

}
