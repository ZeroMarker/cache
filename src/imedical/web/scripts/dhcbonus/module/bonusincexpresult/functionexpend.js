
expend = function(deptcode,yearmonth) {
	//alert("deptcode"+deptcode);
	var itemGrid = new dhc.herp.Grid({
       // title: '������ϸ',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincexpresultexpenddetailexe.csp',	  
		//atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
			 id:'rowid',
		     header: '����',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'deptname',
		     header: '����',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'deptname'
		}, {
		     id:'itemname',
		     header: '֧����Ŀ',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'itemname'
		}, {
		     id:'itemvalue',
		     header: '���',
		     allowBlank: false,
		     align:'right',
		     width:100,
		     editable:false,
		     dataIndex: 'itemvalue'
		}]

        
});
itemGrid.load({params:{start:0,limit:15,yearmonth:yearmonth,deptcode:deptcode}})


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
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [itemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '����֧���ɱ���ϸ',
				plain : true,
				width : 600,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
		itemGrid.btnAddHide() ;	//�������Ӱ�ť
		itemGrid.btnSaveHide(); 	//���ر��水ť
		itemGrid.btnResetHide(); 	//�������ð�ť
		itemGrid.btnDeleteHide(); //����ɾ����ť
		itemGrid.btnPrintHide() ;	//���ش�ӡ��ť
	
	
}