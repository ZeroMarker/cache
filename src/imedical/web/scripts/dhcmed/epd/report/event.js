function InitviewScreenEvent(obj) {
	// 获取基本数据对象
	var objDicManage = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");			// 基础字典对象
	var objInfectionManage = ExtTool.StaticServerObject("DHCMed.EPD.Infection");	// 传染病字典对象
	var objPatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");		// 病人基本信息对象
	var objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");		// 病人就诊信息对象
	var objRepManage = ExtTool.StaticServerObject("DHCMed.EPD.Epidemic");			// 传染病报告对象
	var objEpdManage = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicSrv");
	var objCtlocManage = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");			// 科室对象
	var objSSUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");			// 用户对象
	var objConfigManage = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");	// 家长姓名复选框提示信息
	var objCommonSrv = ExtTool.StaticServerObject("DHCMed.EPDService.CommonSrv");
	var objReportExport = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicReportExport");
	
	// 获取当前就诊病人数据对象
	obj.objCurrPatient = objPatientManage.GetObjById(PatientID);	// 当前病人对象
	obj.objCurrPaadm = objPaadmManage.GetObjById(EpisodeID);		// 当前病人就诊对象
	obj.objCurrRepCtloc = objCtlocManage.GetObjById(session['LOGON.CTLOCID']);	 // 当前上报科室对象
	obj.objCurrRepUser = objSSUserManage.GetObjById(session['LOGON.USERID']);	 // 当前上报用户对象
	obj.objCurrRepWard = objCtlocManage.GetObjByWardId(obj.objCurrPaadm.WardID); // 当前上报病区对象
	var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",PatientID,"");

	// 获取当前上报界面控制设置参数
	obj.EpdRepPatRelNotice = objConfigManage.GetValueByKeyHosp("EpdRepPatRelNotice", "");	//家长姓名文本提示
	obj.EpdRepPatCompanyNotice = objConfigManage.GetValueByKeyHosp("EpdRepPatCompanyNotice", "");	//工作单位文本提示
	
	obj.EpdRepCardNotice = objConfigManage.GetValueByKeyHosp("EpdRepCardNotice", "");	//有效证件号文本提示
	obj.EpdRepCardNotice = "可填写监护人有效证件号，并选择证件类型“监护人证件”";
	obj.EpdRepPatRelRequireMaxAge = objConfigManage.GetValueByKeyHosp("EpdRepPatRelRequireMaxAge", "");	//年龄小于14岁,必须填写家长姓名
	obj.EpdOccupationToRelName = objConfigManage.GetValueByKeyHosp("EpdOccupationToRelName", "");  //职业To家长姓名    职业为幼托儿童或散居儿童,必须填写家长姓名
	obj.EpdOccupationToCompany = objConfigManage.GetValueByKeyHosp("EpdOccupationToCompany", "");  //职业To工作单位  职业为学生（大中小学）,工作单位填写学校年级班级

	obj.EpdDiseaseToSickKind = objConfigManage.GetValueByKeyHosp("EpdDiseaseToSickKind", "");  //诊断To发病性质  诊断为乙肝\丙肝\血吸虫病,发病性质选择慢性(乙型肝炎、丙型肝炎、血吸虫病填写)
	obj.EpdDiseaseToDegree = objConfigManage.GetValueByKeyHosp("EpdDiseaseToDegree", "");  //诊断To诊断分类  诊断为肝炎\淋病\梅毒\艾滋病\HIV\肺结核涂阳\肺结核仅培阳,诊断分类选择实验室确诊病例
	obj.EpdDiseaseToResume = objConfigManage.GetValueByKeyHosp("EpdDiseaseToResume", "");  //诊断To备注信息  诊断为艾滋\HIV,备注为结果已告知，信息保密，拒绝访视,诊断为肺结核,备注为患者已联系转结防所
	obj.EpdDiseaseToCardNo = objConfigManage.GetValueByKeyHosp("EpdDiseaseToCardNo", "");  //诊断To身份证号  诊断为艾滋\HIV,身份证号必填
	obj.EpdInitAddressByLocalHospital = objConfigManage.GetValueByKeyHosp("EpdInitAddressByLocalHospital", "");  //传染病报卡默认初始化加载当地医院所在的省、市、县三级
	obj.EpdInitIntimateKey = objConfigManage.GetValueByKeyHosp("EpdInitIntimateKey", "");  //传染病上报病人密切接触情况
	
	if (ReportID != "") {
		// 已存在的报告
		obj.objCurrReport = objRepManage.GetObjById(ReportID);	// 当前传染病报告对象
		obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", obj.objCurrReport.MEPDStatus, "1"); // 当前报告状态对象
		obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", obj.objCurrReport.MEPDRepPlace, "1"); // 当前上报位置对象
	} else {
		//add by zf 20150402 新建报告默认“草稿”状态
		obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", "6", "1");
		
		// 新建的报告，指定默认的上报位置
		switch (obj.objCurrPaadm.AdmType) {
			case "O" :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "O", "1"); // 门诊
				break;
			case "I" :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "I", "1"); // 病房
				break;
			case "E" :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "E", "1"); // 急诊
				break;
			default :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "O", "1"); // 默认为门诊
				break;
		}
	}
	
	/**
	 * 在客户端操作前，自动初始化执行所需的事件
	 * @param {} args
	 */
	obj.LoadEvent = function(args) {
		// 根据医生站传递的参数获取病人的基本信息，载入当前报告对应的表单项
		obj.loadPatientInfoForReport();
		
		// 挂入全部所需监听事件
		obj.relationToEvents();
		
		// 判断当前报告是否存在
		// 若不存在，则新建
		// 若存在，则根据报告ID加载对应的报告信息
		if (!obj.objCurrReport) {
			// 初始化各报告项和附卡信息
			obj.initReportInfo();
			// 根据报告状态和权限区分标记显示此报告对应的功能按钮
			obj.DisplayButtonStatus(LocFlag,"","N");
		} else {
			// 根据报告ID加载对应的报告信息
			obj.DisplayReportInfo(ReportID);
			// 根据报告状态和权限区分标记显示此报告对应的功能按钮
			if (obj.objCurrReport){
				obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
			}			
		}
		
		// 根据医生站传递的参数获取病人的基本信息，载入基本信息模板
		obj.loadPatientInfoForTemplate();
	};
	
	/**
	 * 公共处理函数 - 根据医生站传递的参数获取病人的基本信息，载入基本信息模板
	 */
	obj.loadPatientInfoForTemplate = function() {
		// 定义病人基本信息模板所需对象
		if (obj.objCurrReport){
			obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", obj.objCurrReport.MEPDStatus, ""); // 报告状态
			obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", obj.objCurrReport.MEPDRepPlace, ""); // 上报位置
			obj.objCurrRepCtloc = objCtlocManage.GetObjById(obj.objCurrReport.MEPDLocDR);	    // 上报科室
			obj.objCurrRepUser = objSSUserManage.GetObjById(obj.objCurrReport.MEPDRepUsrDR);	// 上报用户
			if (obj.objCurrReport.MEPDText3!='') {
				obj.objCurrRepWard = objCtlocManage.GetObjById(obj.objCurrReport.MEPDText3);	    // 上报科室
			}
		}
		//*************************************************
		/*
		//update by zf 20111112 处理年龄问题
		var tmpPatientAge="";
		if (obj.objCurrPatient){
			if (obj.objCurrPatient.Age > 0){
				tmpPatientAge = obj.objCurrPatient.Age + "岁";
			}else if (obj.objCurrPatient.AgeMonth > 0){
				tmpPatientAge = obj.objCurrPatient.AgeMonth + "月";
			}else{
				tmpPatientAge = obj.objCurrPatient.AgeDay + "天";
			}
		}
		*/
		//update by pylian 2015-07-17 年龄由接口来获取,解决已上报的报告打开时年龄变化的问题
		var tmpPatientAge = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",obj.objCurrPatient.Papmi,obj.objCurrPaadm.AdmRowID, obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
		// update by mxp 201605-06 根据就诊类型取相应的病案号
		var PatientMrNo = ExtTool.RunServerMethod("DHCWMR.IO.OutService","IGetMrNoByEpisodeID",obj.objCurrPaadm.AdmRowID,obj.objCurrPaadm.AdmType);
		//*************************************************
		var tplBaseInfoData = {
			PapmiNo : (obj.objCurrPatient ? obj.objCurrPatient.PapmiNo : ''),
			//InPatientMrNo : (obj.objCurrPatient ? obj.objCurrPatient.InPatientMrNo : ''),
			InPatientMrNo : PatientMrNo,
			PatientName : (obj.objCurrPatient ? obj.objCurrPatient.PatientName : ''),
			Sex : (obj.objCurrPatient ? obj.objCurrPatient.Sex : ''),
			Age : (obj.objCurrPatient ? tmpPatientAge : ''),  //update by zf 20111112 处理年龄问题
			Birthday : (obj.objCurrPatient ? obj.objCurrPatient.Birthday : ''),
			RepUser : (obj.objCurrRepUser ? obj.objCurrRepUser.Name : ''),
			RepLoc : (obj.objCurrRepCtloc ? obj.objCurrRepCtloc.Descs + (obj.objCurrRepCtloc.Telephone!='' ? "( " + obj.objCurrRepCtloc.Telephone + ")" : '') : ''),
			RepWard : (obj.objCurrRepWard ? obj.objCurrRepWard.Descs + (obj.objCurrRepWard.Telephone!='' ? "( " + obj.objCurrRepWard.Telephone + ")" : '') : ''),
			RepPlace : (obj.objCurrRepPlace ? obj.objCurrRepPlace.Description : ''),
			RepStatus : (obj.objCurrReportStatus ? obj.objCurrReportStatus.Description : ''),
			EncryptLevel : (SecretStr!="" ? SecretStr.split("^")[0] : ""),
			PatLevel : (SecretStr!="" ? SecretStr.split("^")[1] : "")
		};
		obj.tplBaseInfo.compile();
		obj.tplBaseInfo.overwrite(obj.PanelRow0.body, tplBaseInfoData);
	};
	
	/**
	 * 公共处理函数 - 根据医生站传递的参数获取病人的基本信息，载入当前报告对应的表单项
	 */
	obj.loadPatientInfoForReport = function() {
		document.title = "传染病报告[当前患者：" + obj.objCurrPatient.PatientName + "]";
		obj.lblRelationNotice.setText(obj.EpdRepPatRelNotice);
		obj.lblCompanyNotice.setText(obj.EpdRepPatCompanyNotice);
		
		obj.lblCardNotice.setText(obj.EpdRepCardNotice);  //有效证件号文本提示
		
		// 根据医生站病人建卡信息，自动获取到上报页面的对应表单项
		obj.txtTel.setValue(obj.objCurrPatient.RelativeTelephone);		//联系电话
		
		// ******************************************************************* //
		// 工作单位
		// Modified By PanLei 2013-03-24
		// 如果加载HIS建卡的工作单位为空,则默认设置为“无”
		if (trim(obj.objCurrPatient.WorkAddress)) {
			obj.txtCompany.setValue(obj.objCurrPatient.WorkAddress);
		} else {
			obj.txtCompany.setValue("无");
		}
		// ******************************************************************* //
		
		// add by PanLei 20120208
		// 增加条件判断，如果年龄小于等于14，需要带亲属姓名。14岁以上设为空
		if (obj.objCurrPatient.Age <= obj.EpdRepPatRelRequireMaxAge) {
			obj.txtRelationName.setValue(obj.objCurrPatient.RelativeName);	//家长姓名
		} else {
			obj.txtRelationName.setValue("");	//家长姓名
		}
		
		obj.txtPatCardNo.setValue(obj.objCurrPatient.PersonalID);		//身份证
		obj.txtAddress.setValue(obj.objCurrPatient.Address);			//现住址
		/* update by pylian 2016年新版传染病去掉户籍地址
		// 加载户籍地址
		obj.txtIDAddress.setValue(obj.objCurrPatient.Address);
		//add by zf 20120114 增加地址复制
		if ((trim(obj.txtIDAddress.getValue()) == "")&&(trim(obj.txtAddress.getValue()) != "")) {
			obj.txtIDAddress.setValue(obj.txtAddress.getValue());     //如果户籍地址为空,把现住址复制到户籍地址
		}
		*/
	};
	
	/**
	 * 公用处理函数 - 挂入全部所需监听事件
	 */
	obj.relationToEvents = function() {
		
		// 省市县乡触发事件
		// 当下拉列表被展开时触发
		obj.cboProvince.on("expand", obj.cboProvince_expand, obj);
		//obj.cboCity.on("expand", obj.cboCity_expand, obj);
		//obj.cboCounty.on("expand", obj.cboCounty_expand, obj);
		//obj.cboVillage.on("expand", obj.cboVillage_expand, obj);
		
		// 当一个列表项目被选中时触发
		obj.cboProvince.on("select", obj.cboProvince_select, obj);
		obj.cboCity.on("select", obj.cboCity_select, obj);
		obj.cboCounty.on("select", obj.cboCounty_select, obj);
		obj.cboVillage.on("select", obj.cboVillage_select, obj);

		// 诊断触发事件
		obj.cboDisease.on("collapse", obj.cboDisease_collapse, obj);	//当诊断下拉列表被收起时触发
		obj.cboDisease.on("expand", obj.cboDisease_expand, obj);	    //当诊断下拉列表下拉时触发

		// 附卡编辑触发事件
		obj.AppendixGridPanel.on("beforeedit", obj.AppendixGridPanel_beforeedit, obj);
		obj.AppendixGridPanel.on("afteredit", obj.AppendixGridPanel_afteredit, obj);

		// 按钮触发事件
		obj.btnSaveTmp.on("click", obj.btnSaveTmp_click, obj);		//保存草稿
		obj.btnSave.on("click", obj.btnSave_click, obj);			//上报待审
		obj.btnCheck.on("click", obj.btnCheck_click, obj);			//审核
		obj.btnUpdoCheck.on("click", obj.btnUpdoCheck_click, obj);	//取消审核
		obj.btnCorrect.on("click", obj.btnCorrect_click, obj);		//订正
		obj.btnReturn.on("click", obj.btnReturn_click, obj);		//退回
		obj.btnDelete.on("click", obj.btnDelete_click, obj);		//删除
		obj.btnUpdateCDC.on("click", obj.btnUpdateCDC_click, obj);	//上报CDC
		obj.btnPrint.on("click", obj.btnPrint_click, obj);			//打印
		obj.btnClose.on("click", obj.btnClose_click, obj);			//关闭窗口
		obj.btnOutHospReport.on("click", obj.btnOutHospReport_click, obj);		//外院已报
	};
	
	/**
	 * 新建报告 - 初始化各报告项和附卡信息
	 */
	obj.initReportInfo = function() {
		//modify by mxp 2016-12-09 证件类型及证件号码
		var PatCardInfo=objCommonSrv.GetActiveCardNo(PatientID);
		if (PatCardInfo!="") {
			var arrPatCard=PatCardInfo.split("^");
			obj.cboCardTypeStore.load({
				callback : function() {
					obj.cboCardType.setValue(arrPatCard[0]);
				}
			});				
			obj.txtPatCardNo.setValue(arrPatCard[1]);
		}
		
		// 加载职业
		obj.cboOccupationStore.load({});
		
		// 加载区域
		obj.cboRegionStore.load({});

		// Add By PanLei 2012-03-10
		// 传染病报卡默认初始化加载当地医院所在的省、市、县三级
		// 13294-浙江省,14671-台州市,14781-温岭市
		var arrayEpdInitAddressByLocalHospital = obj.EpdInitAddressByLocalHospital.split("`");
		var initProvince = arrayEpdInitAddressByLocalHospital[0];
		var initCity = arrayEpdInitAddressByLocalHospital[1];
		var initCounty = arrayEpdInitAddressByLocalHospital[2];
		obj.DisplayArea(initProvince, initCity, initCounty, "", "");
		
		//***************************************************
		//update by zf 2012-11-13
		//store.load引起重复刷新问题,把代码从下边移到上边来就可以了
		
		// 加载诊断分类
		obj.cboDegreeStore.load({});
		
		// 加载发病程度
		obj.cboSickKindStore.load({});
		
		// 加载接触情况
		// Add By PanLei 2012-11-28
		// 初始加载报卡界面，默认传染病患者的密切接触情况为“无相关症状”
		obj.cboIntimateStore.load({
			callback : function() {
				if (obj.cboIntimateStore.getCount() > 0) {
					obj.cboIntimate.setValue(obj.EpdInitIntimateKey);
				}
			}
		});
		
		// 设置诊断日期默认为当天
		obj.dtDiagnoseDate.setValue(new Date());
		//***************************************************
		
		// 加载诊断
		obj.cboDiseaseStore.load({
			callback : function() {
				if (obj.cboDiseaseStore.getCount() > 0) {
					if (IFRowID) {
						obj.cboDisease.setValue(IFRowID);
						obj.cboDisease_collapse();
					}
				}
			}
		});		
	};
	
	/**
	 * 核心方法：根据报告ID加载对应的报告信息
	 * @param {} ReportID
	 */
	obj.DisplayReportInfo = function(reportId) {
		
		objRepManage = ExtTool.StaticServerObject("DHCMed.EPD.Epidemic");
		var objReport = objRepManage.GetObjById(reportId);
		if (objReport == "") {
			return;
		}
		//处理日期格式字段空值转换1840-12-31的问题
		if (objReport.MEPDSickDate=="1840-12-31") {objReport.MEPDSickDate="";}
		if (objReport.MEPDDiagDate=="1840-12-31") {objReport.MEPDDiagDate="";}
		if (objReport.MEPDDeathDate=="1840-12-31") {objReport.MEPDDeathDate="";}
		if (objReport.MEPDRepDate=="1840-12-31") {objReport.MEPDRepDate="";}
		if (objReport.MEPDCheckDate=="1840-12-31") {objReport.MEPDCheckDate="";}
		obj.objCurrReport = objReport;
		
		objDicManage = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
		obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", obj.objCurrReport.MEPDRepPlace, "1"); // 上报位置
		obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", obj.objCurrReport.MEPDStatus, "1"); // 报告状态
		if (obj.objCurrReport.MEPDRepUsrDR != "") {
			var objUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");
			var objUser = objUserManage.GetObjById(obj.objCurrReport.MEPDRepUsrDR);
			obj.objCurrReport.RepUser = objUser;
		}
		if (obj.objCurrReport.MEPDLocDR != "") {
			var objLocManage = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
			obj.objCurrReport.RepDep = objLocManage.GetObjById(obj.objCurrReport.MEPDLocDR);
		}
		if (obj.objCurrReport.MEPDCheckUsrDR != "") {
			var objUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");
			var objUser = objUserManage.GetObjById(obj.objCurrReport.MEPDCheckUsrDR);
			if (objUser){
				obj.objCurrReport.CheckUserName = objUser.Name;
			}else{
				obj.objCurrReport.CheckUserName = "";
			}
		}else{
			obj.objCurrReport.CheckUserName = "";
		}
		
		obj.txtTel.setValue(obj.objCurrReport.MEPDTelPhone);		    //联系电话
		obj.txtCompany.setValue(obj.objCurrReport.MEPDCompany);		    //工作单位
		obj.txtRelationName.setValue(obj.objCurrReport.MEPDFamName);	//家长姓名
		obj.txtAddress.setValue(obj.objCurrReport.MEPDAddress);			//现住址
		
		// 加载职业
		obj.cboOccupationStore.load({
			callback : function() {
						obj.cboOccupation.setValue(obj.objCurrReport.MEPDOccupation);
					}
		});
		
		//若是更新旧版的报卡，证件号码默认显示为居民身份证号
		if((trim(obj.objCurrReport.MEPDText4)=="")&&(trim(obj.objCurrReport.MEPDText5)=="")){
			var PatCardInfo=objCommonSrv.GetActiveCardNo(PatientID);
			if (PatCardInfo!="") {
				var arrPatCard=PatCardInfo.split("^");
				obj.cboCardTypeStore.load({
					callback : function() {
						obj.cboCardType.setValue(arrPatCard[0]);
					}
				});				
				obj.txtPatCardNo.setValue(arrPatCard[1]);
			}
		}else{
			// 加载证件类型
			obj.cboCardTypeStore.load({
				callback : function() {
						obj.cboCardType.setValue(obj.objCurrReport.MEPDText4);
				}
			});
			obj.txtPatCardNo.setValue(obj.objCurrReport.MEPDText5);
		}
		
		
		// 加载区域
		obj.cboRegionStore.load({
			callback : function() {
						obj.cboRegion.setValue(obj.objCurrReport.MEPDArea);
					}
		});
		/* update by pylian 2016年新版传染病去掉户籍地址
		// 加载户籍地址
		obj.txtIDAddress.setValue(obj.objCurrReport.MEPDIDAddress);
		//add by zf 20120114 增加地址复制
		if ((trim(obj.txtIDAddress.getValue()) == "")&&(trim(obj.txtAddress.getValue()) != "")) {
			obj.txtIDAddress.setValue(obj.txtAddress.getValue());     //如果户籍地址为空,把现住址复制到户籍地址
		}
		*/
		// 省市县乡
		obj.DisplayArea(obj.objCurrReport.MEPDProvince,
		obj.objCurrReport.MEPDCity,
		obj.objCurrReport.MEPDCounty,
		obj.objCurrReport.MEPDVillage,
		obj.objCurrReport.MEPDRoad);
		
		// 加载诊断
		obj.cboDiseaseStore.load({
			callback : function() {
				var ind = this.find("RowID",obj.objCurrReport.MEPDICDDR);
				if (ind > -1) {
					obj.cboDisease.setValue(obj.objCurrReport.MEPDICDDR);
				}
			},
			scope : obj.cboDiseaseStore,
			add : false
		});
		
		// 加载诊断分类
		obj.cboDegreeStore.load({
			callback : function() {
						obj.cboDegree.setValue(obj.objCurrReport.MEPDDiagDegree);
					}
		});
		
		// 加载发病程度
		obj.cboSickKindStore.load({
			callback : function() {
						obj.cboSickKind.setValue(obj.objCurrReport.MEPDSickKind);
					}
		});
		
		// 发病日期
		obj.dtSickDate.setValue(obj.objCurrReport.MEPDSickDate);
		
		// 诊断日期
		obj.dtDiagnoseDate.setValue(obj.objCurrReport.MEPDDiagDateTime);  //修改诊断日期为诊断日期时间
		
		// 死亡日期
		obj.dtDeadDate.setValue(obj.objCurrReport.MEPDDeathDate);
		
		// 加载接触情况
		obj.cboIntimateStore.load({
			callback : function() {
						obj.cboIntimate.setValue(obj.objCurrReport.MEPDIntimateCode);
					}
		});
		
		// 加载备注
		obj.txtResumeText.setValue(obj.objCurrReport.MEPDDemo);
		
		if (obj.objCurrReport.MEPDIsUpload=="N"){
			obj.btnUpdateCDC.setText("上报CDC");
		}else{
			obj.btnUpdateCDC.setText("取消上报CDC");
		}
		
		// 如果诊断存在对应附卡，则加载。否则，移除附卡，并退出
		var objInfDic = objInfectionManage.GetObjById(obj.objCurrReport.MEPDICDDR);
		if (objInfDic.MIFAppendix == "") {
			obj.AppendixGridPanelStore.removeAll();
			return;
		} else {
			obj.AppendixGridPanelStore.load({
				params : {
					ClassName : 'DHCMed.EPDService.EpidemicSubSrv',
					QueryName : 'QryEpidemicSub',
					Arg1 : (obj.objCurrReport != null ? obj.objCurrReport.RowID : ""),
					Arg2 : objInfDic.MIFAppendix,
					Arg3 : EpisodeID,
					Arg4 : 'Y',
					ArgCnt : 4
				}
			});
		}
		
		window.returnValue = true;
	};
	
	obj.DisplayComps = function(){
		obj.cboOccupation.setDisabled(true);	    // 职业
		obj.cboRegion.setDisabled(true);		    // 区域
		obj.cboCardType.setDisabled(true);		    // 证件类型
		obj.txtPatCardNo.setDisabled(true);		    // 有效证件号
		obj.txtTel.setDisabled(true);			    // 联系电话
		obj.txtRelationName.setDisabled(true);	    // 家长姓名
		obj.txtCompany.setDisabled(true);		    // 工作单位
		//obj.txtIDAddress.setDisabled(true);		    // 户籍地址
		obj.txtAddress.setDisabled(true);		    // 现住址
		obj.cboProvince.setDisabled(true);		    // 省
		obj.cboCity.setDisabled(true);			    // 市
		obj.cboCounty.setDisabled(true);		    // 县
		obj.cboVillage.setDisabled(true);		    // 乡
		obj.txtRoad.setDisabled(true);			    // 门牌号
		obj.cboDisease.setDisabled(true);		    // 诊断
		obj.cboDegree.setDisabled(true);		    // 诊断分类
		obj.cboIntimate.setDisabled(true);		    // 接触情况
		obj.dtSickDate.setDisabled(true);		    // 发病日期
		obj.dtDiagnoseDate.setDisabled(true);	    // 诊断日期
		obj.dtDeadDate.setDisabled(true);		    // 死亡日期
		obj.cboSickKind.setDisabled(true);		    // 发病程度
		obj.txtResumeText.setDisabled(true);	    // 备注
		obj.AppendixGridPanel.setDisabled(true);	// 附卡
	}
	
	/**
	 * 根据报告状态和权限区分标记显示此报告对应的功能按钮
	 */
	 obj.DisplayButtonStatus = function(LocFlag,RepStatus,UploadCode) {
		obj.btnSaveTmp.setVisible(false);   // 保存草稿按钮
		obj.btnSave.setVisible(false);		// 上报按钮
		obj.btnCheck.setVisible(false);	    // 审核按钮
		obj.btnUpdoCheck.setVisible(false);	// 取消审核按钮
		obj.btnCorrect.setVisible(false);   // 订正按钮
		obj.btnReturn.setVisible(false);	// 退回按钮
		obj.btnDelete.setVisible(false);    // 删除按钮
		obj.btnUpdateCDC.setVisible(false); //上报CDC按钮
		obj.btnPrint.setVisible(false);	    // 打印按钮
		if (PortalFlag != 1) {
			obj.btnClose.setVisible(true);	    // 关闭窗口按钮 
		} else {
			obj.btnClose.setVisible(false);	    // 关闭窗口按钮 
		}
		obj.btnOutHospReport.setVisible(false); // 外院已报按钮
		
		// 控制按钮权限，如果 LocFlag=1 代表院感办
		if (LocFlag != '0') {
			switch (RepStatus) {
				case "" : // 无报告
					obj.btnSaveTmp.setVisible(true);    // 保存草稿按钮
					obj.btnSaveTmp.setText("草稿");
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("报卡");
					obj.btnOutHospReport.setVisible(true);    // 外院已报按钮
					break;
				case "6" : // 草稿
					obj.btnSaveTmp.setVisible(true);    // 保存草稿按钮
					obj.btnSaveTmp.setText("草稿");
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("报卡");
					obj.btnDelete.setVisible(true);		// 删除按钮
					obj.btnOutHospReport.setVisible(true);    // 外院已报按钮
					break;
				case "1" : // 待审
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("修改报卡");
					obj.btnCheck.setVisible(true);		// 审核按钮
					obj.btnReturn.setVisible(true);		// 退回按钮
					obj.btnDelete.setVisible(true);		// 删除按钮
					obj.btnPrint.setVisible(true);	    // 打印按钮
					break;
				case "2" : // 已审
					obj.btnUpdoCheck.setVisible(true);	// 取消审核按钮
					obj.btnCorrect.setVisible(true);    // 订正按钮
					obj.btnPrint.setVisible(true);	    // 打印按钮
					obj.btnUpdateCDC.setVisible(true);  // 上报CDC按钮
					break;
				case "3" : // 订正
					obj.btnCheck.setVisible(true);		// 审核按钮
					obj.btnCorrect.setVisible(true);    // 订正按钮
					obj.btnPrint.setVisible(true);	    // 打印按钮
					break;
				case "4" : // 被订
					obj.btnPrint.setVisible(true);	    // 打印按钮
					break;
				case "5" : // 退回
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("修改报卡");
					obj.btnDelete.setVisible(true);		// 删除按钮
					break;
				case "7" : // 删除
					break;
				case "8" : // 外院已报
					obj.btnDelete.setVisible(true);		// 删除按钮
					break;
			}
		} else {
			// 医生站
			switch (RepStatus) {
				case "" : // 无报告
					obj.btnSaveTmp.setVisible(true);    // 保存草稿按钮
					obj.btnSaveTmp.setText("草稿");
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("报卡");
					obj.btnOutHospReport.setVisible(true);    // 外院已报按钮
					break;
				case "6" : // 草稿
					obj.btnSaveTmp.setVisible(true);    // 保存草稿按钮
					obj.btnSaveTmp.setText("草稿");
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("报卡");
					obj.btnDelete.setVisible(true);		// 删除按钮
					obj.btnOutHospReport.setVisible(true);    // 外院已报按钮
					break;
				case "1" : // 待审
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("修改报卡");
					obj.btnDelete.setVisible(true);		// 删除按钮
					obj.btnPrint.setVisible(true);	    // 打印按钮
					break;
				case "2" : // 已审
					obj.btnCorrect.setVisible(true);    // 订正按钮
					break;
				case "3" : // 订正
					obj.btnCorrect.setVisible(true);    // 订正按钮
					obj.btnPrint.setVisible(true);	    // 打印按钮
					break;
				case "4" : // 被订
					break;
				case "5" : // 退回
					obj.btnSave.setVisible(true);		// 上报按钮
					obj.btnSave.setText("修改报卡");
					obj.btnDelete.setVisible(true);		// 删除按钮
					break;
				case "7" : // 删除
					break;
				case "8" : // 外院已报
					obj.btnDelete.setVisible(true);		// 删除按钮
					break;
			}
		}
		
		//根据状态显示
		if (objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS",6,"1")==''){
			obj.btnSaveTmp.setVisible(false);   // 保存草稿按钮
		}
		if (objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS",3,"1")==''){
			obj.btnCorrect.setVisible(false);   // 订正按钮
		}
		
		if ((RepStatus=='4')||(RepStatus=='7')||(RepStatus=='8')){
			obj.DisplayComps();
		}
		
		if (UploadCode=="Y"){
			obj.btnSaveTmp.setVisible(false);   // 保存草稿按钮
			obj.btnSave.setVisible(false);		// 上报按钮
			obj.btnCheck.setVisible(false);	    // 审核按钮
			obj.btnUpdoCheck.setVisible(false);	// 取消审核按钮
			obj.btnCorrect.setVisible(false);   // 订正按钮
			obj.btnReturn.setVisible(false);	// 退回按钮
			obj.btnDelete.setVisible(false);    // 删除按钮
		}
	};
	
	// 医生下诊断触发的事件函数
	obj.cboDisease_expand = function() {
		obj.cboDiseaseStore.load({});
	}
	obj.cboDisease_collapse = function() {
		var DiseaseID = obj.cboDisease.getValue();
		if (DiseaseID == "") {
			return;
		}
		var objInfDic = objInfectionManage.GetObjById(DiseaseID);
		var DiseaseDesc = objInfDic.MIFDisease
		if (DiseaseDesc != "") {
			// 如果诊断属于“艾滋病或HIV”，则备注信息为“结果已告知，信息保密，拒绝访视。”
			// 如果诊断属于“肺结核所有类别”，则备注信息为“患者已联系转结防所。”
			// add by PanLei 2012-02-10 如果未设置备注，则清空备注
			var blnClearResumeFlag = false;
			var arrayEpdDiseaseToResume=obj.EpdDiseaseToResume.split("///");
			for (var i = 0; i < arrayEpdDiseaseToResume.length; i++) {
				var arrsubEpdDiseaseToResume=arrayEpdDiseaseToResume[i].split("~");
				var arrchildEpdDiseaseToResume=arrsubEpdDiseaseToResume[0].split("`");
				for (var j = 0; j < arrchildEpdDiseaseToResume.length; j++){
					if (DiseaseDesc == arrchildEpdDiseaseToResume[j]) {
						var tmpResume = arrsubEpdDiseaseToResume[1];
						if (tmpResume.indexOf('ALT:')<0) {
							obj.txtResumeText.setValue(tmpResume);
						} else {
							var objLISResultSrv = ExtTool.StaticServerObject("DHCMed.EPDService.LISResultSrv");
							var tmpLabItems = tmpResume;
							var arrLabItems = tmpLabItems.split('ALT:');
							if (arrLabItems.length > 1) tmpLabItems = arrLabItems[1];
							var tmpResult = objLISResultSrv.GetLabRstByAdm(EpisodeID,tmpLabItems);
							obj.txtResumeText.setValue(tmpResult);
						}
						blnClearResumeFlag = true;
					}
				}
			}
			
			// add by PanLei 2012-02-10 如果未设置备注，则清空备注
			if(!blnClearResumeFlag) {
				obj.txtResumeText.setValue("");
			}
			
			// 如果诊断属于“乙肝、丙肝、血吸虫”，则“发病程度”必选“慢性（乙型肝炎、丙型肝炎、血吸虫病填写）”
			var arrayEpdDiseaseToSickKind=obj.EpdDiseaseToSickKind.split("///");
			obj.cboSickKindStore.load({
				callback : function(){
					obj.cboSickKind.setValue();
					obj.cboSickKind.setDisabled(false);
					for (var i = 0; i < arrayEpdDiseaseToSickKind.length; i++) {
						var arrsubEpdDiseaseToSickKind=arrayEpdDiseaseToSickKind[i].split("~");
						var arrchildEpdDiseaseToSickKind=arrsubEpdDiseaseToSickKind[0].split("`");
						for (var j = 0; j < arrchildEpdDiseaseToSickKind.length; j++){
							if (DiseaseDesc == arrchildEpdDiseaseToSickKind[j]) {
								obj.cboSickKind.setValue(arrsubEpdDiseaseToSickKind[1]);
								obj.cboSickKind.setDisabled(true);
							}
						}
					}
				}
			});
			
			// 如果诊断属于“所有肝炎类别、淋病、所有梅毒类别、艾滋病、HIV、肺结核涂阳、肺结核仅培阳”  则诊断分类必须为“实验室确诊病例”
			var arrayEpdDiseaseToDegree=obj.EpdDiseaseToDegree.split("///");
			obj.cboDegreeStore.load({
				callback : function(){
					obj.cboDegree.setValue();
					obj.cboDegree.setDisabled(false);
					for (var i = 0; i < arrayEpdDiseaseToDegree.length; i++) {
						var arrsubEpdDiseaseToDegree=arrayEpdDiseaseToDegree[i].split("~");
						var arrchildEpdDiseaseToDegree=arrsubEpdDiseaseToDegree[0].split("`");
						for (var j = 0; j < arrchildEpdDiseaseToDegree.length; j++){
							if (DiseaseDesc == arrchildEpdDiseaseToDegree[j]) {
								obj.cboDegree.setValue(arrsubEpdDiseaseToDegree[1]);
								obj.cboDegree.setDisabled(true);
							}
						}
					}
				}
			});
			
			// 如果诊断存在对应附卡，则加载。否则，移除附卡，并退出
			if (objInfDic.MIFAppendix == "") {
				obj.AppendixGridPanelStore.removeAll();
				return;
			}
			obj.AppendixGridPanelStore.load({
				params : {
					ClassName : 'DHCMed.EPDService.EpidemicSubSrv',
					QueryName : 'QryEpidemicSub',
					Arg1 : (obj.objCurrReport != null ? obj.objCurrReport.RowID : ""),
					Arg2 : objInfDic.MIFAppendix,
					Arg3 : EpisodeID,
					Arg4 : 'Y',
					ArgCnt : 4
				}
			});
		}
	};
	
	// 关闭窗口
	obj.btnClose_click = function() {
		window.close();
		ParrefWindowClose_Handler();
	};
	
	//aStatusCode为报告要求修改为的状态
	//aOperationDesc为操作说明
	obj.SaveReport = function(aStatusCode,aOperationDesc){
		var strMain = obj.SaveToString(obj.objCurrReport, aStatusCode);	// 主卡字符串
		var strSub = obj.SaveSubToString();		                        // 子卡字符串
		var strReportID = objEpdManage.SaveEpidemicReport(strMain, strSub);
		if (strReportID > 0) {
			ReportID=strReportID;
			ExtTool.alert("提示", aOperationDesc + "成功！");
			
			var DiseaseID = obj.cboDisease.getValue();
			var objInfDic = objInfectionManage.GetObjById(DiseaseID);
			var DiseaseDesc = objInfDic.MIFDisease;
			if (DiseaseDesc.indexOf("肺结核")>-1) {
				ExtTool.alert("提示","疑似肺结核病人、肺结核病人请填写转诊单!");
			}
			obj.DisplayReportInfo(strReportID);		// 根据报告ID显示对应的报告信息
			obj.loadPatientInfoForTemplate();		// 根据生成的报告加载病人基本信息模板
			// 显示当前报告状态下的操作按钮状态
			if (obj.objCurrReport){
				obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
			}
			window.returnValue = true;
			ParrefWindowRefresh_Handler();
		} else {
			ExtTool.alert("提示", aOperationDesc + "失败！返回值：" + strReportID);
		}
	}
	
	//aStatusCode为报告要求修改为的状态
	//aOperationDesc为操作说明
	obj.SaveReportAA = function(aStatusCode,aOperationDesc,aTXT){
		var strSysDateTime=objCommonSrv.GetSysDateTime();
		var tmpList=strSysDateTime.split(" ");
		var strReportID=objRepManage.UpdateCheckEPD(obj.objCurrReport.RowID, aStatusCode,session['LOGON.USERID'], tmpList[0], tmpList[1], aTXT)
		if (strReportID > 0) {
			ReportID=strReportID;
			ExtTool.alert("提示", aOperationDesc + "成功！");
			obj.DisplayReportInfo(strReportID);		// 根据报告ID显示对应的报告信息
			obj.loadPatientInfoForTemplate();		// 根据生成的报告加载病人基本信息模板
			// 显示当前报告状态下的操作按钮状态
			if (obj.objCurrReport){
				obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
			}
			window.returnValue = true;
			ParrefWindowRefresh_Handler();
		} else {
			ExtTool.alert("提示", aOperationDesc + "失败！返回值：" + strReportID);
		}
	}
	
	// 保存草稿
	obj.btnSaveTmp_click = function() {
		var strDescription=obj.btnSaveTmp.getText();
		obj.SaveReport(6,strDescription);
		var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"5",obj.objCurrPaadm.AdmRowID);
	}; 
	
	obj.btnOutHospReport_click = function() {
		var InputError = '';
		if (obj.cboDisease.getValue() == "") {
			InputError = InputError + "请选择传染病诊断!<br>";
		}
		if (InputError != '') {
			ExtTool.alert("提示", "外院已报报告 " + InputError);
			return;
		}
		var strDescription=obj.btnOutHospReport.getText();
		obj.SaveReport(8,strDescription);
	}; 
	
	// 上报待审
	obj.btnSave_click = function() {
		//报告数据完整性和逻辑性校验
		if (!obj.ValidateContents()) {
			return;
		}
		var strDescription=obj.btnSave.getText();
		obj.SaveReport(1,strDescription);
		var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"1",obj.objCurrPaadm.AdmRowID);
		
		var result=ExtTool.RunServerMethod("DHCMed.EPDService.CasesXSrv","IsCasesXByReportID",obj.objCurrReport.RowID);
		var Flag = result.split('^')[0];
		var CaseXID=result.split('^')[1];
		if (Flag==1) {
			var Hisret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000040",CaseXID,"4",obj.objCurrPaadm.AdmRowID);		
		}
	};

	// 编辑附卡信息之前触发
	obj.AppendixGridPanel_beforeedit = function(objEvent) {
		if (obj.IsDisableControl) {
			objEvent.cancel = true;
			return;
		}
		var objColModal = objEvent.grid.getColumnModel();
		switch (objEvent.record.get("ItemType")) {
			case "1" :
				objColModal.setEditor(1, new Ext.form.TextField({}));
				break;
			case "2" :
				objColModal.setEditor(1, new Ext.form.NumberField({}));
				break;
			case "3" :
				objColModal.setEditor(1, new Ext.form.DateField({
									format : 'Y-m-d'
								}));
				break;
			case "4" :
				var objConn = new Ext.data.Connection({
							url : ExtToolSetting.RunQueryPageURL
						});
				objConn.on('requestcomplete',
						function(conn, response, Options) {
							if (response.responseText.indexOf('<b>CSP Error</b>') > -1)
								ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
						});
				var objProxy = new Ext.data.HttpProxy(objConn);
				objProxy.on('beforeload', function(objProxy, param) {
							param.ClassName = 'DHCMed.SSService.DictionarySrv';
							param.QueryName = 'QrySSDictionary';
							param.Arg1 = objEvent.record.get("ItemDic");
							param.ArgCnt = 1;
						});
				var objStore = new Ext.data.Store({
							proxy : objProxy,
							reader : new Ext.data.JsonReader({
										root : 'record',
										totalProperty : 'total',
										idProperty : 'Code'
									}, [{
												name : 'checked',
												mapping : 'checked'
											}, {
												name : 'Code',
												mapping : 'Code'
											}, {
												name : 'Description',
												mapping : 'Description'
											}])
						});
				var objCombo = new Ext.form.ComboBox({
							id : 'objCombo'
							// ,width : 120
							// ,minChars : 1
							,
							displayField : 'Description',
							store : objStore,
							triggerAction : 'all',
							valueField : 'Code'
						});
				objStore.load({
							callback : function() {
								objCombo.setValue(objEvent.record.get("HiddenValue"))
							}
						});
				objColModal.setEditor(1, objCombo);
				break;
			case "5" :
				objColModal.setEditor(1, new Ext.form.Checkbox({
							checked : (objEvent.record.get("HiddenValue") == "Y")
						}));
				break;
			case "6" :
				var objConn = new Ext.data.Connection({
							url : ExtToolSetting.RunQueryPageURL
						});
				objConn.on('requestcomplete',
						function(conn, response, Options) {
							if (response.responseText.indexOf('<b>CSP Error</b>') > -1)
								ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
						});
				var objProxy = new Ext.data.HttpProxy(objConn);
				objProxy.on('beforeload', function(objProxy, param) {
							param.ClassName = 'DHCMed.SSService.DictionarySrv';
							param.QueryName = 'QrySSDictionary';
							param.Arg1 = objEvent.record.get("ItemDic");
							param.ArgCnt = 1;
						});
				var objStore = new Ext.data.Store({
							proxy : objProxy,
							reader : new Ext.data.JsonReader({
										root : 'record',
										totalProperty : 'total',
										idProperty : 'Code'
									}, [{
												name : 'checked',
												mapping : 'checked'
											}, {
												name : 'Code',
												mapping : 'Code'
											}, {
												name : 'Description',
												mapping : 'Description'
											}])
						});
				var objCombo =new Ext.ux.form.LovCombo({
							id : 'objCombo',
							name : 'objCombo',
							displayField : 'Description',
							store : objStore,
							valueField : 'Description',
							triggerAction : 'all',
							separator:',',
							hideOnSelect : false,
							//maxHeight : 300,
							editable:false
						});
				objStore.load({
							callback : function() {
								objCombo.setValue(objEvent.record.get("HiddenValue"))
							}
						});
				objColModal.setEditor(1, objCombo);
				break;
		}
	};
	
	// 编辑附卡信息之后触发
	obj.AppendixGridPanel_afteredit = function(objEvent) {
		var objEditor = objEvent.grid.getColumnModel().getCellEditor(1, objEvent.row).field;
		switch (objEvent.record.get("ItemType")) {
			case "3" :
				objEvent.record.set("HiddenValue", objEvent.value.format("Y-m-d"));
				objEvent.record.set("ItemValue", objEvent.value.format("Y-m-d"));
				break;
			case "4" :
				objEvent.record.set("HiddenValue", objEvent.value);
				var objStore = objEditor.getStore();
				var intRecIndex = objStore.findExact("Code", objEvent.value);
				if (intRecIndex != -1) {
					var objRec = objStore.getAt(intRecIndex);
					objEvent.record.set("ItemValue", objRec.get("Description"));
				}
				break;
			case "5" :
				objEvent.record.set("HiddenValue", (objEvent.value ? "Y" : "N"));
				objEvent.record.set("ItemValue", (objEvent.value ? "是" : "否"));
				break;
			default :
				objEvent.record.set("HiddenValue", objEvent.value);
				break;
		}
		objEvent.record.commit();
	};
    /* update by pylian 2016年新版传染病去掉户籍地址
	obj.txtIDAddress_focus = function() {
		var objFrm = new InitAreaPanel(obj.txtIDAddress);
		objFrm.win.show();
	};
	*/
	// 数据校验函数
	obj.ValidateContents = function() {
		var InputError = "";
		if (obj.cboOccupation.getValue() == "") {
			InputError = InputError + "请选择人群分类!<br>";
		}
		if (obj.cboRegion.getValue() == "") {
			InputError = InputError + "请选择区域!<br>";
		}
		
		if (trim(obj.txtTel.getValue()) == "") {
			InputError = InputError + "请填写联系电话!<br>";
		}
		if ((obj.txtRelationName.getValue() == "") && (obj.objCurrPatient.Age <= new Number(trim(obj.EpdRepPatRelRequireMaxAge)))) {
			InputError = InputError + "年龄小于等于" + new Number(trim(obj.EpdRepPatRelRequireMaxAge)) + "岁的患者必需填写家长姓名!<br>";
		}
		/*
		//标准版,25岁以上患者必须填写身份证号
		if ((obj.txtPatCardNo.getValue() == "")&&(obj.objCurrPatient.Age > 25)) {
			InputError = InputError + "请填写身份证号!<br>";
		}*/
	
		
		//职业为幼托儿童,散居儿童,必须填写家长姓名
		var arrayEpdOccupationToRelName = obj.EpdOccupationToRelName.split("`");
		if (trim(obj.txtRelationName.getValue()) == "") {
			for (var i = 0; i < arrayEpdOccupationToRelName.length; i++) {
				if (obj.cboOccupation.getRawValue() == arrayEpdOccupationToRelName[i]) {
					InputError = InputError + "患者人群分类是：" + obj.cboOccupation.getRawValue() + "，请填写家长姓名!<br>";
				}
			}
		}

		// Add By LiKai 2013-01-10
		// 职业为幼托儿童,学生(大中小学生),工作单位不能填无，必须填写学校(幼儿园)、年级、班级 
		var arrayEpdOccupationToCompany = obj.EpdOccupationToCompany.split("`");
		if (trim(obj.txtCompany.getValue()) == "无") {
			for (var i = 0; i < arrayEpdOccupationToCompany.length; i++) {
				if (obj.cboOccupation.getRawValue() == arrayEpdOccupationToCompany[i]) {
					InputError = InputError + "患者人群分类是：" + obj.cboOccupation.getRawValue() + "，请填写学校(幼儿园)、年级、班级!<br>";
				}
			}
		}
		
		// ******************************************************** //
		// Modified By PanLei 2013-03-24
		// 判断如果工作单位为空或者为非法字符等,则不允许上报
		if ((trim(obj.txtCompany.getValue()) == "") || (trim(obj.txtCompany.getValue()) == "\\") || (trim(obj.txtCompany.getValue()) == "\/")) {
			InputError = InputError + "患者工作单位(学校)：请填写工作单位，没有工作单位请填“无”，学生请填写学校、年级、班级!<br>";
		}
		// ******************************************************** //
		
		if (trim(obj.txtAddress.getValue()) == "") {
			InputError = InputError + "请填写现住址!<br>";
		}
		/*
		if (obj.txtIDAddress.getValue() == "") {
			InputError = InputError + "请填写户籍地址!<br>";
		}
		*/
		
		
		if (obj.cboDisease.getValue() == "") {
			InputError = InputError + "请选择传染病诊断!<br>";
		}
		
		var objInfDic = objInfectionManage.GetObjById(obj.cboDisease.getValue());
		
		var PatRegion = obj.cboRegion.getRawValue();
		if ((PatRegion.indexOf('港澳台') > -1)||(PatRegion.indexOf('外籍') > -1)) {
			//不需要填写身份证
		} else {
			// 上报时可先不填写现住址国标 目前不强行控制,由传染科补录
			//if (LocFlag > 0) {
				if ((obj.cboProvince.getValue() == "")
						|| (obj.cboCity.getValue() == "")
						|| (obj.cboCounty.getValue() == "")
						|| (obj.cboVillage.getValue() == "")
						|| (trim(obj.txtRoad.getValue()) == "")) {
					InputError = InputError + "请填写省、市、县、乡、门牌号!<br>";
				}
			//}
			
			//if (LocFlag > 0) {
			    //有效证件号必填后，这里不需要了
				/*
				var PatCardNo = obj.txtPatCardNo.getValue();
				var DiseaseDesc = obj.cboDisease.getRawValue();
				
				if (obj.EpdDiseaseToCardNo != ''){
					var arrayEpdDiseaseToCardNo=obj.EpdDiseaseToCardNo.split("`");
					for (var i = 0; i < arrayEpdDiseaseToCardNo.length; i++){
						if (DiseaseDesc == arrayEpdDiseaseToCardNo[i]){
							if (trim(PatCardNo) == "") {
								InputError = InputError + "请填写身份证号!<br>";
								break;
							}
						}
					}
				} else {
					if (trim(PatCardNo) == "") {
						InputError = InputError + "请填写身份证号!<br>";
					}
				}			
			//}
			// 验证身份证号是否合法(通过正则表达式)
			var CardType=obj.cboCardType.getRawValue();
			if ((CardType.indexOf('身份证')>-1)&&(trim(PatCardNo) != "")){
				if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
					InputError += '输入的身份证号长度不对，或者号码不符合规定！15位号码应全为数字，18位号码末位可以为数字或X(x)。';
				}
			}	*/
			
		}
        if (obj.cboCardType.getValue() == "") {
			InputError = InputError + "请选择证件类型!<br>";
		}
		if (obj.txtPatCardNo.getValue() == "") {
			InputError = InputError + "请填写有效证件号!<br>";
		}
        // 验证身份证号是否合法(通过正则表达式)
        var PatCardNo = obj.txtPatCardNo.getValue();
		var CardType=obj.cboCardType.getRawValue();
		if ((CardType.indexOf('身份证')>-1)&&(trim(PatCardNo) != "")){
			if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
				InputError += '输入的身份证号长度不对，或者号码不符合规定！15位号码应全为数字，18位号码末位可以为数字或X(x)。';
			}
		}

		if (obj.cboDegree.getValue() == "") {
			InputError = InputError + "请选择诊断分类!<br>";
		}
		
		if (obj.dtSickDate.getValue() == "") {
			InputError = InputError + "请选择发病日期!<br>";
		}
		
		if (obj.dtDiagnoseDate.getValue() == "") {
			InputError = InputError + "请选择诊断日期!<br>";
		}
		/* update by zf 20111014  发病程度、与患者密切接触情况暂时设置为非必填项目
		if (obj.cboSickKind.getValue() == "") {
			InputError = InputError + "请选择发病程度!<br>";
		}
		if (obj.cboIntimate.getValue() == "") {
			InputError = InputError + "请选择与患者密切接触情况!<br>";
		}
		*/
		
		// add by PanLei 20120208
		// 解决北京肿瘤医院提出的发病日期不能大于诊断日期或当前日期
		/*var dtSickDateStr = obj.dtSickDate.getRawValue();	//发病日期
		var dtDiagnoseDateStr = obj.dtDiagnoseDate.getRawValue();	//诊断日期
		var dtDeadDateStr = obj.dtDeadDate.getRawValue();//死亡日期
		var sickDate = new Date(Date.parse(dtSickDateStr.replace(/-/g,"/")));
		var diagnoseDate = new Date(Date.parse(dtDiagnoseDateStr.replace(/-/g,"/")));
		var DeadDate = new Date(Date.parse(dtDeadDateStr.replace(/-/g,"/")));
		var thisNowDate = new Date();
		if (sickDate > diagnoseDate) {
			alert("抱歉，发病日期不能大于诊断日期!");
			return false;
		}
		if (sickDate > thisNowDate) {
			alert("抱歉，发病日期不能大于当前日期!");
			return false;
		}
		if (DeadDate > thisNowDate) {
			alert("抱歉，死亡日期不能大于当前日期!");
			return false;
		}
		if (sickDate > DeadDate) {
			alert("抱歉，发病日期不能大于死亡日期!");
			return false;
		}
		//Modified By LiYang 2014-08-08 FixBug:1401 传染病报告查询-双击【待审核】的报告，将【诊断日期】设置为将来的某个时间，可以审核成功
		if (diagnoseDate > thisNowDate) {
			alert("抱歉，诊断日期不能大于当前日期!");
			return false;
		}*/
		
		if (obj.dtSickDate.getValue() != "") {
			if (Common_ComputeDays("dtSickDate")<0) {
				InputError = InputError + "发病日期不能大于当前日期!<br>";				
			}
			if ((obj.dtDiagnoseDate.getValue() != "")&&(Common_ComputeDays("dtSickDate","dtDiagnoseDate")<0)) {
				InputError = InputError + "发病日期不能大于诊断日期!<br>";
			}
		}
		
		if ((obj.dtDiagnoseDate.getValue() != "")&&(Common_ComputeDays("dtDiagnoseDate")<0)) {
			InputError = InputError + "诊断日期不能大于当前日期!<br>";
		}
		
		if (obj.dtDeadDate.getValue() != "") {
			if (Common_ComputeDays("dtDeadDate")<0) {
				InputError = InputError + "死亡日期不能大于当前日期!<br>";
			}
			if ((obj.dtSickDate.getValue() != "")&&(Common_ComputeDays("dtSickDate","dtDeadDate")<0)) {
				InputError = InputError + "发病日期不能大于死亡日期!<br>";
			}
		}
		
		
		// add by zf 传染病附卡增加必填项判断
		var objRec = null;
		var appInputError = "";
		for (var iAppItem = 0; iAppItem < obj.AppendixGridPanelStore.getCount(); iAppItem++) {
			objRec = obj.AppendixGridPanelStore.getAt(iAppItem);
			if (objRec.get("IsNecess")=="是") {
				if ((trim(objRec.get("HiddenValue"))=="")||(trim(objRec.get("ItemValue"))=="")) {
					appInputError = appInputError + objRec.get("ItemCaption") + " 未填写;"
				}
			}
		}
		if (appInputError!='') {
			InputError = InputError + " 附卡:" + appInputError;
		}
		
		if (trim(InputError)) {
			ExtTool.alert("提示", InputError);
			return false;
		}
		
		return true;
	};

	// 获取传染病上报的主卡字符串
	obj.SaveToString = function(objReport, RepStatus) {
		var strDelimiter = String.fromCharCode(1);
		var strTmp = "";
		/* update by pylian 2016年新版传染病去掉户籍地址
		//add by zf 20120114 增加地址复制
		if ((trim(obj.txtIDAddress.getValue()) == "") && (trim(obj.txtAddress.getValue()) != "")) {
			obj.txtIDAddress.setValue(obj.txtAddress.getValue());     //如果户籍地址为空,把现住址复制到户籍地址
		}*/
		
		strTmp += (objReport != null ? objReport.RowID : "") + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDPapmiDR : PatientID) + strDelimiter;  // PatientID
		strTmp += obj.cboRegion.getValue() + strDelimiter;
		strTmp += obj.cboOccupation.getValue() + strDelimiter;
		strTmp += obj.txtRelationName.getValue() + strDelimiter;
		strTmp += obj.cboDisease.getValue() + strDelimiter;
		strTmp += obj.cboIntimate.getValue() + strDelimiter;
		var objInfDic = objInfectionManage.GetObjById(obj.cboDisease.getValue());
		strTmp += objInfDic.MIFKind + strDelimiter; // DiagnoseType
		strTmp += obj.dtSickDate.getRawValue() + strDelimiter;
		strTmp += obj.cboDegree.getValue() + strDelimiter;
		strTmp += obj.dtDiagnoseDate.getRawValue() + strDelimiter;
		strTmp += obj.cboSickKind.getValue() + strDelimiter;
		strTmp += obj.dtDeadDate.getRawValue() + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDLocDR : session['LOGON.CTLOCID']) + strDelimiter;    //报告科室
		strTmp += obj.objCurrRepPlace.Code + strDelimiter;
		strTmp += RepStatus + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDRepUsrDR : session['LOGON.USERID']) + strDelimiter;  //RepUser
		strTmp += (objReport != null ? objReport.MEPDRepDate : "") + strDelimiter;       // RepDate
		strTmp += (objReport != null ? objReport.MEPDRepTime : "") + strDelimiter;       // RepTime
		strTmp += (objReport != null ? objReport.MEPDCheckUsrDR : "") + strDelimiter;    //CheckUser
		strTmp += (objReport != null ? objReport.MEPDCheckDate : "") + strDelimiter;     // CheckDate
		strTmp += (objReport != null ? objReport.MEPDCheckTime : "") + strDelimiter;     // CheckTime
		strTmp += obj.txtResumeText.getValue() + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDDelReason : "") + strDelimiter;     // Del reason
		strTmp += (objReport != null ? objReport.MEPDMepdDR : "") + strDelimiter;        // MEPD_Mepd_DR 被订正记录
		strTmp += obj.txtTel.getValue() + strDelimiter;
		strTmp += obj.txtAddress.getValue() + strDelimiter;
		strTmp += obj.txtCompany.getValue() + strDelimiter;
		//strTmp += obj.txtIDAddress.getValue() + strDelimiter;
		strTmp += '' + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDText1 : EpisodeID) + strDelimiter;  // 就诊号
		strTmp += (objReport != null ? objReport.MEPDText2 : "") + strDelimiter;         // Text2,报告编号
		strTmp += (objReport != null ? objReport.MEPDIsUpload : "N") + strDelimiter;     // 是否上传CDC
		strTmp += obj.cboProvince.getValue() + strDelimiter; // 省
		strTmp += obj.cboCity.getValue() + strDelimiter;     // 市
		strTmp += obj.cboCounty.getValue() + strDelimiter;   // 县
		strTmp += obj.cboVillage.getValue() + strDelimiter;  // 乡
		strTmp += obj.txtRoad.getValue() + strDelimiter;     // 门牌号
		strTmp += (objReport != null ? objReport.MEPDDiagDateTime : "") + strDelimiter;  // 诊断日期时间
		strTmp += (objReport != null ? objReport.MEPDText3 : "") + strDelimiter;    // Text3,报告病区
		//strTmp += (objReport != null ? objReport.MEPDText4 : "") + strDelimiter;    // Text4
		strTmp += obj.cboCardType.getValue() + strDelimiter;                // Text4
		 
		strTmp += obj.txtPatCardNo.getValue() + strDelimiter;        // Text5
		strTmp += (objReport != null ? objReport.MEPDText6 : "") + strDelimiter;    // Text6
		
		//*******************************************************//
		// Add By PanLei 2012-09-23
		// 报传染病卡时，对于填写有身份证号码的病人，要求上报时以身份证为准，回写其身份证号、出生日期
		var PatCardNo = trim(obj.txtPatCardNo.getValue());
		var CardType=obj.cboCardType.getRawValue();
		if ((PatCardNo)&&(CardType.indexOf('身份证')>-1)){
			// 回写身份证号
			//var PapmiIDReturn = objCommonSrv.UpdatePapmiID(PatientID, PatCardNo);
			/* update by zf 20131029
			var strPatDOB = "";
			var tmpYear,tmpMonth,tmpDay;
			
			// 如果身份证号是15位,例如：350424870506202
			if (PatCardNo.length == 15) {
				tmpYear = PatCardNo.substr(6,2);
				if (tmpYear != "19") {
					tmpMonth = PatCardNo.substr(8,2);
					tmpDay = PatCardNo.substr(10,2);
					strPatDOB = "19" + tmpYear + "-" + tmpMonth + "-" + tmpDay;
				}
			}
			
			// 如果身份证号是18位,例如：420536198109216301
			if (PatCardNo.length == 18) {
				tmpYear = PatCardNo.substr(6,4);
				tmpMonth = PatCardNo.substr(10,2);
				tmpDay = PatCardNo.substr(12,2);
				strPatDOB = tmpYear + "-" + tmpMonth + "-" + tmpDay;
			}
			
			// 更新出生日期到病人基本信息
			if (strPatDOB) {
				var DOBReturn = objCommonSrv.UpdatePapmiDOB(PatientID, strPatDOB);
			}
			*/
		}
		//*******************************************************//
		
		return strTmp;
	};

	// 获取传染病上报的子卡字符串
	obj.SaveSubToString = function() {
		var strDelimiter = String.fromCharCode(1);
		var strTmp = "";
		var strRow = "";
		var objRec = null;
		for (var i = 0; i < obj.AppendixGridPanelStore.getCount(); i++) {
			strRow = "";
			objRec = obj.AppendixGridPanelStore.getAt(i);
			strRow += strDelimiter; // Parref
			strRow += strDelimiter; // Rowid
			strRow += strDelimiter; // childsub
			strRow += objRec.get("HiddenValue") + strDelimiter; // value
			strRow += objRec.get("AppendixItemID") + strDelimiter; // AppendixItemID
			if (strTmp != "") {
				strTmp += String.fromCharCode(2);
			}
			strTmp += strRow;
		}
		return strTmp;
	};

	// 打印
	obj.btnPrint_click = function() {
		if (!obj.objCurrReport) {
			ExtTool.alert("错误", "请先保存传染病报告！", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		} else {
			var objCurrInfDic = objInfectionManage.GetObjById(obj.objCurrReport.MEPDICDDR);
			obj.objCurrReport.AppendixID = objCurrInfDic.MIFAppendix;
			//update by zf 20111014 处理AFP打印问题
			var objDic = objDicManage.GetByTypeCode("EPDEMICTYPE",objCurrInfDic.MIFKind, "");
			objCurrInfDic.MIFKindDesc = objDic.Description
			obj.objCurrReport.ICDObj = objCurrInfDic;
			//update by zf 20111014 修改打印地址
			obj.objCurrReport.MEPDAddress = objReportExport.GetPrintAddress(obj.objCurrReport.RowID);
		}
		var reportStatus = obj.objCurrReport.MEPDStatus;
		if (reportStatus > 4) {
			ExtTool.alert("温馨提示", "只能打印“待审”、“已审“、“订正”、“被订”状态的传染病报告!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		}
		
		if ((typeof(IsSecret)!="undefined")&&(IsSecret==1)) {//涉密医院打印时要记录到日志里
			var SecretStr=ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetSecInfoByEpisodeID",EpisodeID);  //取密级信息
			var SecretCode=SecretStr.split('^')[2];
			var ModelName="DHCMedEpdReport";
			var Condition="{ReportID:" +obj.objCurrReport.RowID+"}";
			var Content="{EpisodeID:"+ EpisodeID+",ReportID:"+ obj.objCurrReport.RowID+",ReportStatus:"+ obj.objCurrReport.MEPDStatus+"}";

			var ret= ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","EventLog",ModelName,Condition,Content,SecretCode);
		}
		EpidemicExport.Init(obj);

		//增加打印数字签名功能
		obj.objCurrReport.RepUser.SignID = "";
		var EpdPrintCASign = objConfigManage.GetValueByKeyHosp("EpdPrintCASign", "");
		if (EpdPrintCASign=='1'){
			var ret = EpidemicExport.GetDocSignGif(obj.objCurrReport.RepUser.Rowid);		//获取数字签名图片
			if (ret) {
				obj.objCurrReport.RepUser.SignID = obj.objCurrReport.RepUser.Rowid;
			}else {
				ExtTool.alert("提示", "获取数字签名失败!");
			}
		}
		EpidemicExport.ExportEpidemicToWord(obj.objCurrReport)
	};
	
	//取消审核
	obj.btnUpdoCheck_click = function() {
		ExtTool.confirm("取消审核", "您确定要取消审核这份传染病报告么？", function(btn) {
			if (btn == "yes") {
				var strDescription=obj.btnUpdoCheck.getText();
				obj.SaveReportAA(1,strDescription,"");
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"1",obj.objCurrPaadm.AdmRowID);
			}
		});
	};
	
	// 审核
	obj.btnCheck_click = function() {
		ExtTool.confirm("审核", "您确定要审核这份传染病报告么？", function(btn) {
			if (btn == "yes") {
				//报告数据完整性和逻辑性校验
				if (!obj.ValidateContents()) {
					return;
				}
				var strDescription=obj.btnCheck.getText();
				var objReport=obj.objCurrReport;
				var strSysDateTime=objCommonSrv.GetSysDateTime();
				var tmpList=strSysDateTime.split(" ");
				objReport.MEPDCheckDate=tmpList[0];
				objReport.MEPDCheckTime=tmpList[1];
				objReport.MEPDCheckUsrDR=session['LOGON.USERID'];
				obj.objCurrReport=objReport;
				obj.SaveReport(2,strDescription);
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"2",obj.objCurrPaadm.AdmRowID);
			}
		});
	};
	
	// 订正
	obj.btnCorrect_click = function() {
		ExtTool.confirm("订正", "您确定要订正这份传染病报告么？", function(btn) {
			if (btn == "yes") {
				//报告数据完整性和逻辑性校验
				if (!obj.ValidateContents()) {
					return;
				}
				//保存被订的报告
				var strSysDateTime=objCommonSrv.GetSysDateTime();
				var tmpList=strSysDateTime.split(" ");
				var strReportID=objRepManage.UpdateCheckEPD(obj.objCurrReport.RowID, 4,session['LOGON.USERID'], tmpList[0], tmpList[1], "")
				if (strReportID <= 0) {
					ExtTool.alert("提示", "保存被订报告失败！返回值：" + strReportID);
					return;
				}
				//保存订正后的诊断
				var strDescription=obj.btnCorrect.getText();
				var objReport=obj.objCurrReport;
				objReport.RowID='';
				objReport.MEPDLocDR=session['LOGON.CTLOCID'];
				objReport.MEPDRepUsrDR=session['LOGON.USERID'];
				objReport.MEPDRepDate=tmpList[0];
				objReport.MEPDRepTime=tmpList[1];
				objReport.MEPDCheckUsrDR='';
				objReport.MEPDCheckDate='';
				objReport.MEPDCheckTime='';
				objReport.MEPDDelReason='';
				objReport.MEPDMepdDR=strReportID;
				obj.objCurrReport=objReport;
				obj.SaveReport(3,strDescription);
				
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",strReportID,"6",obj.objCurrPaadm.AdmRowID); //被订
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"7",obj.objCurrPaadm.AdmRowID);  //订正
			}
		});
	};
	
	// 退回
	obj.btnReturn_click = function() {
		ExtTool.prompt("退回", "请输入退回原因!", function(btn, txt) {
			if (btn == 'ok') {
			//Add By pylian 2015-03-27 FixBug：8315 【退回原因】为空时，可以成功退回报告
				if(txt == "")
				{
					ExtTool.alert("提示", "请输入退回原因!");
					return;
				}
				var strDescription=obj.btnReturn.getText();
				obj.SaveReportAA(5,strDescription,txt);
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"3",obj.objCurrPaadm.AdmRowID);
			}		
		});
	};
	
	// 上报CDC
	obj.btnUpdateCDC_click = function() {
		if (obj.objCurrReport){
			var aOperationDesc=obj.btnUpdateCDC.getText();
			ExtTool.confirm(aOperationDesc, "您是否要将此报告"+aOperationDesc+"？", function(btn, txt) {
				if (btn == "yes") {
					var strReportID=objRepManage.UpdateUploadStatus(obj.objCurrReport.RowID,(obj.objCurrReport.MEPDIsUpload == "N" ? "Y" : "N"))
					if (strReportID > 0) {
						ReportID=strReportID;
						ExtTool.alert("提示", aOperationDesc + "成功！");
						obj.DisplayReportInfo(strReportID);		// 根据报告ID显示对应的报告信息
						obj.loadPatientInfoForTemplate();		// 根据生成的报告加载病人基本信息模板
						// 显示当前报告状态下的操作按钮状态
						if (obj.objCurrReport){
							obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
						}
						window.returnValue = true;
						ParrefWindowRefresh_Handler();
						var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"8",obj.objCurrPaadm.AdmRowID);
					} else {
						ExtTool.alert("提示", aOperationDesc + "失败！返回值：" + strReportID);
					}
				}
			});
		}
	};
	
	// 删除
	obj.btnDelete_click = function() {
		ExtTool.prompt("删除", "请输入删除此传染病报告原因!", function(btn, txt) {
			if (btn == "ok") {
				var strDescription=obj.btnDelete.getText();
				if (txt == "") {
					ExtTool.alert("提示", "请填写删除原因！");
					return;
				}
				obj.SaveReportAA(7,strDescription,txt);
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"4",obj.objCurrPaadm.AdmRowID);
			}
		});
	};
	
	// 省市县乡触发事件----------Start
	obj.cboProvince_expand = function() {
		obj.cboProvinceStore.removeAll();
		obj.cboProvinceStore.load({});
	};
	obj.cboProvince_select = function() {
		obj.cboCityStore.removeAll();
		obj.cboCityStore.load({});
		obj.cboCity.setValue('');
		obj.cboCounty.setValue('');
		obj.cboVillage.setValue('');
		obj.txtRoad.setValue('');
	};
	obj.cboCity_expand = function() {
		obj.cboCityStore.removeAll();
		obj.cboCityStore.load({});
	};
	obj.cboCity_select = function() {
		obj.cboCountyStore.removeAll();
		obj.cboCountyStore.load({});
		obj.cboCounty.setValue('');
		obj.cboVillage.setValue('');
		obj.txtRoad.setValue('');
	};
	obj.cboCounty_expand = function() {
		obj.cboCountyStore.removeAll();
		obj.cboCountyStore.load({});
	};
	obj.cboCounty_select = function() {
		obj.cboVillageStore.removeAll();
		obj.cboVillageStore.load({});
		obj.cboVillage.setValue('');
		obj.txtRoad.setValue('');
	};
	obj.cboVillage_expand = function() {
		obj.cboVillageStore.removeAll();
		obj.cboVillageStore.load({});
	};
	obj.cboVillage_select = function() {
		obj.txtRoad.setValue('');
		var StrAddress=obj.cboProvince.getRawValue()+obj.cboCity.getRawValue()+obj.cboCounty.getRawValue()+obj.cboVillage.getRawValue();
		obj.txtAddress.setValue(StrAddress);
	};
	// 省市县乡触发事件----------End
	
	//update by zf 20140714
	//处理因字典项作废导致历史报告显示错误问题
	obj.DisplayArea = function(Province, City, County, Village, Road) {
		var strArea = ExtTool.RunServerMethod("DHCMed.EPDService.AreaDicSrv","GetAreaDics",Province, City, County, Village);
		var arrArea = strArea.split(String.fromCharCode(1));
		if (arrArea.length==8){
			obj.cboProvince.setValue(arrArea[0]);
			obj.cboProvince.setRawValue(arrArea[1]);
			obj.cboCity.setValue(arrArea[2]);
			obj.cboCity.setRawValue(arrArea[3]);
			obj.cboCounty.setValue(arrArea[4]);
			obj.cboCounty.setRawValue(arrArea[5]);
			obj.cboVillage.setValue(arrArea[6]);
			obj.cboVillage.setRawValue(arrArea[7]);
		}
		obj.txtRoad.setValue(Road);
	};
}

// 处理字符串两端的空白
function trim(obj) {
	return obj.toString().replace(/^\s+/, "").replace(/\s+$/, "");
}

//调用父窗体页面刷新
function ParrefWindowRefresh_Handler(){
	if (typeof window.opener != "undefined"){
		if (typeof window.opener.WindowRefresh_Handler != "undefined"){
			window.opener.WindowRefresh_Handler();
		}
	} else {
		if (window.parent) {
			if (typeof window.parent.WindowRefresh_Handler != "undefined"){
				window.parent.WindowRefresh_Handler();
			}
		}
	}
}

//调用父窗体页面关闭
function ParrefWindowClose_Handler(){
	if (typeof window.opener != "undefined"){
		if (typeof window.opener.WindowClose_Handler != "undefined"){
			window.opener.WindowClose_Handler();
		}
	} else {
		if (window.parent) {
			if (typeof window.parent.WindowClose_Handler != "undefined"){
				window.parent.WindowClose_Handler();
			}
		}
	}
}
