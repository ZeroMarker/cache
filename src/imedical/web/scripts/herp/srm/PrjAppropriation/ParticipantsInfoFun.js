
ParticipantsInfoFun=function(Name,ParticipantsIDs){
	var Participantstitle = Name+"--������Ա";
	
	var ParticipantsInfo = new dhc.herp.Gridlyf({
				width : 400,
				region : 'center',
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [{
							header : '��ԱID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'name',
							header : '������Ա',
							dataIndex : 'name',
							width : 100
						},{
							id : 'isthehosrowid',
							header : '�������ʱ���',
							dataIndex : 'isthehosrowid',
							width : 60,
							hidden : true
						},{
							id : 'isthehos',
							header : '�������ʱ���',
							dataIndex : 'isthehos',
							//align:'right',
							width : 180
						},{
							id : 'rangerowid',
							header : '��Աλ��',
							dataIndex : 'rangerowid',
							width : 60,
							hidden : true
							
						},{
							id : 'range',
							header : '��Աλ��',
							dataIndex : 'range',
							//align:'right',
							width : 100
						}
						]
						//viewConfig : {forceFit : true}
						//tbar : [Name,'-','������Ա']	
	});

	ParticipantsInfo.btnAddHide();  //�������Ӱ�ť
   	ParticipantsInfo.btnSaveHide();  //���ر��水ť
    ParticipantsInfo.btnResetHide();  //�������ð�ť
    ParticipantsInfo.btnDeleteHide(); //����ɾ����ť
    ParticipantsInfo.btnPrintHide();  //���ش�ӡ��ť
    
	ParticipantsInfo.load({params : {start : 0,limit : 25,ParticipantsIDs:ParticipantsIDs}});
	//alert(ParticipantsIDs);
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�',iconCls : 'cancel'});
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
				items : [ParticipantsInfo]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : Participantstitle,
				iconCls: 'popup_list',
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