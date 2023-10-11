// 页面Gui
function InitCRuleRBAbWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecRowID2= "";
	
	obj.gridCRuleRBAb = $HUI.datagrid("#gridCRuleRBAb",{
		fit: true,
		title: "放射筛查规则",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:70},
			{field:'RBCode',title:'检查项目',width:200,sortable:true},
			{field:'RBPos',title:'检查部位',width:300}, 
			{field:'RBNote',title:'说明',width:200},
			{field:'RBCFlag',title:'筛查标志',width:160,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleRBAb_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleRBAb_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			$("#btnAdd_one").linkbutton("disable");
			$('#gridCRuleRBCode').datagrid('loadData',{total:0,rows:[]});
		}
	});
	
	obj.gridCRuleRBCode = $HUI.datagrid("#gridCRuleRBCode",{
		fit: true,
		title: "检查项目",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'RBCodeDesc',title:'检查项目',width:200},
			{field:'ActDate',title:'更新日期',width:200,sortable:true,
				formatter: function(value,row,index){
						return value + ' ' + row["ActTime"];
					}
			},
			{field:'ActUser',title:'更新人',width:150,sortable:true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleRBCode_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleRBCode_onDbselect(rowData);
			}
		}
	});
	//感染诊断描述
	$HUI.combobox('#cboRBCodeDr',
	    {
			url:$URL+'?ClassName=DHCHAI.DPS.RBItmMastMapSrv&QueryName=QryRBItmMastMapByInit&ResultSetType=Array',
			valueField:'ID',
			textField:'BTMRCHKItem',
			panelHeight:300,
			editable:true   		    
	    })
	/*obj.cboRBCodeDr = $HUI.combobox("#cboRBCodeDr", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTMRCHKItem',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.RBItmMastMapSrv&QueryName=QryRBItmMastMapByInit&ResultSetType=array";
		   	$("#cboRBCodeDr").combobox('reload',url);
		}
	});*/
	
	InitCRuleRBAbWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}