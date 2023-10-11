
 EthicAuditList = function(rowid,title,subuser){
  
  var ethicaudittitle=title+'--'+subuser;
	var EthicAuditGrid = new dhc.herp.GridEthic({
				//title : "����������Ϣ",
				width : 400,
				region : 'center',                          
				url : 'herp.srm.srmprosoliauditexe.csp',
				fields : [
              //new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'rowid',
							header : 'rowid',
							dataIndex : 'rowid',
							width : 60,
							hidden:true,
							align : 'center',
							editable:false
						}, {
							id : 'EthicExpert',
							header : '����ר��',
							dataIndex : 'EthicExpert',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'datastatus',
							header : '�Ƿ����ύ���ƽ̴�',
							dataIndex : 'datastatus',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'EthicChkResult',
							header : '������˽��',
							dataIndex : 'EthicChkResult',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'EthicAuditDate',
							header : '�������ʱ��',
							dataIndex : 'EthicAuditDate',
							width : 120,
							editable:false,
							align : 'left'
						},{
							id : 'EthicAuditDesc',
							header : '����������',
							dataIndex : 'EthicAuditDesc',
							width : 120,
							editable:false,
							align : 'left'
						}]    
			});
		EthicAuditGrid.btnAddHide();  //�������Ӱ�ť
   	EthicAuditGrid.btnSaveHide();  //���ر��水ť
    EthicAuditGrid.btnResetHide();  //�������ð�ť
    EthicAuditGrid.btnDeleteHide(); //����ɾ����ť
    EthicAuditGrid.btnPrintHide();  //���ش�ӡ��ť
    
	EthicAuditGrid.load({params:{start:0,limit:15,rowid:rowid}})
	
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
				items : [EthicAuditGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : ethicaudittitle,
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