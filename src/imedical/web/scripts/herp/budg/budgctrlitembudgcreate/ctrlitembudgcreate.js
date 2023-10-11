var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var projUrl = 'herp.budg.ctrlitembudgcreateexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
// 申请年月
var YearDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'year', 'year' ])
});

YearDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url :  commonboxUrl + '?action=year',
		method : 'POST'
	});
});

var yearCombo = new Ext.form.ComboBox({
	fieldLabel : '预算年度',
	store : YearDs,
	displayField : 'year',
	valueField : 'year',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 120,
	listWidth : 245,
	pageSize : 10,
	minChars : 1,
	columnWidth : .12,
	selectOnFocus : true,
	listeners:{
            	select:{fn:function(combo,record,index) { 
                    ItemDs.removeAll();     				
                    ItemDs.proxy= new Ext.data.HttpProxy({url : projUrl + '?action=itemList&year='+yearCombo.getValue()+'&flag=2',method : 'POST'});      
                    ItemDs.load({params:{start:0,limit:10}});                     
            	}}
         	}
});

// 科目名称
var ItemDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'key', 'value' ])
});

ItemDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url :  projUrl + '?action=itemList&year='+yearCombo.getValue(),
		method : 'POST'
	});
});

var itemCombo = new Ext.form.ComboBox({
	fieldLabel : '科目名称',
	store : ItemDs,
	displayField :'value',
	valueField : 'key',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 120,
	listWidth : 245,
	pageSize : 10,
	minChars : 1,
	columnWidth : .18,
	selectOnFocus : true
});



///////////////科室名称////////////////////////
var audnameDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

audnameDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : commonboxUrl + '?action=dept&flag=1',
		method : 'POST'
		});
});
var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

// ///////////////////申请单号/////////////////////////
var applyNo = new Ext.form.TextField({
	columnWidth : .1,
	width : 70,
	columnWidth : .12,
	selectOnFocus : true

});

var findButton = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '查询',
	iconCls : 'option',
	handler : function() {
		var year = yearCombo.getValue();
		var code = itemCombo.getValue();
		var deptdr = audnamefield.getValue();
		if(code==""){
			Ext.Msg.show({title:'注意',msg:'请选择项目名称!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}

	
		itemGrid.load({
			params : {
				start : 0,
				limit : 25,
				year : year,
				code : code,
				userdr:userdr,
				deptdr:deptdr
			}
		});
	}
});

var addButton = new Ext.Toolbar.Button({
	text : '预算采集',
	tooltip : '预算采集',
	iconCls : 'option',
	handler : function() {
		var year = yearCombo.getValue();
		if(year==""){
			Ext.Msg.show({title:'注意',msg:'请选择年度名称!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}	 		
		addFun(year);
		
	}

});

var queryPanel = new Ext.FormPanel(
		{
			height : 90,
			region : 'north',
			frame : true,

			defaults : {
				bodyStyle : 'padding:5px'
			},
			items : [
					{
						xtype : 'panel',
						layout : "column",
						items : [ {
							xtype : 'displayfield',
							value : '<center><p style="font-weight:bold;font-size:120%">控制预算项生成</p></center>',
							columnWidth : 1,
							height : '32'
						} ]
					}, {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [  {
							xtype : 'displayfield',
							value : '预算年度:',
							columnWidth : .1
						}, yearCombo,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},{
							xtype : 'displayfield',
							value : '科目名称:',
							columnWidth : .1
						}, itemCombo,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},{
							xtype : 'displayfield',
							value : '科室名称:',
							columnWidth : .1
						}, audnamefield
						]
					} ]
		});

var itemGrid = new dhc.herp.Grid(
		{
			atload : true,
			region : 'center',
			url : 'herp.budg.ctrlitembudgcreateexe.csp',
			fields : [
			          {
			        	  id : 'mbudgtotal',
			        	  header : 'id',
			        	  width : 90,
			        	  hidden:true,
			        	  editable : true,
			        	  dataIndex : 'mbudgtotal'
			          },{	
			            id:'deptdr',
						header : '科室编号',
						dataIndex : 'deptdr',
						width:90
						
					},{
						id : 'CompName',
						header : '医疗单位',
						width : 90,
						editable : false,
						dataIndex : 'CompName'

					},{
						id : 'deptname',
						header : '科室名称',
						width : 90,
						editable : false,
						dataIndex : 'deptname'

					},{
						id : 'itemname',
						header : '项目名称',
						width : 90,
						editable : false,
						dataIndex : 'itemname'

					},{
						id : 'year',
						header : '年份',
						width : 90,
						editable : false,
						dataIndex : 'year'

					},{
						id : 'sbudgtotal',
						header : '累计预算',
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						hidden:true,
						editable : false,
						//allowBlank : false,
						dataIndex : 'sbudgtotal'

					},{
						id : 'ybudgtotal',
						header : '预算总额',
						width : 100,
						//hidden:true,
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'ybudgtotal'
					},{
						id : 'January',
						header : '一月',
						editable : false,
						width : 100,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'January'

					},{
						id : 'February',
						header : '二月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'February'

					},{
						id : 'March',
						header : '三月',
						editable : false,
						width : 100,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'March'

					},{
						id : 'April',
						header : '四月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'April'

					},{
						id : 'May',
						header : '五月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'May'

					},{
						id : 'June',
						header : '六月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'June'

					},{
						id : 'July',
						header : '七月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'July'

					},{
						id : 'August',
						header : '八月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'August'

					},{
						id : 'September',
						header : '九月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'September'

					},{
						id : 'October',
						header : '十月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'October'

					},{
						id : 'November',
						header : '十一月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'November'

					},{
						id : 'December',
						header : '十二月',
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						width : 100,
						dataIndex : 'December'

					}],
			xtype : 'grid',
			loadMask : true,
			// viewConfig : {forceFit : true},
//			tbar : [ '-', findButton, '-', addButton ]
		tbar : [ findButton, '-', addButton]

		});

itemGrid.btnAddHide(); // 隐藏增加按钮
itemGrid.btnSaveHide(); // 隐藏保存按钮
itemGrid.btnResetHide(); // 隐藏重置按钮
itemGrid.btnDeleteHide(); // 隐藏删除按钮
itemGrid.btnPrintHide(); // 隐藏打印按钮

itemGrid.load({
	params : {
		start : 0,
		limit : 12,
		year:"",
		code:"",
		userdr:userdr

	}
	
});



// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {


});
