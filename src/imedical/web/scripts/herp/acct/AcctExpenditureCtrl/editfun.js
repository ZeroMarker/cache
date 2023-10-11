EditFun = function (itemGrid) {

	var username = session['LOGON.USERNAME'];
	var userId = session['LOGON.USERID'];
	Username = userId + '_' + username;
	var billcode = "";
	var statetitle = name + "֧������";

	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var rowidm = selectedRow[0].data['rowid'];
	var yearmonth = selectedRow[0].data['checkyearmonth'];
	var billcode = selectedRow[0].data['billcode'];
	var dname = selectedRow[0].data['dname'];
	var uname = selectedRow[0].data['applyer'];
	var mdesc = selectedRow[0].data['applydecl'];
	var deptdr = selectedRow[0].data['deprdr'];
	var applycode = selectedRow[0].data['applycode'];
	dname = deptdr + '_' + dname;
	var billstate = selectedRow[0].data['billstate'];
	var audeprdr = selectedRow[0].data['audeprdr'];
	var audname = selectedRow[0].data['audname'];
	var audname = audeprdr + '_' + audname;
	var CheckDR = selectedRow[0].data['CheckDR'];
	var FundSour = selectedRow[0].data['FundSour'];

	/////////////////////��������/////////////////////////
	var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : billcode,
			disabled : true,
			selectOnFocus : true

		});
	/////////////////////������/////////////////////////
	var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : uname,
			disabled : true,
			selectOnFocus : true

		});
	/////////////////////����˵��/////////////////////////
	Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : mdesc,
			disabled : true,
			selectOnFocus : true
		});
	/////////////////////Ԥ����/////////////////////////
	var timeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['yearmonth', 'yearmonth'])
		});

	timeDs.on('beforeload', function (ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.acct.expenseaccountdetailexe.csp?action=timelist',
				method : 'POST'
			});
	});

	timeCombo = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ����',
			store : timeDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			disabled : false,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			value : yearmonth,
			emptyText : '��ѡ��...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			disabled : true,
			selectOnFocus : true
		});

	/////////////////////��������/////////////////////////
	var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : dname,
			emptyText : '�س����ɿ���...',
			disabled : true,
			selectOnFocus : true

		});
	///////////////////////�ʽ����뵥��/////////////////////
	var applyDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'applycode'])
		});

	applyDs.on('beforeload', function (ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.acct.expenseaccountdetailexe.csp?action=applycode&&userdr=' + userId,
				method : 'POST'
			});
	});

	applyCombo = new Ext.form.ComboBox({
			fieldLabel : '�ʽ����뵥��',
			store : applyDs,
			displayField : 'applycode',
			valueField : 'rowid',
			disabled : true,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 90,
			value : applycode,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

	applyCombo.on('focus', function (f) {
		AddReqFun(applyCombo);
	});

	///////////////��ڿ���////////////////////////
	var audnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
		});

	audnameDs.on('beforeload', function (ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=1',
				method : 'POST'
			});
	});

	var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '��ڿ���',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			value : audname,
			typeAhead : true,
			disabled : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true

		});
	////////////������//////////////////////
	var checkflowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
		});

	checkflowDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=checkflowlist',
				method : 'POST'
			});
	});

	var checkflowField = new Ext.form.ComboBox({
			fieldLabel : '������',
			store : checkflowDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value : CheckDR,
			disabled : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true

		});
	/////////////////////�ʽ���Դ////////////////////////////
	var fundsourceStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�ֽ�'], ['2', '����']]
		});
	var fundsourceField = new Ext.form.ComboBox({
			id : 'fundsourceField',
			fieldLabel : '�ʽ���Դ',
			width : 120,
			allowBlank : false,
			store : fundsourceStore,
			value : FundSour,
			anchor : '90%',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : 'ѡ��...',
			mode : 'local', // ����ģʽ
			pageSize : 10,
			minChars : 15,
			columnWidth : .15,
			selectOnFocus : true,
			disabled : true,
			forceSelection : true
		});

	var queryPanel = new Ext.FormPanel({
			height : 120,
			region : 'north',
			frame : true,
			defaults : {
				bodyStyle : 'padding:5px'
			},
			items : [{
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [{
							xtype : 'displayfield',
							value : '��������:',
							columnWidth : .12
						}, applyNo, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '��������:',
							columnWidth : .12
						}, dnamefield, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '������:',
							columnWidth : .12
						}, appuName

					]
				}, {
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [{
							xtype : 'displayfield',
							value : '����˵��:',
							columnWidth : .12
						}, Descfield, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : 'Ԥ����:',
							columnWidth : .12
						}, timeCombo, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '�ʽ����뵥��:',
							columnWidth : .12
						}, applyCombo

					]
				}, {
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [{
							xtype : 'displayfield',
							value : '��ڿ���:',
							columnWidth : .12
						}, audnamefield, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '������:',
							columnWidth : .12
						}, checkflowField, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '�ʽ���Դ:',
							columnWidth : .12
						}, fundsourceField
					]
				}
			]
		});



	var editGrid = new dhc.herp.GridDetail({
			width : 600,
			height : 150,
			region : 'center',
			url : 'herp.acct.acctexpenditurectrlexe.csp', //'herp.acct.expenseaccountdetailexe.csp',
			fields : [{
					header : 'ID',
					width : 30,
					editable : false,
					dataIndex : 'rowid',
					hidden : true
				}, {
					id : 'billdr',
					header : '��������ID',
					dataIndex : 'billdr',
					width : 120,
					hidden : true
				}, {
					id : 'itemcode',
					header : 'Ԥ�������',
					dataIndex : 'itemcode',
					hidden : true,
					width : 120
				}, {
					id : 'itemname',
					header : 'Ԥ����',
					dataIndex : 'itemname',
					editable : false,
					width : 120
				}, {
					id : 'balance',
					header : '��ǰԤ�����',
					dataIndex : 'balance',
					align : 'right',
					xtype : 'numbercolumn',
					width : 120,
					editable : false
				}, {
					id : 'reqpay',
					header : '���α�������',
					dataIndex : 'reqpay',
					align : 'right',
					editable : false,
					xtype : 'numbercolumn',
					renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
						cellmeta.css = "cellColor3"; // ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
						return '<span style="color:black;cursor:hand;backgroundColor:red">' + value + '</span>';
					},
					width : 120
				}, {
					id : 'actpay',
					header : '����֧��',
					align : 'right',
					xtype : 'numbercolumn',
					renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
						cellmeta.css = "cellColor3"; // ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
						return '<span style="color:black;cursor:hand;backgroundColor:red">' + value + '</span>';
					},
					dataIndex : 'actpay',
					editable : false,
					width : 120
				}, {
					id : 'balance1',
					header : '������Ԥ�����',
					dataIndex : 'balance1',
					align : 'right',
					xtype : 'numbercolumn',
					editable : false,
					width : 120

				}, {
					id : 'budgcotrol',
					header : 'Ԥ�����',
					dataIndex : 'budgcotrol',
					width : 100,
					renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
						var sf = record.data['budgcotrol']
							if (sf == "��Ԥ��") {
								return '<span style="color:red;cursor:hand;">' + value + '</span>';
							} else {
								return '<span style="color:black;cursor:hand">' + value + '</span>';
							}
					},
					editable : false
				}, {
					id : 'State',
					header : '״̬',
					dataIndex : 'State',
					editable : false,
					width : 80
				}
			],
			viewConfig : {
				forceFit : true
			}
		});
	editGrid.load({
		params : {
			start : 0,
			limit : 25,
			billcode : billcode
		}
	});



	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
			text : '�ر�',
			iconCls:'cancel'
		});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function () {
		window.close();
		/* itemGrid.load({
			params : {
				start : 0,
				limit : 12,
				userdr : userId
			}
		}); */
	};

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			layout : 'fit',
			labelWidth : 100,
			items : [queryPanel, editGrid]
		});

	var tabPanel = new Ext.Panel({
			//activeTab: 0,
			layout : 'border',
			region : 'center',
			items : [queryPanel, editGrid]//���Tabs
		});

	var window = new Ext.Window({
			layout : 'fit',
			title : '��������',
			plain : true,
			width : 950,
			height : 500,
			modal : true,
			buttonAlign : 'center',
			items : tabPanel,
			buttons : [cancelButton]

		});

	window.show();

};