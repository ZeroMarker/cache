var userdr = session['LOGON.USERID']; //登录人ID
var acctbookid = GetAcctBookID();

//获得当前系统登录用户的信息说明
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];

var projUrl = 'herp.acct.acctbankcheckexe.csp';

// 定义起始时间控件
var startDate = new Ext.form.DateField({
		id: 'startDate',
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

var endDate = new Ext.form.DateField({
		id: 'endDate',
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

/*  		var OccurDate = new Ext.form.DateField({
id : 'OccurDate',
fieldLabel: '业务时间',
format : 'Y-m-d',
width : 120,
emptyText : ''
});
 */

//显示银行科目//
var SubjNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['SubjCode', 'SubjName', 'SubjCodeName'])
	});

SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=GetBankName&acctbookid=' + acctbookid + '&str=' + encodeURIComponent(Ext.getCmp('SubjName').getRawValue()),
		method: 'POST'
	});
});
//Grid表格
var SubjName = new Ext.form.ComboBox({
		id: 'SubjName',
		fieldLabel: '银行科目',
		width: 220,
		listWidth: 220,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'SubjCode',
		displayField: 'SubjCodeName',
		triggerAction: 'all',
		emptyText:'科目字典中末级银行科目',
		name: 'SubjName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//银行科目--查询条件
SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=GetBankName&acctbookid=' + acctbookid + '&str=' + encodeURIComponent(Ext.getCmp('SubjName3').getRawValue()),
		method: 'POST'
	});
});

var SubjName3 = new Ext.form.ComboBox({
		id: 'SubjName3',
		fieldLabel: '银行科目',
		width: 260,
		listWidth: 280,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'SubjCode',
		displayField: 'SubjCodeName',
		triggerAction: 'all',
		emptyText: '科目字典中末级银行科目',
		name: 'SubjName3',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			select: function (combo, record, index) {

				Ext.Ajax.request({
					url: '../csp/herp.acct.acctbankcheckexe.csp?action=getAmtBal&&bankcode=' + combo.value + '&acctbookid=' + acctbookid + '&userdr=' + userdr,
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							var data = jsonData.info;
							var bcodes = jsonData.info;
							AmtBalField.setRawValue(Ext.util.Format.number(bcodes, '0,000.00'));
							// AmtBalField.setValue(data);

						};
					},
					scope: this
				});

			}

		}

	});

//审核状态
var IfConfirmField = new Ext.form.RadioGroup({
		fieldLabel: '审核状态',
		xtype: 'radiogroup',
		width: 220,
		defaults: {
			style: "vertical-align:middle;margin:0px;border:0;"
			//style:"margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'ifall',
				boxLabel: '全部',
				inputValue: '',
				name: 'ConfirmState',
				checked: true
			}, {
				id: 'ifchecked',
				boxLabel: '已审核',
				inputValue: '1',
				name: 'ConfirmState'
			}, {
				id: 'ifunchecked',
				boxLabel: '未审核',
				inputValue: '0',
				name: 'ConfirmState'
			}
		]
	});
//<input type="checkbox" style="border:0;">
/*input.form-submit {
height: 27px;//设置行高是为了解决Safari和Chrome下的高度问题
line-height: 19px;//让文字居中显示
margin: 0;
overflow: visible;//只有设置这个属性IE下padding才能生效
width: auto;//现代浏览器下识别
 *width: 1;//IE7和IE6识别，设置值为1,我也不知道有何作用，但有些人此处设置值为0
} */
//***********************************************************//


//最新余额AmtBal
var AmtBalField = new Ext.form.NumberField({
		width: 120,
		name: 'AmtBalField',
		// region: 'east',
		align: 'right',
		xtype: 'numberfield',
		selectOnFocus: true

		//xtype:'numberfield', //只允许输入数值
		//maskRe:'/\d/',
		//regex: /^\d+(\.\d{1,2})?$/,
		// regexText: '请输入正确的数据类型',
	});
var SaveAmtBal = new Ext.Toolbar.Button({
		text: '余额保存',
		iconCls: 'save',
		width: 100,
		handler: function () {
			//定义并初始化行对象
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var bankcode = SubjName3.getValue();
			if (bankcode == "") {
				// alert("请选择银行科目");
				Ext.Msg.show({
					title: '注意',
					msg: '请选择银行科目! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;

			}
			var AmtBal = AmtBalField.getValue();
			if (AmtBal == "") {
				// alert("请输入合格的金额值");
				Ext.Msg.show({
					title: '注意',
					msg: '请输入合格的金额值! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;

			}
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: projUrl + '?action=saveamtbal&AmtBal=' + AmtBal + '&bankcode=' + bankcode + '&userdr=' + userdr + '&acctbookid=' + acctbookid,
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
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '保存成功!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								AmtBalField.setRawValue(Ext.util.Format.number(AmtBal, '0,000.00'));

							} else {
								Ext.Msg.show({
									title: '错误',
									msg: jsonData.info,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}
						},
						scope: this
					});
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('提示', '确实要保存最新余额吗?', handler);
		}
	});

//******************************************************************************//


var CheqTypeNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'name'])
	});

CheqTypeNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetSysChequeType',
			method: 'POST'
		});
});

var CheqTypeName = new Ext.form.ComboBox({
		id: 'CheqTypeName',
		fieldLabel: '结算方式',
		width: 150,
		listWidth: 220,
		allowBlank: true,
		store: CheqTypeNameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '结算方式',
		name: 'CheqTypeName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

///////////////对账状态///////////////////////

//对账状态--查询
var IsChecked1 = new Ext.form.RadioGroup({
		fieldLabel: '对账状态',
		xtype: 'radiogroup',
		width: 220,
		defaults: {
			style: "vertical-align:middle;margin-top:0px;"
			//style:"margin:0;padding:0 0.25em 10 0;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'all',
				boxLabel: '全部',
				inputValue: '',
				name: 'IsChecked1',
				checked: true
			}, {
				id: 'checked',
				boxLabel: '已对',
				inputValue: '1',
				name: 'IsChecked1'
			}, {
				id: 'unchecked',
				boxLabel: '未对',
				inputValue: '0',
				name: 'IsChecked1'
			}
		]
	});

var IsCheckedDs = new Ext.data.SimpleStore({ //对账状态
		fields: ['key', 'keyValue'],
		data: [['0', '未对'], ['1', '已对'], ['', '全部']]
	});

////配置下拉框--对账状态----IsChecked2-----////
var IsChecked2 = new Ext.form.ComboBox({
		id: 'IsChecked2',
		fieldLabel: '对账状态',
		width: 100,
		listWidth: 100,
		store: IsCheckedDs,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // 本地模式
		triggerAction: 'all',
		emptyText: '全部',
		selectOnFocus: true,
		forceSelection: true
	});
//queryPanel
// tbar:['会计期间:',startDate,'至',endDate,'-','银行科目:',SubjName3,'-','最新余额:',AmtBalField,'-',SaveAmtBal,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;','-',QueryButton,'-'],

//****查询面板--查询条件*****//


/////////////////查询按钮响应函数//////////////
var QueryButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		// height:25,
		scale: 'small',
		width: 70,
		handler: function () {
			var startTime = startDate.getValue();
			if (startTime !== "") {
				startTime = startTime.format('Y-m-d');
			}
			var endTime = endDate.getValue();
			if (endTime !== "") {
				endTime = endTime.format('Y-m-d');
			}
			var BankCode = SubjName3.getValue();
			var IsChecked = IsChecked1.getValue().inputValue;
			var IfConfirm = IfConfirmField.getValue().inputValue;
         
			//var data = SubjName+"|"+IsChecked    //根据后台方法显示查询的条件
			//var data = startTime+"|"+endTime+"|"+SubjName+"|"+IsChecked

			itemGrid.load({
				params: {
					sortField: '',
					sortDir: '',
					start: 0,
					limit: 25,
					BankCode: BankCode,
					IsChecked: IsChecked,
					StartDate: startTime,
					EndDate: endTime,
					acctbookid: acctbookid,
					userdr: userdr,
					IfConfirm: IfConfirm
				}
			});

			//未有记录的余额进行显示
			Ext.Ajax.request({
				url: '../csp/herp.acct.acctbankcheckexe.csp?action=getAmtBal&&bankcode=' + BankCode + '&acctbookid=' + acctbookid + '&userdr=' + userdr,
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var data = jsonData.info;
						var bcodes = jsonData.info;
						AmtBalField.setRawValue(Ext.util.Format.number(bcodes, '0,000.00'));
						// AmtBalField.setRawValue(bcodes);
					};
				},
				scope: this
			});

		}
	});

//删除按钮
var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {
			// 导入的数据不可删除
			var rowObj=itemGrid.getSelectionModel().getSelections();
			// console.log(rowObj)
			var isImportState=[];
			Ext.each(rowObj,function(row){
				isImportState.push(row.data["IsImport"]);
			});
			if(isImportState.indexOf("导入")!==-1){
				Ext.MessageBox.show({
					title:"注意",
					msg:"不能删除导入的数据！ ",
					icon:Ext.Msg.INFO,
					buttons:Ext.Msg.OK
				});
				return;
			}else{
				itemGrid.del();
			}

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

//导入按钮
var importButton = new Ext.Toolbar.Button({
		text: '导入Excel文件',
		tooltip: '导入', //悬停提示
		iconCls: 'in',
		handler: function () {
			doimport();
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

//审核
var AuditButton = new Ext.Toolbar.Button({
		text: '审核',
		iconCls: 'audit',
		handler: function () {
			//定义并初始化行对象
			var rowObj = itemGrid.getSelectionModel().getSelections();
			//定义并初始化行对象长度变量
			var len = rowObj.length;
			var checker = session['LOGON.USERID'];
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择需要审核的数据! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			var count = 0;
			for (var j = 0; j < len; j++) {

				if (rowObj[j].get("ConfirmState") == "已审核") {

					count = parseInt(count, 10) + 1;
					//alert(count+"^"+len);
					continue;
				}
				
				var rowid=rowObj[j].get("rowid");
				if(rowid==""){
					Ext.Msg.show({
					title: '注意',
					msg: '有未保存的数据,请先保存! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
					
				}
			}

			if (count == len) {
				Ext.Msg.show({
					title: '注意',
					msg: '数据已审核 ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}

			function handler(id) {
				if (id == "yes") {
					for (var i = 0; i < len; i++) {
						if (rowObj[i].get("ConfirmState") == "已审核") {
							// Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							continue;
						}
                        
						Ext.Ajax.request({
							url: projUrl + '?action=audit&&rowid=' + rowObj[i].get("rowid") + '&checker=' + checker,
							waitMsg: '审核中...',
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
									Ext.Msg.show({
										title: '注意',
										msg: '审核成功! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.INFO
									});
									itemGrid.load({
										params: {
											start: 0,
											limit: 25,
											userdr: userdr
										}
									});

								} else {
									Ext.Msg.show({
										title: '错误',
										msg: jsonData.info,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								}
							},
							scope: this
						});
					}
				} else {
					return;
				}
			}

			Ext.MessageBox.confirm('提示', '确实要审核该条记录吗? ', handler);
		}
	});

var queryPanel = new Ext.FormPanel({
	    title:'银行对账单维护',
		iconCls:'maintain',
		region: 'north',
		height: 110,
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
						value: '会计期间',
						style: 'padding:0 5px;'
						//width: 60
					}, startDate, {
						xtype: 'displayfield',
						value: '--',
						style: 'padding:0 5px;'
						//width: 12
					}, endDate, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '对账状态',
						style: 'padding:0 5px;'
						//width: 60
					}, IsChecked1,{
						xtype: 'displayfield',
						value: '',
						width: 20
					}, {
						xtype: 'displayfield',
						value: '最新余额',
						style: 'padding:0 5px;'
						//width: 60
					}, AmtBalField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					SaveAmtBal
				]
			}, {
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '银行科目',
						style: 'padding:0 5px;'
						//width: 60
					}, SubjName3, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '审核状态',
						style: 'padding:0 5px;'
						//width: 60
					}, IfConfirmField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, QueryButton
				]
			}

		]

	});


var itemGrid = new dhc.herp.Grid({
		//width: 400,
		//title:'银行对账单查询列表',
		iconCls:'list',
		region: 'center',
		url: projUrl,
		tbar: [addButton, '-', saveButton, '-', delButton, '-', AuditButton, '-', importButton],
		// tbar:['会计期间:',startDate,'至',endDate,'-','银行科目:',SubjName3,'-','最新余额:',AmtBalField,'-',SaveAmtBal,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;','-',QueryButton,'-'],
		listeners: {
			// 'render': function(){//button0.render(itemGrid.tbar);
			// button1.render(itemGrid.tbar);
			// },
			'cellclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				var IsChecked = record.get("IsChecked");
				var ConfirmState = record.get("ConfirmState");
				var IsImport = record.get("IsImport");
				if (((record.get('IsChecked') == "1") || (record.get('ConfirmState') == "已审核") || (record.get('IsImport') == "导入")) && ((columnIndex == 2) || (columnIndex == 3) || (columnIndex == 4) || (columnIndex == 5) || (columnIndex == 6) || (columnIndex == 7) || (columnIndex == 8) || (columnIndex == 9))) {
					return false;
				} else {
					return true;
				}
			},
			'celldblclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				var IsChecked = record.get("IsChecked")
					var ConfirmState = record.get("ConfirmState")
					var IsImport = record.get("IsImport")
					if (((record.get('IsChecked') == "1") || (record.get('ConfirmState') == "已审核") || (record.get('IsImport') == "导入")) && ((columnIndex == 2) || (columnIndex == 3) || (columnIndex == 4) || (columnIndex == 5) || (columnIndex == 6) || (columnIndex == 7) || (columnIndex == 8) || (columnIndex == 9))) {
						return false;
					} else {
						return true;
					}
			}
		},

		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				header: 'ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'SubjName',
				header: '<div style="text-align:center">银行科目</div>',
				//header : '银行科目',
				width: 265,
				editable: true,
				type: SubjName,
				align: 'left',
				allowBlank: false,
				dataIndex: 'SubjName'
			}, {
				id: 'OccurDate',
				header: '业务时间',
				align: 'center',
				width: 90,
				dataIndex: 'OccurDate',
				sortable: true,
				type: "dateField"
				//renderer : Ext.Date.Format.dateRenderer('Y-m-d'),
			}, {
				id: 'CheqTypeName',
				header: '结算方式',
				width: 80,
				align: 'center',
				type: CheqTypeName,
				editable: true,
				//allowBlank : false,
				dataIndex: 'CheqTypeName'
			}, {
				id: 'CheqNo',
				header: '<div style="text-align:center">票据号</div>',
				width: 130,
				editable: true,
				//allowBlank : false,
				//vtype:'number',
				dataIndex: 'CheqNo'
			}, {
				id: 'summary',
				//header : '摘    要',
				header: '<div style="text-align:center">摘    要</div>',
				width: 250,
				editable: true,
				align: 'left',
				dataIndex: 'summary'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">借方金额</div>',
				editable: true,
				allowBlank: false,
				width: 150,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				type: 'numberField',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AmtCredit',
				//header : '贷方金额',
				header: '<div style="text-align:center">贷方金额</div>',
				editable: true,
				allowBlank: false,
				width: 150,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				type: 'numberField',
				dataIndex: 'AmtCredit'
			}, {
				id: 'IsChecked',
				header: '对账状态',
				editable: false,
				width: 80,
				type: IsChecked2,
				align: 'center',
				dataIndex: 'IsChecked',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					if (sf == "1") {
						return '<span style="cursor:hand">' + value + '</span>';
					}
					if ((sf == '0') || (sf == "未对")) {
						return '<span style="color:blue;cursor:hand">' + value + '</span>';
					}
				}
			}, {
				id: 'IsImport',
				header: '录入方式',
				editable: false,
				width: 80,
				align: 'center',
				dataIndex: 'IsImport'
			}, {
				id: 'EnterID',
				header: '录入人',
				editable: false,
				hidden: false,
				width: 100,
				align: 'center',
				dataIndex: 'EnterID'
			}, {
				id: 'EnterDate',
				header: '录入时间',
				editable: false,
				hidden: false,
				width: 90,
				align: 'center',
				dataIndex: 'EnterDate'
			}, {
				id: 'ConfirmState',
				header: '审核状态',
				editable: false,
				width: 100,
				align: 'center',
				dataIndex: 'ConfirmState',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {

					var sf = record.data['ConfirmState']
						if (sf == "未审核") {
							return '<span>' + value + '</span>';
						}
						if (sf == "已审核") {
							return '<span style="color:blue;">' + value + '</span>';
						}
						//if (sf == "审核不通过"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
				}

			}, {
				id: 'ConfirmerID',
				header: '审核人',
				editable: false,
				hidden: false,
				width: 100,
				align: 'center',
				dataIndex: 'ConfirmerID'
			}, {
				id: 'ConfirmDate',
				header: '审核时间',
				editable: false,
				hidden: false,
				width: 150,
				align: 'center',
				dataIndex: 'ConfirmDate'
			}, {
				id: 'Amtbal',
				header: '余额',
				editable: false,
				width: 150,
				align: 'right',
				hidden: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'Amtbal'
			}
		]

	});

//itemGrid.load({params:{start:0,limit:25,userdr:userdr,acctbookid:acctbookid}});

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
	};

};

itemGrid.store.on("load", function () {
	if (itemGrid.getStore().getAt(0) == undefined) {

		AmtBalField.setValue('');
	} else {
		AmtBalField.setValue(itemGrid.getStore().getAt(0).data.Amtbal);
	}

	return;
});
var acctbookid = IsExistAcctBook();
