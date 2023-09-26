// 名称:厂商维护
// 编写日期:2012-05-10

var ManfTakePicWindow;
var conditionCodeField = new Ext.form.TextField({
		id: 'conditionCodeField',
		fieldLabel: '代码',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findPhManf.handler();
				}
			}
		}
	});

var conditionNameField = new Ext.form.TextField({
		id: 'conditionNameField',
		fieldLabel: '名称',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			'specialkey': function (t, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findPhManf.handler();
				}
			}
		}
	});

var ActiveData=[['全部',''],['激活','Y'],['未激活','N']];
	var ActiveStore = new Ext.data.SimpleStore({
		fields: ['Activedesc', 'Activeid'],
		data : ActiveData
	});
var conditionactiveField = new Ext.form.ComboBox({
	store: ActiveStore,
	displayField:'Activedesc',
	mode: 'local', 
	anchor : '90%',
	emptyText:'',
	id:'conditionactiveField',
	fieldLabel : '是否激活',
	triggerAction:'all',
	valueField : 'Activeid'
});
Ext.getCmp("conditionactiveField").setValue("");
	
var PhManfGrid = "";
//配置数据源
var PhManfGridUrl = 'dhcstm.phmanfnewaction.csp';
var PhManfGridProxy = new Ext.data.HttpProxy({
		url: PhManfGridUrl + '?actiontype=query',
		method: 'POST'
	});
var PhManfGridDs = new Ext.data.Store({
		proxy: PhManfGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [{
					name: 'RowId'
				}, {
					name: 'Code'
				}, {
					name: 'Name'
				}, {
					name: 'Address'
				}, {
					name: 'Tel'
				}, {
					name: 'AddManfId'
				}, {
					name: 'ParManfId'
				}, {
					name: 'ParManf'
				}, {
					name: 'socialCreditCodeText'
				}, {
					name: 'socialCreditCodeDateTo'
				}, {
					name: 'drugProPermitText'
				}, {
					name: 'drugProPermitDateTo'
				}, {
					name: 'insProLicText'
				}, {
					name: 'insProLicDateTo'
				}, {
					name: 'comLicText'
				}, {
					name: 'comLicDateTo'
				}, {
					name: 'Active'
				}, {
					name: 'businessRegNoText'
				}, {
					name: 'businessRegNoDateTo'
				}, {
					name: 'orgCodeText'
				}, {
					name: 'orgCodeDateTo'
				}, {
					name: 'insBusLicText'
				}, {
					name: 'insBusLicDateTo'
				}, {
					name: 'prodEprsHygLicText'
				}, {
					name: 'prodEprsHygLicDateTo'
				}, {
					name: 'taxLicText'
				}
			]),
		remoteSort: false
	});

//模型
var PhManfGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "代码",
				dataIndex: 'Code',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "名称",
				dataIndex: 'Name',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: "地址",
				dataIndex: 'Address',
				width: 200,
				align: 'left',
				sortable: false
			}, {
				header: "电话",
				dataIndex: 'Tel',
				width: 100,
				align: 'left',
				sortable: false
			}, {
				header: "上级厂商",
				dataIndex: 'ParManf',
				width: 150,
				align: 'left',
				sortable: false
			}, {
				header: "社会信用码",
				dataIndex: 'socialCreditCodeText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "社会信用码效期",
				dataIndex: 'socialCreditCodeDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "药物生产许可",
				dataIndex: 'drugProPermitText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "药物生产许可有效期",
				dataIndex: 'drugProPermitDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "器械生产许可",
				dataIndex: 'insProLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "器械生产许可有效期",
				dataIndex: 'insProLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "工商执照许可",
				dataIndex: 'comLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "工商执照许可有效期",
				dataIndex: 'comLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "工商注册号",
				dataIndex: 'businessRegNoText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "工商注册效期",
				dataIndex: 'businessRegNoDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "组织机构代码",
				dataIndex: 'orgCodeText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "组织机构代码效期",
				dataIndex: 'orgCodeDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "税务登记号",
				dataIndex: 'taxLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "器械经营许可证",
				dataIndex: 'insBusLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "器械经营许可证效期",
				dataIndex: 'insBusLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "生产企业卫生许可证",
				dataIndex: 'prodEprsHygLicText',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "生产企业卫生许可证效期",
				dataIndex: 'prodEprsHygLicDateTo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "激活标识",
				dataIndex: 'Active',
				width: 80,
				align: 'left',
				sortable: true,
				renderer: function (v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}
		]);

//初始化默认排序功能
PhManfGridCm.defaultSortable = true;

var findPhManf = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			var conditionCode = Ext.getCmp('conditionCodeField').getValue();
			var conditionName = Ext.getCmp('conditionNameField').getValue();
			var activeFlag=Ext.getCmp('conditionactiveField').getValue();
			PhManfGridDs.setBaseParam('sort', 'RowId');
			PhManfGridDs.setBaseParam('dir', 'desc');
			PhManfGridDs.setBaseParam('conditionCode', conditionCode);
			PhManfGridDs.setBaseParam('conditionName', conditionName);
			PhManfGridDs.setBaseParam('activeFlag', activeFlag);
			PhManfGridDs.load({
				params: {
					start: 0,
					limit: PhManfPagingToolbar.pageSize
				},
				callback: function (r, options, success) {
					if (success == false) {
						Msg.info("error", "查询错误，请查看日志!");
					}
				}
			});
		}
	});

//厂商编辑窗口
//zdm,2013-03-06
function CreateEditWin(rowid) {

	//厂商代码
	var codeField = new Ext.form.TextField({
			id: 'codeField',
			fieldLabel: '<font color=red>厂商代码</font>',
			allowBlank: false,
			maxLength: 12,
			emptyText: '新建时为空,则自动生成...',
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('codeField').getValue() == "") {
							Handler = function () {
								codeField.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '厂商代码不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							nameField.focus();
						}
					}
				}
			}
		});

	//厂商名称
	var nameField = new Ext.form.TextField({
			id: 'nameField',
			fieldLabel: '<font color=red>厂商名称</font>',
			allowBlank: false,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('nameField').getValue() == "") {
							Handler = function () {
								nameField.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '厂商名称不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							addressField.focus();
						}
					}
				}
			}
		});

	//厂商地址
	var addressField = new Ext.form.TextField({
			id: 'addressField',
			fieldLabel: '厂商地址',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						phoneField.focus();
					}
				}
			}
		});

	//厂商电话
	var phoneField = new Ext.form.TextField({
			id: 'phoneField',
			fieldLabel: '厂商电话',
			allowBlank: true,
			anchor: '90%',
			regex: /^[^\u4e00-\u9fa5]{0,}$/,
			regexText: '不正确的电话号码',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						lastPhManfField.focus();
					}
				}
			}
		});

	//上级厂商
	var lastPhManfField = new Ext.ux.ComboBox({
			id: 'lastPhManfField',
			fieldLabel: '上级厂商',
			anchor: '90%',
			allowBlank: true,
			store: PhManufacturerStore,
			filterName: 'PHMNFName',
			editable: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						drugProPermitText.focus();
					}
				}
			}
		});

	//药物生产许可
	var drugProPermitText = new Ext.form.TextField({
			id: 'drugProPermitText',
			fieldLabel: '药物生产许可',
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProPermitText').getValue() == "") {
							Handler = function () {
								drugProPermitText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '药物生产许可不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							drugProPermitDateTo.focus();
						}
					}
				}
			}
		});

	//药物生产许可有效期
	var drugProPermitDateTo = new Ext.ux.DateField({
			id: 'drugProPermitDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProPermitDateTo').getValue() == "") {
							Handler = function () {
								drugProPermitDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '药物生产许可有效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insProLicText.focus();
						}
					}
				}
			}
		});

	//器械生产许可
	var insProLicText = new Ext.form.TextField({
			id: 'insProLicText',
			fieldLabel: '器械生产许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insProLicText').getValue() == "") {
							Handler = function () {
								insProLicText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '器械生产许可不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insProLicDateTo.focus();
						}
					}
				}
			}
		});

	//器械生产许可有效期
	var insProLicDateTo = new Ext.ux.DateField({
			id: 'insProLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insProLicDateTo').getValue() == "") {
							Handler = function () {
								insProLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '器械生产许可有效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							comLicText.focus();
						}
					}
				}
			}
		});

	//工商执照许可
	var comLicText = new Ext.form.TextField({
			id: 'comLicText',
			fieldLabel: '工商执照许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicText').getValue() == "") {
							Handler = function () {
								comLicText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '工商执照许可不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							comLicDateTo.focus();
						}
					}
				}
			}
		});

	//工商执照许可有效期
	var comLicDateTo = new Ext.ux.DateField({
			id: 'comLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicDateTo').getValue() == "") {
							Handler = function () {
								comLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '工商执照许可有效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							businessRegNoText.focus();

						}
					}
				}
			}
		});
	//工商注册号
	var businessRegNoText = new Ext.form.TextField({
			id: 'businessRegNoText',
			fieldLabel: '工商注册号',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('businessRegNoText').getValue() == "") {
							Handler = function () {
								businessRegNoText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '工商注册号不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							businessRegNoDateTo.focus();
						}
					}
				}
			}
		});

	//工商注册效期
	var businessRegNoDateTo = new Ext.ux.DateField({
			id: 'businessRegNoDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('businessRegNoDateTo').getValue() == "") {
							Handler = function () {
								businessRegNoDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '工商注册效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							orgCodeText.focus();
						}
					}
				}
			}
		});
	//组织机构代码
	var orgCodeText = new Ext.form.TextField({
			id: 'orgCodeText',
			fieldLabel: '组织机构代码',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('orgCodeText').getValue() == "") {
							Handler = function () {
								orgCodeText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '组织机构代码不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							orgCodeDateTo.focus();
						}
					}
				}
			}
		});

	//组织机构代码效期
	var orgCodeDateTo = new Ext.ux.DateField({
			id: 'orgCodeDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('orgCodeDateTo').getValue() == "") {
							Handler = function () {
								orgCodeDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '组织机构代码效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							taxLicText.focus();
						}
					}
				}
			}
		});
	//税务登记号
	var taxLicText = new Ext.form.TextField({
			id: 'taxLicText',
			fieldLabel: '税务登记号',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('taxLicText').getValue() == "") {
							Handler = function () {
								taxLicText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '税务登记号不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insBusLicText.focus();
						}
					}
				}
			}
		});
	//医疗器械经营许可证
	var insBusLicText = new Ext.form.TextField({
			id: 'insBusLicText',
			fieldLabel: '器械经营许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insBusLicText').getValue() == "") {
							Handler = function () {
								insBusLicText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '医疗器械经营许可证不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							insBusLicDateTo.focus();
						}
					}
				}
			}
		});

	//医疗器械经营许可证效期
	var insBusLicDateTo = new Ext.ux.DateField({
			id: 'insBusLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('insBusLicDateTo').getValue() == "") {
							Handler = function () {
								insBusLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '医疗器械经营许可证效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							prodEprsHygLicText.focus();
						}
					}
				}
			}
		});
	//医疗器械经营许可证
	var prodEprsHygLicText = new Ext.form.TextField({
			id: 'prodEprsHygLicText',
			fieldLabel: '生产企业卫生许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('prodEprsHygLicText').getValue() == "") {
							Handler = function () {
								prodEprsHygLicText.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '生产企业卫生许可证不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							prodEprsHygLicDateTo.focus();
						}
					}
				}
			}
		});

	//医疗器械经营许可证效期
	var prodEprsHygLicDateTo = new Ext.ux.DateField({
			id: 'prodEprsHygLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('prodEprsHygLicDateTo').getValue() == "") {
							Handler = function () {
								prodEprsHygLicDateTo.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '生产企业卫生许可证效期不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler,
								width: 250
							});
						} else {
							activeField.focus();
							activeField.setValue(true);
						}
					}
				}
			}
		});
	//激活
	var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			fieldLabel: '激活',
			boxLabel: '激活',
			hideLabel: true,
			allowBlank: false,
			checked: true, //默认是"激活"状态
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						editButton.focus();
					}
				}
			}
		});

	//工商执照
	var uploadButtonComLic = new Ext.Button({
			text: '上传',
			anchor: '10%',
			handler: function () {
				var type = "comLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonComLicTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("comLic", "工商执照");
			}
		});
	///税务执照
	var uploadButtonTaxLic = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "taxLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonTaxLicTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("taxLic", "税务执照");
			}
		});

	//机构代码
	var uploadButtonOrgCode = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "orgCode";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonOrgCodeTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("orgCode", "机构代码");
			}
		});
	//器械生产许可
	var uploadButtonInsProLic = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "insProLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonInsProLicTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("insProLic", "器械生产许可证");
			}
		});
	//器械经营许可证
	var uploadButtonInsBusLic = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "insBusLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonInsBusLicTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("insBusLic", "器械经营许可证");
			}
		});
	//药品生产许可证
	var uploadButtonDrugProLic = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "drugProLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonDrugProLicTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("drugProLic", "药品生产许可证");
			}
		});
	//生产企业卫生许可证
	var uploadButtonMANFProdEprsHygLic = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "drugProLic";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonMANFProdEprsHygLicTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("drugProLic", "生产企业卫生许可证");
			}
		});

	var socialCreditCodeText = new Ext.form.TextField({
			id: 'socialCreditCodeText',
			fieldLabel: '社会信用码',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//社会信用码效期
	var socialCreditCodeDateTo = new Ext.ux.DateField({
			id: 'socialCreditCodeDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});
	
	var uploadButtonSocialCreditCode = new Ext.Button({
			text: '上传',
			handler: function () {
				var type = "socialCreditCode";
				addManfPic(rowid, type);
			}
		});
	var uploadButtonSocialCreditCodeTP = new Ext.Button({
			text: '拍照',
			anchor: '10%',
			handler: function () {
				take_pic("socialCreditCode", "社会信用码");
			}
		});
		
	//初始化面板
	editForm = new Ext.form.FormPanel({
			autoScroll: true,
			frame: true,
			labelWidth: 60,
			labelAlign: 'right',
			items: [{
					xtype: 'fieldset',
					title: '基本信息',
					autoHeight: true,
					items: [{
							layout: 'column',
							items: [{
									layout: 'form',
									columnWidth: .5,
									items: [codeField, phoneField]
								}, {
									layout: 'form',
									columnWidth: .5,
									items: [nameField, lastPhManfField]
								}
							]
						}, {
							layout: 'column',
							items: [{
									layout: 'form',
									columnWidth: .85,
									items: [addressField]
								}, {
									layout: 'form',
									columnWidth: .15,
									items: [activeField]
								}
							]
						}
					]
				}, {
					xtype: 'fieldset',
					title: '资质信息',
					autoHeight: true,
					items: [{
							layout: 'form',
							labelWidth: 170,
							items: [{
									xtype: 'compositefield',
									items: [socialCreditCodeText, socialCreditCodeDateTo, uploadButtonSocialCreditCode, uploadButtonSocialCreditCodeTP]
								}, {
									xtype: 'compositefield',
									items: [drugProPermitText, drugProPermitDateTo, uploadButtonDrugProLic, uploadButtonDrugProLicTP]
								}, {
									xtype: 'compositefield',
									items: [insProLicText, insProLicDateTo, uploadButtonInsProLic, uploadButtonInsProLicTP]
								}, {
									xtype: 'compositefield',
									items: [comLicText, comLicDateTo, uploadButtonComLic, uploadButtonComLicTP]
								}, {
									xtype: 'compositefield',
									items: [orgCodeText, orgCodeDateTo, uploadButtonOrgCode, uploadButtonOrgCodeTP]
								}, {
									xtype: 'compositefield',
									items: [insBusLicText, insBusLicDateTo, uploadButtonInsBusLic, uploadButtonInsBusLicTP]
								}, {
									xtype: 'compositefield',
									items: [prodEprsHygLicText, prodEprsHygLicDateTo, uploadButtonMANFProdEprsHygLic, uploadButtonMANFProdEprsHygLicTP]
								}, {
									xtype: 'compositefield',
									items: [businessRegNoText, businessRegNoDateTo]
								}, {
									xtype: 'compositefield',
									items: [taxLicText, uploadButtonTaxLic, uploadButtonTaxLicTP]
								}
							]
						}
					]
				}
			]
		});

	//初始化添加按钮
	editButton = new Ext.Toolbar.Button({
			text: '保存',
			iconCls: 'page_save',
			handler: function () {
				if (rowid == "") {
					addHandler();
				} else {
					editHandler();
				}
			}
		});
	//初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
			text: '关闭',
			iconCls: 'page_close'
		});

	//定义取消按钮的响应函数
	cancelHandler = function () {
		win.close();
	};

	//添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	//初始化窗口
	var win = new Ext.Window({
			title: '厂商维护',
			width: 600,
			height: gWinHeight,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: editForm,
			resizable: false,
			buttons: [
				editButton,
				cancelButton
			],
			listeners: {
				'show': function (thisWin) {
					if (rowid != "") {
						Select(rowid);
					}
				}
			}
		});

	win.show();
	//新增
	var addHandler = function () {
		/*
		厂商基本信息
		*/
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		
		/*资质信息
			严格按照以下顺序
			每个资质组成串顺序：资质类型^资质有效期^资质发证日期^资质发证机关^效期长期标志^延期标志^延期日期
		*/
		// 药品生产许可证
		var drugProPermitText = Ext.getCmp('drugProPermitText').getValue();
		var drugProPermitDateTo = Ext.getCmp('drugProPermitDateTo').getValue();
		if ((drugProPermitDateTo != "") && (drugProPermitDateTo != null)) {
			drugProPermitDateTo = drugProPermitDateTo.format(ARG_DATEFORMAT);
		}
		var drugProPermitType="drugProPermit";
		var drugProPermitStr=drugProPermitType+"^"+drugProPermitText+"^"+drugProPermitDateTo;
		
		// 器械生产许可证
		var insProLicText = Ext.getCmp('insProLicText').getValue();
		var insProLicDateTo = Ext.getCmp('insProLicDateTo').getValue();
		if ((insProLicDateTo != "") && (insProLicDateTo != null)) {
			insProLicDateTo = insProLicDateTo.format(ARG_DATEFORMAT);
		}
		var insProLicType="insProLic";
		var insProLicStr=insProLicType+"^"+insProLicText+"^"+insProLicDateTo;
		
		// 工商执照
		var comLicText = Ext.getCmp('comLicText').getValue();
		var comLicDateTo = Ext.getCmp('comLicDateTo').getValue();
		if ((comLicDateTo != "") && (comLicDateTo != null)) {
			comLicDateTo = comLicDateTo.format(ARG_DATEFORMAT);
		}
		var comLicType="comLic";
		var comLicStr=comLicType+"^"+comLicText+"^"+comLicDateTo;
		
		// 工商注册号
		var businessRegNoText = Ext.getCmp('businessRegNoText').getValue();
		var businessRegNoDateTo = Ext.getCmp('businessRegNoDateTo').getValue();
		if ((businessRegNoDateTo != "") && (businessRegNoDateTo != null)) {
			businessRegNoDateTo = businessRegNoDateTo.format(ARG_DATEFORMAT);
		}
		var businessRegNoType="businessRegNo";
		var businessRegNoStr=businessRegNoType+"^"+businessRegNoText+"^"+businessRegNoDateTo;
		
		// 机构代码
		var orgCodeText = Ext.getCmp('orgCodeText').getValue();
		var orgCodeDateTo = Ext.getCmp('orgCodeDateTo').getValue();
		if ((orgCodeDateTo != "") && (orgCodeDateTo != null)) {
			orgCodeDateTo = orgCodeDateTo.format(ARG_DATEFORMAT);
		}
		var orgCodeType="orgCode";
		var orgCodeStr=orgCodeType+"^"+orgCodeText+"^"+orgCodeDateTo;
		
		// 税务登记证
		var taxLicText = Ext.getCmp('taxLicText').getValue();
		var taxLicType="taxLic";
		var taxLicStr=taxLicType+"^"+taxLicText;
		
		// 器械经营许可证
		var insBusLicText = Ext.getCmp('insBusLicText').getValue();
		var insBusLicDateTo = Ext.getCmp('insBusLicDateTo').getValue();
		if ((insBusLicDateTo != "") && (insBusLicDateTo != null)) {
			insBusLicDateTo = insBusLicDateTo.format(ARG_DATEFORMAT);
		}
		var insBusLicType="insBusLic";
		var insBusLicStr=insBusLicType+"^"+insBusLicText+"^"+insBusLicDateTo;
		
		// 生产企业卫生许可证
		var prodEprsHygLicText = Ext.getCmp('prodEprsHygLicText').getValue();
		var prodEprsHygLicDateTo = Ext.getCmp('prodEprsHygLicDateTo').getValue();
		if ((prodEprsHygLicDateTo != "") && (prodEprsHygLicDateTo != null)) {
			prodEprsHygLicDateTo = prodEprsHygLicDateTo.format(ARG_DATEFORMAT);
		}
		var prodEprsHygLicType="prodEprsHygLic";
		var prodEprsHygLicStr=prodEprsHygLicType+"^"+prodEprsHygLicText+"^"+prodEprsHygLicDateTo;
		
		// 社会信用码
		var socialCreditCodeText = Ext.getCmp('socialCreditCodeText').getValue();
		var socialCreditCodeDateTo = Ext.getCmp('socialCreditCodeDateTo').getValue();
		if ((socialCreditCodeDateTo != "") && (socialCreditCodeDateTo != null)) {
			socialCreditCodeDateTo = socialCreditCodeDateTo.format(ARG_DATEFORMAT);
		}
		var socialCreditCodeType="socialCreditCode";
		var socialCreditCodeStr=socialCreditCodeType+"^"+socialCreditCodeText+"^"+socialCreditCodeDateTo;
		
		if (code.trim() == "") {}

		if (name.trim() == "") {
			Msg.info('warning', "厂商名称不能为空");
			return;
		}

		//拼data字符串
		var Basicdata = code + "^" + name + "^" + address + "^" + phone + "^" + lastPhManfId+ "^" + active;
		var QualityData = drugProPermitStr+"&"+insProLicStr+"&"+comLicStr+"&"+businessRegNoStr+"&"+orgCodeStr
			+"&"+taxLicStr+"&"+insBusLicStr+"&"+prodEprsHygLicStr+"&"+socialCreditCodeStr;
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=insert',
			params: {
				data: Basicdata,
				QualityData :QualityData
			},
			method: 'post',
			waitMsg: '新建中...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					var newRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					win.close();
					findPhManf.handler();
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "名称重复!");
					} else if (jsonData.info == -11) {
						Msg.info("error", "代码重复!");
					} else {
						Msg.info("error", "保存失败!");
					}
				}
			},
			scope: this
		});
	};

	//修改
	var editHandler = function () {
		/*
		厂商基本信息
		*/
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		
		/*资质信息
			严格按照以下顺序
			每个资质组成串顺序：资质类型^资质有效期^资质发证日期^资质发证机关^效期长期标志^延期标志^延期日期
		*/
		// 药品生产许可证
		var drugProPermitText = Ext.getCmp('drugProPermitText').getValue();
		var drugProPermitDateTo = Ext.getCmp('drugProPermitDateTo').getValue();
		if ((drugProPermitDateTo != "") && (drugProPermitDateTo != null)) {
			drugProPermitDateTo = drugProPermitDateTo.format(ARG_DATEFORMAT);
		}
		var drugProPermitType="drugProPermit";
		var drugProPermitStr=drugProPermitType+"^"+drugProPermitText+"^"+drugProPermitDateTo;
		
		// 器械生产许可证
		var insProLicText = Ext.getCmp('insProLicText').getValue();
		var insProLicDateTo = Ext.getCmp('insProLicDateTo').getValue();
		if ((insProLicDateTo != "") && (insProLicDateTo != null)) {
			insProLicDateTo = insProLicDateTo.format(ARG_DATEFORMAT);
		}
		var insProLicType="insProLic";
		var insProLicStr=insProLicType+"^"+insProLicText+"^"+insProLicDateTo;
		
		// 工商执照
		var comLicText = Ext.getCmp('comLicText').getValue();
		var comLicDateTo = Ext.getCmp('comLicDateTo').getValue();
		if ((comLicDateTo != "") && (comLicDateTo != null)) {
			comLicDateTo = comLicDateTo.format(ARG_DATEFORMAT);
		}
		var comLicType="comLic";
		var comLicStr=comLicType+"^"+comLicText+"^"+comLicDateTo;
		
		// 工商注册号
		var businessRegNoText = Ext.getCmp('businessRegNoText').getValue();
		var businessRegNoDateTo = Ext.getCmp('businessRegNoDateTo').getValue();
		if ((businessRegNoDateTo != "") && (businessRegNoDateTo != null)) {
			businessRegNoDateTo = businessRegNoDateTo.format(ARG_DATEFORMAT);
		}
		var businessRegNoType="businessRegNo";
		var businessRegNoStr=businessRegNoType+"^"+businessRegNoText+"^"+businessRegNoDateTo;
		
		// 机构代码
		var orgCodeText = Ext.getCmp('orgCodeText').getValue();
		var orgCodeDateTo = Ext.getCmp('orgCodeDateTo').getValue();
		if ((orgCodeDateTo != "") && (orgCodeDateTo != null)) {
			orgCodeDateTo = orgCodeDateTo.format(ARG_DATEFORMAT);
		}
		var orgCodeType="orgCode";
		var orgCodeStr=orgCodeType+"^"+orgCodeText+"^"+orgCodeDateTo;
		
		// 税务登记证
		var taxLicText = Ext.getCmp('taxLicText').getValue();
		var taxLicType="taxLic";
		var taxLicStr=taxLicType+"^"+taxLicText;		
		
		// 器械经营许可证
		var insBusLicText = Ext.getCmp('insBusLicText').getValue();
		var insBusLicDateTo = Ext.getCmp('insBusLicDateTo').getValue();
		if ((insBusLicDateTo != "") && (insBusLicDateTo != null)) {
			insBusLicDateTo = insBusLicDateTo.format(ARG_DATEFORMAT);
		}
		var insBusLicType="insBusLic";
		var insBusLicStr=insBusLicType+"^"+insBusLicText+"^"+insBusLicDateTo;
		
		//生产企业卫生许可证
		var prodEprsHygLicText = Ext.getCmp('prodEprsHygLicText').getValue();
		var prodEprsHygLicDateTo = Ext.getCmp('prodEprsHygLicDateTo').getValue();
		if ((prodEprsHygLicDateTo != "") && (prodEprsHygLicDateTo != null)) {
			prodEprsHygLicDateTo = prodEprsHygLicDateTo.format(ARG_DATEFORMAT);
		}
		var prodEprsHygLicType="prodEprsHygLic";
		var prodEprsHygLicStr=prodEprsHygLicType+"^"+prodEprsHygLicText+"^"+prodEprsHygLicDateTo;
		
		// 社会信用码
		var socialCreditCodeText = Ext.getCmp('socialCreditCodeText').getValue();
		var socialCreditCodeDateTo = Ext.getCmp('socialCreditCodeDateTo').getValue();
		if ((socialCreditCodeDateTo != "") && (socialCreditCodeDateTo != null)) {
			socialCreditCodeDateTo = socialCreditCodeDateTo.format(ARG_DATEFORMAT);
		}
		var socialCreditCodeType="socialCreditCode";
		var socialCreditCodeStr=socialCreditCodeType+"^"+socialCreditCodeText+"^"+socialCreditCodeDateTo;
		
		
		if (code.trim() == "") {
			Ext.Msg.show({
				title: '提示',
				msg: '厂商代码为空',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}

		if (name.trim() == "") {
			Ext.Msg.show({
				title: '提示',
				msg: '厂商名称为空',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		//拼data字符串
		var Basicdata = rowid + "^" + code + "^" + name + "^" + address + "^" + phone + "^" + lastPhManfId+ "^" + active;
		var QualityData = drugProPermitStr+"&"+insProLicStr+"&"+comLicStr+"&"+businessRegNoStr+"&"+orgCodeStr
			+"&"+taxLicStr+"&"+insBusLicStr+"&"+prodEprsHygLicStr+"&"+socialCreditCodeStr;
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=update',
			params: {
				data: Basicdata,
				QualityData:QualityData
			},
			waitMsg: '更新中...',
			failure: function (result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "更新成功!");
					win.close();
					PhManfGridDs.reload();
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "名称重复!");
					}
					if (jsonData.info == -11) {
						Msg.info("error", "代码重复!");
					} else {
						Msg.info('error', '保存失败:' + jsonData.info);
					}
				}
			},
			scope: this
		});
	};

	function Select(rowid) {
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=queryByRowId&rowid=' + rowid,
			failure: function (result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					//查询成功,赋值给控件
					var value = jsonData.info;
					var AllArr=value.split("&");
					var arr = AllArr[0].split("^");
					var QualityStr = AllArr[1];
					
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					addComboData(lastPhManfField.getStore(), arr[5], arr[6]);
					Ext.getCmp('lastPhManfField').setValue(arr[5]);
					Ext.getCmp('activeField').setValue((arr[7] == "Y") ? true : false);
					
					var QualityArr=QualityStr.split("#");
					var QualityArrLen=QualityArr.length;
					for (var i=0;i<QualityArrLen;i++)
					{
						var tmpQualityStr = QualityArr[i];
						var tmpQualityArr = tmpQualityStr.split("^");
						var CertType = tmpQualityArr[0];
						var CertText = tmpQualityArr[1];
						var CertIssuedDept = tmpQualityArr[2];
						var CertIssuedDate = tmpQualityArr[3];
						var CertDateTo = tmpQualityArr[4];
						var CertBlankedFlag = tmpQualityArr[5];
						var CertDelayFlag = tmpQualityArr[6];
						var CertDelayDateTo = tmpQualityArr[7];
						if (Ext.isEmpty(Ext.getCmp(CertType+'Text'))){continue;}
						Ext.getCmp(CertType+'Text').setValue(CertText);
						if (Ext.isEmpty(Ext.getCmp(CertType+'DateTo'))){continue;}
						Ext.getCmp(CertType+'DateTo').setValue(CertDateTo);
						if (Ext.isEmpty(Ext.getCmp(CertType+'IssuedDept'))){continue;}
						Ext.getCmp(CertType+'IssuedDept').setValue(CertIssuedDept);
						if (Ext.isEmpty(Ext.getCmp(CertType+'IssuedDate'))){continue;}
						Ext.getCmp(CertType+'IssuedDate').setValue(CertIssuedDate);
						if (Ext.isEmpty(Ext.getCmp(CertType+'BlankedFlag'))){continue;}
						Ext.getCmp(CertType+'BlankedFlag').setValue(CertBlankedFlag);
						if (Ext.isEmpty(Ext.getCmp(CertType+'DelayFlag'))){continue;}
						Ext.getCmp(CertType+'DelayFlag').setValue(CertDelayFlag);
						if (Ext.isEmpty(Ext.getCmp(CertType+'DelayDateTo'))){continue;}
						Ext.getCmp(CertType+'DelayDateTo').setValue(CertDelayDateTo);
					}
					
				} else {
					Msg.info("error", "查询失败!" + newRowid);
				}
			},
			scope: this
		});
	}

	function take_pic(typeCode, typeDesc) {
		if (rowid == "") {
			Msg.info("warning", "请先保存厂商信息,再拍照!");
			return;
		}
		var AppName = 'DHCSTPHMANFM';
		if ((!ManfTakePicWindow) || (ManfTakePicWindow.closed)) {
			var lnk = 'dhcstm.takepiccommon.csp';
			lnk = lnk + "?AppName=" + AppName;
			lnk = lnk + "&RowId=" + rowid;
			lnk = lnk + "&typeCode=" + typeCode;
			lnk = lnk + "&typeDesc=" + typeDesc;
			lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
			lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
			lnk = lnk + "&UserId=" + session['LOGON.USERID'];
			ManfTakePicWindow = window.open(lnk, "take_photo_manf", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
		} else {
			ManfTakePicWindow.setType(AppName, rowid, typeCode, typeDesc, session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
			ManfTakePicWindow.focus();
		}
	}

}

var addPhManf = new Ext.Toolbar.Button({
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			//窗口显示
			CreateEditWin("");
		}
	});

var editPhManf = new Ext.Toolbar.Button({
		text: '编辑',
		tooltip: '编辑',
		id: 'EditManfBt',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = PhManfGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("error", "请选择数据!");
				return false;
			} else {
				CreateEditWin(rowObj[0].get("RowId"));
			}
		}
	});

var editPicPhManf = new Ext.Toolbar.Button({
		text: '资质图片',
		tooltip: '查看资质图片',
		id: 'EditManfPicBt',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = PhManfGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("error", "请选择数据!");
				return false;
			} else {
				var manf = rowObj[0].get("RowId");
				ShowManfPicWindow(manf);
			}
		}
	});

var formPanel = new Ext.ux.FormPanel({
		title: '厂商维护',
		tbar: [findPhManf, '-', addPhManf, '-', editPhManf, '-', editPicPhManf],
		items: [{
				xtype: 'fieldset',
				title: '查询条件',
				layout: 'column',
				style: 'padding:5px 0px 0px 5px',
				defaults: {
					border: false,
					columnWidth: .33,
					xtype: 'fieldset'
				},
				items: [{
						items: [conditionCodeField]
					}, {
						items: [conditionNameField]
					}, {
						items: [conditionactiveField]
					}
				]
			}
		]
	});

//分页工具栏
var PhManfPagingToolbar = new Ext.PagingToolbar({
		store: PhManfGridDs,
		pageSize: 30,
		displayInfo: true
	});

//表格
PhManfGrid = new Ext.ux.EditorGridPanel({
                id :'PhManfGrid',
		store: PhManfGridDs,
		title: '厂商明细',
		cm: PhManfGridCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: false
		}),
		loadMask: true,
		bbar: PhManfPagingToolbar,
		listeners: {
			'rowdblclick': function () {
				Ext.getCmp('EditManfBt').handler();
			}
		}
	});

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, PhManfGrid],
			renderTo: 'mainPanel'
		});
	findPhManf.handler();
});
