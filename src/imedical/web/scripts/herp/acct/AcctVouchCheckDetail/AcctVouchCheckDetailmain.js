//取当前用户ID
var UserId = session['LOGON.USERID']
var AcctBookID = IsExistAcctBook();

var InitBankFlag;

//删除按钮
var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {
			itemGrid.del();
		}
	});

//增加按钮
var addButton = new Ext.Toolbar.Button({
		text: '增加',
		tooltip: '增加', //悬停提示
		iconCls: 'add',
		handler: function () {
			itemGrid.add();
		}

	});

//保存按钮
var saveButton = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存更改',
		iconCls: 'save',
		handler: function () {
			//调用保存函数
			itemGrid.save();
		}
	});

//查询按钮
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		width: 55, //给按钮加图标
		handler: function () {
			//调用添加函数

			var StartDate = StartDateField.getValue();
			if (StartDate != "") {
				StartDate = StartDate.format('Y-m-d');
			}
			var EndDate = EndDateField.getValue();
			if (EndDate != "") {
				EndDate = EndDate.format('Y-m-d')
			}
			var AcctSubjCode = AcctSubjNameField.getValue();

			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					AcctBookID: AcctBookID,
					StartDate: StartDate,
					EndDate: EndDate,
					AcctSubjCode: AcctSubjCode

				}
			});
		}
	});

//开始时间
var StartDateField = new Ext.form.DateField({
		id: 'StartDateField',
		fieldLabel: '开始时间',
		//format : 'Y-m-d',
		width: 120,
		triggerAction: 'all',
		emptyText: '请选择开始时间...',
		name: 'StartDateField',
		allowBlank: true,
		editable: true
	});

//结束时间
var EndDateField = new Ext.form.DateField({
		id: 'EndDateField',
		fieldLabel: '结束时间',
		//format : 'Y-m-d',
		width: 120,
		triggerAction: 'all',
		emptyText: '请选择结束时间...',
		name: 'EndDateField',
		allowBlank: true,
		editable: true
	});

//银行科目
var GetSubjNameDS = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name', 'idName'])

	});
GetSubjNameDS.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetAcctSubjName&AcctBookID=' + AcctBookID,
			method: 'POST'

		});
});
var AcctSubjNameField = new Ext.form.ComboBox({
		id: 'AcctSubjNameField',
		name: 'AcctSubjNameField',
		fieldLabel: '银行科目',
		store: GetSubjNameDS,
		displayField: 'idName',
		valueField: 'rowid',
		width: 220,
		listWidth: 220,
		start: 0,
		limit: 100,
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		lazyRender: true,
		//mode : 'local',
		emptyText: '请选择银行科目...',
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			select: function () {
				var subjcode = AcctSubjNameField.getValue();
				Ext.Ajax.request({
					url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetEndSum&AcctBookID=' + AcctBookID + '&AcctSubjCode=' + subjcode,
					method: 'GET',
					success: function (result, request) {
						// var respText=result.responseText;
						var respText = new Ext.util.JSON.decode(result.responseText);
						var EndSum = respText.info;

						if (EndSum != "")
							EndSumField.setValue(EndSum);
						else
							EndSumField.setValue("");

					},
					failure: function (result, request) {
						Ext.Msg.show({
							title: '错误',
							msg: '网络错误！',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					},
					scope: this
				});
			}
		}

	});

//银行科目字段编辑下拉框
var AcctSubjName = new Ext.form.ComboBox({
		id: 'AcctSubjName',
		name: 'AcctSubjName',
		fieldLabel: '银行科目',
		store: GetSubjNameDS,
		displayField: 'name',
		valueField: 'rowid',
		width: 180,
		listWidth: 220,
		start: 0,
		limit: 100,
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		lazyRender: true,
		//mode : 'local',
		emptyText: '请选择银行科目...',
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});


//结算方式下拉框
var GetCheqTypeNameDS = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])

	});
GetCheqTypeNameDS.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetCheqTypeName',
			method: 'POST'

		});
});
var CheqTypeNameField = new Ext.form.ComboBox({
		id: 'CheqTypeNameField',
		name: 'CheqTypeNameField',
		fieldLabel: '结算方式',
		store: GetCheqTypeNameDS,
		displayField: 'name',
		valueField: 'rowid',
		width: 180,
		listWidth: 220,
		//start:0,
		//limit:100,
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		lazyRender: true,
		//mode : 'local',
		emptyText: '',
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});


//银行账面余额
var EndSumField = new Ext.form.DisplayField({ //原为TextField
		id: 'EndSumField',
		name: 'EndSumField',
		style: 'text-align:left;font-size:12px;', //文本框对齐方式
		triggerAction: 'all',
		editable: false
	});

var queryPanel = new Ext.FormPanel({
		title: '银行未达帐维护',
		iconCls: 'maintain',
		region: 'north',
		height: 73,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '开始时间',
						style: 'padding:0 5px;'
						//width: 70
					}, StartDateField, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '结束时间',
						style: 'padding:0 5px;'
						///width: 70
					}, EndDateField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '银行科目',
						style: 'padding:0 5px;'
						//width: 70
					}, AcctSubjNameField, {
						xtype: 'displayfield',
						value: '',
						width: 15
					},
					findButton, {
						xtype: 'displayfield',
						value: '',
						width: 15
					}, {
						xtype: 'displayfield',
						value: '单位银行账面余额:',
						style: 'padding:0 5px;'
						//width: 120
					}, EndSumField
				]
			}
		]

	});


var itemGrid = new dhc.herp.Grid({
		/// title: '银行未达帐查询列表',
		//iconCls:'list',
		width: 400,
		pageSize: 25,
		readerModel: 'remote',
		region: 'center',
		url: 'herp.acct.acctvouchcheckdetailexe.csp',
		atLoad: true, // 是否自动刷新
		//loadmask:true,
		tbar: [addButton, '-', saveButton, '-', delButton],
		fields: [{
				header: 'rowid',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'AcctSubjName',
				header: '<div style="text-align:center">银行科目</div>',
				width: 155,
				type: AcctSubjName,
				allowBlank: false,
				dataIndex: 'AcctSubjName'
			}, {
				id: 'OccurDate',
				header: '<div style="text-align:center">业务时间</div>',
				allowBlank: true,
				width: 90,
				align: 'center',
				type: "dateField", //时间控件属性
				dataIndex: 'OccurDate'
			}, {
				id: 'CheqTypeName',
				header: '<div style="text-align:center">结算方式</div>',
				width: 100,
				allowBlank: false,
				align: 'center',
				type: CheqTypeNameField,
				dataIndex: 'CheqTypeName'
			}, {
				id: 'CheqNo',
				header: '<div style="text-align:center">票据号</div>',
				allowBlank: true,
				width: 170,
				dataIndex: 'CheqNo'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">摘要</div>',
				allowBlank: true,
				width: 300,
				type: 'textfield',
				dataIndex: 'Summary'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">借方金额</div>',
				allowBlank: true,
				width: 160,
				align: 'right',
				type: 'numberField',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AmtCredit',
				header: '<div style="text-align:center">贷方金额</div>',
				allowBlank: true,
				width: 160,
				type: 'numberField',
				align: 'right',
				dataIndex: 'AmtCredit'
			}
		]
		
	});
//InitBankFlag==1时，增删改按钮不可用
//--------判断按钮标志
itemGrid.store.on('load', function () {
	Ext.Ajax.request({
		url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetInitBankFlag&AcctBookID=' + AcctBookID,
		method: 'GET',
		success: function (result, request) {
			var respText = Ext.decode(result.responseText);
			var str = respText.info;
			InitBankFlag = str;
			if (InitBankFlag == 1) {
				addButton.disable();
				saveButton.disable();
				delButton.disable();
			}
		}
	});
});

//按钮标志为1时，不可进行行编辑
itemGrid.on('beforeedit', function (editor, e) {
	if (InitBankFlag == 1) {
		return false;
	}
});

//AmtDebit\AmtCredit两列互斥，修改一个，另一个置0
itemGrid.on('afterEdit', onEdit, this);
function onEdit(e) {
	if (e.field == "AmtDebit") {
		if (e.value != 0) {
			e.record.set("AmtCredit", 0);
		}
	} else if (e.field == "AmtCredit") {
		if (e.value != 0) {
			e.record.set("AmtDebit", 0);
		}
	}

};

//取EndSum的值，赋给EndSumField
/* Ext.Ajax.request({
url:itemGrid.url+'?action=GetEndSum'+'&AcctBookID='+AcctBookID+'&AcctSubjCode='+subjcode,
method:'GET',
success:function(result,request){
var respText=Ext.util.JSON.decode(result,respText);
var EndSum=respText.info;
EndSumField.setValue(EndSum);
},
failure:function(result,request){
return;
}
}); */

// itemGrid.addButton('-');
// itemGrid.addButton(delButton);
// itemGrid.btnAddHide()     //隐藏增加按钮
// itemGrid.btnSaveHide()    //隐藏保存按钮
// itemGrid.btnDeleteHide()  //隐藏删除按钮
//itemGrid.btnResetHide()     //隐藏重置按钮
//itemGrid.btnPrintHide()     //隐藏打印按钮
