// //////////////年度//////////////////////
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
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
			columnWidth : .13,
			selectOnFocus : true
		});
		
// ////////////////////////////////////levelField SchTypeCombo
var SchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=itemtype&flag=1',
						method : 'POST'
					});
		});

var SchTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算项类别',
			store : SchTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .13,
			selectOnFocus : true
		});


//预算项级别
var levelStore = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['level','level'])
});

levelStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: commonboxUrl+'?action=itemlev',method:'POST'})
		});

var levelField  = new Ext.form.ComboBox({
	id: 'levelField ',
	fieldLabel: '预算项级别',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: levelStore,
	valueField: 'level',
	displayField: 'level',
	triggerAction: 'all',
	emptyText:'预算项级别...',
	name: 'levelField ',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});

/*var levelStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'], ['5', '5'], ['6', '6']]
		});
var levelField = new Ext.form.ComboBox({
			id : 'levelField',
			fieldLabel : '预算项级别',
			width : 100,
			listWidth : 245,
			selectOnFocus : true,
			store : levelStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
*/	
///////////////////////顶显示//////////////////////////////////
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
			value : '<center><p style="font-weight:bold;font-size:120%">医疗计划编制平衡</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '年度:',
					columnWidth : .07
				},yearCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
		            xtype : 'displayfield',
					value : '科目类别:',
					columnWidth : .07
				},SchTypeCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '科目级次:',
					columnWidth : .07
				},levelField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				},{
					xtype:'button',
					text: '查询',
					handler:function(){
					
						var type = SchTypeCombo.getValue();
						var level = levelField.getValue();
						var Year  = yearCombo.getValue();
						if(Year==""){
							Ext.Msg.show({title:'注意',msg:'年度不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}

						itemGrid.load({params:{start:0, limit:25,type:type, level:level,Year:Year}});
						
					},
					iconCls: 'add'
				}]	
	}]
});

//预算下达按钮
var ApproveButton = new Ext.Toolbar.Button({
	text: '预算下达',
    tooltip:'预算下达',        
    iconCls:'add',
	handler:function(){
		year=yearCombo.getValue();
		
		if(year==""){
			Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        var AdjustNo=0;
        
        Ext.MessageBox.confirm('提示', '确定要下达吗', function(btn) {
        if(btn='yes'){
		var surl = 'herp.budg.budginoutbalanceexe.csp?action=updateApprove&AdjustNo='+ AdjustNo+'&year='+year;
		itemGrid.saveurl(surl);
		}
	});
	}
});

//取消下达按钮
var UApproveButton = new Ext.Toolbar.Button({
	text: '取消下达',
    tooltip:'取消下达',        
    iconCls:'add',
	handler:function(){
		year=yearCombo.getValue();
		
		if(year==""){
			Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        var AdjustNo=0;

        Ext.MessageBox.confirm('提示', '确定取消下达吗', function(btn) {
        if(btn='yes'){
		var surl = 'herp.budg.budginoutbalanceexe.csp?action=updateUApprove&AdjustNo='+ AdjustNo+'&year='+year;
		itemGrid.saveurl(surl);
		}
	});
	

	}
});

//全院预算编制按钮
var SbudgButton = new Ext.Toolbar.Button({
	text: '全院预算编制状态',
    tooltip:'全院预算编制状态',        
    iconCls:'add',
	handler:function(){
	SbudgFun();
	}
});
//科室预算编制按钮
var DbudgButton = new Ext.Toolbar.Button({
	text: '科室预算编制状态',
    tooltip:'科室预算编制状态',        
    iconCls:'add',
	handler:function(){
	DbudgFun();
	}
});
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : 'herp.budg.budghealbalanceexe.csp',
			
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                    if ((record.get('t2d') =="")&& (columnIndex == 8)) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('t2d') =="") && (columnIndex == 8)) {						
							return false;
						} else {
							return true;
						}
					}
            },
						
			fields : [
			new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
	            id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
	      hidden : true,
                     dataIndex : 'CompName'

	    }, {
						id : 'Code',
						header : '预算编码',
						dataIndex : 'Code',
						width : 120,
						editable:false,
						hidden : false

					}, {
						id : 'Name',
						header : '预算项名称',
						width : 200,
						editable:false,
						//hidden : true,
						dataIndex : 'Name'

				}, {
						id : 'Year',
						header : '年度',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'Year'

				}, {
						id : 'TypeCode',
						header : '预算项类别',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'TypeCode'

					},{
						id : 't1s',
						header : '全院',
						width : 120,
						editable:true,
						align : 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
						},
						dataIndex : 't1s'

					}, {
						id : 't2d',
						header : '科室汇总',
						width : 120,
						align : 'right',
						editable:false,
						overrender: true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['t2d']
						if (sf != "") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}},
						dataIndex : 't2d'

					}, {
						id : 'dis',
						header : '差额',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'dis'
						
					},{
						id : 'disrate',
						header : '差异率(%)',
						width : 120,
						editable:false,
						//type : IsDBField,
						align : 'right',
						dataIndex : 'disrate'

					}, {
						id : 'RealValueLast',
						header : '上年执行',
						width : 120,
						align : 'right',
						editable : false,
						dataIndex : 'RealValueLast'
						
					},{
						id : 'disitem',
						header : '差额',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'disitem'
					},{
						id : 'updisrate',
						header : '差异率(%)',
						width : 120,
						editable:false,
						align : 'right',
						dataIndex : 'updisrate'

					},{
						id : 'ChkDesc',
						header : '审批意见',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ChkDesc'

					},{
						id : 'IdxType',
						header : '指标属性',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'IdxType'

					},{
						id : 'SchemDR',
						header : '方案dr',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'SchemDR'

					},{
						id : 'Stest',
						header : '全院',
						width : 120,
						editable:false,
                        update:true,
						hidden:true,
						dataIndex : 'Stest'

					},{
						id : 'AdjustNo',
						header : '调整序号',
						width : 120,
						editable:false,
                        update:true,
						hidden:true,
						dataIndex : 'AdjustNo'

					},{
						id : 'IsApproveS',
						header : '是否下达',
						width : 60,
						editable:false,
						align:'center',
						hidden:false,
						dataIndex : 'IsApproveS'

					},{
						id : 'IsApprove',
						header : '是否下达',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsApprove'

					}],
					//tbar:['-',ApproveButton,'-',searchbotton,'-',upstatebotton],
					layout:"fit",
					split : true,
					//collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					//viewConfig : {forceFit : true},
					//loadMask: true,
					//atLoad: true,
					height : 250,
					trackMouseOver: true,
					stripeRows: true
					

		});
   
    itemGrid.addButton('-');
	itemGrid.addButton(ApproveButton);
    itemGrid.addButton('-');
	itemGrid.addButton(UApproveButton); 
    itemGrid.addButton('-');
	itemGrid.addButton(SbudgButton);
	itemGrid.addButton('-');
	itemGrid.addButton(DbudgButton);
    
    itemGrid.btnAddHide();  //隐藏增加按钮
    //itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var tbar = itemGrid.getTopToolbar();
	var tbutton = tbar.get('herpSaveId');
	var records = itemGrid.getSelectionModel().getSelections();
	if( records[0].get("IsApprove")==1){
		tbutton.disable();
	}
	
	
	
	
	 //alert(columnIndex)
	// 前置方案设置
	if (columnIndex == 9) {
		var records = itemGrid.getSelectionModel().getSelections();
		var sName = records[0].get("Code")
		//alert(sName);
		var SchemDR = records[0].get("SchemDR")
        //alert(OrderBy);
		var Name = records[0].get("Name")
		var Year  = yearCombo.getValue();
		balanceDFun(sName,SchemDR,Name, itemGrid,Year);
	}
		// 预算方案明细添加
	/*if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid")
		var schmName = records[0].get("Name")
		var syear = records[0].get("Year")
		// 预算方案明细编制
		schemeDetailFun(schmDr,schmName,syear);
	}*/

  /*
	// 预算方案复制
	if (columnIndex == 11) {
		Ext.MessageBox.confirm('提示', '确定要复制选定的方案吗', function(btn) {
			if (btn == 'yes') {
				var records = itemGrid.getSelectionModel().getSelections();
				var schmDr = records[0].get("rowid")
				var surl = 'herp.budg.budgschemmainexe.csp?action=copysheme&rowid='
						+ schmDr;

				itemGrid.saveurl(surl)
			}
		});
	}*/
	

})
    
    
    



