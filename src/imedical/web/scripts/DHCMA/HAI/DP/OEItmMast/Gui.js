//页面Gui
function InitOEItmMastWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridOEItmMast = $HUI.datagrid("#gridOEItmMast",{
		fit: true,
		//title: "医嘱项字典",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		nowrap:true,
		fitColumns:true,
		columns:[[
			{field:'ID',title:'ID',width:100},
			{field:'BTCode',title:'代码',width:80},
			{field:'BTDesc',title:'名称',width:500},
			{field:'BTCatDesc',title:'分类',width:300},
			{field:'BTIsActive',title:'是否有效',width:100,
			formatter: function ( value,row,index ) {
					return (row['BTIsActive'] == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEItmMast_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				//alert(JSON.stringify(rowData));
				obj.gridOEItmMast_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
			
	//医嘱分类下拉框
	obj.cbokind = $HUI.combobox('#cboBTCatDr', {              
		url:$URL,
		editable: false,
		mode: 'remote',
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.DPS.OEItmCatSrv';
			param.QueryName = 'QryOEItmCat';
			//param.aTypeCode = 'MapRule';
			//param.aActive = '1';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){  
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	
	InitOEItmMastWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}