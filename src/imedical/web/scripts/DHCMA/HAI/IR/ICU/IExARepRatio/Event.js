//页面Event
function InitIExARatioWinEvent(obj){
	obj.LoadEvent = function(args){ 
		obj.reloadGridIExARepRatio();
		$("#btnQuery").on('click',function(){
			obj.reloadGridIExARepRatio();
		});
		//三管感染核心防控措施执行率统计导出
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
		//三管感染核心防控措施执行率统计明细表导出
		$("#btnDtlExport").on('click',function(){
			obj.btnDtlExport_click();
		});
		//住院患者明细表导出
		$("#btnTubePatDtlExport").on('click',function(){
			obj.btnTubePatDtlExport_click();
		});
		//（PICC,UC,VAP）使用明细表导出
		$("#btnTubeDayDtlExport").on('click',function(){
			obj.btnTubeDayDtlExport_click();
		});
		$("#btnTubeInfDtlExport").on('click',function(){
			obj.btnTubeInfDtlExport_click();
		});
	}
	
	$("#btnTips").popover({
		width:'700px',
		height:'480px',
		content:'',
		trigger:'hover',
		type:'iframe',
		url:'../scripts/DHCMA/HAI/IR/ICU/IExARepRatio/tips.html'
	});
	
	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID){	
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

    	
    //********************************************************************* ↓↓↓三管感染核心防控措施执行率统计表
    //导出三管感染核心防控措施执行率统计表
	obj.btnExport_click = function() {
		var rows=$("#gridIExARepRatio").datagrid('getRows').length;
		if (rows>0) {
			$('#gridIExARepRatio').datagrid('toExcel','三管感染核心防控措施执行率统计表'+$("#dtDateFrom").datebox('getValue')+"至"+$("#dtDateTo").datebox('getValue')+'.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	//重新加载表格数据：三管感染核心防控措施执行率统计表
	obj.reloadGridIExARepRatio = function(){
		var ErrorStr="";
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatDimens=="")){
			$.messager.alert("提示","请选择展示维度！", 'info');
			return;
		}
		$("#gridIExARepRatio").datagrid("loading");
        var Ret = $cm({
			ClassName:"DHCHAI.IRS.IExAQrySrv",
			QueryName:"QryIExARepRatio",
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aLocType:aLocType,
			aQryCon:aQrycon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
            page: 1,
            rows: 99999
        }, function (rs) {
            $('#gridIExARepRatio').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
	};
	//********************************************************************* ↑↑↑ 三管感染核心防控措施执行率统计表
	
	//********************************************************************* ↓↓↓三管感染核心防控措施执行率统计明细表 
	//三管感染核心防控措施执行率统计明细表导出
	obj.btnDtlExport_click = function() {
		var rows=$("#gridIExARatiolDtl").datagrid('getRows').length;
		if (rows>0) {
			$('#gridIExARatiolDtl').datagrid('toExcel','三管感染核心防控措施执行率统计明细表'+'.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	//打开三管感染核心防控措施执行率统计明细表基本信息
    obj.OpenDtlInfo = function (aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID,aIsExe) {
        $('#LayerDtlInfo').show();		//显示
        $HUI.dialog('#LayerDtlInfo', {
            title: "三管感染核心防控措施执行率统计明细表",
            iconCls: 'icon-w-paper',
            width: 1400,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        //打开'督查表'链接
   		obj.OpenIExARep = function (IExAID) {
			var url = '../csp/dhcma.hai.ir.icu.iexareport.csp?aIExAID=' + IExAID + '&aIsAdmin=' + 1  + '&2=2';
       		websys_showModal({
        		url: url,
        		title: $g("三管感染防控督查表"),
        		iconCls:'icon-w-epr',
        		closable: true,
       			width: 1268,
       			height: '95%',
            	onBeforeClose: function () {
	            obj.refreshGridIExARatiolDtl(aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID,aIsExe);
	           	obj.reloadGridIExARepRatio();
            	}
       		});
    	}
        obj.refreshGridIExARatiolDtl(aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID,aIsExe);
    }
    //刷新三管感染核心防控措施执行率统计明细
    obj.refreshGridIExARatiolDtl = function (aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID,aIsExe) {
        //前台刷新
        $("#gridIExARatiolDtl").datagrid("loading");
		$cm ({
			ClassName: "DHCHAI.IRS.IExAQrySrv",
            QueryName: "QryRepRatioDtl",
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aDimensKey:aDimensKey,
			aStaType:aStaType,
			aTubeType:aTubeType,
			aLocIDs:aICULocID,
			aIsExe:aIsExe,
			page:1,
			rows:99999
		},function(rs){
			$('#gridIExARatiolDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
    //********************************************************************* ↑↑↑三管感染核心防控措施执行率统计明细
    
    //********************************************************************* ↓↓↓住院人数明细表
    //住院患者明细表导出
	obj.btnTubePatDtlExport_click = function() {
		var rows=$("#gridTubePatDtl").datagrid('getRows').length;
		if (rows>0) {
			$('#gridTubePatDtl').datagrid('toExcel','住院患者明细表'+'.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	//打开住院人数明细表基本信息
    obj.OpenTubePatDtl = function (aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID) {
        $('#LayerTubePatDtl').show();		//显示
        $HUI.dialog('#LayerTubePatDtl', {
            title: "住院人数明细表",
            iconCls: 'icon-w-paper',
            width: 1400,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        obj.refreshgridTubePatDtl(aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID);
    }
    //刷住院人数明细表
    obj.refreshgridTubePatDtl= function (aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID) {
        //前台刷新
        $("#gridTubePatDtl").datagrid("loading");
		$cm ({
			ClassName: "DHCHAI.STATV2.S3TubeInf",
            QueryName: "QryTubePatDtl",
            aHospIDs:aHospIDs,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aDimensKey:aDimensKey,
			aStaType:aStaType,
			aTubeType:aTubeType,
			aLocIDs:aICULocID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridTubePatDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
		//根据查询类型刷新列信息
		var bTranLocDesc = $('#gridTubePatDtl').datagrid('getColumnOption', "TranLocDesc");
		var bTransDateTime = $('#gridTubePatDtl').datagrid('getColumnOption', "TransDateTime");
		var bOutLocDateTime = $('#gridTubePatDtl').datagrid('getColumnOption', "OutLocDateTime");
  	 	if(aStaType=="E"){
	  	 	bTranLocDesc.title="入住科室";
	  	 	bTransDateTime.title="入科室时间";
	  	 	bOutLocDateTime.title="出科室时间";

	  	}else if(aStaType=="W"){
		  	bTranLocDesc.title="入住病区";
	  	 	bTransDateTime.title="入病区时间";
	  	 	bOutLocDateTime.title="出病区时间";
		}
	  	$('#gridTubeDayDtl').datagrid('showColumn','TranLocDesc');	//显示
	  	$('#gridTubeDayDtl').datagrid('showColumn','TransDateTime');	//显示
	  	$('#gridTubeDayDtl').datagrid('showColumn','OutLocDateTime');	//显示
    }
    //********************************************************************* ↑↑↑住院人数明细表
    
    
    //********************************************************************* ↓↓↓插管人数
	//打开（PICC,UC,VAP）使用明细表基本信息
    obj.OpenTubeDayDtl = function (aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID) {
        $('#LayerTubeDayDtl').show();		//显示
        if(aTubeType=="PICC"){
	        var TubeDesc="中央血管导管(PICC)";	    
	    }
	    if(aTubeType=="VAP"){
	        var TubeDesc="呼吸机";
	    }
	    if(aTubeType=="UC"){
	        var TubeDesc="导尿管";
	    }
        $HUI.dialog('#LayerTubeDayDtl', {
            title: TubeDesc+"使用明细表",
            iconCls: 'icon-w-paper',
            width: 1400,
            height: 500,
            modal: true,
            isTopZindex: true
        });
       	obj.btnTubeDayDtlExport_click = function() {   //（PICC,UC,VAP）使用明细导出
			var rows=$("#gridTubeDayDtl").datagrid('getRows').length;
			if (rows>0) {
				$('#gridTubeDayDtl').datagrid('toExcel',TubeDesc+'使用明细表'+'.xls');
			
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
				return;
			}	
		};
        obj.refreshgridTubeDayDtl(aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID); 
    }
    //刷新（PICC,UC,VAP）使用明细
    obj.refreshgridTubeDayDtl= function (aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID) {
        //前台刷新
        $("#gridTubeDayDtl").datagrid("loading");
		$cm ({
			ClassName: "DHCHAI.STATV2.S3TubeInf",
            QueryName: "QryTubeDayDtl",
            aHospIDs:aHospIDs,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aDimensKey:aDimensKey,
			aStaType:aStaType,
			aTubeType:aTubeType,
			aLocIDs:aICULocID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridTubeDayDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
		//根据查询类型刷新列信息
		var bTranLocDesc = $('#gridTubeDayDtl').datagrid('getColumnOption', "TranLocDesc");
		var bTransDateTime = $('#gridTubeDayDtl').datagrid('getColumnOption', "TransDateTime");
		var bOutLocDateTime = $('#gridTubeDayDtl').datagrid('getColumnOption', "OutLocDateTime");
  	 	if(aStaType=="E"){
	  	 	bTranLocDesc.title="入住科室";
	  	 	bTransDateTime.title="入科室时间";
	  	 	bOutLocDateTime.title="出科室时间";

	  	}else if(aStaType=="W"){
		  	bTranLocDesc.title="入住病区";
	  	 	bTransDateTime.title="入病区时间";
	  	 	bOutLocDateTime.title="出病区时间";
		}
	  	$('#gridTubeDayDtl').datagrid('showColumn','TranLocDesc');	//显示
	  	$('#gridTubeDayDtl').datagrid('showColumn','TransDateTime');	//显示
	  	$('#gridTubeDayDtl').datagrid('showColumn','OutLocDateTime');	//显示
    }		
    //********************************************************************* ↑↑↑插管人数 
    
    //********************************************************************* ↓↓↓感染人数/感染例次数
	//打开基本信息
    obj.OpenTubeInfDtl = function (aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID) {
        $('#LayerTubeInfDtl').show();		//显示
        if(aTubeType=="PICC"){
	        var title="中央血管导管新发生CLABSI明细表"	    
	    }
	    if(aTubeType=="VAP"){
	        var title="呼吸机新发生VAP明细表"
	    }
	    if(aTubeType=="UC"){
	        var title="导尿管新发生CAUTI明细表"
	    }
        $HUI.dialog('#LayerTubeInfDtl', {
            title: title,
            iconCls: 'icon-w-paper',
            width: 1400,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        obj.btnTubeInfDtlExport_click = function() {      //导出
			var rows=$("#gridTubeInfDtl").datagrid('getRows').length;
			if (rows>0) {
				$('#gridTubeInfDtl').datagrid('toExcel',title+'.xls');
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
				return;
			}	
		}
        obj.refreshgridTubeInfDtl(aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID);
    }
    //刷新明细表
    obj.refreshgridTubeInfDtl= function (aHospIDs,aDateFrom,aDateTo,aDimensKey,aStaType,aTubeType,aICULocID) {
        //前台刷新
        $("gridTubeInfDtl").datagrid("loading");
		$cm ({
			ClassName: "DHCHAI.STATV2.S3TubeInf",
            QueryName: "QryTubeInfDtl",
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aDimensKey:aDimensKey,
			aStaType:aStaType,
			aTubeType:aTubeType,
			aLocIDs:aICULocID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridTubeInfDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		//根据查询类型刷新列信息
		var bTranLocDesc = $('#gridTubeInfDtl').datagrid('getColumnOption', "TranLocDesc");
		var bTransDateTime = $('#gridTubeInfDtl').datagrid('getColumnOption', "TransDateTime");
		var bOutLocDateTime = $('#gridTubeInfDtl').datagrid('getColumnOption', "OutLocDateTime");
  	 	if(aStaType=="E"){
	  	 	bTranLocDesc.title="入住科室";
	  	 	bTransDateTime.title="入科室时间";
	  	 	bOutLocDateTime.title="出科室时间";

	  	}else if(aStaType=="W"){
		  	bTranLocDesc.title="入住病区";
	  	 	bTransDateTime.title="入病区时间";
	  	 	bOutLocDateTime.title="出病区时间";
		}
	  	$('#gridTubeDayDtl').datagrid('showColumn','TranLocDesc');	//显示
	  	$('#gridTubeDayDtl').datagrid('showColumn','TransDateTime');	//显示
	  	$('#gridTubeDayDtl').datagrid('showColumn','OutLocDateTime');	//显示
    }
    //********************************************************************* ↑↑↑感染人数/感染例次数	
}
