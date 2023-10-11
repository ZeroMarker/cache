function Query() {

	////Schem	简历查询方案的grid
	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls:'maintain',
			region: 'center',
			url: 'herp.acct.Auxiliaryaccountamountexe.csp',
			split: true,
			viewConfig: {
				forceFit: true
			},
			fields: [//new Ext.grid.CheckboxSelectionModel({editable:false}),
				//  s jsonTitle=rowid^bookid^code^name^desc
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
					width: 50,
					allowBlank:false,
					align: 'left',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案名称</div>',
					allowBlank:false,
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
			bookID: bookID
		}
	});

	//SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">说明：辅助账总账-金额式的方案编号以ZB1101开头。</div>');
	SchemGrid.btnResetHide() //隐藏重置按钮
	SchemGrid.btnPrintHide() //隐藏打印按钮
	//=================================查询条件 FormPanel==========================//
	//期间范围

	var StartDate = new Ext.form.DateField({
			id: 'StartDate',
			name: 'StartDate',
			fieldLabel: '起始年月',
			labelSeparator:'',
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
			labelSeparator:'',
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
				url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetAcctSubj&bookId=' + bookID,
				method: 'POST'
			});
	});
	//辅助核算科目ComboBox
	var AcctSubj = new Ext.form.ComboBox({
			id: 'AcctSubj',
			fieldLabel: '辅助核算科目',
			store: AcctSubjDs,
			emptyText: '请选择辅助核算科目...',
			labelSeparator:'',
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
					if (AcctSubjID != "") {
						Ext.getCmp('CheckType').clearValue();
						Ext.getCmp('CheckItem').clearValue();
					}
					CheckTypeDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckType&AcctSubjID=' + Ext.getCmp('AcctSubj').getValue()+
						'&bookId=' + bookID,
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
				url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckType&AcctSubjID=' + Ext.getCmp('AcctSubj').getValue()+
						'&bookId=' + bookID,
				method: 'POST'
			});
	});
	//辅助核算类型ComboBox
	var CheckType = new Ext.form.ComboBox({
			fieldLabel: '辅助核算类型',
			id: 'CheckType',
			emptyText: '请选择辅助核算类型...',
			store: CheckTypeDs,
			valueField: 'rowid',
			labelSeparator:'',
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
					var IsValid = Ext.getCmp('IsValid').getValue();
					CheckItemDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckItem&AcctCheckTypeID=' + Ext.getCmp('CheckType').getValue() +
								'&IsValid=' + Ext.getCmp('IsValid').getValue() + '&bookId=' + bookID,
								method: 'POST'
							});
					});
					CheckItem.setValue("");
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
				url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckItem&AcctCheckTypeID=' + Ext.getCmp('CheckType').getValue() +
				'&IsValid=' + Ext.getCmp('IsValid').getValue() + '&bookId=' + bookID,
				method: 'POST'
			});
	});
	//辅助核算项
	var CheckItem = new Ext.form.ComboBox({
			fieldLabel: '辅助核算项',
			id: 'CheckItem',
			labelSeparator:'',
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

	//----------------- 包含停用辅助核算项-----------------//
	var IsValid = new Ext.form.Checkbox({
			fieldLabel: '包含停用辅助核算项',
			id: 'IsValid',
			labelSeparator:'',
			name: 'IsValid',
			style: 'border:0;background:none;margin-top:0px;',
			//checked:true,
			labelAlign: 'right'
		});
	//----------------- 包含未记账凭证-----------------//
	var VouchState = new Ext.form.Checkbox({
			fieldLabel: '包含未记账凭证',
			id: 'VouchState',
			labelSeparator:'',
			name: 'VouchState',
			style: 'border:0;background:none;margin-top:0px;',
			labelAlign: 'right'
		});
	//----------------- 余额为零且发生额为零不显示-----------------//
	var IsZero = new Ext.form.Checkbox({
			fieldLabel: '余额为0且发生额为0不显示',
			id: 'IsZero',
			name: 'IsZero',
			labelSeparator:'',
			style: 'border:0;background:none;margin-top:0px;',
			labelAlign: 'right'
		});
	//----------------- 向后连续n个辅助核算项-----------------//
	var IsTop = new Ext.form.TextField({
			id: 'IsTop',
			width: 100,
			triggerAction: 'all',
			labelSeparator:'',
			fieldLabel: '连续辅助核算项个数',
			style: 'text-align:left',
			name: 'IsTop',
			editable: true
		});
	//////////////辅助账总账-金额式查询条件end//////////
	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '查询条件',
			iconCls:'find',
			width: 470,
			frame: true,
			region: 'east',
			labelWidth: 180,
			//buttonAlign: 'center',

			//closable: true, //这个属性就可以控制关闭该from
			items: [{
					xtype: 'fieldset',
					//title : '报表类型',
					style:'padding:5px;',
					items: [StartDate, EndDate, IsTop, AcctSubj, CheckType, CheckItem, IsValid, VouchState, IsZero]
				}, {
					xtype: 'button',
					//margin-top:12,
					//style:"margin:auto;",
					style: "marginLeft:45%;",
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
			//alert(SchemDesc);
			var arr = SchemDesc.split(";");
			var startdate = arr[0];
			var enddate = arr[1];
			//var acctsubj = arr[2];
			//var checktype=arr[3];
			//var checkitem=arr[4];
			var isvalid = arr[5];
			var istop = arr[6];
			var vouchstate = arr[7];
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
			CheckTypeDs.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckType&AcctSubjID=' + AcctSubjID+
						'&bookId=' + bookID,
					method: 'POST'
				});
			});
			CheckItemDs.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckItem&AcctCheckTypeID=' + AcctCheckTypeID +
					'&IsValid=' + isvalid + '&bookId=' + bookID,
					method: 'POST'
				});
			});
			setTimeout(function () {
				StartDate.setValue(startdate);
				EndDate.setValue(enddate);
				AcctSubj.setValue(acctsubj);
				CheckType.setValue(arr[3]);
				CheckItem.setValue(arr[4]);
				IsValid.setValue(isvalid);
				IsTop.setValue(istop);
				VouchState.setValue(vouchstate);
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
			width: 1000,
			height: 500,
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
		var StartDate = Ext.getCmp('StartDate').getRawValue();
		var EndDate = Ext.getCmp('EndDate').getRawValue();
		var AcctSubj = Ext.getCmp('AcctSubj').getValue();
		AcctSubj = AcctSubj.split("-")[0];
		var CheckType = Ext.getCmp('CheckType').getValue();
		CheckType = CheckType.split(" ")[0];
		var CheckItem = Ext.getCmp('CheckItem').getValue();
		CheckItem = CheckItem.split(" ")[0];
		var IsValid = Ext.getCmp('IsValid').getValue();
		var VouchState = Ext.getCmp('VouchState').getValue();
		var IsZero = Ext.getCmp('IsZero').getValue();
		var IsTop = Ext.getCmp('IsTop').getValue();
		//alert(CheckItem)

		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径
		//SubjName,StartDate,EndDate,VouchState,IsZero,CheckType,CheckItem,IsValid,IsTop,USERID
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.uAuxiliaryaccountamount.raq&SubjName=' + AcctSubj + '&StartDate=' + StartDate +
			'&EndDate=' + EndDate + '&VouchState=' + VouchState + '&IsZero=' + IsZero + '&CheckType=' + CheckType + '&CheckItem=' + CheckItem +
			'&IsValid=' + IsValid + '&IsTop=' + IsTop + '&USERID=' + userdr;
		reportFrame.src = p_URL;

	}

}
