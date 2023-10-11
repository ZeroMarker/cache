//页面Gui
var aflg=""
function InitOEAntiMastMapWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.layer_rd=""	
    
    obj.gridOEAntiMastMap = $HUI.datagrid("#gridOEAntiMastMap",{
		fit: true,
		title: "抗菌药物对照",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,    //是否是服务器对数据排序
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:60,sortable:true,sorter:Sort_int},
			{field:'BTAnitDesc',title:'医嘱名称',width:400},
			{field:'PHChemical',title:'品种通用名',width:260},
			{field:'BTMapItemDesc',title:'标准名称',width:300},
			{field:'BTMapNote',title:'备注',width:100},
			{field:'HospGroup',title:'医院',width:250},
			{field:'BTIsActive',title:'是否<br>有效',width:60,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOEAntiMastMap_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEAntiMastMap_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.gridOEAntiMast = $HUI.datagrid("#gridOEAntiMast",{
		fit: true,
		title: "抗菌药物字典",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true,//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		columns:[[
			{field:'BTCode',title:'代码',width:100},
			{field:'BTName',title:'名称',width:350},
			{field:'BTIsActive',title:'是否有效',width:100,
				formatter: function(value,row,index){
						return (value == '1' ? '是' : '否');
				}
			}
		]],
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridOEAntiMast').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			}
	});
	
	InitOEAntiMastMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}