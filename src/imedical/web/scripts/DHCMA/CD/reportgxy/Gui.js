$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();   
	obj.ReportID=ReportID;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }    
	obj.CRGXYZDID =''; 

	//居住地址
	$('#cboPatAgeDW').combobox({});  //年龄单位
	obj.cboCurrProvince = Common_ComboToArea2("cboCurrProvince","1",1);            // 省
	obj.CurrCity = $HUI.combobox('#cboCurrProvince', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCity').combobox('clear');
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCity = Common_ComboToArea2("cboCurrCity","cboCurrProvince",2);				// 市
		}		
	});
	obj.CurrCounty = $HUI.combobox('#cboCurrCity', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCounty = Common_ComboToArea2("cboCurrCounty","cboCurrCity",3);             // 县
		}
	});
	obj.CurrVillage = $HUI.combobox('#cboCurrCounty', {
		onChange:function(newValue,oldValue){
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrVillage = Common_ComboToArea2("cboCurrVillage","cboCurrCounty",4);         // 乡
		}
	});
	$HUI.combobox('#cboCurrVillage', {
		onSelect:function(record){
			if (record) {
			    $('#txtCurrRoad').val('');
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtCurrRoad').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText')+$('#txtCurrRoad').val());
	});

	obj.cboNation 		= Common_ComboToDic("cboNation","CRMZ","",LogonHospID); // 民族
	obj.chkRelations 	= Common_CheckboxToDic("chkRelations","GXYRelation",8);	// 有高血压史的家庭成员
	obj.chkSymptoms 	= Common_CheckboxToDic("chkSymptoms","GXYSymptoms",5);	// 症状
	obj.cboCRGXYZD		= Common_LookupToICD("cboCRGXYZD");           // 高血压诊断
	$("#cboCRGXYZD").lookup({
		onSelect:function(index,rowData){		
			obj.CRGXYZDID = rowData['ICDRowID'];
			$('#txtCRGXYZDICD').val(rowData['ICD10']);
		}			
	});
	$('#cboCRGXYZD').bind('change', function (e) {    // 高血压诊断
		if($('#cboCRGXYZD').lookup("getText")=="") {
			$('#txtCRGXYZDICD').val('');          
			obj.CRGXYZDID = '';
		}
	});
	
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID); 

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;  
	
	      
}
