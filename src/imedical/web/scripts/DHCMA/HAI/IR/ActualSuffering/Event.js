﻿//页面Event
function InitActualSufferingWinEvent(obj){	
	obj.LoadEvent = function(args){
	    $('#ActualSuffering').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0

		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridActualSuffering();
		});
		
		//导出
		$('#btnExport').on('click', function(){
			var rows = obj.gridActualSuffering.datagrid('getRows');//返回当前页的所有行
	        if(rows.length==0){
		        $.messager.alert("错误","当前界面没有数据，无法导出!");
				return;
		    }
			$('#ActualSuffering').datagrid('toExcel', $('#DateFrom').datebox('getValue')+'实时现患列表.xls');
     	});
	}

    //疑似处理
	obj.PatScreenShow = function(EpisodeID) {
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'疑似病例筛查',
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:'95%',
			height:'95%',
			onBeforeClose:function(){
				obj.reloadgridActualSuffering();
			}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	}

	//摘要信息
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
	}
	
	//重新加载表格数据
	obj.reloadgridActualSuffering = function(){
		var HospIDs	    = $('#cboHospital').combobox('getValue');
		var DateFrom	= $('#DateFrom').datebox('getValue');
		//var Loc 		= $("#cboLoc").combobox('getValue');
		var SubLocArr   = $('#cboLoc').combobox('getValues');
		var Loc = SubLocArr.join();
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		/*if (Loc=="") {
			ErrorStr += '请选择科室!<br/>';
		}*/
		if (DateFrom=="") {
			ErrorStr += '请选择调查日期!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			$("#ActualSuffering").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.INFCSSSHSrv",
				QueryName:"QrySHAdm",
				ResultSetType:"array",
                aIntputs:HospIDs+"^"+DateFrom+"^"+DateFrom+"^"+Loc+"^"+($HUI.radio("#chkHCSSFlag").getValue()?1:0)+"^"+obj.LocType,
				//aHospIDs:HospIDs,
		        //aDateFrom:DateFrom,
		       // aLoc:Loc,
				page:1,
				rows:9999
			},function(rs){
				$('#ActualSuffering').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		}
	};
    
    obj.OpenInfPosDialog = function(aEpisodeID,aDiasID,aAdmitDate,aDischDate){
	    var t=new Date();
		t=t.getTime();
	
		var strUrl = "./dhcma.hai.ir.infdiagnos.csp?EpisodeID=" + aEpisodeID + "&DiagID=" + aDiasID +"&AdmitDate=" + aAdmitDate +"&DischDate=" + aDischDate+"&t=" + t ;
		websys_showModal({
			url:strUrl,
			title:'感染诊断-编辑',
			iconCls:'icon-w-paper',  
			width:'1010',
			height:'555',
			onBeforeClose:function(){
				obj.reloadgridActualSuffering();
			} 
		});
    }
}



