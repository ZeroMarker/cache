//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridPlanManage = $HUI.datagrid("#gridPlanManage",{
		fit: true,
		//title: "SOP预案维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:false,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	   queryParams:{                
		    ClassName:"DHCHAI.IRS.PlanManageSrv",
			QueryName:"QryPlanManage"
	    },
		columns:[[
			{field:'PlanTypeDesc',title:'类型',width:200},
			{field:'IRPlanName',title:'预案名',width:200},
			{field:'IRKeys',title:'关键词',width:340},
			{field:'IRContent',title:'内容',width:520,
				formatter: function (value) {
					return value.replace(/&hc/g,""); //"<br>")
				}},
			{field:'IRIsActive',title:'是否有效',width:100,align:'center',
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPlanManage_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPlanManage_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	Common_ComboDicID("cboPlanType","PlanType",1)
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

$(function () {
	InitWin();
});
