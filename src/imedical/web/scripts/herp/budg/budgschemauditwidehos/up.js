ChildFun = function(Id)
{	
	
		
	var childGrid = new dhc.herp.Grid({
	    title: 'ǰ�÷����б� ',
	    width: 400,
	    // edit:false, //�Ƿ�ɱ༭
	    // readerModel:'local',
	    region: 'center',
	   //atLoad : true, // �Ƿ��Զ�ˢ��
	    url: 'herp.budg.budgschemauditwidehoschildexe.csp',
	    
		
	    fields: [
	    {
	        id:'rowid',
	        header: 'ID',
	        dataIndex: 'rowid',
	        hidden: true
	    },{
	        id:'bsmcode',
	        header: '�������',
	        dataIndex: 'bsmcode',
	        width:150,
			editable:false
			//hidden: true
	    },{
	        id:'bsmname',
	        header: '��������',
	        dataIndex: 'bsmname',
	        width:250,
	        update:true,
			editable:false,
			hidden: false
//			type:bsmNameField
	    },{ 
	        id:'bsmorderby',
	        header: '����˳��',
	        dataIndex: 'bsmorderby',
	        width:100,
			editable:false,
			hidden: false
	    }
		]

	});
	childGrid.load(({params:{start:0, limit:25,Id:Id}}));
	
	
	
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
				items : [childGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				//title : '�ڿƿ������Ԥ��ֽ����ά��;��������ֽ�ϵ��ά������',
				plain : true,
				width : 550,
				height : 450,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	
	childGrid.btnAddHide();  //�������Ӱ�ť
	childGrid.btnSaveHide();  //���ر��水ť
	childGrid.btnResetHide();  //�������ð�ť
	childGrid.btnDeleteHide(); //����ɾ����ť
	childGrid.btnPrintHide();  //���ش�ӡ��ť
	

};