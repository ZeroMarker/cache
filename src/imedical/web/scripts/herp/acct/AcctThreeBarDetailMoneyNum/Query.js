var projUrl = '../csp/herp.acct.acctThreeBarDetailMoneyNumexe.csp';
var bookID = GetAcctBookID();
var acctbookid = bookID;

var userdr = session['LOGON.USERID']; //登录人ID
//连接报表Query
//连接报表Query
function Query() {
	//查询方案Grid的定义
	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls:'maintain',
			region: 'center',
			atLoad: true,
			url: projUrl,
			split: true,
			//edit:false,
			viewConfig: {
				forceFit: true
			},
			fields: [
				//var json=rowid^bookid^code^name^desc
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
					width: 50,
					allowBlank:false,
					align: 'left',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案名称</div>',
					width: 140,
					align: 'left',
					allowBlank:false,
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '方案描述',
					width: 220,
					editable: false,
					allowBlank: true,
					hidden: true,
					dataIndex: 'desc'
				}
			]
		});
	//数据加载
	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookID: bookID
		}
	});
	SchemGrid.btnResetHide(); //隐藏重置按钮
	SchemGrid.btnPrintHide(); //隐藏打印按钮
	SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">说明：科目明细账-金额式的方案编号请以ZB0301开头。</div>');

	//============================分割线==================================================//


	//////////////科目三栏明细账查询条件start//////////

	//会计科目1
	var SubjCodeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'SubjCode', 'SubjName', 'SubjCodeName'])
		});
	SubjCodeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetNumAcctSubjZB0302&str=' + Ext.getCmp('AcctNumSubjCodeZB0302').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctSubjCodeA = new Ext.form.ComboBox({
			id: 'AcctSubjCodeA',
			fieldLabel: '会计科目',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'SubjCode',
			displayField: 'SubjCodeName',
			width: 220,
			listWidth: 260,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//会计科目2
	var AcctSubjCodeB = new Ext.form.ComboBox({
			id: 'AcctSubjCodeB',
			fieldLabel: '会计科目',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'SubjCode',
			displayField: 'SubjCodeName',
			width: 220,
			listWidth: 260,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//科目级别
	var SubjLevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [
				["1", '1'], ["2", '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
			]
		});
	var AcctSubjLevel = new Ext.form.ComboBox({
			id: 'AcctSubjLevel',
			fieldLabel: '科目级别',
			labelSeparator:'',
			width: 220,
			selectOnFocus: true,
			allowBlank: false,
			store: SubjLevelDs,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			emptyText: '请选择录入科目级别',
			selectOnFocus: true,
			forceSelection: true
		});

	//**会计年度**//
	var YearDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['AcctYear'])
		});
	YearDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetAcctYearZB0301&&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctYearField = new Ext.form.ComboBox({
			id: 'AcctYearField',
			fieldLabel: '会计年度',
			labelSeparator:'',
			store: YearDs,
			valueField: 'AcctYear',
			displayField: 'AcctYear',
			width: 220,
			listWidth: 250,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//**会计月份**//
	var MonthDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
				['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
				['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
		});

	var AcctMonthStrat = new Ext.form.ComboBox({
			id: 'AcctMonthStrat',
			fieldLabel: '起始月份',
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
			fieldLabel: '结束月份',
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
			style: 'border:0;background:none;margin-top:0px;',
			width: 30
		});

	//明细科目显示
	var NotIsLastField = new Ext.form.Checkbox({
			id: 'NotIsLastField',
			labelSeparator:'',
			fieldLabel: '非明细科目显示',
			allowBlank: false,
			width: 30
		});

	//============================分割线==================================================//
	var frm = new Ext.form.FormPanel({
			//autoLoad:true,
			labelAlign: 'right',
			title: '查询条件',
			iconCls:'find',
			width: 400,
			frame: true,
			region: 'east',
			defaults: {
				bodyStyle: ' padding:2.5px 0 ' //,
				//anchor: '200%',
			},
			labelWidth: 80,
			//labelWidth : 115,
			items: [{
					// defaults: {anchor: '90%'},
					// layout:'fit',
					xtype: 'fieldset',
					items: [AcctSubjCodeA, AcctSubjCodeB, AcctSubjLevel, AcctYearField, AcctMonthStrat, AcctMonthEnd, StateField]
				}, {
					xtype: 'button',
					style: "margin-Left:45%;",
					width: 55,
					text: '查询',
					iconCls: 'find',
					//fontSize:200,
					handler: function () {
						FindQuery();
					}
				}
			]
		});
	var CodeStr = "";
	var ConfigItems = [];
	//载入显示

	//rowdblclick 双击; rowclick 单击
	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		var rowObj = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = rowObj[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = rowObj[0].get("desc"); //截取方案描述
			var code = rowObj[0].get("code");
			var arr = SchemDesc.split(";"); //按照分号截取方案

			var SubjCodeA = arr[0]; //截取会计科目A
			AcctSubjCodeA.setValue(SubjCodeA);

			var SubjCodeB = arr[1]; //截取会计科目B
			AcctSubjCodeB.setValue(SubjCodeB);

			var SubjLevel = arr[2];
			AcctSubjLevel.setValue(SubjLevel);
			var year = arr[3]; //截取方案的年
			AcctYearField.setValue(year); //截取年度
			var month1 = arr[4];
			AcctMonthStrat.setValue(month1);
			var month2 = arr[5];
			AcctMonthEnd.setValue(month2);
			var state = arr[6];
			StateField.setValue(state);
			var notlastsj = arr[7];
			NotIsLastField.setValue(notlastsj);
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
		var sjcode1 = Ext.getCmp('AcctSubjCodeA').getValue();
		var sjcode1 = sjcode1.split(" ")[0];
		var sjcode2 = Ext.getCmp('AcctSubjCodeB').getValue();
		var sjcode2 = sjcode2.split(" ")[0];
		var sjlevel = Ext.getCmp('AcctSubjLevel').getValue();
		var year = Ext.getCmp('AcctYearField').getValue();
		var month1 = Ext.getCmp('AcctMonthStrat').getValue();
		var month2 = Ext.getCmp('AcctMonthEnd').getValue();
		var state = Ext.getCmp('StateField').getValue();
		var notlastsj = Ext.getCmp('NotIsLastField').getValue();

		if (state == true) {
			state = 1;
		} else {
			state = 0;
		}
		if (notlastsj == true) {
			notlastsj = 1;
		} else {
			notlastsj = 0;
		}

		//alert(sjcode+"^"+year+"^"+month1+"^"+month2+"^"+state);
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctThreeBarDetailMoneyNum.raq&&sjcode1=' + sjcode1 +
			'&sjcode2=' + sjcode2 + '&sjlevel=' + sjlevel + '&year=' + year + '&month1=' + month1 + '&month2=' + month2 +
			'&state=' + state + '&notlastsj=' + notlastsj + '&userid=' + userdr;
		// alert(p_URL);
		reportFrame.src = p_URL;
		//}


	}

}
