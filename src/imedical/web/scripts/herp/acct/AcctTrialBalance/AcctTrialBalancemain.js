
var userID = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
/////////////////////科目级次

var levelStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'level'],
		data: [['1', '1级'], ['2', '2级'], ['3', '3级'], ['4', '4级'], ['5', '5级'], ['6', '6级'], ['7', '7级'], ['8', '8级']]
	});
var subjlevelname = new Ext.form.ComboBox({
		fieldLabel: '科目级次',
		width: 80,
		listWidth: 80,
		selectOnFocus: true,
		allowBlank: false,
		store: levelStore,
		anchor: '90%',
		value: 1, //默认值
		valueNotFoundText: '',
		displayField: 'level',
		valueField: 'rowid',
		triggerAction: 'all',
		// emptyText : '1',
		mode: 'local', // 本地模式
		editable: false,
		//pageSize : 10,
		minChars: 1,
		editable: false,
		listeners: {
			select: function () {

				dosearch()
			}

		},
		selectOnFocus: true,
		forceSelection: true

	});

var balanceField = new Ext.form.DisplayField({
		id: 'balanceField',
		fieldLabel: '试算平衡结果',
		width: 80,
		// disabled:true,
		// style: 'padding-left:5px;margin-top:-1px;font-size:12px;',
		selectOnFocus: true

	});

/*
var findButton = new Ext.Button({
text: '查询',
tooltip: '查询',
iconCls: 'option',
handler: function(){

dosearch();
}
});
 */

function dosearch() {
	var subjlevel = subjlevelname.getValue()
	var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	 if(!limits){limits=25};
		itemGrid.load({
			params: {
				start: 0,
				limit: limits,
				subjlevel: subjlevel
				//bookID:bookID
			}

		});

}
//////////试算平衡按钮//////////////
var trialButton = new Ext.Button({
		text: '试算平衡',
		tooltip: '试算平衡',
		width: 90,
		iconCls: 'trialbalance',
		handler: function () {
			trial();
			itemGrid.load({
				params: {
					start: 0,
					limit: 25
				}
			});
		}
	});

//////////启用账套//////////////
var acctstartButton = new Ext.Button({
		text: '启用账套',
		tooltip: '启用账套',
		width: 90,
		iconCls: 'StartAcctbook',
		handler: function () {
			acctstart();

		}
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.AcctTrialBalanceexe.csp?action=getLedgerFlag' + '&bookID=' + bookID,
	failure: function (result, request) {
		Ext.Msg.show({
			title: '错误',
			msg: '请检查网络连接!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	},
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			if (jsonData.info == 1) {
				balanceField.setValue("平衡");
				trialButton.disable();
				acctstartButton.disable();
			}
		}
		scope: this
	}
});

var queryPanel = new Ext.FormPanel({
		height: 70,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				// columnWidth : 1,
				xtype: 'panel',
				layout: "column",
				items:
				[{
						xtype: 'displayfield',
						value: '科目级次',
						width: 65
					},
					subjlevelname, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, trialButton, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, acctstartButton]
			}, {
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '试算平衡结果:',
						width: 95
					},
					balanceField
				]
			}

			/* ,{
			xtype: 'compositefield',
			//fieldLabel: '查询条件',
			// msgTarget : 'side',
			layout:'column',
			hideLabel: true,
			//anchor    : '-20',
			defaults: {
			flex: 1
			},
			items: [{
			xtype : 'displayfield',
			value : '',
			width : 10
			}


			]  } */
		]
	});

var itemGrid = new dhc.herp.Grid({
		title:'试算平衡列表',
		iconCls:'list',
		region: 'center',
		url: '../csp/herp.acct.accttrialbalanceexe.csp',
		// atLoad:true,
		/* viewConfig : {
		forceFit : true,
		getRowClass : function(record,rowIndex,rowParams,store){

		//var dow =record.data.upmoney
		if(true)
	{alert("fdgh");
		return 'x-grid-record-blue'; }
		else
	{return 'x-grid-record-red';}

		}
		},   */

		fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
				id: 'AcctSubjCode',
				header: '<div style="text-align:center">科目代码</div>',
				allowBlank: false,
				width: 100,
				editable: false,
				update: true,
				dataIndex: 'AcctSubjCode'
			}, {
				id: 'AcctSubjNameAll',
				header: '<div style="text-align:center">科目全称</div>',
				allowBlank: false,
				editable: false,
				allowBlank: false,
				width: 150,
				update: true,
				dataIndex: 'AcctSubjNameAll'

			}, {
				id: 'Direction',
				header: '<div style="text-align:center">借贷方向</div>',
				editable: false,
				allowBlank: false,
				align: 'center',
				width: 70,
				update: true,
				dataIndex: 'Direction'
			}, {

				id: 'BeginDebtSum',
				header: '<div style="text-align:center">年初借方金额</div>',
				editable: false,
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				// type:'numberField',
				allowBlank: false,
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'BeginDebtSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}
			}, {

				id: 'BeginCreditSum',
				header: '<div style="text-align:center">年初贷方金额</div>',
				editable: false,
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				allowBlank: false,
				//type:'numberField',
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'BeginCreditSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}

			}, {
				id: 'TDebtSum',
				header: '<div style="text-align:center">累计借方金额</div>',
				editable: false,
				allowBlank: false,
				// type:'numberField',
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'TDebtSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}

			}, {

				id: 'TCreditSum',
				header: '<div style="text-align:center">累计贷方金额</div>',
				editable: false,
				allowBlank: false,
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				// type:'numberField',
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'TCreditSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}
			}, {

				id: 'EndDebtSum',
				header: '<div style="text-align:center">期初借方金额</div>',
				editable: false,
				allowBlank: false,
				// type:'numberField',

				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'EndDebtSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}
			}, {

				id: 'EndCreditSum',
				header: '<div style="text-align:center">期初贷方金额</div>',
				editable: false,
				allowBlank: false,
				//type:'numberField',
				//renderer:Ext.util.Format.number('0,000.00'),
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'EndCreditSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}

			}
		]
	});

itemGrid.load({
	params: {
		start: 0,
		limit: 25,
		bookID: bookID
	}
});

itemGrid.btnAddHide(); //隐藏增加按钮
itemGrid.btnSaveHide(); //隐藏保存按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnResetHide() //隐藏重置按钮
itemGrid.btnPrintHide() //隐藏打印按钮
