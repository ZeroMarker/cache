$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();   
	obj.CRZD ='';  
	obj.CRSWZD ='';
	obj.CRGZ= ''; 
	obj.ReportID=ReportID;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }     

	//居住地址
	$('#cboPatAgeDW').combobox({});  //年龄单位
	$('#cboCRGZ').combobox({});      //工种
	obj.cboCurrProvince = Common_ComboToArea2("cboCurrProvince","1");            // 省
	obj.CurrCity = $HUI.combobox('#cboCurrProvince', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCity').combobox('clear');
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCity = Common_ComboToArea2("cboCurrCity","cboCurrProvince");				// 市
		}		
	});
	obj.CurrCounty = $HUI.combobox('#cboCurrCity', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrCounty = Common_ComboToArea2("cboCurrCounty","cboCurrCity");             // 县
		}
	});
	obj.CurrVillage = $HUI.combobox('#cboCurrCounty', {
		onChange:function(newValue,oldValue){
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
			obj.cboCurrVillage = Common_ComboToArea2("cboCurrVillage","cboCurrCounty");         // 乡
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
	//常住地址
	obj.cboRegProvince = Common_ComboToArea2("cboRegProvince","1");            // 省
	obj.RegCity = $HUI.combobox('#cboRegProvince', {
		onChange:function(newValue,oldValue){
			$('#cboRegCity').combobox('clear');
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegCity = Common_ComboToArea2("cboRegCity","cboRegProvince");				// 市
		}		
	});
	obj.RegCounty = $HUI.combobox('#cboRegCity', {
		onChange:function(newValue,oldValue){
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegCounty = Common_ComboToArea2("cboRegCounty","cboRegCity");             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboRegCounty', {
		onChange:function(newValue,oldValue){
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegVillage = Common_ComboToArea2("cboRegVillage","cboRegCounty");         // 乡
		}
	});
	$HUI.combobox('#cboRegVillage', {
		onSelect:function(record){
			if (record) {
			    $('#txtRegRoad').val('');
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtRegRoad').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtRegAddress').val($('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText')+$('#txtRegRoad').val());
	});
	obj.cboNation = Common_ComboToDic("cboNation","CRMZ","",LogonHospID);                                   //民族
	obj.cboOccupation = Common_ComboToDic("cboOccupation","CRZY","",LogonHospID);                                   //职业
	obj.cboEducation = Common_ComboToDic("cboEducation","CRDTHEducation","",LogonHospID);               //文化 
	obj.cboMarital = Common_ComboToDic("cboMarital","CRDTHMarriage","",LogonHospID);                    //婚姻情况 
	//职业工种联动
    $('#cboOccupation').combobox({                                                               //工种
	    onSelect:function(rows){
		    $('#cboCRGZ').combobox('clear');
		    obj.CRGZ="CDGZ"+rows["DicCode"];
		    obj.cboCRGZ = Common_ComboToDic("cboCRGZ",obj.CRGZ,"",LogonHospID);
	    }
    });
    
	obj.cboGXBZD  = Common_ComboToDic("cboGXB","CRGXBZD","",LogonHospID);
	obj.cboBGKLX = Common_ComboToDic("cboBGKLX","CRReportType","",LogonHospID);
	obj.cboNCZZD  = Common_ComboToDic("cboNZZ","CRNZZZD","",LogonHospID);
	obj.cboQZDW = Common_ComboToDic("cboQZDW","CRZGZDDW","",LogonHospID);
	obj.cboLCZZ = Common_ComboToDic("cboLCZZ","CRDiagnoseBase","",LogonHospID);
	obj.cboXGZY = Common_ComboToDic("cboXGZY","CRDiagnoseBase","",LogonHospID);
	obj.cboXDT  = Common_ComboToDic("cboXDT","CRDiagnoseBase","",LogonHospID);
	obj.cboCT   = Common_ComboToDic("cboCT","CRDiagnoseBase","",LogonHospID);
	obj.cboXQM  = Common_ComboToDic("cboXQM","CRDiagnoseBase","",LogonHospID);
	obj.cboCGZ  = Common_ComboToDic("cboCGZ","CRDiagnoseBase","",LogonHospID);
	obj.cboNJY  = Common_ComboToDic("cboNJY","CRDiagnoseBase","",LogonHospID);
	obj.cboSJ   = Common_ComboToDic("cboSJ","CRDiagnoseBase","",LogonHospID);
	obj.cboNDT  = Common_ComboToDic("cboNDT","CRDiagnoseBase","",LogonHospID);
	obj.cboYSJC = Common_ComboToDic("cboYSJC","CRDiagnoseBase","",LogonHospID);
	obj.cboDeathReason = Common_ComboToDic("cboDeathReason","CRSWYYxnxg","",LogonHospID);
	obj.cboSHTD = Common_ComboToDic("cboSHTD","CRSHTD","",LogonHospID);
    obj.cboSJJG = Common_ComboToDic("cboSJJG","CRSJJG","",LogonHospID);
	obj.cboQZDW = Common_ComboToDic("cboQZDW","CRZGZDDW","",LogonHospID);
	obj.cboCRZD = Common_LookupToICD("cboCRZD");                              //诊断
	obj.cboCRSWZD = Common_LookupToICD("cboCRSWZD");                          //死亡诊断
	
	$("#cboCRZD").lookup({onSelect:function(index,rowData){ //诊断
		$('#txtICD').val(rowData['ICD10']);
		obj.CRZD = rowData['ICDRowID'];
	}});
	$('#cboCRZD').bind('change', function (e) {  
		if($('#cboCRZD').lookup("getText")==""){
			$('#txtICD').val('');            //给相关的ICD10赋值
		}
	});
	$("#cboCRSWZD").lookup({onSelect:function(index,rowData){ //死亡诊断
		$('#txtSWICD').val(rowData['ICD10']);
		obj.CRSWZD = rowData['ICDRowID'];
	}});
	$('#cboCRSWZD').bind('change', function (e) {  //诊断
		if($('#cboCRSWZD').lookup("getText")==""){
			$('#txtSWICD').val('');            //给相关的ICD10赋值
		}
	});
	$HUI.combobox('#cboGXB',{                                                     //冠心病
	    onSelect:function(rows){
		    $('#cboNZZ').combobox('clear');
		    $('input[type=checkbox][name=radSYZZList]').checkbox('setValue',false);
		    $('input[type=checkbox][name=radSYZZList]').checkbox('disable');
		    //$('#cboNZZ').combobox('disable');
		    if(rows.DicCode==''){
				 $('#cboNZZ').combobox("enable");
				 $('#radSYZZList').checkbox('enable');
			}
	    }
    });
	$HUI.combobox('#cboNZZ',{                                                     //脑卒中
	    onSelect:function(rows){			
			$('#cboGXB').combobox('clear');
		    $('input[type=checkbox][name=radSYZZList]').checkbox('enable');
			//$('#cboGXB').combobox('disable');
			if(rows.DicCode==''){
				 $('#cboGXB').combobox("enable");
			}
	    }
    });
	
	obj.LoadListInfo = function() {	  //加载单选、多选列表          
		obj.radSYZZList = Common_CheckboxToDic("radSYZZList","CRSYZZ",4);          //首要症状
		obj.radBSList = Common_CheckboxToDic("radBSList","CRZDBS",4);          //病史
	}
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID); 

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;  
	
	      
}
