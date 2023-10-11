var LinkCancelVouch = function (data) {
	var CancelVouchGrid = new dhc.herp.Gridvouchprogress({
			region: 'center',
			url: projUrl,
			viewConfig: {
				forceFit: true
			},
			fields: [{
					id: 'AcctVouchOpLogID',
					header: 'AcctVouchOpLogID',
					align: 'center',
					width: 40,
					hidden: true,
					editable: false,
					dataIndex: 'AcctVouchOpLogID'
				},{
					id: 'AcctVouchID',
					header: 'ƾ֤ID',
					align: 'center',
					width: 40,
					hidden: true,
					editable: false,
					dataIndex: 'AcctVouchID'
				}, {
					id: 'VouchNo',
					header: 'ƾ֤��',
					align: 'center',
					width: 120,
					editable: false,
					renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
						return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
					},
					dataIndex: 'VouchNo'
				}, {
					id: 'AcctYear',
					header: '��',
					align: 'center',
					width: 80,
					editable: false,
					dataIndex: 'AcctYear'
				}, {
					id: 'AcctMonth',
					header: '��',
					align: 'center',
					width: 80,
					editable: false,
					dataIndex: 'AcctMonth'
				}, {
					id: 'MakeBillDate',
					header: '�Ƶ�����',
					align: 'center',
					width: 120,
					editable: false,
					dataIndex: 'MakeBillDate'
				}, {
					id: 'IsCancelWord',
					header: 'ƾ֤����',
					align: 'center',
					width: 100,
					renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
						return '<span style="color:red;">' + value + '</span>';
					},
					editable: false,
					dataIndex: 'IsCancelWord'
				}, {
					id: 'CancelDate',
					header: '����ʱ��',
					align: 'center',
					width: 200,
					// hidden:true,
					editable: false,
					dataIndex: 'CancelDate'
				}, {
					id: 'VouchState',
					header: 'ƾ֤״̬',
					align: 'center',
					width: 100,
					hidden: true,
					editable: false,
					dataIndex: 'VouchState'
				}, {
					id: 'OperatorID',
					header: '������ID',
					align: 'center',
					width: 150,
					hidden: true,
					editable: false,
					dataIndex: 'OperatorID'
				}, {
					id: 'OperatorName',
					header: '�Ƶ���',
					align: 'center',
					width: 160,
					editable: false,
					dataIndex: 'OperatorName'
				}
			]
		});

	CancelVouchGrid.load({
		params: {
			start: 0,
			limit: 25,
			data: data
		}

	});

	// ��ʼ�����
	var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			layout: 'fit',
			labelWidth: 100,
			items: [CancelVouchGrid]
		});
	var win = new Ext.Window({
			title: '����ƾ֤',
			layout: 'fit',
			plain: true,
			width: 800,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: formPanel,
			buttons: [{
					text: '�ر�',
					iconCls:'cancel',
					handler: function () {
						win.close();
					}
				}
			]

		});
	win.show();

	CancelVouchGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
		if (columnIndex == 3) {
			var records = CancelVouchGrid.getSelectionModel().getSelections();
			var VouchNo = records[0].get("VouchNo");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto",
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=11' + '&bookID=' + bookID + '&searchFlag=' + 1 + '" /></iframe>'
					//frame : true
				});
			var win = new Ext.Window({
					title: 'ƾ֤�鿴',
					width: 1093,
					height: 620,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
					//bodyStyle : 'padding:5px;',
					items: [myPanel],
					buttonAlign: 'center',
					buttons: [{
							text: '�ر�',
							type: 'button',
							handler: function () {
								win.close();
							}
						}
					]
				});
			win.show();
		}

	});

}

