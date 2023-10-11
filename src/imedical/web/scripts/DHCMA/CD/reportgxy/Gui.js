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

	//��ס��ַ
	$('#cboPatAgeDW').combobox({});  //���䵥λ
	obj.cboCurrProvince = Common_ComboToArea2("cboCurrProvince","1",1);            // ʡ
	obj.CurrCity = $HUI.combobox('#cboCurrProvince', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCity').combobox('clear');
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCity = Common_ComboToArea2("cboCurrCity","cboCurrProvince",2);				// ��
		}		
	});
	obj.CurrCounty = $HUI.combobox('#cboCurrCity', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCounty = Common_ComboToArea2("cboCurrCounty","cboCurrCity",3);             // ��
		}
	});
	obj.CurrVillage = $HUI.combobox('#cboCurrCounty', {
		onChange:function(newValue,oldValue){
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrVillage = Common_ComboToArea2("cboCurrVillage","cboCurrCounty",4);         // ��
		}
	});
	$HUI.combobox('#cboCurrVillage', {
		onSelect:function(record){
			if (record) {
			    $('#txtCurrRoad').val('');
			}
		}
	});
	//��̬��Ӵ壨input��������
	$('#txtCurrRoad').bind('change', function (e) {  //����ƶ�֮���¼� 
		$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText')+$('#txtCurrRoad').val());
	});

	obj.cboNation 		= Common_ComboToDic("cboNation","CRMZ","",LogonHospID); // ����
	obj.chkRelations 	= Common_CheckboxToDic("chkRelations","GXYRelation",8);	// �и�Ѫѹʷ�ļ�ͥ��Ա
	obj.chkSymptoms 	= Common_CheckboxToDic("chkSymptoms","GXYSymptoms",5);	// ֢״
	obj.cboCRGXYZD		= Common_LookupToICD("cboCRGXYZD");           // ��Ѫѹ���
	$("#cboCRGXYZD").lookup({
		onSelect:function(index,rowData){		
			obj.CRGXYZDID = rowData['ICDRowID'];
			$('#txtCRGXYZDICD').val(rowData['ICD10']);
		}			
	});
	$('#cboCRGXYZD').bind('change', function (e) {    // ��Ѫѹ���
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
