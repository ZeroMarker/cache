//页面Gui
function InitMdlRoleListWin(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";	
    $.parser.parse(); // 解析整个页面 
	
	//所属产品加载-查询
	obj.cboProduct = $HUI.combobox('#cboProduct', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ProID',
		textField: 'ProDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.ProductSrv';
			param.QueryName = 'QryProduct';
			param.aActive = "1";
			param.ResultSetType = 'array'
		},
		onSelect:function(record){
				obj.ProCode=record["ProCode"]
				var param=$("#gridMdlDef").datagrid("options").queryParams;
				param.aProCode=obj.ProCode;
				$("#gridMdlDef").datagrid("reload");
		},
		onChange:function(newdata,olddata){
			if(!newdata){
			obj.ProCode=""
			var param=$("#gridMdlDef").datagrid("options").queryParams;
				param.aProCode=obj.ProCode;
				$("#gridMdlDef").datagrid("reload");
			}
		}
	});
	obj.gridMdlDef = $HUI.datagrid("#gridMdlDef",{
		fit: true,
		title: "产品模块定义-产品模块列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.BTS.MdlDefSrv",
			QueryName:"QryMdlDef",
			aProCode:obj.ProCode
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'60'},
			{field:'BTCode',title:'代码',width:'160'},
			{field:'BTDesc',title:'名称',width:'220'}, 
			{field:'BTTypeDesc',title:'产品线',width:'160'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMdlDef_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMdlDef_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			//$('#gridMdlDef').datagrid('clearSelections');
			
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	

	obj.gridMdlRole = $HUI.datagrid("#gridMdlRole",{
		fit: true,
		title: "产品模块定义-角色列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.BTS.MdlRoleSrv",
			QueryName:"QryMdlRole",
			aParRef:obj.RecRowID1
		},
		columns:[[
			{field:'SubID',title:'ID',width:'80'},
			{field:'BTCode',title:'代码',width:'150'},
			{field:'BTDesc',title:'名称',width:'220'}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMdlRole_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMdlRole_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			//$('#gridMdlRole').datagrid('clearSelections');
			 if($("#btnAdd").hasClass("l-btn-disabled")){
				$("#btnSubAdd").linkbutton("enable");
			}else{
				$("#btnSubAdd").linkbutton("disable");
			}
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	
		//所属产品加载-保存
	obj.cboTypeDr = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ProID',
		textField: 'ProDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.ProductSrv';
			param.QueryName = 'QryProduct';
			param.ResultSetType = 'array'
		}
	});
	InitMdlRoleListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


