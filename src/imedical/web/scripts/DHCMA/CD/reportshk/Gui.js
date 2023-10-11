$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();   
	obj.ReportID=ReportID;
	obj.SHLCZD ='';
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }     

	//联系地址
	$('#cboPatAgeDW').combobox({});  //年龄单位
	obj.cboCRZY = Common_ComboToDic("cboCRZY","CRZY","",LogonHospID);                                                               //职业
	obj.cboProvince1 = Common_ComboToArea2("cboProvince1","1",1);                        // 省
	obj.cboSHFSYY = Common_ComboToDic("cboSHFSYY","CRSHFSYY","",LogonHospID);
	obj.cboSHFSDD = Common_ComboToDic("cboSHFSDD","CRSHFSDD","",LogonHospID);
	obj.cboSHFSSHD = Common_ComboToDic("cboSHFSHD","CRSHFSSHD","",LogonHospID);
	obj.cboCRSHCPFL1 = Common_ComboToDic("cboCRSHCPFL1","CRSHCPFL","",LogonHospID);
	obj.cboCRSHCPFL2 = Common_ComboToDic("cboCRSHCPFL2","CRSHCPFL","",LogonHospID);
	obj.cboCRSHXZ = Common_ComboToDic("cboCRSHXZ","CRSHXZ","",LogonHospID);
	obj.cboCRSHBW = Common_ComboToDic("cboCRSHBW","CRSHBW","",LogonHospID);
	obj.cboCRZD = Common_LookupToICD("cboSHLCZD");                              //诊断
	$("#cboSHLCZD").lookup({onSelect:function(index,rowData){ //诊断
		$('#txtCRZDICD').val(rowData['ICD10']);
		obj.SHLCZD = rowData['ICDRowID'];
	}});
	$('#cboSHLCZD').bind('change', function (e) {  //诊断
		if($('#cboSHLCZD').lookup("getText")==""){
			$('#txtCRZDICD').val('');            //给相关的ICD10赋值
		}
	});
	
	obj.RegCity = $HUI.combobox('#cboProvince1', {
		onChange:function(newValue,oldValue){
			$('#cboCity1').combobox('clear');
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCity1 = Common_ComboToArea2("cboCity1","cboProvince1",2);				// 市
		}	
	});
	obj.RegCounty = $HUI.combobox('#cboCity1', {
		onChange:function(newValue,oldValue){
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCounty1 = Common_ComboToArea2("cboCounty1","cboCity1",3);             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboCounty1', {
		onChange:function(newValue,oldValue){
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboVillage1 = Common_ComboToArea2("cboVillage1","cboCounty1",4);         // 乡
		}
	});
	$HUI.combobox('#cboVillage1', {
		onSelect:function(record){
			if (record) {
			    $('#txtCUN1').val('');
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtCUN1').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText')+$('#txtCUN1').val());
	});

	obj.LoadListInfo = function() {	  //加载单选、多选列表	
		obj.radSHSFGYList = Common_RadioToDic("radSHSFGYList","CRSHSFGY",4);         //是否故意
		obj.radSHYZCDList = Common_RadioToDic("radSHYZCDList","CRSHYZCD",3);       	 //严重程度
		obj.radSHJJList   = Common_RadioToDic("radSHJJList","CRSHJJ",4);             //伤害结局
		obj.chkSHDXALList = Common_CheckboxToDic("chkSHDXALList","CRSHDYAL",2);      //典型案例
	}

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
