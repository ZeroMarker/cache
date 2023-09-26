Import SQLUser

/// Descript:按照标记查询日志数据
/// Creator:sufa
/// CreateDate:2020-12-29
Class web.DHCCKBMonLogQuery Extends %Library.RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Descript:按照标记查询日志数据
/// Creator:sufa
/// CreateDate:2020-12-29
/// Input:stDate:开始日期,endDate:结束日期,hospDesc:医院
/// Output:日志信息
/// w ##class(web.DHCCKBMonLogQuery).QueryMonData("30","1","2020-12-21^2020-12-21^^哈尔滨医科大学第一附属医院(20201221)")
ClassMethod QueryMonData(rows, page, params)
{
	n (rows,page,params)
	s ^temptest("QueryMonData")=$lb(rows, page, params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	s sign = $p(params,"^",3)
	s hospDesc = $p(params,"^",4)
	
	s hospDesc = $$ALPHAUP^SSUTIL4(hospDesc)
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	d ##Class(web.DHCCKBMonLogQuery).KillTmpGlobal(pid)
	s h = 0,count = 0
	for date = stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("DatePass",date,"0",monId))   Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s hosp= $lg(monData,12)
	..s hosp=$$ALPHAUP^SSUTIL4(hosp)
	..q:(hospDesc'="")&&(hospDesc'=hosp)
	..s exaParam = $lg(monData,9) //入参
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	..s outParam = $lg(monData,10)
	..s monItmId = ""	
	..for  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s mqlData = $g(^CKB.PDSS.MonQueListD(monItmId))
	...s itmId = $lg(mqlData,3)		//药品名称
	...Q:'$d(^CT.CKB.PDSS.CommonDictionD(itmId))
	...s catId = $lg(mqlData,4)		//目录id
	...s cat = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	...s remarks = $lg(mqlData,9)	//备注
 	...s exasignval = $lg(mqlData,10)	
 	...;b:exasignval'=""   //11
 	...Q:exasignval=""
 	...Q:(sign'="")&&(exasignval'=sign)
 	...s drug = $lg($g(^CT.CKB.PDSS.CommonDictionD(itmId)),3)
 	...s drugOutParam = "",formProp = "",onceDose = "",drugPreMet = "" ,drugFreq = "",treatment = ""
 	...s drugArr = exaParamObj.%Get("Drug")
	...s length = drugArr.%Size()
	...for k=0:1:length-1  d
	....s drugObj = drugArr.%Get(k)
	....s drugName = drugObj.item
	....q:drugName=""
	....s onceDose = drugObj.OnceDose
	....s unit = drugObj.Unit
	....s formProp = drugObj.FormProp
	....s drugPreMet = drugObj.DrugPreMet
	....s drugFreq = drugObj.DrugFreq
	....i drugFreq="" s drugFreq=drugObj.DrugDrugFreq
	....s treatment = drugObj.Treatment
	....s seqNo = drugObj.SeqNo 
	....s libDrugId = ##Class(web.DHCCKBPassNew).GetComDicIdNew(drugName,"Drug")
	....s libDrugDesc = ""
	....s:libDrugId'="" libDrugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD($list(libDrugId,1))),3)
	....Q:libDrugDesc'=drug
	....s drugOutParam = ##class(web.DHCCKBCalculateval).getExeOutParam(outParam, drugName, cat,"",seqNo)    //获取审查结果
 	...s h = h+1
 	...s ^TMP("DHCCKB","web.DHCCKBMonLogQuery","QueryMonData",pid,itmId,catId,exasignval) = monId_"^"_monItmId_"^"_drug_"^"_remarks_"^"_exasignval_"^"_formProp_"^"_onceDose_"^"_drugPreMet_"^"_drugFreq_"^"_treatment_"^"_drugOutParam
	
	Q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	s listTitle = "monId^monItmId^drug^remarks^exasignval^drugOutParam"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s indexItm = ""
	for  s indexItm = $o(^TMP("DHCCKB","web.DHCCKBMonLogQuery","QueryMonData",pid,indexItm))  Q:indexItm=""  d
	.s indexCat = ""
	.for  s indexCat = $o(^TMP("DHCCKB","web.DHCCKBMonLogQuery","QueryMonData",pid,indexItm,indexCat))  Q:indexCat=""  d
	..s indexSign = ""
	..for  s indexSign = $o(^TMP("DHCCKB","web.DHCCKBMonLogQuery","QueryMonData",pid,indexItm,indexCat,indexSign))  Q:indexSign=""  d
	...s data = ^TMP("DHCCKB","web.DHCCKBMonLogQuery","QueryMonData",pid,indexItm,indexCat,indexSign)
	...s count = count+1
	...q:(count<Start)||(count>End)
	...i count=Start d
	....w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	...e  d
	....w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ##Class(web.DHCCKBMonLogQuery).KillTmpGlobal(pid)
	Q ""
}

ClassMethod KillTmpGlobal(pid)
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBMonLogQuery","QueryMonData",pid)
}

}
