var projUrl = 'herp.srm.srmhorizontalprjcheckapplyexe.csp';
BudgItemPay=function(SubNo){ 
var PrjItemPayGrid = new dhc.herp.Gridhs({
				//title : "������Ϣ",
				region : 'center',                          
				url : 'herp.srm.srmhorizontalprjcheckapplyexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'PYear',
							header : '���',
							dataIndex : 'PYear',
							width : 120,
							align : 'center',
							editable:false
							//hidden:true
						},{
							id : 'PCode',
							header : '��Ŀ����',
							dataIndex : 'PCode',
							width : 120,
							align : 'center',
							editable:false
							//type:ItemCombo
						},{
							id : 'PName',
							header : '��Ŀ����',
							dataIndex : 'PName',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false
						},{
							id : 'ItemCode',
							header : '��Ŀ����',
							dataIndex : 'ItemCode',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'ItemName',
							header : '��Ŀ����',
							dataIndex : 'ItemName',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'BudgTotal',
							header : '����Ԥ���ܶ�',
							dataIndex : 'BudgTotal',
							width : 120,
							editable:false,
							align : 'right'
						},{
							id : 'DName',
							header : '��������',
							dataIndex : 'DName',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'UName',
							header : '������',
							dataIndex : 'UName',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'BillCode',
							header : '��������',
							dataIndex : 'BillCode',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'ActPay',
							header : 'ʵ�ʱ���',
							dataIndex : 'ActPay',
							width : 120,
							editable:false,
							align : 'right'
						},{
							id : 'BudgBalance',
							header : '����',
							dataIndex : 'BudgBalance',
							width : 120,
							editable:false,
							align : 'right'
						},{
							id : 'Desc',
							header : '����˵��',
							dataIndex : 'Desc',
							width : 120,
							editable:false,
							align : 'left'
						}]    
			});
    
    PrjItemPayGrid.btnAddHide();  //�������Ӱ�ť
    PrjItemPayGrid.btnSaveHide();  //���ر��水ť
    //PrjItemPayGrid.btnResetHide();  //�������ð�ť
    PrjItemPayGrid.btnDeleteHide(); //����ɾ����ť
    //PrjItemPayGrid.btnPrintHide();  //���ش�ӡ��ť
	
	PrjItemPayGrid.load({params:{start:0,limit:15,prjcode:SubNo}})
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		window.close();
	}
	
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [PrjItemPayGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				//title : ethicaudittitle,
				plain : true,
				width : 800,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}