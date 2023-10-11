
 ParticipantsInfoList = function(participantsdrs){
	
	var ParticipantsInfoGrid = new dhc.herp.GridP({
				title : "���������Ա��Ϣ",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.srmprojectsapplyexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'Name',
							header : '����',
							dataIndex : 'Name',
							width : 120,
							align : 'center',
							editable:false
						}, {
							id : 'CreditID',
							header : '���֤��',
							dataIndex : 'CreditID',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'BirthDay',
							header : '��������',
							dataIndex : 'BirthDay',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Sex',
							header : '�Ա�',
							dataIndex : 'Sex',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'TitleInfo',
							header : 'ְ��',
							dataIndex : 'TitleInfo',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Degree',
							header : 'ѧλ',
							dataIndex : 'Degree',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Dept',
							header : '����רҵ',
							dataIndex : 'Dept',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Comp',
							header : '��λ����',
							dataIndex : 'Comp',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Tel',
							header : '�绰',
							dataIndex : 'Tel',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Email',
							header : '��������',
							dataIndex : 'Email',
							width : 120,
              editable:false,
							align : 'center'
						}]    
			});
		ParticipantsInfoGrid.btnAddHide();  //�������Ӱ�ť
   	ParticipantsInfoGrid.btnSaveHide();  //���ر��水ť
    ParticipantsInfoGrid.btnResetHide();  //�������ð�ť
    ParticipantsInfoGrid.btnDeleteHide(); //����ɾ����ť
    ParticipantsInfoGrid.btnPrintHide();  //���ش�ӡ��ť
    
	ParticipantsInfoGrid.load({params:{start:0,limit:15,participantsdrs:participantsdrs}})
	
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
				items : [ParticipantsInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '���������Ա��Ϣ',
				plain : true,
				width : 468,
				height : 300,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}