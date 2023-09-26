

var gNewItmFn;
function NewItmInfo(Fn){
	gNewItmFn = Fn;
	
	var NewItmUrl = 'dhcstm.newitmaction.csp';
	
	var NewItmSearchBtn = new Ext.ux.Button({
		text : '查询',
		iconCls : 'page_gear',
		handler : function(){
			var NewItmStartDate = Ext.getCmp('NewItmStartDate').getValue();
			if(Ext.isEmpty(NewItmStartDate)){
				Msg.info('warning', '开始日期不可为空!');
				return;
			}else{
				NewItmStartDate = NewItmStartDate.format(ARG_DATEFORMAT);
			}
			var NewItmEndDate = Ext.getCmp('NewItmEndDate').getValue();
			if(Ext.isEmpty(NewItmEndDate)){
				Msg.info('warning', '开始日期不可为空!');
				return;
			}else{
				NewItmEndDate = NewItmEndDate.format(ARG_DATEFORMAT);
			}
			var Desc = '';
			var CreateFlag = 'N';
			var AckFlag = 'Y';
			var Param = NewItmStartDate + '^' + NewItmEndDate + '^' + Desc + '^' + CreateFlag + '^' + AckFlag;
			NewItmGrid.getStore().load({
				params : {
					start : 0,
					limit : 999,
					Param : Param
				}
			});
		}
	});
	
	var SCISynBtn = new Ext.ux.Button({
		text : '同步',
		tooltip : '同步供应商商品',
		iconCls : 'page_gear',
		handler : function() {
			var Param = gLocId + '^' + userId;
			var url = 'dhcstm.newitmaction.csp?actiontype=GetPbSciItm&Param=' + Param;
			var result = ExecuteDBSynAccess(url);
			var jsonData = Ext.util.JSON.decode(result);
			if(jsonData.success == 'true'){
				Msg.info("success","同步成功!");
				NewItmSearchBtn.handler();
			}
		}
	});
	
	var NewItmStartDate = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'NewItmStartDate',
		anchor : '90%',
		value : new Date().add(Date.MONTH,-1)
	});
	var NewItmEndDate = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'NewItmEndDate',
		anchor : '90%',
		value : new Date()
	});
	
	var NewItmForm = new Ext.ux.FormPanel({
		tbar : [NewItmSearchBtn, '-', SCISynBtn],
		items : [{
			xtype : 'fieldset',
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : 0.3,
				items : [NewItmStartDate]
			},{
				columnWidth : 0.3,
				items : [NewItmEndDate]
			}]
		}]
	});

	var NewItmGrid = new Ext.grid.GridPanel({
		region : 'west',
		title : '立项项目',
		width : 0.6 * gWinWidth,
		store : new Ext.data.JsonStore({
			url : NewItmUrl + '?actiontype=GetNewItm',
			fields : ['NIRowId', 'NINo', 'NIDesc', 'NISpec', 'NIDateTime'],
			totalProperty : 'results',
			root : 'rows'
		}),
		cm : new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header : '审批单编号',
				dataIndex : 'NIRowId'
			},{
				header : '审批单名称',
				dataIndex : 'NINo',
				width : 120
			},{
				header : '物资名称',
				dataIndex : 'NIDesc',
				width : 120
			},{
				header : '规格',
				dataIndex : 'NISpec',
				width : 80
			},{
				header : '审批日期',
				dataIndex : 'NIDateTime',
				width : 150
			}
		]),
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true,
			listeners : {
				rowselect : function(sm, rowIndex, r){
					var Parref = r.get('NIRowId');
					NewItmDetailGrid.getStore().removeAll();
					NewItmDetailGrid.getStore().load({
						params : {
							Parref : Parref
						}
					});
				}
			}
		}),
		listeners : {
			rowdblclick : function(grid, rowIndex, e){
				var NIRowId = grid.getStore().getAt(rowIndex).get('NIRowId');
				var DetailUrl = NewItmUrl + '?actiontype=GetItmDetail&RowId=' + NIRowId;
				var DetailStr = ExecuteDBSynAccess(DetailUrl);
				var DetailObj = Ext.decode(DetailStr);
				NewItmWin.close();
				gNewItmFn(DetailObj);
			}
		}
	});
	
	var NewItmDetailGrid = new Ext.grid.GridPanel({
		region : 'center',
		title : '明细信息',
		store : new Ext.data.JsonStore({
			url : NewItmUrl + '?actiontype=GetNewItmInfo',
			fields : ['Desc', 'Value'],
			totalProperty : 'results',
			root : 'rows'
		}),
		cm : new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header : '字段',
				dataIndex : 'Desc'
			},{
				header : '字段值',
				dataIndex : 'Value',
				width : 120
			}
		])
	});
	
	var NewItmWin = new Ext.ux.Window({
		title : '新品立项信息',
		layout : 'border',
		items : [NewItmForm, NewItmGrid, NewItmDetailGrid]
	});
	NewItmWin.show();
	
}