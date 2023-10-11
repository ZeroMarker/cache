function Query() {

	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls: 'maintain',
			region: 'center',
			//atLoad:true,
			url: 'herp.acct.acctAuxiliarytrendanalysisexe.csp',
			// split : true,
			viewConfig: {
				forceFit: true
			},
			fields: [//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
					id: 'rowid',
					header: 'ID',
					width: 100,
					editable: false,
					hidden: true,
					dataIndex: 'rowid'
				}, {
					id: 'bookid',
					header: '<div style="text-align:center">账套id</div>',
					align: 'right',
					editable: false,
					width: 140,
					hidden: true,
					dataIndex: 'bookid'
				}, {
					id: 'code',
					header: '<div style="text-align:center">方案编号</div>',
					allowBlank: false,
					width: 50,
					align: 'center',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案名称</div>',
					allowBlank: false,
					width: 140,
					align: 'left',
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '方案描述',
					width: 220,
					allowBlank: true,
					hidden: true,
					dataIndex: 'desc'
				}
			]
		});

	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookId: bookID
		}
	});

	//SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">说明:辅助核算分析-趋势分析的方案编号以AN0202开头。</div>');
	SchemGrid.btnResetHide(); //隐藏重置按钮
	SchemGrid.btnPrintHide(); //隐藏打印按钮
	//=================================查询条件 FormPanel==========================//
	//期间范围

	var StartDate = new Ext.form.DateField({
			id: 'StartDate',
			name: 'StartDate',
			fieldLabel: '起始年月',
			labelSeparator: '',
			emptyMsg: "",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});
	var EndDate = new Ext.form.DateField({
			id: 'EndDate',
			name: 'EndDate',
			fieldLabel: '终止年月',
			labelSeparator: '',
			emptyMsg: "",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});
	//----------------- 辅助核算科目---------------//
	//辅助核算科目store
	var AcctSubjDs = new Ext.data.Store({
			//autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'name'])
		});
	AcctSubjDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetAcctSubj&bookId=' + bookID+'&str='+encodeURIComponent(Ext.getCmp('AcctSubj').getRawValue().trim()),
				method: 'POST'
			});
	});
	//辅助核算科目ComboBox
	var AcctSubj = new Ext.form.ComboBox({
			id: 'AcctSubj',
			fieldLabel: '辅助核算科目',
			labelSeparator: '',
			store: AcctSubjDs,
			emptyText: '请选择辅助核算科目...',
			valueField: 'rowid',
			displayField: 'name',
			width: 245,
			listWidth: 500,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			//resizable:true,
			typeAhead: true,
			listeners: {
				select: function () {
					var AcctSubjID = Ext.getCmp('AcctSubj').getValue();
					CheckTypeDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetCheckType&AcctSubjID=' + AcctSubjID+'&bookId=' + bookID,
								method: 'POST'
							});
					});
					CheckType.setValue("");
					CheckTypeDs.load({
						params: {
							start: 0,
							limit: 10
						}
					});
				}
			}
		});

	//----------------- 辅助核算类型-----------------//
	var CheckTypeDs = new Ext.data.Store({
			//autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'name'])
			//remoteSort: false
		});
	CheckTypeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetCheckType&AcctSubjID=' + Ext.getCmp('AcctSubj').getValue() +'&bookId=' + bookID,
				method: 'POST'
			});
	});
	//辅助核算类型ComboBox
	var CheckType = new Ext.form.ComboBox({
			fieldLabel: '辅助核算类型',
			labelSeparator: '',
			id: 'CheckType',
			emptyText: '请选择辅助核算类型...',
			store: CheckTypeDs,
			valueField: 'rowid',
			displayField: 'name',
			width: 245,
			listWidth: 250,
			triggerAction: 'all',
			//mode: 'local', //本地模式
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			//resizable:true,
			typeAhead: true,
			listeners: {
				select: function () {
					var AcctCheckTypeID = Ext.getCmp('CheckType').getValue();
					CheckItemDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetCheckItem&AcctCheckTypeID=' + Ext.getCmp('CheckType').getValue() +
								'&bookId=' + bookID,
								method: 'POST'
							});
					});
					CheckItem1.setValue("");
					CheckItem2.setValue("");
					CheckItemDs.load({
						params: {
							start: 0,
							limit: 10
						}
					});
				}
			}
		});

	//----------------- 辅助核算项-----------------//
	var CheckItemDs = new Ext.data.Store({
			//autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'name'])
		});
	CheckItemDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetCheckItem&AcctCheckTypeID=' + Ext.getCmp('CheckType').getValue() +
				'&bookId=' + bookID,
				method: 'POST'
			});
	});
	//辅助核算项
	var CheckItem1 = new Ext.form.ComboBox({
			fieldLabel: '辅助核算项',
			labelSeparator: '',
			id: 'CheckItem1',
			emptyText: '请选择辅助核算项...',
			store: CheckItemDs,
			valueField: 'rowid',
			displayField: 'name',
			width: 245,
			listWidth: 300,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			typeAhead: true
		});
	var CheckItem2 = new Ext.form.ComboBox({
			id: 'CheckItem2',
			emptyText: '请选择辅助核算项...',
			store: CheckItemDs,
			valueField: 'rowid',
			displayField: 'name',
			width: 245,
			listWidth: 300,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			typeAhead: true
		});

	//------------分析数据类型-------------//
	var AnalysisTypeStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyvalue'],
			data: [['1', '借方发生额'], ['2', '贷方发生额'], ['3', '借方发生额-贷方发生额'], ['4', '贷方发生额-借方发生额'], ['5', '借方期末余额'], ['6', '贷方期末余额']]
		});

	var AnalysisTypeField = new Ext.form.ComboBox({
			id: "AnalysisTypeField",
			fieldLabel: '分析数据类型',
			labelSeparator: '',
			store: AnalysisTypeStore,
			displayField: 'keyvalue',
			valueField: 'key',
			value: '1', //设默认值
			triggerAction: 'all',
			mode: 'local',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//----------------- 余额为零且发生额为零不显示-----------------//
	var IsZero = new Ext.form.Checkbox({
			fieldLabel: '金额为零不显示',
			labelSeparator: '',
			id: 'IsZero',
			name: 'IsZero',
			style: 'border:0;background:none;margin-top:0px;',
			labelAlign: 'right'
		});

	//////////////辅助核算分析-趋势分析查询条件end//////////
	var frm = new Ext.form.FormPanel({
			iconCls: 'find',
			labelAlign: 'right',
			title: '查询条件',
			width: 470,
			frame: true,
			region: 'east',
			labelWidth: 160,
			//buttonAlign: 'center',

			//closable: true, //这个属性就可以控制关闭该from
			items: [{
					xtype: 'fieldset',
					style:"padding:5px;",
					items: [StartDate, EndDate, AcctSubj, CheckType, CheckItem1, CheckItem2, AnalysisTypeField, IsZero]
				}, {
					xtype: 'button',
					style: "marginLeft:40%",
					width: 55,
					iconCls: 'find',
					text: '查询',
					handler: function () {
						FindQuery();
					}
				}
			]

		});

	SchemGrid.on('rowclick', function (grid, rowIndex, e) {

		var object = SchemGrid.getSelectionModel().getSelections();

		var rowObjID = object[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {
			var code = object[0].get("code");
			var SchemDesc = object[0].get("desc");
			var arr = SchemDesc.split(";");
			var startdate = arr[0];
			var enddate = arr[1];
			//var acctsubj=arr[2];
			//var checktype=arr[3];
			//var checkitem=arr[4];
			var AnalysisType = arr[6];
			var AnalysisTypeDs = arr[7];
			var iszero = arr[8];
			if (arr != "") {
				var acctsubj = arr[2];
				var AcctSubjID = acctsubj.split("-")[0];
				var checktype = arr[3];
				var AcctCheckTypeID = checktype.split(" ")[0];
			}
			AcctSubjDs.load({
				params: {
					start: 0,
					limit: 10
				}
			});
			//CheckTypeDs.load({params:{start:0,limit:10}});
			//CheckItemDs.load({params:{start:0,limit:10}});
			//CheckTypeDs.load({params:{start:0,limit:10,AcctSubjID:acctsubj}});
			CheckTypeDs.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
						url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetCheckType&AcctSubjID=' + AcctSubjID+
						'&bookId=' + bookID,
						method: 'POST'
					});
			});
			//CheckItemDs.load({params:{start:0,limit:10,IsValid:isvalid,AcctCheckTypeID:AcctCheckTypeID}});
			CheckItemDs.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
						url: '../csp/herp.acct.acctAuxiliarytrendanalysisexe.csp?action=GetCheckItem&AcctCheckTypeID=' + AcctCheckTypeID +
						'&bookId=' + bookID,
						method: 'POST'
					});
			});
			setTimeout(function () {
				StartDate.setValue(startdate);
				EndDate.setValue(enddate);
				AcctSubj.setValue(acctsubj);
				CheckType.setValue(arr[3]);
				CheckItem1.setValue(arr[4]);
				CheckItem2.setValue(arr[5]);
				AnalysisTypeField.setValue(AnalysisType);
				IsZero.setValue(iszero);

			}, 200);
		}
	});

	//能包含其他panel的是Ext.panel
	var fullForm = new Ext.Panel({
			//title: '查询方案管理',
			closable: true,
			border: true,
			layout: 'border',
			items: [SchemGrid, frm]
		});

	var window = new Ext.Window({
			// title: '查询方案管理',
			layout: 'fit',
			plain: true,
			width: 900,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: fullForm,
			buttons: [{
					text: '关闭',
					iconCls:'cancel',
					handler: function () {
						window.close();
					}
				}
			]

		});
	window.show();

	function FindQuery() {
		var StartDate = Ext.getCmp('StartDate').getRawValue()
			var EndDate = Ext.getCmp('EndDate').getRawValue()
			var AcctSubj = Ext.getCmp('AcctSubj').getValue();
		AcctSubj = AcctSubj.split("-")[0];
		var CheckType = Ext.getCmp('CheckType').getValue();
		CheckTypeCode = CheckType.split(" ")[0];
		CheckTypeName = CheckType.split(" ")[1];
		var CheckItem1 = Ext.getCmp('CheckItem1').getValue();
		CheckItem1 = CheckItem1.split(" ")[0];
		var CheckItem2 = Ext.getCmp('CheckItem2').getValue();
		CheckItem2 = CheckItem2.split(" ")[0];
		var AnalysisType = Ext.getCmp('AnalysisTypeField').getValue();
		var AnalysisTypeDs = Ext.getCmp('AnalysisTypeField').getRawValue();
		var IsZero = Ext.getCmp('IsZero').getValue();
		//alert(Ext.getCmp('AnalysisTypeField').getValue()+Ext.getCmp('CheckItem1').getValue())
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径
		//SubjName,StartDate,EndDate,IsZero,CheckType,CheckItem1,
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.acctAuxiliarytrendanalysis.raq&SubjName=' + AcctSubj + '&StartDate=' + StartDate +
			'&EndDate=' + EndDate + '&IsZero=' + IsZero + '&CheckTypeCode=' + CheckTypeCode + '&CheckTypeName=' + CheckTypeName + '&CheckItem1=' + CheckItem1 + '&CheckItem2=' + CheckItem2 + '&AnalysisType=' + AnalysisType + '&AnalysisTypeDs=' + AnalysisTypeDs + '&USERID=' + userdr;
		reportFrame.src = p_URL;

	}

}
