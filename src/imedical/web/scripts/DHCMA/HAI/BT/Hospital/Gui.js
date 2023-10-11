//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.XCode=""
	obj.gridHospital = $HUI.datagrid("#gridHospital",{
		fit: true,
		//title: "医院字典",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//idField:'ID',
		columns:[[
			{field:'ID',title:'ID',width:80,align:'center'},
			{field:'BTCode',title:'组织机构代码',width:160},
			{field:'BTDesc',title:'医院名称',width:220},
			{field:'BTDesc2',title:'医院别名',width:200},
			{field:'BTGroupDesc',title:'医院分组',width:200},
			{field:'BTIsActive',title:'是否有效',width:80,align:'center',
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'BTActDate',title:'日期',width:180,align:'center',
				formatter: function (value,row,index) {
					return value+ ' ' + row.BTActTime
				}
			},
			{field:'BTActUser',title:'操作人',width:200},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridHospital_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridHospital_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			obj.RecRowID="";
			$("#btnSyn").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
		}
	});
	//加载医院方法
	obj.Hospital = $HUI.combobox("#cboHospGroup", {
		url: $URL,
		editable: true,
		allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		blurValidValue:true,
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.HospGroupSrv';
			param.QueryName = 'QueryHospGroup';
			param.ResultSetType = 'array';
		}
	});
	
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}
$(InitWin);

