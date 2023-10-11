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
					header: '凭证ID',
					align: 'center',
					width: 40,
					hidden: true,
					editable: false,
					dataIndex: 'AcctVouchID'
				}, {
					id: 'VouchNo',
					header: '凭证号',
					align: 'center',
					width: 120,
					editable: false,
					renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
						return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
					},
					dataIndex: 'VouchNo'
				}, {
					id: 'AcctYear',
					header: '年',
					align: 'center',
					width: 80,
					editable: false,
					dataIndex: 'AcctYear'
				}, {
					id: 'AcctMonth',
					header: '月',
					align: 'center',
					width: 80,
					editable: false,
					dataIndex: 'AcctMonth'
				}, {
					id: 'MakeBillDate',
					header: '制单日期',
					align: 'center',
					width: 120,
					editable: false,
					dataIndex: 'MakeBillDate'
				}, {
					id: 'IsCancelWord',
					header: '凭证作废',
					align: 'center',
					width: 100,
					renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
						return '<span style="color:red;">' + value + '</span>';
					},
					editable: false,
					dataIndex: 'IsCancelWord'
				}, {
					id: 'CancelDate',
					header: '作废时间',
					align: 'center',
					width: 200,
					// hidden:true,
					editable: false,
					dataIndex: 'CancelDate'
				}, {
					id: 'VouchState',
					header: '凭证状态',
					align: 'center',
					width: 100,
					hidden: true,
					editable: false,
					dataIndex: 'VouchState'
				}, {
					id: 'OperatorID',
					header: '操作人ID',
					align: 'center',
					width: 150,
					hidden: true,
					editable: false,
					dataIndex: 'OperatorID'
				}, {
					id: 'OperatorName',
					header: '制单人',
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

	// 初始化面板
	var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			layout: 'fit',
			labelWidth: 100,
			items: [CancelVouchGrid]
		});
	var win = new Ext.Window({
			title: '作废凭证',
			layout: 'fit',
			plain: true,
			width: 800,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: formPanel,
			buttons: [{
					text: '关闭',
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
					title: '凭证查看',
					width: 1093,
					height: 620,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // 表示为渲染window body的背景为透明的背景
					//bodyStyle : 'padding:5px;',
					items: [myPanel],
					buttonAlign: 'center',
					buttons: [{
							text: '关闭',
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

