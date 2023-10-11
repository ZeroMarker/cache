//页面Gui
var aflg=""
function InitOEItmMastMapWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.layer_rd=""	
    obj.gridOEItmMastMap = $HUI.datagrid("#gridOEItmMastMap",{
		fit: true,
		title: "医嘱项对照维护",
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
			{field:'BTOrdDesc',title:'医嘱名称',width:300},
			{field:'OrdCatDesc',title:'医嘱分类',width:160}, 
			{field:'BTMapItemDesc',title:'标准名称',width:150},
			{field:'IADesc',title:'督查表类型',width:100},
			{field:'IATypeDesc',title:'插管类别',width:100},
			{field:'HospGroup',title:'医院',width:100},
			{field:'BTIsActive',title:'是否<br>有效',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			},
			{field:'BTMapNote',title:'备注',width:80}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOEItmMastMap_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEItmMastMap_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.gridOEItmMast = $HUI.datagrid("#gridOEItmMast",{
		fit: true,
		title: "医嘱项字典",
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
			{field:'BTDesc',title:'名称',width:250},
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
				$('#gridOEItmMast').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		}
	});
	//ADD(2022-12) 新增'三管感染防控督查表'自动匹配规则
	$HUI.combobox("#cboIADr",{
		data:[
			{value:'1',text:'血管导管'},
			{value:'2',text:'呼吸机'},
			{value:'3',text:'导尿管'},
		],
		valueField:'value',
		textField:'text'
	})
	obj.cboIATypeDr = $HUI.combobox('#cboIATypeDr', {              
		url:$URL,
		editable: false,
		mode: 'remote',
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.IRS.ICUIExASrv';
			param.QueryName = 'QryTubeTypeList';
			param.ResultSetType = 'array'
		}
	});
	
	InitOEItmMastMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}