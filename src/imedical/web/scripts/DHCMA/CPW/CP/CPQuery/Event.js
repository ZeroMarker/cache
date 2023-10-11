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
		$('#btnPrint').on('click', function(){
			obj.btnPrint();
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
		    onChange:function(n,o){
			    if (o!="") $("#cboLoc").combobox('clear');		//首次加载不清除赋值
				$("#cboLoc").combobox('reload');  
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
		   grid2excel($('#'+id), {IE11IsLowIE: false,filename:TitleDesc,allPage: true});
		   //$('#'+id).datagrid('toExcel',TitleDesc+".xls");
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}
	}
	obj.CheckQueryLoad = function(){
		$('#GridCheckQuery').datagrid('loadData',[]);
		$("#loading").show();
		LocID=""
		WardID=""
		if ($("#cboLoc").combobox('getValue')!=""){
			var flag=$m({
				ClassName: "DHCMA.Util.EPS.LocationSrv",
				MethodName: "GetTypeByOID",
				aId: $("#cboLoc").combobox('getValue')
			}, false)
			if (flag=="W"){
				WardID=$("#cboLoc").combobox('getValue')
			}else{
				obj.LocID=Common_GetValue('cboLoc');
				LocID=$("#cboLoc").combobox('getValue')
			}
		}
	     $cm ({
			ClassName:"DHCMA.CPW.CPS.PathwaySrv",
			QueryName:"QryCPWByDate",	
			aDateType: Common_GetValue('cboDateType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: obj.Status,
			aLocID:LocID,
			aWardID:WardID,
			aHospID:$("#cboSSHosp").combobox('getValue'),
			aRegNo:$("#txtRegNo").val(),
			aMrNo:$("#txtMRNo").val(),
			page:1,
			rows:99999
		},function(rs){
			$("#loading").hide();
			$('#GridCheckQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	obj.GridCheckQuery_onDblClick = function(rowIndex,rowData){
	    var EpisodeID=rowData['aEpisodeID'];
	    var FormUrl="./dhcma.cpw.cp.form.csp?EpisodeID="+EpisodeID+"&UserType=MED";
		websys_showModal({
			url:FormUrl,
			title:'表单总览',
			iconCls:'icon-w-import',  
			closable:true,
			originWindow:window,
			width:screen.availWidth-200,
			height:screen.availHeight-200
		});	
    }
    obj.btnPrint = function(){
    	var row = obj.GridCheckQuery.getSelected();
    	if(!row) {
	    	$.messager.popover({msg: '请先选择一条数据！',type:'error',timeout: 1000})
	    	return;	
	    }
	    
    	var EpisodeID=row['aEpisodeID'];		
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCPWInform2");  //打印任务的名称
		LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//每页都输出
		//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
		//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
		LodopPrintURL(LODOP,"./dhcma.cpw.cp.lodopprint.csp?EpisodeID="+EpisodeID,"10mm","12mm","6mm","20mm")
		LODOP.PRINT();
    }
}