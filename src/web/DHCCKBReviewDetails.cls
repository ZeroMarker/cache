Import sqluser

Class web.DHCCKBReviewDetails Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##class(web.DHCCKBReviewDetails).QueryRevDetails("30","1","7565933,7568053","52")
ClassMethod QueryRevDetails(rows, page, monItmList, funId)
{
	s ^temptest("sss")=$lb(rows, page, monItmList,funId)
	s End=page*rows
	s Start=(page-1)*rows+1
	s len = $l(monItmList,",")
	
	Q:len=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s h = 0
	
	for i =1:1:len  d
	.s monItmId = $p(monItmList,",",i)
	.s mqlData = $g(^CKB.PDSS.MonQueListD(monItmId))
	.s catId = $lg(mqlData,4)
	.s cat = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	.s drugId = $lg(mqlData,3)
	.s drug = ""
	.s:drugId'="" drug = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	.s monId = $lg(mqlData,2)
	.s monData = $g(^CKB.PDSS.MonMasterD(monId))
	.s exaParam = $lg(monData,9)				//入参
	.s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	.s hospital = exaParamObj.Hospital
	.s hospId = ""
	.i hospital'="" s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospital),""))
	.s outParam = $lg(monData,10)	
	.s funPro = $lg(mqlData,5)			//出参
	.s funDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(funPro)),3)
	.Q:(funId'="")&&(funId'=funPro)
	.//取患者信息
	.s patName = exaParamObj.PatName
	.s:patName="" patName="门诊"
	.s episodeID = exaParamObj.EpisodeID
	.s patientID = $p($g(^PAADM(+episodeID)),"^",1)
	.s patNo = $p($g(^PAPER(+patientID,"PAT",1)),"^",1)  /// 登记号
	.s sex = exaParamObj.SexProp
	.s age = exaParamObj.AgeProp
	.s weight = exaParamObj.Weight
	.s patInfo = patName_"^"_sex_"^"_age_"^"_weight
	.//取过敏信息
	.s hisAllergyList = ""
	.s hisAllergyArr = exaParamObj.%Get("HisAllergy")
	.s lenaller = hisAllergyArr.%Size()
	.for m=0:1:lenaller-1  d
	..s allergyObj = hisAllergyArr.%Get(m)
	..s allergy = allergyObj.item
	..i hisAllergyList="" s hisAllergyList = allergy
	..e  s hisAllergyList = hisAllergyList_";"_allergy
	.s diagList = ""
	.s diagArr = exaParamObj.%Get("Disease")
	.s diagLen = diagArr.%Size()
	.for j=0:1:diagLen-1  d
	..s diagObj = diagArr.%Get(j)
	..s diag = diagObj.item
	..i diagList="" s diagList = diag
	..e  s diagList = diagList_";"_diag
	.//取药品信息
	.s drugArr = exaParamObj.%Get("Drug")
	.s length = drugArr.%Size()
	.for k=0:1:length-1  d
	..s drugObj = drugArr.%Get(k)
	..s drugName = drugObj.item
	..q:drugName=""
	..s onceDose = drugObj.OnceDose
	..s unit = drugObj.Unit
	..s formProp = drugObj.FormProp
	..s drugPreMet = drugObj.DrugPreMet
	..s drugFreq = drugObj.DrugFreq
	..i drugFreq="" s drugFreq=drugObj.DrugDrugFreq
	..s treatment = drugObj.Treatment
	..s seqNo = drugObj.SeqNo // 序号 qnp 2020/12/18
	..s drugOutParam = ##class(web.DHCCKBCalculateval).getExeOutParam(outParam, drugName, cat,funDesc,seqNo)    //获取审查结果
	..s libDrugId = ##Class(web.DHCCKBPassNew).GetComDicIdNew(drugName,"Drug",hospId)
	..s libDrugDesc = ""
	..s:libDrugId'="" libDrugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD($list(libDrugId,1))),3)
	..Q:(cat'="相互作用")&&(cat'="重复用药")&&(cat'="配伍禁忌")&&(libDrugDesc'=drug)
	..s remarks = "",exasignval = "" , exasign = ""   
	..s h = h+1
	..s groupiden = ""
	..i ((k=0)&&(length>1)) s groupiden = "<div style='margin-top:5px'><span style='color:#509DE1;font-size:20px;'>┎</span></div>"
	..i ((k>0)&&(k<(length-1))) s groupiden = "<div><span style='color:#509DE1;font-size:35px;'>│</span></div>"
	..i ((k=(length-1))&&(k>0)) s groupiden = "<div style='margin-top:2px;'><span style='color:#509DE1;font-size:20px;'>┖</span></div>"
	..s drugList = length_"^"_groupiden_"^"_drugName_"^"_onceDose_"^"_unit_"^"_formProp_"^"_drugPreMet_"^"_drugFreq_"^"_treatment
	..s mqlData = $g(^CKB.PDSS.MonQueListD(monItmId))
	..s remarks = $lg(mqlData,9)	 		//备注
	..s exasignval = $lg(mqlData,10)	//备注
	..s exasign = $s(exasignval="complet":"规则错误，已完成",exasignval="uwcomplet":"规则错误，未完成",exasignval="partcomp":"规则错误，部分完成",exasignval="partcompcon":"规则错误，部分完成，需用户确认",exasignval="partcompproame":"规则错误，部分完成，需修正程序",exasignval="partcompruleimp":"规则错误，部分完成，需完善规则",exasignval="partcompdicimp":"规则错误，部分完成，需完善字典",exasignval="verifycorrect":"规则正确，需验证",exasignval="affirmcorrect":"规则正确，需用户确认",exasignval="achievecorrect":"规则正确，已完成",1:"")
	..s funId = $lg(mqlData,25)
	..s funDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(funId)),3)
	..s outLen = $l(drugOutParam,"&")
	..for n=1:1:outLen    d
	...s outParams = $p(drugOutParam,"&",n)
	...;Q:outParams'[funDesc
	...s paraLen = $l(outParams)
	...s paNode = 0
	...s paNode = $s(paraLen>150:$e(outParams,1,150),paraLen=0:0,1:outParams) 
	...s dataList = monId_"^"_monItmId_"^"_patInfo_"^"_hisAllergyList_"^"_diagList_"^"_drugList_"^"_outParams
	...s dataList = dataList_"^"_remarks_"^"_exasignval_"^"_exasign_"^"_patNo_"^"_funId	
	...s ^TMP("DHCCKB","web.DHCCKBReviewDetails","QueryRevDetails",pid,h) = dataList
	b  //55
	s listTitle = "monId^monItmId^patName^sex^age^weight^hisAllergyList^diagList^drugNum^groupiden^drugName^onceDose"
	s listTitle = listTitle_"^unit^formProp^drugPreMet^drugFreq^treatment^drugOutParam^remarks^exasignval^exasign^patNo"
	s listTitle = listTitle_"^funId"
	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	
	s count = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBReviewDetails","QueryRevDetails",pid,index))  Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBReviewDetails","QueryRevDetails",pid,index)
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

}
