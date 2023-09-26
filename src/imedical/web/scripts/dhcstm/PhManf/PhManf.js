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
var PhManfGridUrl = 'dhcstm.phmanfaction.csp';
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
					name: 'SocialCreditCode'
				}, {
					name: 'SocialCreditExpDate'
				}, {
					name: 'DrugProductP'
				}, {
					name: 'DrugProductExp'
				}, {
					name: 'MatProductP'
				}, {
					name: 'MatProductExp'
				}, {
					name: 'ComLic'
				}, {
					name: 'ComLicDate'
				}, {
					name: 'Active'
				}, {
					name: 'BusinessRegNo'
				}, {
					name: 'BusinessRegExpDate'
				}, {
					name: 'OrgCode'
				}, {
					name: 'OrgCodeExpDate'
				}, {
					name: 'MatManLic'
				}, {
					name: 'MatManLicDate'
				}, {
					name: 'MANFProdEprsHygLic'
				}, {
					name: 'MANFProdEprsHygLicExpDate'
				}, {
					name: 'TaxRegNo'
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
				dataIndex: 'SocialCreditCode',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "社会信用码效期",
				dataIndex: 'SocialCreditExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "药物生产许可",
				dataIndex: 'DrugProductP',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "药物生产许可有效期",
				dataIndex: 'DrugProductExp',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "器械生产许可",
				dataIndex: 'MatProductP',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "器械生产许可有效期",
				dataIndex: 'MatProductExp',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "工商执照许可",
				dataIndex: 'ComLic',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "工商执照许可有效期",
				dataIndex: 'ComLicDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "工商注册号",
				dataIndex: 'BusinessRegNo',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "工商注册效期",
				dataIndex: 'BusinessRegExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "组织机构代码",
				dataIndex: 'OrgCode',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "组织机构代码效期",
				dataIndex: 'OrgCodeExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "税务登记号",
				dataIndex: 'TaxRegNo',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "器械经营许可证",
				dataIndex: 'MatManLic',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "器械经营许可证效期",
				dataIndex: 'MatManLicDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "生产企业卫生许可证",
				dataIndex: 'MANFProdEprsHygLic',
				width: 120,
				align: 'left',
				sortable: false
			}, {
				header: "生产企业卫生许可证效期",
				dataIndex: 'MANFProdEprsHygLicExpDate',
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
						drugProductPermitField.focus();
					}
				}
			}
		});

	//药物生产许可
	var drugProductPermitField = new Ext.form.TextField({
			id: 'drugProductPermitField',
			fieldLabel: '药物生产许可',
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProductPermitField').getValue() == "") {
							Handler = function () {
								drugProductPermitField.focus();
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
							drugProductExpDate.focus();
						}
					}
				}
			}
		});

	//药物生产许可有效期
	var drugProductExpDate = new Ext.ux.DateField({
			id: 'drugProductExpDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('drugProductExpDate').getValue() == "") {
							Handler = function () {
								drugProductExpDate.focus();
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
							matProductPermitField.focus();
						}
					}
				}
			}
		});

	//器械生产许可
	var matProductPermitField = new Ext.form.TextField({
			id: 'matProductPermitField',
			fieldLabel: '器械生产许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('matProductPermitField').getValue() == "") {
							Handler = function () {
								matProductPermitField.focus();
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
							matProductExpDate.focus();
						}
					}
				}
			}
		});

	//器械生产许可有效期
	var matProductExpDate = new Ext.ux.DateField({
			id: 'matProductExpDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('matProductExpDate').getValue() == "") {
							Handler = function () {
								matProductExpDate.focus();
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
							comLicField.focus();
						}
					}
				}
			}
		});

	//工商执照许可
	var comLicField = new Ext.form.TextField({
			id: 'comLicField',
			fieldLabel: '工商执照许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicField').getValue() == "") {
							Handler = function () {
								comLicField.focus();
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
							comLicExpDate.focus();
						}
					}
				}
			}
		});

	//工商执照许可有效期
	var comLicExpDate = new Ext.ux.DateField({
			id: 'comLicExpDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('comLicExpDate').getValue() == "") {
							Handler = function () {
								comLicExpDate.focus();
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
							BusinessRegNoField.focus();

						}
					}
				}
			}
		});
	//工商注册号
	var BusinessRegNoField = new Ext.form.TextField({
			id: 'BusinessRegNoField',
			fieldLabel: '工商注册号',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('BusinessRegNoField').getValue() == "") {
							Handler = function () {
								BusinessRegNoField.focus();
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
							BusinessRegExpDate.focus();
						}
					}
				}
			}
		});

	//工商注册效期
	var BusinessRegExpDate = new Ext.ux.DateField({
			id: 'BusinessRegExpDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('BusinessRegExpDate').getValue() == "") {
							Handler = function () {
								BusinessRegExpDate.focus();
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
							OrgCodeField.focus();
						}
					}
				}
			}
		});
	//组织机构代码
	var OrgCodeField = new Ext.form.TextField({
			id: 'OrgCodeField',
			fieldLabel: '组织机构代码',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('OrgCodeField').getValue() == "") {
							Handler = function () {
								OrgCodeField.focus();
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
							OrgCodeExpDate.focus();
						}
					}
				}
			}
		});

	//组织机构代码效期
	var OrgCodeExpDate = new Ext.ux.DateField({
			id: 'OrgCodeExpDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('BusinessRegExpDate').getValue() == "") {
							Handler = function () {
								OrgCodeExpDate.focus();
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
							TaxRegNoField.focus();
						}
					}
				}
			}
		});
	//税务登记号
	var TaxRegNoField = new Ext.form.TextField({
			id: 'TaxRegNoField',
			fieldLabel: '税务登记号',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('TaxRegNoField').getValue() == "") {
							Handler = function () {
								TaxRegNoField.focus();
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
							MatManLicField.focus();
						}
					}
				}
			}
		});
	//医疗器械经营许可证
	var MatManLicField = new Ext.form.TextField({
			id: 'MatManLicField',
			fieldLabel: '器械经营许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MatManLicField').getValue() == "") {
							Handler = function () {
								MatManLicField.focus();
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
							MatManLicDate.focus();
						}
					}
				}
			}
		});

	//医疗器械经营许可证效期
	var MatManLicDate = new Ext.ux.DateField({
			id: 'MatManLicDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MatManLicDate').getValue() == "") {
							Handler = function () {
								MatManLicDate.focus();
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
							MANFProdEprsHygLic.focus();
						}
					}
				}
			}
		});
	//医疗器械经营许可证
	var MANFProdEprsHygLic = new Ext.form.TextField({
			id: 'MANFProdEprsHygLic',
			fieldLabel: '生产企业卫生许可',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MANFProdEprsHygLic').getValue() == "") {
							Handler = function () {
								MANFProdEprsHygLic.focus();
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
							MANFProdEprsHygLicExpDate.focus();
						}
					}
				}
			}
		});

	//医疗器械经营许可证效期
	var MANFProdEprsHygLicExpDate = new Ext.ux.DateField({
			id: 'MANFProdEprsHygLicExpDate',
			fieldLabel: '有效期',
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (Ext.getCmp('MANFProdEprsHygLicExpDate').getValue() == "") {
							Handler = function () {
								MANFProdEprsHygLicExpDate.focus();
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

	var SocialCreditCode = new Ext.form.TextField({
			id: 'SocialCreditCode',
			fieldLabel: '社会信用码',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//社会信用码效期
	var SocialCreditExpDate = new Ext.ux.DateField({
			id: 'SocialCreditExpDate',
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
									items: [SocialCreditCode, SocialCreditExpDate, uploadButtonSocialCreditCode, uploadButtonSocialCreditCodeTP]
								}, {
									xtype: 'compositefield',
									items: [drugProductPermitField, drugProductExpDate, uploadButtonDrugProLic, uploadButtonDrugProLicTP]
								}, {
									xtype: 'compositefield',
									items: [matProductPermitField, matProductExpDate, uploadButtonInsProLic, uploadButtonInsProLicTP]
								}, {
									xtype: 'compositefield',
									items: [comLicField, comLicExpDate, uploadButtonComLic, uploadButtonComLicTP]
								}, {
									xtype: 'compositefield',
									items: [OrgCodeField, OrgCodeExpDate, uploadButtonOrgCode, uploadButtonOrgCodeTP]
								}, {
									xtype: 'compositefield',
									items: [MatManLicField, MatManLicDate, uploadButtonInsBusLic, uploadButtonInsBusLicTP]
								}, {
									xtype: 'compositefield',
									items: [MANFProdEprsHygLic, MANFProdEprsHygLicExpDate, uploadButtonMANFProdEprsHygLic, uploadButtonMANFProdEprsHygLicTP]
								}, {
									xtype: 'compositefield',
									items: [BusinessRegNoField, BusinessRegExpDate]
								}, {
									xtype: 'compositefield',
									items: [TaxRegNoField, uploadButtonTaxLic, uploadButtonTaxLicTP]
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
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue();
		if (drugProductExpDate != '') {
			drugProductExpDate = drugProductExpDate.format(ARG_DATEFORMAT);
		}
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue();
		if (matProductExpDate != '') {
			matProductExpDate = matProductExpDate.format(ARG_DATEFORMAT);
		}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate != '') {
			comLicExpDate = comLicExpDate.format(ARG_DATEFORMAT);
		}
		var BusinessRegNo = BusinessRegNoField.getValue();
		var BusinessRegExpDate = Ext.getCmp('BusinessRegExpDate').getValue();
		if (BusinessRegExpDate != '') {
			BusinessRegExpDate = BusinessRegExpDate.format(ARG_DATEFORMAT);
		}
		var OrgCode = OrgCodeField.getValue();
		var OrgCodeExpDate = Ext.getCmp('OrgCodeExpDate').getValue();
		if (OrgCodeExpDate != '') {
			OrgCodeExpDate = OrgCodeExpDate.format(ARG_DATEFORMAT);
		}
		var TaxRegNo = TaxRegNoField.getValue();
		var MatManLic = MatManLicField.getValue();
		var MatManLicDate = Ext.getCmp('MatManLicDate').getValue();
		if (MatManLicDate != '') {
			MatManLicDate = MatManLicDate.format(ARG_DATEFORMAT);
		}
		var MANFProdEprsHyg = MANFProdEprsHygLic.getValue();
		var MANFProdEprsHygLicExpDate = Ext.getCmp('MANFProdEprsHygLicExpDate').getValue();
		if (MANFProdEprsHygLicExpDate != '') {
			MANFProdEprsHygLicExpDate = MANFProdEprsHygLicExpDate.format(ARG_DATEFORMAT);
		}
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		var SocialCreditCode = Ext.getCmp('SocialCreditCode').getValue();
		var SocialCreditExpDate = Ext.getCmp('SocialCreditExpDate').getValue();
		if (SocialCreditExpDate != '') {
			SocialCreditExpDate = SocialCreditExpDate.format(ARG_DATEFORMAT);
		}
		if (code.trim() == "") {}

		if (name.trim() == "") {
			Msg.info('warning', "厂商名称不能为空");
			return;
		}

		//拼data字符串
		var data = code + "^" + name + "^" + address + "^" + phone + "^" + lastPhManfId
			 + "^" + drugProductPermit + "^" + drugProductExpDate + "^" + matProductPermit + "^" + matProductExpDate + "^" + comLic
			 + "^" + comLicExpDate + "^" + active + "^" + BusinessRegNo + "^" + BusinessRegExpDate + "^" + OrgCode
			 + "^" + OrgCodeExpDate + "^" + TaxRegNo + "^" + MatManLic + "^" + MatManLicDate + "^" + MANFProdEprsHyg
			 + "^" + MANFProdEprsHygLicExpDate + "^" + SocialCreditCode + "^" + SocialCreditExpDate;
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=insert',
			params: {
				data: data
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

		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue();
		if (drugProductExpDate != '') {
			drugProductExpDate = drugProductExpDate.format(ARG_DATEFORMAT);
		}

		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue();
		if (matProductExpDate != '') {
			matProductExpDate = matProductExpDate.format(ARG_DATEFORMAT);
		}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate != '') {
			comLicExpDate = comLicExpDate.format(ARG_DATEFORMAT);
		}
		var BusinessRegNo = BusinessRegNoField.getValue();
		var BusinessRegExpDate = Ext.getCmp('BusinessRegExpDate').getValue();
		if (BusinessRegExpDate != '') {
			BusinessRegExpDate = BusinessRegExpDate.format(ARG_DATEFORMAT);
		}
		var OrgCode = OrgCodeField.getValue();
		var OrgCodeExpDate = Ext.getCmp('OrgCodeExpDate').getValue();
		if (OrgCodeExpDate != '') {
			OrgCodeExpDate = OrgCodeExpDate.format(ARG_DATEFORMAT);
		}
		var TaxRegNo = TaxRegNoField.getValue();
		var MatManLic = MatManLicField.getValue();
		var MatManLicDate = Ext.getCmp('MatManLicDate').getValue();
		if (MatManLicDate != '') {
			MatManLicDate = MatManLicDate.format(ARG_DATEFORMAT);
		}
		var MANFProdEprsHyg = MANFProdEprsHygLic.getValue();
		var MANFProdEprsHygLicExpDate = Ext.getCmp('MANFProdEprsHygLicExpDate').getValue();
		if (MANFProdEprsHygLicExpDate != '') {
			MANFProdEprsHygLicExpDate = MANFProdEprsHygLicExpDate.format(ARG_DATEFORMAT);
		}
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		var SocialCreditCode = Ext.getCmp('SocialCreditCode').getValue();
		var SocialCreditExpDate = Ext.getCmp('SocialCreditExpDate').getValue();
		if (SocialCreditExpDate != '') {
			SocialCreditExpDate = SocialCreditExpDate.format(ARG_DATEFORMAT);
		}
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
		var data = rowid + "^" + code + "^" + name + "^" + address + "^" + phone
			 + "^" + lastPhManfId + "^" + drugProductPermit + "^" + drugProductExpDate + "^" + matProductPermit + "^" + matProductExpDate
			 + "^" + comLic + "^" + comLicExpDate + "^" + active + "^" + BusinessRegNo + "^" + BusinessRegExpDate
			 + "^" + OrgCode + "^" + OrgCodeExpDate + "^" + TaxRegNo + "^" + MatManLic + "^" + MatManLicDate
			 + "^" + MANFProdEprsHyg + "^" + MANFProdEprsHygLicExpDate + "^" + SocialCreditCode + "^" + SocialCreditExpDate;

		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: PhManfGridUrl + '?actiontype=update',
			params: {
				data: data
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
					var arr = value.split("^");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					addComboData(lastPhManfField.getStore(), arr[5], arr[6]);
					Ext.getCmp('lastPhManfField').setValue(arr[5]);
					Ext.getCmp('drugProductPermitField').setValue(arr[7]);
					Ext.getCmp('drugProductExpDate').setValue(arr[8]);
					Ext.getCmp('matProductPermitField').setValue(arr[9]);
					Ext.getCmp('matProductExpDate').setValue(arr[10]);
					Ext.getCmp('comLicField').setValue(arr[11]);
					Ext.getCmp('comLicExpDate').setValue(arr[12]);
					Ext.getCmp('activeField').setValue((arr[13] == "Y") ? true : false);

					Ext.getCmp('BusinessRegNoField').setValue(arr[14]);
					Ext.getCmp('BusinessRegExpDate').setValue(arr[15]);
					Ext.getCmp('OrgCodeField').setValue(arr[16]);
					Ext.getCmp('OrgCodeExpDate').setValue(arr[17]);
					Ext.getCmp('TaxRegNoField').setValue(arr[18]);
					Ext.getCmp('MatManLicField').setValue(arr[19]);
					Ext.getCmp('MatManLicDate').setValue(arr[20]);
					Ext.getCmp('MANFProdEprsHygLic').setValue(arr[21]);
					Ext.getCmp('MANFProdEprsHygLicExpDate').setValue(arr[22]);
					Ext.getCmp('SocialCreditCode').setValue(arr[23]);
					Ext.getCmp('SocialCreditExpDate').setValue(arr[24]);
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
