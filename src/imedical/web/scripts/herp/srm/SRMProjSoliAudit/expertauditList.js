
 ExpertAuditList = function(rowid,title,subuser){
	var ExpertAuditGrid = new dhc.herp.GridExpert({
				//title : "����������Ϣ",
				width : 400,
				region : 'center',                          
				url : 'herp.srm.srmprosoliauditexe.csp',
				fields : [
						{
							id : 'rowid',
							header : 'rowid',
							dataIndex : 'rowid',
							width : 60,
							hidden:true,
							align : 'center',
							editable:false
						}, {
							id : 'ExpertName',
							header : 'ר��',
							dataIndex : 'ExpertName',
							width : 80,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'datastatus',
							header : '�Ƿ����ύ���ƽ̴�',
							dataIndex : 'datastatus',
							width : 80,
							editable:false,
							align : 'left'
						},{
							id : 'sumscore',
							header : '�ܷ�',
							dataIndex : 'sumscore',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index1score',
							header : 'Ŀ����ȷ��',
							dataIndex : 'Index1score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index2score',
							header : '�������ճ̶�',
							dataIndex : 'Index2score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index3score',
							header : '��ƿ�ѧ��',
							dataIndex : 'Index3score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index4score',
							header : '���ⴴ����',
							dataIndex : 'Index4score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index5score',
							header : '���ۿ�����',
							dataIndex : 'Index5score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index6score',
							header : '����������',
							dataIndex : 'Index6score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index7score',
							header : '��Ա������',
							dataIndex : 'Index7score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index8score',
							header : '�ⲿ����������',
							dataIndex : 'Index8score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index9score',
							header : 'Ԥ�������',
							dataIndex : 'Index9score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index10score',
							header : '�����߼�������',
							dataIndex : 'Index10score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index11score',
							header : '�������Ԥ��',
							dataIndex : 'Index11score',
							width : 80,
							editable:false,
							align : 'right'
						},{
							id : 'Index12score',
							header : 'ǰ�ڹ�������',
							dataIndex : 'Index12score',
							width : 80,
							editable:false,
							align : 'right'
						}]    
			});
	ExpertAuditGrid.btnAddHide();  //�������Ӱ�ť
   	ExpertAuditGrid.btnSaveHide();  //���ر��水ť
    ExpertAuditGrid.btnResetHide();  //�������ð�ť
    ExpertAuditGrid.btnDeleteHide(); //����ɾ����ť
    ExpertAuditGrid.btnPrintHide();  //���ش�ӡ��ť
    
	ExpertAuditGrid.load({params:{start:0,limit:15,rowid:rowid}})
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�',
				iconCls : 'cancel'
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
				items : [ExpertAuditGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : subuser+"--"+title,
				iconCls : 'popup_list',
				plain : true,
				width : 500,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}