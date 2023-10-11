
depAdjustFun = function(Year, AdjustNo, itemCode, itemName, planValueModi){
	var budginfotitle = "��λ���������ҵ���";
	var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgadjustdepadjustexe.csp',
				fields : [{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'code',
							header : '��������',
							dataIndex : 'code',
							width : 60,
							editable:false
						},{
							id : 'planValue',
							header : '���Ԥ��',
							dataIndex : 'planValue',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'planValueModi',
							header : '����Ԥ��',
							dataIndex : 'planValueModi',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'adjustRatio',
							header : '��������',
							dataIndex : 'adjustRatio',
							align:'right',
							width : 60,
							editable:false
						}
						],
						viewConfig : {forceFit : true},
						tbar : ['���������ƣ�',itemName,'-','����Ԥ�㣺',planValueModi]	

	});
	
	detailitemGrid.btnAddHide();  //�������Ӱ�ť
   	detailitemGrid.btnSaveHide();  //���ر��水ť
    detailitemGrid.btnResetHide();  //�������ð�ť
    detailitemGrid.btnDeleteHide(); //����ɾ����ť
    detailitemGrid.btnPrintHide();  //���ش�ӡ��ť
	detailitemGrid.load({params:{Year:Year, AdjustNo:AdjustNo, itemCode:itemCode, start:0, limit:25}});
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
				width : 600,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]
			});
	window.show();
};