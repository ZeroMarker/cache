var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgmoneybillmainsearchexe.csp';
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
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
			select:{fn:function(combo,record,index) { 
                	projDs.removeAll();
                	projCombo.setValue('');     				
                  projDs.load({params:{start:0,limit:10,year:combo.value,flag:2}});
            	}}
			}
		});
		
// ////////////项目名称////////////////////////
var projDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

projDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=projList&year='+yearCombo.getValue(),
						method : 'POST'
					});
		});

var projCombo = new Ext.form.ComboBox({
			fieldLabel : '项目名称',
			store : projDs,
			displayField : 'name',
			valueField : 'rowid',
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
		
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=username',
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			fieldLabel : '申请人',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

/////////////////////报销单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

		});


var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){

	      	var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			var applyer = userCombo.getValue();
			var billcode = applyNo.getValue();

		itemGrid.load({params:{start:0,limit:25,year:year,projname:projname,billcode:billcode,applyer:applyer}});
	}
});


var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">项目支出资金单据查询</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{
					xtype : 'displayfield',
					value : '立项年度:',
					columnWidth : .05
				}, yearCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .05
				},projCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .05
				}, userCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请单号:',
					columnWidth : .05
				}, applyNo

		]
	}]
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,		
			/*listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                //alert(columnIndex);
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if ((record.get('BillState') =="提交")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('BillState') =="提交") && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            },*/
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
	            id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
                     dataIndex : 'CompName'

	    }, {
						id : 'Code',
						header : '申请单号',
						width : 80,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'Code'

					},{
						id : 'Name',
						header : '项目名称',
						editable:false,
						width : 120,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'Name'

					}, {
						id : 'dname',
						header : '申请科室',
						editable:false,
						width : 120,
						dataIndex : 'dname'

					},{
						id : 'uName',
						header : '申请人',
						width : 60,
						editable:false,
						dataIndex : 'uName'

					}, {
						id : 'ApplyMoney',
						header : '申请金额',
						width : 60,
						editable : false,
						align:'right',
						dataIndex : 'ApplyMoney'
						
					},{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						align : 'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "新建") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else if (sf == "提交"){
							return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
						}else {
							return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'Desc',
						header : '申请说明',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'Desc'

					},{
						id : 'budgco',
						header : '预算结余',
						width : 60,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
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
					xtype : 'grid',
					loadMask : true,
					viewConfig : {forceFit : true},
					tbar : ['-',findButton ]

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:12,userdr:userdr}});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	
	if (columnIndex == 4) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("Name");
		detailFun(FundBillDR,Name);
	}
	
	if (columnIndex == 8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("Code");
		var Name		 = records[0].get("Name");
		stateFun(FundBillDR,Code,Name);
	}

	if (columnIndex == 3) {		

		var records = itemGrid.getSelectionModel().getSelections();
		var rowid = records[0].get("rowid")
		var Code  		 = records[0].get("Code");
		var dname  		 = records[0].get("dname");
		var uName  		 = records[0].get("uName");
		var Name  		 = records[0].get("Name");
		var Desc  		 = records[0].get("Desc");
	
		applyFun(rowid,Code,dname,uName,Name,Desc);

		
	}

});


