//页面Gui
function InitSymptomWin(){
	var obj = new Object();		
    obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面  
    
    //症状归类
	obj.cboMsCate = Common_ComboDicID("cboMsCate","SMDSymptom");

    obj.gridMental = $HUI.datagrid("#gridMental",{
		fit: true,
		title:'精神症状字典',
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
		    ClassName:"DHCMed.SMD.Symptom",
			QueryName:"QryMentalSym",
			aCode: $('#txtCode').val(),
			aDesc:$('#txtDesc').val(), 
			aCateID: $('#cboMsCate').combobox('getValue')
	    },
		columns:[[
			{field: 'Code',title: '代码', width: 120},                                                                                                                           
			{field: 'Desc',title: '名称', width: 260},                                                                                                                                           
			{field: 'CateDesc',title: '症状分类', width: 200},                                                                                                                                              
			{field: 'IsActive',title: '是否有效', width: 100},                                                                                                                                            
			{field: 'Resume',title: '备注', width: 350}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMental_onSelect();
			}
		}
	});

	InitSymptomWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


