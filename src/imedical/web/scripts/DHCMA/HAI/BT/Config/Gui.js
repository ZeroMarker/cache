//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//初始化模块
	obj.cboModList = $HUI.combobox("#cboModList", {
    	url: $URL,
     	editable: true,
       	allowNull: true,
      	defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
      	valueField: 'DicDesc',
       	textField: 'DicDesc',
      	onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
       		param.ClassName = 'DHCHAI.BTS.DictionarySrv';
       		param.QueryName = 'QryDic';
       		param.aTypeCode="ConfigMod";
       		param.aActive="1";
       		param.ResultSetType = 'array';
       	},
   		onSelect: function () {
      		obj.gridConfigLoad();  //刷新表格
     	},
       	onUnselect: function () {
     		obj.gridConfigLoad();  //刷新表格
        },
        onChange:function(newval,oldval){
            if (newval.length==0){
               obj.gridConfigLoad();  //刷新表格 
            }
     	}
  	});
	obj.cboAddMod = $HUI.combobox("#cboAddMod", {
     	url: $URL,
        editable: true,
        allowNull: true,
        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
        valueField: 'DicDesc',
        textField: 'DicDesc',
        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
           	param.ClassName = 'DHCHAI.BTS.DictionarySrv';
       		param.QueryName = 'QryDic';
       		param.aTypeCode="ConfigMod";
       		param.aActive="1";
        	param.ResultSetType = 'array';
      	}
    });
	//加载系统参数
	obj.gridConfig = $HUI.datagrid("#gridConfig",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:false,
		fitColumns: true,
		loadMsg:'数据加载中...',
		//分组
		showGroup: true,
		checkOnSelect:false,
		groupField:'Mod',
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return value;
		},
		columns:[[
			{field:'BTCode',title:'代码',width:200},
			{field:'BTDesc',title:'描述',width:350},
			{field:'Value',title:'配置值',width:250},
			{field:'Resume',title:'备注',width:350},
			{field:'HospDesc',title:'医院',width:150},
			{field:'IsActive',title:'是否有效',width:120,align:'center',
				formatter: function (value) {
					return (value=="1"?'<a href="#" style="color:green" >是</a>':'<a href="#" style="color:red" >否</a>')
				}
			},
			{field:'IndNo',title:'排序码',width:60,align:'center'}
		]],
		onSelect:function(rindex,rowData){
			obj.gridConfig_onSelect();
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridConfig_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//加载医院方法
	obj.Hospital = $HUI.combobox("#cboHospital", {
		url: $URL,
		editable: true,
		allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.HospitalSrv';
			param.QueryName = 'QryHospital';
			param.ResultSetType = 'array';
		}
	});
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

$(function () {
	InitWin();
});
