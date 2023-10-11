//页面Event
function InitInHosQueryWinEvent(obj){	
    $('#winInHosDetail').dialog({
		title: '在院患者-出入径明细列表',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});
	obj.LoadEvent = function(args){
		//查询
		$('#btnQuery').on('click', function(){
			obj.InHosQueryLoad();
		});
		$('#btnExport').on('click', function(){
			obj.btnExport("GridInHosQuery",obj.GridInHosQuery,"在院患者统计");
		});
		$('#btnDetailExport').on('click', function(){
			obj.ExportInHosDetail();
		});
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.InHosQueryLoad();
			}
		});
		//医院科室联动
		$HUI.combobox('#cboSSHosp',{
		    onChange:function(n,o){
			    if (o!="") $("#cboLoc").combobox('clear');		//首次加载不清除赋值
				$("#cboLoc").combobox('reload');
				obj.InHosQueryLoad();  
			}
	    });
		//权限控制
		if(tDHCMedMenuOper['admin']<1){
			$("#cboLoc").combobox('select',session['DHCMA.CTLOCID']);	 
			$('#cboSSHosp').combobox('disable');
			$('#cboLoc').combobox('disable');
		}
	}
	obj.btnExport = function(id,objExport,TitleDesc){
		var rows = objExport.getRows().length; 
		if (rows>0) {
		   grid2excel($('#'+id), {IE11IsLowIE: false,filename:TitleDesc,allPage: true});
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}
	}
	obj.ExportInHosDetail = function(){
		var rows = obj.GridInHosDetail.getRows().length; 
		if (rows>0) {
		   grid2excel($('#GridInHosDetail'), {IE11IsLowIE: false,filename:obj.LocDesc+"出入径明细列表",allPage: true});
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}
	}
	obj.InHosQueryLoad = function(){
		obj.LocID=$("#cboLoc").combobox('getValue')
	     $cm ({
			ClassName:"DHCMA.CPW.CPS.PathwaySrv",
			QueryName:"QryAdmInHos",		
			aLocID:$("#cboLoc").combobox('getValue'),
			aHospID:$("#cboSSHosp").combobox('getValue'),
			aStatus: obj.Status,
			page:1,
			rows:99999
		},function(rs){
			$('#GridInHosQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	obj.GridInHosQuery_onDblClick = function(rowIndex,rowData){
		obj.LocDesc=rowData.BTLocDesc
		if(rowData.BTCPWCount==0){
			$.messager.alert("确认", "此科室没有入径人数", 'info');
			return;
		}
		$('#winInHosDetail').dialog({
			title: '在院患者-出入径明细列表[<span style="margin:0;">科室:</span>'+rowData.BTLocDesc+'<span style="margin:0 0 0 10px;">在院人数:</span>'+rowData.BTCount+'<span style="margin:0 0 0 10px;">入径人数:</span>'+rowData.BTCPWCount+'<span style="margin:0 0 0 10px;">路径数:</span>'+rowData.BTFormCount+']'
		});
		$HUI.dialog('#winInHosDetail').open();
		obj.LocID=rowData.BTLocID
		obj.ShowInHosDetail(rowData);
    }
}