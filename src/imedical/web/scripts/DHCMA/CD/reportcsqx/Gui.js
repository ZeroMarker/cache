$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();  
	obj.ReportID=ReportID;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }     
	
    
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

	obj.cboNation = Common_ComboToDic("cboNation","CRMZ","",LogonHospID);                                   //民族
	obj.cboOccupation = Common_ComboToDic("cboOccupation","CRMQZY","",LogonHospID);                                   //职业
	obj.cboEducation = Common_ComboToDic("cboEducation","CRDTHEducation","",LogonHospID);               //文化 

	obj.cboPreIncome = Common_ComboToDic("cboPreIncome","CRPreIncome","",LogonHospID);      //家庭年人均收入
	obj.cboRegType = Common_ComboToDic("cboRegType","CRRegType","",LogonHospID);      //户籍类型

	obj.cboChildSex = Common_ComboToDic("cboChildSex","CRChildSex","",LogonHospID);      //缺陷儿性别
	obj.cboMultiple = Common_ComboToDic("cboMultiple","CRMultiple","",LogonHospID);      //同卵异卵
	obj.cboOutCome = Common_ComboToDic("cboOutCome","CROutCome","",LogonHospID);      //转归

	obj.cboDefect = Common_ComboToDic("cboDefect","CRDefect","",LogonHospID);      //缺陷诊断
	obj.cboPosition = Common_ComboToDic("cboPosition","CRPosition","",LogonHospID);      //缺陷诊断位置
	obj.cboChdType = Common_ComboToDic("cboChdType","CRChdType","",LogonHospID);      //先心病类型
	
	obj.cboFoetNum = Common_ComboToDic("cboFoetNum","CRTS","",LogonHospID);      //胎数
	obj.cboMalfTime = Common_ComboToDic("cboMalfTime","CRJXZQSJ","",LogonHospID);      //畸形确诊时间
	obj.cboDiagBasis = Common_ComboToDic("cboDiagBasis","CRQXZDYJ","",LogonHospID);      //诊断依据
	
	obj.cboAbnoBirth = Common_ComboGrpDicID("cboAbnoBirth","CRYCSYS","",LogonHospID);      //异常生育史
	
	
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID); 

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;  
	
	      
}
