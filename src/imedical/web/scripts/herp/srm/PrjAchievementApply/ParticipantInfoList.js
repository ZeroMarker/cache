
 AuthorInfoList = function(title,authorinfo){
	var title=title+'--������λ����Ϣ';
	var AuthorInfoGrid = new dhc.herp.GridAuthor({
				//title : "������λ����Ϣ",
				width : 400,
				region : 'center',                          
                url : 'herp.srm.srmidentifyapplyexe.csp',
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
							id : 'name',
							header : '����������',
							dataIndex : 'name',
							width : 150,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'isthehos',
							header : '������гɹ�ʱ���',
							dataIndex : 'isthehos',
							width : 150,
                            editable:false,
							align : 'left'
						},{
							id : 'range',
							header : '������λ��',
							dataIndex : 'range',
							width : 150,
              editable:false,
							align : 'left'
						}]    
			});
	AuthorInfoGrid.btnAddHide();  //�������Ӱ�ť
   	AuthorInfoGrid.btnSaveHide();  //���ر��水ť
    AuthorInfoGrid.btnResetHide();  //�������ð�ť
    AuthorInfoGrid.btnDeleteHide(); //����ɾ����ť
    AuthorInfoGrid.btnPrintHide();  //���ش�ӡ��ť
    
	AuthorInfoGrid.load({params:{start:0,limit:15,IDs:authorinfo}})
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�',
				iconCls: 'cancel'
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
				items : [AuthorInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : title,
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