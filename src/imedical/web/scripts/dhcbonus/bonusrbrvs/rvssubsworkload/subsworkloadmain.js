/**
  *name:tab of database
  *author:guojing
  *Date:2016-2-24
 */﻿
 
 var RVSSubsWorkLoadTabUrl = '../csp/dhc.bonus.rvssubsworkloadexe.csp';
 function trim(str){
 	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");   //匹配规则
 	return tmp;
}

//配件数据源

var RVSSubsWorkLoadTabProxy= new Ext.data.HttpProxy({url:RVSSubsWorkLoadTabUrl + '?action=list'});

var RVSSubsWorkLoadTabDs = new Ext.data.Store({
	proxy: RVSSubsWorkLoadTabProxy,
	//proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        //'BsbExpendCollectDocID',
		'rowid',
		'ItemCode',
		'ItemName',
		'OrdDate',
		'AdmDate',
		'PatType',
		'PatDepDr',
		'RecDepDr',
		'ResDoc',
		'RecDoc',
		'TarNums',
		'TarPrice',
		'PatRate',
		'RecRate',
		'ResRate',
		'TotalPrice',
		'TarItmEMCCate',
		'Flag',
		'UpdateDate',
		'YearMonth'
	]),
    // turn on remote sorting
    remoteSort: true     //排序
});


//数据库数据模型
var RVSSubsWorkLoadTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: '年月',
        dataIndex: 'YearMonth',
        width: 80,		  
        sortable: true
	 },{
    	header: '项目编号',
        dataIndex: 'ItemCode',
        width: 90,		  
        sortable: true
    },{
    	header: '项目名称',
        dataIndex: 'ItemName',
        width: 130,
        sortable: true
    },{
	    header: '开单科室',
        dataIndex: 'PatDepDr',
        width: 130,
        sortable: true
	},{
	    header: '执行科室',
        dataIndex: 'RecDepDr',
        width: 130,
        sortable: true
	},{
	    header: '项目数量',
        dataIndex: 'TarNums',
        width: 70,
        sortable: true,
        align : 'right'
	},{
	    header: '更新时间',
        dataIndex: 'UpdateDate',
        width: 150,
        sortable: true
	}
    
]);

var CNField = new Ext.form.TextField({
	id: 'CNField',
	fieldLabel: '编码/名称',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'CNField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

var YMField = new Ext.form.TextField({
	id: 'YMField',
	fieldLabel: '年月',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'YMField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

var PatDepDrSt = new Ext.data.Store({
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['BonusUnitID','BonusUnitName'])
	});

PatDepDrSt.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.rvssubsworkloadexe.csp?action=getPatDepDr&start=0&limit=25'+encodeURIComponent(Ext.getCmp('PatDepDrCombo').getRawValue()),
		     method:'POST'
		});
});

var PatDepDrCombo = new Ext.form.ComboBox({
	id: 'PatDepDrCombo',
	fieldLabel : '开单科室',
	width : 120,
	listWidth : 200,
	selectOnFocus : true,
	store : PatDepDrSt,
	anchor : '95%',			
	displayField : 'BonusUnitName',                                
	valueField : 'BonusUnitID',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true,
	editable:true,
	typeAhead:true,
	name: 'PatDepDrCombo',
	minChars: 1,
	pageSize: 25
});

var RecDepDrSt = new Ext.data.Store({
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['BonusUnitID','BonusUnitName'])
	});

RecDepDrSt.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.rvssubsworkloadexe.csp?action=getRecDepDr&start=0&limit=25'+encodeURIComponent(Ext.getCmp('RecDepDrCombo').getRawValue()),
		     method:'POST'
		});
});

var RecDepDrCombo = new Ext.form.ComboBox({
	id: 'RecDepDrCombo',
	fieldLabel : '执行科室',
	width : 120,
	listWidth : 200,
	selectOnFocus : true,
	store : RecDepDrSt,
	anchor : '95%',			
	displayField : 'BonusUnitName',                                
	valueField : 'BonusUnitID',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true,
	editable:true,
	typeAhead:true,
	name: 'RecDepDrCombo',
	minChars: 1,
	pageSize: 25
});


//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var cnfield=CNField.getValue();
	
	var PatDepDr=PatDepDrCombo.getValue();
	
	var RecDepDr=RecDepDrCombo.getValue();
	var yearMonth = YMField.getValue();	

	RVSSubsWorkLoadTabDs.load(({params:{
		start:0, 
		limit:25,
		cnfield:cnfield,
		PatDepDr:PatDepDr,
		RecDepDr:RecDepDr,
		yearMonth:yearMonth}}));
	
	}
});
//Excel导入按钮
var ExcelButton = new Ext.Toolbar.Button({
    text : 'Excel导入', 
	tooltip : 'Excel导入',
	iconCls : 'add',
	handler : function(){
	importExcel();
	return;
}
});		

//分页工具栏
var RVSSubsWorkLoadTabPagingToolbar = new Ext.PagingToolbar({
    store: RVSSubsWorkLoadTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"	
});


//表格
var RVSSubsWorkLoadTab = new Ext.grid.EditorGridPanel({
	title: '工作量采集',
	store: RVSSubsWorkLoadTabDs,
	cm: RVSSubsWorkLoadTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:["年月",YMField,'-',"编码/名称",CNField,'-',"开单科室",PatDepDrCombo,'-',"执行科室",RecDepDrCombo,'-',findButton,'-',ExcelButton],
	bbar:RVSSubsWorkLoadTabPagingToolbar
});
//RVSSubsWorkLoadTabDs.load({params:{start:0, limit:RVSSubsWorkLoadTabPagingToolbar.pageSize}});