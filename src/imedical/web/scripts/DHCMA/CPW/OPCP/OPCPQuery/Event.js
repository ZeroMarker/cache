//页面Event
function InitCheckQueryWinEvent(obj){
	
	$('#winPathVisit').dialog({
		title: '路径就诊出入径明细',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false//true,
		/*
		buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPathVisit').close();
			}
		}]
		*/
	});	
		
	$('#winGridPathVisit').dialog({
		title: '',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winGridPathVisit').close();
			}
		}]
	});	
    
	obj.LoadEvent = function(args){
		//查询
		$('#btnQuery').on('click', function(){
			obj.CheckQueryLoad();
		});
		$('#btnExport').on('click', function(){
			obj.btnExport("GridCheckQuery",obj.GridCheckQuery,"门诊临床路径出入径查询表");
			
		});
		$('#btnExportVisit').on('click', function(){
			obj.btnQueryVisit();
		});
		$("#btnPrintPathway").on('click',function(){
			obj.btnPrintPathway();	
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
			    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","O",HospID);
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
	obj.btnQueryVisit = function(){
		
		obj.LocID=Common_GetValue('cboLoc');
    	if(tDHCMedMenuOper['admin']<1) obj.LocID=session['DHCMA.CTLOCID'].split("!!")[0];
	    $cm ({
			 ClassName:"DHCMA.CPW.OPCPS.PathwaySrv",
			QueryName:"QryOPCPWVisitByDate",
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
			$('#GridPathVisit').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
			obj.btnExport("GridPathVisit",obj.GridPathVisit,"门诊临床路径出入径明细查询表");
		});
	}
	obj.GetPathwayVisit = function(rowData){
		$cm ({
			  ClassName:"DHCMA.CPW.OPCPS.PathwaySrv",
			  QueryName:"QryOPCPWVisitByaPathWayID",
			  aPatientID:rowData['PatientID'],
			  aPathWayID:rowData['CPWID']
		},function(rs){
			$('#PathVisitByaEpisodeID').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			$HUI.dialog('#winPathVisit').open();
		});
		}
	obj.CheckQueryLoad = function(){
    	obj.LocID=Common_GetValue('cboLoc');
    	if(tDHCMedMenuOper['admin']<1) obj.LocID=session['DHCMA.CTLOCID'].split("!!")[0];
	    $cm ({
			 ClassName:"DHCMA.CPW.OPCPS.PathwaySrv",
			QueryName:"QryOPCPWByDate",	
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
    //打印表单 dsp
    obj.btnPrintPathway=function(){
	   var row =$("#GridCheckQuery").datagrid('getSelected');
	   if(row){
	   		var aEpisodeID = row['aEpisodeID'];
	   		//var pathwayID = row['CPWID'];
	   		//alert(aEpisodeID+"--"+pathwayID);
	    	//PrintCPWQueryToExcel("","","","",aEpisodeID);
	    var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintOPCPWInform");  //打印任务的名称
			var PrintUrl="./dhcma.cpw.opcp.oplodopprint.csp?EpisodeID="+aEpisodeID;
			LODOP.ADD_PRINT_URL("1cm","1cm","100%","100%",PrintUrl);
			LODOP.PRINT();
	   }else{
			$.messager.alert("确认", "请选择要打印表单的病人", 'info');   
		}
	 }
}