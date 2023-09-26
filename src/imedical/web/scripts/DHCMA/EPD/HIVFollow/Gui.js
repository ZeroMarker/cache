function InitReportWin(){
	var obj = new Object();   
	obj.ReportID = ReportID;
	//从HIV副卡(传染病报卡)获取数据
	var EPDRepInfo = $m({                  
		ClassName:"DHCMed.EPD.CaseFollow",
		MethodName:"GetEPDInfoByAdm",
		aEpisodeID:EpisodeID,
		aReportID:obj.ReportID
	},false);
	if (!EPDRepInfo){
		websys_showModal('close');
	}else{
		obj.arrEPDInfo=EPDRepInfo.split("^")
		if (!obj.arrEPDInfo[0]){    //传染病报卡ID
			websys_showModal('close');
		}
	}
	/*if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }*/       
	$.parser.parse();        // 解析整个页面 
	//下拉选初始化
	obj.cboFollowStatus = Common_ComboToDic("cboFollowStatus","EPDFollowStatus","",session['LOGON.HOSPID']);                               //随访状态
	obj.cboIsCustody = Common_ComboToDic("cboIsCustody","EPDIsCheck","",session['LOGON.HOSPID']);                                          //当前是否羁押
	obj.cboReasons = Common_ComboToDic("cboReasons","EPDNotFollowReasons","",session['LOGON.HOSPID']);                                     //失访原因
	obj.cboIsDead = Common_ComboToDic("cboIsDead","EPDIsCheck","",session['LOGON.HOSPID']);                                                //是否死亡
	obj.cboDeathStage = Common_ComboToDic("cboDeathStage","EPDDeathStage","",session['LOGON.HOSPID']);                                     //死亡时病程阶段
	obj.cboDeathPlace = Common_ComboToDic("cboDeathPlace","EPDDeathPlace","",session['LOGON.HOSPID']);                                     //死亡地点
	obj.cboDeathReason = Common_ComboToDic("cboDeathReason","EPDDeathReason","",session['LOGON.HOSPID']);                                  //主要死因
	obj.cboCourseStage = Common_ComboToDic("cboCourseStage","EPDCourseStage","",session['LOGON.HOSPID']);                                  //病程阶段
	obj.cboSpouseSituation = Common_ComboToDic("cboSpouseSituation","EPDSpouseSituation","",session['LOGON.HOSPID']);                      //自上次随访以来配偶/固定性伴变化情况
	obj.cboSpouseHIV = Common_ComboToDic("cboSpouseHIV","EPDSpouseHIV","",session['LOGON.HOSPID']);                                        //当前配偶/固定性伴感染状况
	obj.cboHIVSurvey1 = Common_ComboToDic("cboHIVSurvey1","EPDIsCheck","",session['LOGON.HOSPID']);                                        //现在是否为同伴教育员
	obj.cboHIVSurvey2 = Common_ComboToDic("cboHIVSurvey2","EPDIsCheckSurvey2","",session['LOGON.HOSPID']);                                 //过去3个月，是否每次发生性行为都用安全套
	obj.cboHIVSurvey3 = Common_ComboToDic("cboHIVSurvey3","EPDIsCheckSurvey3","",session['LOGON.HOSPID']);                                 //过去3个月，是否每次与配偶/固定性伴发生性行为都用安全套
	obj.cboHIVSurvey4 = Common_ComboToDic("cboHIVSurvey4","EPDIsCheckSurvey4","",session['LOGON.HOSPID']);                                 //过去3个月，是否共用过注射器注射毒品
	obj.cboHIVSurvey5 = Common_ComboToDic("cboHIVSurvey5","EPDIsCheckSurvey4","",session['LOGON.HOSPID']);                                 //过去3个月，是否参加针具交换
	obj.cboHIVSurvey6 = Common_ComboToDic("cboHIVSurvey6","EPDIsCheck","",session['LOGON.HOSPID']);                                        //目前是否接受社区美沙酮维持治疗
	obj.cboHIVSurvey7 = Common_ComboToDic("cboHIVSurvey7","EPDIsCheckSurvey7","",session['LOGON.HOSPID']); 
	obj.cbgIsHIVSurvey7 = Common_ComboToDic("cbgIsHIVSurvey7","EPDIsCheck","",session['LOGON.HOSPID']); 
	obj.cboHIVSurvey8 = Common_ComboToDic("cboHIVSurvey8","EPDIsCheck","",session['LOGON.HOSPID']);                                 //若为育龄妇女，目前为
	obj.cboHIVSurvey8a = Common_ComboToDic("cboHIVSurvey8a","EPDIsCheck","",session['LOGON.HOSPID']);                                      //宣传咨询(宣传材料、咨询服务)
	obj.cboHIVSurvey8b = Common_ComboToDic("cboHIVSurvey8b","EPDIsCheck","",session['LOGON.HOSPID']);                                      //药物提供(提供抗机会性感染药物)
	obj.cboHIVSurvey8c = Common_ComboToDic("cboHIVSurvey8c","EPDIsCheck","",session['LOGON.HOSPID']);                                      //关怀救助(经济支持、生活帮助)
	obj.cboHIVSurvey9 = Common_ComboToDic("cboHIVSurvey9","EPDHIVSurvey9","",session['LOGON.HOSPID']);                                     //本次随访是否出现以下结核病可疑筛查症状
	obj.cboHIVSurvey10 = Common_ComboToDic("cboHIVSurvey10","EPDHIVSurvey10","",session['LOGON.HOSPID']);                                  //结果
	obj.cboIsHIVSurvey10 = Common_ComboToDic("cboIsHIVSurvey10","EPDIsCheck","",session['LOGON.HOSPID']);                                  //过去6个月是否接受过结核病检查
	obj.cboIsHIVSurvey11 = Common_ComboToDic("cboIsHIVSurvey11","EPDIsCheck","",session['LOGON.HOSPID']);                                  //目前是否接受国家免费艾滋病抗病毒治疗
	//加载单选、多选列表	
	obj.LoadListInfo = function() {	  //加载单选、多选列表	
		obj.cbgIsHIVTest = Common_RadioToDic("cbgIsHIVTest","EPDIsCheck",4);                                      //本次被诊断为HIV阳性以前是否还做过HIV监测
		obj.cbgDeathReasonSource = Common_CheckboxToDic("cbgDeathReasonSource","EPDDeathReasonSource",3);         //死因信息收集来源(可多选)
		obj.cbgDeathReasonHIV = Common_CheckboxToDic("cbgDeathReasonHIV","EPDDeathReasonHIV",3);                  //艾滋病相关疾病死亡
		obj.cbgDeathReasonOthers = Common_CheckboxToDic("cbgDeathReasonOthers","EPDDeathReasonOthers",3);         //艾滋病无关死亡
		obj.cboHIVManifestation = Common_CheckboxToDic("cboHIVManifestation","EPDHIVManifestation",3);            //可多选
	}
	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
