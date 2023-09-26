
StatesDetail = function(title,schemmainrowid){
	//alert(schemmainrowid);
var stateGrid = new dhc.herp.stateGrid({
            region : 'center',
		    url: 'dhc.pa.basicuintpacaluexe.csp',
			fields : [
			       new Ext.grid.CheckboxSelectionModel({hidden : true,editable:false}),
			       {
						header : '����ID',
						dataIndex : 'periodchkrowid',
						editable:false,
						hidden : true
					}, {
						id : 'chkresult',
						header : '����״̬',
						width : 100,
						editable:false,
						dataIndex : 'chkresult'

					},{
						id : 'chercker',
						header : '������',
						editable:false,
						width : 80,
						dataIndex : 'chercker'

					},{
						id : 'cherckdate',
						header : '����ʱ��',
						editable:false,
						width : 80,
						dataIndex : 'cherckdate'

					},{
						id : 'chkdeptname',
						header : '����',
						editable:false,
						width : 100,
						dataIndex : 'chkdeptname'

					}, {
						id : 'desc',
						header : '�������',
						editable:false,
						width : 200,
						dataIndex : 'desc'

					}],

						split : true,
						collapsible : true,
						containerScroll : true,
						xtype : 'grid',
						trackMouseOver : true,
						stripeRows : true,
						sm : new Ext.grid.RowSelectionModel({
									singleSelect : true
								}),
						loadMask : true,
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    stateGrid.btnAddHide();  //�������Ӱ�ť
   	stateGrid.btnSaveHide();  //���ر��水ť
    stateGrid.btnResetHide();  //�������ð�ť
    stateGrid.btnDeleteHide(); //����ɾ����ť
    stateGrid.btnPrintHide();  //���ش�ӡ��ť
	
	stateGrid.load({params:{start:0,limit:15,schemrowid:schemmainrowid}})
	
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
				items : [stateGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : title+'--',
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
