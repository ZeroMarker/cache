$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
	obj.ReportID=ReportID;
	obj.ZDID ='';  
	obj.SWZD ='';
    obj.CRGZ= ''; 
    
	//基本信息
	$('#cboPatAgeDW').combobox({});  //年龄单位
	$('#cboCRGZ').combobox({});      //工种
	obj.cboCRZY = Common_ComboToDic("cboCRZY","CRZY","",LogonHospID);                                             //职业
	obj.cboCRMZ = Common_ComboToDic("cboCRMZ","CRMZ","",LogonHospID);                                             //民族                                       
	//职业工种联动
	$HUI.combobox('#cboCRZY',{                                                                      //工种
	    onSelect:function(rows){
		    $('#cboCRGZ').combobox('clear');
		    obj.CRGZ="CDGZ"+rows["DicCode"];
		    obj.cboCRGZ = Common_ComboToDic("cboCRGZ",obj.CRGZ,"",LogonHospID);
	    }
    });
	
	obj.cboCRWH = Common_ComboToDic("cboCRWH","CRDTHEducation","",LogonHospID);                                   //文化
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","CRPatAge","",LogonHospID);                                 //年龄单位
	obj.cboCRZGZDDW = Common_ComboToDic("cboCRZGZDDW","CRZGZDDW","",LogonHospID);                                 //最高诊断单位
	obj.cboProvince1 = Common_ComboToArea2("cboProvince1","1",1);                                     //省
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
	$HUI.combobox('#cboVillage1', {                                                    //村
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
	obj.cboProvince2 = Common_ComboToArea2("cboProvince2","1",1);                        // 省
	obj.RegCity2 = $HUI.combobox('#cboProvince2', {
		onChange:function(newValue,oldValue){
			$('#cboCity2').combobox('clear');
			$('#cboCounty2').combobox('clear');
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboCity2 = Common_ComboToArea2("cboCity2","cboProvince2",2);				// 市
		}		
	});
	obj.RegCounty2 = $HUI.combobox('#cboCity2', {
		onChange:function(newValue,oldValue){
			$('#cboCounty2').combobox('clear');
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboCounty2 = Common_ComboToArea2("cboCounty2","cboCity2",3);             // 县
		}
	});
	obj.RegVillage2 = $HUI.combobox('#cboCounty2', {
		onChange:function(newValue,oldValue){
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboVillage2 = Common_ComboToArea2("cboVillage2","cboCounty2",4);         // 乡
		}
	});
	$HUI.combobox('#cboVillage2', {
		onSelect:function(record){
			if (record) {
			    $('#txtCUN2').val('');
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtCUN2').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtAdress2').val($('#cboProvince2').combobox('getText')+$('#cboCity2').combobox('getText')+$('#cboCounty2').combobox('getText')+$('#cboVillage2').combobox('getText')+$('#txtCUN2').val());
	});
	//诊断信息
	obj.cboCRZY = Common_ComboToDic("cboCRZDLX","CRZDLX","",LogonHospID);                                   //糖尿病类型
	obj.cboCRZD = Common_LookupToICD("cboCRZD");                                //诊断
	$("#cboCRZD").lookup({onSelect:function(index,rowData){
		$('#txtCRZDICD').val(rowData['ICD10']);
		obj.ZDID = rowData['ICDRowID'];
	}});
	$('#cboCRZD').bind('change', function (e) {  //诊断
		if($('#cboCRZD').lookup("getText")==""){
			$('#txtCRZDICD').val('');            //给相关的ICD10赋值
		}
	});
	obj.cboCRSWZD = Common_LookupToICD("cboCRSWZD");                          //死亡诊断
	$("#cboCRSWZD").lookup({onSelect:function(index,rowData){
		$('#txtCRSYICD').val(rowData['ICD10']);
		obj.SWZD = rowData['ICDRowID'];
	}});
	$('#cboCRSWZD').bind('change', function (e) {  //死亡诊断
		if($('#cboCRSWZD').lookup("getText")==""){
			$('#txtCRSYICD').val('');            //给相关的ICD10赋值
		}
	});
	obj.cboCRSWYY = Common_ComboToDic("cboCRSWYY","CRSWYY","",LogonHospID);                                 //死亡原因
	obj.LoadListInfo = function() {	  //加载单选、多选列表	
		obj.cbgCRBFZ = Common_CheckboxToDic("cbgCRBFZ","CRBFZ",4);                      //并发症   
		obj.cbgCRWHYS = Common_CheckboxToDic("cbgCRWHYS","CRWHYS",4);                   //危害因素   
		obj.cbgCRJZS = Common_CheckboxToDic("cbgCRJZS","CRJZS",4);                      //家族史   
		obj.cbgCRLCBX = Common_CheckboxToDic("cbgCRLCBX","CRLCBX",4);                   //临床表现
	}
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID);                            //报卡科室
    
	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
