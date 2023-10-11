//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";	
    $.parser.parse(); // 解析整个页面 	
				 
	obj.gridIMPKeyword = $HUI.datagrid("#gridIMPKeyword",{
		fit:true,
		title: "重点患者关键词维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.IMP.BTS.IMPKeywordSrv",
			QueryName:"QryIMPKeyword"		
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'Code',title:'关键词编码',width:'100',sortable:true},
			{field:'Desc',title:'关键词名称',width:'200',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'80',align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridIMPKeyword_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridIMPKeyword_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			obj.gridSemanticWord.loadData([]);
		}
	});
    
    obj.gridSemanticWord = $HUI.datagrid("#gridSemanticWord",{
		fit: true,
		title:'重点患者语义词维护',
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: true, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.IMP.BTS.SemanticWordSrv",
			QueryName:"QrySemanticWByKeyI",
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'40'},
			{field:'BTDesc',title:'语义词描述',width:'150',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'80',align:'center'}		
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSemanticWord_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSemanticWord_onDbSelect(rowData);
			}
		},
		onLoadSuccess:function(data){	
		    if($("#btnAdd").hasClass("l-btn-disabled")){
				$("#btnSubAdd").linkbutton("enable");
			}else{
				$("#btnSubAdd").linkbutton("disable");
			}
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
		
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


