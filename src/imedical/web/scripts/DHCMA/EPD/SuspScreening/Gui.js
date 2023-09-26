//页面Gui
function InitSuspScreeningWin(){
	var obj = new Object();
    obj.RecRowID = '';	
    $.parser.parse(); // 解析整个页面  
   
   obj.gridScreening = $HUI.treegrid("#SuspScreening",{
		fit: true,
		title:'传染病疑似筛查条件维护',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		idField:'RowId',           //关键字段来标识树节点，不能重复  
		treeField:'RowDesc', //树节点字段，也就是树节点的名称
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCMed.EPDService.SuspScreeningSrv',
			QueryName:'QryScreenInfo'
	    },
		columns:[[
			{field:'RowDesc',title:'筛查条件',width:400},
			{field:'TypeDesc',title:'筛查类型',width:80},
			{field:'IncludeKey',title:'诊断关键词',width:100,
				formatter: function(value,row,index){
					if (!row.ExcludeKeys) {
						return row.IncludeKey;
					}else {
						return row.IncludeKey+" [排除:"+row.ExcludeKeys+"]";
					}
				}
			}, 
			{field:'LisItems',title:'检验项目',width:400,
				formatter: function(value,row,index){
					if (!row.LisLogic) {
						return row.LisItems;
					}else {
						return row.LisItems+" ["+row.LisLogic+"]";
					}
				}
			},
			{field:'IsActDesc',title:'有效标志',width:80},
			{field:'Note',title:'条件说明',width:350},
			{field:'ActDate',title:'更新日期',width:100},
			{field:'ActTime',title:'更新时间',width:80},
			{field:'ActUser',title:'更新用户',width:120}
		]],
		onSelect:function(rindex,rowData){
			if (!rowData._parentId) {
				obj.RecRowID="";
				$("#btnAdd").linkbutton("enable");
				$("#btnEdit").linkbutton("disable");
				$("#btnDelete").linkbutton("disable");
				obj.gridScreening.clearSelections();  //清除选中行
				return;
			}
			if (rindex>-1) {
				obj.gridScreening_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if (!rowData._parentId) return;
			if (rowIndex>-1) {
				obj.gridScreening_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//传染病类别
	$('#cboType').combobox({      
		valueField:'Code',    
		textField:'Desc',  //K,I,L,R
		data : [ {
			Code:'K', 
			Desc:'关键词',
			"selected":true   
		},{
			Code:'I', 
			Desc:'ICD编码'
		},{
			Code:'L', 
			Desc:'检验'
		},{
			Code:'R', 
			Desc:'检查'
		}]
	});  
	
	//传染病疑似诊断
	obj.cboInfect = $HUI.combobox('#cboInfect', {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.EPDService.SuspInfectDicSrv';
			param.QueryName = 'QryInfectDic';
			param.ResultSetType = 'array';
			param.aIsActive = 1;
		}
	});
    
	//检验项目
	obj.cbgLisItems = $HUI.combogrid('#cbgLisItems', {
		panelWidth: 450,
		editable: true,
	    pagination: true,
		//blurValidValue: true, //为true时，光标离开时，检查是否选中值,没选中则置空输入框的值
		fitColumns: true,     //真正的自动展开/收缩列的大小，以适应网格的宽度，防止水平滚动条
		mode:'remote',        //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		idField: 'ID',
		textField: 'BTDesc',
		multiple: true,
		url: $URL,
		queryParams:{ClassName: 'DHCMed.EPDService.SuspTestCodeSrv',QueryName: 'QryTestCode'},
		columns: [[
			{field:'ck',checkbox:true},
			{field:'ID',title:'ID',width:80},
			{field:'BTCode',title:'项目代码',width:80},
			{field:'BTDesc',title:'项目名称',width:150}
		]]
	});
	
	InitSuspScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


