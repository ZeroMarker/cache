//页面Event
function InitCheckQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){
		//查询
		$('#btnQuery').on('click', function(){
			obj.CheckQueryLoad();
		});
		$('#btnExport').on('click', function(){
			obj.btnExport("GridCheckQuery",obj.GridCheckQuery,"临床路径出入径查询表");
		});
		//日期选择判断
		$HUI.datebox("#DateFrom", {
			onSelect:function(){
				var ret=Common_CompareDate(Common_GetValue("DateFrom"),Common_GetValue("DateTo"));				
				if (ret>0) {
					$.messager.popover({msg: '开始日期不能大于结束日期！',type:'error',timeout: 1000})
					Common_SetValue("DateFrom",'');
					}
			}
		});
		$HUI.datebox("#DateTo", {
			onSelect:function(){
				var ret=Common_CompareDate(Common_GetValue("DateFrom"),Common_GetValue("DateTo"));
				if (ret>0) {
					$.messager.popover({msg: '结束日期不能小于开始日期！',type:'error',timeout: 1000})
					Common_SetValue("DateTo",'');
					}
			}
		});
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.CheckQueryLoad();
			}
		});
		//医院科室联动
		$HUI.combobox('#cboSSHosp',{
		    onSelect:function(rows){
			    var HospID=rows["OID"].split("!!")[0];
			    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","I",HospID);
		    }
	    });

		obj.DateFrom = Common_SetValue('DateFrom',Common_GetDate(new Date())); // 日期初始赋值
		obj.DateTo = Common_SetValue('DateTo',Common_GetDate(new Date()));
		obj.CheckQueryLoad();
	}
	obj.btnExport = function(id,objExport,TitleDesc){
		//PrintCPWToExcel()
		var rows = objExport.getRows().length; 
		
		if (rows>0) {
		   //ExportGridByCls(objExport,TitleDesc);
		   $('#'+id).datagrid('toExcel',TitleDesc+".xls");
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}
	}
	obj.CheckQueryLoad = function(){
    	obj.LocID=Common_GetValue('cboLoc');
    	if(tDHCMedMenuOper['admin']<1) obj.LocID=session['DHCMA.CTLOCID'].split("!!")[0];
    	
		/*obj.GridCheckQuery.load({
		   ClassName:"DHCMA.CPW.CPS.PathwaySrv",
			QueryName:"QryCPWByDate",	
			aDateType: Common_GetValue('cboDateType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: obj.Status,
			aLocID:obj.LocID,
			aWardID:"",
			aHospID:Common_GetValue('cboSSHosp')
	    });	*/
	     $cm ({
			 ClassName:"DHCMA.CPW.CPS.PathwaySrv",
			QueryName:"QryCPWByDate",	
			aDateType: Common_GetValue('cboDateType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: obj.Status,
			aLocID:obj.LocID,
			aWardID:"",
			aHospID:Common_GetValue('cboSSHosp'),
			page:1,
			rows:999
		},function(rs){
			$('#GridCheckQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
}