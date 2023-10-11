
 HeadInfoList = function(headdr){
	
	var HeadInfoGrid = new dhc.herp.Grid({
				title : "���⸺������Ϣ",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.srmprojectsapplyexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'MonographNum',
							header : '����ר��',
							dataIndex : 'MonographNum',
							width : 60,
							align : 'center',
							editable:false
						}, {
							id : 'PaperNum',
							header : '��������',
							dataIndex : 'PaperNum',
							width : 60,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'PatentNum',
							header : 'ר��',
							dataIndex : 'PatentNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'InvInCustomStanNum',
							header : '�����ƶ�������׼',
							dataIndex : 'InvInCustomStanNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'TrainNum',
							header : '�����˲�',
							dataIndex : 'TrainNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'HoldTrainNum',
							header : '�ٰ���ѵ��',
							dataIndex : 'HoldTrainNum',
							width : 60,
              editable:false,
							align : 'center'
						}, {
							id : 'InTrainingNum',
							header : '������ѵ��',
							dataIndex : 'InTrainingNum',
							width : 60,
              editable:false,
							align : 'center'
						}]    
			});
		HeadInfoGrid.btnAddHide();  //�������Ӱ�ť
   	HeadInfoGrid.btnSaveHide();  //���ر��水ť
    HeadInfoGrid.btnResetHide();  //�������ð�ť
    HeadInfoGrid.btnDeleteHide(); //����ɾ����ť
    HeadInfoGrid.btnPrintHide();  //���ش�ӡ��ť
    
	HeadInfoGrid.load({params:{start:0,limit:15,headdr:headdr}})
	
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
				items : [HeadInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '���⸺������Ϣ',
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