function InitReportWin(){
	//head 定义
	var obj=new Object();
	obj.ReportID=ReportID;
	//权限控制
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }  
	if (typeof tDHCMedMenuOper=="undefined"){
		$.messager.alert("提示","您没有操作权限，请找相关人员增加权限!");
		renturn
	}	
		
	$.parser.parse();        // 解析整个页面 
	
	//加载基本信息,获取地址
	obj.LoadNotice	 = function(aKeys,aHospID) {
		var NoticeInfo = $m({                  
			ClassName:"DHCMed.SSService.ConfigSrv",
			MethodName:"GetValueByKeyHosp",
			aKeys:aKeys,
			aHospitalID:aHospID
		},false);
		return NoticeInfo;
	}
	// 获取地址
	obj.LoadArea = function() {
		var AreaInfo = $m({                  
			ClassName:"DHCMed.EPDService.InitRepLoadSrv",
			MethodName:"GetDictionary",
			aConfigList:"GetAreaInfo!!EpdInitAddressByLocalHospital"
		},false);
		return AreaInfo;
	}
	//病人基本信息
	//年龄单位
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","ERPatAge");
	//传染病报卡默认初始化加载当地医院所在的省、市、县三级obj.LoadNotice
	obj.EpdInitAddressByLocalHospital = obj.LoadArea();  
	
	//省市县乡联动
	obj.cboERCurrProvince = Common_ComboToAreaEpd("cboERCurrProvince","1",1);               // 省
	obj.cboERCurrCity = $HUI.combobox('#cboERCurrProvince', {
		onChange:function(newValue,oldValue){
			$('#cboERCurrCity').combobox('clear');
			$('#cboERCurrCounty').combobox('clear');
			$('#cboERCurrTown').combobox('clear');
			$('#txtERCurrVillage').val('');
			obj.cboERCurrCity = Common_ComboToAreaEpd("cboERCurrCity","cboERCurrProvince",2);			  // 市
		}
	});
	obj.cboERCurrCounty = $HUI.combobox('#cboERCurrCity', {
		onChange:function(newValue,oldValue){
			$('#cboERCurrCounty').combobox('clear');
			$('#cboERCurrTown').combobox('clear');
			$('#txtERCurrVillage').val('');
			obj.cboERCurrCounty = Common_ComboToAreaEpd("cboERCurrCounty","cboERCurrCity",3);            // 县
		}
	});
	
	obj.cboERCurrTown = $HUI.combobox('#cboERCurrCounty', {
		onChange:function(newValue,oldValue){
			$('#cboERCurrTown').combobox('clear');
			$('#txtERCurrVillage').val('');
			obj.cboERCurrTown = Common_ComboToAreaEpd("cboERCurrTown","cboERCurrCounty",4);         // 乡
		}
	});
	$HUI.combobox('#cboERCurrTown', {
		onSelect:function(record){
			if (record) {
			    $('#txtERCurrVillage').val('');
				$('#txtERCurrAddress').val($('#cboERCurrProvince').combobox('getText')+$('#cboERCurrCity').combobox('getText')+$('#cboERCurrCounty').combobox('getText')+$('#cboERCurrTown').combobox('getText'));
			}
		}
	});
	//标本信息
	obj.cboERSpecimenType=Common_ComboToDic("cboERSpecimenType","ERSpecimenType")
	obj.cboERSpecimenSource=Common_ComboToDic("cboERSpecimenSource","ERSpecimenSource")
	//$("#txtERAdmDate").datebox("setValue",Common_GetDate(new Date()))  //就诊日期默认为空
	$("#txtERRepDate").datebox("setValue",Common_GetDate(new Date()))
	$("#txtERSickDate").datebox("setValue",Common_GetDate(new Date()))	
	obj.cboERAdmLoc=Common_ComboToLoc("cboERAdmLoc","E","","")	
	//流感样病例爆发监测 
	$("#cboERSpecimenSource").combobox({
		onSelect:function(data){
			$("#fontERIncident").attr("style","display:none");
			if(data.DicDesc.indexOf("流感样病例暴发监测")>=0)$("#fontERIncident").removeAttr("style",true);
		}
	})
	
	//foot  执行
	InitReportWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}