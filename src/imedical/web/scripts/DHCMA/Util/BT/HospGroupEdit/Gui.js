//页面Gui
function InitHISUIWin(){
	var obj = new Object(); //初始化赋值
	 $.parser.parse(); // 解析整个页面 	
	//$.fn.pagination.defaults.showPageList=false;
	obj.dictList = $HUI.datagrid("#dictList",{
		fit: true,
		title:"医院分组列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.Util.BTS.HospGroupSrv",
			QueryName:"QryHospGrpInfo"
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'Code',title:'医院分组代码',sortable:true,width:200},
			{field:'Desc',title:'医院分组名称',sortable:true,width:400},
			{field:'IsActive',title:'是否有效',sortable:false,width:100,formatter:function(v,r,i){
				if(v=='1') return '是';
				else return '否';
			}}
		]],
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.dictList_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridProduct_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#addIcon").linkbutton("enable");
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
		}
	});	
/* 	obj.btnEdit=$HUI.linkbutton("#editIcon",{
		iconCls:'icon-save',
		plain:true,
		text:'编辑'
	});
	obj.btnDel=$HUI.linkbutton("#delIcon",{
		iconCls:'icon-close',
		plain:true,
		text:'删除'
	});
	obj.btnAdd=$HUI.linkbutton("#addIcon",{
		iconCls:'icon-add',
		plain:true,
		text:'添加'
	}); */
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
