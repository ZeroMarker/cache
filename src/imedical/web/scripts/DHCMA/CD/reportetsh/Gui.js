$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
	obj.ReportID=ReportID;
    
	//基本信息
	obj.RadLocType  = Common_chkRadioToDic("RadLocType","ETSHAdmLocType",2);             // 就诊科室类型
	obj.cboCRMZ 	= Common_ComboToDic("cboNation","CRMZ","",LogonHospID);              // 民族   
	obj.cboRegister = Common_ComboToDic("cboRegister","CRHJ","",LogonHospID);            // 户籍                                      
	obj.cboSchool 	= Common_ComboToDic("cboSchool","ETSHChildSchool","",LogonHospID);   // 就学情况                                  
	obj.cboFather 	= Common_ComboToDic("cboFather","ETSHEducation","",LogonHospID);   	 // 父亲教育程度                                  
	obj.cboMather 	= Common_ComboToDic("cboMather","ETSHEducation","",LogonHospID);   	 // 母亲教育程度 
	  
	obj.cboCurrProvince = Common_ComboToArea2("cboCurrProvince","1",1);                                     //省
	obj.cboCurrCity = $HUI.combobox('#cboCurrProvince', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCity').combobox('clear');
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCity = Common_ComboToArea2("cboCurrCity","cboCurrProvince",2);				// 市
		}		
	});
	obj.cboCurrCounty = $HUI.combobox('#cboCurrCity', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCounty = Common_ComboToArea2("cboCurrCounty","cboCurrCity",3);             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboCurrCounty', {
		onChange:function(newValue,oldValue){
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrVillage = Common_ComboToArea2("cboCurrVillage","cboCurrCounty",4);         // 乡
		}
	});
	$HUI.combobox('#cboCurrVillage', {                                                    //村
		onSelect:function(record){
			if (record) {
			    $('#txtCurrRoad').val('');
			}
		}
	});
	//鼠标移动之后事件 
	$('#txtCurrRoad').bind('change', function (e) {  
		$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText')+$('#txtCurrRoad').val());
	});
	
	obj.radInjuryReason  	= Common_chkRadioToDic("radInjuryReason","ETSHHappenReason",4);   // 伤害发生的原因
	obj.radInjuryplace  	= Common_chkRadioToDic("radInjuryplace","ETSHHappenPlace",4);     // 伤害发生的地点
	obj.radInjuryActivity  	= Common_chkRadioToDic("radInjuryActivity","ETSHInjuryActive",4); // 伤害发生时活动
	obj.radIsWillfully  	= Common_chkRadioToDic("radIsWillfully","ETSHIsWillfully",4);     // 是否故意
	obj.radIsDrink  		= Common_chkRadioToDic("radIsDrink","ETSHIsDrink",3);     		  // 是否饮酒
	obj.radIsCaregiver  	= Common_RadioToDic("radIsCaregiver","ETSHIsCaregiver",3);     // 看护人是否在场
	obj.radCaregiverType  	= Common_chkRadioToDic("radCaregiverType","ETSHCaregiverType",3); // 看护人类别
	obj.radCaregiverStatus  = Common_chkRadioToDic("radCaregiverStatus","ETSHCaregiverStatus",3); // 看护人状态
	
	obj.radInjure  			= Common_chkRadioToDic("radInjure","ETSHInjury",4); 				// 伤害性质
	obj.radInjurePalce  	= Common_chkRadioToDic("radInjurePalce","ETSHInjuryPlace",5); 		// 伤害部位
	obj.radInjureSystem  	= Common_chkRadioToDic("radInjureSystem","ETSHInjurySystem",3); 	// 伤害累及系统
	obj.radAirwayStatus  	= Common_chkRadioToDic("radAirwayStatus","ETSHAirwayStatus",3); 	// 气道状态
	obj.radSBP  			= Common_chkRadioToDic("radSBP","ETSHSBP",3); 						// 收缩期血压
	obj.radCentralSystem  	= Common_chkRadioToDic("radCentralSystem","ETSHCentralSystem",3); 	// 中枢神经系统
	obj.radOpenWound  		= Common_chkRadioToDic("radOpenWound","ETSHOpenWound",3); 			// 开放性伤口
	obj.radFracture  		= Common_chkRadioToDic("radFracture","ETSHFracture",3); 			// 骨折
	obj.radInjurySeverity  	= Common_chkRadioToDic("radInjurySeverity","ETSHInjurySeverity",3); // 伤害严重程度
	obj.radInjuryEnd  		= Common_chkRadioToDic("radInjuryEnd","ETSHInjuryEnd",4); 			// 伤害结局
	
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID);                            //报卡科室
    
	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
