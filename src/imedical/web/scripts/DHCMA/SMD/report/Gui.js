$(function () {
	InitReportWin();
});

function InitReportWin() {
	var obj = new Object();
	if (ServerObj.EmrOpen == 1) {
		$(".page-footer").css("display", "none");
	}
	obj.SymptomList = new Array();
	obj.ReportID = ServerObj.ReportID;
	obj.EpisodeID = ServerObj.EpisodeID;
	obj.PatientID = ServerObj.PatientID;
	obj.DiseaseID = ServerObj.DiseaseID;
	obj.RepTypeID = ServerObj.RepTypeID;
	obj.RepStatus = ServerObj.RepStatus;
	obj.RepTypeCode = ServerObj.RepTypeCode;
	obj.RepTypeDesc = ServerObj.RepTypeDesc;
	
	if (obj.RepTypeCode == '1') {                                //重性精神疾病发病报告卡
		$('#report-title').text($g('重性精神疾病发病报告卡'));
		$('#tr-AdmitReason').css('display', 'none');
		$('#td-AdmitReason').css('display', 'none');	
		LoadSMDSMIInfo();
	} else if (obj.RepTypeCode == '3') {                         //严重精神障碍患者发病报告卡
		$('#report-title').text($g('严重精神障碍患者发病报告卡'));
		LoadSMDSMIInfo();
	} else if (obj.RepTypeCode == '4') { 
		LoadDischageInfo();
	}else{
		$.messager.alert("提示","报告类型错误,请检查程序配置!",'info');
		return;
	}
	// ****************************** ↓↓↓ 加载公共方法
	obj.cboAdmitReason = Common_ComboToDic("cboAdmitReason", "SMDAdmitReason","",ServerObj.HospID);    //本次入院原因
	obj.cboLocal = Common_ComboToDic("cboLocal", "SMDLocal","",ServerObj.HospID)              		 //人员属地/常住类型
	obj.PatNation=Common_ComboToDic("cboPatNation","SMDNationality","",ServerObj.HospID);              //国籍
	obj.CertType=Common_ComboToDic("cboCertType","SMDZJLX","",ServerObj.HospID);                       //证件类型
	obj.National=Common_ComboToDic("cboNational","SMDMZ","",ServerObj.HospID);                         //民族
	obj.PatRelationList=Common_ComboToDic("cboPatRelationList","SMDPatRelation","",ServerObj.HospID);  //与患者关系
	obj.cboRegAddType = Common_ComboToDic("cboRegAddType", "SMDAddrType","",ServerObj.HospID);         //户籍地址类型
	obj.cboCurrAddType = Common_ComboToDic("cboCurrAddType", "SMDAddrType","",ServerObj.HospID);       //现住址地址类型
	//户籍地址
	obj.cboRegProvince = Common_ComboToArea2("cboRegProvince", "1",1);              // 省
	obj.RegCity = $HUI.combobox('#cboRegProvince', {
		onChange: function (newValue, oldValue) {
			$('#cboRegCity').combobox('clear');
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegCity = Common_ComboToArea2("cboRegCity", "cboRegProvince",2);				// 市
		}
	});
	obj.RegCounty = $HUI.combobox('#cboRegCity', {
		onChange: function (newValue, oldValue) {
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegCounty = Common_ComboToArea2("cboRegCounty", "cboRegCity",3);             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboRegCounty', {
		onChange: function (newValue, oldValue) {
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegVillage = Common_ComboToArea2("cboRegVillage", "cboRegCounty",4);         // 乡
		}
	});
	$HUI.combobox('#cboRegVillage', {
		onSelect: function (record) {
			if (record) {
				$('#txtRegRoad').val('');
				$('#txtRegAddress').val($('#cboRegProvince').combobox('getText') + $('#cboRegCity').combobox('getText') + $('#cboRegCounty').combobox('getText') + $('#cboRegVillage').combobox('getText'));
			}
		}
	});
	//现地址
	obj.cboCurrProvince = Common_ComboToArea2("cboCurrProvince", "1",1);               // 省
	obj.CurrCity = $HUI.combobox('#cboCurrProvince', {
		onChange: function (newValue, oldValue) {
			$('#cboCurrCity').combobox('clear');
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCity = Common_ComboToArea2("cboCurrCity", "cboCurrProvince",2);			  // 市
		}
	});
	obj.CurrCounty = $HUI.combobox('#cboCurrCity', {
		onChange: function (newValue, oldValue) {
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCounty = Common_ComboToArea2("cboCurrCounty", "cboCurrCity",3);            // 县
		}
	});

	obj.CurrVillage = $HUI.combobox('#cboCurrCounty', {
		onChange: function (newValue, oldValue) {
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrVillage = Common_ComboToArea2("cboCurrVillage", "cboCurrCounty",4);         // 乡
		}
	});
	$HUI.combobox('#cboCurrVillage', {
		onSelect: function (record) {
			if (record) {
				$('#txtCurrRoad').val('');
				$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText') + $('#cboCurrCity').combobox('getText') + $('#cboCurrCounty').combobox('getText') + $('#cboCurrVillage').combobox('getText'));
			}
		}
	});
	Common_CheckboxToDic("chkBehaviors","SMDWXXW",5);   										 //既往危险行为
	obj.Assessment=Common_ComboToDic("cboAssessment","SMDWXPG","",ServerObj.HospID);                      //既往危险性评估
	//疾病名称
	obj.cboDisease = $('#cboDisease').lookup({
		panelWidth: 450,
		url: $URL,
		editable: true,
		mode: 'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'IDDesc',
		pagination: true,
		loadMsg: '正在查询',
		//isCombo:true,             //是否输入字符即触发事件，进行搜索
		//minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		queryParams: { ClassName: 'DHCMed.SSService.DiseaseSrv', QueryName: 'QryDisease', aProductCode: 'SMD', aIsActive: 1 },
		columns: [[
			{ field: 'ICD10', title: 'ICD10', width: 80 },
			{ field: 'IDDesc', title: '诊断描述', width: 350 }
		]],
		onBeforeLoad: function (param) {
			var desc = param['q'];
			//if (desc=="") return false;        
			param = $.extend(param, { aAlias: desc }); //将参数q转换为类中的参数
		},
		onSelect: function (index, rowData) {
			var ICD10 = rowData['ICD10'];
			$('#txtDiseaseICD').val(ICD10);            //给相关的ICD10赋值	
			$('#DiseaseId').val(rowData['ID']);
		}
	});
	//药物名称
	InitDrugName("cboDrug1");
	InitDrugName("cboDrug2");
	Common_ComboToDic("cboTreatUnit1","SMDPCDW","");           		 					 //药品1频次
    Common_ComboToDic("cboTreatUnit2","SMDPCDW","");           							 //药品2频次

	$('#cboDisease').bind('change', function (e) {     //疾病名称
		if ($('#cboDisease').lookup("getText") == "") {
			$('#txtDiseaseICD').val('');
			$('#DiseaseId').val("");
		}
	});
	// ****************************** ↑↑↑ 加载公共方法
	
	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;    
}

/// 精神疾病发病报卡
function LoadSMDSMIInfo() {
	Common_ComboToDic("cboPatType","SMDPatType","",ServerObj.HospID);             //患者类型
	Common_ComboToDic("cboAdmType","SMDAdmType","",ServerObj.HospID);             //报卡类型
	Common_ComboToDic("cboOccupation","SMDOccupation","",ServerObj.HospID);       //职业类别
	Common_CheckboxToDic("chkReferralList","SMDReferral",5);    	    //送诊主体  
	Common_ComboToDic("cboHuBie","SMDHB","",ServerObj.HospID);                    //户别
	Common_ComboToDic("cboDegree","SMDducation","",ServerObj.HospID);             //文化程度
	Common_ComboToDic("cboWedLock","SMDMarriage","",ServerObj.HospID);            //婚姻状况
	Common_ComboToDic("cboHouseHold","SMDZFamily","",ServerObj.HospID);           //两系三代严重精神障碍家族史
	Common_ComboToDic("cboIsDrugTreatment","SMDKJSYW","",ServerObj.HospID);       //是否已进行抗精神药物治疗
	Common_ComboToDic("cboLockStatus","SMDGS","",ServerObj.HospID);               //既往关锁情况
	Common_ComboToDic("cboAgree","SMDZQTY","",ServerObj.HospID);                  //知情同意
	
	Common_ComboToDic("cboIsDrug","SMDKJSYW","",ServerObj.HospID);       //是否服药
	Common_ComboToDic("cboIsDrug2","SMDKJSYW","",ServerObj.HospID);       //是否服药 出院康复


	// ****************************** ↓↓↓ 单选、多选事件
	$HUI.checkbox("[name='chkReferralList']",{  //送诊主体选项触发事件
		onChecked:function(e,value){
			var value = $(e.target).attr("label");   //当前选中的值
			if (value==$g('其他')) {	
				$('#txtReferralTxt').removeAttr("disabled");
			}
		},onUnchecked :function(e,value){
			var value = $(e.target).attr("label");
			if (value==$g('其他')) {	
				$('#txtReferralTxt').attr('disabled','disabled');
				$('#txtReferralTxt').val('');
			}
		}
	});
	
	$HUI.combobox('#cboAgree', {    //当选择知情同意为“不同意参加社区服务管理” 知情时间不可填写
		onSelect:function(rd){
			var Desc = rd.DicDesc;
			if (Desc=="同意参加社区服务管理"){	
				$('#txtAgreeDate').datebox('enable');
            }else{
	            $('#txtAgreeDate').datebox('clear');
                $('#txtAgreeDate').datebox('disable');
            }
		}
	});
	// ****************************** ↑↑↑ 单选、多选事件
}

function InitDrugName(Id)
{
	if (Id==""){ 
		return;
	 }
	$('#'+Id).lookup({
		panelWidth: 450,
		url: $URL,
		editable: true,
		mode: 'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'Desc',
		pagination: true,
		loadMsg: '正在查询',
		//isCombo:true,             //是否输入字符即触发事件，进行搜索
		//minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		queryParams: { ClassName: 'DHCMed.SMDService.PsychDrugSrv', QueryName: 'QryPsychDrug'},
		columns:[[  
			{field:'ID',title:'ID',width:45},  
			{field:'Desc',title:'名称',width:200},   
			{field:'Spec',title:'规格',width:120}, 				
			{field:'PackUnit',title:'单位',width:60}  
		]],
		onBeforeLoad: function (param) {
			var desc = param['q'];
			//if (desc=="") return false;        
			param = $.extend(param, { aAlias: desc }); //将参数q转换为类中的参数
		},
		onSelect: function (index, rowData) { 
			var newId=Id.replace("cbo","")  + "Id"
			$('#'+newId).val(rowData["ID"]);
		}
	});
}
//严重精神障碍患者出院信息单
function  LoadDischageInfo() {		
	BuildSymptom();	//精神症状
	
	Common_ComboToDic("cboPrognosis","SMDPrognosis","",ServerObj.HospID);       //住院疗效
	Common_ComboToDic("cboPayment","SMDPaidType","",ServerObj.HospID);          //医疗付费方式
	//康复措施、经费补助
	Common_RadioToDic("radOPTreatmentList","SMDOPTreatment",3);        //门诊治疗情况
	Common_CheckboxToDic("chkTreatMeasureList","SMDRehabMeasure",5);   //本次住院康复措施 
	Common_RadioToDic("radIsFundingList","SMDIsFunding",2);            //本次住院是否获得经费补助
	Common_RadioToDic("radFundsTypeList","SMDFundsType",2);            //经费补助类型 
	Common_RadioToDic("radFundsSourceList","SMDFundsSource",5);        //经费来源 
	Common_CheckboxToDic("chkRehabMeasureList","SMDRehabMeasure",5);   //康复措施 
	
	//下一步治疗方案及康复建议
	InitDrugName("cboRehabDrug1");               //康复用药1
	InitDrugName("cboRehabDrug2");               //康复用药1
	Common_ComboToDic("cboRehabUnit1","SMDPCDW","",ServerObj.HospID);           //药品1频次
    Common_ComboToDic("cboRehabUnit2","SMDPCDW","",ServerObj.HospID);           //药品2频次
    
    // ****************************** ↓↓↓ 单选、多选事件	
	$HUI.checkbox("[name='chkTreatMeasureList']",{  //本次住院康复措施选项触发事件
		onChecked:function(e,value){
			var value = $(e.target).attr("label");   //当前选中的值
			if (value==$g('其他')) {	
				$('#txtTreatMeasureTxt').removeAttr("disabled");
			}
		},onUnchecked :function(e,value){
			var value = $(e.target).attr("label");
			if (value==$g('其他')) {	
				$('#txtTreatMeasureTxt').attr('disabled','disabled');
				$('#txtTreatMeasureTxt').val('');
			}
		}
	});
	$HUI.checkbox("[name='chkRehabMeasureList']",{  //下一步治疗康复措施选项触发事件
		onChecked:function(e,value){
			var value = $(e.target).attr("label");   //当前选中的值
			if (value==$g('其他')) {	
				$('#txtRehabMeasureTxt').removeAttr("disabled");
			}
		},onUnchecked :function(e,value){
			var value = $(e.target).attr("label");
			if (value==$g('其他')) {	
				$('#txtRehabMeasureTxt').attr('disabled','disabled');
				$('#txtRehabMeasureTxt').val('');
			}
		}
	});
	
	$('#radFundsTypeList').radio('disable');
	$('#radFundsSourceList').radio('disable');
	$HUI.radio("[name='radIsFundingList']",{  //本次住院是否获得经费补助选项触发事件
		onChecked:function(e,value){
			var value = $(e.target).attr("label");   //当前选中的值
			if (value==$g('有')) {	
				$('input[type=radio][name=radFundsTypeList]').radio('enable');
				$('input[type=radio][name=radFundsSourceList]').radio('enable');
				$HUI.radio("[name='radFundsSourceList']",{  //经费来源选项触发事件
					onChecked:function(e,value){
						var value = $(e.target).attr("label");   //当前选中的值
						if (value==$g('其他')) {	
							$('#txtFundsSource').removeAttr("disabled");
						}else{
							$('#txtFundsSource').attr('disabled','disabled');
							$('#txtFundsSource').val('');
						}
					}
				});				
			}else{
				$HUI.radio("[name='radFundsTypeList']").setValue('');	
				$HUI.radio("[name='radFundsSourceList']").setValue('');	
				$('#txtFundsSource').val('');
				$('input[type=radio][name=radFundsTypeList]').radio('disable');
				$('input[type=radio][name=radFundsSourceList]').radio('disable');
				$('#txtFundsSource').attr('disabled','disabled');
			}
		}
	});
	// ****************************** ↑↑↑ 单选、多选事件
}
// 严重精神障碍患者出院信息单 精神症状
function  BuildSymptom() {
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:"SMDSymptom"
	},false);

	var htmlStr	='';	
	var dicList = strDicList.split(String.fromCharCode(1));
	var len = dicList.length;
	
	for (var dicIndex = 0; dicIndex < len; dicIndex++) {
		if (dicList[dicIndex] == '') continue;
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var strSymptom =$m({
			ClassName:"DHCMed.SMD.Symptom",
			MethodName:"GetStringByCat",
			aCateID:dicSubList[0]
		},false);
		
		if (strSymptom == '') continue;
		
		if (dicIndex<6) {
			htmlStr += 	'<tr class="report-tr">'
			htmlStr += 		'<td class="report-td top-bold"  style="width:120px;"><font color="red">*</font>'+dicSubList[1]+'</td>'
		}else {
			htmlStr += 	'<tr class="report-tr">'
			htmlStr += 		'<td class="report-td top-bold"  style="width:120px;">'+dicSubList[1]+'</td>'		
		}
		htmlStr += 	    '<td style="vertical-align:top;">'
		var SymptomList = strSymptom.split(String.fromCharCode(1));
		var Symlen = SymptomList.length;
		for (var SymIndex = 0; SymIndex < Symlen; SymIndex++) {
			if (SymptomList[SymIndex] == '') continue;
			var SymSubList = SymptomList[SymIndex].split(String.fromCharCode(2));
			htmlStr += 		'<div class="td-quarter">'				
			htmlStr += 			'<input id=chkSymptom'+SymSubList[0]+' type="checkbox" class="hisui-checkbox" label='+SymSubList[1]+' name="chkSymptom"  value='+SymSubList[0]+'>'
			htmlStr += 		'</div>'
		}
		htmlStr += 	    '</td>'
		htmlStr += 	'</tr>'		    
	}
	
	$('#SymptomInfoTab').append(htmlStr);
	$.parser.parse('#SymptomInfoTab');  //解析checkbox	
}
