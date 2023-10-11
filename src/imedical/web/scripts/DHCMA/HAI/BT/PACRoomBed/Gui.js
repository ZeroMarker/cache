//页面Gui
var obj = new Object();
function InitPACRoomBedWin(){
	obj.RecRowID = "";
	obj.RecRowID2 = "";
	obj.RecRowID3 ="";
	obj.RoomType="";
	obj.RoomRowData="";
	obj.BedRowData="";
	$("#btnAdd_two").linkbutton("disable");
	$("#btnEdit_two").linkbutton("disable");
	$("#btnDelete_two").linkbutton("disable");
	
	//病区列表
	obj.gridPACWard = $HUI.datagrid("#gridPACWard",{
		fit: true,
		title: "病区列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'LocDesc',title:'病区',width:300},
			{field:'IsMainWard',title:'是否维护',width:80,
				formatter: function ( value,row,index ) {
					return (row['IsMainWard'] == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPACWard_onSelect();
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnBuildWard").linkbutton("disable");
		}
	});
	
	//房间列表
	obj.gridRoom  = $HUI.datagrid("#gridRoom",{
		fit: true,
		title: "房间列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:true,
		columns:[[
			{field:'ID',title:'ID',width:'50'},
			{field:'RoomDesc',title:'房间名称',width:70},
			{field:'SubNo',title:'分区号',width:70},
			{field:'LeftBedCnt',title:'左床位数',width:70},
			{field:'RightBedCnt',title:'右床位数',width:70},
			{field:'ContBedCnt',title:'关联床位',width:70}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridRoom_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridRoom_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); 
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			if(obj.RecRowID!=""){	
				$("#btnAdd_two").linkbutton("enable");
			}
			if(obj.RecRowID2==""){	
				$("#btnEdit_two").linkbutton("disable");
				$("#btnDelete_two").linkbutton("disable");
			}
		}
	});
	//床位列表
	obj.gridBed = $HUI.datagrid("#gridBed",{
		fit: true,
		title: "床位列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,
		columns:[[		
			{field:'ID',title:'ID',width:50},
			{field:'BedDesc',title:'床位',width:70},
			{field:'IndNo',title:'排序码',width:70},
			{field:'null',title:'操作',width:170,
				formatter: function (value,row,index) {	
						if(row.IsRoomFlag == '1') {
							return '<a href="#" onclick=obj.editor_canceledit('+row['ID']+')><span class="icon-cancel-ref" data-options="plain:true">&nbsp;&nbsp;&nbsp;&nbsp;</span> 取消关联 </a>';
						}else if(row.IsRoomBed == '0') {
							return '<a href="#" onclick=obj.editor_edit('+row['ID']+','+row['IsRoomBed']+ ')><span class="icon-ref" data-options="plain:true" >&nbsp;&nbsp;&nbsp;&nbsp;</span> 关联 </a>';
						}else{
							return '';
						}
				}},
			{field:'IsActive',title:'是否有效',width:'70',
				formatter: function ( value,row,index ) {
					return (row['IsActive'] == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridBed_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridBed_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			if(obj.RecRowID!=""){	
				$("#btnEdit_three").linkbutton("disable");
			}
		}
	});
	
	//房间类型下拉框
	obj.cbokind = $HUI.combobox('#RoomType', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = 'RoomType';
			param.aActive = '1';
			param.ResultSetType = 'array'
		}
	});

	InitPACRoomBedWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}