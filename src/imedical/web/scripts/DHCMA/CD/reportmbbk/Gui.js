$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();   
	obj.ReportID=ReportID;
	obj.CRZDMCID ='';
	obj.CRGZZDID ='';
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }     
  
	//户口地址
	$('#cboPatAgeDW').combobox({});  //年龄单位
	obj.cboProvince1 = Common_ComboToArea2("cboProvince1","1");            // 省
	obj.RegCity1 = $HUI.combobox('#cboProvince1', {
		onChange:function(newValue,oldValue){
			$('#cboCity1').combobox('clear');
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCity1 = Common_ComboToArea2("cboCity1","cboProvince1");				// 市
		}
		
	});
	obj.RegCounty1 = $HUI.combobox('#cboCity1', {
		onChange:function(newValue,oldValue){
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCounty1 = Common_ComboToArea2("cboCounty1","cboCity1");             // 县
		}
	});
	obj.RegVillage1 = $HUI.combobox('#cboCounty1', {
		onChange:function(newValue,oldValue){
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboVillage1 = Common_ComboToArea2("cboVillage1","cboCounty1");         // 乡
		}
	});
	$HUI.combobox('#cboVillage1', {
		onSelect:function(record){
			if (record) {
			    $('#txtCUN1').val('');
			}
		}
	});
	
	//现地址
	obj.cboProvince2 = Common_ComboToArea2("cboProvince2","1");            // 省
	obj.RegCity2 = $HUI.combobox('#cboProvince2', {
		onChange:function(newValue,oldValue){
			$('#cboCity2').combobox('clear');
			$('#cboCounty2').combobox('clear');
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboCity2 = Common_ComboToArea2("cboCity2","cboProvince2");				// 市
		}
		
	});
	obj.RegCounty2 = $HUI.combobox('#cboCity2', {
		onChange:function(newValue,oldValue){
			$('#cboCounty2').combobox('clear');
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboCounty2 = Common_ComboToArea2("cboCounty2","cboCity2");             // 县
		}
	});
	obj.RegVillage2 = $HUI.combobox('#cboCounty2', {
		onChange:function(newValue,oldValue){
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboVillage2 = Common_ComboToArea2("cboVillage2","cboCounty2");         // 乡
		}
	});
	$HUI.combobox('#cboVillage2', {
		onSelect:function(record){
			if (record) {
			    $('#txtCUN2').val('');
			}
		}
	});
	
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","CRPatAge","",LogonHospID);          //年龄单位
	obj.cboCRMZ = Common_ComboToDic("cboCRMZ","CRMZ","",LogonHospID);                      //民族
	obj.cboEducation = Common_ComboToDic("cboEducation","CRDTHEducation","",LogonHospID);  //文化程度
	obj.cboCRZY = Common_ComboToDic("cboCRZY","CRZY","",LogonHospID);                      //职业

	obj.cboCRGXBZDList = Common_ComboToDic("cboCRGXBZDList","CRMBGXBZD","",LogonHospID);          //冠心病诊断
	obj.cboCRNCZZDList = Common_ComboToDic("cboCRNCZZDList","CRMBNCZZD","",LogonHospID);          //脑卒中诊断
	obj.cboCRTNBZDList = Common_ComboToDic("cboCRTNBZDList","CRMBTNBZD","",LogonHospID);          //糖尿病诊断
	obj.cboCRGZZD = Common_LookupToICD("cboCRGZZD");           //更正病名
	obj.cboCRZDMC = Common_LookupToICD("cboCRZDMC");           //肿瘤病名
	$("#cboCRGZZD").lookup({
		onSelect:function(index,rowData){		
			obj.CRGZZDID = rowData['ICDRowID'];
			$('#txtCRGZZDICD').val(rowData['ICD10']);
		}			
	});
	$('#cboCRGZZD').bind('change', function (e) {    //更正病名
		if($('#cboCRGZZD').lookup("getText")=="") {
			$('#txtCRGZZDICD').val('');          
			obj.CRGZZDID = '';
		}
	});
	$("#cboCRZDMC").lookup({	
		onSelect:function(index,rowData){			
			obj.CRZDMCID = rowData['ICDRowID'];
			$('#txtCRZDBM').val(rowData['ICD10']);
		}
	});
	$('#cboCRZDMC').bind('change', function (e) {    //肿瘤病名
		if($('#cboCRZDMC').lookup("getText")=="") {
			$('#txtCRZDBM').val('');          
			obj.CRZDMCID = '';
		}
	});
	
	obj.cboCRZDDW = Common_ComboToDic("cboCRZDDW","CRMBZDDW","",LogonHospID);              //诊断单位
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","");     //科室位置

	obj.LoadListInfo = function() {	  //加载单选、多选列表  
		obj.radBGKLXList = Common_RadioToDic("radBGKLXList","CRMBReportType",3);         //报卡类型
   		obj.radSFFBRQGJList = Common_RadioToDic("radSFFBRQGJList","CRMBSFFBRQGJ",2);     //发病日期为估计
		obj.chkCRZDYJList = Common_CheckboxToDic("chkCRZDYJList","CRMBZDYJ",7);          //诊断依据
		obj.radCRSBWZList = Common_RadioToDic("radCRSBWZList","CRMBSBWZ",2);             //报告科室位置
	}

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
