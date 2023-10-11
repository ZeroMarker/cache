//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridSystemMap = $HUI.datagrid("#gridSystemMap",{
		fit: true,
		//title: "系统代码定义",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
	    url:$URL,
	   queryParams:{                
		    ClassName:"DHCHAI.BTS.SystemMapSrv",
			QueryName:"QrySystemMapInfo"
	    },
		columns:[[
			{field:'ID',title:'ID',width:40},
			{field:'Code',title:'系统代码',width:100},
			{field:'Desc',title:'系统名称',width:160},
			{field:'HISCode',title:'HIS关联码',width:100},
			{field:'SysDesc',title:'系统分类',width:140},
			{field:'HospDesc',title:'医院',width:200},
			
			{field:'IsActive',title:'是否有效',width:60,align:'center',
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'ActDate',title:'处置日期',width:160,
				formatter: function (value,row, index) {
					return value + ' ' + row["ActTime"];
				}
			},
			{field:'ActUserDesc',title:'处置人员',width:'160'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSystemMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSystemMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	Common_ComboDicID("cboType","SubSysType",1)
	//加载医院方法
	obj.cboHosp = $HUI.combobox("#cboHosp", {
		url: $URL,
		editable: true,
		allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.HospitalSrv';
			param.QueryName = 'QryHospitalToSelect';
			param.ResultSetType = 'array';
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

$(function () {
	InitWin();
	//$.parse.parse();
});
