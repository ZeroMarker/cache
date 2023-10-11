var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var projUrl = 'herp.budg.budgsyschkflowexe.csp';
		
// ////////////审批流////////////////////////
var CHKFlowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

CHKFlowDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=chkflowList&str='+encodeURIComponent(Ext.getCmp('CHKFlowCombo').getRawValue()),
						method : 'POST'
					});
		});

var CHKFlowCombo = new Ext.form.ComboBox({
			id : 'CHKFlowCombo',
			fieldLabel : '审批流',
			store : CHKFlowDs,
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

var SysNamemodStoreField = new Ext.form.ComboBox({												
				fieldLabel: '系统名称',
				width:120,
				anchor: '90%',
				store : new Ext.data.ArrayStore({
					fields:['key','keyValue'],
	data:[['1','P001_项目资金申请审'],['2','P002_项目支出报销申请'],['3','N001_一般性资金申请'],['4','N002_一般性支出报销申请']]
				}),
				displayField : 'keyValue',
				valueField : 'keyValue',
				typeAhead : true,
				mode : 'local',
				///value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});

var queryPanel = new Ext.FormPanel({
	height : 50,
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
			value : '<center><p style="font-weight:bold;font-size:150%">审批流定义</p></center>',
			columnWidth : 1,
			height : '35'
		}]
	}]
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,		
			
			fields : [
    new Ext.grid.CheckboxSelectionModel({editable:false}),{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'CompName',
						header : '医疗单位',
						width : 150,
						allowBlank:true,
						editable:false,
						dataIndex : 'CompName'

					}, {
						id : 'SysNo',
						header : '系统模块号',
						width : 200,
						allowBlank:true,
						editable:false,
						dataIndex : 'SysNo'

					}, {
						id : 'SysName',
						header : '系统名称',
						width : 300,						
						allowBlank : false,
						dataIndex : 'SysName',
						type:SysNamemodStoreField
					}, {
						id : 'CHKFlowDR',
						header : '审批流',
						width : 300,						
						allowBlank : false,
						dataIndex : 'CHKFlowDR',
						type:CHKFlowCombo

					}],
					xtype : 'grid',
					atload:true,
					loadMask : true
					//viewConfig : {forceFit : true}					

		});

    //itemGrid.btnAddHide();  //隐藏增加按钮
   	//itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    //itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:25}});


