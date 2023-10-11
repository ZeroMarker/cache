//页面Gui
function InitCRuleDefWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecRowID2= "";
	
	obj.gridCRuleDef = $HUI.datagrid("#gridCRuleDef",{
		fit: true,
		title: "感染诊断标准配置",
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
			{field:'InfPosCode',title:'感染诊断代码',width:200,sortable:true},
			{field:'InfPosDesc',title:'感染诊断描述',width:300}, 
			{field:'Title',title:'标准定义',width:200},
			{field:'Note',title:'标准解读',width:200},
			{field:'IndNo',title:'排序码',width:200},
			{field:'IsActive',title:'是否有效',width:160,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'MaxAge',title:'年龄大于',width:200},
			{field:'MinAge',title:'年龄小于',width:200}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleDef_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleDef_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridCRuleDefExtLoad("");
		}
	});
	
	obj.gridCRuleDefExt = $HUI.datagrid("#gridCRuleDefExt",{
		fit: true,
		title: "感染诊断标准",
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
			{field:'Title',title:'标准定义',width:120,sortable:true},
			{field:'Note',title:'标准解读',width:120,sortable:true},
			{field:'TypeDesc',title:'诊断类型',width:120,sortable:true},
			{field:'IndNo',title:'排序码',width:100,sortable:true},
			{field:'IsActive',title:'是否有效',width:80,
				formatter: function(value,row,index){
						return (value == '1' ? '是' : '否');
				}
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			var rowData = obj.gridCRuleDef.getSelected();
			if (rowData) {
				$("#btnAdd_one").linkbutton("enable");
				$("#btnEdit_one").linkbutton("disable");
				$("#btnDelete_one").linkbutton("disable");
			}else {
				$("#btnAdd_one").linkbutton("disable");
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleDefExt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleDefExt_onDbselect(rowData);
			}
		}
	});
	
	//感染诊断描述
	/*obj.cboInfPos = $HUI.combobox("#cboInfPos", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array";
		   	$("#cboInfPos").combobox('reload',url);
		}
	});*/
	$HUI.combobox('#cboInfPos',
	    {
			url:$URL+'?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=Array',
			valueField:'ID',
			textField:'Desc',
			panelHeight:300,
			editable:true   		    
	    })
	
	//诊断类型
	var TypeCode="DiagType";
	/*obj.cboDiagType = $HUI.combobox("#cboDiagType", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode;
		   	$("#cboDiagType").combobox('reload',url);
		}
	});*/
	$HUI.combobox('#cboDiagType',
	    {
			url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode='+TypeCode,
			valueField:'ID',
			textField:'DicDesc',
			panelHeight:300,
			editable:true   		    
	    })
	
	InitCRuleDefWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}