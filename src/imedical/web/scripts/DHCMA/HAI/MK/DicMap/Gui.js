//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.aCategory="";
	
	//分类下拉框
	obj.cbokind = $HUI.combobox('#cboCat', {              
		url:$URL,
		allowNull:true,
		editable: true,
		mode: 'remote',
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.MK.BTMappingSrv';
			param.QueryName = 'QryInfDicByType';
			param.aGroupCode='SSDIC';
			param.aTypeCode='INFMinkeMappingType';
			param.aAlias='';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){   
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['xType']);
			}
		}
	}); 
	//分类下拉框
	obj.cboCategory = $HUI.combobox('#cboCategory', {              
		url:$URL,
		allowNull:true,
		editable: true,
		mode: 'remote',
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.MK.BTMappingSrv';
			param.QueryName = 'QryInfDicByType';
			param.aGroupCode='SSDIC';
			param.aTypeCode='INFMinkeMappingType';
			param.aAlias='';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){  
		}
	}); 
	obj.gridDicType = $HUI.datagrid("#gridDicType",{
		fit: true,
		//title: "字典类型",
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
	   
		columns:[[
			{field:'ID',title:'ID',width:80,align:'center'},
			{field:'Category',title:'类型代码',width:160},
			{field:'CategoryDesc',title:'类型名称',width:160},
			{field:'SrcObjectID',title:'唯一键值',width:240},
			{field:'SrcDescription',title:'键值描述',width:240},
			{field:'Target',title:'标准值',width:120},
			{field:'TargetDesc',title:'标准描述',width:140},
			{field:'ResumeText',title:'备注',width:120}		
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDicType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDicType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}
$(InitWin);

