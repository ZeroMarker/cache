//页面Gui
function InitLabInfTestSetWin(obj){
	var obj = new Object();
	obj.RecRowID = "";
	obj.RecRowID_two = ""; 
	
	obj.gridLabInfTestSet = $HUI.datagrid("#gridLabInfTestSet",{
		fit: true,
		title: "检验医嘱定义",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
	    url:$URL,
	   queryParams:{  
			ClassName : "DHCHAI.DPS.LabInfTestSetSrv",
			QueryName : "QryByType",
			aType: ""
	    },		
		columns:[[
			{field:'ID',title:'ID',width:60},
			{field:'Code',title:'代码',width:100},
			{field:'LabType',title:'业务类型',width:120},
			{field:'Desc',title:'名称',width:150},
			{field:'IsActive',title:'有效标志',width:60,
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabInfTestSet_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabInfTestSet_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	obj.gridLabInfTestSetExt = $HUI.datagrid("#gridLabInfTestSetExt",{
		fit: true,
		title: "检验医嘱外部码维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:false,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
	    url:$URL,
	   queryParams:{  
			ClassName : "DHCHAI.DPS.LabInfTestSetSrv",
			QueryName : "QryTestSetExt",
			aTestSetID: obj.RecRowID
	    },  
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'ExtCode',title:'外部码',width:200},
			{field:'ActDate',title:'更新日期',width:100},
			{field:'ActTime',title:'更新时间',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabInfTestSetExt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabInfTestSetExt_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			if (obj.RecRowID == ""){
				$("#btnAdd_two").linkbutton("disable");
			}else{
				$("#btnAdd_two").linkbutton("enable");
			}
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			
		}
	});
	
	//业务类型
	$HUI.combobox("#cboType",{
		data:[{Id:'1',text:'环境卫生学'},{Id:'2',text:'职业暴露'}],
		valueField:'Id',
		textField:'text'
	});
	
	InitLabInfTestSetWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;	
}
$(InitLabInfTestSetWin);