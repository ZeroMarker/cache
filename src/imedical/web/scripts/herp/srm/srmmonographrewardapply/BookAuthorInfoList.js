
 BookAuthorInfoList = function(title,authorinfo){
	var title = title+'--��������������Ϣ�б�';
	var BookAuthorInfoGrid = new dhc.herp.GridAuthor({
				//title : "��������������Ϣ",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.monographrewardapplyexe.csp',
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
							id : 'typename',
							header : '��������',
							dataIndex : 'typename',
							width : 100,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'name',
							header : '��������',
							dataIndex : 'name',
							width : 100,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'isthehos',
							header : '��������ʱ���',
							dataIndex : 'isthehos',
							width : 100,
              editable:false,
							align : 'left'
						},{
							id : 'rangename',
							header : '����λ��',
							dataIndex : 'rangename',
							width : 100,
              editable:false,
							align : 'left'
						}]    
			});
		BookAuthorInfoGrid.btnAddHide();  //�������Ӱ�ť
   	BookAuthorInfoGrid.btnSaveHide();  //���ر��水ť
    BookAuthorInfoGrid.btnResetHide();  //�������ð�ť
    BookAuthorInfoGrid.btnDeleteHide(); //����ɾ����ť
    BookAuthorInfoGrid.btnPrintHide();  //���ش�ӡ��ť
    
	BookAuthorInfoGrid.load({params:{start:0,limit:15,IDs:authorinfo}})
	
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
				items : [BookAuthorInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : title,
				iconCls: 'popup_list',
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