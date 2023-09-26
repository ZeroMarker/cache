var PageLogicObj={
	m_tabUDHCFavOrderSetsDataGrid:"",
	m_tabUDHCARCOrderSetItemDataGrid:""
};
$(function(){
	//初始化加载已授权至登录科室的医嘱套列表
	PageLogicObj.m_tabUDHCFavOrderSetsDataGrid=InitUDHCFavOrderSetsDataGrid();
	LoadUDHCFavOrderSetsDataGrid();	
});
function InitUDHCFavOrderSetsDataGrid(){
	ARCOSToolBar = [{
            text: '引用至个人',
            iconCls: 'icon-copy',
            handler: function() {
	            ARCOSCopySave(1);
            }
        },
        {
            text: '引用至科室',
            iconCls: 'icon-copy',
            handler: function() {
	            ARCOSCopySave(2);
            }
        }
	];
	//医嘱套
	UDHCFavOrderSetsDataGrid=$('#UDHCFavOrderSets').datagrid({  
		width : 'auto',
		fit:true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"ARCOSRowid",
		pageSize:20,
		pageList : [20,50,100],
		toolbar :ARCOSToolBar,
		columns :[[
				{field:'ARCOSRowid',checkbox:true},
				{field:'ARCOSCode',title:'代码',width:100},   
    			{field:'ARCOSDesc',title:'名称',width:150},   
    			{field:'ARCOSAlias',title:'别名',width:100},
    			{field:'CelerType',title:'快速',width:50},
    			{field:'FavUserDesc',title:'用户',width:100},
    			{field:'FavDepDesc',title:'使用科室',width:100},
    			{field:'MedUnitDesc',title:'组名',width:100,hidden:true},
    			{field:'ARCOSEffDateFrom',title:'生效日期',width:100,hidden:true}, 
    			{field:'FavRowid',title:'FavRowid',width:100,hidden:true}, 
    			{field:'ARCOSOrdCatDR',title:'ARCOSOrdCatDR',width:100,hidden:true}, 
    			{field:'FavUserDr',title:'用户ID',width:100,hidden:true}, 
    			{field:'FavDepDr',title:'科室ID',width:100,hidden:true}, 
    			{field:'MedUnit',title:'组',width:100,hidden:true},
    			{field:'ARCOSOrdCat',title:'大类',width:100,align:'left'},
    			{field:'ARCOSOrdSubCat',title:'子类',width:100},
		]],
		onSelect:function(rowid,RowData){
			if (PageLogicObj.m_tabUDHCARCOrderSetItemDataGrid=="") {
				PageLogicObj.m_tabUDHCARCOrderSetItemDataGrid=InitUDHCARCOrderSetItemDataGrid();
			}
			LoadUDHCARCOrderSetItemDataGrid(RowData.ARCOSRowid);
		},
		onLoadSuccess:function(data){
			PageLogicObj.m_tabUDHCFavOrderSetsDataGrid.datagrid('uncheckAll');
		}
	});	
	return UDHCFavOrderSetsDataGrid;
}
function LoadUDHCFavOrderSetsDataGrid(){
	$.cm({
	    ClassName : "web.DHCARCOrdSetsAuthorize",
	    QueryName : "QueryARCOSList",
	    LocID:session['LOGON.CTLOCID'],
	    Pagerows:PageLogicObj.m_tabUDHCFavOrderSetsDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_tabUDHCFavOrderSetsDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function InitUDHCARCOrderSetItemDataGrid(){
	//医嘱套详细信息
	UDHCARCOrderSetItemDataGrid=$('#UDHCARCOrderSetItem').datagrid({  
		width : 'auto',
		fit:true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  
		rownumbers : false,  
		idField:"NO",
		pageSize:6,
		pageList : [6,15,50,100],
		columns :[[
				{field:'NO',title:'序号',width:50},
				{field:'ARCIMDesc',title:'名称',width:250,align:'left'}, 
				{field:'ARCOSItemDoseQty',title:'剂量',width:50},
    			{field:'ARCOSItemUOM',title:'剂量单位',width:100},
    			{field:'ARCOSItemFrequence',title:'频次',width:50},
    			{field:'ARCOSItemInstruction',title:'用法',width:100},
    			{field:'ARCOSItemDuration',title:'疗程',width:50},  
    			{field:'ARCOSItemQty',title:'数量',width:60},   
    			{field:'ARCOSItemBillUOM',title:'单位',width:50},
    			{field:'ARCOSItmLinkDoctor',title:'关联',width:50},
    			{field:'Tremark',title:'备注',width:150},
    			{field:'ARCOSDHCDocOrderType',title:'医嘱类型',width:100},
    			{field:'SampleDesc',title:'标本',width:100},
    			{field:'OrderPriorRemarks',title:'附加说明',width:100},
    			{field:'DHCDocOrdRecLoc',title:'接收科室',width:200},
    			{field:'DHCDocOrdStage',title:'医嘱阶段',width:150},
    			{field:'DHCMustEnter',title:'必开项',width:80},
    			{field:'SpeedFlowRate',title:'输液流速',width:80},
    			{field:'FlowRateUnit',title:'流速单位',width:85},
    	]],
		onLoadSuccess:function(data){
			PageLogicObj.m_tabUDHCARCOrderSetItemDataGrid.datagrid('uncheckAll');
		}
	});	
	return UDHCARCOrderSetItemDataGrid;
}
function LoadUDHCARCOrderSetItemDataGrid(ARCOSRowid){
	$.cm({
	    ClassName : "web.DHCARCOrdSets",
	    QueryName : "FindOSItem",
	    ARCOSRowid:ARCOSRowid, QueryFlag:1,
	    Pagerows:PageLogicObj.m_tabUDHCARCOrderSetItemDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_tabUDHCARCOrderSetItemDataGrid.datagrid('uncheckAll');
		PageLogicObj.m_tabUDHCARCOrderSetItemDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function ARCOSCopySave(CopyToConditione){
	var rows=PageLogicObj.m_tabUDHCFavOrderSetsDataGrid.datagrid("getSelections");
	if (rows.length==0) {
		$.messager.alert('提示','请选择需要引用的医嘱套!');
		return false;
	}
	var FromARCOSIdStr="";
	for (var i=0;i<rows.length;i++){
		var ARCOSRowid=rows[i].ARCOSRowid;
		if (FromARCOSIdStr=="") FromARCOSIdStr=ARCOSRowid;
		else  FromARCOSIdStr=FromARCOSIdStr+"^"+ARCOSRowid;
	}
	if (CopyToConditione=="1"){
		var InUser=session['LOGON.USERID'],FavDepList="";
	}else if (CopyToConditione=="2"){
		var InUser="",FavDepList=session['LOGON.CTLOCID'];
	}
	$.cm({
	    ClassName : "web.DHCARCOrdSetsAuthorize",
	    MethodName : "ARCOSCopy",
	    FromARCOSIdStr:FromARCOSIdStr,
	    UserRowid:session['LOGON.USERID'],
	    InUser:InUser,
	    FavDepList:FavDepList
	},function(rtn){
		if (rtn>0) {
			$.messager.popover({msg: '引用成功!',type:'success'});
			PageLogicObj.m_tabUDHCFavOrderSetsDataGrid.datagrid('uncheckAll');
		}
	})
}