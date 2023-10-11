//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.editIndex=undefined;
    $.parser.parse(); // 解析整个页面
	obj.gridCategory =$HUI.datagrid("#gridCategory",{
		fit: true,
		title: "重点患者分类",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    nowrap:false,
	    queryParams:{
		    ClassName:"DHCMA.IMP.BTS.IMPCategorySrv",
			QueryName:"QryIMPCategory"		
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'80'},
			{field:'CateCode',title:'重点患者分类代码',width:'150',sortable:true},
			{field:'CateDesc',title:'重点患者分类描述',width:'200',sortable:true},
			{field:'CateFlag',title:'重点患者分类标识',width:'200',sortable:true},
			{field:'BTIsActive',title:'是否<br>有效',width:'80',align:'center'},
			{field:'BTIsEnd',title:'是否<br>终结',width:'80',align:'center'},
			{field:'BTIsOper',title:'是否<br>操作',width:'80',align:'center'},
			{field:'BTIsManMark',title:'是否允许<br>手动标记',width:'80',align:'center'},
			{field:'BTIsReMark',title:'是否允许<br>重复标记',width:'80',align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCategory_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridCategory_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}