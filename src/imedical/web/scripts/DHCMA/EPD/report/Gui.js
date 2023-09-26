function InitReportWin(){
	var obj = new Object();
	obj.ReportID = ReportID;
	obj.MReportID = '';  //被订报告ID

    if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 
	
	// 获取当前上报诊断对应的附卡类型
	obj.LoadCardType = function(aRowID) {
		var CardCode = $m({
			ClassName:"DHCMed.EPDService.AppendixCardSrv",
			MethodName:"GetAppendixCard",
			aDiseaseID:aRowID
		},false);
	
		return CardCode;
	}
	
	obj.LoadDataCss = function() {
		
		$('#lblRelationNotice').text(ServerObj.EpdRepPatRelNotice);
		$('#lblCompanyNotice').text(ServerObj.EpdRepPatCompanyNotice);
		$('#lblCardNotice').text(ServerObj.EpdRepCardNotice);
	    $('#lblCardNotice2').text(ServerObj.EpdRepCardNotice);
	  
	    //人群分类
		obj.cboOccupation =Common_ComboDicCode("cboOccupation","Career");
		//病人属于
		obj.cboRegion =Common_ComboDicCode("cboRegion","EpidemicReportRegion");
		//证件类型
		obj.cboCardType =Common_ComboDicCode("cboCardType","EpidemicCardType");
		//病例分类
		obj.cboDegree =Common_ComboDicCode("cboDegree","EpidemicDiagnoseDegree");
		//发病程度
		obj.cboSickKind =Common_ComboDicCode("cboSickKind","EpidemicSickQuality");
		//接触情况
		obj.cboIntimate =Common_ComboDicCode("cboIntimate","EpidemicContact");
		//临床严重程度
		obj.cboSeverity =Common_ComboDicCode("cboSeverity","EpidemicSeverity");

		//诊断
		obj.cboDisease = $HUI.combobox('#cboDisease', {
			editable: true,
			defaultFilter:4,
			valueField: 'RowID',
			textField: 'MIFDisease',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.EPDService.InfectionSrv&QueryName=QryInfection&ResultSetType=array&argAlias=&argID="+IFRowID;
				$('#cboDisease').combobox('reload',url);
			},
			onSelect :function(record){	
			    var DiseaseDesc = record.MIFDisease;
				if ((DiseaseDesc=="乙型病毒性肝炎")||(DiseaseDesc=="丙型病毒性肝炎")||(DiseaseDesc=="血吸虫病")||(DiseaseDesc=="其它")) {
					$('#cboSickKind').combobox('enable');         //发病程度恢复可选
				}else {
					$('#cboSickKind').combobox('clear');          //清空选中值
					$('#cboSickKind').combobox('disable'); 
				}
				if ((DiseaseDesc=="新型冠状病毒感染的肺炎")||(DiseaseDesc=="新型冠状病毒肺炎")) { 
				 	$('#cboSeverity').combobox('enable');         //临床严重程度恢复可选
				} else {
					$('#cboSeverity').combobox('clear');         //清空选中值
					$('#cboSeverity').combobox('disable');       
				}
				// 如果诊断属于“艾滋病或HIV”，则备注信息为“结果已告知，信息保密，拒绝访视。”
				// 如果诊断属于“肺结核所有类别”，则备注信息为“患者已联系转结防所。”
				var arrayEpdDiseaseToResume=ServerObj.EpdDiseaseToResume.split("///");
				for (var i = 0; i < arrayEpdDiseaseToResume.length; i++) {
					var arrsubEpdDiseaseToResume=arrayEpdDiseaseToResume[i].split("~");
					var arrchildEpdDiseaseToResume=arrsubEpdDiseaseToResume[0].split("`");
					for (var j = 0; j < arrchildEpdDiseaseToResume.length; j++){
						if (DiseaseDesc == arrchildEpdDiseaseToResume[j]) {
							var tmpResume = arrsubEpdDiseaseToResume[1];
							if (tmpResume.indexOf('ALT:')<0) {
								$('#txtResumeText').val(tmpResume);
							}else {
								var tmpLabItems = tmpResume;
								var arrLabItems = tmpLabItems.split('ALT:');
								if (arrLabItems.length > 1) tmpLabItems = arrLabItems[1];
								var tmpResult = $m({
									ClassName:"DHCMed.EPDService.LISResultSrv",
									MethodName:"GetLabRstByAdm",
									aEpisodeID:EpisodeID,
									aLabItems:tmpLabItems
								},false);
								$('#txtResumeText').val(tmpResult);
							}
						}
					}
				}
			},
			onChange:function(newValue,oldValue){	
				if (newValue) {
					var RowID = newValue;
					var NewCardCode = obj.LoadCardType(RowID);
				    
					if (NewCardCode=='HBV') {    	
					    $('#HBVInfoDIV').removeAttr("style"); //显示div
						$.parser.parse('#HBVInfoDIV');        //需要再次解析 不解析全部界面时 滚动条压边，解析全部清空填写数据(除文本框以外)
						obj.LoadHBVInfo();  //加载乙肝病例附卡
					}
					if (NewCardCode=='HIV') {	               			
						$('#HIVInfoDIV').removeAttr("style"); //显示div	
						$.parser.parse('#HIVInfoDIV');        //需要再次解析	
						obj.LoadHIVInfo(); //加载艾滋病附卡
					}
					
					if (NewCardCode=='STD') {  	
						$('#STDInfoDIV').removeAttr("style");  //显示div
						$.parser.parse('#STDInfoDIV');         //需要再次解析
						obj.LoadSTDInfo(); //加载性病附卡				
					}	
				}
				if (oldValue) {
					var RowID = oldValue;
					var OldCardCode = obj.LoadCardType(RowID);
				
					if (OldCardCode!=NewCardCode) {
						if (OldCardCode=='HBV') { 				
							$('#HBVInfoDIV').attr("style","display:none"); //不显示div
						}
						if (OldCardCode=='HIV') {
							$('#HIVInfoDIV').attr("style","display:none"); //不显示div
						}
						if (OldCardCode=='STD') {  	
							$('#STDInfoDIV').attr("style","display:none"); //不显示div		
						}	
					}
				}
			}
		});
		
		//省
		obj.cboProvince = $HUI.combobox('#cboProvince', {
			defaultFilter:4,
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var ParentId = 1;
				var url=$URL+"?ClassName=DHCMed.EPD.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=" + ParentId;
				$('#cboProvince').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){			
				$('#cboCity').combobox('clear');
				$('#cboCounty').combobox('clear');
				$('#cboVillage').combobox('clear');
				$('#txtRoad').val('');
				obj.cboCity.reload();
			}
		});
		//市
		obj.cboCity = $HUI.combobox('#cboCity', {
			defaultFilter:4,
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var ParentId = $('#cboProvince').combobox('getValue');
				var url=$URL+"?ClassName=DHCMed.EPD.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=" + ParentId;
				$('#cboCity').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){
				$('#cboCounty').combobox('clear');
				$('#cboVillage').combobox('clear');
				$('#txtRoad').val('');
				obj.cboCounty.reload();		
			}
		});
		//县
		obj.cboCounty = $HUI.combobox('#cboCounty', {
			defaultFilter:4,
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var ParentId = $('#cboCity').combobox('getValue');
				var url=$URL+"?ClassName=DHCMed.EPD.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=" + ParentId;
				$('#cboCounty').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){
				$('#cboVillage').combobox('setValue','');
				$('#txtRoad').val('');
				obj.cboVillage.reload();
				
			}
		});
		//乡
		obj.cboVillage = $HUI.combobox('#cboVillage', {
			defaultFilter:4,
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var ParentId = $('#cboCounty').combobox('getValue');
				var url=$URL+"?ClassName=DHCMed.EPD.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=" + ParentId;
				$('#cboVillage').combobox('reload',url);
			},
			onSelect:function(record){
				$('#txtRoad').val('');
				$('#txtAddress').val($('#cboProvince').combobox('getText')+$('#cboCity').combobox('getText')+$('#cboCounty').combobox('getText')+$('#cboVillage').combobox('getText'));	
			}
		});
	}
	obj.InitDiseaseCommbo = function(){   //带入临床诊断
		if (!IFRowID) return;
		var DieaseInfo = $m({                  
			ClassName:"DHCMed.EPD.Infection",
			MethodName:"GetStringById",
			id:IFRowID,
			separete:'^'
		},false);
		if (DieaseInfo){
			var DiseaseDesc = DieaseInfo.split("^")[2];
		} else {
			return;
		}
		$('#cboDisease').combobox('setValue',IFRowID);
		$('#cboDisease').combobox('setText',DiseaseDesc);
		if ((DiseaseDesc=="乙型病毒性肝炎")||(DiseaseDesc=="丙型病毒性肝炎")||(DiseaseDesc=="血吸虫病")||(DiseaseDesc=="其它")) {
			$('#cboSickKind').combobox('enable');         //发病程度恢复可选
		}else {
			$('#cboSickKind').combobox('clear');          //清空选中值
			$('#cboSickKind').combobox('disable'); 
		}
		if ((DiseaseDesc=="新型冠状病毒感染的肺炎")||(DiseaseDesc=="新型冠状病毒肺炎")) { 
		 	$('#cboSeverity').combobox('enable');         //临床严重程度恢复可选
		} else {
			$('#cboSeverity').combobox('clear');         //清空选中值
			$('#cboSeverity').combobox('disable');       
		}

		// 如果诊断属于“艾滋病或HIV”，则备注信息为“结果已告知，信息保密，拒绝访视。”
		// 如果诊断属于“肺结核所有类别”，则备注信息为“患者已联系转结防所。”
		var arrayEpdDiseaseToResume=ServerObj.EpdDiseaseToResume.split("///");
		for (var i = 0; i < arrayEpdDiseaseToResume.length; i++) {
			var arrsubEpdDiseaseToResume=arrayEpdDiseaseToResume[i].split("~");
			var arrchildEpdDiseaseToResume=arrsubEpdDiseaseToResume[0].split("`");
			for (var j = 0; j < arrchildEpdDiseaseToResume.length; j++){
				if (DiseaseDesc == arrchildEpdDiseaseToResume[j]) {
					var tmpResume = arrsubEpdDiseaseToResume[1];
					if (tmpResume.indexOf('ALT:')<0) {
						$('#txtResumeText').val(tmpResume);
					}else {
						var tmpLabItems = tmpResume;
						var arrLabItems = tmpLabItems.split('ALT:');
						if (arrLabItems.length > 1) tmpLabItems = arrLabItems[1];
						var tmpResult = $m({                  
							ClassName:"DHCMed.EPDService.LISResultSrv",
							MethodName:"GetLabRstByAdm",
							aEpisodeID:EpisodeID,
							aLabItems:tmpLabItems
						},false);
						$('#txtResumeText').val(tmpResult);
					}
				}
			}
		}
	}
	
	//人群分类联动
	$HUI.combobox('#cboOccupation', {
		onSelect:function(rd){
			var Desc = rd.Description;
			if (Desc=="其他"){	
				$('#trOtherOccupation').removeAttr("style");
				$('#lblCardNotice').attr("style","display:none");  
			}else{
				$('#trOtherOccupation').attr("style","display:none"); 
				$('#lblCardNotice').removeAttr("style");
				$('#txtOtherOccupation').val('')
			}
		}
	});
	
	
	//乙肝病例附卡
	obj.LoadHBVInfo = function() {	     
		//HBsAg阳性时间
		obj.cboHBVHBsAgPositive =Common_ComboDicCode("cboHBVHBsAgPositive","EpdemicHBsAgPositiveTime");
		//肝组织穿刺检测结果
		obj.cboHBVLiverResult =Common_ComboDicCode("cboHBVLiverResult","EpdemicLiverTestResult");
		//抗-HBc IgM 1:1000 稀释检测结果(单选)
		obj.radHBVDilute = Common_RadioDic("radHBVDiluteList","EpdemicPositiveNegative");  
		//恢复期血清HBsAg阴转，抗HBs阳转(没有相应字典)		
		obj.radHBVSerum = Common_RadioDic("radHBVSerumList","EpdHBVHBsAgLab");  	
	}
	
	//艾滋病附卡
	obj.LoadHIVInfo = function() {	     
		//婚姻
		obj.cboMarriage =Common_ComboDicCode("cboHIVMarriage","EpidemicMaritalStatus");
		//文化程度
		obj.cboEducation =Common_ComboDicCode("cboHIVEducation","EpidemicEducation");
		//性病史
		obj.cboSTDHistory =Common_ComboDicCode("cboHIVStdHistory","EpidemicHistory");
		//疾病名称
		//obj.chkHIVDiaType = Common_CheckboxToDic("chkHIVDiaTypeList","EpdSexDiaType");
		obj.chkHIVDiaType = Common_EpdSexDiaType("chkHIVDiaTypeList","EpdSexDiaType","radHIVSexPeriodList","radHIVTrachomaInfList");
		//梅毒分期
		obj.radHIVSexPeriod = Common_RadioDic("radHIVSexPeriodList","EpdSex2Period");
		//沙眼衣原体感染       
		obj.radHIVTrachomaInf = Common_RadioDic("radHIVTrachomaInfList","EpidemicTrachomaInf");
		
		//实验室检测结论
		obj.cboHIVTestResult =Common_ComboDicCode("cboHIVTestResult","EpidemicLabResult");
		
		//最可能的感染途径(单选)
		obj.radHIVPosSource = Common_RadioToDicCol("radHIVPobSourceList","EpidemicPossibleSource","txtHIVPosSource"); 
		//检测样本来源(单选)
		obj.radHIVSimSource = Common_RadioToDicCol("radHIVSimSourceList","EpidemicSimpleSource","txtHIVSimSource"); 
		
	}
	
	//性病附卡
	obj.LoadSTDInfo = function() {		
		//婚姻
		obj.cboMarriage = Common_ComboDicCode("cboSTDMarriage","EpidemicMaritalStatus");
		//文化程度
		obj.cboEducation = Common_ComboDicCode("cboSTDEducation","EpdSexEdu");
		//性病史
		obj.cboSTDHistory = Common_ComboDicCode("cboSTDStdHistory","EpidemicHistory");	
		//疾病名称
		obj.chkSTDDiaType = Common_EpdSexDiaType("chkSTDDiaTypeList","EpdSexDiaType","radSTDSexPeriodList","radSTDTrachomaInfList");
		//梅毒分期
		obj.radSTDSexPeriod = Common_RadioDic("radSTDSexPeriodList","EpdSex2Period");
		//沙眼衣原体感染       
		obj.radSTDTrachomaInf = Common_RadioDic("radSTDTrachomaInfList","EpidemicTrachomaInf");
		
		//实验室检测结论
		obj.cboSTDTestResult =Common_ComboDicCode("cboSTDTestResult","EpidemicLabResult");
		//最可能的感染途径(单选)
		obj.radSTDPosSource = Common_RadioToDicCol("radSTDPobSourceList","EpidemicPossibleSource","txtSTDPosSource");		
		//检测样本来源(单选)
		obj.GetSTDSimSource = Common_RadioToDicCol("radSTDSimSourceList","EpidemicSimpleSource","txtSTDSimSource"); 
		//梅毒RPR/TRUST定性
		obj.radSTDLabResult = Common_RadioDic("radSTDLabResultList","EpdSexLabResult");
		//TP暗视野镜检
		obj.radSTDTPResult = Common_RadioDic("radSTDTPResultList","EpdSexLabResult");
		//梅毒TPPA/TPHA
		obj.radSTDTPHAResult = Common_RadioDic("radSTDTPHAResultList","EpdSexLabResult");
		//TP-ELISA
		obj.radSTDELISAResult = Common_RadioDic("radSTDELISAResultList","EpdSexLabResult");
		//其它检测方法
		obj.radSTDQTResult = Common_RadioDic("radSTDQTResultList","EpdSexLabResult");
		
		//患儿生母
		//梅毒RPR/TRUST定性
		obj.radSTDMLabResult = Common_RadioDic("radSTDMLabResultList","EpdSexLabResult");
		//TP暗视野镜检
		obj.radSTDMTPResult = Common_RadioDic("radSTDMTPResultList","EpdSexLabResult");
		//梅毒TPPA/TPHA
		obj.radSTDMTPHAResult = Common_RadioDic("radSTDMTPHAResultList","EpdSexLabResult");
		//TP-ELISA
		obj.radSTDMELISAResult = Common_RadioDic("radSTDMELISAResultList","EpdSexLabResult");
		//其它检测方法
		obj.radSTDMQTResult = Common_RadioDic("radSTDMQTResultList","EpdSexLabResult");
		
		//梅毒临床表现
		obj.radSTDHave = Common_RadioDic("radSTDHaveList","EpdemicHave");
		//梅毒临床症状
		obj.chkSTDSymbol = Common_CheckboxDic("chkSTDSymbolList","EpdSexSymbolLst2");
		
	}
	
	//附卡疾病名称单独处理
	function Common_EpdSexDiaType () {	
		var ItemCode = arguments[0];
		var DicType = arguments[1];	
		var TypeList1 = arguments[2];
		var TypeList2 = arguments[3];		
		var strList =$m({  
			ClassName:"DHCMed.SSService.DictionarySrv",
			QueryName:"QryDictionary",
			ResultSetType:'array',
			aType:"EpdSexDiaType"
		}, false);
	
		var objStr = JSON.parse(strList);
		var len = objStr.length;
		if (len<1) return;
		
		var count = parseInt(len/2)+1;
		var listHtml="";
		for (var index =0; index< count; index++) {
			var radlen=(((index+1)*2)<len) ? (index+1)*2 : len;
			listHtml +="<div>"; 
			for (var ind=index*2; ind < radlen;ind++) {
				var ValueID    = objStr[ind].myid;
				var ValueCode  = objStr[ind].Code;
				var Value  = objStr[ind].Description;
				if (Value.indexOf('梅毒')>-1) {
					listHtml +="<div class='td-half'><input id="+ItemCode+ValueCode+" type='checkbox' class='hisui-checkbox' label="+Value+" name="+ItemCode+" value="+ValueCode+"><label class='td-label'>(</label><div id="+TypeList1+" style='display:inline-block;'></div><label class='td-label'>)</label></div>"
				}
				else if (Value.indexOf('衣原体感染')>-1) {
					listHtml +="<div class='td-half'><input id="+ItemCode+ValueCode+" type='checkbox' class='hisui-checkbox' label="+Value+" name="+ItemCode+" value="+ValueCode+"><label class='td-label'>(</label><div id="+TypeList2+" style='display:inline-block;'></div><label class='td-label'>)</label></div>"
				}
				else {
					listHtml += "<div class='td-half'><input id="+ItemCode+ValueCode+" type='checkbox' class='hisui-checkbox' label="+Value+" name="+ItemCode+" value="+ValueCode+"></div>";
				}
			   
			}
			listHtml +="</div>"
		}
		$('#'+ItemCode).html(listHtml); 
		$.parser.parse('#'+ItemCode);  //解析checkbox
	}
	//单选字典 追加备注 单独处理
	function Common_RadioToDicCol() {
		var ItemCode = arguments[0];
		var DicType = arguments[1];	
		var TypeList1 = arguments[2];	
		var strList =$m({  
			ClassName:"DHCMed.SSService.DictionarySrv",
			QueryName:"QryDictionary",
			ResultSetType:'array',
			aType:DicType
		}, false);
	
		var objStr = JSON.parse(strList);
		var len = objStr.length;
		if (len<1) return;
		
		var count = parseInt(len/4)+1;
		var listHtml="";
		for (var index =0; index< count; index++) {
			var radlen=(((index+1)*4)<len) ? (index+1)*4 : len;
			listHtml +="<div>"; 
			for (var ind=index*4; ind < radlen;ind++) {
				var ValueID    = objStr[ind].myid;
				var ValueCode  = objStr[ind].Code;
				var Value  = objStr[ind].Description;
				if (Value=="其他") {
					listHtml +="<div class='td-quarter'><input id="+ItemCode+ValueCode+" type='radio' class='hisui-radio' label="+Value+" name="+ItemCode+" value="+ValueCode+"><input class='textbox' placeholder='其他请注明' id="+TypeList1+" style='display:inline-block;margin-left:5px;' ></div>"
				}else {
					listHtml += "<div class='td-quarter'><input id="+ItemCode+ValueCode+" type='radio' class='hisui-radio' label="+Value+" name="+ItemCode+" value="+ValueCode+"></div>";
				}
			}
			listHtml +="</div>"
		}
		$('#'+ItemCode).html(listHtml); 
		$.parser.parse('#'+ItemCode);  //解析radio
	}
	
	InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}
