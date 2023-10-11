﻿var userid = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
///////////////////////// 年度///////////////////////////////////
var projUrl = 'herp.budg.budgprojclaimapplymainexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '立项年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//项目名称

var projnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


projnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojsubmitauditexe.csp'+'?action=projname',method:'POST'});
});

var projnameField = new Ext.form.ComboBox({
	id: 'projnameField',
	fieldLabel: '项目名称',
	width:150,
	listWidth : 300,
	store: projnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	name: 'projnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//预算科室
	var deptnameBs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	deptnameBs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept&str='+encodeURIComponent(Ext.getCmp('BudgdeptNameField').getRawValue()),method:'POST'});
	});
	var BudgdeptNameField = new Ext.form.ComboBox({
		id: 'BudgdeptNameField',
		fieldLabel: '预算科室',
		width:100,
		listWidth:225,
		store: deptnameBs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		name: 'BudgdeptNameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
//申请单状态
var chkStateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','新建'],['2','提交'],['3','审核通过']]
});
var chkstatecomb = new Ext.form.ComboBox({
	fieldLabel: '申请单状态',
	width:80,
	listWidth : 80,
	store: chkStateStore,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	name: 'chkstatecomb',
	mode: 'local', //本地模式
	selectOnFocus:true,
	forceSelection:'true'
});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var year = yearCombo.getValue();
	    var prjname = projnameField.getValue();
	    var budgdeptname = BudgdeptNameField.getValue();
	    var chkstate = chkstatecomb.getValue();
	    //alert(budgdeptname);
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,prjname:prjname,budgdeptname:budgdeptname,chkstate:chkstate}});
	}
});
var itemGrid = new dhc.herp.Grid({
		    title: '项目支出报销申请',
		    region : 'north',
		    url: 'herp.budg.budgprojclaimapplymainexe.csp',
			fields : [{
						header : '项目ID',
						dataIndex : 'rowid',
						editable:false,
						hidden : true
					},{
	                                                                                id : 'CompName',
	                                                                                header : '医疗单位',
                                                                                                width : 90,
	                                                                                editable : false,
                                                                                                dataIndex : 'CompName'
              
	                                                                }, {
						id : 'year',
						header : '立项年度',
						editable:false,
						width : 80,
						dataIndex : 'year'

					},{
						id : 'code',
						header : '项目编号',
						width : 100,
						editable:false,
						dataIndex : 'code'

					},{
						id : 'name',
						header : '项目名称',
						editable:false,
						width : 200,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'name'

					}, {
						id : 'deptdr',
						header : '责任科室ID',
						editable:false,
						width : 120,
						dataIndex : 'deptdr',
						hidden : true
					},{
						id : 'deptname',
						header : '责任科室',
						editable:false,
						width : 120,
						dataIndex : 'deptname'
					},{
						id : 'bdeptname',
						header : '预算科室',
						editable:false,
						width : 120,
						dataIndex : 'bdeptname'
					},{
						id : 'username',
						header : '负责人',
						width : 100,
						editable:false,
						dataIndex : 'username'

					}, {
						id : 'FundTotal',
						header : '预算总额',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'FundTotal'
						
					},{
						id : 'ReqMoney',
						header : '申请资金',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ReqMoney'

					},{
						id : 'ActPayWait',
						header : '在途报销',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayWait'

					},{
						id : 'ActPayMoney',
						header : '已经执行',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayMoney'

					},{
						id : 'budgco',
						header : '预算结余',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 100,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					}],

						split : true,
						collapsible : true,
						containerScroll : true,
						xtype : 'grid',
						trackMouseOver : true,
						stripeRows : true,
						sm : new Ext.grid.RowSelectionModel({
									singleSelect : true
								}),
						loadMask : true,
						tbar:['立项年度:',yearCombo,'-','项目名称:',projnameField,'-','预算科室:',BudgdeptNameField,'-','申请单状态:',chkstatecomb,'-',findButton],
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
	params:{start:0, limit:25,userid:userid},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){	
    var projdr="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	projdr=selectedRow[0].data['rowid'];
	itemDetail.load({params:{start:0,limit:25,userid:userid,projdr:projdr}});	
});


////////////// 单击项目名称 单击gird的单元格事件 /////////////////
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	if (columnIndex == 5) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("name");
		var projDr		 = records[0].get("rowid");
		projnamefun(FundBillDR,projDr,Name);
	}
});


