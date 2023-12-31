$(function() {
	function initUI() {
		initSearchForm();
		initGrid();
		InitStatus1();
		InitStatus2();
	}

	function search() {
		initGrid();
	}
	
	function print() {
		var LODOP = getLodop();
		$m({
			ClassName:'Nur.Report.Service.SpecimenTransport',
			MethodName:'getCTLoc',
			LocID:session['LOGON.CTLOCID']
		},function(locDesc){
			$m({
				ClassName:'Nur.Report.Service.SpecimenTransport',
				MethodName:'GetLabCarry',	
				StrDate: $HUI.datebox('#startDate').getValue(),
				EndDate: $HUI.datebox('#endDate').getValue(),
				LocDr: session['LOGON.CTLOCID'],
				InStatus:$("#status1").combobox('getValues')+"",
				InTranStatus:$("#status2").combobox('getValues')+""
			},function(tableStr){
				LODOP.PRINT_INIT("科室标本运送统计打印");
		        LODOP.SET_PRINT_PAGESIZE(0, 0, 0, "A4");
		        //LODOP.ADD_PRINT_TABLE("2%", "1%", "96%", "98%", tableStr);

		        LODOP.ADD_PRINT_TABLE("30mm", "10mm", "185mm", "230mm", tableStr);
		        LODOP.ADD_PRINT_TEXT("10mm", 277, 200, 32, locDesc+"\n标本接收登记本\n");
		        LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
		        LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		        LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
		        LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
		        //LODOP.SET_PREVIEW_WINDOW(0, 0, 0, 800, 600, "");
		        // LODOP. SET_SHOW_MODE("PREVIEW_IN_BROWSE",true);
		        // LODOP. SET_SHOW_MODE("PREVIEW_NO_MINIMIZE",true);
		        // LODOP.PRINT_DESIGN();
		        // LODOP.PRINT();
		        LODOP.PREVIEW();
			})
		});
	}

	function initSearchForm() {
		//初始化日期时间
		$('#startDate').datebox('setValue', dateCalculate(now, 0));
		$('#endDate').datebox('setValue', dateCalculate(now, 0));
		$('#queryBtn').click(search);
		$('#Print').click(print);
		
	}


	function initGrid() {
		
		$cm({
			ClassName: "Nur.Report.Service.SpecimenTransport",
			MethodName: "getTableColumnOfHISUI",
			StrDate: $HUI.datebox('#startDate').getValue(),
			EndDate: $HUI.datebox('#endDate').getValue()
		}, function(columns) {
			console.log(columns);
				
			/*
			columns.forEach(function(column) {
					column.width=200;
			});
			*/
			//debugger;
			
			$('#LabStatReport').datagrid({
				url: $URL,
				fitColumns: false,
				headerCls: 'panel-header-gray',
				columns: [columns],
				queryParams: {
					ClassName: "Nur.Report.Service.SpecimenTransport",
					MethodName: "FindLabCarry",
					StrDate: $HUI.datebox('#startDate').getValue(),
					EndDate: $HUI.datebox('#endDate').getValue(),
					LocDr: session['LOGON.CTLOCID'],
					Print:"false",
					InStatus:$("#status1").combobox('getValues')+"",
					InTranStatus:$("#status2").combobox('getValues')+""
				},
			});
			
			/*
			//初始化汇总表格
			$HUI.datagrid('#LabStatReport', {
				autoSizeColumn: false,
				fit: true,
				url: $NURURL + '?className=Nur.Report.Service.SpecimenTransport&methodName=FindLabCarry',
				fitColumns: false,
				headerCls: 'panel-header-gray',
				columns: [columns],
				singleSelect: true,
				
				onBeforeLoad: function(param) {
					param.parameter1 = $HUI.datebox('#startDate').getValue();
					param.parameter2 = $HUI.datebox('#endDate').getValue();
					param.parameter3 = session['LOGON.CTLOCID'];
				},
			});
			*/
			
		});
	}
	
	initUI();
	
// 导出 excel
 $("#Export").click(function(){
 	// 借助插件-datagrid-export.js 实现导出excel功能
 	var param = {}
 	param['filename']='科室标本运送统计.xls'
 	param['worksheet']= getLocDesc();
 	$('#LabStatReport').datagrid('toExcel',param)
 });
 
 function InitStatus1(){
	// 运单状态
	$("#status1").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		editable:false,
		rowStyle:'checkbox', //显示成勾选行形式
        value:['S','R','P'],
        // 运单状态："C":"建单","S":"已交接","D":"作废","R":"全部接收","P":"部分处理"
		data:[{"id":"C","text":$g("建单")},{"id":"S","text":$g("已交接")},
			  {"id":"R","text":$g("全部处理")}, //{"id":"D","text":"作废"},
			  {"id":"P","text":$g("部分处理")}],
		onSelect:function(rec){
		},
		onChange:function(arg){
            initGrid();
        }
	});
   }
   
   function InitStatus2(){
	// 接收状态
	$("#status2").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		editable:false,
		rowStyle:'checkbox', //显示成勾选行形式
        value:['R'],
        // 接收状态："":"未接","R":"接收","F":"拒绝"
		data:[{"id":"999","text":$g("未接")},
			  {"id":"R","text":$g("接收")},
			  {"id":"F","text":$g("拒绝")}],
		onSelect:function(rec){
		},
		onChange:function(arg){
            initGrid();
        }
	});
   }
   
   function getLocDesc()
   {
		var desc = $m({
			ClassName:'Nur.Report.Service.SpecimenTransport',
			MethodName:'getCTLoc',
			LocID:session['LOGON.CTLOCID']
		},false);
		return desc;
   }
   
})


