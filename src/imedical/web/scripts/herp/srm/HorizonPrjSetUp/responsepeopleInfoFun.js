
responsepeopleInfoFun=function(Name,HeadDR){
	var Participantstitle = Name+"--��Ŀ������";
	
	var ParticipantsInfo = new dhc.herp.Gridres({
				width : 500,
				region : 'center',
				autoScroll:true,
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [{
							header : '��Ա����',
							width : 100,
							editable:false,
							dataIndex : 'code',
							hidden : false
						},{
							id : 'name',
							header : '����',
							dataIndex : 'name',
							width : 100
						},{
							id : 'ID',
							header : '���֤��',
							dataIndex : 'ID',
							width : 150
						},{
							id : 'sex',
							header : '�Ա�',
							dataIndex : 'sex',
							width : 80,
							hidden : false
						},{
							id : 'DeptName',
							header : '����',
							dataIndex : 'DeptName',
							width : 180
						},{
							id : 'TitleDr',
							header : '����ְ��',
							dataIndex : 'TitleDr',
							//align:'right',
							width : 100
						},{
							id : 'Phone',
							header : '��ϵ�绰',
							dataIndex : 'Phone',
							width : 100,
							hidden : false
							
						},{
							id : 'EMail',
							header : '����',
							dataIndex : 'EMail',
							//align:'right',
							hidden:true,
							width : 80
						},{
							id : 'Degree',
							header : 'ѧλ',
							dataIndex : 'Degree',
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
    
	ParticipantsInfo.load({params : {start : 0,limit : 25,HeadDR:HeadDR}});
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