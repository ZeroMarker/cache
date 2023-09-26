

var gNewItmFn;
function NewItmInfo(Fn){
	gNewItmFn = Fn;
	
	var NewItmUrl = 'dhcstm.newitmaction.csp';
	
	var NewItmSearchBtn = new Ext.ux.Button({
		text : '��ѯ',
		iconCls : 'page_gear',
		handler : function(){
			var NewItmStartDate = Ext.getCmp('NewItmStartDate').getValue();
			if(Ext.isEmpty(NewItmStartDate)){
				Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
				return;
			}else{
				NewItmStartDate = NewItmStartDate.format(ARG_DATEFORMAT);
			}
			var NewItmEndDate = Ext.getCmp('NewItmEndDate').getValue();
			if(Ext.isEmpty(NewItmEndDate)){
				Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
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
		text : 'ͬ��',
		tooltip : 'ͬ����Ӧ����Ʒ',
		iconCls : 'page_gear',
		handler : function() {
			var Param = gLocId + '^' + userId;
			var url = 'dhcstm.newitmaction.csp?actiontype=GetPbSciItm&Param=' + Param;
			var result = ExecuteDBSynAccess(url);
			var jsonData = Ext.util.JSON.decode(result);
			if(jsonData.success == 'true'){
				Msg.info("success","ͬ���ɹ�!");
				NewItmSearchBtn.handler();
			}
		}
	});
	
	var NewItmStartDate = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'NewItmStartDate',
		anchor : '90%',
		value : new Date().add(Date.MONTH,-1)
	});
	var NewItmEndDate = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
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
		title : '������Ŀ',
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
				header : '���������',
				dataIndex : 'NIRowId'
			},{
				header : '����������',
				dataIndex : 'NINo',
				width : 120
			},{
				header : '��������',
				dataIndex : 'NIDesc',
				width : 120
			},{
				header : '���',
				dataIndex : 'NISpec',
				width : 80
			},{
				header : '��������',
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
		title : '��ϸ��Ϣ',
		store : new Ext.data.JsonStore({
			url : NewItmUrl + '?actiontype=GetNewItmInfo',
			fields : ['Desc', 'Value'],
			totalProperty : 'results',
			root : 'rows'
		}),
		cm : new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header : '�ֶ�',
				dataIndex : 'Desc'
			},{
				header : '�ֶ�ֵ',
				dataIndex : 'Value',
				width : 120
			}
		])
	});
	
	var NewItmWin = new Ext.ux.Window({
		title : '��Ʒ������Ϣ',
		layout : 'border',
		items : [NewItmForm, NewItmGrid, NewItmDetailGrid]
	});
	NewItmWin.show();
	
}