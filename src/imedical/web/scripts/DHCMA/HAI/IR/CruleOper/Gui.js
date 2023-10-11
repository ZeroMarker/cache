//页面Gui
function InitCRuleOperWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecRowID2= "";
	//手术列表
	obj.gridCRuleOper = $HUI.datagrid("#gridCRuleOper",{
		fit: true,
		title: "手术筛查列表",
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
		loadFilter:pagerFilter,
		columns:[[
			{field:'ID',title:'ID',width:70},
			{field:'Type',title:'类型',width:200,sortable:true,
				formatter: function(value,row,index){
					switch(value){
						case "1":
							return "全院";
							break;
						case "2":
							return "院区";
							break;
						case "3":
							return "科室";
							break;
						default:
							return "全院";
					}
				}
			},
			{field:'GrpDesc',title:'医院分组',width:300}, 
			{field:'HospDesc',title:'院区',width:200},
			{field:'LocDesc',title:'科室',width:200},
			{field:'IncDesc',title:'切口类型',width:200},
			{field:'Operation',title:'手术名称',width:200},
			{field:'IsActive',title:'是否有效',width:160,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleOper_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleOper_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//手术关键词
	obj.gridCRuleOperKeys = $HUI.datagrid("#gridCRuleOperKeys",{
		fit: true,
		title: "手术关键词",
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
			{field:'InWord',title:'包含词',width:200,sortable:true},
			{field:'ExWords',title:'排除词',width:200,sortable:true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleOperKeys_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCRuleOperKeys_onDbselect(rowData);
			}
		}
	});
	
	//科室
	obj.cboLocation = $HUI.combobox("#cboLocation", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'LocDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleOperSrv&QueryName=QryOperLocList&ResultSetType=array";
		   	$("#cboLocation").combobox('reload',url);
		}
	});
	//切口类型
	var TypeCode="CuteType";
	obj.cboOperInc = $HUI.combobox("#cboOperInc", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode;
		   	$("#cboOperInc").combobox('reload',url);
		}
	});
	
	InitCRuleOperWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}