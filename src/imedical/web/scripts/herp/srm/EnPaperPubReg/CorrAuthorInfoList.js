
 CorrAuthorInfoList = function(title,corrauthorinfo){

var corrauthorinfotitle=title+'--ͨѶ����������Ϣ';
	var CorrAuthorInfoGrid = new dhc.herp.CorrAuthorGrid({
				//title : "ͨѶ����������Ϣ",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.SRMEnPaperPubRegexe.csp',
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
							header : '��������',
							dataIndex : 'name',
							width : 100,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'isthehos',
							header : '���ķ���ʱ���',
							dataIndex : 'isthehos',
							width : 100,
              editable:false,
							align : 'left'
						},{
							id : 'range',
							header : '����λ��',
							dataIndex : 'range',
							width : 100,
              editable:false,
							align : 'left',
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   if (value=='�ڶ�'){
						   var value='����';
						   };       
						  return '<span >'+value+'</span>';}
							
						}]    
			});
		CorrAuthorInfoGrid.btnAddHide();  //�������Ӱ�ť
   	CorrAuthorInfoGrid.btnSaveHide();  //���ر��水ť
    CorrAuthorInfoGrid.btnResetHide();  //�������ð�ť
    CorrAuthorInfoGrid.btnDeleteHide(); //����ɾ����ť
    CorrAuthorInfoGrid.btnPrintHide();  //���ش�ӡ��ť
    
	CorrAuthorInfoGrid.load({params:{start:0,limit:15,IDs:corrauthorinfo}})
	
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
				items : [CorrAuthorInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : corrauthorinfotitle,
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