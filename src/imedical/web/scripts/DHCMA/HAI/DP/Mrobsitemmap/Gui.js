//页面Gui
function InitMROBSItemMapWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.layer_rd=""	
    
    obj.gridMROBSItemMap = $HUI.datagrid("#gridMROBSItemMap",{
		fit: true,
		title: "护理项目对照维护",
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
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:70,sortable:true,sorter:Sort_int},
			{field:'BTItemDesc',title:'护理项目名称',width:280,sortable:true},
			{field:'MapItemDesc',title:'标准项目名称',width:280}, 
			{field:'MapNote',title:'备注',width:200},
			{field:'HospGroup',title:'医院',width:280},
			{field:'BTIsActive',title:'是否有效',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMROBSItemMap_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMROBSItemMap_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.gridMROBSItem = $HUI.datagrid("#gridMROBSItem",{
		fit: true,
		title: "护理项目",
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
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.DPS.MROBSItemSrv",
			QueryName:"QryMROBSItem"
		},
		columns:[[
			{field:'BTItemCode',title:'代码',width:20},
			{field:'BTItemDesc',title:'名称',width:40,sortable:true},
			{field:'BTIsActive',title:'是否有效',width:20,
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
				$('#gridMROBSItem').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			}
	});
	
	InitMROBSItemMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}