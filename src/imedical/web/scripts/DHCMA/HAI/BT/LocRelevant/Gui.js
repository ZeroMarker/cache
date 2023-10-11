//页面Gui
var obj = new Object();
function InitLocRelevWin(){
	obj.ClickLocID="";
	obj.RecRowID="";
	obj.relevCount=0;
	
	obj.gridLocRelev = $HUI.datagrid("#gridLocRelev",{
		fit: true,
		title: "科室相关性维护",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns:true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'Name',title:'名称',width:240,sortable:true},
			{field:'LocDescList',title:'科室列表',width:240}, 
			{field:'IsActive',title:'是否有效',width:150,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'ActUser',title:'操作人',width:240},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLocRelev_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLocRelev_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//检查项目
	obj.gridLoc = $HUI.datagrid("#gridLoc",{
		fit: true,
		title: "检查项目",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'LocCode',title:'代码',width:150},
			{field:'LocDesc2',title:'名称',width:150,sortable:true},
			{field:'null',title:'操作',width:150,
				formatter: function(value,row,index){
					if(row.IsRelev=='1'){
						obj.relevCount+=1;
						return '<a href="#"><span class="icon-cancel-ref" data-options="plain:true" onclick=obj.Relev_Click('+row['ID']+','+row['IsRelev']+ ')>&nbsp;&nbsp;&nbsp;&nbsp;</span> 取消关联 </a>';
					}else if(row.IsRelev=='0'){
						return '<a href="#"><span class="icon-ref" data-options="plain:true" onclick=obj.Relev_Click('+row['ID']+','+row['IsRelev']+ ')>&nbsp;&nbsp;&nbsp;&nbsp;</span> 关联 </a>';
					}else{
						return '';
					}
				}
			}
		]],
		onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				obj.gridLoc_onSelect();
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	//工作组类型
 	var CatList = $cm ({
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		aTypeCode:"LocRelevant",
		aActive:"1"
	},false);
	obj.CatData = CatList.rows;
	obj.cboCat = $HUI.combobox("#cboCat", {
		editable: false,     
		valueField: 'ID',
		textField: 'DicDesc',
		selected:true,
		data:obj.CatData,
		onLoadSuccess:function(data){
			$('#cboCat').combobox('select',data[0].ID);
		}
	});
	
	InitLocRelevWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}