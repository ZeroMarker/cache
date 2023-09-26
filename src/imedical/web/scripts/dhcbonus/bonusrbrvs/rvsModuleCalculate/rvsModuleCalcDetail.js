function trim(str){
 	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");   //匹配规则
 	return tmp;
}

//配件数据源
var ModuleCalcDetailTabUrl = '../csp/dhc.bonus.rvsModuleCalculateexe.csp';
//var ModuleCalcDetailTabProxy= new Ext.data.HttpProxy({url:ModuleCalcDetailTabUrl + '?action=DetailList&start=0&limit=25'});

var ModuleCalcDetailTabProxy='';

var ModuleCalcDetailTabDs = new Ext.data.Store({
	proxy: ModuleCalcDetailTabProxy,
	//proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        //'rvsModuleCalcDetailID',
		'rowid',
		'rvsModuleCalcMainID',
		'bonusUnitID',
		'bonusSubItemID',
		'makeItemNum',
		'makeItemScore',
		'execItemNum',
		'execItemScore'
	]),
    // turn on remote sorting
    remoteSort: true     //排序
});


//数据库数据模型
var ModuleCalcDetailTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '测算ID',
        dataIndex: 'rvsModuleCalcMainID',
        width: 100,		  
        sortable: true
    },{
    	header: '核算大科',
        dataIndex: 'bonusUnitID',
        width: 150,
        sortable: true
    },{
	    header: 'RBRVS项目',
        dataIndex: 'bonusSubItemID',
        width: 150,
        sortable: true
	},{
	    header: '开单数量',
        dataIndex: 'makeItemNum',
        width: 130,
        sortable: true
	},{
	    header: '开单分值',
        dataIndex: 'makeItemScore',
        width: 130,
        sortable: true
        //align : 'right'
	},{
	    header: '执行数量',
        dataIndex: 'execItemNum',
        width: 130,
        sortable: true
	},{
		header: '执行分值',
        dataIndex: 'execItemScore',
        width: 130,		  
        sortable: true
	 }
    
]);﻿




//分页工具栏
var ModuleCalcDetailTabPagingToolbar = new Ext.PagingToolbar({
    store: ModuleCalcDetailTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"	
});


var ModuleCalcDetailTab = new Ext.grid.EditorGridPanel({
	title: '模型测算',
	region:'center',
	store: ModuleCalcDetailTabDs,
	cm: ModuleCalcDetailTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	//tbar:["模型名称",'-',templateCombo,"日期",YearMonth,'-',findButton,'-',addButton,'-',editButton],
	bbar:ModuleCalcDetailTabPagingToolbar
});

/*
ModuleCalcDetailTabDs.load({
	params:{start:0, limit:ModuleCalcDetailTabPagingToolbar.pageSize}
	
});
*/