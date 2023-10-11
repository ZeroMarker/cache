//连接报表Query
function Query() {

	////Schem	简历查询方案的grid
	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls:'maintain',
			region: 'center',
			url: 'herp.acct.acctsubjledgreportexe.csp',
			split: true,
			atLoad: true,
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
					align: 'left',
					allowBlank: false,
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案名称</div>',
					width: 140,
					align: 'left',
					allowBlank: false,
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

	// SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">说明：科目总账-外币金额式的方案编号以ZB0103开头。</div>');
	SchemGrid.btnResetHide() //隐藏重置按钮
	SchemGrid.btnPrintHide() //隐藏打印按钮


	//////////////科目总账金额式、数量金额式、外币金额式查询条件start//////////
	//----------取科目编码、名称-----------//
	var SubjCodeNameProxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctsubjledgreportexe.csp?action=GetSubjCodeNameCur&bookID=' + bookID, //&subjstr='+SubjCodeNameField1.getValue(),	//Ext.getCmp('SubjCodeNameField1').getRawValue(),
			method: 'POST'
		});
	var SubjCodeNameDS = new Ext.data.Store({
			proxy: SubjCodeNameProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			},
				['subjCode', 'subjCodeNameAll']),
			remoteSort: true
		});

	var SubjCodeNameField1 = new Ext.form.ComboBox({
			id: 'SubjCodeNameField1',
			store: SubjCodeNameDS,
			displayField: 'subjCodeNameAll',
			valueField: 'subjCode',
			fieldLabel: '科目范围',
			width: 200,
			listWidth: 270,
			pageSize: 10,
			minChars: 1,
			emptyText: '请选择...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});
	var SubjCodeNameField2 = new Ext.form.ComboBox({
			id: 'SubjCodeNameField2',
			store: SubjCodeNameDS,
			displayField: 'subjCodeNameAll',
			valueField: 'subjCode',
			width: 200,
			listWidth: 270,
			pageSize: 10,
			minChars: 1,
			emptyText: '请选择...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//-----------科目级次------------//
	var SubjLevelStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyvalue'],
			data: [['1', '1级'], ['2', '2级'], ['3', '3级'], ['4', '4级'], ['5', '5级'], ['6', '6级'], ['7', '7级'], ['8', '8级']]
		});
	var SubjLevelField = new Ext.form.ComboBox({
			id: 'SubjLevelField',
			width: 90,
			store: SubjLevelStore,
			displayField: 'keyvalue',
			valueField: 'key',
			fieldLabel: '科目级次',
			value: '1', //设默认值
			triggerAction: 'all',
			mode: 'local',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});
	//----------------会计年度-----------//
	var AcctYearProxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctsubjledgreportexe.csp?action=GetAcctYear&bookID=' + bookID
		});
	var AcctYearDS = new Ext.data.Store({
			proxy: AcctYearProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			}, ['year', 'yearh']),
			remoteSort: true
		});

	var AcctYearField = new Ext.form.ComboBox({
			id: 'AcctYearField',
			store: AcctYearDS,
			displayField: 'yearh',
			valueField: 'year',
			fieldLabel: '会计年月',
			width: 90,
			listWidth: 187,
			pageSize: 10,
			minChars: 1,
			emptyText: '请选择...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//------------月份-------------//
	var MonthStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyvalue'],
			data: [['01', '1月'], ['02', '2月'], ['03', '3月'], ['04', '4月'], ['05', '5月'], ['06', '6月'],
				['07', '7月'], ['08', '8月'], ['09', '9月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
		});
	var AcctMonthField = new Ext.form.ComboBox({
			id: 'AcctMonthField',
			width: 90,
			store: MonthStore,
			displayField: 'keyvalue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local',
			emptyText: '请选择...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true

		});
	//------------包含未记账复选框-------------//
	var VouchStateField = new Ext.form.Checkbox({
			id: "VouchStateField",
			name: 'EndSumFlagField',
			fieldLabel: '<div style="padding-top:2px;">包含未记账:</div>',
			labelSeparator: '', //去掉冒号
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------余额为零且发生额为零不显示复选框-------------//
	var EndSumFlagField = new Ext.form.Checkbox({
			id: "EndSumFlagField",
			fieldLabel: '<div style="padding-top:2px;">余额为0且发生额为0不显示:</div>',
			labelSeparator: '', //去掉冒号
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});

	//////////////科目总账金额式、数量金额式、外币金额式查询条件end//////////


	var frm = new Ext.form.FormPanel({

			title: '查询条件',
			iconCls:'find',
			width: 480,
			frame: true,
			region: 'east',
			// labelAlign: 'right',
			// labelWidth : 115,
			// buttonAlign: 'center',
			defaults: {
				style: 'padding:5px 0 0 5px;'
			},
			closable: true, //这个属性就可以控制关闭该from
			items: [{
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 500,
					items: [{
							xtype: 'tbtext',
							text: '科目范围',
							style: 'text-align:right;padding:5px;',
							columnWidth: .7
						}, SubjCodeNameField1]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '',
							style: 'text-align:right;padding:5px;',
							columnWidth: .7
						}, SubjCodeNameField2]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '科目级次',
							style: 'text-align:right;padding:5px;',
							columnWidth: .5
						}, SubjLevelField]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '会计年月',
							style: 'text-align:right;padding:5px;',
							columnWidth: .5
						}, AcctYearField]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '',
							style: 'text-align:right;padding:5px;',
							columnWidth: .5
						}, AcctMonthField]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '包含未记账',
							style: 'text-align:right;padding:2px 5px;',
							columnWidth: .42
						}, VouchStateField
					]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '余额为0且发生额为0不显示',
							style: 'text-align:right;padding:2px 5px;',
							columnWidth: .42
						}, EndSumFlagField
					]
				},  {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'button',
							style: "marginLeft:40%;", //marginLeft:170px
							width: 55,
							iconCls: 'find',
							text: '查询',
							handler: function () {

								FindQuery();
							}
						}
					]
				}
			]

		});


	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		var object = SchemGrid.getSelectionModel().getSelections();
		var id = object[0].get("rowid");
		if (id == "" || id == null || id == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = object[0].get("desc");
			var arr = SchemDesc.split(";");
			SubjCodeNameField1.setValue(arr[0]);
			SubjCodeNameField2.setValue(arr[1]);
			SubjLevelField.setValue(arr[2]);
			AcctYearField.setValue(arr[3]);
			AcctMonthField.setValue(arr[4]);
			if (arr[5] == 1) {
				VouchStateField.setValue(1);
			} else {
				VouchStateField.setValue(0);
			}
			if (arr[6] == 1) {
				EndSumFlagField.setValue(1);
			} else {
				EndSumFlagField.setValue(0);
			}
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
			width: 950,
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

		//
		var AcctSubjCode1 = Ext.getCmp('SubjCodeNameField1').getValue();
		AcctSubjCode1 = AcctSubjCode1.split(" ")[0];
		var AcctSubjCode2 = Ext.getCmp('SubjCodeNameField2').getValue();
		AcctSubjCode2 = AcctSubjCode2.split(" ")[0];
		var SubjLevel = Ext.getCmp('SubjLevelField').getValue();
		var AcctYear = Ext.getCmp('AcctYearField').getValue();
		var AcctMonth = Ext.getCmp('AcctMonthField').getValue();
		var VouchState = VouchStateField.getValue();
		if (VouchState == "")
			VouchState = 0;
		else
			VouchState = 1;
		var EndSumFlag = EndSumFlagField.getValue();
		if (EndSumFlag == "")
			EndSumFlag = 0;
		else
			EndSumFlag = 1;
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctSubjCurAmountForm.raq&AcctSubjCode1=' + AcctSubjCode1 + '&AcctSubjCode2=' + AcctSubjCode2
			 + '&SubjLevel=' + SubjLevel + '&Year=' + AcctYear + '&Month=' + AcctMonth + '&VouchState=' + VouchState + '&EndSumFlag=' + EndSumFlag + '&USERID=' + userdr;
		reportFrame.src = p_URL;

	}

}
