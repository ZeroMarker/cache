//页面Gui
function InitViewport(){
	var obj = new Object();		
    obj.currGridRowId = "";
    $.parser.parse(); // 解析整个页面  
    
    //值类型
	obj.cboExtraType = Common_ComboDicID("cboExtraType","FBDSignExtraType");

    obj.gridSignDic = $HUI.datagrid("#gridSignDic",{
		fit: true,
		title:'主要症状与体征字典',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.FBDService.SignDicSrv",
			QueryName:"QrySignDic"
	    },
		columns:[[
			{field: 'Code',title: '代码', width: 150},                                                                                                                           
			{field: 'Desc',title: '名称', width: 260}, 
			{field: 'ExtraTypeDesc',title: '值类型', width: 120},                                                                                                                                              
			{field: 'ExtraUnit',title: '值单位', width: 120}, 			                                                                                                                                          
			{field: 'IsActiveDesc',title: '是否有效', width: 80},                                                                                                                                            
			{field: 'Resume',title: '备注', width: 300}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSignDic_onSelect();
			}
		}
	});

	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


