Import sqluser

Class web.DHCCKBRecipeAuditStat Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 处方审核记录统计
/// Input：	       params:开始日期^结束日期^类型
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).RecipeAuditStat(10,1,"2021-10-07^2021-10-13")
ClassMethod RecipeAuditStat(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("RecipeAuditStat")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	s Type = $p(params,"^",3)    // 按科室（Loc），医生（Doctor），药品统计（Drug）
	q:Type="" ""
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ERRPRESC",pid)
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid)
	s h=0,count=0
	s ret = ..getRecipeData(pid,stDate,endDate)    //获取审核处方数据
	s h = $p(ret,"^",1)							// 审核总次数
	s auditTotalNum = $p(ret,"^",2)				// 服务总数：时间范围内审核的药品数量
	s prescTotalNum = $p(ret,"^",3)				// 处方数量：实际入库的处方数量
	s errorprescTotalNum = $p(ret,"^",4)		// 药品错误次数：审查出的提示药品数量
	s mandatoryAuditTotalNum = $p(ret,"^",5)	// 强制审核次数：强制审核的处方数量
	s modifyTotalNum = $p(ret,"^",6)			// 修改次数：修改的处方数量
	s submitTotalNum	= $p(ret,"^",7)					// 提交处方总数
	w "{""rows"":["
	s listTitle ="locName^auditNum^prescNum^errorprescNum^mandatoryauditNum^modifyNum^submitNum^modifyRate^errorNum^mandatoryauditRate^errorRate"
	
	s locDesc = ""
	f  s locDesc = $o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc)) Q:(locDesc="")||(Type="Drug")  d
	.s auditNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"AuditNum"))
	.s prescNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"prescNum"))
	.s errorprescNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"ERRPRESCNum"))
	.s mandatoryauditNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"MandatoryAuditNum"))  // 强制审核次数：强制审核的处方数量
	.s modifyNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"modifyNum"))		// 修改次数：修改的处方数量
	.s submitNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"submitNum"))  	// 提交处方总数
	.s errorNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,locDesc,"errorNum"))  		// 错误处方总数
	.s modifyRate="",mandatoryauditRate="",errorRate=""
	.i submitNum'=0 d
	..s modifyRate=$fn(modifyNum/submitNum*100,"",2)_"%"												// 医生修改率
	..s mandatoryauditRate=$fn(mandatoryauditNum/submitNum*100,"",2)_"%"								// 医生强制审核率
	..s errorRate=$fn(errorNum/submitNum*100,"",2)_"%"												// 不合格率
	.s list = locDesc_"^"_auditNum_"^"_prescNum_"^"_errorprescNum_"^"_mandatoryauditNum_"^"_modifyNum_"^"_submitNum_"^"_modifyRate_"^"_errorNum_"^"_mandatoryauditRate
	.s list = list_"^"_errorRate
	.s count=count+1
	.b ;2332	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	b ;221
	s drugTitle="drugName^totalNum^errorNum^errorRate"
	//统计药品相关数量
	s Drug = ""
	f  s Drug = $o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,Drug)) Q:(Drug="")||(Type'="Drug")  d
	.s drugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(Drug)),3)
	.s totalNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,Drug,"TotalNum"))
	.s errorNum=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid,Drug,"ErrorNum"))
	.s errorRate=""
	.i totalNum'=0 d
	..s errorRate=$fn(errorNum/totalNum*100,"",2)_"%"					// 药品不合理率

	.s list = drugName_"^"_totalNum_"^"_errorNum_"^"_errorRate
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(drugTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(drugTitle,list)
	
 	w "],""total"":"_count
 	w ",""auditTotalNum"":"_auditTotalNum_",""prescNum"":"_prescTotalNum_",""errorprescNum"":"_errorprescTotalNum_",""mandatoryAuditNum"":"_mandatoryAuditTotalNum_",""modifyNum"":"_modifyTotalNum
 	w ",""submitTotalNum"":"_submitTotalNum
 	w "}"
 	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ERRPRESC",pid)
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",Type,pid)
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 获取审核处方数据
/// Input：	       stDate:开始日期，endDate:结束日期,pid
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).getRecipeData()
ClassMethod getRecipeData(pid, stDate, endDate)
{
	n (pid,stDate,endDate)
	s h = 0,tmpCount = 0,count = 0
	s auditTotalNum = 0  	// 服务总数(时间范围内审核的药品数量)
	s prescNum = 0 	  	 	// 处方数量(实际入库的处方数量)
	s errorprescNum = 0  	// 药品错误次数(审查出的提示药品数量)
	s MandatoryAuditNum = 0 // 强制审核数量
	s modifyNum = 0  	 	// 修改次数：修改的处方数量
	s submitNum = 0 		// 提交总数
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)    // 就诊id
	..q:EpisodeID=""
	..s PatientID=$P(^PAADM(EpisodeID),"^",1) 
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	..s Loc = $lg(monData,6) 		  // 科室
	..q:Loc=""
	..s createUser = $lg(monData,5)   // 医生
	..s passFlag = $lg(monData,7) // 审查结果
	..s exaParam = $lg(monData,9)	  // 入参
	..q:exaParam["UNDEFINED"
	..s submitNum = submitNum + 1 				  // 提交总数
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	..s drugArr = exaParamObj.%Get("Drug")	
	..s length = drugArr.%Size()
	..f len=0:1:length-1  d
	...s drugObj = drugArr.%Get(len)
	...s drugName = drugObj.item
	...q:drugName=""
	...s libvalue=##class(web.DHCCKBPassNew).GetComDicIdNew(drugName,"Drug")	//(Drug,Ext) 记录的是没有对照的药品
	...s libvalue=$listget(libvalue)	 // 药品只能对照一个
	...q:libvalue=""
	...// 统计各药品数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,libvalue,"TotalNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,libvalue,"TotalNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,libvalue,"TotalNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,libvalue,"TotalNum")+1
	
	
	..s auditTotalNum = auditTotalNum+length	  // 审核总数
	..// 按科室获取审核药品总数
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"AuditNum")) d	
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"AuditNum")=length
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"AuditNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"AuditNum")+length
	
	..// 按医生获取审核药品总数
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"AuditNum")) d	
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"AuditNum")=length
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"AuditNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"AuditNum")+length
	
	..// 按科室获取审核处方总数
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"submitNum")) d	
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"submitNum")=1
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"submitNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"submitNum")+1
	
	..// 按医生获取审核处方总数
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"submitNum")) d	
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"submitNum")=1
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"submitNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"submitNum")+1

	..s CMPrescFlag = $lg(^CKB.PDSS.MonMasterD(monId),16) // 是否生成处方标志(Y/N) 
	..i CMPrescFlag="Y" d
	...s prescNum = prescNum + 1	  			  // 处方数量
	...// 按科室获取强制审核数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"prescNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"prescNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"prescNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"prescNum")+1
	
	...// 按医生获取处方数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"prescNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"prescNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"prescNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"prescNum")+1

	..s CMPassType = $lg(^CKB.PDSS.MonMasterD(monId),15)  	// 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
	...s MandatoryAuditNum = MandatoryAuditNum + 1	// 强制审核数量 
	...// 按科室获取强制审核数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"MandatoryAuditNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"MandatoryAuditNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"MandatoryAuditNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"MandatoryAuditNum")+1
	...// 按医生获取强制审核数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"MandatoryAuditNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"MandatoryAuditNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"MandatoryAuditNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"MandatoryAuditNum")+1
	
	
	..s CMLastId = $lg(^CKB.PDSS.MonMasterD(monId),18)  // 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s modifyNum = modifyNum + 1 // 修改次数：修改的处方数量
	...b ;89
	...// 按科室获取修改次数：修改的处方数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"modifyNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"modifyNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"modifyNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"modifyNum")+1
	
	...// 按科室获取修改次数：修改的处方数量
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"modifyNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"modifyNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"modifyNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"modifyNum")+1
	
	
	..q:passFlag'="0"  //下面是计算没通过的错误处方数
	
	..// 按科室获取错误处方总数
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"errorNum")) d	
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"errorNum")=1
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"errorNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"errorNum")+1
	
	..// 按医生获取错误处方总数
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"errorNum")) d	
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"errorNum")=1
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"errorNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"errorNum")+1
	
	
	..s monItmId = ""	
	..f  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s count=count+1
	...s itmId = $lg(^CKB.PDSS.MonQueListD(monItmId),3)	//药品名称
	...Q:'$d(^CT.CKB.PDSS.CommonDictionD(itmId))
	...//统计药品错误数量（按药品）
	...;统计错误药品数量，同一个药品提醒多次，算药品错误一次
	...q:$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","DrugStat",pid,monId,itmId)) 
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","DrugStat",pid,monId,itmId) = ""
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,itmId,"ErrorNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,itmId,"ErrorNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,itmId,"ErrorNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Drug",pid,itmId,"ErrorNum")+1
	
	
	...s catId = $lg(^CKB.PDSS.MonQueListD(monItmId),4)	//目录id
	...s catCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),2)
	...;Q:catCode="HighDangerDrug"
	...;b ;8
	...;统计错误处方数量，同一个药品错误一次，算一个错误处方数
	...q:$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ERRPRESC",pid,monId,itmId)) 
	...s errorprescNum = errorprescNum+1		// 药品错误次数
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ERRPRESC",pid,monId,itmId) = ""
	...// 按科室获取错误处方数
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"ERRPRESCNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"ERRPRESCNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"ERRPRESCNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","LOC",pid,Loc,"ERRPRESCNum")+1
	
	...// 按医生获取错误处方数
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"ERRPRESCNum")) d	
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"ERRPRESCNum")=1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"ERRPRESCNum")=^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","Doctor",pid,createUser,"ERRPRESCNum")+1

	
	q h_"^"_auditTotalNum_"^"_prescNum_"^"_errorprescNum_"^"_MandatoryAuditNum_"^"_modifyNum_"^"_submitNum
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 处方审核记录统计明细
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).RecipeAuditDetail(10,1,"2021-06-01^2021-06-18")
ClassMethod RecipeAuditDetail(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("RecipeAuditDetail")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s regNo = $p(params,"^",1)   // 登记号
	s stDate = $p(params,"^",2)	 // 开始日期
	s endDate = $p(params,"^",3) // 结束日期
	s locName = $p(params,"^",4) // 科室名称
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s h=0,count=0
	s listTitle ="locName^patName^seqNo^regNo^PAAdmDate^CMCreateDate^CMCreateTime^monId^Diagnosis"
	w "{""rows"":["
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)     	  // 就诊id
	..q:EpisodeID=""
	..s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	..s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	..s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	..s mradm=$P(^PAADM(EpisodeID),"^",61) 
	..s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	..s Loc =$lg(monData,6)		    // 科室
	..q:(Loc'=locName)||(PatNo'=regNo)
	..s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	..s CMCreateDate = $lg(monData,3)  // 创建日期 
	..s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	..s CMCreateTime = $lg(monData,4)  // 创建时间
	..s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	..s CMExaParam = $lg(monData,9)  // 审查内容 
	..s CMExaRes = $lg(monData,10)  // 审查结果
	
	..s count=count+1	
	..s list = Loc_"^"_PatName_"^"_count_"^"_PatNo_"^"_PAAdmDate_"^"_CMCreateDate_"^"_CMCreateTime_"^"_monId_"^"_Diagnosis
	..i count=Start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count_"}"
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 强制审核记录统计明细
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).MandatoryAuditDetail(10,1,"2021-06-01^2021-06-18")
ClassMethod MandatoryAuditDetail(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("MandatoryAuditDetail")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)	 // 开始日期
	s endDate = $p(params,"^",2) // 结束日期
	s locName = $p(params,"^",3) // 科室名称	
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s docName=""
	s type = $p(params,"^",4) // 科室名称
	i type="Doc" d
	.s docName=locName
	.s locName=""
	
	s h=0,count=0
	s listTitle ="locName^patName^seqNo^regNo^PAAdmDate^CMCreateDate^CMCreateTime^monId^Diagnosis^PatSex^PatAge"
	w "{""rows"":["
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(MonData,2)     	  // 就诊id
	..q:EpisodeID=""
	..s mradm=$P(^PAADM(EpisodeID),"^",61) 
	..s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	..s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	..s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	..s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	..s Loc = $lg(MonData,6) 		    // 科室
	..q:(locName'="")&&(locName'="undefined")&&(locName'=Loc)
	..s createUser = $lg(MonData,5)   // 医生
	..q:(docName'="")&&(docName'=createUser)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)   /// 年龄
	..s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	..s CMCreateDate = $lg(MonData,3)  // 创建日期 
	..s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	..s CMCreateTime = $lg(MonData,4)  // 创建时间
	..s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	..s CMExaParam = $lg(MonData,9)  // 审查内容 
	..s CMExaRes = $lg(MonData,10)  // 审查结果
	..s CMPassType = $lg(MonData,15) // 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..q:CMPassType'="R" 
	..s count=count+1	
	..s list = Loc_"^"_PatName_"^"_count_"^"_PatNo_"^"_PAAdmDate_"^"_CMCreateDate_"^"_CMCreateTime_"^"_monId_"^"_Diagnosis
	..s list = list_"^"_PatSex_"^"_PatAge
	..i count=Start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count_"}"
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 处方数量记录统计明细
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).MandatoryAuditDetail(10,1,"2021-06-01^2021-06-18")
ClassMethod PrescDetail(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("PrescDetail")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)	 // 开始日期
	s endDate = $p(params,"^",2) // 结束日期
	s locName = $p(params,"^",3) // 科室名称	
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s docName=""
	s type = $p(params,"^",4) // 科室名称
	i type="Doc" d
	.s docName=locName
	.s locName=""
	
	s h=0,count=0
	s listTitle ="locName^patName^seqNo^regNo^PAAdmDate^CMCreateDate^CMCreateTime^monId^Diagnosis^PatSex^PatAge"
	w "{""rows"":["
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)  // 就诊id
	..q:EpisodeID=""
	..s mradm=$P(^PAADM(EpisodeID),"^",61) 
	..s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	..s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	..s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	..s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	..s Loc = $lg(monData,6) 		    // 科室
	..q:(locName'="")&&(locName'="undefined")&&(locName'=Loc)
	..s createUser = $lg(monData,5)   // 医生
	..q:(docName'="")&&(docName'=createUser)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)   /// 年龄
	..s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	..s CMCreateDate = $lg(monData,3)  // 创建日期 
	..s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	..s CMCreateTime = $lg(monData,4)  // 创建时间
	..s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	..s CMExaParam = $lg(monData,9) // 审查内容 
	..s CMExaRes = $lg(monData,10)  // 审查结果
	..s CMPrescFlag = $lg(monData,16) // 是否生成处方标志(Y/N) 
	..;q:CMPrescFlag'="Y"
	..s count=count+1	
	..s list = Loc_"^"_PatName_"^"_count_"^"_PatNo_"^"_PAAdmDate_"^"_CMCreateDate_"^"_CMCreateTime_"^"_monId_"^"_Diagnosis
	..s list = list_"^"_PatSex_"^"_PatAge
	..q:(count<Start)||(count>End)
	..i count=Start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count_"}"
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 处方修改记录统计明细
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).PrescModifyData(10,1,"2021-06-01^2021-06-21")
ClassMethod PrescModifyData(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("PrescModifyData")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)	 // 开始日期
	s endDate = $p(params,"^",2) // 结束日期
	s locName = $p(params,"^",3) // 科室名称
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s docName=""
	s type = $p(params,"^",4) // 科室名称
	i type="Doc" d
	.s docName=locName
	.s locName=""
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","PrescModifyData",pid)
	s h=0,count=0
	s listTitle ="locName^patName^seqNo^regNo^PAAdmDate^CMCreateDate^CMCreateTime^monId^Diagnosis^PatSex^PatAge"
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)     	  // 就诊id
	..q:EpisodeID=""
	..s mradm=$P(^PAADM(EpisodeID),"^",61) 
	..s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	..s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	..s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	..s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	..s Loc = $lg(monData,6)		    // 科室
	..q:(locName'="")&&(locName'="undefined")&&(locName'=Loc)
	..s createUser = $lg(monData,5)   // 医生
	..q:(docName'="")&&(docName'=createUser)
	..s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	..s CMCreateDate = $lg(monData,3)  // 创建日期 
	..s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	..s CMCreateTime = $lg(monData,4)  // 创建时间
	..s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	..s CMExaParam = $lg(monData,9)  // 审查内容 
	..s CMExaRes = $lg(monData,10)  // 审查结果
	..s CMLastId = $lg(monData,18) // 关联上一次的日志id(流转信息用)
	..q:CMLastId=""
	..s firstId = ..getCMFirstId(CMLastId)   //根据关联id获取第一个id 
	..i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","PrescModifyData",pid,firstId)) d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","PrescModifyData",pid,firstId)=""
	
	w "{""rows"":["
	s monId = ""
	f  s monId = $o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","PrescModifyData",pid,monId))  q:monId=""  d
	.s monData = $g(^CKB.PDSS.MonMasterD(monId))
	.s EpisodeID = $lg(monData,2)     	  // 就诊id
	.q:EpisodeID=""
	.s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	.s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	.s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	.s Loc = $lg(monData,6)		    // 科室
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	.s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	.s CMCreateDate = $lg(monData,3)  // 创建日期 
	.s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	.s CMCreateTime = $lg(monData,4)  // 创建时间
	.s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	.s CMExaParam = $lg(monData,9) // 审查内容 
	.s CMExaRes = $lg(monData,10)  // 审查结果
	.s CMLastId = $lg(monData,18) // 关联上一次的日志id(流转信息用)
	.q:CMLastId'=""
	.;s  
	.s count=count+1	
	.s list = Loc_"^"_PatName_"^"_count_"^"_PatNo_"^"_PAAdmDate_"^"_CMCreateDate_"^"_CMCreateTime_"^"_monId_"^"_Diagnosis
	.s list = list_"^"_PatSex_"^"_PatAge
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count_"}"
 	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","PrescModifyData",pid)
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 根据关联日志ID获取第一个ID
/// Input：	       CMLastId
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).getCMFirstId(888)
ClassMethod getCMFirstId(CMLastId)
{
	n (CMLastId)
	q:CMLastId="" ""
	s CMFirstId=""
	while(CMLastId'="") {
		s CMFirstId = CMLastId
		s CMLastId = $lg(^CKB.PDSS.MonMasterD(CMLastId),18)
	}
	q CMFirstId
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 处方修改过程记录分析
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).PrescModifyDetail(890)
ClassMethod PrescModifyDetail(monId)
{
	n (monId)
	s ^TMPTEST("PrescModifyDetail")=$lb(monId)
	s num=0
	w "["
	while(monId'=""){
		s num = num + 1
		i num > 1 d
		.w ","
		d ##class(web.DHCCKBRecipeAuditStat).GetDrugDataByMonId(monId)
		s monId=$o(^DHCCKBMM(0,"LastId",monId,0))
	}
	w "]"
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 根据monID取药品信息(查询修改明细用)
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).GetDrugDataByMonId(10,1,"2021-06-01^2021-06-18")
ClassMethod GetDrugDataByMonId(monId)
{
	n (monId)
	s count=0
	s exaParam = $lg(^CKB.PDSS.MonMasterD(monId),9)	  // 入参
	q:exaParam["UNDEFINED" "[]"
	s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	s drugArr = exaParamObj.%Get("Drug")
	s length = drugArr.%Size()
	w "["
	s listTitle = "drugName^drugFreq^drugPreMet^dose^treatment"
	for k=0:1:length-1  d
	.s drugObj = drugArr.%Get(k)
	.s drugName = drugObj.item  //药品名称
	.q:drugName=""
	.s onceDose = drugObj.OnceDose  // 单次剂量
	.s unit = drugObj.Unit			// 单位
	.s dose = onceDose_unit
	.s formProp = drugObj.FormProp
	.s drugPreMet = drugObj.DrugPreMet // 给药途径
	.s drugFreq = drugObj.DrugFreq   // 频次
	.i drugFreq = "" s drugFreq=drugObj.DrugDrugFreq
	.s treatment = drugObj.Treatment // 疗程
	.s list = drugName_"^"_drugFreq_"^"_drugPreMet_"^"_dose_"^"_treatment
	.s count = count +1
	.i count = 1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	w "]"
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 根据monID取药品信息json串（分页用)
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).GetDrugDetailByMonId(10,1,"890")
ClassMethod GetDrugDetailByMonId(rows, page, monId)
{
	n (rows, page, monId)
	s ^TMPTEST("GetDrugDetailByMonId")=$lb(rows, page,monId)
	s End=page*rows
	s Start=(page-1)*rows+1
	s count=0
	q:monId="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s exaParam = $lg(^CKB.PDSS.MonMasterD(monId),9)  // 入参
	q:exaParam["UNDEFINED" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	s drugArr = exaParamObj.%Get("Drug")
	s length = drugArr.%Size()
	w "{""rows"":["
	s listTitle = "drugName^drugFreq^drugPreMet^dose^treatment^seqNo"
	for k=0:1:length-1  d
	.s drugObj = drugArr.%Get(k)
	.s drugName = drugObj.item  //药品名称
	.q:drugName=""
	.s onceDose = drugObj.OnceDose  // 单次剂量
	.s unit = drugObj.Unit			// 单位
	.s dose = onceDose_unit
	.s formProp = drugObj.FormProp
	.s drugPreMet = drugObj.DrugPreMet // 给药途径
	.s drugFreq = drugObj.DrugFreq   // 频次
	.i drugFreq = "" s drugFreq=drugObj.DrugDrugFreq
	.s treatment = drugObj.Treatment // 疗程
	.s count = count +1			//序号
	.s list = drugName_"^"_drugFreq_"^"_drugPreMet_"^"_dose_"^"_treatment_"^"_count

	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
 	w "],""total"":"_count_"}"
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 服务总数明细查询
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).AuditDrugDetail(10,1,"2021-06-01^2021-06-18")
ClassMethod AuditDrugDetail(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("AuditDrugDetail")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)	 // 开始日期
	s endDate = $p(params,"^",2) // 结束日期
	s locName = $p(params,"^",3) // 科室名称
	s docName=""
	s type = $p(params,"^",4) // 科室名称
	i type="Doc" d
	.s docName=locName
	.s locName=""
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s h=0,count=0
	s listTitle ="locName^patName^seqNo^regNo^PAAdmDate^CMCreateDate^CMCreateTime^monId^Diagnosis^Length^PatSex^PatAge"
	w "{""rows"":["
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(MonData,2) // 就诊id
	..q:EpisodeID=""
	..s CMExaParam = $lg(MonData,9) // 审查内容 
	..s CMExaRes =  $lg(MonData,10) // 审查结果
	..q:CMExaParam["UNDEFINED"
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(CMExaParam)
	..s drugArr = exaParamObj.%Get("Drug")	
	..s length = drugArr.%Size()    //药品数量
	..q:length<1
	..s mradm=$P(^PAADM(EpisodeID),"^",61) 
	..s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	..s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	..s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	..s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	..s Loc = $lg(MonData,6)  // 科室
	..q:(locName'="")&&(locName'="undefined")&&(locName'=Loc)
	..s createUser = $lg(MonData,5)  // 医生
	..q:(docName'="")&&(docName'=createUser)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)   /// 年龄
	..s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	..s CMCreateDate = $lg(MonData,3) // 创建日期 
	..s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	..s CMCreateTime = $lg(MonData,4) // 创建时间
	..s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	
	..s count=count+1	
	..s list = Loc_"^"_PatName_"^"_count_"^"_PatNo_"^"_PAAdmDate_"^"_CMCreateDate_"^"_CMCreateTime_"^"_monId_"^"_Diagnosis_"^"_length
	..s list = list_"^"_PatSex_"^"_PatAge
	..q:(count<Start)||(count>End)
	..i count=Start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count_"}"
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 药品提醒次数
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).ErrorPrescDetail(10,1,"2021-06-01^2021-06-18")
ClassMethod ErrorPrescDetail(rows, page, params)
{
	n (rows, page,params)
	s ^TMPTEST("ErrorPrescDetail")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)	 // 开始日期
	s endDate = $p(params,"^",2) // 结束日期
	s locName = $p(params,"^",3) // 科室名称
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s docName=""
	s type = $p(params,"^",4) // 科室名称
	i type="Doc" d
	.s docName=locName
	.s locName=""
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat",".ErrorPrescDetail",pid)
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2) // 就诊id
	..q:EpisodeID=""
	..s CMExaParam = $lg(monData,9) // 审查内容 
	..s CMExaRes = $lg(monData,10) // 审查结果
	..q:CMExaParam["UNDEFINED"
	..s Loc = $lg(monData,6)  // 科室
	..q:(locName'="")&&(locName'="undefined")&&(locName'=Loc)
	..s createUser = $lg(monData,5)  // 医生
	..q:(docName'="")&&(docName'=createUser)
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(CMExaParam)
	..s drugArr = exaParamObj.%Get("Drug")	
	..s passFlag = $lg(monData,7) // 审查结果
	..q:passFlag'="0"
	..s monItmId = ""	
	..f  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s mqlData = $g(^CKB.PDSS.MonQueListD(monItmId))
	...s itmId = $lg(mqlData,3)			//药品名称
	...Q:'$d(^CT.CKB.PDSS.CommonDictionD(itmId))
	...s catId = $lg(mqlData,4)			//目录id
	...s catCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),2)
	...Q:catCode="HighDangerDrug"
	...;b ;8
	...;统计错误处方数量，同一个药品错误一次，算一个错误处方数
	...i $d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ErrorPrescDetail",pid,monId,itmId)) d
	....
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ErrorPrescDetail",pid,monId,itmId) = ""
	
	
	s h=0,count=0
	s listTitle ="locName^patName^seqNo^regNo^PAAdmDate^CMCreateDate^CMCreateTime^monId^Diagnosis^Length^PatSex^PatAge"
	w "{""rows"":["
	s monId=""
	f  s monId=$o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ErrorPrescDetail",pid,monId)) q:monId=""  d
	.s itmId=0,number=0
	.f  s itmId=$o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ErrorPrescDetail",pid,monId,itmId)) q:itmId=""  d
	..s number=number+1
	.s monData = $g(^CKB.PDSS.MonMasterD(monId))
	.s EpisodeID = $lg(monData,2)  // 就诊id
	.q:EpisodeID=""
	.s mradm=$P(^PAADM(EpisodeID),"^",61) 
	.s Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) /// 诊断
	.s PatientID = $P(^PAADM(EpisodeID),"^",1) 
	.s PatName = $p(^PAPER(PatientID,"ALL"),"^",1) // 姓名
	.s PatNo = $p(^PAPER(PatientID,"PAT",1),"^",1) // 登记号
	.s Loc = $lg(monData,6) // 科室
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	.s PAAdmDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(EpisodeID)),"^",6))  //就诊日期
	.s CMCreateDate = $lg(monData,3)  // 创建日期 
	.s CMCreateDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CMCreateDate)
	.s CMCreateTime = $lg(monData,4)  // 创建时间
	.s:CMCreateTime'="" CMCreateTime = $zt(CMCreateTime,1)
	
	.s count=count+1	
	.s list = Loc_"^"_PatName_"^"_count_"^"_PatNo_"^"_PAAdmDate_"^"_CMCreateDate_"^"_CMCreateTime_"^"_monId_"^"_Diagnosis_"^"_number
	.s list = list_"^"_PatSex_"^"_PatAge
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count_"}"
 	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","ErrorPrescDetail",pid)
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-07-08
/// Description:： 图表统计分析查询
/// Input：	       params:开始日期^结束日期
/// Return：
/// w ##class(web.DHCCKBRecipeAuditStat).GetAnalysessData("2021-06-01^2021-07-09")
ClassMethod GetAnalysessData(Params)
{
	n (Params)
	s StDate =$p(Params,"^",1)
	s EndDate =$p(Params,"^",2)
	s Loc =$p(Params,"^",4)
	s Del=""""
	w "{"
	w Del_"GetCheckPatNum"_Del_":"
	d ##class(web.DHCCKBRecipeAuditStat).GetPromptTypeNum(StDate, EndDate,Loc)  // 提示类别占比
	w ","
	w Del_"GetLocModifyNum"_Del_":"
	d ##class(web.DHCCKBRecipeAuditStat).GetLocModifyNum(StDate, EndDate,Loc)	// 各科室修改次数比例、强制审核比例
	w ","
	w Del_"GetDocModifyNum"_Del_":"
	d ##class(web.DHCCKBRecipeAuditStat).GetDocModifyNum(StDate, EndDate)	// 各医生修改次数比例、强制审核比例
	w ","
	;w Del_"RecipeAuditYoYNum"_Del_":"
	;d ##class(web.DHCCKBRecipeAuditStat).RecipeAuditYoYStat(StDate)		// 问题类型同比
	;w ","
	w Del_"QuestionTypeNum"_Del_":"
	d ##class(web.DHCCKBRecipeAuditStat).QuestionTypeStat(StDate, EndDate)
#;	w ","
#;	w Del_"PatAgeAnalysess"_Del_":"
#;	d ##class(web.DHCEMAnalysessCheckLev).PatAgeAnalysess(StDate,EndDate,HospID)
#;	w ","
#;	w Del_"PatCheckLocNum"_Del_":"
#;	d ##class(web.DHCEMAnalysessCheckLev).PatCheckLocNum(StDate, EndDate,HospID)
	w "}"
  	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-07-08
/// Description:： 提示类别占比
/// Input：	       params:开始日期^结束日期
/// Return：
/// w ##class(web.DHCCKBRecipeAuditStat).GetPromptTypeNum("2020-06-01","2020-07-09")
ClassMethod GetPromptTypeNum(StDate, EndDate)
{
	n (StDate,EndDate)
	q:(StDate="")!(EndDate="") "[]"
	s normalNum=0,tipsNum=0,warnNum=0,forbidNum=0
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)    	// 就诊id
	..q:EpisodeID=""
	..;GetLocSelectFlag
	..s CMExaParam = $lg(monData,9)  	// 审查内容 
	..s CMExaRes = $lg(monData,10)  	// 审查结果
	..q:CMExaParam["UNDEFINED"
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(CMExaParam)
	..s drugArr = exaParamObj.%Get("Drug")	
	..s passFlag = $lg(monData,7) 	// 审查结果
	..q:passFlag'="0"
	..s CMManLevDr = $lg(monData,8) // 管理级别
 	..;s CMManLevDr = $case(CMManLevDr,"normal":"提示","tips":"提醒","warn":"警示","forbid":"禁止",:"")
    ..s:CMManLevDr="normal" normalNum = normalNum + 1
    ..s:CMManLevDr="tips" tipsNum = tipsNum + 1
    ..s:CMManLevDr="warn" warnNum = warnNum + 1
    ..s:CMManLevDr="forbid" forbidNum = forbidNum + 1
 	
 	s Del=""""	
 	;q:(normalNum=0)&&(tipsNum=0)&&(warnNum=0)&&(forbidNum=0) ""
 	w "["
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","提示^"_normalNum_"^数量")
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","提醒^"_tipsNum_"^数量") 
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","警示^"_warnNum_"^数量")
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","禁止^"_forbidNum_"^数量")
 	w "]"
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-07-08
/// Description:： 各科室修改次数比例、强制审核比例	柱状图
/// Input：	       params:开始日期^结束日期
/// Return：
/// w ##class(web.DHCCKBRecipeAuditStat).GetLocModifyNum("2020-06-01","2020-07-09")
ClassMethod GetLocModifyNum(StDate, EndDate)
{
	n (StDate,EndDate)
	q:(StDate="")!(EndDate="") ""
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum",pid)
	f Date=StDate:1:EndDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)    // 就诊id
	..q:EpisodeID=""
	..s PatientID=$P(^PAADM(EpisodeID),"^",1) 
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) //姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) //登记号
	..s loc = $lg(monData,6) 		  // 科室
	..q:loc=""
	..s passFlag = $lg(monData,7) // 审查结果
	..s exaParam = $lg(monData,9)	  // 入参
	..q:exaParam["UNDEFINED"
	..s CMPassType = $lg(monData,15) 	// 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
    ...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","MandatoryAuditNum",pid,loc)=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","MandatoryAuditNum",pid,loc))+1
	...s:'$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","ModifyNum",pid,loc)) ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","ModifyNum",pid,loc)=""
	..s CMLastId = $lg(monData,18) // 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","ModifyNum",pid,loc)=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","ModifyNum",pid,loc))+1
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","MandatoryAuditNum",pid,loc)) d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","MandatoryAuditNum",pid,loc)=""
	
	s loc="",ModifyData="",locDesc=""
	f  s loc=$o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","ModifyNum",pid,loc)) q:loc=""  d 
	.s num=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","ModifyNum",pid,loc))
	.s ModifyData=$s(ModifyData="":num,1:ModifyData_","_num)
	.s locDesc=$s(locDesc="":loc,1:locDesc_","_loc)
	
	s loc="",MandatoryAuditDate=""
	f  s loc=$o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","MandatoryAuditNum",pid,loc)) q:loc=""  d 
	.s num=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum","MandatoryAuditNum",pid,loc))
	.s MandatoryAuditDate=$s(MandatoryAuditDate="":num,1:MandatoryAuditDate_","_num)
	
	s DataStr=ModifyData_"^"_MandatoryAuditDate_"^"_locDesc
	w ##class(web.DHCAPPJsonCommon).getJsonData("ModifyNum^MandatoryAuditNum^locDesc",DataStr)
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetLocModifyNum",pid)
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-07-08
/// Description:： 各医生修改次数比例、强制审核比例	柱状图
/// Input：	       params:开始日期^结束日期
/// Return：
/// w ##class(web.DHCCKBRecipeAuditStat).GetDocModifyNum("2021-06-01","2021-07-09")
ClassMethod GetDocModifyNum(StDate, EndDate)
{
	n (StDate,EndDate)
	q:(StDate="")!(EndDate="") ""
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum",pid)
	f Date=StDate:1:EndDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)   // 就诊id
	..q:EpisodeID=""
	..s doctor = $lg(monData,5)	  //医生
	..q:doctor=""
	..s passFlag = $lg(monData,7) // 审查结果
	..s exaParam = $lg(monData,9)  // 入参
	..q:exaParam["UNDEFINED"
	..s CMPassType = $lg(monData,15)	// 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
    ...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","MandatoryAuditNum",pid,doctor)=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","MandatoryAuditNum",pid,doctor))+1
	...s:'$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","ModifyNum",pid,doctor)) ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","ModifyNum",pid,doctor)=""
	..s CMLastId = $lg(monData,18) // 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","ModifyNum",pid,doctor)=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","ModifyNum",pid,doctor))+1
	...i '$d(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","MandatoryAuditNum",pid,doctor)) d
	....s ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","MandatoryAuditNum",pid,doctor)=""
	
	s doctor="",ModifyData="",doctorNum=""
	f  s doctor=$o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","ModifyNum",pid,doctor)) q:doctor=""  d 
	.s num=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","ModifyNum",pid,doctor))
	.s ModifyData=$s(ModifyData="":num,1:ModifyData_","_num)
	.s doctorNum=$s(doctorNum="":doctor,1:doctorNum_","_doctor)
	
	s doctor="",MandatoryAuditDate=""
	f  s doctor=$o(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","MandatoryAuditNum",pid,doctor)) q:doctor=""  d 
	.s num=+$g(^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum","MandatoryAuditNum",pid,doctor))
	.s MandatoryAuditDate=$s(MandatoryAuditDate="":num,1:MandatoryAuditDate_","_num)
	
	s DataStr=ModifyData_"^"_MandatoryAuditDate_"^"_doctorNum
	w ##class(web.DHCAPPJsonCommon).getJsonData("ModifyNum^MandatoryAuditNum^locDesc",DataStr)
	k ^TMP("DHCCKB","web.DHCCKBRecipeAuditStat","GetDocModifyNum",pid)
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 各类别汇总表
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).RecipeAuditTypeStat(10,1,"2021-06-01^2021-07-18")
ClassMethod RecipeAuditTypeStat(rows = 10, page = 1, params)
{
	n (rows, page,params)
	s ^TMPTEST("RecipeAuditStat")=$lb(rows, page,params,$zts)
	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid)

	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)    // 就诊id
	..q:EpisodeID=""
	..s exaParam = $lg(monData,9)	  // 入参
	..q:exaParam["UNDEFINED"
	..s passFlag = $lg(monData,7) 	// 审查结果
	..q:passFlag'="0"
	..s CMManLevDr = $lg(monData,8) // 管理级别
	..q:CMManLevDr=""
	
	..// 各类别提示总数
	..s ^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,CMManLevDr,"Total")=+$g(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,CMManLevDr,"Total"))+1
 	..;s CMManLevDr = $case(CMManLevDr,"normal":"提示","tips":"提醒","warn":"警示","forbid":"禁止",:"")
	..s CMPassType = $lg(monData,15) 	// 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
    ...s ^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,CMManLevDr,"MandatoryAudit")=+$g(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,CMManLevDr,"MandatoryAudit"))+1
	..s CMLastId = $lg(monData,18) // 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s ^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,CMManLevDr,"Modify")=+$g(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,CMManLevDr,"Modify"))+1
	s count=0
	w "{""rows"":["
	s listTitle ="type^totalNum^modifyNum^modifyRate^mandatoryauditNum^mandatoryauditRate"
	
	s Type = ""
	f  s Type = $o(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,Type)) Q:Type=""  d
	.s totalNum=+$g(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,Type,"Total"))
	.s modifyNum=+$g(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,Type,"Modify"))
	.s mandatoryauditNum=+$g(^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid,Type,"MandatoryAudit"))
	.s modifyRate="0",mandatoryauditRate="0"
	.s:modifyNum'=0 modifyRate=$fn(modifyNum/totalNum*100,"",2)_"%"
	.s:mandatoryauditNum'=0 mandatoryauditRate=$fn(mandatoryauditNum/totalNum*100,"",2)_"%"
	.s typeDesc = $case(Type,"normal":"提示","tips":"提醒","warn":"警示","forbid":"禁止",:"")
	
	.s list = typeDesc_"^"_totalNum_"^"_modifyNum_"^"_mandatoryauditNum_"^"_modifyRate_"^"_mandatoryauditRate
	.s count=count+1	
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	
 	w "],""total"":"_count
 	w "}"
 	k ^TMP("DHCCKB","RecipeAuditTypeStat","Type",pid)
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-06-18
/// Description:： 院各类别修改同比及环比
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).RecipeAuditYoYStat("2021-06-01^2021-07-18")
ClassMethod RecipeAuditYoYStat(stDate)
{
	n (stDate)
	s ^TMPTEST("RecipeAuditYoYStat")=$lb(stDate)
	Q:(stDate = "") ""
	s curYear=$p(stDate,"-",1)
	s curMonth=$p(stDate,"-",2)
	s laststDate = (curYear-1)_"-"_curMonth_"-01"  	// 去年本月第一天
	s stDate = curYear_"-"_curMonth_"-01"  			// 今年当月第一天
	i curMonth'=12 d
	.s nextMonth = curMonth + 1
	.s:(nextMonth<10)&&(nextMonth'["0") nextMonth = "0"_nextMonth
	.s endDate = curYear_"-"_nextMonth_"-"_"01"  	// 获取下月第一天
	.s lastendDate = (curYear-1)_"-"_nextMonth_"-"_"01"  // 获取下月第一天
	i curMonth=12 d
	.s endDate = (curYear+1)_"-01-01"  				// 获取下月第一天
	.s lastendDate = curYear_"-01-01"  				// 获取下月第一天
	i curMonth=1 d
	.s lastMonth = "12"
	.s lastYear = curYear -  1
	e  d
	.s lastMonth = curMonth - 1
	.s lastYear = curYear  
	.s:(lastMonth<10)&&(lastMonth'["0") lastMonth = "0"_lastMonth    
	
	s lastMonthDate = lastYear_"-"_lastMonth_"-01"  // 上月第一天
	s stDate = $zdh(stDate,3)						// 本月第一天
	s endDate = $zdh(endDate,3)-1  					// 本月最后一天
	s laststDate = $zdh(laststDate,3)				// 去年本月第一天
	s lastendDate = $zdh(lastendDate,3)-1			// 去年本月最后一天
	s lastmonthstDate = $zdh(lastMonthDate,3)		// 上月第一天
	s lastmonthendDate = stDate-1			// 上月最后一天
	
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","Lev",pid)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid)
	// 获取本年本月各类型修改和强制审核数
	b ;11
	f date = stDate:1:endDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s MonData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(MonData,2)    	// 就诊id
	..q:EpisodeID=""
	..s exaParam = $lg(MonData,9) 	  	// 入参
	..q:exaParam["UNDEFINED"
	..s passFlag = $lg(MonData,7) 	// 审查结果
	..q:passFlag'="0"
	..s CMManLevDr = $lg(MonData,8)  // 管理级别
	..q:CMManLevDr=""
	..s ^TMP("DHCCKB","RecipeAuditYoYStat","Lev",pid,CMManLevDr)=""  //记录有多少个级别有数据
	..// 各类别提示总数
	..s ^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,CMManLevDr,"Total")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,CMManLevDr,"Total"))+1
 	..;s CMManLevDr = $case(CMManLevDr,"normal":"提示","tips":"提醒","warn":"警示","forbid":"禁止",:"")
	..s CMPassType = $lg(MonData,15)  	 // 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
    ...s ^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,CMManLevDr,"MandatoryAudit")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,CMManLevDr,"MandatoryAudit"))+1
	..s CMLastId = $lg(MonData,18) 		  // 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s ^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,CMManLevDr,"Modify")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,CMManLevDr,"Modify"))+1
	
	// 获取去年本月各类型修改和强制审核数
	f date = laststDate:1:lastendDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)  	// 就诊id
	..q:EpisodeID=""
	..s exaParam = $lg(monData,9)	  	// 入参
	..q:exaParam["UNDEFINED"
	..s passFlag = $lg(monData,7) 	// 审查结果
	..q:passFlag'="0"
	..s CMManLevDr = $lg(monData,8) // 管理级别
	..q:CMManLevDr=""
	..s TMP("DHCCKB","RecipeAuditYoYStat","Lev",pid,CMManLevDr)=""  //记录有多少个级别有数据
	..// 各类别提示总数
	..s ^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,CMManLevDr,"Total")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,CMManLevDr,"Total"))+1
	..s CMPassType = $lg(monData,15) 	// 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
    ...s ^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,CMManLevDr,"MandatoryAudit")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,CMManLevDr,"MandatoryAudit"))+1
	..s CMLastId = $lg(monData,18) 		// 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s ^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,CMManLevDr,"Modify")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,CMManLevDr,"Modify"))+1
	
	// 获取上月各类型修改和强制审核数
	f date = lastmonthstDate:1:lastmonthendDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)  	// 就诊id
	..q:EpisodeID=""
	..s exaParam = $lg(monData,9)	  	// 入参
	..q:exaParam["UNDEFINED"
	..s passFlag = $lg(monData,7) 	// 审查结果
	..q:passFlag'="0"
	..s CMManLevDr = $lg(monData,8) // 管理级别
	..q:CMManLevDr=""
	..s TMP("DHCCKB","RecipeAuditYoYStat","Lev",pid,CMManLevDr)=""  //记录有多少个级别有数据
	..// 各类别提示总数
	..s ^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,CMManLevDr,"Total")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,CMManLevDr,"Total"))+1
	..s CMPassType = $lg(monData,15) 	// 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..i CMPassType="R" d
    ...s ^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,CMManLevDr,"MandatoryAudit")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,CMManLevDr,"MandatoryAudit"))+1
	..s CMLastId = $lg(monData,18) 		// 关联上一次的日志id(流转信息用)
	..i CMLastId'="" d
	...s ^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,CMManLevDr,"Modify")=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,CMManLevDr,"Modify"))+1
	
	s Lev="",curData="",levNum="",lastData="",lastMonthData="",lastMonthAuditData="",lastAuditData="",curAuditData=""
	f  s Lev=$o(^TMP("DHCCKB","RecipeAuditYoYStat","Lev",pid,Lev)) q:Lev=""  d 
	.s curNum=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,Lev,"Modify"))	//今年本月修改数据
	.s curData=$s(curData="":curNum,1:curData_","_curNum)
	.s lastNum=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,Lev,"Modify"))  //去年本月修改数据
	.s lastData=$s(lastData="":lastNum,1:lastData_","_lastNum)
	.s lastMonthNum=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,Lev,"Modify"))  //上月修改数据
	.s lastMonthData=$s(lastMonthData="":lastMonthNum,1:lastMonthData_","_lastMonthNum)
	.s curAuditNum=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid,Lev,"MandatoryAudit"))	//今年本月强制审核数据
	.s curAuditData=$s(curAuditData="":curAuditNum,1:curAuditData_","_curAuditNum)
	.s lastAuditNum=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid,Lev,"MandatoryAudit"))  //去年本月强制审核数据
	.s lastAuditData=$s(lastAuditData="":lastAuditNum,1:lastAuditData_","_lastAuditNum)
	.s lastMonthAuditNum=+$g(^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid,Lev,"MandatoryAudit"))  //上月强制审核数据
	.s lastMonthAuditData=$s(lastMonthAuditData="":lastMonthAuditNum,1:lastMonthAuditData_","_lastMonthAuditNum)
	.s LevDesc=$case(Lev,"normal":"提示","tips":"提醒","warn":"警示","forbid":"禁止",:"")
	.s levNum=$s(levNum="":LevDesc,1:levNum_","_LevDesc)   							//有数据得级别
	
	s YearStr=curYear_"年"_curMonth_"月"_","_(curYear-1)_"年"_curMonth_"月"_","_lastYear_"年"_lastMonth_"月"
	s DataStr=curData_"^"_lastData_"^"_levNum_"^"_YearStr_"^"_lastMonthData_"^"_lastMonthAuditData_"^"_lastAuditData_"^"_curAuditData
	w ##class(web.DHCAPPJsonCommon).getJsonData("curData^lastData^levNum^YearStr^lastMonthData^lastMonthAuditData^lastAuditData^curAuditData",DataStr)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","LastYear",pid)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","Lev",pid)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","CurYear",pid)
	k ^TMP("DHCCKB","RecipeAuditYoYStat","LastMonth",pid)
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-07-12
/// Description:： 各科室问题类型对比修改，强制审核记录统计
/// Input：	       params:开始日期^结束日期
/// Return：       
/// w ##class(web.DHCCKBRecipeAuditStat).QuestionTypeStat("2021-06-01^2021-07-18")
ClassMethod QuestionTypeStat(StDate, EndDate)
{
	n (StDate,EndDate)
	q:(StDate="")!(EndDate="") ""
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","QuestionTypeStat","MandatoryAuditNum",pid)
	k ^TMP("DHCCKB","QuestionTypeStat","ModifyNum",pid)
	k ^TMP("DHCCKB","QuestionTypeStat","Problem",pid)
	f Date=StDate:1:EndDate  d
	.s monId = ""
	.f  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",Date,monId))  q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s EpisodeID = $lg(monData,2)    // 就诊id
	..q:EpisodeID=""
	..s PatientID=$P(^PAADM(EpisodeID),"^",1) 
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) //姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) //登记号
	..s loc = $lg(monData,6) 		  // 科室
	..q:loc=""
	..s passFlag = $lg(monData,7) // 审查结果
	..s exaParam = $lg(monData,9)	  // 入参
	..q:exaParam["UNDEFINED"
	..q:passFlag'="0"  							  //下面是计算没通过的错误处方数
	..s CMPassType = $lg(monData,15)  // 通过类型(合理通过,强制审核通过,药师复核通过,药师拒绝)
	..s CMLastId = $lg(monData,18)    // 关联上一次的日志id(流转信息用)
	..s monItmId = ""	
	..f  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s proDr=$lg(^CKB.PDSS.MonQueListD(monItmId),4)    // 问题ID
	...s proDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(proDr)),3)    // 问题描述
	...s ^TMP("DHCCKB","QuestionTypeStat","Problem",pid,proDesc)=""  //记录有多少个级别有数据
	...i CMPassType="R" d
    ....s ^TMP("DHCCKB","QuestionTypeStat","MandatoryAuditNum",pid,loc,proDesc)=+$g(^TMP("DHCCKB","QuestionTypeStat","MandatoryAuditNum",pid,loc,proDesc))+1
	...i CMLastId'="" d
	....s ^TMP("DHCCKB","QuestionTypeStat","ModifyNum",pid,loc,proDesc)=+$g(^TMP("DHCCKB","QuestionTypeStat","ModifyNum",pid,loc,proDesc))+1
	
	b ;444
	s Problem="",ModifyData="",ModifyLocStr="",MandatoryAuditLocStr="",ProblemStr="",MandatoryAuditData=""
	f  s Problem=$o(^TMP("DHCCKB","QuestionTypeStat","Problem",pid,Problem)) q:Problem=""  d 
	.s ModifyLoc="",ModifyLocStr="",MandatoryAuditLocStr=""			  // 获取各科室修改数量
	.f  s ModifyLoc=$o(^TMP("DHCCKB","QuestionTypeStat","ModifyNum",pid,ModifyLoc)) q:ModifyLoc=""  d
	..s ModifyNum=+$g(^TMP("DHCCKB","QuestionTypeStat","ModifyNum",pid,ModifyLoc,Problem)) 
	..s ModifyData=$s(ModifyData="":ModifyNum,1:ModifyData_","_ModifyNum)
	..s ModifyLocStr=$s(ModifyLocStr="":ModifyLoc,1:ModifyLocStr_","_ModifyLoc)
	.s MandatoryAuditLoc=""   // 获取各科室强制审核数量
	.f  s MandatoryAuditLoc=$o(^TMP("DHCCKB","QuestionTypeStat","MandatoryAuditNum",pid,MandatoryAuditLoc)) q:MandatoryAuditLoc=""  d
	..s MandatoryAuditNum=+$g(^TMP("DHCCKB","QuestionTypeStat","MandatoryAuditNum",pid,MandatoryAuditLoc,Problem)) 
	..s MandatoryAuditData=$s(MandatoryAuditData="":MandatoryAuditNum,1:MandatoryAuditData_","_MandatoryAuditNum)
	..s MandatoryAuditLocStr=$s(MandatoryAuditLocStr="":MandatoryAuditLoc,1:MandatoryAuditLocStr_","_MandatoryAuditLoc)
	.s ProblemStr=$s(ProblemStr="":Problem,1:ProblemStr_","_Problem)
	s DataStr=ModifyData_"^"_ModifyLocStr_"^"_MandatoryAuditData_"^"_MandatoryAuditLocStr_"^"_ProblemStr
	w ##class(web.DHCAPPJsonCommon).getJsonData("ModifyData^ModifyLocStr^MandatoryAuditData^MandatoryAuditLocStr^ProblemStr",DataStr)
	k ^TMP("DHCCKB","QuestionTypeStat","MandatoryAuditNum",pid)
	k ^TMP("DHCCKB","QuestionTypeStat","ModifyNum",pid)
	k ^TMP("DHCCKB","QuestionTypeStat","Problem",pid)
	q ""
}

/// Description: 获取科室描述，
/// Creator:     xww
/// CreateDate:  2021-11-15	 
/// Input:       查询内容(汉字或者拼音码)
/// Output:  	 id^科室描述 （串）
/// Table:		 CT_LOC
/// Others:	w ##class(web.DHCCKBRecipeAuditStat).GetAllLoc("fs",2)	
ClassMethod GetAllLoc(rows = 10, page = 1, input As %String, hospID As %String) As %String
{
	n (rows,page,input,hospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DESC as locDesc FROM CT_LOC"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_"%"_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_"%"_""_input_""_"%"_""_""" "
	.//旧版(拼音码和描述为分开) s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Code LIKE """_""_input_""_"%"_""_""" "
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "{""rows"":["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		continue:(hospID'="")&(hospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
  		continue:($p(^CTLOC(locDr),"^",25)'="")&&($p(^CTLOC(locDr),"^",25)<+$h)
		s:locDesc["-" locDesc=$p(locDesc,"-",2)
		s tmp=locDr_"^"_locDesc
		s count = count+1
		q:(count<Start)||(count>End)
		I count=1 d
		.w ##class(web.DHCADVJSONCOMMON).getJsonData("LocID^LocDesc",tmp)
		e  d
		.w ","_##class(web.DHCADVJSONCOMMON).getJsonData("LocID^LocDesc",tmp)
	}

 	w "],""total"":"_count
	w "}"
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2021-11-16
/// Description:： 获取科室是否在科室串中
/// Input：	       Loc:科室，LocStr：科室串
/// Return：	   0：不在 ，1 在
/// w ##class(web.DHCCKBRecipeAuditStat).GetLocSelectFlag("2020-06-01","2020-07-09")
ClassMethod GetLocSelectFlag(Loc, LocStr)
{
	n (Loc, LocStr)
	s flag=0
	for i=1:1:$l(LocStr,", ") q:flag=1  d
	.s LocDesc=$p(LocStr,", ",i)
	.q:LocDesc=""
	.q:LocDesc'=Loc
	.s flag=1
	
	q flag
}

}
