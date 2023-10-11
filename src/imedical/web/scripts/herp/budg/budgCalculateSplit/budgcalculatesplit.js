var userdr = session['LOGON.USERID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgadjustcalcusplitexe.csp';
//年度
var YearDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results"
		,root : 'rows'
		}, ['year', 'year'])
	});
YearDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : commonboxURL+'?action=year&flag=',method : 'POST'});
	});
var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners:{
            "select":function(combo,record,index){
	            AdjustNoDs.removeAll();     
				AdjustNoCombo.setValue('');
				AdjustNoDs.proxy = new Ext.data.HttpProxy({url:commonboxURL+'?action=adjustno&flag=&year='+combo.value,method:'POST'})  
				AdjustNoDs.load({params:{start:0,limit:10}}); 
				}
			}	
		});

//调整序号
var AdjustNoDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['AdjustNo', 'AdjustNo'])
});
AdjustNoDs.on('beforeload', function(ds, o) {
	var year=yearCombo.getValue();
	if(year==""){
		Ext.Msg.show({title:'注意',msg:'请先选择预算年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
});
var AdjustNoCombo = new Ext.form.ComboBox({
			fieldLabel : '调整序号',
			store : AdjustNoDs,
			displayField : 'AdjustNo',
			valueField : 'AdjustNo',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

//////////////科室名称////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
deptDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
						url : commonboxURL+'?action=dept&flag=',
						method : 'POST'
					});
	});
var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 245,
			pageSize : 300,
			minChars : 1,
			selectOnFocus : true
		});

		
var calculateButton = new Ext.Toolbar.Button({
	text : '计算',
	tooltip : '计算',
	iconCls:'option',
	width : 50,
	handler : function() {
		var myMask = new Ext.LoadMask(Ext.getBody(), {
			msg: '数据计算中…',
			removeMask: true //完成后移除
		});
		var year= yearCombo.getValue();
		var adjustno=AdjustNoCombo.getValue();
		if((year=="")||(adjustno=="")){
			Ext.Msg.show({title:'注意',msg:'年度、调整序号不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		};
		function handler(id) {
			if (id == 'yes') {// 添加数据初始化进度条
				myMask.show();
				Ext.Ajax.request({
					url : projUrl + '?action=adjdeptymsplit&year='+year+'&adjustno='+adjustno,
					failure : function(result, request) {
						myMask.hide();
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						myMask.hide();
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : '注意',msg : '计算成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							itemGrid.load(({params:{start:0, limit:25,year:year,adjustno:adjustno,deptdr:deptCombo.getValue()}}));
						} else {
							Ext.Msg.show({title : '错误',msg : jsonData.info,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				})
			}
		}
		Ext.MessageBox.confirm('提示','确实要计算吗?',handler);			
	}
});
				
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',
    width : 50,        
    iconCls:'add',
	handler:function(){
		var year=yearCombo.getValue();
		var adjustno=AdjustNoCombo.getValue();
		var deptdr=deptCombo.getValue();
		if((year=="")||(adjustno=="")||(deptdr=="")){
			Ext.Msg.show({title:'注意',msg:'年度、调整序号、科室不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		};
		itemGrid.load(({params:{start:0, limit:25,year:year,adjustno:adjustno,deptdr:deptdr}}));
	}
});

//查询面板
var queryPanel = new Ext.FormPanel({
	height : 100,
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
			value : '<center><p style="font-weight:bold;font-size:150%">科室年度预算分解计算</p></center>',
			columnWidth : 1,
			height : '40'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '年度:',
					columnWidth : .05
				}, yearCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				},{
					xtype : 'displayfield',
					value : '调整序号:',
					columnWidth : .08
				}, AdjustNoCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				}, {
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .08
				},deptCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				},findButton,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				},calculateButton 

		]
	}]
});
function renderTopic(value, p, record){
	return String.format(
	    "<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?year={2}&report=HERPBUDGAdjDecmposReq.raq&reportName=HERPBUDGAdjDecmposReq.raq&ServerSideRedirect=dhccpmrunqianreport.csp\" >{0}</a></b>",
	    value, record.data.Code,record.data.Year);
	}
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,		
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if ((record.get('ChkStep') =="提交")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('ChkStep') =="提交") && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            },
			fields : [{
						header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'bsmCompName',
							header : '医疗单位',
							dataIndex : 'bsmCompName',
							width : 100,
							editable:false,
							hidden : true

						},{
							id : 'bsmYear',
							header : '年度',
							dataIndex : 'bsmYear',
							width : 70,
							editable:false

						},{
							id : 'bdsDeptNa',
							header : '科室名称',
							dataIndex : 'bdsDeptNa',
							width : 120,
							editable:false
						},{
							id : 'bsdItemCode',
							header : '科目编码',
							dataIndex : 'bsdItemCode',
							width : 120,
							editable:false
						},{
							id : 'bsdItemName',
							header : '科目名称',
							dataIndex : 'bsdItemName',
							width : 200,
							editable:false
							//renderer : renderTopic
						},{
							id : 'm1',
							header : '1月',
							dataIndex : 'm1',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm2',
							header : '2月',
							dataIndex : 'm2',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm3',
							header : '3月',
							dataIndex : 'm3',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm4',
							header : '4月',
							dataIndex : 'm4',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm5',
							header : '5月',
							dataIndex : 'm5',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm6',
							header : '6月',
							dataIndex : 'm6',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm7',
							header : '7月',
							dataIndex : 'm7',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm8',
							header : '8月',
							dataIndex : 'm8',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm9',
							header : '9月',
							dataIndex : 'm9',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm10',
							header : '10月',
							dataIndex : 'm10',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm11',
							header : '11月',
							dataIndex : 'm11',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm12',
							header : '12月',
							dataIndex : 'm12',
							width : 80,
							align : 'center',
							editable:false,
							hidden : false
					}],
					xtype : 'grid'

		});

    itemGrid.btnAddHide();     //隐藏增加按钮
   	itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮

/*
// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	//  单据状态
	if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var BillCode  	 = records[0].get("BillCode");
		var dName		 = records[0].get("dName");
		stateFun(FundBillDR,BillCode,dName);
	}
});
*/