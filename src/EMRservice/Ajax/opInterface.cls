/// 门诊病历数据接口
Class EMRservice.Ajax.opInterface Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	
	s action=$g(%request.Data("action",1),"")

	if (action = "GetSavedRecord"){
		s AEpisodeID = $g(%request.Data("EpisodeID", 1), "")
		s ACTLocId = $g(%request.Data("UserLocID", 1), "")
		S ASSGroupID=$g(%request.Data("ssgroup", 1), "")
		s ACategoryID=$g(%request.Data("CategoryID", 1), "")
		s result = ..getSavedRecords(AEpisodeID, ACTLocId, ASSGroupID, ACategoryID)
		w result
	}
	elseif (action = "GetOPHistory")
	{
		s patientID = $Get(%request.Data("PatientID",1),"")
		s flag = $Get(%request.Data("Flag",1),"")
		s lastEpisodeID = $Get(%request.Data("LastEpisodeID",1),"")
		
		w ..GetOPHistory(patientID,flag,lastEpisodeID)
	}
	elseif (action = "getFirstInstance")
	{
		s episodeID = $Get(%request.Data("EpisodeID",1),"")	
		s ret=..getFirstInstance(episodeID)
		w ret
	}
	elseif(action = "IsExistInstance")   
	{
		s episodeID = $Get(%request.Data("EpisodeID",1),"")	
		s docId  = $Get(%request.Data("emrDocId",1),"")
		if (docId["&")  //个人模板即病历范例
		{
			s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId($tr(docId,"&",""))
			s docId = obj.ChartItemID
		}	
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
		if (objTemplate '= "")
		{
			s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(episodeID,objTemplate.ID,docId)
		}
		else
		{
			s result = "0"
		}
		w result
	}		
	elseif (action = "isSaved")  //EMRinstance.InstanceData
	{
		s ret="0"
		s insId=$Get(%request.Data("InstanceID",1),"")
		s ins=##Class(EMRinstance.InstanceData).%OpenId(insId)
		s:("Save"=ins.Status) ret="1"
		w ret
	}
	elseif (action = "GetTemplateIDByInsId") 
	{
		s insId=$Get(%request.Data("InstanceID",1),"")
		s ins=##Class(EMRinstance.InstanceData).%OpenId(insId)
		w ins.TemplateID.%Id()	
	}
	elseif (action = "getEMRTemplateIDBymodelId") 
	{
		s insId=$Get(%request.Data("modelId",1),"")
		s ins=##Class(EMRmeta.ModelInstanceData).%OpenId(insId)
		w ins.ChartItemID	
	}
	elseif (action = "getAllInstance")
	{
		s episodeID = $Get(%request.Data("EpisodeID",1),"")	
		s userID = $g(%request.Data("userId", 1), "")
		s ctLocId = $g(%request.Data("ctLocId", 1), "")
		s ssgroup = $g(%request.Data("ssgroup", 1), "")
		s ret=..getAllInstance(ctLocId, ssgroup, episodeID, userID)
		w ret
	}		
	elseif (action = "GetPatientInfoOP") //患者信息
	{
		s episodeID = $Get(%request.Data("EpisodeID",1),"")
		s patientID = $Get(%request.Data("PatientID",1),"")
		
		w ..GetPatientInfo(patientID,episodeID)
	}
	elseif (action = "GetFirstTmpl") //病历实例
	{
		s userLocID = $Get(%request.Data("userLocID",1),"")
		s episodeID = $Get(%request.Data("episodeID",1),"")
		s userID = $Get(%request.Data("userID",1),"")
		s ssgroup=$g(%request.Data("ssgroup", 1), "")
		s docID = $g(%request.Data("emrDocId", 1), "")
		s categoryID=$g(%request.Data("CategoryID", 1), "")
		s FirstTmpl = ..GetFirstTmpl(userLocID, ssgroup, episodeID, userID, docID, categoryID)
		w FirstTmpl
	}	
	elseif (action = "GetRecodeParam")
	{
		s EMRTmplCateid = $Get(%request.Data("EMRTmplCateid",1),"")
		w ..GetRecodeParam(EMRTmplCateid)	
	}
	elseif (action = "GetHisTools")	
	{
	 	w ..GetHisTools()
	}					
	elseif (action = "GetUnitLink")	// 链接单元的地址
	{
		s UnitOperation = $Get(%request.Data("UnitOperation",1),"")
	 	w ..GetUnitLink(UnitOperation)
	}		
	elseif (action = "GetOPSectionRes")		
	{
		s templateId = $Get(%request.Data("templateId",1),"")
		s sectionCode = $Get(%request.Data("sectionCode",1),"")
		w ..GetOPSectionRes(templateId, sectionCode) 
	}
	elseif (action = "GetOPResource")		
	{
		s visibleType = $Get(%request.Data("visibleType",1),"Panel")
		s tag = $Get(%request.Data("tag",1),"main2")
		w ..GetOPResource(visibleType, tag) 
	}
	elseif (action = "getOPEmrButtons")		
	{					
		s ret="btnSave:保  存;btnPrint:打  印;btnDelete:删  除;btnTemplateclassify:模板选择;btnSpechars:特殊符号;btnScaleEditor:放大;btnTest:测试;btnExportDocument:导出;btnUndo:撤销"
		s ret=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPEmrButtons",ret)
		w "{""Value"":"""_ret_"""}"
	}			
	else
	{
		w ""
	}
 
	Quit $$$OK
ErrorHandler
   w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
   Quit $$$OK
}

ClassMethod isSaved(insId As %String) As %String
{
	s ret="0"
	//s insId=$Get(%request.Data("InstanceID",1),"")
	s ins=##Class(EMRinstance.InstanceData).%OpenId(insId)
	s:("Save"=ins.Status) ret="1"
	q ret
}

ClassMethod IsExistInstance(episodeID, docId As %String = "") As %String
{
	if (docId["&")  //个人模板即病历范例
	{
		s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId($tr(docId,"&",""))
		s docId = obj.RealChartItemID
	}	
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	if (objTemplate '= "")
	{
		s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(episodeID,objTemplate.ID,docId)
	}
	else
	{
		s result = "0"
	}
	q result
}

ClassMethod getOPEmrButtons()
{
	s ret="btnSave:保  存;btnPrint:打  印;btnDelete:删  除;btnTemplateclassify:模板选择;btnSpechars:特殊符号;btnScaleEditor:放大;btnTest:测试;btnExportDocument:导出;btnUndo:撤销"
	s ret=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPEmrButtons",ret)
	q "{""Value"":"""_ret_"""}"
}

/// w ##Class(EMRservice.Ajax.patientInfo).GetPatientInfo()
ClassMethod GetPatientInfo(patientID As %String, episodeID As %String) As %String
{
	s patientInfo = ""
	s papmiNo = ""		//登记号
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s disBed = ""		//出院床位
	s payType = ""		//付费类型
	s admDate = ""		//入院日期
	s mainDiagnos = ""	//主要诊断
	s ipRecordNo = "" 	//病案号
	s Num= ""           //余额
	
	//取就诊信息
	if (episodeID '= "")&&(episodeID '= $C(0))
	{
		//取患者指针
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
		
		//年龄
		s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientID)
		s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID, "")
		s admDate = $P(admDate, ",", 1)
		s age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(episodeID,birthday,admDate,4)
		
		//出院床位
		s disBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(episodeID)
		
		//付费类型
		s payType =  ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
		s Num=##class(web.DHCDocOrderCommon).GetCurrentDeposit(episodeID)
		
		//入院日期
		s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = $zd(admDate,3)
		
		//主要诊断
		s mainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		if (mainDiagnos '= "")
		{	
			s mainDiagnos = $P(mainDiagnos,"^",3)
			s mainDiagnos = $tr(mainDiagnos,"'","\'")
		}
		
		s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName()
		s ipRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(episodeID, hospital)
	}
	
	s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID,hospital)
	s dept = $p(dept,"^",3)		
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		
		//姓名
		s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
		
		//性别
		s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
	}
		
	s patientInfo = """papmiNo"":"""_papmiNo_""",""name"":"""_name_""",""gender"":"""_gender_""",""disBed"":"""_disBed_""",""age"":"""_age_""",""mainDiagnos"":"""_mainDiagnos_""",""payType"":"""_payType_""",""admDate"":"""_admDate_""",""ipRecordNo"":"""_$g(ipRecordNo)_""",""birthday"":"""_$zd(birthday,3)_""",""dept"":"""_dept_""",""Num"":"""_Num_""""  
	//转换特殊字符
	s patientInfo = $ZSTRIP(patientInfo,"*C")
	q "{"_patientInfo_"}"
}

/// W ##Class(EMRservice.Ajax.opInterface).GetOPHistory("8376","0","")
/// W ##Class(EMRservice.Ajax.opInterface).GetOPHistory("8376","1","")
/// W ##Class(EMRservice.Ajax.opInterface).GetOPHistory(6923, 0, 9193)
/// flag:0\1\2 当前医生、当前科室、全院 flagArg: userID\userLocID\空
ClassMethod GetOPHistory(patientID, flag, lastEpisodeID As %String) As %String
{
	s opHistoryCount=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("opHistoryCount",3)
	//是否过滤掉未写门诊病历的记录
	s isFilterOPHistoryEmr=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isFilterOPHistoryEmr","N")	
	s isIncludeOeordHistory=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isIncludeOeordHistory","N")	
	//q ..getHistoryDetailTest()
	//s ^CacheTemp("GetOPHistory")=patientID_", "_flag_", "_lastEpisodeID
	s count = 0, result = "", episodeID = lastEpisodeID
	s:(0=flag) flagArg=%session.Get("LOGON.USERCODE")
	s:(1=flag) flagArg=%session.Get("LOGON.CTLOCID")
 	for {
	 	q:(count=opHistoryCount)
	 	s episodeID = $O(^PAPERdr(patientID,"ADM","O",episodeID),-1)
	 	q:(episodeID="")
 
 		d getDetails
 	}
 		
	q "{""total"":"_count_",""rows"":["_result_"]}"
 
getDetails //根据flag，过滤不符合条件的,获取详细的就诊信息
	if ("0"=flag)
	{
		s doc=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(episodeID)
		q:(flagArg'=$P($G(doc),"^",2))		
	} 
	elseif ("1"=flag)
	{
		s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
		q:(flagArg'=$P($G(dept),"^",1))	
	}
	
	s ret = ..getHistoryDetail(episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory)
	if (ret'="")
	{
		if (result'="") { s result=result_","_"{""record"":"""_ret_"""}" }
		else { s result = "{""record"":"""_ret_"""}" }
		s count=count+1
	}
}

ClassMethod getHistoryDetailTest() As %String
{
	s isIncludeOeordHistory=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isIncludeOeordHistory","Y")	
	s ret = "{""total"":3,""rows"":[{""record"":""<div class='admdate'>2016-01-05<span>14:21:29</span></div>"
	s ret = ret_"<div class='diag' admID='11411'><H3></H3><br><H4>病历未书写<div class='admloc'>"
	s ret = ret_"<span>针灸科门诊 医师:</span>&nbsp&nbsp<span id='doctor'></span><br/>"
	s:(isIncludeOeordHistory="Y") ret = ret_"<a class='oeord' admID='11411'>医嘱内容...</a>"
	s ret = ret_"<a class='emrdoc' admID='8651'>病历内容...</a></div>"
	s ret = ret_"</H4></div>""},{""record"":""<div class='admdate'>2016-01-05<span>14:21:23</span></div>"
	s ret = ret_"<div class='diag' admID='11411'><H3></H3><br><H4>初诊病历<div class='admloc'>"
	s ret = ret_"<span>针灸科门诊 医师:doctor</span>&nbsp&nbsp<span id='doctor'>蒋某某</span><br/><a class='emrdoc' admID='11411' admType='I'>详细内容...</a></div><br/><br/><br/><span class='content'><label class='chapter'>【主诉】</label><div class='text'>左侧口眼歪斜  天。</div><br/><label class='chapter'>【现病史】</label><div class='text'>缘患者  天前因吹风致左侧口眼歪斜， 左眼闭合不全，迎风流泪，噘嘴、鼓腮、吹气等动作受限，伴左耳后乳突部疼痛，左侧头痛，舌麻，左耳听觉过敏，未见疱疹，四肢活动正常。未予治疗。在本市某医院诊治，诊断为面神经麻痹，予激素、甲钴胺等治疗，疗效不显。</div><br/><label class='chapter'>【其他病史】</label><div class='text'>既往体健。{或病史描述}</div><br/><label class='chapter'>【体格检查】</label><div class='text'>左侧不完全性周围性面瘫面容。左侧贝尔氏征（＋）、吹气试验（＋）、左侧额纹、鼻唇沟变浅，左侧耳后乳突部压痛，未见疱疹。伸舌居中，四肢肌力正常，病理征（＋）。</div><br/><label class='chapter'>【辅助检查】</label><div class='text'>左侧不完全性周围性面瘫面容。左侧贝尔氏征（＋）、吹气试验（＋）、左侧额纹、鼻唇沟变浅，左侧耳后乳突部压痛，未见疱疹。伸舌居中，四肢肌力正常，病理征（＋）。</div></span><br/></H4></div>""},{""record"":""<div class='admdate'>2016-01-05<span>14:21:20</span></div><div class='diag' adm='10368448'><H3></H3><br><H4>病历未书写<div class='admloc'><span>简易门诊 医师:</span>&nbsp&nbsp<span id='doctor'></span><br/><a class='emrdoc'  admID='11411'>详细内容...</a></div></H4></div>""}]}"
	q ret
}

ClassMethod getHistoryDetail(admID As %String, filterOPHistoryEmr As %String = "", isIncludeOeordHistory As %String = "") As %String
{
	s hasInstance=##Class(EMRservice.Ajax.opInterface).getFirstInstance(admID)
	//过滤掉未写门诊病历的记录
	q:((hasInstance="")&&(filterOPHistoryEmr="Y")) ""
		
	s admDate = $P($G(^PAADM(admID)),"^",6)
	s admTime = $P($G(^PAADM(admID)),"^",7)
	s curDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(admID)
	s curDept = $P(curDept,"^",3)
	s diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(admID)
	s diagnosis = $P(diagnosis,"^",3)
	s doc=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(admID,"")
	s doc = $P($G(doc),"^",3)
	s admType = $p($g(^PAADM(admID)),"^",2)
	s:(hasInstance'="") hasInstance="<a class='emrdoc' admID='"_admID_"' admType='"_admType_"'>病历内容...</a>"
	
	s ret = "<div class='admdate'>"_$zd(admDate,3)_"<span>"_$zt(admTime,1)_"</span></div>"
	s ret = ret_"<div class='diag' admID='"_admID_"'>"
	s ret = ret_"<H3></H3><br>"
	s ret = ret_"<H4>"_diagnosis
	s ret = ret_"<div class='admloc'>"
	s ret = ret_"<span>"_curDept_"</span>&nbsp&nbsp<span name='doctor'>"_doc_"</span><br/>"
	s:(isIncludeOeordHistory="Y") ret = ret_"<a class='oeord' admID='"_admID_"'>医嘱内容...</a>"
	s ret = ret_hasInstance_"</div>"
	s ret = ret_"</H4></div>"
	//liuzhongwan 这里加了一个给半角单引号加转义符的操作。
	s ret = $replace(ret,"""","\""")

	q ret
}

/// w ##Class(EMRservice.Ajax.opInterface).GetRecodeParam("108")
ClassMethod GetRecodeParam(EMRTmplCateid As %String) As %String
{
	s ret=""
	
	if (EMRTmplCateid["&")  //个人模板即病历范例
	{
		s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId($tr(EMRTmplCateid,"&",""))
		s EMRTmplCateid = obj.RealChartItemID
	}		
	
	s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(EMRTmplCateid)

	s emrTmplid=$O(^DHCEMRM.EMRTemplateI("IdxCategoryID", " "_EMRTmplCateid, ""))
	q:(emrTmplid="") ret
	s emrTmpl=##Class(EMRmeta.EMRTemplate).%OpenId(emrTmplid)
	s tmplid = emrTmpl.BindTemplateID
	s tmpl = ##Class(EMRmeta.Template).%OpenId(tmplid)
	s cate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
		
	s ret = "{""id"":"""",""actionType"":""CREATE"",""categoryId"":"""_cate.ParentCategoryID_""","
	s ret = ret_"""chartItemType"":"""_tmpl.ChartItemType_""",""closable"":true,"
	s ret = ret_"""emrDocId"":"""_EMRTmplCateid_""",""isLeadframe"":"""_chapter.IsLeadframe_""","
	s ret = ret_"""isMutex"":"""_cate.IsMutex_""",""pluginType"":"""_tmpl.DocumentType_""","
	s ret = ret_"""status"":""NORMAL"",""templateId"":"""_tmpl.%Id()_""",""text"":"""_cate.CategoryName_"""}"
	q ret
}

/// w ##Class(EMRservice.Ajax.opInterface).GetRecodeParamToUserTemplate("108")
ClassMethod GetRecodeParamToUserTemplate(EMRTmplCateid As %String, ExampleInstanceID As %String) As %String
{
	s ret=""	
	s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(EMRTmplCateid)

	s emrTmplid=$O(^DHCEMRM.EMRTemplateI("IdxCategoryID", " "_EMRTmplCateid, ""))
	q:(emrTmplid="") ret
	s emrTmpl=##Class(EMRmeta.EMRTemplate).%OpenId(emrTmplid)
	s tmplid = emrTmpl.BindTemplateID
	s tmpl = ##Class(EMRmeta.Template).%OpenId(tmplid)
	s cate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
		
	s ret = "{""id"":"""",""actionType"":""CREATE"",""categoryId"":"""_cate.ParentCategoryID_""","
	s ret = ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
	s ret = ret_"""emrDocId"":"""_EMRTmplCateid_""",""isLeadframe"":"""_chapter.IsLeadframe_""","
	s ret = ret_"""isMutex"":"""_cate.IsMutex_""",""pluginType"":"""_tmpl.DocumentType_""","
	s ret = ret_"""status"":""NORMAL"",""templateId"":"""_tmpl.%Id()_""","
	s ret = ret_"""TemplateType"":""OpUserTemplate"",""ExampleInstanceID"":"""_ExampleInstanceID_""","
	s ret = ret_"""text"":"""_cate.CategoryName_"""}"
	q ret
}

ClassMethod GetRecodeParamByInsID(AInstanceID As %String) As %String
{
	s ret=""
	q:(AInstanceID = "") ret
	
	s InstanceData = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(InstanceData = "") ret
	s ECrecordID = $p(AInstanceID,"||",1)
	q:(ECrecordID = "") ret

	s TemplateID = InstanceData.RealTemplateID
	q:(TemplateID = "") ret
	s TemplateData = ##Class(EMRmeta.Template).%OpenId(TemplateID)
	q:(TemplateData = "") ret
	
	s ECRecordData = ##Class(EMRinstance.ECRecord).%OpenId(ECrecordID)
	q:(ECRecordData = "") ret
	s categoryId = ECRecordData.RealChartItemID
	s chapterdata = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryId)
	q:(chapterdata = "") ret
	s cate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapterdata.ParentCategoryID)
	q:(cate = "") ret

	s ret = "{""id"":"""_AInstanceID_""",""actionType"":""LOAD"",""categoryId"":"""_cate.ParentCategoryID_""","
	s ret = ret_"""chartItemType"":"""_TemplateData.ChartItemType_""",""closable"":true,"
	s ret = ret_"""emrDocId"":"""_categoryId_""",""isLeadframe"":"""_chapterdata.IsLeadframe_""","
	s ret = ret_"""isMutex"":"""_cate.IsMutex_""",""pluginType"":"""_TemplateData.DocumentType_""","
	s ret = ret_"""status"":""NORMAL"",""templateId"":"""_TemplateID_""",""text"":"""_InstanceData.Title_"""}"
	q ret
}

/// 获取门诊病历信息 todo
/// W ##Class(EMRservice.Ajax.opInterface).GetEMRRecordOP(1, 32, 11411, 2062)
ClassMethod GetEMRRecordOP(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String) As %String
{
	//s ret=..getFirstInstance(AEpisodeID)
	//q:(ret'="") ret
	
	q ..GetFirstTmpl(ACTLocId, ASSGroupID, AEpisodeID, AUserID)
}

/// w ##Class(EMRservice.Ajax.opInterface).getAllInstance(1, 32, 11411, 2062)
ClassMethod getAllInstance(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String) As %String
{
	s json = "",count = 0  //, ASchemType="Running"
	q:(ACTLocId = "")||(AEpisodeID = "")||(AUserID = "") json
	
	s ArrCate = ##Class(%ArrayOfDataTypes).%New()
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId, ASSGroupID, AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		d ArrCate.SetAt(categoryId, categoryId)
	}

	s ret=""
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
		q:(CategoryID="")
			
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ""))
		s id = "" 
		for {
			s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID",CategoryID, id))
			q:(id="")
			
			
			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
			
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
			s ecID = $tr(ecRecordID," ","")
		 
		 	s insID = ""
		 	for {
				s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID),-1)
		 		q:(""=insID)
		 	
		 		s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
		 		s cate=##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
		 		continue:(""=ArrCate.GetAt(cate.ParentCategoryID))
		
		 		//s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(insID)
				s item="{""id"":"""_ecID_"||"_insID_""","
				s item=item_"""actionType"":""LOAD"","
				s item=item_"""categoryId"":"""_cate.ParentCategoryID_""","
				s item=item_"""chartItemType"":"""_tmpl.ChartItemType_""","
				s item=item_"""closable"":true,"
				s item=item_"""emrDocId"":"""_emrTmpl.CategoryID_""","
				s item=item_"""isLeadframe"":"""_cate.IsLeadframe_""","
				s item=item_"""isMutex"":"""_chapter.IsMutex_""","
				s item=item_"""pluginType"":"""_tmpl.DocumentType_""","
				s item=item_"""status"":""NORMAL"","
				s item=item_"""templateId"":"""_emrTmpl.BindTemplateID_""","
				//s item=item_"""text"":"""_emrTmpl.TemplateName_"""}"
				//s item=item_"""text"":"""_objInstance.Title_"""}"
				s item=item_"""text"":"""_cate.CategoryName_"""}"
			
			if (ret="") { s ret=item} else { s ret=ret_","_item }
			}
		}	 	
	}
	
	q "["_ret_"]"
}

/// w ##Class(EMRservice.Ajax.opInterface).getFirstInstance("11411")
ClassMethod getFirstInstance(adm As %String) As %String
{
	s ret=""
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",adm, CategoryID))
		q:(CategoryID="")
		
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",adm, CategoryID, ""))
		
		s id = "" 
		for {
			s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_CategoryID, id))
			q:(id="")
			
			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
			s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
			continue:(chapter="")
		 	s cate=##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
			s ecID = $tr(ecRecordID," ","")
		 
			s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", ""),-1)
		 	continue:(""=insID)
			s ret="{""id"":"""_ecID_"||"_insID_""","
			s ret=ret_"""actionType"":""LOAD"","
			s ret=ret_"""categoryId"":"""_cate.ParentCategoryID_""","
			s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
			s ret=ret_"""closable"":true,"
			s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","
			s ret=ret_"""isLeadframe"":"""_cate.IsLeadframe_""","
			s ret=ret_"""isMutex"":"""_chapter.IsMutex_""","
			s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
			s ret=ret_"""status"":""NORMAL"","
			s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","
			s ret=ret_"""text"":"""_emrTmpl.TemplateName_"""}"
			q
		}	 	
	}
	
	q ret
}

/// w ##Class(EMRservice.Ajax.opInterface).GetFirstTmpl(1, 32, 11411, 2062)
ClassMethod GetFirstTmpl(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String, ADocID As %String = "", ACategoryID As %String = "") As %String
{
	s json = "",count = 0
	q:(ACTLocId = "")||(AEpisodeID = "")||(AUserID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId, ASSGroupID, AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		// 配置门诊病历页面传入病历导航分类目录CategoryID用于过滤模板数据
		continue:((ACategoryID'="")&&(ACategoryID'=categoryId))
		s cjson = ..GetTempCateJsonByCategoryID(categoryId,AEpisodeID,AUserID,ADocID)
		//当设置的默认加载模板无权限时，默认使用ALL类型的默认模板
		if (cjson="")
		{
			s cjson = ..GetTempCateJsonByCategoryID(categoryId,AEpisodeID,AUserID,"ALL")
		}
		continue:(cjson = "")
		
		s OPDefaultCreateTempType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPDefaultCreateTempType","UserTemplate")	
		if (OPDefaultCreateTempType = "Template"){
			s json=cjson
		} else {
			try{
				s Stream= ##Class(%GlobalCharacterStream).%New()
				d Stream.Write(cjson)
				s objJson = ##Class(EMRservice.Parser.Json).%New()  
				s tmpobj = objJson.Deserialize(Stream)
				
				s docID = tmpobj.GetAt("emrDocId")
				s userTemplateID = ##Class(EMRservice.BL.BLUserTemplate).GetFirstUserTemplateID(ACTLocId,docID,AEpisodeID,"")
				if (userTemplateID = ""){
					s json=cjson
				} else{
					s json = ##Class(EMRservice.Ajax.opInterface).GetRecodeParamToUserTemplate(docID,userTemplateID)
				}
			}catch{
				s json=cjson
			}
		}
		q:(json'="")
	}
	s json = $ZSTRIP(json,"*C")
	q json
}

ClassMethod GetTempCateJsonByCategoryID(ACTLocId As %String, AEpisodeID As %String, AUserID As %String, ADocID As %String = "") As %String
{
	s quitFlag = 0
	s json = "",count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((ACTLocId = "")||(AEpisodeID = "")) ""
	s priActivity = ##Class(EMRservice.BL.BLClientCategory).CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)

	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_ACTLocId,seq))
		q:(seq = "")
		s curCategoryId = ""
		s resultDocID =""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_ACTLocId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	       
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			//s curObjDocCategory = ##Class(EMRservice.BL.BLOPClientCategory).GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo, .resultDocID)
			//continue:(curObjDocCategory = "")
			//获取符号权限的DOCID集合已^分隔		
			s curDocIDS = ##Class(EMRservice.BL.BLOPClientCategory).GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo, .resultDocID)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ##Class(EMRservice.BL.BLOPClientCategory).GetEmrCategoryPropertyByDocID(strDocID)
			
				s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
				continue:(curEMRTemplategoryID = "")
				continue:((ADocID'="")&&(curEMRTemplategoryID '= ADocID))
			
				s curIsLeadframe = curObjDocCategory.IsLeadframe
		        s curObjDocCategory = ""  k curObjDocCategory
		        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
			    continue:(objTemplate = "")
		
			    /*s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
				
				if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
				{
					s:(curIsMutex = 1) flag = 1
					continue
				}*/
			
				s quotationFlag = $d(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",patDept,curEMRTemplategoryID))
				s cjson = "{"
				s cjson = cjson_ """emrDocId"":"""_curEMRTemplategoryID_""""
				s cjson = cjson_ ",""text"":"""_curCategoryName_""""
				s cjson = cjson_ ",""actionType"":""CREATE"""
				s cjson = cjson_ ",""type"":""TempCate""" 
				s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
				s cjson = cjson_ ",""pluginType"":"""_objTemplate.DocumentType_"""" 
				s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
				s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
				s cjson = cjson_ ",""templateId"":"""_objTemplate.ID_""""
				s cjson = cjson_ ",""status"":""NORMAL"""
				s cjson = cjson_ ",""categoryId"":"""_ACTLocId_""""
				s cjson = cjson_ ",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
				s cjson = cjson_ "}"
		
			 
				d jsonList.Insert(curIsMutex_"^"_cjson)
				s quitFlag=1
				q
			}
			q:(quitFlag=1)
		}
		q:(quitFlag=1)
	}
    s key = ""
    for
    {
	    s value = jsonList.GetNext(.key)
	    q:(key = "")
	    s curIsMutex = $p(value,"^",1)
	    continue:((flag = 1)&&(curIsMutex = 1))
	    s:(count '= 0) json = json_","
	    s json = json_$p(value,"^",2)
	    s count = count + 1
	}
	s json = $ZSTRIP(json,"*C")
    q json
}

///  w ##Class(EMRservice.Ajax.opInterface).getSavedRecords(11411,1,2062,32)
ClassMethod getSavedRecords(AEpisodeID, AUserLocID, ASSGroupID As %String, ACategoryID As %String = "") As %String
{
	s result = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s retCategory = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d retCategory.Execute(AUserLocID, ASSGroupID, AEpisodeID)
	while retCategory.%Next()
	{
		s ItemType = retCategory.Data("ItemType")
		continue:(ItemType = "HIS")
		s CategoryID = retCategory.Data("ItemCategoryID")
		// 配置门诊病历页面传入病历导航分类目录CategoryID用于过滤模板数据
		continue:((ACategoryID'="")&&(ACategoryID'=CategoryID))
		s docIds = ##class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(CategoryID)
		continue:(docIds="")
		s length = $l(docIds,",")
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId, ""))
			continue:(""=ecRecordID)
			s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecRecordID)
			s count = objECRecord.InstanceCount
			q:(0=count)
			
			s emrTmplId = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_docId, ""))
			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(emrTmplId)
			s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
			s cateChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(tempCate.ParentCategoryID)
			//s cate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(cateChapter.ParentCategoryID)
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)		
			s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",cateChapter.CategoryName,langid)	
			s categoryNameTemp = categoryName
			
			if (("Multiple"=tmpl.ChartItemType) && ("1"=tempCate.IsLeadframe))
			{
				s idx = count
				for 
				{
					q:(idx=0)
					s objInstance = objECRecord.Instances.GetAt(idx)
					if ("Save" = objInstance.Status)
					{
						if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.SystemParameter||getPlantToothTreatmentCategoryId") '= "0")
						{
							s plantTreatmentCategoryId = ##Class(EMRservice.SystemParameter).getPlantToothTreatmentCategoryId()
							if (cateChapter.ParentCategoryID = plantTreatmentCategoryId) //如果是种植牙病历，名称上需要加上疗程名称
							{
								s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_objInstance.%Id(),""))
								s treatmentInstanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
								if (treatmentInstanceIdObj.IsActive=1)
								s patientId = $p($g(^PAADM(AEpisodeID)),"^",1)
								s plantTreatmentRowId = ""
								for 
								{
									s plantTreatmentRowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_patientId,plantTreatmentRowId))
									q:(plantTreatmentRowId="")
									s plantTreatmentobj = ##class(EMRinstance.PlantToothTreatment).%OpenId(plantTreatmentRowId)
									q:(plantTreatmentobj="")
									if (plantTreatmentobj.TreatmentID = treatmentInstanceIdObj.TreatmengId)
									{
										s categoryNameTemp = plantTreatmentobj.Name_"-"_categoryName
										q
									}
								}
							}
						}
						
						s isPrint = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(objInstance.RealEpisodeID,objInstance.%Id(),"Print")
						s:(isPrint = "1") categoryNameTemp = categoryNameTemp_"（已打印）"
						
						//指定病历实例是否有对应患者签名后的PDF文档
    					s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(objInstance.%Id(), objInstance.RealEpisodeID)
    					s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
						
						s ret="{""id"":"""_objInstance.%Id()_""","
						s ret=ret_"""actionType"":""LOAD"","
						s ret=ret_"""categoryId"":"""_cateChapter.ParentCategoryID_""","
						s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
						s ret=ret_"""closable"":true,"
						s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","   //emrTmpl.%Id()
						s ret=ret_"""isLeadframe"":"""_tempCate.IsLeadframe_""","
						s ret=ret_"""isMutex"":"""_cateChapter.IsMutex_""","
						s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
						s ret=ret_"""status"":""NORMAL"","			
						s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","
						s ret=ret_"""pdfDocType"":"""_pdfDocType_""","							
						s ret=ret_"""text"":"""_categoryNameTemp_"""}"
						
						//可重复不换页，有引导窗的模板加载第一个
						if (result="") { s result=ret }
						else { s result=result_","_ret }
						q
					}
					s idx = idx - 1
				} 
			}
			else
			{
				s idx = 1
				for 
				{
					q:(idx>count)
					s objInstance = objECRecord.Instances.GetAt(idx)
					if ("Save" = objInstance.Status)
					{
						if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.SystemParameter||getPlantToothTreatmentCategoryId") '= "0")
						{
							s plantTreatmentCategoryId = ##Class(EMRservice.SystemParameter).getPlantToothTreatmentCategoryId()
							if (cateChapter.ParentCategoryID = plantTreatmentCategoryId) //如果是种植牙病历，名称上需要加上疗程名称
							{
								s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_objInstance.%Id(),""))
								s treatmentInstanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
								if (treatmentInstanceIdObj.IsActive=1)
								s patientId = $p($g(^PAADM(AEpisodeID)),"^",1)
								s plantTreatmentRowId = ""
								for 
								{
									s plantTreatmentRowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_patientId,plantTreatmentRowId))
									q:(plantTreatmentRowId="")
									s plantTreatmentobj = ##class(EMRinstance.PlantToothTreatment).%OpenId(plantTreatmentRowId)
									q:(plantTreatmentobj="")
									if (plantTreatmentobj.TreatmentID = treatmentInstanceIdObj.TreatmengId)
									{
										s categoryNameTemp = plantTreatmentobj.Name_"-"_categoryName
										q
									}
								}
							}
						}
						
						s isPrint = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(objInstance.RealEpisodeID,objInstance.%Id(),"Print")
						s:(isPrint = "1") categoryNameTemp = categoryNameTemp_"（已打印）"
						
						//指定病历实例是否有对应患者签名后的PDF文档
    					s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(objInstance.%Id(), objInstance.RealEpisodeID)
    					s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
						
						s ret="{""id"":"""_objInstance.%Id()_""","
						s ret=ret_"""actionType"":""LOAD"","
						s ret=ret_"""categoryId"":"""_cateChapter.ParentCategoryID_""","
						s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
						s ret=ret_"""closable"":true,"
						s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","   //emrTmpl.%Id()
						s ret=ret_"""isLeadframe"":"""_tempCate.IsLeadframe_""","
						s ret=ret_"""isMutex"":"""_cateChapter.IsMutex_""","
						s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
						s ret=ret_"""status"":""NORMAL"","			
						s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","	
						s ret=ret_"""pdfDocType"":"""_pdfDocType_""","		
						s ret=ret_"""text"":"""_categoryNameTemp_"""}"

						if (result="") { s result=ret }
						else { s result=result_","_ret }
					}
					s idx = idx + 1
				} 
			}
		}
	}
	
	q "["_result_"]"
}

ClassMethod getSavedRecord(AEpisodeID, AUserLocID, ASSGroupID As %String, arrResult As %ArrayOfDataTypes)
{
	s result=""
	s CategoryID = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}

	s ArrCate = ##Class(%ArrayOfDataTypes).%New()
	s retCategory = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d retCategory.Execute(AUserLocID, ASSGroupID, AEpisodeID)
	while retCategory.%Next()
	{
		s ItemType = retCategory.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = retCategory.Data("ItemCategoryID")
		d ArrCate.SetAt(categoryId, categoryId)
	}

	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
		q:(CategoryID="")
		//continue:(""=ArrTemplate.GetAt($tr(CategoryID," ","")))
		
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ""))
		
		s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecRecordID)
		s count = objECRecord.InstanceCount
		q:(0=count)
		
		s emrTmplId = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID", CategoryID, ""))
		s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(emrTmplId)
		s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
		s cateChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(tempCate.ParentCategoryID)
		//s cate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(cateChapter.ParentCategoryID)
		continue:(""=ArrCate.GetAt(cateChapter.ParentCategoryID))
		s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)	
		s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",cateChapter.CategoryName,langid)	
		s categoryNameTemp = categoryName
		
		if (("Multiple"=tmpl.ChartItemType) && ("1"=tempCate.IsLeadframe))
		{
			s idx = count
			for 
			{
				q:(idx=0)
				s objInstance = objECRecord.Instances.GetAt(idx)
				if ("Save" = objInstance.Status)
				{
					if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.SystemParameter||getPlantToothTreatmentCategoryId") '= "0")
					{
						s plantTreatmentCategoryId = ##Class(EMRservice.SystemParameter).getPlantToothTreatmentCategoryId()
						if (cateChapter.ParentCategoryID = plantTreatmentCategoryId) //如果是种植牙病历，名称上需要加上疗程名称
						{
							s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_objInstance.%Id(),""))
							s treatmentInstanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
							if (treatmentInstanceIdObj.IsActive=1)
							s patientId = $p($g(^PAADM(AEpisodeID)),"^",1)
							s plantTreatmentRowId = ""
							for 
							{
								s plantTreatmentRowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_patientId,plantTreatmentRowId))
								q:(plantTreatmentRowId="")
								s plantTreatmentobj = ##class(EMRinstance.PlantToothTreatment).%OpenId(plantTreatmentRowId)
								q:(plantTreatmentobj="")
								if (plantTreatmentobj.TreatmentID = treatmentInstanceIdObj.TreatmengId)
								{
									s categoryNameTemp = plantTreatmentobj.Name_"-"_categoryName
									q
								}
							}
						}
					}
					
					s isPrint = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(objInstance.RealEpisodeID,objInstance.%Id(),"Print")
					s:(isPrint = "1") categoryNameTemp = categoryNameTemp_"（已打印）"
				
					s ret="{""id"":"""_objInstance.%Id()_""","
					s ret=ret_"""actionType"":""LOAD"","
					s ret=ret_"""categoryId"":"""_cateChapter.ParentCategoryID_""","
					s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
					s ret=ret_"""closable"":true,"
					s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","   //emrTmpl.%Id()
					s ret=ret_"""isLeadframe"":"""_tempCate.IsLeadframe_""","
					s ret=ret_"""isMutex"":"""_cateChapter.IsMutex_""","
					s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
					s ret=ret_"""status"":""NORMAL"","			
					s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","			
					s ret=ret_"""text"":"""_categoryNameTemp_"""}"
					
					s item = arrResult.GetAt(cateChapter.CategorySeq)
					if (item="") { s item = ret }
					else { s item = item_","_ret }
					d arrResult.SetAt(item, cateChapter.CategorySeq)
					//可重复不换页，有引导窗的模板加载第一个
					q
				}
				s idx = idx - 1
			} 
		}
		else
		{
			s idx = 1
			for 
			{
				q:(idx>count)
				s objInstance = objECRecord.Instances.GetAt(idx)
				if ("Save" = objInstance.Status)
				{
					if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.SystemParameter||getPlantToothTreatmentCategoryId") '= "0")
					{
						s plantTreatmentCategoryId = ##Class(EMRservice.SystemParameter).getPlantToothTreatmentCategoryId()
						if (cateChapter.ParentCategoryID = plantTreatmentCategoryId) //如果是种植牙病历，名称上需要加上疗程名称
						{
							s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_objInstance.%Id(),""))
							s treatmentInstanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
							if (treatmentInstanceIdObj.IsActive=1)
							s patientId = $p($g(^PAADM(AEpisodeID)),"^",1)
							s plantTreatmentRowId = ""
							for 
							{
								s plantTreatmentRowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_patientId,plantTreatmentRowId))
								q:(plantTreatmentRowId="")
								s plantTreatmentobj = ##class(EMRinstance.PlantToothTreatment).%OpenId(plantTreatmentRowId)
								q:(plantTreatmentobj="")
								if (plantTreatmentobj.TreatmentID = treatmentInstanceIdObj.TreatmengId)
								{
									s categoryNameTemp = plantTreatmentobj.Name_"-"_categoryName
									q
								}
							}
						}
					}
					
					s isPrint = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(objInstance.RealEpisodeID,objInstance.%Id(),"Print")
					s:(isPrint = "1") categoryNameTemp = categoryNameTemp_"（已打印）"
				
					s ret="{""id"":"""_objInstance.%Id()_""","
					s ret=ret_"""actionType"":""LOAD"","
					s ret=ret_"""categoryId"":"""_cateChapter.ParentCategoryID_""","
					s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
					s ret=ret_"""closable"":true,"
					s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","   //emrTmpl.%Id()
					s ret=ret_"""isLeadframe"":"""_tempCate.IsLeadframe_""","
					s ret=ret_"""isMutex"":"""_cateChapter.IsMutex_""","
					s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
					s ret=ret_"""status"":""NORMAL"","			
					s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","			
					s ret=ret_"""text"":"""_categoryNameTemp_"""}"
					//s ret=ret_"""text"":"""_emrTmpl.TemplateName_"""}"

					s item = arrResult.GetAt(cateChapter.CategorySeq)
					if (item="") { s item = ret }
					else { s item = item_","_ret }
					d arrResult.SetAt(item, cateChapter.CategorySeq)
					//可重复不换页，有引导窗的模板加载第一个
					//q:(("Multiple"=tmpl.ChartItemType) && ("1"=tempCate.IsLeadframe))
				}
				s idx = idx + 1
			} 
		}
	}
}

/// w ##Class(EMRservice.Ajax.opInterface).GetUnitLink("oeord")
ClassMethod GetUnitLink(UnitOperation As %String) As %String
{
	/*s id=$O(^DHCEMRM.OPHisToolsI("IdxName"," "_$zcvt(UnitOperation,"U"),""))
	q:(""=id) ""
	s obj = ##Class(EMRmeta.OPHisTools).%OpenId(id)
	q obj.Link*/
	
	
	s id=$O(^DHCEMRM.OPUnitLinkI("IdxName"," "_$zcvt(UnitOperation,"U"),""))
	q:(""=id) ""
	s obj = ##Class(EMRmeta.OPUnitLink).%OpenId(id)
	q "{""Title"":"""_obj.Title_""",""Link"":"""_obj.Link_""",""Method"":"""_obj.Method_""",""IsDirectOpen"":"""_obj.IsDirectOpen_"""}"
}

/// w ##Class(EMRservice.Ajax.opInterface).GetOPResource("Panel")
ClassMethod GetOPResource(visibleType As %String, tag As %String = "main") As %String
{
	s ret = ""
	
	if ("main2"=tag) {
		&sql(declare curOPResource2 cursor for 
			select Name,Title,Frame,Content,Href
			from EMRmeta.OPResource2 where Visible=:visibleType order by Position)	
		&sql(open curOPResource2)
		for {
			&sql(fetch curOPResource2 into :Name,:Title,:Frame,:Content,:Href)
   	     quit:SQLCODE
   	     s item="{""Name"":"""_Name_""",""Title"":"""_Title_""",""Frame"":"""_Frame_""",""Content"":"""_Content_""",""Href"":"""_Href_"""}"
			if (ret'="") { s ret = ret_","_item }
			else { s ret = item }	
		}
		&sql(close curOPResource2)						
	}
	else {
		&sql(declare curOPResource cursor for 
			select Name,Title,Frame,Content,Href
			from EMRmeta.OPResource where Visible=:visibleType order by Position)	
		&sql(open curOPResource)
		for {
			&sql(fetch curOPResource into :Name,:Title,:Frame,:Content,:Href)
   	     quit:SQLCODE
   	     s item="{""Name"":"""_Name_""",""Title"":"""_Title_""",""Frame"":"""_Frame_""",""Content"":"""_Content_""",""Href"":"""_Href_"""}"
			if (ret'="") { s ret = ret_","_item }
			else { s ret = item }	
		}
		&sql(close curOPResource)					
	}
	
	if (ret'="") { s ret = "["_ret_"]" }
	q ret
}

/// w ##Class(EMRservice.Ajax.opInterface).GetHisTools()
ClassMethod GetHisTools() As %String
{
	s ret = ""
	&sql(declare curHisTool cursor for 
		select Name,Position,Text,ColSpan,Link,Background,Color,FormWidth,FormHeight
		from EMRmeta.OPHisTools where Visible='Y' order by Position)  //1=2

	&sql(open curHisTool)
	for {
		&sql(fetch curHisTool into :Name,:Position,:Text,:ColSpan,:Link,:Background,:Color,:FormWidth,:FormHeight)
        quit:SQLCODE  
        s:(Color="") Color="#FFFFFF"
        s item="{""Name"":"""_Name_""",""Position"":"_Position_",""Text"":"""_Text_""",""ColSpan"":"_ColSpan_",""Link"":"""_Link_""",""Background"":"""_Background_""",""Color"":"""_Color_""",""FormWidth"":"""_FormWidth_""",""FormHeight"":"""_FormHeight_"""}"
		if (ret'="") { s ret = ret_","_item }
		else { s ret = item }	
	}
	&sql(close curHisTool)	
	if (ret'="") { s ret = "["_ret_"]" }
	q ret
}

/// w ##Class(EMRservice.Ajax.opInterface).GetOPSectionRes("44","S002")
ClassMethod GetOPSectionRes(templateId, sectionCode) As %String
{
	q:(""=templateId)||(""=sectionCode) ""
	
	s id = $O(^DHCEMRM.OPSectionResI("IdxSec"," "_$zcvt(templateId,"U")," "_$zcvt(sectionCode,"U"),""))
	q:(""=id) ""	
	
	s obj = ##Class(EMRmeta.OPSectionRes).%OpenId(id)
	s id = $O(^DHCEMRM.OPResourceI("IdxName"," "_$zcvt(obj.Resource,"U"),""))
	q:(""=id) ""
	s obj = ##Class(EMRmeta.OPResource).%OpenId(id)
	q "{""Title"":"""_obj.Title_""",""Name"":"""_obj.Name_"""}"
}

/// w ##Class(EMRservice.Ajax.opInterface).LogFlagInfo("4366||1")
ClassMethod LogFlagInfo(instanceId As %String = "") As %String
{
    s result=""
    q:(instanceId="") result
    s ECRecord=$p(instanceId,"||",1)
    s Num=$p(instanceId,"||",2)
    s arr=##Class(EMRinstance.ECRecord).%OpenId(ECRecord)
	q:(arr="") result
    s ChartItemID=arr.RealChartItemID

    s result=ChartItemID_"^"_Num
    q result
}

ClassMethod getAdmByInstanceID(insId As %String) As %String
{
	s result = ""
	q:(insId = "") result
	s ins=##Class(EMRinstance.InstanceData).%OpenId(insId)
	q:(ins = "") result
	s result = ins.RealEpisodeID
	q result
}

/// DESC:   根据系统参数OPTmplDocId获取指定默认加载模板docId
/// input： ACTLocId 科室ID
/// output: 获取指定默认加载模板docId
/// ##class(EMRservice.Ajax.opInterface).getEMRDocID(4)
ClassMethod getEMRDocID(ACTLocId As %String) As %String
{
	s docId = ""
	q:(ACTLocId = "") docId
	//OPTmplDocId "CTLocID^ALL!DocID^102" 或 "CTLocID^6!DocID^102|CTLocId^5!DocID^104"
	s tmpl = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPTmplDocId","")
	s count = $l(tmpl,"|")
	for i=1:1:count
	{
		s recordName = "",recordData = ""
		s recordList = ##class(EMRservice.BL.BLPrivRule).ParseEnvInfo($p(tmpl,"|",i),.recordName,.recordData)
		s ctlocId = $lg(recordData,$lf(recordName,"CTLocID"))
		if ("ALL" = ctlocId) {
			s docId = $lg(recordData,$lf(recordName,"DocID"))
		}else {
			continue:(ACTLocId '= ctlocId)
			s docId = $lg(recordData,$lf(recordName,"DocID"))
		}
	}
	q docId
}

Storage Default
{
<Data name="opInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EMRservice.Ajax.opInterfaceD</DataLocation>
<DefaultData>opInterfaceDefaultData</DefaultData>
<IdLocation>^EMRservice.Ajax.opInterfaceD</IdLocation>
<IndexLocation>^EMRservice.Ajax.opInterfaceI</IndexLocation>
<StreamLocation>^EMRservice.Ajax.opInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
