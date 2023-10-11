﻿$(function () {
	InitReportWin();
});


function InitReportWin(){
	var obj = new Object();   
	obj.ReportID=ReportID;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }       
	
	//联系地址
	$('#cboPatAgeDW').combobox({});  //年龄单位
	obj.cboCRZY = Common_ComboToDic("cboCRZY","CRZY","",LogonHospID);                              //职业
	obj.cboProvince1 = Common_ComboToArea2("cboProvince1","1",1);                        // 省
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
		obj.radZDYYList = Common_RadioToDic("cbgZDYY","CRCOZDYY",4);               //中毒原因
		obj.radZDCSList = Common_RadioToDic("radZDCSList","CRZDCS",4);             //中毒场所
		obj.radZDYSList = Common_RadioToDic("radZDYSList","CRZDYS",4);             //中毒因素
		obj.redZYZZList = Common_CheckboxToDic("redZYZZList","CRZYZZ",4);          //中毒症状
		$HUI.checkbox("[name='redZYZZList']",{  
			onCheckChange:function(e,value){
				var CROTZYZZ = $(e.target).attr("label");   //当前选中的值
				if (CROTZYZZ==$g('其他')) {
					if(value==false){	
						$('#txtCRQTZZ').val("")						
						$('#txtCRQTZZ').attr('disabled','disabled');
					}else{
						$('#txtCRQTZZ').removeAttr('disabled');
					}
				}
				
			}
		});
		obj.radZDZDList = Common_RadioToDic("radZDZDList","CRZDZD",4);             //中毒诊断
		obj.radJZCSList = Common_CheckboxToDic("radJZCSList","CRJZCS",4);          //救治措施
		obj.radZDZGList = Common_RadioToDic("radZDZGList","CRCOZG",4);             //转归
	}

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
