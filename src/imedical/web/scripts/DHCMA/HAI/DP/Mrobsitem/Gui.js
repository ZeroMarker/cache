//页面Gui
function InitMROBSItemWin(){
	var obj = new Object();
	obj.RecRowID = "";
   
    obj.gridMROBSItem = $HUI.datagrid("#gridMROBSItem",{
		fit: true,
		title: "",
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
			{field:'ID',title:'ID',width:70},
			{field:'BTItemCode',title:'代码',width:280,sortable:true},
			{field:'BTItemDesc',title:'名称',width:280}, 
			{field:'BTCatDesc',title:'分类',width:280}, 
			{field:'BTIsActive',title:'是否有效',width:70,
				formatter: function(value,row,index){
						return (value == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMROBSItem_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMROBSItem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//护理分类
	obj.cboBTCatDr = $HUI.combobox("#cboBTCatDr", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.MROBSItemCatSrv&QueryName=QryMROBSItemCat&ResultSetType=array";
		   	$("#cboBTCatDr").combobox('reload',url);
		}
	});
	
	InitMROBSItemWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}