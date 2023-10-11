//页面Event
function InitHospSurveryWinEvent(obj){
	//初始化
	obj.LoadEvent = function(args){ 
		obj.reloadgridAdmLoad();
		//查询
		$("#btnQuery").on('click',function(){
			obj.reloadgridAdmLoad();
		});
		//前一天
		$("#btnLast").on('click',function(){
			var SelectDate 	= $("#dtDate").datebox('getValue');
			var SelectDate=getNextDate(SelectDate,-1) 
			Common_SetValue('dtDate',SelectDate);
			
			obj.reloadgridAdmLoad();
		});
		//当前
		$("#btnNow").on('click',function(){
			//当前日期
			var SelectDate = new Date();
			var SelectDate=Common_GetDate(SelectDate);
			Common_SetValue('dtDate',SelectDate);
	
			obj.reloadgridAdmLoad();
		});
		//后一天
		$("#btnNext").on('click',function(){
			var SelectDate 	= $("#dtDate").datebox('getValue');
			var SelectDate=getNextDate(SelectDate,1) 
			Common_SetValue('dtDate',SelectDate);
			
			obj.reloadgridAdmLoad();
		});
		//导出
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
		//病人导出
		$("#btnPatExport").on('click',function(){
			obj.btnPatExport_click();
		});
	}
	//查询
	obj.reloadgridAdmLoad = function(){
		var HospIDs = $("#cboHospital").combobox('getValue');
		var dtDate 	= $("#dtDate").datebox('getValue');
		//记录日期
		obj.SelectDate=dtDate;
		
		obj.gridHospSurvery.load({
           	ClassName: "DHCHAI.STAS.WelcomeSrv",
            QueryName: "QryHospSurvey",
            aHospIDs: HospIDs,
            aDate: dtDate
  	 	})
	};
	//导出
	obj.btnExport_click = function() {
		var rows=$("#gridHospSurvery").datagrid('getRows').length;
		if (rows>0) {
			$('#gridHospSurvery').datagrid('toExcel','全院概况('+obj.SelectDate+').xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	//患者导出
	obj.btnPatExport_click = function() {
		var rows=$("#gridPatInfo").datagrid('getRows').length;
		if (rows>0) {
			$('#gridPatInfo').datagrid('toExcel','患者基本信息'+obj.SelectDate+'.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	//打开患者基本信息
    obj.OpenPatInfo = function (aTypeID,aLocDesc) {
        $('#LayerPatInfo').show();		//显示
        $HUI.dialog('#LayerPatInfo', {
            title: "患者基本信息",
            iconCls: 'icon-w-paper',
            width: 1000,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        obj.refreshgridPatInfo(aTypeID,aLocDesc);
    }
    //刷新操作明细
    obj.refreshgridPatInfo = function (aTypeID,aLocDesc) {
        //前台刷新
        $("#gridPatInfo").datagrid("loading");
		$cm ({
			ClassName: "DHCHAI.DPS.PAAdmSrv",
            QueryName: "QryPatByType",
			ResultSetType:"array",
			aHospIDs:$("#cboHospital").combobox('getValue'),
            aLocDesc:aLocDesc,
			aDate:obj.SelectDate,
			aTypeID:aTypeID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridPatInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
        //根据查询类型刷新列信息
        var bcolumn1 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc1");
        var bcolumn2 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc2");
        var bcolumn3 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc3");
        var bcolumn4 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc4");
        var bcolumn5 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc5");
        var bcolumn6 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc6");
        var bcolumn7 = $('#gridPatInfo').datagrid('getColumnOption', "ItemDesc7");
  	 	if(aTypeID==1){
	  	 	bcolumn1.title="入院科室";
	  	 	bcolumn2.title="入院日期";
	  	 	bcolumn3.title="入院时间";
	  	 	bcolumn4.title="出院科室";
	  	 	bcolumn5.title="出院日期";
	  	 	bcolumn6.title="出院时间";
	  	 	bcolumn1.width=120;
	  	 	bcolumn2.width=120;
	  	 	bcolumn3.width=120;
	  	 	bcolumn4.width=120;
	  	 	bcolumn5.width=120;
	  	 	bcolumn6.width=120;
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc4');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc5');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc6');	//显示
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc7');	//隐藏列
	  	}
  	 	if(aTypeID==2){
	  	 	bcolumn1.title="在院科室";
	  	 	bcolumn2.title="入院日期";
	  	 	bcolumn3.title="入院时间";
	  	 	bcolumn4.title="出院科室";
	  	 	bcolumn5.title="出院日期";
	  	 	bcolumn6.title="出院时间";
	  	 	bcolumn1.width=120;
	  	 	bcolumn2.width=120;
	  	 	bcolumn3.width=120;
	  	 	bcolumn4.width=120;
	  	 	bcolumn5.width=120;
	  	 	bcolumn6.width=120;
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc4');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc5');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc6');	//显示
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc7');	//隐藏列
	  	}
	  	if(aTypeID==3){
	  	 	bcolumn1.title="体温";
	  	 	bcolumn2.title="测量日期";
	  	 	bcolumn3.title="测量时间";
	  	 	bcolumn1.width=60;
	  	 	bcolumn2.width=120;
	  	 	bcolumn3.width=120;
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc4');	//隐藏列
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc5');	//隐藏列
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc6');	//隐藏列
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc7');	//隐藏列
	  	}
	  	if((aTypeID==4)||(aTypeID==5)||((aTypeID==6))){
	  	 	bcolumn1.title="插管医嘱";
	  	 	bcolumn2.title="插管开始日期";
	  	 	bcolumn3.title="插管结束日期";
	  	 	bcolumn1.width=150;
	  	 	bcolumn2.width=120;
	  	 	bcolumn3.width=120;
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc4');	//隐藏列
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc5');	//隐藏列
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc6');	//隐藏列
	  	 	$('#gridPatInfo').datagrid('hideColumn','ItemDesc7');	//隐藏列
	  	}
	  	if(aTypeID==7){
	  	 	bcolumn1.title="抗菌药物名称";
	  	 	bcolumn2.title="使用开始时间";
	  	 	bcolumn3.title="使用结束时间";
	  	 	bcolumn4.title="等级";
	  	 	bcolumn5.title="用药目的";
	  	 	bcolumn6.title="途径";
	  	 	bcolumn7.title="医生";
	  	 	bcolumn1.width=150
	  	 	bcolumn2.width=180
	  	 	bcolumn3.width=180
	  	 	bcolumn4.width=80
	  	 	bcolumn5.width=80
	  	 	bcolumn6.width=100
	  	 	bcolumn7.width=100
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc4');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc5');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc6');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc7');	//显示
	  	}
	  	if(aTypeID==8){
	  	 	bcolumn1.title="手术名称";
	  	 	bcolumn2.title="手术开始日期时间";
	  	 	bcolumn3.title="手术结束日期时间";
	  	 	bcolumn4.title="切口类别";
	  	 	bcolumn5.title="愈合等级";
	  	 	bcolumn6.title="ASA评分";
	  	 	bcolumn7.title="NNIS分级";
	  	 	bcolumn1.width=180
	  	 	bcolumn2.width=180
	  	 	bcolumn3.width=180
	  	 	bcolumn4.width=100
	  	 	bcolumn5.width=100
	  	 	bcolumn6.width=100
	  	 	bcolumn7.width=100
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc4');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc5');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc6');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc7');	//显示
	  	}
	  	if(aTypeID==9){
	  	 	bcolumn1.title="在院科室";
	  	 	bcolumn2.title="入院日期";
	  	 	bcolumn3.title="入院时间";
	  	 	bcolumn4.title="出院科室";
	  	 	bcolumn5.title="出院日期";
	  	 	bcolumn6.title="出院时间";
	  	 	bcolumn7.title="是否死亡";
	  	 	bcolumn1.width=120;
	  	 	bcolumn2.width=120;
	  	 	bcolumn3.width=120;
	  	 	bcolumn4.width=120;
	  	 	bcolumn5.width=120;
	  	 	bcolumn6.width=120;
	  	 	bcolumn7.width=100;
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc1');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc2');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc3');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc4');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc5');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc6');	//显示
	  	 	$('#gridPatInfo').datagrid('showColumn','ItemDesc7');	//显示
	  	}
        $('#gridPatInfo').datagrid();
    }
    //摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
	    websys_showModal({
			url:url,
			title:'医院感染集成视图',
			iconCls:'icon-w-epr',
			closable:true,
			width:'95%',
			height:'95%'
		});
	};
	//电子病历
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
		var rst = $m({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			MethodName:"GetPaAdmHISx",
			aEpisodeID:EpisodeID
		},false);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';	
		websys_showModal({
			url:url,
			title:'病历浏览',
			iconCls:'icon-w-epr',
			closable:true,
			width:1298,
			height:'95%'
		});
	};
	//获取day天后的日期
	function getNextDate(date,day) {  
  		var dd = new Date(date);
  		dd.setDate(dd.getDate() + day);
  		var y = dd.getFullYear();
  		var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
  		var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
  		return y + "-" + m + "-" + d;
	};
}

