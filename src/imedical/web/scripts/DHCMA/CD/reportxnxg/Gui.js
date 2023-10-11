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
	
	//常住地址
	obj.cboRegProvince = Common_ComboToArea2("cboRegProvince","1",1);            // 省
	obj.RegCity = $HUI.combobox('#cboRegProvince', {
		onChange:function(newValue,oldValue){
			$('#cboRegCity').combobox('clear');
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegCity = Common_ComboToArea2("cboRegCity","cboRegProvince",2);				// 市
		}		
	});
	obj.RegCounty = $HUI.combobox('#cboRegCity', {
		onChange:function(newValue,oldValue){
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegCounty = Common_ComboToArea2("cboRegCounty","cboRegCity",3);             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboRegCounty', {
		onChange:function(newValue,oldValue){
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
			obj.cboRegVillage = Common_ComboToArea2("cboRegVillage","cboRegCounty",4);         // 乡
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
	// 报卡单位地址
	//省
		obj.cboRepProvince = $HUI.combobox('#cboRepProvince', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1";
		   	 	$('#cboRepProvince').combobox('reload',url);
			}, onChange:function(newValue,oldValue){		
				$('#cboRepCity').combobox('clear');
				$('#cboRepCounty').combobox('clear');
				obj.cboRepCity.reload();
			}
		});

		//市
		obj.cboRepCity = $HUI.combobox('#cboRepCity', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboRepProvince').combobox('getValue');
		   	 	$('#cboRepCity').combobox('reload',url);
			}, onChange:function(newValue,oldValue){
				$('#cboRepCounty').combobox('clear');
				obj.cboRepCounty.reload();
			}
		});	
		//县
		obj.cboRepCounty = $HUI.combobox('#cboRepCounty', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboRepCity').combobox('getValue');
		   	 	$('#cboRepCounty').combobox('reload',url);
			}
		});
	
	
	
	obj.cboNation = Common_ComboToDic("cboNation","CRMZ","",LogonHospID);                                   //民族
	obj.cboOccupation = Common_ComboToDic("cboOccupation","CRZY","",LogonHospID);                                   //职业
	obj.cboEducation = Common_ComboToDic("cboEducation","CRDTHEducation","",LogonHospID);               //文化 
	obj.cboMarital = Common_ComboToDic("cboMarital","CRDTHMarriage","",LogonHospID);                    //婚姻情况 
	
	obj.cboCardType = Common_ComboToDic("cboCardType","CRCardType","",LogonHospID);                    // 证件类型
	obj.cboLevel = Common_ComboToDic("cboLevel","XNXGLevel","",LogonHospID);                    // 单位级别
	obj.cboOutCome = Common_ComboToDic("cboOutCome","XNXGOutCome","",LogonHospID);                    // 转归
	
	 
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
	obj.cboSHTD = Common_ComboToDic("cboSHTD","CRSHTD","",LogonHospID);
    obj.cboSJJG = Common_ComboToDic("cboSJJG","CRSJJG","",LogonHospID);
	obj.cboCRSWZD = Common_LookupToICD("cboCRSWZD");                          //死亡诊断
	obj.cboDeathReason = Common_ComboToDic("cboDeathReason","CRSWYYxnxg","",LogonHospID);
	
	// 诊断
	obj.cboCRZD = $('#cboCRZD').lookup({
			panelWidth: 320,
			url: $URL,
			editable: true,
			mode: 'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			valueField: 'myid',
			textField: 'Description',
			pagination: true,
			loadMsg: '正在查询',
			//isCombo:true,             //是否输入字符即触发事件，进行搜索
			//minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
			queryParams:{ClassName: 'DHCMed.SSService.DictionarySrv',QueryName: 'QryDictionary', aType: "XNXGDiag"},
				columns: [[
				{ field: 'myid', title: '字典ID', width: 60 },
				{ field: 'Code', title: 'ICD编码', width: 80 },
				{ field: 'Description', title: '诊断描述', width: 100 },
				
			]],
			onBeforeLoad: function (param) {
				var desc = param['q'];
				//if (desc=="") return false;        
				param = $.extend(param, { aAlias: desc }); //将参数q转换为类中的参数
			},
			onSelect: function (index, rowData) {
				obj.CRZD = rowData['myid'];
				$('#txtICD').val(rowData['Code']);
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
	
	obj.LoadListInfo = function() {	  //加载单选、多选列表          
		obj.chkDiagList = Common_CheckboxToDic("chkDiagList","XNXGDiagList",7)	// 诊断依据
		obj.radIsLiveSixMonth = Common_RadioToDic("radIsLiveSixMonth","XNXGLiveSixMonth",2)	// 在本辖区连续居住6个月以上：
		obj.radCureMethod = Common_chkRadioToDic("radCureMethod","XNXGCureMethod",3)		// 心绞痛治疗措施
		obj.radApoplexyType = Common_chkRadioToDic("radApoplexyType","XNXGApoplexyType",4)	// 脑卒中类型
		obj.radSCD = Common_chkRadioToDic("radSCD","XNXGSCD",2)	// 心源性猝死
		obj.radInfer = Common_chkRadioToDic("radInfer","XNXGInfer",1)	// 推断
		obj.radIsFirstAttck = Common_RadioToDic("radIsFirstAttck","XNXGLiveSixMonth",2)	// 是否首次发病
		obj.radIsFirstAttck = Common_chkRadioToDic("radBiochemicalMark","BiochemicalMark",2)	// 生化标志物
		obj.radIsFirstAttck = Common_chkRadioToDic("radReissue","Reissue",3)	// 补发
		
		
		
	}
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID); 

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;  
	
	      
}
