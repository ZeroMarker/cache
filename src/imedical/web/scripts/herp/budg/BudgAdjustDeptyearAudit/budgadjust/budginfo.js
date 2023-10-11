
budginfoFun = function(Year, AdjustNo, itemCode){
	var budginfotitle = "��λ�ƻ�����";

	var budginfoUrl = 'herp.budg.budgadjustbudginfoexe.csp';
	var itemCodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Rowid', 'Code'])
	});

	itemCodeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : budginfoUrl+'?action=listCodeName',
						method : 'POST'
					});
	});

	var itemCodeCombo = new Ext.form.ComboBox({
			fieldLabel : 'ָ�����',
			store : itemCodeDs,
			displayField : 'Code',
			valueField : 'Code',
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

	var itemNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Rowid', 'Name'])
	});

	itemNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : budginfoUrl+'?action=listCodeName',
						method : 'POST'
					});
	});

	var itemNameCombo = new Ext.form.ComboBox({
			fieldLabel : 'ָ������',
			store : itemNameDs,
			displayField : 'Name',
			valueField : 'Rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '-',
			width : 100,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
	});

	var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'option',
		handler: function(){
			var itemCode = itemCodeCombo.getValue();
			var itemName = itemNameCombo.getValue();
			detailitemGrid.load({params:{start:0,limit:25,itemCode:itemCode,itemName:itemName,Year:Year,AdjustNo:AdjustNo}});
		}
	});

	var detailitemGrid = new dhc.herp.Grid({
				width : 800,
				region : 'center',
				url : 'herp.budg.budgadjustbudginfoexe.csp',
				fields : [
						{
							id : 'ItemCode',
							header : '��Ŀ����',
							dataIndex : 'ItemCode',
							width : 80,
							editable:false,
							renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
							{ 
								return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
							}
						},{
							id : 'ItemName',
							header : '��Ŀ����',
							dataIndex : 'ItemName',
							width : 80,
							editable:false

						},{
							id : 'CalUnitName',
							header : '������λ',
							dataIndex : 'CalUnitName',
							width : 80,
							editable:false

						},{
							id : 'planValue',
							header : '���Ԥ��',
							dataIndex : 'planValue',
							width : 80,
							editable:false

						},{
							id : 'planValueModi',
							header : '����Ԥ��',
							dataIndex : 'planValueModi',
							width : 80,
							editable:false

						},{
							id : 'depSumAdjust',
							header : '���һ���',
							dataIndex : 'depSumAdjust',
							width : 80,
							editable:false
						},
						{
							id : 'SumAdjust',
							header : '�ۼ�Ԥ��',
							dataIndex : 'SumAdjust',
							width : 80,
							editable:false
						},
						{
							id : 'adjustRatio',
							header : '��������',
							dataIndex : 'adjustRatio',
							width : 80,
							editable:false

						}
						],
						viewConfig : {forceFit : true},
						tbar : ['ָ����룺',itemCodeCombo,'ָ�����ƣ�',itemNameCombo,'-',findButton ]	

	});
	
	detailitemGrid.btnAddHide();  //�������Ӱ�ť
   	detailitemGrid.btnSaveHide();  //���ر��水ť
    detailitemGrid.btnResetHide();  //�������ð�ť
    detailitemGrid.btnDeleteHide(); //����ɾ����ť
    detailitemGrid.btnPrintHide();  //���ش�ӡ��ť
	detailitemGrid.load({params:{Year:Year, AdjustNo:AdjustNo, itemCode:itemCode, start:0, limit:25}});
	// ����gird�ĵ�Ԫ���¼�
	detailitemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
		var records = detailitemGrid.getSelectionModel().getSelections();
		if (columnIndex == 1) {         	
			var rowid  = records[0].get("rowid");
			var itemCode  = records[0].get("ItemCode");
			var itemName  = records[0].get("ItemName");
			var planValueModi  = records[0].get("planValueModi");
			//alert(Year);			
			depAdjustFun(Year, AdjustNo, itemCode, itemName, planValueModi);	
		}
	});
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});
	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
		window.close();
	};
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
		
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [detailitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : budginfotitle,
				plain : true,
				width : 800,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};