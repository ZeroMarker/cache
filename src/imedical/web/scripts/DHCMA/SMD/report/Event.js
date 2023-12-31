﻿function InitReportWinEvent(obj) {
	// 保存报告状态
	obj.SaveRepStatus = function (aReportID,aStatusCode,aTxt,aUserID) {  
		var ret = $m({                  
			ClassName:"DHCMed.SMD.Report",
			MethodName:"CheckReport",
			ReportID:aReportID, 
			StatusCode:aStatusCode, 
			ResumeText:aTxt,
			UserID:aUserID
		},false);
		return ret;
	}
	
	obj.LoadEvent = function () {
		//loadingWindow();
		window.setTimeout(function () {
			obj.InitReport(obj.RepStatus);                    //初始化页面
			//disLoadWindow();
		}, 100);
		//初始 删除追加隐藏元素，用于强制报告保存失败时删除诊断
		top.$("#WinModalEasyUI").empty();
		if ((obj.RepTypeCode == '4')&&(!ServerObj.DischDate)){
			if (obj.RepStatus==""){
				$.messager.confirm($g("提示"), $g("<p>该患者未出院，确定填写草稿？</p>"), function (r) {
					if (r) {
						$('#btnSubmit').hide();
					} else {
						websys_showModal('close');
					}
				})
			}
		}
	}

	/// 初始加载
	obj.InitReport = function (StatusCode) {
		//下诊断弹出报卡时，疾病名称自动置为诊断名称
		if (obj.DiseaseID!='') {
			var objDisease = $cm({                  
				ClassName:"DHCMed.SS.Disease",
				MethodName:"GetObjById",
				aId:obj.DiseaseID
			},false);
			
			$('#cboDisease').lookup('setText',objDisease.IDDesc);
			$('#DiseaseId').val(objDisease.ID);
			$('#txtDiseaseICD').val(objDisease.IDICD10);
		}
		
		var strReport = $m({
			ClassName: "DHCMed.SMDService.ReportSrv",
			MethodName: "GetReportString",
			aReportID: obj.ReportID,
			aRepTypeCode: obj.RepTypeCode,
			aEpisodeID: obj.EpisodeID
		}, false);
		DisplayRepData(strReport);
		
		var SMDFlag = $m({
			ClassName: "DHCMed.SMDService.ReportSrv",
			MethodName: "GetRepIDByPaadm",
			aEpisodeID: obj.EpisodeID
		}, false);
		if ((!obj.ReportID)) {
			DisplayPatient();		
			$('#txtDiagHospital').val(ServerObj.HospDesc);
			$('#txtRepLoc').val(ServerObj.LocDesc);
			$('#txtRepUser').val(ServerObj.UserName);
			$('#txtRepDate').datebox('setValue',Common_GetDate(new Date()));
		}
		$('#txtAdmitDate').datebox('setValue',ServerObj.AdmitDate);
		if (obj.RepTypeCode=="4"){		
			$('#txtDischDate').datebox('setValue',ServerObj.DischDate);	
		}	
		obj.InitRepPowerByStatus(StatusCode);          //按钮显示事件
		return;
	}
	
	$HUI.radio("[name='IsDrug2']",{  //出院康复是否服药
		onChecked:function(e,value){
			var IsDrug2 = $(e.target).val();   //当前选中的值
			if (IsDrug2==1) {	
				$('#cboRehabDrug1').removeAttr("disabled");
				$("input:radio[name='chkRehabIsLong1']").radio("enable");
				$('#cboRehabDrug2').removeAttr("disabled");
				$("input:radio[name='chkRehabIsLong2']").radio("enable");
			}else{
				$('#cboRehabDrug1').attr('disabled','disabled');
				$('#cboRehabDrug1').lookup('setText'," ");
				$('#RehabDrug1Id').val("");
				$("input:radio[name='chkRehabIsLong1']").radio("disable");
				$("input:radio[name='chkRehabIsLong1']").radio();
				$('#txtRehabDrugSpec10').attr('disabled','disabled');
				$('#txtRehabDrugSpec10').val("");
				$('#txtRehabMorn1').attr('disabled','disabled');
				$('#txtRehabMorn1').val("");
				$('#txtRehabNoon1').attr('disabled','disabled');
				$('#txtRehabNoon1').val("");
				$('#txtRehabEven1').attr('disabled','disabled');
				$('#txtRehabEven1').val("");
				$('#txtRehabDrugSpec11').attr('disabled','disabled');
				$('#txtRehabDrugSpec11').val("");
				$('#txtRehabDoseQty1').attr('disabled','disabled');
				$('#txtRehabDoseQty1').val("");
				$('#txtRehabNumber1').attr('disabled','disabled');
				$('#txtRehabNumber1').val("");
				$('#cboRehabUnit1').combobox('disable');
				$('#cboRehabUnit1').combobox('clear');
				
				$('#cboRehabDrug2').attr('disabled','disabled');
				$('#cboRehabDrug2').lookup('setText'," ");
				$('#RehabDrug2Id').val("");
				$("input:radio[name='chkRehabIsLong2']").radio("disable");
				$("input:radio[name='chkRehabIsLong2']").radio();
				$('#txtRehabDrugSpec20').attr('disabled','disabled');
				$('#txtRehabDrugSpec20').val("");
				$('#txtRehabMorn2').attr('disabled','disabled');
				$('#txtRehabMorn2').val("");
				$('#txtRehabNoon2').attr('disabled','disabled');
				$('#txtRehabNoon2').val("");
				$('#txtRehabEven2').attr('disabled','disabled');
				$('#txtRehabEven2').val("");
				$('#txtRehabDrugSpec21').attr('disabled','disabled');
				$('#txtRehabDrugSpec21').val("");
				$('#txtRehabDoseQty2').attr('disabled','disabled');
				$('#txtRehabDoseQty2').val("");
				$('#txtRehabNumber2').attr('disabled','disabled');
				$('#txtRehabNumber2').val("");
				$('#cboRehabUnit2').combobox('disable');
				$('#cboRehabUnit2').combobox('clear');
			}
		}
	});
	$HUI.radio("[name='chkRehabIsLong2']",{  //是否长效药2康复
		onChecked:function(e,value){
			$("input:radio[name='chkRehabIsLong2']").radio("enable");
			var chkRehabIsLong2 = $(e.target).val();   //当前选中的值
			if (chkRehabIsLong2==1) {	
				$('#txtRehabDrugSpec21').removeAttr("disabled");
				$('#txtRehabDoseQty2').removeAttr("disabled");
				$('#txtRehabNumber2').removeAttr("disabled");
				$('#cboRehabUnit2').combobox("enable");
				
				$('#txtRehabDrugSpec20').attr('disabled','disabled');
				$('#txtRehabDrugSpec20').val("");
				$('#txtRehabMorn2').attr('disabled','disabled');
				$('#txtRehabMorn2').val("");
				$('#txtRehabNoon2').attr('disabled','disabled');
				$('#txtRehabNoon2').val("");
				$('#txtRehabEven2').attr('disabled','disabled');
				$('#txtRehabEven2').val("");
			}else{
				$('#txtRehabDrugSpec20').removeAttr("disabled");
				$('#txtRehabMorn2').removeAttr("disabled");
				$('#txtRehabNoon2').removeAttr("disabled");
				$('#txtRehabEven2').removeAttr("disabled");
				
				$('#txtRehabDrugSpec21').attr('disabled','disabled');
				$('#txtRehabDrugSpec21').val("");
				$('#txtRehabDoseQty2').attr('disabled','disabled');
				$('#txtRehabDoseQty2').val("");
				$('#txtRehabNumber2').attr('disabled','disabled');
				$('#txtRehabNumber2').val("");
				$('#cboRehabUnit2').combobox('disable');
				$('#cboRehabUnit2').combobox('clear');
			}
		}
	});
	$HUI.radio("[name='chkRehabIsLong1']",{  //是否长效药1康复
		onChecked:function(e,value){
			$("input:radio[name='chkRehabIsLong1']").radio("enable");
			var chkRehabIsLong1 = $(e.target).val();   //当前选中的值
			if (chkRehabIsLong1==1) {	
				$('#txtRehabDrugSpec11').removeAttr("disabled");
				$('#txtRehabDoseQty1').removeAttr("disabled");
				$('#txtRehabNumber1').removeAttr("disabled");
				$('#cboRehabUnit1').combobox("enable");
				
				$('#txtRehabDrugSpec10').attr('disabled','disabled');
				$('#txtRehabDrugSpec10').val("");
				$('#txtRehabMorn1').attr('disabled','disabled');
				$('#txtRehabMorn1').val("");
				$('#txtRehabNoon1').attr('disabled','disabled');
				$('#txtRehabNoon1').val("");
				$('#txtRehabEven1').attr('disabled','disabled');
				$('#txtRehabEven1').val("");
			}else{
				$('#txtRehabDrugSpec10').removeAttr("disabled");
				$('#txtRehabMorn1').removeAttr("disabled");
				$('#txtRehabNoon1').removeAttr("disabled");
				$('#txtRehabEven1').removeAttr("disabled");

				$('#txtRehabDrugSpec11').attr('disabled','disabled');
				$('#txtRehabDrugSpec11').val("");
				$('#txtRehabDoseQty1').attr('disabled','disabled');
				$('#txtRehabDoseQty1').val("");
				$('#txtRehabNumber1').attr('disabled','disabled');
				$('#txtRehabNumber1').val("");
				$('#cboRehabUnit1').combobox('disable');
				$('#cboRehabUnit1').combobox('clear');
				
			}
		}
	});
	
	$HUI.radio("[name='chkIsLong1']",{  //是否长效药1
		onChecked:function(e,value){
			$("input:radio[name='chkIsLong1']").radio("enable");
			var chkIsLong1 = $(e.target).val();   //当前选中的值
			if (chkIsLong1==1) {	
				$('#txtDrugSpec11').removeAttr("disabled");
				$('#txtTreatDoseQty1').removeAttr("disabled");
				$('#txtNumber1').removeAttr("disabled");
				$('#cboTreatUnit1').combobox("enable");
				
				$('#txtDrugSpec10').attr('disabled','disabled');
				$('#txtDrugSpec10').val("");
				$('#txtUsageMorn1').attr('disabled','disabled');
				$('#txtUsageMorn1').val("");
				$('#txtUsageNoon1').attr('disabled','disabled');
				$('#txtUsageNoon1').val("");
				$('#txtUsageEven1').attr('disabled','disabled');
				$('#txtUsageEven1').val("");
			}else{
				$('#txtDrugSpec10').removeAttr("disabled");
				$('#txtUsageMorn1').removeAttr("disabled");
				$('#txtUsageNoon1').removeAttr("disabled");
				$('#txtUsageEven1').removeAttr("disabled");

				$('#txtDrugSpec11').attr('disabled','disabled');
				$('#txtDrugSpec11').val("");
				$('#txtTreatDoseQty1').attr('disabled','disabled');
				$('#txtTreatDoseQty1').val("");
				$('#txtNumber1').attr('disabled','disabled');
				$('#txtNumber1').val("");
				$('#cboTreatUnit1').combobox('disable');
				$('#cboTreatUnit1').combobox('clear');
			}
		}
	});
	$HUI.radio("[name='chkIsLong2']",{  //是否长效药2
		onChecked:function(e,value){
			$("input:radio[name='chkIsLong2']").radio("enable");
			var chkIsLong2 = $(e.target).val();   //当前选中的值
			if (chkIsLong2==1) {	
				$('#txtDrugSpec21').removeAttr("disabled");
				$('#txtTreatDoseQty2').removeAttr("disabled");
				$('#txtNumber2').removeAttr("disabled");
				$('#cboTreatUnit2').combobox("enable");
				
				$('#txtDrugSpec20').attr('disabled','disabled');
				$('#txtDrugSpec20').val("");
				$('#txtUsageMorn2').attr('disabled','disabled');
				$('#txtUsageMorn2').val("");
				$('#txtUsageNoon2').attr('disabled','disabled');
				$('#txtUsageNoon2').val("");
				$('#txtUsageEven2').attr('disabled','disabled');
				$('#txtUsageEven2').val("");
			}else{
				$('#txtDrugSpec20').removeAttr("disabled");
				$('#txtUsageMorn2').removeAttr("disabled");
				$('#txtUsageNoon2').removeAttr("disabled");
				$('#txtUsageEven2').removeAttr("disabled");
				
				$('#txtDrugSpec21').attr('disabled','disabled');
				$('#txtDrugSpec21').val("");
				$('#txtTreatDoseQty2').attr('disabled','disabled');
				$('#txtTreatDoseQty2').val("");
				$('#txtNumber2').attr('disabled','disabled');
				$('#txtNumber2').val("");
				$('#cboTreatUnit2').combobox('disable');
				$('#cboTreatUnit2').combobox('clear');
			}
		}
	});
	
	$HUI.radio("[name='IsDrug']",{  //是否服药
		onChecked:function(e,value){
			var IsDrug = $(e.target).val();   //当前选中的值
			if (IsDrug==1) {	
				$('#cboDrug1').removeAttr("disabled");
				$("input:radio[name='chkIsLong1']").radio("enable");
				$('#cboDrug2').removeAttr("disabled");
				$("input:radio[name='chkIsLong2']").radio("enable");
			}else{
				$('#cboDrug1').attr('disabled','disabled');
				$('#cboDrug1').lookup('setText'," ");
				$('#Drug1Id').val("");
				$("input:radio[name='chkIsLong1']").radio("disable");
				$("input:radio[name='chkIsLong1']").radio();
				$('#txtDrugSpec10').attr('disabled','disabled');
				$('#txtDrugSpec10').val("");
				$('#txtUsageMorn1').attr('disabled','disabled');
				$('#txtUsageMorn1').val("");
				$('#txtUsageNoon1').attr('disabled','disabled');
				$('#txtUsageNoon1').val("");
				$('#txtUsageEven1').attr('disabled','disabled');
				$('#txtUsageEven1').val("");
				$('#txtDrugSpec11').attr('disabled','disabled');
				$('#txtDrugSpec11').val("");
				$('#txtTreatDoseQty1').attr('disabled','disabled');
				$('#txtTreatDoseQty1').val("");
				$('#txtNumber1').attr('disabled','disabled');
				$('#txtNumber1').val("");
				$('#cboTreatUnit1').combobox('disable');
				$('#cboTreatUnit1').combobox('clear');
				
				$('#cboDrug2').attr('disabled','disabled');
				$('#cboDrug2').lookup('setText'," ");
				$('#Drug2Id').val("");
				$("input:radio[name='chkIsLong2']").radio("disable");
				$("input:radio[name='chkIsLong2']").radio();
				$('#txtDrugSpec20').attr('disabled','disabled');
				$('#txtDrugSpec20').val("");
				$('#txtUsageMorn2').attr('disabled','disabled');
				$('#txtUsageMorn2').val("");
				$('#txtUsageNoon2').attr('disabled','disabled');
				$('#txtUsageNoon2').val("");
				$('#txtUsageEven2').attr('disabled','disabled');
				$('#txtUsageEven2').val("");
				$('#txtDrugSpec21').attr('disabled','disabled');
				$('#txtDrugSpec21').val("");
				$('#txtTreatDoseQty2').attr('disabled','disabled');
				$('#txtTreatDoseQty2').val("");
				$('#txtNumber2').attr('disabled','disabled');
				$('#txtNumber2').val("");
				$('#cboTreatUnit2').combobox('disable');
				$('#cboTreatUnit2').combobox('clear');
			}
		}
	});
	function DisplayPatient(){
		if (ServerObj.CurrAddress) {// 现地址
			$('#cboCurrProvince').combobox('setValue',ServerObj.CurrAddress.split("^")[0]);                    
			$('#cboCurrProvince').combobox('setText',ServerObj.CurrAddress.split("^")[1]);                  
			$('#cboCurrCity').combobox('setValue',ServerObj.CurrAddress.split("^")[2]);                    
			$('#cboCurrCity').combobox('setText',ServerObj.CurrAddress.split("^")[3]);                  
			$('#cboCurrCounty').combobox('setValue',ServerObj.CurrAddress.split("^")[4]);                    
			$('#cboCurrCounty').combobox('setText',ServerObj.CurrAddress.split("^")[5]);                  
			$('#cboCurrVillage').combobox('setValue',ServerObj.CurrAddress.split("^")[6]);                    
			$('#cboCurrVillage').combobox('setText',ServerObj.CurrAddress.split("^")[7]);                  
			$('#txtCurrRoad').val(ServerObj.CurrAddress.split("^")[8]);    
		}	

		if (ServerObj.RegAddress) {// 户籍地址
			$('#cboRegProvince').combobox('setValue',ServerObj.RegAddress.split("^")[0]);                    
			$('#cboRegProvince').combobox('setText',ServerObj.RegAddress.split("^")[1]);                  
			$('#cboRegCity').combobox('setValue',ServerObj.RegAddress.split("^")[2]);                    
			$('#cboRegCity').combobox('setText',ServerObj.RegAddress.split("^")[3]);                  
			$('#cboRegCounty').combobox('setValue',ServerObj.RegAddress.split("^")[4]);                    
			$('#cboRegCounty').combobox('setText',ServerObj.RegAddress.split("^")[5]);                  
			$('#cboRegVillage').combobox('setValue',ServerObj.RegAddress.split("^")[6]);                    
			$('#cboRegVillage').combobox('setText',ServerObj.RegAddress.split("^")[7]);                  
			$('#txtRegRoad').val(ServerObj.RegAddress.split("^")[8]);    
		}
		if (ServerObj.DicInfo) {
			var NationInfo = ServerObj.DicInfo.split("^")[1];
			var CountryInfo = ServerObj.DicInfo.split("^")[2];
			var OccupationInfo = ServerObj.DicInfo.split("^")[3];
			var MaritalInfo = ServerObj.DicInfo.split("^")[4];
			var EducationInfo = ServerObj.DicInfo.split("^")[5];
			var RelationInfo = ServerObj.DicInfo.split("^")[7];
			var CardTypeInfo = ServerObj.DicInfo.split("^")[8];
			//国籍
			$('#cboPatNation').combobox('setValue',((CountryInfo.split(",")[0]) ? CountryInfo.split(",")[0]:'')); 
			$('#cboPatNation').combobox('setText',((CountryInfo.split(",")[0]) ? CountryInfo.split(",")[2]:'')); 
            //就业情况
			$('#cboOccupation').combobox('setValue',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[0]:'')); 
			$('#cboOccupation').combobox('setText',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[2]:'')); 
            //民族
			$('#cboNational').combobox('setValue',((NationInfo.split(",")[0]) ? NationInfo.split(",")[0]:'')); 
			$('#cboNational').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
			//婚姻状况
			$('#cboWedLock').combobox('setValue',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[0]:'')); 
			$('#cboWedLock').combobox('setText',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[2]:'')); 
			//文化程度
			$('#cboDegree').combobox('setValue',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[0]:'')); 
			$('#cboDegree').combobox('setText',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[2]:'')); 
			//证件类型
			//$('#cboCertType').combobox('setValue',((CardTypeInfo.split(",")[0]) ? CardTypeInfo.split(",")[0]:'')); 
			//$('#cboCertType').combobox('setText',((CardTypeInfo.split(",")[0]) ? CardTypeInfo.split(",")[2]:'')); 
			//与患者关系
			$('#cboPatRelationList').combobox('setValue',((RelationInfo.split(",")[0]) ? RelationInfo.split(",")[0]:'')); 
			$('#cboPatRelationList').combobox('setText',((RelationInfo.split(",")[0]) ? RelationInfo.split(",")[2]:'')); 
		}
	}
	
	function DisplayRepData(strReport){
		if (!strReport){
			return false;
		} 
		var arrFieldData = strReport.split(CHR_1);
		var ReportID     = arrFieldData[0];
		var EpisodeID    = arrFieldData[1];
		var PatientID    = arrFieldData[2];
		var RepTypeDr = arrFieldData[3].split(CHR_2);
		var AdmTypeDr = arrFieldData[4].split(CHR_2);
		var PatTypeDr = arrFieldData[5].split(CHR_2);
		var LocalDr   = arrFieldData[6].split(CHR_2);
		var DiseaseDr = arrFieldData[7].split(CHR_2);
		var DiseaseText = arrFieldData[8];
		var StatusDr  = arrFieldData[9].split(CHR_2);
		var CardNo    = arrFieldData[10];
		var WholenessDr = arrFieldData[11].split(CHR_2);
		//患者信息
		var arrFieldItem = arrFieldData[12].split(CHR_2);
		if (arrFieldItem.length > 9) {		
			//显示患者信息
			$('#txtPatName').val(arrFieldItem[0]);
			$('#txtHomeTel').val(arrFieldItem[4]);
			$('#txtSex').val(arrFieldItem[1]);
			$('#txtPersonalID').val(arrFieldItem[3]);
			$('#txtBirthday').datebox('setValue',arrFieldItem[2]);
			$('#txtOPMrNo').val(arrFieldItem[6]);
			$('#txtIPMrNo').val(arrFieldItem[7]);
		}
		var Contactor = arrFieldData[13];
		var ContactorTel = arrFieldData[14];
		var HomeTel = arrFieldData[15];
		var RegAddrTypeDr = arrFieldData[16].split(CHR_2);
		var RegAddress = arrFieldData[17];
		var RegProvince = arrFieldData[18];
		var RegCity = arrFieldData[19];
		var RegCounty = arrFieldData[20];
		var RegVillage = arrFieldData[21];
		var RegRoad = arrFieldData[22];
		var CurrAddrTypeDr = arrFieldData[23].split(CHR_2);
		var CurrAddress = arrFieldData[24];
		var CurrProvince = arrFieldData[25];
		var CurrCity = arrFieldData[26];
		var CurrCounty = arrFieldData[27];
		var CurrVillage = arrFieldData[28];
		var CurrRoad = arrFieldData[29];
		var OccupationDr = arrFieldData[30].split(CHR_2);
		var Company = arrFieldData[31];
		var CompanyTel = arrFieldData[32];
		var SickDate = arrFieldData[33];
		var ReferralDr = arrFieldData[34];
		var ReferralTxt = arrFieldData[35];
		var DiagHospital = arrFieldData[36];
		var DiagDate = arrFieldData[37];
		var AdmitReasonDr = arrFieldData[38].split(CHR_2);
		var SymptomDr = arrFieldData[39];
		var SocietyImpact = arrFieldData[40];
		var SocietyImpactTxt = arrFieldData[41];
		var OPTreatmentDr = arrFieldData[42].split(CHR_2);
		var IPTreatTimes = arrFieldData[43];
		var FirstDrugTreatDate = arrFieldData[44];
		var DischDiagnos = arrFieldData[45].split(CHR_2);
		var PrognosisDr = arrFieldData[46].split(CHR_2);
		var IsFunding = arrFieldData[47].split(CHR_2)
		var FundsType = arrFieldData[48].split(CHR_2);
		var FundsSourceDr = arrFieldData[49].split(CHR_2);
		var FundsSource = arrFieldData[50];  					//修复经费来源其他不显示
		var TreatPharmacy = arrFieldData[51];
		var TreatMeasureDr = arrFieldData[52];
		var TreatMeasureTxt = arrFieldData[53];
		var RehabPharmacy = arrFieldData[54];
		var RehabMeasureDr = arrFieldData[55];
		var RehabMeasureTxt = arrFieldData[56];
		var RehabResume = arrFieldData[57];
		var ReportNote = arrFieldData[58];
		var ReportLoc = arrFieldData[59];
		var RepLocTel = arrFieldData[60];
		var ReportUser = arrFieldData[61];
		var ReportDate = arrFieldData[62];
		var ReportTime = arrFieldData[63];
		var CheckUser = arrFieldData[64];
		var CheckDate = arrFieldData[65];
		var CheckTime = arrFieldData[66];
		var PaymentDr = arrFieldData[67].split(CHR_2);
		var PatRelationDr = arrFieldData[68].split(CHR_2);
		var PatNationDr = arrFieldData[69].split(CHR_2);
		var CertTypeDr = arrFieldData[70].split(CHR_2);
		var NationalDr = arrFieldData[71].split(CHR_2);
		var HuBieDr = arrFieldData[72].split(CHR_2);
		var DegreeDr  = arrFieldData[73].split(CHR_2);
		var WedLockDr = arrFieldData[74].split(CHR_2);
		var HouseHoldDr = arrFieldData[75].split(CHR_2);
		var IsDrugTreatment = arrFieldData[76];
		var LockStatusDr = arrFieldData[77].split(CHR_2);
		var AssessmentDr = arrFieldData[78].split(CHR_2);   //既往危险性评估
		var Agree = arrFieldData[79].split(CHR_2);   //知情同意
		var AgreeDate = arrFieldData[80];
		var Behaviors = arrFieldData[81];
		var Telephone2 = arrFieldData[82];
		var RegProvinceDesc = arrFieldData[83];
		var RegCityDesc = arrFieldData[84];
		var RegCountyDesc = arrFieldData[85];
		var RegVillageDesc = arrFieldData[86];
		var CurrProvinceDesc = arrFieldData[87];
		var CurrCityDesc = arrFieldData[88];
		var CurrCountyDesc = arrFieldData[89];
		var CurrVillageDesc = arrFieldData[90];	
		//是否服药
		var IsDrug = arrFieldData[91];
		//出院康复 是否服药
		var IsDrug2 = arrFieldData[92];
		
		//显示报告信息
		$('#txtContactor').val(Contactor);
		$('#txtContactorTel').val(ContactorTel);
		$('#txtContactorTel2').val(Telephone2);
		$('#txtCompany').val(Company);
		$('#txtCompanyTel').val(CompanyTel);
		
		if (AdmTypeDr!= ''){
			$('#cboAdmType').combobox('setValue',AdmTypeDr[0]);
			$('#cboAdmType').combobox('setText',AdmTypeDr[2]);
		}
		if (PatTypeDr!= ''){
			$('#cboPatType').combobox('setValue',PatTypeDr[0]);
			$('#cboPatType').combobox('setText',PatTypeDr[2]);
		}
	
		var arrNation = arrFieldItem[5].split(CHR_3);
		if (arrNation!=''){
			$('#cboNation').combobox('setValue',arrNation[0]);
			$('#cboNation').combobox('setText',arrNation[2]);	
		}
		
		if (StatusDr!= ''){
			$('#txtRepStatus').val(StatusDr[2]);
		}
		if (WholenessDr!= ''){
			$('#cboIsComplete').combobox('setValue',WholenessDr[0]);
			$('#cboIsComplete').combobox('setText',WholenessDr[2]);
		}
		if (OccupationDr != ''){
			$('#cboOccupation').combobox('setValue',OccupationDr[0]);
			$('#cboOccupation').combobox('setText',OccupationDr[2]);
		}
		
		if ((AdmitReasonDr!= '')&&(AdmitReasonDr.length>1)){
			$('#cboAdmitReason').combobox('setValue',AdmitReasonDr[0]);
			$('#cboAdmitReason').combobox('setText',AdmitReasonDr[2]);
		}
		$('#txtCardNo').val(CardNo);
		if (obj.ReportID) {
			$('#cboDisease').lookup('setText',DiseaseText);
			$('#DiseaseId').val(DiseaseDr[0]);   //用隐藏样式存储公用信息
			$('#txtDiseaseICD').val(DiseaseDr[2]);
		}
		
		$('#txtSickDate').datebox('setValue',SickDate);
		$('#txtDiagHospital').val(DiagHospital);
		$('#txtDiagDate').datebox('setValue',DiagDate);   
		$('#txtRepLoc').val(ReportLoc);
		$('#txtRepLocTel').val(RepLocTel);
		$('#txtRepUser').val(ReportUser);
		$('#txtRepDate').datebox('setValue',ReportDate);
		$('#txtCheckUser').val(CheckUser);
		$('#txtCheckDate').datebox('setValue',CheckDate);
		$('#txtResume').val(ReportNote);
		
		if (DischDiagnos!=""){
			$('#cboDiagnose').lookup('setText',DischDiagnos[2]);
			$('#txtDiseaseICD').val(DischDiagnos[3]);
		}
		if (LocalDr!=""){
			$('#cboLocal').combobox('setValue',LocalDr[0]);
			$('#cboLocal').combobox('setText',LocalDr[2]);
		}
		if (RegAddrTypeDr!=""){
			$('#cboRegAddType').combobox('setValue',RegAddrTypeDr[0]);
			$('#cboRegAddType').combobox('setText',RegAddrTypeDr[2]);	
		}
		$('#cboRegProvince').combobox('setValue',RegProvince);
		$('#cboRegCity').combobox('setValue',RegCity);
		$('#cboRegCounty').combobox('setValue',RegCounty);
		$('#cboRegVillage').combobox('setValue',RegVillage);
		$('#cboRegProvince').combobox('setText',RegProvinceDesc);
		$('#cboRegCity').combobox('setText',RegCityDesc);
		$('#cboRegCounty').combobox('setText',RegCountyDesc);
		$('#cboRegVillage').combobox('setText',RegVillageDesc);
		$('#txtRegRoad').val(RegRoad);
		if (CurrAddrTypeDr!=""){
			$('#cboCurrAddType').combobox('setValue',CurrAddrTypeDr[0]);
			$('#cboCurrAddType').combobox('setText',CurrAddrTypeDr[2]);	
		}
		$('#cboCurrProvince').combobox('setValue',CurrProvince);
		$('#cboCurrCity').combobox('setValue',CurrCity);
		$('#cboCurrCounty').combobox('setValue',CurrCounty);
		$('#cboCurrVillage').combobox('setValue',CurrVillage);
		$('#cboCurrProvince').combobox('setText',CurrProvinceDesc);
		$('#cboCurrCity').combobox('setText',CurrCityDesc);
		$('#cboCurrCounty').combobox('setText',CurrCountyDesc);
		$('#cboCurrVillage').combobox('setText',CurrVillageDesc);
		$('#txtCurrRoad').val(CurrRoad);
		//送诊主体
		var strValue = '';
		var arrDic = ReferralDr.split("#");
		if (arrDic!=""){
			for (var i =0; i < arrDic.length; i ++) {
				var strDic = arrDic[i];
				if (strDic == "") continue;
				strValue = strDic.split("^")[0];
				$('#chkReferralList'+strValue).checkbox('setValue', true);
			}
		}
		$('#txtReferralTxt').val(ReferralTxt);
		
		//****************************** ↓↓↓兼容历史版本
		if (PatRelationDr[2]){
			$('#cboPatRelationList').combobox('setValue',PatRelationDr[0]);
			$('#cboPatRelationList').combobox('setText',PatRelationDr[2]);
		}
		if (PatNationDr[2]){
			$('#cboPatNation').combobox('setValue',PatNationDr[0]);
			$('#cboPatNation').combobox('setText',PatNationDr[2]);    //国籍
		}
		if (CertTypeDr[2]){
			$('#cboCertType').combobox('setValue',CertTypeDr[0]);
			$('#cboCertType').combobox('setText',CertTypeDr[2]);    //证件类型
		}
		if (NationalDr[2]){
			$('#cboNational').combobox('setValue',NationalDr[0]);
			$('#cboNational').combobox('setText',NationalDr[2]);    //民族
		}
		if (HuBieDr[2]){
			$('#cboHuBie').combobox('setValue',HuBieDr[0]);
			$('#cboHuBie').combobox('setText',HuBieDr[2]);    //户别
		}
		if (DegreeDr[2]){
			$('#cboDegree ').combobox('setValue',DegreeDr [0]);
			$('#cboDegree ').combobox('setText',DegreeDr [2]);    //文化程度
		}
		if (WedLockDr[2]){
			$('#cboWedLock').combobox('setValue',WedLockDr[0]);
			$('#cboWedLock').combobox('setText',WedLockDr[2]);    //婚姻状况
		}
		if (HouseHoldDr[2]){
			$('#cboHouseHold').combobox('setValue',HouseHoldDr[0]);
			$('#cboHouseHold').combobox('setText',HouseHoldDr[2]);    //两系三代严重精神障碍家族史
		}
		if (IsDrugTreatment!=""){
			$HUI.radio("#IsDrugTreatment"+IsDrugTreatment).setValue(true);   //是否已进行抗精神药物治疗
		}
		//是否服药
		if (IsDrug!=""){
			$HUI.radio("#IsDrug"+IsDrug).setValue(true);   //是否服药	
		}
		//是否服药
		if (IsDrug2!=""){
			$HUI.radio("#IsDrug2"+IsDrug2).setValue(true);   //是否服药	
		}
		if (LockStatusDr[2]){
			$('#cboLockStatus').combobox('setValue',LockStatusDr[0]);
			$('#cboLockStatus').combobox('setText',LockStatusDr[2]);      //既往关锁情况
		}
		if (AssessmentDr[2]){
			$('#cboAssessment').combobox('setValue',AssessmentDr[0]);
			$('#cboAssessment').combobox('setText',AssessmentDr[2]);      //既往危险性评估
		}
		if (Agree[2]){
			$('#cboAgree').combobox('setValue',Agree[0]);
			$('#cboAgree').combobox('setText',Agree[2]);      //知情同意
			if (Agree[2]=="同意参加社区服务管理"){	
				$('#txtAgreeDate').datebox('enable');
			}
		}			
        if (AgreeDate){		
			$('#txtAgreeDate').datebox('setValue',AgreeDate);       //知情同意时间
		}
		if (FirstDrugTreatDate){	
			$('#txtFDTreatDate').datebox('setValue',FirstDrugTreatDate);//首次抗精神疾病治疗时间
		}
		//****************************** ↑↑↑兼容历史版本
		$('#txtTreatTimes').val(IPTreatTimes);
		//既往危险行为
		var strValue = '';
		var arrDic = Behaviors.split("#");
		if (arrDic!=""){
			for (var i =0; i < arrDic.length; i ++) {
				var strDic = arrDic[i];
				if (strDic == "") continue;
				strValue = strDic.split("^")[0];
				$('#chkBehaviors'+strValue).checkbox('setValue', true);
			}
		}
		var arrayTreatPharmacy = TreatPharmacy.split("#");
		if (arrayTreatPharmacy!=""){
			for (var i = 0;i < arrayTreatPharmacy.length; i++) {
				var strDrug = arrayTreatPharmacy[i];
				if(strDrug == "") continue;
				var arrDrugInfo = strDrug.split("^");
				var index = parseInt(i)+1;
				$('#cboDrug'+index).lookup('setText',arrDrugInfo[1]);
				$('#txtNumber'+index).val(arrDrugInfo[2]);
				$('#txtTreatDoseQty'+index).val(arrDrugInfo[3]);
				$('#Drug'+index+"Id").val(arrDrugInfo[5]);
				$('#cboTreatUnit'+index).combobox("setValue",arrDrugInfo[6]);
				$('#cboTreatUnit'+index).combobox("setText",arrDrugInfo[13]);
			
				var IsLongTerm=arrDrugInfo[8];
				if (IsLongTerm!=""){
					$HUI.radio("#chkIsLong"+index+IsLongTerm).setValue(true);  
					$('#txtDrugSpec'+index+IsLongTerm).val(arrDrugInfo[9]);
				}else{
					$('#txtDrugSpec'+index+"1").val(arrDrugInfo[9]);
					$('#txtDrugSpec'+index+"0").val(arrDrugInfo[9]);
				}					
				$('#txtUsageMorn'+index).val(arrDrugInfo[10]);
				$('#txtUsageNoon'+index).val(arrDrugInfo[11]);
				$('#txtUsageEven'+index).val(arrDrugInfo[12]);
			}
		}
		
		if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4")){
			//付费方式
			if (PaymentDr!=""){
				$('#cboPayment').combobox('setValue',PaymentDr[0]);
				$('#cboPayment').combobox('setText',PaymentDr[2]);
			}		
			$('#txtInsurNo').val(arrFieldItem[8]);
			
			if (OPTreatmentDr!=""){
				$HUI.radio('#radOPTreatmentList'+OPTreatmentDr[0]).setValue(true);
			}
			if (PrognosisDr!=""){	
				$('#cboPrognosis').combobox('setValue',PrognosisDr[0]);	
				$('#cboPrognosis').combobox('setText',PrognosisDr[2]);	
			}
			
			//家庭社会影响
			if (SocietyImpact!=""){
				var arrayStr = SocietyImpact.split(",");
				$('#txtCause').val(arrayStr[0]);
				$('#txtCause1').val(arrayStr[1]);
				$('#txtCause2').val(arrayStr[2]);
				$('#txtCause3').val(arrayStr[3]);
				$('#txtCause4').val(arrayStr[4]);
				$('#txtCause5').val(arrayStr[5]);
				$('#txtCauseNote').val(SocietyImpactTxt);
			}
			
			//精神症状
			var strValue = '';
			var arrDic = SymptomDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					strValue = strDic.split("^")[0];
					$('#chkSymptom'+strValue).checkbox('setValue', true);					
				}
			}

			//住院经费
			if (IsFunding!=""){
				$HUI.radio('#radIsFundingList'+IsFunding[0]).setValue(true);
			}
			if (FundsType!=""){
				$HUI.radio('#radFundsTypeList'+FundsType[0]).setValue(true);
				$HUI.radio('#radFundsSourceList'+FundsSourceDr[0]).setValue(true);
				$('#txtFundsSource').val(FundsSource); 
			}
						
			//住院康复措施
			var strValue = '';
			var arrDic = TreatMeasureDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					strValue = strDic.split("^")[0];
					$('#chkTreatMeasureList'+strValue).checkbox('setValue', true);					
				}
			}
			$('#txtTreatMeasureTxt').val(TreatMeasureTxt);
			
			//康复措施
			var strValue = '';
			var arrDic = RehabMeasureDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					strValue = strDic.split("^")[0];
					$HUI.radio('#chkRehabMeasureList'+strValue).setValue(true);
				}
			}
			$('#txtRehabMeasureTxt').val(RehabMeasureTxt);
			$('#txtRehabResume').val(RehabResume);
			//康复用药
			var arrayRehabPharmacy = RehabPharmacy.split("#");
			if (arrayRehabPharmacy!=""){
				for (var i = 0;i < arrayRehabPharmacy.length; i++) {
					var strDrug = arrayRehabPharmacy[i];
					if(strDrug == "") continue;
					var arrDrugInfo = strDrug.split("^");
					var index = parseInt(i)+1;
					$('#cboRehabDrug'+index).lookup('setText',arrDrugInfo[1]);
					$('#txtRehabNumber'+index).val(arrDrugInfo[2]);
					$('#txtRehabDoseQty'+index).val(arrDrugInfo[3]);
					$('#RehabDrug'+index+"Id").val(arrDrugInfo[5]);
					$('#cboRehabUnit'+index).combobox("setValue",arrDrugInfo[6]);
					$('#cboRehabUnit'+index).combobox("setText",arrDrugInfo[13]);
					var IsLongTerm=arrDrugInfo[8];
					if (IsLongTerm!=""){
						$HUI.radio("#chkRehabIsLong"+index+IsLongTerm).setValue(true);  
						$('#txtRehabDrugSpec'+index+IsLongTerm).val(arrDrugInfo[9]);
					}else{
						$('#txtRehabDrugSpec'+index+"1").val(arrDrugInfo[9]);
						$('#txtRehabDrugSpec'+index+"0").val(arrDrugInfo[9]);
					}					
					$('#txtRehabMorn'+index).val(arrDrugInfo[10]);
					$('#txtRehabNoon'+index).val(arrDrugInfo[11]);
					$('#txtRehabEven'+index).val(arrDrugInfo[12]);
				}
			}		
		}		
	}

	// 保存
	obj.SaveReport = function(StatusCode){
	    var StatusID = $m({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetIdByTypeCode",
			code:StatusCode, 
			type:"SMDRepStatus"
		},false);
	    
	    ///16-详细地址
	    var RegProvinceID = $.trim($('#cboRegProvince').combobox('getValue'));
	    var RegProvince = $.trim($('#cboRegProvince').combobox('getText'));
	    var RegCityID = $.trim($('#cboRegCity').combobox('getValue')); 
	    var RegCity = $.trim($('#cboRegCity').combobox('getText')); 
	    var RegCountyID = $.trim($('#cboRegCounty').combobox('getValue')); 
	    var RegCounty = $.trim($('#cboRegCounty').combobox('getText'));
	    var RegVillageID = $.trim($('#cboRegVillage').combobox('getValue')); 
	    var RegVillage = $.trim($('#cboRegVillage').combobox('getText')); 
	    //23-现住址
	    var CurrProvinceID = $.trim($('#cboCurrProvince').combobox('getValue'));
	    var CurrProvince = $.trim($('#cboCurrProvince').combobox('getText'));
	    var CurrCityID = $.trim($('#cboCurrCity').combobox('getValue'));
	    var CurrCity = $.trim($('#cboCurrCity').combobox('getText'));
	    var CurrCountyID = $.trim($('#cboCurrCounty').combobox('getValue'));
	    var CurrCounty = $.trim($('#cboCurrCounty').combobox('getText'));
	    var CurrVillageID =  $.trim($('#cboCurrVillage').combobox('getValue'));
	    var CurrVillage =  $.trim($('#cboCurrVillage').combobox('getText')); 
	    var strPatInfo = "";
		strPatInfo +=  $.trim($('#txtPatName').val()) + String.fromCharCode(2);
		strPatInfo +=  $.trim($('#txtSex').val()) + String.fromCharCode(2);
		strPatInfo +=  $.trim($('#txtBirthday').datebox("getValue")) + String.fromCharCode(2);
		strPatInfo +=  $.trim($('#txtPersonalID').val()) + String.fromCharCode(2);
		strPatInfo +=  (IsExist('cboNation') ? $.trim($('#cboNation').combobox('getValue')):'') + String.fromCharCode(2); //民族
		strPatInfo +=  (IsExist('txtOPMrNo') ? $.trim($('#txtOPMrNo').val()):'') + String.fromCharCode(2); //门诊号
		strPatInfo +=  (IsExist('txtIPMrNo') ? $.trim($('#txtIPMrNo').val()):'') + String.fromCharCode(2); //住院号
		strPatInfo +=  $.trim($('#txtHomeTel').val())  + String.fromCharCode(2); //电话
		strPatInfo +=  $.trim($('#txtInsurNo').val()) + String.fromCharCode(2); //医保号

		var inputStr = "",strMentalSymptom = "",strTreatPharmacy = "",strRehabPharmacy = "";
		inputStr += obj.ReportID                                    		+ CHR_1;
		inputStr += obj.RepTypeID                                   		+ CHR_1;
		inputStr += (IsExist('cboAdmType') ? $.trim($('#cboAdmType').combobox('getValue')):'')          + CHR_1;
		inputStr += (IsExist('cboPatType') ? $.trim($('#cboPatType').combobox('getValue')):'')          + CHR_1;
		inputStr += obj.EpisodeID                                   		+ CHR_1;
		inputStr += obj.PatientID                                   		+ CHR_1;
		inputStr += $.trim($('#cboLocal').combobox('getValue'))             + CHR_1;
		inputStr += $.trim($('#DiseaseId').val())                           + CHR_1;
		inputStr += ($.trim($('#DiseaseId').val()) ? $.trim($('#cboDisease').lookup('getText')):'')     + CHR_1;
		inputStr += StatusID 	                                    		+ CHR_1;
		inputStr += $.trim($('#txtCardNo').val())                           + CHR_1;	            //CardNo
		inputStr += (IsExist('cboIsComplete') ? $.trim($('#cboIsComplete').combobox('getValue')):'')    + CHR_1;
		inputStr += strPatInfo                                      		+ CHR_1;				//13-病人信息
		inputStr += $.trim($('#txtContactor').val())                        + CHR_1;			    //14-联系人姓名
		inputStr += $.trim($('#txtContactorTel').val())                     + CHR_1;             	//15-联系人电话
		inputStr += (RegProvinceID ? RegProvince:'') +(RegCityID ? RegCity:'')+ (RegCountyID ? RegCounty:'') + (RegVillageID ? RegVillage:'') + $.trim($('#txtRegRoad').val()) + CHR_1; 			//16-详细地址
		
		inputStr += $.trim($('#cboRegAddType').combobox('getValue')) 		+ CHR_1;				//17-户籍地址类型
		inputStr += $.trim($('#cboRegProvince').combobox('getValue'))		+ CHR_1;				//18-
		inputStr += $.trim($('#cboRegCity').combobox('getValue')) 			+ CHR_1;                //19-
		inputStr += $.trim($('#cboRegCounty').combobox('getValue')) 		+ CHR_1;                //20-
		inputStr += $.trim($('#cboRegVillage').combobox('getValue'))		+ CHR_1;               	//21-
		inputStr += $.trim($('#txtRegRoad').val())			                + CHR_1;                 //22-
		inputStr += (CurrProvinceID ? CurrProvince:'') +(CurrCityID ? CurrCity:'')+ (CurrCountyID ? CurrCounty:'') + (CurrVillageID ? CurrVillage:'') + $.trim($('#txtCurrRoad').val()) + CHR_1; 			//23-现住址
		inputStr += $.trim($('#cboCurrAddType').combobox('getValue'))		+ CHR_1;				//24-现住址地址类型
		inputStr += $.trim($('#cboCurrProvince').combobox('getValue')) 		+ CHR_1;             	//25-
		inputStr += $.trim($('#cboCurrCity').combobox('getValue')) 			+ CHR_1;                //26-
		inputStr += $.trim($('#cboCurrCounty').combobox('getValue')) 		+ CHR_1;               	//27-
		inputStr += $.trim($('#cboCurrVillage').combobox('getValue')) 		+ CHR_1;              	//28-
		inputStr += $.trim($('#txtCurrRoad').val())                         + CHR_1;                //29-
		inputStr += (IsExist('cboOccupation') ? $.trim($('#cboOccupation').combobox('getValue')):'')	+ CHR_1;               	//30-职业
		inputStr += $.trim($('#txtCompany').val()) 		                    + CHR_1;                //31-工作单位
		inputStr += $.trim($('#txtCompanyTel').val())	                    + CHR_1;               	//32-工作单位电话
		inputStr += $('#txtSickDate').datebox('getValue') 		   			+ CHR_1;                //33-初次发病时间
		inputStr += Common_CheckboxValue('chkReferralList') 				+ CHR_1;				//34-送诊主体
		inputStr += $.trim($('#txtReferralTxt').val()) 	                    + CHR_1;              	//35-送诊主体（其它）
		inputStr += $.trim($('#txtDiagHospital').val()) 		            + CHR_1;             	//36-确诊医院
		inputStr += $.trim($('#txtDiagDate').combobox('getValue')) 			+ CHR_1;                //37-确诊日期
		inputStr += session['LOGON.CTLOCID'] 				       			+ CHR_1;                //38-上报科室
		inputStr += session['LOGON.USERID'] 				        		+ CHR_1;                //39-上报医师
		inputStr += $.trim($('#txtRepLocTel').val()) 		                + CHR_1;                //40-科室电话
		inputStr += $.trim($('#txtRepDate').datebox('getValue'))			+ CHR_1;                //41-上报日期
		inputStr += ""	                                            		+ CHR_1;                //42-上报时间
		inputStr += $.trim($('#txtResume').val()) 		                    + CHR_1;            	//43-备注
		inputStr += $.trim($('#cboAdmitReason').combobox('getValue'))		+ CHR_1;				//44-本次入院原因

		if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4")){
			inputStr += $.trim($('#txtCause').val())+","+ $.trim($('#txtCause1').val()) +","+ $.trim($('#txtCause2').val()) + "," + $.trim($('#txtCause3').val())+ "," + $.trim($('#txtCause4').val()) + "," + $.trim($('#txtCause5').val()) + CHR_1;		//45-家庭社会影响
			inputStr += $.trim($('#txtCauseNote').val()) 	                + CHR_1;				//46-其他补充说明
			inputStr += Common_RadioValue('radOPTreatmentList')     		+ CHR_1;                //47-门诊治疗情况
			inputStr += $('#txtFDTreatDate').datebox('getValue') 			+ CHR_1;                //48-首次抗精神药物治疗时间
			inputStr += $.trim($('#txtTreatTimes').val()) 	                + CHR_1;                //49-住院次数
			inputStr += $.trim(obj.Disease)                  		       	+ CHR_1;                //50-住院诊断
			inputStr += $.trim($('#cboPrognosis').combobox('getValue')) 	+ CHR_1;                //51-住院疗效
			inputStr += Common_CheckboxValue('chkTreatMeasureList') 		+ CHR_1;				//52-本次住院康复措施
			inputStr += $.trim($('#txtTreatMeasureTxt').val())              + CHR_1;                //53-本次住院康复措施其他 
			inputStr += Common_CheckboxValue('chkRehabMeasureList') 		+ CHR_1;				//54-康复措施
			inputStr += $.trim($('#txtRehabMeasureTxt').val())              + CHR_1;                //55-康复措施其他  
			inputStr += $.trim($('#txtRehabResume').val())  	            + CHR_1;                //56-其他注意事项
			inputStr += Common_RadioValue('radIsFundingList')  	    		+ CHR_1;				//57-是否获得经费补助
			inputStr += Common_RadioValue('radFundsTypeList')       		+ CHR_1;				//58-补助类型
			inputStr += Common_RadioValue('radFundsSourceList')  			+ CHR_1;				//59-经费来源
			inputStr += $.trim($('#txtFundsSource').val())  	            + CHR_1;                //60-经费其他
			inputStr += $.trim($('#cboPayment').combobox('getValue'))    	+ CHR_1;                //61-付费方式
			strMentalSymptom = SaveMentalSymptomToString();              //精神症状
			strTreatPharmacy = SaveTreatPharmacyToString();	            //治疗用药
			strRehabPharmacy = SaveRehabPharmacyToString();				//康复用药	
		}else{
			for(var i=0;i<3 ;i++){
				inputStr =inputStr + CHR_1;
			}
			inputStr += $('#txtFDTreatDate').datebox('getValue') 			+ CHR_1;                //48-首次抗精神药物治疗时间
			inputStr += $.trim($('#txtTreatTimes').val()) 	                + CHR_1;                //49-住院次数
			for(var i=0;i<12 ;i++){
				inputStr =inputStr + CHR_1;
			}
			strTreatPharmacy = SaveTreatPharmacyToString();	            //治疗用药
		}
			
		inputStr += $.trim($('#cboPatRelationList').combobox('getValue'))    	+ CHR_1;             //62-与患者关系
		inputStr += $.trim($('#cboPatNation').combobox('getValue'))         	+ CHR_1;             //63-国籍
		inputStr += $.trim($('#cboCertType').combobox('getValue'))          	+ CHR_1;             //64-证件类型
		inputStr += $.trim($('#cboNational').combobox('getValue'))          	+ CHR_1;             //65-民族
		inputStr += (IsExist('cboHuBie') ? $.trim($('#cboHuBie').combobox('getValue')):'')       			+ CHR_1;             //66-户别
		inputStr += (IsExist('cboDegree') ?$.trim($('#cboDegree').combobox('getValue')):'')             	+ CHR_1;             //67-文化程度
		inputStr += (IsExist('cboWedLock') ?$.trim($('#cboWedLock').combobox('getValue')):'')              	+ CHR_1;             //68-婚姻状况
		inputStr += (IsExist('cboHouseHold') ? $.trim($('#cboHouseHold').combobox('getValue')) :'')         + CHR_1;             //69-两系三代严重精神障碍家族史
		inputStr += Common_RadioValue('IsDrugTreatment')             		    + CHR_1;           	//70-是否已进行抗精神药物治疗
		inputStr += (IsExist('cboLockStatus') ? $.trim($('#cboLockStatus').combobox('getValue')):'')  	    + CHR_1;        //71-既往关锁情况
		inputStr += $.trim($('#cboAssessment').combobox('getValue'))  	        + CHR_1;            //72-既往危险性评估
		inputStr += (IsExist('cboAgree') ? $.trim($('#cboAgree').combobox('getValue')):'')   	            + CHR_1;             //73-知情同意
		inputStr +=  (IsExist('txtAgreeDate') ?  $.trim($('#txtAgreeDate').datebox('getValue')):'')	        + CHR_1;             //74-知情同意时间
		inputStr += Common_CheckboxValue('chkBehaviors') 				        + CHR_1;			 //75-危险行为
		inputStr += $.trim($('#txtContactorTel2').val())                        + CHR_1;             //76-联系人电话副
		//是否服药
		inputStr += Common_RadioValue('IsDrug')             		    		+ CHR_1;           	//77-是否服药
		inputStr += Common_RadioValue('IsDrug2')             		    		+ CHR_1;   
		var ret = $m({                  
			ClassName:"DHCMed.SMD.Report",
			MethodName:"Update",
			aInputStr:inputStr, 
			aMentalSymptom:strMentalSymptom,
			aTreatPharmacy:strTreatPharmacy,
			aRehabPharmacy:strRehabPharmacy,
			aSeparate:CHR_1
		},false);
	    if (parseInt(ret)>0){
			obj.ReportID = ret;
			$.messager.alert("提示",StatusCode== "0" ? "草稿保存成功":"报卡提交成功",'info');
			obj.InitReport(StatusCode);    //初始化页面
			//追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		} else {
			$.messager.alert("提示",StatusCode== "0" ? "草稿保存失败!":"报卡提交失败",'info');
			return;
		}
	}
	
	// 校验
	obj.CheckReport=function(){
		var errStr = "";
		//*************************************** ↓↓↓公共部分
		var PatName = $.trim($('#txtPatName').val());
		var Sex = $.trim($('#txtSex').val());
		var Birthday  = $.trim($('#txtBirthday').datebox('getValue'));
		var PatNation = $.trim($('#cboPatNation').combobox('getText'));  //国籍
		var CertType = $.trim($('#cboCertType').combobox('getText'));    //证件类型
		var PatCardNo = $.trim($('#txtPersonalID').val()); 
		
		var RegProvince = $.trim($('#cboRegProvince').combobox('getValue'));
		var National = $('#cboNational').combobox('getText');      //民族     
		var Contactor = $.trim($('#txtContactor').val());
		var ContactorTel = $.trim($('#txtContactorTel').val());   //联系人电话
		if((PatNation==$g("中国"))&&(CertType!=$g("身份证"))){
				errStr += $g('国籍选择中国时，证件类型必须选择身份证<br>');
			}
		if(((PatNation.indexOf($g("中国")))==-1)&&(CertType!=$g("护照"))){
				errStr += $g('国籍选择非中国时，证件类型必须选择护照<br>');
			}
		if(((PatNation.indexOf($g("港"))!=-1)||(PatNation.indexOf($g("澳"))!=-1)||(PatNation.indexOf($g("台"))!=-1))&&(CertType!=$g("港澳台居民居住证"))){
				errStr += $g('国籍选择港澳台时，证件类型必须选择港澳台居民居住证<br>');
			}
		if(((PatNation.indexOf($g("中国")))!=-1)&&(National==$g("其他"))){
				errStr += $g('国籍选择中国及港澳台时，民族必须选择 56 民族其一<br>');
			}
		if(((PatNation.indexOf($g("中国")))==-1)&&(National!=$g("其他"))){
				errStr += $g('国籍选择非中国时，民族必须选择‘其他’<br>');
			}
		
		
		if ($.trim(ContactorTel) != ""){
			if (!(/(^\d{11}$)/.test(ContactorTel))) {
				errStr += $g('输入的联系人电话号码长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。<br>');
			}
		}	
		var ContactorTel2 = $.trim($('#txtContactorTel2').val());   //联系人电话副
		if ($.trim(ContactorTel2) != ""){
			if (!(/(^\d{11}$)/.test(ContactorTel2))) {
				errStr += $g('输入的联系人电话号码(副)长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。<br>');
			}
		}	
		var RegProvince = $.trim($('#cboRegProvince').combobox('getValue'));
		var RegCity = $.trim($('#cboRegCity').combobox('getValue'));
		var RegCounty = $.trim($('#cboRegCounty').combobox('getValue'));  
		var RegVillage = $.trim($('#cboRegVillage').combobox('getValue'));
		var RegRoad = $.trim($('#txtRegRoad').val());
		var RegAddType = $.trim($('#cboRegAddType').combobox('getValue')); 
		
		var CurrProvince = $.trim($('#cboCurrProvince').combobox('getValue'));
		var CurrCity = $.trim($('#cboCurrCity').combobox('getValue'));
		var CurrCounty = $.trim($('#cboCurrCounty').combobox('getValue'));  
		var CurrVillage = $.trim($('#cboCurrVillage').combobox('getValue'));
		var CurrRoad = $.trim($('#txtCurrRoad').val());
		var CurrAddType = $.trim($('#cboCurrAddType').combobox('getValue')); 
		var SickDate = $('#txtSickDate').datebox('getValue');	
		var RepLocTel = $.trim($('#txtRepLocTel').val());	
		var PatRelationList = $.trim($('#cboPatRelationList').combobox('getValue'));             //与患者关系
		var FDTreatDate = $.trim($('#txtFDTreatDate').datebox('getValue')); //首次抗精神病治疗时间 txtFDTreatDate
		var TreatTimes = $.trim($('#txtTreatTimes').val()); 				//住院曾住精神专科医院/综合医院精神科 
		var Assessment = $.trim($('#cboAssessment').combobox('getValue')); 	//既往危险性评估
		var CertTypeDesc = $.trim($('#cboCertType').combobox('getText'));    //证件类型描述
		var IsLongTerm1=$.trim($("input[name='chkIsLong1']:checked").val());	//是否为长效药1
		var txtUsageMorn1=$('#txtUsageMorn1').val()		//早
		var txtUsageNoon1=$('#txtUsageNoon1').val()		//中
		var txtUsageEven1=$('#txtUsageEven1').val()		//晚
		var txtDrugSpec11=$('#txtDrugSpec11').val()
		var txtTreatDoseQty1=$('#txtTreatDoseQty1').val()
		var txtNumber1=$('#txtNumber1').val()
		var cboTreatUnit1=$('#cboTreatUnit1').combobox('getValue')
		
		var IsLongTerm2=$.trim($("input[name='chkIsLong2']:checked").val());	//是否为长效药2
		var txtUsageMorn2=$('#txtUsageMorn2').val()		//早
		var txtUsageNoon2=$('#txtUsageNoon2').val()		//中
		var txtUsageEven2=$('#txtUsageEven2').val()		//晚
		var txtDrugSpec21=$('#txtDrugSpec21').val()
		var txtTreatDoseQty2=$('#txtTreatDoseQty2').val()
		var txtNumber2=$('#txtNumber2').val()
		var cboTreatUnit2=$('#cboTreatUnit2').combobox('getValue')
		var Behaviors=Common_CheckboxValue('chkBehaviors')                          //既往危险行为
		
		var txtCause = $('#txtCause').val()           //危害公共安全或他人安全的行为
		var txtCause1 = $('#txtCause1').val()           //存在危害公共安全或他人安全的危险
		var txtCause2 = $('#txtCause2').val()           //病情复发、精神状况明显恶化
		var txtCause3 = $('#txtCause3').val()           //急性或严重药物不良反应
		var txtCause4 = $('#txtCause4').val()           //存在自伤自杀行为的危险
		var txtCause5 = $('#txtCause5').val()           //自伤自杀行为
		
		if ($.trim(RepLocTel) != ""){
			if (!(/(^\d{11}$)/.test(RepLocTel))) {
				errStr += $g('输入的科室电话号码长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。<br>');
			}
		}	
		var DiagDate = $('#txtDiagDate').datebox('getValue');
		var AdmitDate = $('#txtAdmitDate').datebox('getValue');
		var Disease = $.trim($('#cboDisease').lookup('getText'));
		var RepDate = $('#txtRepDate').datebox('getValue');
		if ((obj.RepTypeCode != '1')&&(PatName=="")) { errStr = errStr + $g("请填写姓名!<br>"); }
		if ((obj.RepTypeCode != '1')&&(Sex=="")) { errStr = errStr + $g("请填写性别!<br>"); }
		if (Birthday=="") { errStr = errStr + $g("请填写出生日期!<br>"); }
		if (CertType=="") { errStr = errStr + $g("请选择证件类型!<br>"); }
		if (!$.trim(PatCardNo)){errStr += $g('请填写证件号码!<br>');}
		if (($.trim(PatCardNo)!= "")&&(CertTypeDesc == $g("身份证"))){
			if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
				errStr += $g('输入的身份证号长度不对，或者号码不符合规定！15位号码应全为数字，18位号码末位可以为数字或X。<br>');
			}
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
		}
		var IsDrug=$("input[name='IsDrug']:checked").val();							//是否服药
		if (IsDrug==undefined) { errStr = errStr + $g("治疗请选择是否服药!<br>"); }
		if((IsDrug=='1')&&(($('#cboDrug2').val()=="")&&($('#cboDrug1').val()==""))){
				errStr = errStr + $g("请填写治疗的药物!<br>");
		}
		var chkIsLong1=$("input[name='chkIsLong1']:checked").val();
		if ((chkIsLong1==undefined) && (($('#cboDrug1').val()!="")&&($('#Drug1Id').val()!=""))) { 
			errStr = errStr + $g("治疗的药物一请选择是否为长效药!<br>"); 
		}
		if ((chkIsLong1!=undefined) && (($('#cboDrug1').val()==""))) { 
			errStr = errStr + $g("请填写治疗的药物一!<br>"); 
		}
		var chkIsLong2=$("input[name='chkIsLong2']:checked").val();
		if ((chkIsLong2==undefined) && (($('#cboDrug2').val()!="")&&($('#Drug2Id').val()!=""))) { 
			errStr = errStr + $g("治疗的药物二请选择是否为长效药!<br>"); 
		}
		if ((chkIsLong2!=undefined) && (($('#cboDrug2').val()==""))) { 
			errStr = errStr + $g("请填写治疗的药物二!<br>"); 
		}
		if (PatNation=="") { errStr = errStr + $g("请选择国籍或地区!<br>"); }
		if (National=="") { errStr = errStr + $g("请选择民族!<br>"); }
		if (Contactor=="") { errStr = errStr + $g("请填写联系人姓名!<br>"); }
		if (ContactorTel=="") { errStr = errStr + $g("请填写联系人电话!<br>"); }
		if (PatRelationList=="") { errStr = errStr + $g("请选择与患者关系!<br>"); }
		if (RegProvince=="") { errStr = errStr + $g("请选择户籍地省!<br>"); }
		if (RegCity=="") { errStr = errStr + $g("请选择户籍地市!<br>"); }
		if (RegCounty=="") { errStr = errStr + $g("请选择户籍地县!<br>"); }
		if (RegVillage=="") { errStr = errStr + $g("请选择户籍地乡/镇(街道)!<br>"); }
		if (RegRoad=="") { errStr = errStr + $g("请填写户籍地村(居委会)!<br>"); }	
		if (RegAddType=="") { errStr = errStr + $g("请选择户籍地类型!<br>"); }			
		if (CurrProvince=="") { errStr = errStr + $g("请选择现住址省!<br>"); }
		if (CurrCity=="") { errStr = errStr + $g("请选择现住址市!<br>"); }
		if (CurrCounty=="") { errStr = errStr + $g("请选择现住址县!<br>"); }
		if (CurrVillage=="") { errStr = errStr + $g("请选择现住址乡/镇(街道)!<br>"); }
		if (CurrRoad=="") { errStr = errStr + $g("请填写现住址村(居委会)!<br>"); }
		if (CurrAddType=="") { errStr = errStr + $g("请选择现住址类型!<br>"); }
		
		if (SickDate=="") { errStr = errStr + $g("请填写初次发病时间!<br>"); }
		if (Behaviors=="") { errStr = errStr + $g("请选择既往危险行为!<br>"); }
		if (RepLocTel=="") { errStr = errStr + $g("请填写科室电话!<br>"); }
		if (FDTreatDate=="") { errStr = errStr + $g("请填写首次抗精神病治疗时间!<br>"); }
		if (TreatTimes=="") { errStr = errStr + $g("请填写住院曾住精神专科医院/综合医院精神科次数!<br>"); }
		if (DiagDate=="") { errStr = errStr + $g("请填写本次确诊日期!<br>"); }
		if (AdmitDate=="") { errStr = errStr + $g("请填写入院时间!<br>"); }
		if (Disease=="") { errStr = errStr + $g("请选择疾病名称!<br>"); }
		if ((Disease!="")&&(obj.Disease=="")) { errStr = errStr + $g("请选择疾病名称!<br>"); }
		
		if ((txtCause=="")||(txtCause1=="")||(txtCause2=="")||(txtCause3=="")||(txtCause4=="")||(txtCause5==""))  { errStr = errStr + $g("未填写患者对家庭社会的影响的必填项!<br>"); }
		
		if(($('#cboDrug1').val()!="")&&((IsLongTerm1=='0')&&((txtUsageMorn1=='0')&&(txtUsageNoon1=='0')&&(txtUsageEven1=='0')))){
			errStr += $g('治疗的非长效药一用法不能全填0<br>');
		}
		if(($('#cboDrug1').val()!="")&&((IsLongTerm1=='0')&&((txtUsageMorn1=="")||(txtUsageNoon1=="")||(txtUsageEven1=="")))){
			errStr += $g('治疗的非长效药一用法不能为空<br>');
		}
		if(($('#cboDrug1').val()!="")&&((IsLongTerm1=='1')&&((cboTreatUnit1=='0')||(txtTreatDoseQty1=='0')||(txtNumber1=='0')))){
			errStr += $g('治疗的长效药一不能填0<br>');
		}
		if(($('#cboDrug1').val()!="")&&((IsLongTerm1=='1')&&((cboTreatUnit1=='0')||(txtTreatDoseQty1=="")||(txtNumber1=="")))){
			errStr += $g('治疗的长效药一不能为空<br>');
		}
		if(($('#cboDrug2').val()!="")&&((IsLongTerm2=='0')&&((txtUsageMorn2=='0')&&(txtUsageNoon2=='0')&&(txtUsageEven2=='0')))){
			errStr += $g('治疗的非长效药二用法不能全填0<br>');
		}
		if(($('#cboDrug2').val()!="")&&((IsLongTerm2=='0')&&((txtUsageMorn2=="")||(txtUsageNoon2=="")||(txtUsageEven2=="")))){
			errStr += $g('治疗的非长效药二用法不能为空<br>');
		}
		if(($('#cboDrug2').val()!="")&&(IsLongTerm2=='1')&&((cboTreatUnit2=='0')||(txtTreatDoseQty2=='0')||(txtNumber2=='0'))){
			errStr += $g('治疗的长效药二不能填0<br>');
		}
		if(($('#cboDrug2').val()!="")&&(IsLongTerm2=='1')&&((cboTreatUnit2=="")||(txtTreatDoseQty2=="")||(txtNumber2==""))){
			errStr += $g('治疗的长效药二不能为空<br>');
		}
	
		if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4")) {		
			var Local = $.trim($('#cboLocal').combobox('getValue'));  
			var OPTreatmentList = Common_RadioValue('radOPTreatmentList');
			var AdmitReason = $.trim($('#cboAdmitReason').combobox('getValue'));
			if (Local=="") { errStr = errStr + $g("请选择常住类型!<br>"); }
			
			if (AdmitReason=="") { errStr = errStr + $g("请选择本次入院原因!<br>"); }
			var DischDate = $.trim($('#txtDischDate').datebox('getValue'));
			if(DischDate ==""){
				errStr += $g("出院日期为空，不允许提交报卡，请先保存为草稿，待患者出院后再提交出院信息单！<br>");
			}	
			if(SaveMentalSymptomToString().length == 0){
				errStr += $g("请选择“精神症状”！<br>");
			}else{	//判断精神症状前6项是否填写
				for (var ind = 0; ind < 6; ind++){
				
				}
			}
			if (OPTreatmentList=="") { errStr = errStr + $g("请选择门诊治疗情况!<br>"); }
			var Payment = $.trim($('#cboPayment').combobox('getValue'));
			if (Payment=="") { errStr = errStr + $g("请选择医疗付费方式!<br>"); }	
			var Prognosis = $.trim($('#cboPrognosis').combobox('getValue'));
			if (Prognosis=="") { errStr = errStr + $g("请选择住院疗效!<br>"); }	
			
			var IsDrug2=$("input[name='IsDrug2']:checked").val();							//是否服药
			if (IsDrug2==undefined) { errStr = errStr + $g("康复建议请选择是否服药!<br>"); }
			if((IsDrug2=='1')&&(($('#cboRehabDrug1').val()=="")&&($('#cboRehabDrug2').val()==""))){
				errStr = errStr + $g("请填写康复建议的药物!<br>");
			}
			var chkRehabIsLong1=$("input[name='chkRehabIsLong1']:checked").val();
			if ((chkRehabIsLong1==undefined) && (($('#RehabDrug1Id').val()!=""&&($('#cboRehabDrug1').val()!="")))) { 
				errStr = errStr + $g("康复建议的药物一请选择是否为长效药!<br>"); 
			}
			var chkRehabIsLong2=$("input[name='chkRehabIsLong2']:checked").val();
			if ((chkRehabIsLong2==undefined) && (($('#RehabDrug2Id').val()!="")&&($('#cboRehabDrug2').val()!=""))) { 
				errStr = errStr + $g("康复建议的药物二请选择是否为长效药!<br>"); 
			}
			if((chkRehabIsLong1!=undefined)&&(($('#cboRehabDrug1').val()==""))){
				errStr += $g('请填写康复药物1<br>');
			}
			if((chkRehabIsLong2!=undefined)&&(($('#cboRehabDrug2').val()==""))){
				errStr += $g('请填写康复药物2<br>');
			}
				
			var chkRehabIsLong1=$.trim($("input[name='chkRehabIsLong1']:checked").val());	//是否为长效药1
			var txtRehabMorn1=$('#txtRehabMorn1').val()		//早
			var txtRehabNoon1=$('#txtRehabNoon1').val()		//中
			var txtRehabEven1=$('#txtRehabEven1').val()		//晚
			var txtRehabDrugSpec11=$('#txtRehabDrugSpec11').val()
			var txtRehabDoseQty1=$('#txtRehabDoseQty1').val()
			var txtRehabNumber1=$('#txtRehabNumber1').val()
			var cboRehabUnit1=$('#cboRehabUnit1').combobox('getValue');
			var chkRehabIsLong2=$.trim($("input[name='chkRehabIsLong2']:checked").val());	//是否为长效药2
			var txtRehabMorn2=$('#txtRehabMorn2').val()		//早
			var txtRehabNoon2=$('#txtRehabNoon2').val()		//中
			var txtRehabEven2=$('#txtRehabEven2').val()		//晚
			var txtRehabDrugSpec21=$('#txtRehabDrugSpec21').val()
			var txtRehabDoseQty2=$('#txtRehabDoseQty2').val()
			var txtRehabNumber2=$('#txtRehabNumber2').val()
			var cboRehabUnit2=$('#cboRehabUnit2').combobox('getValue');
			if(($('#cboRehabDrug1').val()!="")&&((chkRehabIsLong1=='0')&&((txtRehabMorn1=='0')&&(txtRehabNoon1=='0')&&(txtRehabEven1=='0')))){
				errStr += $g('康复药物1非长效药用法不能全填0<br>');
			}
			if(($('#cboRehabDrug1').val()!="")&&((chkRehabIsLong1=='0')&&((txtRehabMorn1=="")||(txtRehabNoon1=="")||(txtRehabEven1=="")))){
				errStr += $g('康复药物1非长效药用法不能为空<br>');
			}
			if(($('#cboRehabDrug1').val()!="")&&((chkRehabIsLong1=='1')&&((cboRehabUnit1=='0')||(txtRehabDoseQty1=='0')||(txtRehabNumber1=='0')))){
				errStr += $g('康复药物1长效药不能填0<br>');
			}
			if(($('#cboRehabDrug1').val()!="")&&((chkRehabIsLong1=='1')&&((cboRehabUnit1=="")||(txtRehabDoseQty1=="")||(txtRehabNumber1=="")))){
				errStr += $g('康复药物1长效药不能为空<br>');
			}
			if(($('#cboRehabDrug2').val()!="")&&((chkRehabIsLong2=='0')&&((txtRehabMorn2=='0')&&(txtRehabNoon2=='0')&&(txtRehabEven2=='0')))){
				errStr += $g('康复药物2非长效药早中晚不能全填0<br>');
			}
			if(($('#cboRehabDrug2').val()!="")&&((chkRehabIsLong2=='0')&&((txtRehabMorn2=='')||(txtRehabNoon2=='')||(txtRehabEven2=='')))){
				errStr += $g('康复药物2非长效药用法不能为空<br>');
			}
			if(($('#cboRehabDrug2').val()!="")&&((chkRehabIsLong2=='1')&&((cboRehabUnit2=='0')||(txtRehabDoseQty2=='0')||(txtRehabNumber2=='0')))){
				errStr += $g('康复药物2长效药不能填0<br>');
			}
			if(($('#cboRehabDrug2').val()!="")&&((chkRehabIsLong2=='1')&&((cboRehabUnit2=="")||(txtRehabDoseQty2=='')||(txtRehabNumber2=='')))){
				errStr += $g('康复药物2长效药不能为空<br>');
			}
			var IsFunding=Common_RadioLabel('radIsFundingList');
			if (IsFunding=="") { errStr = errStr + $g("请填写本次住院是否获得经费补助!<br>"); }
			if (IsFunding==$g("有")){ //是否获得补助为"有"时，补助类型、补助来源必填
				var FundsType = Common_RadioValue('radFundsTypeList');
				var FundsSource = Common_RadioValue('radFundsSourceList');  
				if (FundsType=="") { errStr = errStr + $g("请选择补助类型!<br>"); }
				if (FundsSource=="") { errStr = errStr + $g("请选择经费来源!<br>"); }
				var FundsSourceDesc = Common_RadioLabel('radFundsSourceList');
				var FundsSourceTxt = $.trim($('#txtFundsSource').val());	
				if ((FundsSourceDesc.indexOf($g("其他"))> -1)&&($.trim(FundsSourceTxt)=="")) {
					errStr += $g("请填写“经费来源”的“其他”！<br>");
				}				
			}
			var TreatMeasure = Common_CheckboxValue('chkTreatMeasureList');  
			if(TreatMeasure.length == 0){
				errStr += $g("请选择“本次住院康复措施”！<br>");
			}else{
				var TreatMeasureTDesc = Common_CheckboxLabel('chkTreatMeasureList'); 
				var TreatMeasureTxt = $.trim($('#txtTreatMeasureTxt').val());				
				if ((TreatMeasureTDesc.indexOf($g("其他"))> -1)&&($.trim(TreatMeasureTxt)=="")) {
					errStr += $g("请填写“本次住院康复措施”的“其他”！<br>");
				}	
			}
			var RehabMeasure = Common_CheckboxValue('chkRehabMeasureList');  
			if(RehabMeasure.length == 0){
				errStr += $g("请选择下一步治疗“康复措施”！<br>");
			}else{
				var RehabMeasureTDesc = Common_CheckboxLabel('chkRehabMeasureList'); 
				var RehabMeasureTxt = $.trim($('#txtRehabMeasureTxt').val());				
				if ((RehabMeasureTDesc.indexOf("其他")> -1)&&($.trim(RehabMeasureTxt)=="")) {
					errStr += $g("请填写下一步治疗“康复措施”的“其他”！<br>");
				}				
			}
			//时间逻辑判断   出生时间＜初次发病时间≤首次抗精神病药治疗时间≤本次入院时间≤本次确诊时间≤填卡时间
			if (Common_CompareDate(Birthday,SickDate)>0){
				errStr = errStr + $g("初次发病时间不能早于出生时间！<br>"); 
			}
			
			if (Common_CompareDate(SickDate,Common_GetDate(new Date()))>0){
				errStr = errStr + $g("初次发病时间不能晚于当前时间！<br>"); 
			}
			if (Common_CompareDate(SickDate,FDTreatDate)>0){
				errStr = errStr + $g("首次抗精神病药治疗时间不能早于初次发病时间！<br>"); 
			}
			if (Common_CompareDate(SickDate,AdmitDate)>0){
				errStr = errStr + $g("本次入院时间不能早于初次发病时间！<br>"); 
			}
			if (Common_CompareDate(SickDate,DiagDate)>0){
				errStr = errStr + $g("本次确诊日期不能早于初次发病时间，！<br>"); 
			}
			if (Common_CompareDate(AdmitDate,DiagDate)>0){
				errStr = errStr + $g("本次确诊时间不能早于本次入院时间！<br>"); 
			}
			if (Common_CompareDate(DiagDate,RepDate)>0){
				errStr = errStr + $g("本次确诊时间不能晚于填卡时间！<br>"); 
			}
		} else {
			var PatType  = $.trim($('#cboPatType').combobox('getValue'));      //患者类型
			var AdmType  = $.trim($('#cboAdmType').combobox('getValue'));      //报卡类型
			var HB = $.trim($('#cboHuBie').combobox('getText'))                 //户别
			var Degree = $.trim($('#cboDegree').combobox('getValue'));    //文化程度
			var WedLock = $.trim($('#cboWedLock').combobox('getValue'));    			//婚姻状况
			var Occupation = $.trim($('#cboOccupation').combobox('getValue')) 			 //就业情况
			var Local = $.trim($('#cboLocal').combobox('getValue'));  		  			 //人员属地
			//var IsComplete = $.trim($('#cboIsComplete').combobox('getValue')); 			//完整性
			var ReferralList = Common_CheckboxValue('chkReferralList') 							//送诊主体
			var Referral = $.trim($('#txtReferralTxt').val()) 	                              	//送诊主体（其它）
			var HouseHold = $.trim($('#cboHouseHold').combobox('getValue')); 			//两系三代严重精神疾病 cboHouseHold
			var IsDrugTreatment=$("input[name='IsDrugTreatment']:checked").val();
			var LockStatus = $.trim($('#cboLockStatus').combobox('getValue')); 			//既往关锁情况 LockStatus
			var Agree = $.trim($('#cboAgree').combobox('getValue'));  		   			//知情同意
			var AgreeText = $.trim($('#cboAgree').combobox('getText'));  				//知情同意文本
			var AgreeDate = $.trim($('#txtAgreeDate').datebox('getValue'));  		   //知情同意时间
			var cboAssessment = $.trim($('#cboAssessment').combobox('getText')); 
		
			if ((PatType=="")&&(obj.RepTypeCode != '1')) { errStr = errStr + $g("请选择患者类型!<br>"); }
			if ((obj.RepTypeCode != '1')&&(AdmType=="")) { errStr = errStr + $g("请选择报卡类型!<br>"); }
		
			var AdmitReason = $.trim($('#cboAdmitReason').combobox('getValue'));		
			if ((obj.RepTypeCode == '3')&&(AdmitReason=="")) { errStr = errStr + $g("请选择本次入院原因!<br>"); }
			if (HB=="") { errStr = errStr + $g("请选择户别!<br>"); }
			if (Degree=="") { errStr = errStr + $g("请选择文化程度!<br>"); }
			if (WedLock=="") { errStr = errStr + $g("请选择婚姻状况!<br>"); }
			if (Occupation=="") { errStr = errStr + $g("请选择就业情况!<br>"); }
			if (Local=="") { errStr = errStr + $g("请选择人员属地!<br>"); }
			if (ReferralList=="") { errStr = errStr + $g("请选择送诊主体!<br>"); }
			if (($("input[name='chkReferralList'][label='其他']").is(':checked'))&&(Referral=="")) { errStr = errStr + $g("请选择送诊主体（其它）!<br>"); }
			if (HouseHold=="") { errStr = errStr + $g("请选择两系三代严重精神疾病!<br>"); }
			if (IsDrugTreatment==undefined) { errStr = errStr + $g("请选择是否已进行抗精神药物治疗!<br>"); }
			if(((PatNation.indexOf($g("中国")))==-1)&&(HB!=$g("外籍"))){
				errStr += $g('国籍选择非中国时，户别必须选择“外籍”<br>');
			}
			if((PatNation==$g("中国"))&&(HB==$g("外籍"))){
				errStr += $g('国籍选择中国时，户别只能选择“农业或非农业”<br>');
			}
			if(((Behaviors.indexOf("2311"))==-1)&&(cboAssessment==$g("0级"))){
				errStr += $g('危险性评估不能选0级<br>');
			}
			
			if (LockStatus=="") { errStr = errStr + $g("请选择既往关锁情况!<br>"); }
			if (Assessment=="") { errStr = errStr + $g("请选择既往危险性评估!<br>"); }
			if (Agree=="") { errStr = errStr + $g("请选择”知情同意“项目!<br>"); }
			if ((AgreeText==$g("同意参加社区服务管理")) && (AgreeDate=="")){ errStr = errStr + $g("请选择“知情同意时间”!<br>"); }
			
			//初次发病时间≤知情同意时间≤当前时间
			if (Common_CompareDate(SickDate,AgreeDate)>0){
				errStr = errStr + $g("知情同意时间不能晚于初次发病时间！<br>"); 
			}
			if (Common_CompareDate(AgreeDate,Common_GetDate(new Date()))>0){
				errStr = errStr + $g("知情同意时间不能晚于当前时间！<br>"); 
			}
			if (Common_CompareDate(SickDate,FDTreatDate)>0){
				errStr = errStr + $g("首次抗精神病药治疗时间不能早于初次发病时间！<br>"); 
			}
			if (Common_CompareDate(Birthday,SickDate)>0){
				errStr = errStr + $g("出生时间不能晚于初次发病时间！<br>"); 
			}
			if (Common_CompareDate(SickDate,AdmitDate)>0){
				if(obj.RepTypeCode=="1"){
					errStr = errStr + $g("初次发病时间不能晚于本次就诊时间！<br>"); 
				}else{
					errStr = errStr + $g("初次发病时间不能晚于本次入院时间！<br>"); 
				}
			}
			if (Common_CompareDate(AdmitDate,DiagDate)>0){
				errStr = errStr + $g("本次入院时间不能晚于本次确诊时间！<br>"); 
			}
			if (Common_CompareDate(DiagDate,RepDate)>0){
				errStr = errStr + $g("本次确诊时间不能晚于填卡时间！<br>"); 
			}
			if (Common_CompareDate(RepDate,Common_GetDate(new Date()))>0){
				errStr = errStr + $g("填卡时间不能晚于当前时间！<br>"); 
			}
		}
		if(errStr != "")
		{
			$.messager.alert($g("提示"), '<div style="height:400px;overflow-y:scroll">' + errStr + '</div>', 'info');
			return false;
		}
		return true;
	}
	
	///  按钮对应事件
	//按钮监听事件
	$('#btnRepTmp').on("click", function(){
		obj.btnRepTmp_click();
	});
	$('#btnSubmit').on("click", function(){
		obj.btnSubmit_click()
	});
	$('#btnCheck').on("click",function(){
		obj.btnCheck_click()
	});
	$('#btnCanCheck').on("click",function(){
		obj.btnCanCheck_click()
	});
	$('#btnReturn').on("click", function(){
		obj.btnReturn_click()
	});
	$('#btnDelete').on("click",function(){
		obj.btnDelete_click()
	});
	$('#btnPrint').on("click",function(){
		obj.btnPrint_click()
	});
	$('#btnClose').on("click", function(){
		obj.btnClose_click()
	});	
	
	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function (StatusCode) {
		$('#btnCheck').hide();
		$('#btnCanCheck').hide();
		$('#btnReturn').hide();
		$('#btnDelete').hide();
		$('#btnPrint').hide();
		if (obj.ReportID != "") {
			switch (StatusCode) {
				case "":
				case "1": //上报
					$('#btnSubmit').show();
					$('#btnRepTmp').hide();
					$('#btnCheck').show();
					$('#btnCanCheck').hide();
					$('#btnReturn').show();
					$('#btnDelete').show();
					$('#btnPrint').show();
					$('#btnClose').show();
					break;
				case "2": //审核
					$('#btnSubmit').hide();
					$('#btnRepTmp').hide();
					$('#btnCheck').hide();
					$('#btnCanCheck').show();
					$('#btnReturn').hide();
					$('#btnDelete').hide();
					$('#btnPrint').show();
					$('#btnClose').show();
					break;
				case "3": //退回
					$('#btnSubmit').show();
					$('#btnRepTmp').show();
					$('#btnCheck').hide();
					$('#btnCanCheck').hide();
					$('#btnReturn').hide();
					$('#btnDelete').hide();
					$('#btnPrint').hide();
					$('#btnClose').show();
					break;
				case "4": //作废
					$('#btnSubmit').hide();
					$('#btnRepTmp').hide();
					$('#btnCheck').hide();
					$('#btnCanCheck').hide();
					$('#btnReturn').hide();
					$('#btnDelete').hide();
					$('#btnPrint').hide();
					$('#btnClose').show();
					break;
				case "0": //草稿
					$('#btnSubmit').show();
					$('#btnRepTmp').show();
					$('#btnCheck').hide();
					$('#btnCanCheck').hide();
					$('#btnReturn').hide();
					$('#btnDelete').show();
					$('#btnPrint').hide();
					$('#btnClose').show();
					break;
				case "5":	//取消审核
					$('#btnSubmit').show();
					$('#btnRepTmp').hide();
					$('#btnCheck').show();
					$('#btnCanCheck').hide();
					$('#btnReturn').show();
					$('#btnDelete').show();
					$('#btnPrint').show();
					$('#btnClose').show();
					break;
			}
		}
		if (!tDHCMedMenuOper['Report']) {
			$('#btnSubmit').hide();
			$('#btnRepTmp').hide();
			$('#btnDelete').hide();
		}
		if (!tDHCMedMenuOper['Check']) {
			$('#btnCheck').hide();
			$('#btnCanCheck').hide();
			$('#btnReturn').hide();
		}
	}
	
	//草稿
	obj.btnRepTmp_click = function () {
		obj.SaveReport("0");
	}
	//提交
	obj.btnSubmit_click = function () {
		if (obj.CheckReport() != true) return;
		obj.SaveReport("1");
	}
	//作废
	obj.btnDelete_click = function () {
		if (obj.ReportID == "") return;
		$.messager.confirm("作废报告", "您确定要作废这份报告吗？", function (r) {
			if (r) {
				var ret = obj.SaveRepStatus(obj.ReportID, "4", '', session['LOGON.USERID']);
				if (ret == "1") {
					$.messager.alert("提示", "作废成功！", 'info');
					obj.InitReport("4");
				} else {
					$.messager.alert("提示", "作废失败，错误代码：" + ret + "！", 'info');
				}
			}
		});
	}
	//审核
	obj.btnCheck_click = function () {
		$.messager.confirm("审核报告", "您确定要审核这份报告吗？", function (r) {
			if (r) {
				var ret = obj.SaveRepStatus(obj.ReportID, "2", "", session['LOGON.USERID']);
				if (ret == "1") {
					$.messager.alert("提示", "审核成功！", 'info');
					obj.InitReport("2");
				} else if(ret=="-1") {
					$.messager.alert("提示", "不是提交状态的报卡，不能审核！", 'info');
				}
				else{
					$.messager.alert("提示", "审核失败，错误代码：" + ret + "！", 'info');
				}
			}
		});
	}
	//取消审核
	obj.btnCanCheck_click = function () {
		$.messager.confirm("取消审核报告", "您确定要取消审核这份报告吗？", function (r) {
			if (r) {
				var ret = obj.SaveRepStatus(obj.ReportID, "5", "", session['LOGON.USERID']);
				if (ret == "1") {
					$.messager.alert("提示", "取消审核成功！", 'info');
					obj.InitReport("5");
				} else {
					$.messager.alert("提示", "取消审核失败，错误代码：" + ret + "！", 'info');
				}
			}
		});
	}
	//退回
	obj.btnReturn_click = function () {
		$.messager.confirm("退回报告", "您确定要退回这份报告吗？", function (r) {
			if (r) {
				$.messager.prompt("退回报告", "请输入退回原因!", function (txt) {
					if (txt) {
						var ret = obj.SaveRepStatus(obj.ReportID, "3", txt, session['LOGON.USERID']);
						if (ret == "1") {
							$.messager.alert("提示", "退回成功！", 'info');
							obj.InitReport("3");
						} else {
							$.messager.alert("提示", "退回失败，错误代码：" + ret + "！", 'info');
						}
					} else if (txt === '') {
						$.messager.alert("提示", "未输入退回原因,报告不能退回！", 'info');
					}
				});
			}

		});
	}
	//打印
	obj.btnPrint_click = function () {		
		if (obj.RepTypeCode == "1") {   //1- 门诊报卡  重性精神疾病发病报告
			var fileName="{DHCMed.SMD.ReportOP.raq(aReportID="+obj.ReportID+")}";
		} else if (obj.RepTypeCode == "3") {
			var fileName="{DHCMed.SMD.ReportIP.raq(aReportID="+obj.ReportID+")}";   //3- 住院报卡  严重精神障碍患者发病报告
		} else if (obj.RepTypeCode == "4") {
			var fileName="{DHCMed.SMD.DisReport.raq(aReportID="+obj.ReportID+")}";
		} 
		//DHCCPM_RQDirectPrint(fileName);
		DHCCPM_RQDirectPrintPDF(fileName);
	}
		
	//关闭
	obj.btnClose_click = function () {
		websys_showModal('close');
	}
}



//弹出加载层
function loadingWindow() {
	var left = ($(window).outerWidth(true) - 190) / 2;
	var top = ($(window).height() - 35) / 2;
	var height = $(window).height() * 2;
	$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#SMDReport");
	$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#SMDReport").css({ display: "block", left: left, top: top });
}

//取消加载层  
function disLoadWindow() {
	$(".datagrid-mask").remove();
	$(".datagrid-mask-msg").remove();
}


//精神症状
function SaveMentalSymptomToString()
{
	var strRet = "";
	$("input[name='chkSymptom']:checked").each(function(){
		strRet = strRet + $(this).val()+ "#";
	});
	return strRet;
} 
//住院/治疗用药
 function SaveTreatPharmacyToString()
{
	var strRet = "";
	strRet += "";
	strRet += "^" +  $.trim($('#cboDrug1').lookup('getText'));
	strRet += "^" +	 $.trim($('#txtNumber1').val());
	strRet += "^" +	 $.trim($('#txtTreatDoseQty1').val());
	strRet += "^" +  "mg";
	strRet += "^" +   $.trim($('#Drug1Id').val());
	strRet += "^" +	 $.trim($('#cboTreatUnit1').combobox("getValue"));
	strRet += "^" +  ""
	var IsLongTerm1=$.trim($("input[name='chkIsLong1']:checked").val());
	strRet += "^" +  IsLongTerm1;
	strRet += "^" + (IsLongTerm1==1?$.trim($('#txtDrugSpec11').val()):$.trim($('#txtDrugSpec10').val()));
	strRet += "^" + $.trim($('#txtUsageMorn1').val())
	strRet += "^" + $.trim($('#txtUsageNoon1').val())
	strRet += "^" + $.trim($('#txtUsageEven1').val())
	strRet += String.fromCharCode(1);
	strRet += "";
	strRet += "^" +  $.trim($('#cboDrug2').lookup('getText'));
	strRet += "^" +	 $.trim($('#txtNumber2').val());
	strRet += "^" +	 $.trim($('#txtTreatDoseQty2').val());
	strRet += "^" +  "mg";
	strRet += "^" +   $.trim($('#Drug2Id').val());
	strRet += "^" +	  $.trim($('#cboTreatUnit2').combobox("getValue"));
	strRet += "^" +  ""
	var IsLongTerm1=$.trim($("input[name='chkIsLong2']:checked").val());
	strRet += "^" +  IsLongTerm1;
	strRet += "^" + (IsLongTerm1==1?$.trim($('#txtDrugSpec21').val()):$.trim($('#txtDrugSpec20').val()));
	strRet += "^" + $.trim($('#txtUsageMorn2').val())
	strRet += "^" + $.trim($('#txtUsageNoon2').val())
	strRet += "^" + $.trim($('#txtUsageEven2').val())
	return strRet;
}
//康复用药
function SaveRehabPharmacyToString()
{
	var strRet = "";
	strRet += "";
	strRet += "^" +  $.trim($('#cboRehabDrug1').lookup('getText'));
	strRet += "^" +	 $.trim($('#txtRehabNumber1').val());
	strRet += "^" +	 $.trim($('#txtRehabDoseQty1').val());
	strRet += "^" +  "mg";
	strRet += "^" +  $.trim($('#RehabDrug1Id').val());
	strRet += "^" +	 $.trim($('#cboRehabUnit1').combobox("getValue"));
	strRet += "^" +  ""
	var IsLongTerm1=$.trim($("input[name='chkRehabIsLong1']:checked").val());
	strRet += "^" +  IsLongTerm1;
	strRet += "^" + (IsLongTerm1==1?$.trim($('#txtRehabDrugSpec11').val()):$.trim($('#txtRehabDrugSpec10').val()));
	strRet += "^" + $.trim($('#txtRehabMorn1').val())
	strRet += "^" + $.trim($('#txtRehabNoon1').val())
	strRet += "^" + $.trim($('#txtRehabEven1').val())
	strRet += String.fromCharCode(1);
	strRet += "";
	strRet += "^" +  $.trim($('#cboRehabDrug2').lookup('getText'));
	strRet += "^" +	 $.trim($('#txtRehabNumber2').val());
	strRet += "^" +	 $.trim($('#txtRehabDoseQty2').val());
	strRet += "^" +  "mg";
	strRet += "^" +   $.trim($('#RehabDrug2Id').val());
	strRet += "^" +	  $.trim($('#cboRehabUnit2').combobox("getValue"));
	strRet += "^" +  ""
	var IsLongTerm2=$.trim($("input[name='chkRehabIsLong2']:checked").val());
	strRet += "^" +  IsLongTerm2;
	strRet += "^" + (IsLongTerm2==1?$.trim($('#txtRehabDrugSpec21').val()):$.trim($('#txtDrugSpec20').val()));
	strRet += "^" + $.trim($('#txtRehabMorn2').val())
	strRet += "^" + $.trim($('#txtRehabNoon2').val())
	strRet += "^" + $.trim($('#txtRehabEven2').val())
	return strRet;
}
//判断某一元素在加载的html中是否存在
function IsExist(obj) {
	if ($('#'+obj).length > 0) {
		return 1;
	}else {
		return 0;
	}
}
