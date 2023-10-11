var userid = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
// 年度///////////////////////////////////
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :commonboxUrl + '?action=year&flag=1',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '申请年月',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


/////科室


var DeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

DeptDs.on('beforeload', function(ds, o) {

   ds.proxy = new Ext.data.HttpProxy({
   url:commonboxUrl + '?action=dept&flag=1',method:'POST'});
		});

var DeptCombo = new Ext.form.ComboBox({
                        id:'DeptCombo',
			fieldLabel : '科室',
			store : DeptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

/////申请人



var ApplyerDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

ApplyerDs.on('beforeload', function(ds, o) {

   ds.proxy = new Ext.data.HttpProxy({
   url:commonboxUrl + '?action=username',method:'POST'});
		});

var ApplyerCombo = new Ext.form.ComboBox({
                        id:'ApplyerCombo',
			fieldLabel : '申请人',
			store : ApplyerDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});



////申请时间


var DateDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

DateDs.on('beforeload', function(ds, o) {

   ds.proxy = new Ext.data.HttpProxy({
   url:'herp.budg.syntheseachexe.csp'+'?action=GetDate&str='+encodeURIComponent(Ext.getCmp('DateCombo').getRawValue()),method:'POST'});
		});

var DateCombo = new Ext.form.ComboBox({
                        id:'DateCombo',
			fieldLabel : '申请时间',
			store : DateDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});






//////查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	   var year  = yearCombo.getValue();
           var dept  = DeptCombo.getValue();
           var appler= ApplyerCombo.getValue();
           var date  = DateCombo.getValue();
	   itemGrid.load({params:{start:0,limit:25,year:year,dept:dept,appler:appler,date:date,userid:userid}});
	}
});



var itemGrid = new dhc.herp.Grid({
		    title: '预算综合查询',
		    region : 'north',
		    url: 'herp.budg.syntheseachexe.csp',
			fields : [{            
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					}, {            
						header : '支付表ID',
						dataIndex : 'payrowid',
						hidden : true
					},{
						id : 'CompName',
						header : '医疗单位',
						editable:false,
						width : 120,
						
						dataIndex : 'CompName'

					},{
						id : 'ClaimCode',
					        header : '资金申请单号',
						editable:false,
						width : 120,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'ClaimCode',
                                                hidden : false

					},{
						id : 'ApplyCode',
						header : '报销申请单号',
						width : 120,
                                                align:'left',
                                                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						editable:false,
						dataIndex : 'ApplyCode'

					},{
						id : 'ApplyDept',
						header : '申请科室',
						editable:false,
						width : 120,
						
						dataIndex : 'ApplyDept'

					}, {
						id : 'ApplyName',
						header : '申请人',
						editable:false,
						width : 120,
						dataIndex : 'ApplyName',
						hidden : false
					}, {
						id : 'aApplyYear',
						header : '申请年月',
						editable:false,
						width : 80,
						dataIndex : 'ApplyYear'

					},{
						id : 'BudgAmount',
						header : '预算总额',
						width : 100,
						editable:false,
                                                align:'right',
						dataIndex : 'BudgAmount'

					}, {
						id : 'ApplyLimte',
						header : '申请额度',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'ApplyLimte'
						
					},{
						id : 'ApplyCheck',
						header : '申请审核',
						width : 80,
						align : 'right',
						editable:false,
						dataIndex : 'ApplyCheck'

					},{
						id : 'BudgSurplu',
						header : '预算结余',
						width : 100,
						align : 'right',
						editable:false,
                                                renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BudgSurplu']
						if (sf == "预算内") {
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:red;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'BudgSurplu'

					},{
						id : 'ClaimCheck',
						header : '报销审核',
						width : 80,
						editable:false,
						align:'right',
						dataIndex : 'ClaimCheck'

					},{
                                                id : 'ApplyDate',
						header : '申请时间',
						width : 100,
						editable:false,
						align:'center',
                                                hidden:false,
						dataIndex : 'ApplyDate'

                                        },{
						id : 'ClaimDate',
						header : '报销时间',
						width : 100,
                                                align:'center',
						editable:false,
						dataIndex : 'ClaimDate'

					}],
                                     tbar:['申请年月:',yearCombo,'-','科室','-',DeptCombo,'-','申请人','-',ApplyerCombo,'-','申请时间','-',DateCombo,'-',findButton]
	                 
						
		});

itemGrid.btnAddHide();    //隐藏增加按钮
itemGrid.btnSaveHide();   //隐藏保存按钮
itemGrid.btnResetHide();  //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
	params:{start:0, limit:25,userid:userid},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});



// 单击单据状态 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	if (columnIndex == 4) {              	
	   var records = itemGrid.getSelectionModel().getSelections();
	   var rowids  = records[0].get("rowid");
	   var funcode = records[0].get("ClaimCode");

           FundBillDetail(rowids,funcode);
	}
//单击报销单号单元格
       else if (columnIndex == 5) {
  var records = itemGrid.getSelectionModel().getSelections();
	 var payrowids  = records[0].get("payrowid");
	 var payrcode   = records[0].get("ApplyCode");
           PayBillDetail(payrowids,payrcode);
	}
       

});


