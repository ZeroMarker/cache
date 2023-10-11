
//连接报表Query
function Query() {
	//alert(bookID);

	////Schem	简历查询方案的grid
	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls: 'maintain',
			region: 'center',
			url: 'herp.acct.acctmulticolumnaccountexe.csp',
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
					header: '<div style="text-align:center">方案编码</div>',
					width: 100,
					align: 'left',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案内容</div>',
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

	SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">说明：科目多栏账-金额式的方案编号以ZB0401开头。</div>');


	//////////////科目多栏账查询条件start//////////
	//----------------- 会计科目---------------//

	var SubjCodeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeName'])
		});
	SubjCodeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.acctmulticolumnaccountexe.csp?action=GetAcctSubj&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCode').getRawValue(),
				method: 'POST'
			});
	});

	var AcctSubjCode = new Ext.form.ComboBox({
			id: 'AcctSubjCode',
			fieldLabel: '会计科目',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'subjCode',
			displayField: 'subjCodeName',
			width: 180,
			listWidth: 220,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	/////////会计年度////////
	var YearDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'year', 'month', 'AcctYearMonth'])
		});
	YearDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.acctmulticolumnaccountexe.csp?action=GetAcctYear&bookID=' + bookID + '&str=' + Ext.getCmp('AcctYear').getRawValue(),
				method: 'POST'
			});
	});

	var AcctYear = new Ext.form.ComboBox({
			id: 'AcctYear',
			fieldLabel: '会计年度',
			labelSeparator:'',
			store: YearDs,
			valueField: 'year',
			displayField: 'year',
			width: 180,
			listWidth: 220,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	/////////会计月份////////
	var MonthDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
				['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
				['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
		});

	var AcctMonthStrat = new Ext.form.ComboBox({
			id: 'AcctMonthStrat',
			fieldLabel: '月',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: MonthDs,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // 本地模式
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
			//resizable:true
		});
	var AcctMonthEnd = new Ext.form.ComboBox({
			id: 'AcctMonthEnd',
			fieldLabel: '月',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: MonthDs,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // 本地模式
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
		});

	//是否包含为记账
	var StateField = new Ext.form.Checkbox({
			id: 'StateField',
			fieldLabel: '包含未记账',
			labelSeparator:'',
			allowBlank: false,
			width: 30
		});

	//////////////科目多栏账查询条件end//////////

	//============================分割线==================================================//
	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '查询条件',
			iconCls: 'find',
			width: 350,
			frame: true,
			region: 'east',
			labelWidth: 115,
			labelSeparator:'',
			//buttonAlign: 'center',
			//closable: true, //这个属性就可以控制关闭该from
			items: []
		});
	var CodeStr = "";
	var ConfigItems = [];
	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		alert(11);
		var object = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = object[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {

			var code = object[0].get("code");
			if (code === "ZB0401") {
				if (CodeStr === code)
					return;
				var TempItems = [{
						xtype: 'fieldset',
						id: 'ZB0401_Item0',
						items: [AcctSubjCode, AcctYear, AcctMonthStrat, AcctMonthEnd]
					}, {
						xtype: 'button',
						id: 'ZB0401_Item1',
						text: '确&nbsp;&nbsp;定',
						handler: function () {
							FindQuery(code);
						}
					}
				];
				ChangeItems(code, TempItems);
			}
		}
	});

	//替换panel中的组件
	function ChangeItems(code, TempItems) {
		if (CodeStr !== "") {
			for (var i = 0; i < ConfigItems.length; i++) {
				frm.remove(Ext.getCmp(CodeStr + '_Item' + i), false);
				Ext.getCmp(CodeStr + '_Item' + i).setVisible(false);
			}
			frm.doLayout();
		}
		CodeStr = code;
		ConfigItems = TempItems.slice(); ////splice() 方法用于插入、删除或替换数组的元素。

		for (var j = 0; j < ConfigItems.length; j++)
			frm.add(ConfigItems[j]);
		frm.doLayout();
		return;
	}
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
			width: 800,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: fullForm,
			buttons: [{
					text: '关闭',
					handler: function () {
						window.close();
					}
				}
			]

		});
	window.show();

	function FindQuery(code) {

		// if(code==="ZB0401"){
		var SubjCode = Ext.getCmp('AcctSubjCode').getValue();
		var year = Ext.getCmp('AcctYear').getValue();
		var month1 = Ext.getCmp('AcctMonthStrat').getValue();
		var month2 = Ext.getCmp('AcctMonthEnd').getValue();
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.MultiColumnAccount.raq&&SubjCode=' + SubjCode +
			'&year=' + year + '&month1=' + month1 + '&month2=' + month2 + '&userdr=' + userdr;
		reportFrame.src = p_URL;
		//   }

	}

}
