var projUrl = '../csp/herp.acct.acctThreeBarDetailCashexe.csp';
var bookID = GetAcctBookID();
var acctbookid = bookID;
var userdr = session['LOGON.USERID']; //登录人ID
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

	//会计科目
	var SubjCodeZB0301Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'SubjCode', 'SubjName', 'SubjCodeName'])
		});
	SubjCodeZB0301Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetAcctSubjZB0301&str=' + Ext.getCmp('AcctSubjCodeZB0301').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctSubjCodeZB0301 = new Ext.form.ComboBox({
			id: 'AcctSubjCodeZB0301',
			fieldLabel: '会计科目',
			labelSeparator:'',
			store: SubjCodeZB0301Ds,
			valueField: 'SubjCode',
			displayField: 'SubjCodeName',
			width: 220,
			listWidth: 250,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//**会计年度**//
	var YearZB0301Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['AcctYear'])
		});
	YearZB0301Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetAcctYearZB0301&&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctYearZB0301 = new Ext.form.ComboBox({
			id: 'AcctYearZB0301',
			fieldLabel: '会计年度',
			labelSeparator:'',
			store: YearZB0301Ds,
			valueField: 'AcctYear',
			displayField: 'AcctYear',
			width: 220,
			listWidth: 260,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//**会计月份**//
	var MonthZB0301Ds = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
				['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
				['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
		});

	var AcctMonthZB0301Strat = new Ext.form.ComboBox({
			id: 'AcctMonthZB0301Strat',
			fieldLabel: '起始月份',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: MonthZB0301Ds,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // 本地模式
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
			//resizable:true
		});
	var AcctMonthZB0301End = new Ext.form.ComboBox({
			id: 'AcctMonthZB0301End',
			fieldLabel: '结束月份',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: MonthZB0301Ds,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // 本地模式
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
		});

	//是否包含为记账
	var StateZB0301Field = new Ext.form.Checkbox({
			id: 'StateZB0301Field',
			fieldLabel: '包含未记账',
			labelSeparator:'',
			allowBlank: false,
			style: 'border:0;background:none;margin-top:0px;',
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
					items: [AcctSubjCodeZB0301, AcctYearZB0301, AcctMonthZB0301Strat, AcctMonthZB0301End, StateZB0301Field]
				}, {
					xtype: 'button',
					style: "margin-Left:45%;",
					width: 55,
					iconCls: 'find',
					text: '查询',
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
			var SubjCode = arr[0]; //截取会计科目
			AcctSubjCodeZB0301.setValue(SubjCode);
			var year = arr[1]; //截取方案的年
			AcctYearZB0301.setValue(year); //截取年度
			var month1 = arr[2];
			AcctMonthZB0301Strat.setValue(month1);
			var month2 = arr[3];
			AcctMonthZB0301End.setValue(month2);
			var state = arr[4];
			StateZB0301Field.setValue(state);
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
		var sjcode = Ext.getCmp('AcctSubjCodeZB0301').getValue();
		var sjcode = sjcode.split(" ")[0];
		var year = Ext.getCmp('AcctYearZB0301').getValue();
		var month1 = Ext.getCmp('AcctMonthZB0301Strat').getValue();
		var month2 = Ext.getCmp('AcctMonthZB0301End').getValue();
		var state = Ext.getCmp('StateZB0301Field').getValue();

		if (state == true) {
			state = 1;
		} else {
			state = 0;
		}
		//alert(sjcode+"^"+year+"^"+month1+"^"+month2+"^"+state);
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.ThreeBarDetailCash.raq&&sjcode=' + sjcode +
			'&year=' + year + '&month1=' + month1 + '&month2=' + month2 + '&state=' + state + '&userid=' + userdr;
		// alert(p_URL);
		reportFrame.src = p_URL;
		//}
		//新增ZB0302

		//辅助账三栏明细账


	}

}
