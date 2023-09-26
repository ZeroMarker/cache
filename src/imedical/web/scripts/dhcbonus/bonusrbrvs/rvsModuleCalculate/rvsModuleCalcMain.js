/**
  *name:tab of database
  *author:guojing
  *Date:2016-2-24
 */﻿
 
 function trim(str){
 	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");   //匹配规则
 	return tmp;
}

//配件数据源
var ModuleCalTabUrl = '../csp/dhc.bonus.rvsModuleCalculateexe.csp';
var ModuleCalTabProxy= new Ext.data.HttpProxy({url:ModuleCalTabUrl + '?action=list&start=0&limit=10'});

var ModuleCalTabDs = new Ext.data.Store({
	proxy: ModuleCalTabProxy,
	//proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        //'rvsModuleCalcMainID',
		'rowid',
		'calcNum',
		'rvsTemplateMainID',
		'operatePerson',
		'operateDate',
		'CalcDesc',
		'ItemPrice',
		'CalcTotal'
	]),
    // turn on remote sorting
    remoteSort: true     //排序
});


//数据库数据模型
var ModuleCalTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '测算次数',
        dataIndex: 'calcNum',
        width: 90,		  
        sortable: true
    },{
    	header: '模型名称',
        dataIndex: 'rvsTemplateMainID',
        width: 100,
        sortable: true
    },{
	    header: '操作人员',
        dataIndex: 'operatePerson',
        width: 100,
        sortable: true
	},{
	    header: '操作日期',
        dataIndex: 'operateDate',
        width: 150,
        sortable: true
	},{
	    header: '测算描述',
        dataIndex: 'CalcDesc',
        width: 220,
        sortable: true
        //align : 'right'
	},{
	    header: '分值单价',
        dataIndex: 'ItemPrice',
        width: 130,
        sortable: true
	},{
		header: '分配总额',
        dataIndex: 'CalcTotal',
        width: 150,		  
        sortable: true
	 }
    
]);

//获取模型ID
var TemplateDs = new Ext.data.Store({
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','templateName'])
	});

 TemplateDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.rvstemplateexe.csp?action=templatelist&start=0&limit=25'+encodeURIComponent(Ext.getCmp('templateCombo').getRawValue()),
		     method:'POST'
		});
});

 var templateCombo = new Ext.form.ComboBox({
	id: 'templateCombo',
	fieldLabel : '模型名称',
	width : 120,
	selectOnFocus : true,
	store : TemplateDs,
	anchor : '95%',			
	displayField : 'templateName',                                
	valueField : 'rowid',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true,
	minChars: 1,
	pageSize: 25
});

//日期控件
var YearMonth = new Ext.ux.MonthField({   
     id:'month',   
     fieldLabel: '月份',   
     allowBlank:true,   
     readOnly : true,   
     format:'Y-m',   
        listeners:{"blur":function(){    
  }}   
});



//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	
	var templateMainId=templateCombo.getValue();
	//var templateMainId=templateCombo.getRawValue();
	//alert(templateMainId)
	var yearmonth = Ext.util.Format.date(YearMonth.getValue(), 'Y-m');
	
	

	ModuleCalTabDs.load(({params:{
		start:0, 
		limit:25,
		templateMainId:templateMainId,
		yearmonth:yearmonth
		}}));
	
	}
});

		

//分页工具栏
var ModuleCalTabPagingToolbar = new Ext.PagingToolbar({
    store: ModuleCalTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"	
});


//添加
var addButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
		mainAddFun();
		
	}
});


//修改
var editButton = new Ext.Toolbar.Button({
	text: '修改',
	tooltip: '修改',
	iconCls: 'option',
	handler: function(){
		var rowObj = ModuleCalTab.getSelectionModel().getSelections();
		var len = rowObj.length;
		mainEditFun();
	}
});


//测算
var calcButton = new Ext.Toolbar.Button({
	text: '测算',
	tooltip: '测算',
	iconCls: 'add',
	handler: function(){
		var rowObj = ModuleCalTab.getSelectionModel().getSelections();
	    var len = rowObj.length;
	    var tmpRowid = "";
		mainCalcFun();
		
	}
});



//表格
var ModuleCalTab = new Ext.grid.EditorGridPanel({
	title: '模型测算',
	region:'north',
	height:230,
	store: ModuleCalTabDs,
	cm: ModuleCalTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:["模型名称",'-',templateCombo,"日期",YearMonth,'-',findButton,'-',addButton,'-',editButton,'-',calcButton],
	bbar:ModuleCalTabPagingToolbar
});
ModuleCalTabDs.load({
	params:{start:0, limit:ModuleCalTabPagingToolbar.pageSize},
	callback:function(record,options,success ){
		ModuleCalTab.fireEvent('rowclick',this,0);
		
	}    
});

var tmpMCMID='';

ModuleCalTab.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = ModuleCalTabDs.data.items[rowIndex];

	//单击主模板，刷新详细信息
	//selectedRow.data['templateCode']  templateCode必须是grid已经定义的
	tmpMCMID=selectedRow.data['rowid'];
	ModuleCalcDetailTabDs.proxy = new Ext.data.HttpProxy({url: ModuleCalcDetailTabUrl + '?action=DetailList&ModuleCalcDetailID='+tmpMCMID});
	ModuleCalcDetailTabDs.load({params:{start:0, limit:ModuleCalcDetailTabPagingToolbar.pageSize}});
	
});	