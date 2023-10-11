
var bookID = IsExistAcctBook();

//取余额百分比法的初始值
Ext.Ajax.request({
	url: '../csp/herp.acct.acctbaddebtsexe.csp?action=GetParamValue&bookID=' + bookID,
	waitMsg: '保存中...',
	failure: function (result, request) {
		Ext.Msg.show({
			title: '错误',
			msg: '请检查网络连接!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	},
	success: function (result, request) {
		var str = result.responseText;
		typename.setValue(parseInt(str.split('^')[0]));
		if (parseInt(str.split('^')[0]) == 2) {
			itemGrid.enable();
			Paramproportion.disable();
		} else {
			itemGrid.disable();
			Paramproportion.enable();
		}
		resultstr = Ext.util.Format.trim(str.split('^')[1]); //去掉前面的换行符、空格
		var resultfrist = Ext.util.Format.substr(resultstr, 0, 1); //截取第一位
		// alert(resultstr+"^"+resultfrist);
		if (resultfrist == ".")
			resultstr = "0" + resultstr; //判断第一位是否为数字，否则加0
		Paramproportion.setValue(resultstr);

	},
	scope: this
});

var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'mode'],
		data: [['1', '余额百分比法'], ['2', '账龄分析法']]
	})
	var typename = new Ext.form.ComboBox({
		width: 120,
		listWidth: 120,
		// selectOnFocus : true,
		// allowBlank : false,
		store: typeStore,
		displayField: 'mode',
		valueField: 'rowid',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		editable: false,
		// minChars : 1,
		selectOnFocus: true,
		disabled: true /* ,
		listeners : { //监听事件
		select : function () {
		if (typename.getValue() == 2) {
		itemGrid.enable();
		Paramproportion.disable();
		} else {
		itemGrid.disable();
		Paramproportion.enable();
		}

		}
		} */

	});

////////////
var Paramproportion = new Ext.form.NumberField({
		fieldLabel: '余额百分比法比例设置',
		width: 50,
		decimalPrecision: 2, //小数点后最多2位
		regex: /^0|(^0\.[0-9]{1,2})$/,
		regexText: '最多可保留两位小数！',
		style: "padding-top:3px;text-align:right;",
		maxValue: 1,
		minValue: 0

	});

//////////保存按钮//////////////
var SaveButton = new Ext.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'save',
		width: 55,
		handler: function () {
			save();
		}
	});

var queryPanel = new Ext.FormPanel({
		title: '坏账计提设置',
		iconCls: 'maintain',
		height: 125,
		region: 'north',
		frame: true,
		defaults: {
			style: "padding:3px;"
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				// hideLabel : true,
				items: [{
						xtype: 'displayfield',
						value: '坏账计提方式',
						style: 'padding-top:4px;',
						width: 90
					},
					typename]
			}, {
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '余额百分比法比例设置',
						style: 'padding-top:3px;', //line-height: 5px;
						width: 145
					},
					Paramproportion, {
						xtype: 'displayfield',
						value: '(1以内)',
						style: 'padding-left:5px;padding-top:3px;',
						width: 100
					}
				]
			}, {
				xtype: 'panel',
				layout: "column",
				items: [
					SaveButton
				]
			}

		]
	});

var itemGrid = new dhc.herp.Grid({
		title: '账龄分析法比例设置',
		iconCls: 'maintain',
		// width: 400,
		//edit:false,                   //是否可编辑
		readerModel: 'remote',
		region: 'center',
		// url: 'herp.acct.vouchtypeexe.csp',
		url: '../csp/herp.acct.acctbaddebtsexe.csp',
		// tbar:delButton,
		// atLoad : true, // 是否自动刷新
		loadmask: true,
		fields: [{
				header: 'ID',
				dataIndex: 'rowid',
				edit: false,
				hidden: true
			}, {
				id: 'code',
				header: '区间编号',
				allowBlank: false,
				align: 'center',
				width: 80,
				editable: false,
				update: true,
				dataIndex: 'code'
			}, {
				id: 'describe',
				header: '区间描述',
				allowBlank: false,
				editable: false,
				align: 'center',
				width: 300,
				update: true,
				dataIndex: 'describe'

			}, {
				id: 'beginDays',
				header: '起始天数',
				editable: false,
				align: 'center',
				allowBlank: false,
				width: 100,
				update: true,
				dataIndex: 'beginDays'
			}, {
				id: 'endDays',
				header: '终止天数',
				editable: false,
				//allowBlank: false,
				align: 'center',
				width: 100,
				update: true,
				dataIndex: 'endDays'

			}, {
				id: 'deadScale',
				header: '计提比例（%）',
				allowBlank: false,
				align: 'center',
				width: 120,
				update: true,
				dataIndex: 'deadScale'
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

itemGrid.on('afterEdit', function (e) {
	if (e.field == 'deadScale') {
		//alert(isNaN(e.value));
		if(!isNaN(e.value)){
		if (e.value < 0 || e.value > 100) {
			Ext.Msg.show({
				title: '提示',
				msg: '请输入0-100以内的数字!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return;
		}
		}else{
			Ext.Msg.show({
				title: '提示',
				msg: '请输入0-100以内的数字!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return
		}

	}
}, this);
/* itemGrid.store.on('load',function(){
//计提方式设置默认值，同时另一种计提方式不可编辑
typename.setValue(1);
Paramproportion.disable();
});
 */
itemGrid.btnAddHide(); //隐藏增加按钮
itemGrid.btnSaveHide(); //隐藏保存按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnResetHide() //隐藏重置按钮
itemGrid.btnPrintHide() //隐藏打印按钮
