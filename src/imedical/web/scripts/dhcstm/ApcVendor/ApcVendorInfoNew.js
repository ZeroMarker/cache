// 名称:供应商管理
// 编写日期:2012-05-14

//创建编辑窗口(弹出)
//rowid :供应商rowid
var VendorTakePicWindow;
var gVendorPara = [];
function CreateEditWin() {
	setVendorParam();
	if (win) {
		win.show();
		return;
	}
	//供应商代码
	var codeField = new Ext.form.TextField({
			id: 'codeField',
			fieldLabel: '<font color=red>*供应商代码</font>',
			allowBlank: false,
			anchor: '90%',
			emptyText:'新建时代码为空,则系统自动生成...',
			selectOnFocus: true,
			listeners: {
				'change': function (x, n, o) {
					if (getVendorParamValue('CodeAlphaUp') == '1') {
						var s = n;
						x.setValue(s.toUpperCase());
					}
				}
			}
		});

	var barcodePrefix = new Ext.form.TextField({
			id: 'barcodePrefix',
			fieldLabel: '高值条码前缀',
			anchor: '90%'
		});

	//供应商名称
	var nameField = new Ext.form.TextField({
			id: 'nameField',
			fieldLabel: '<font color=red>*供应商名称</font>',
			allowBlank: false,
			anchor: '90%',
			selectOnFocus: true,
			listeners: {
				'change': function (x, n, o) {
					if (getVendorParamValue('NameAlphaUp') == '1') {
						var s = n;
						x.setValue(s.toUpperCase());
					}
				}
			}
		});

	//供应商简称
	var abbrevField = new Ext.form.TextField({
			id: 'abbrevField',
			fieldLabel: '供应商简称',
			anchor: '90%',
			selectOnFocus: true
		});

	var VendorAlias = new Ext.form.TextField({
			id: 'VendorAlias',
			fieldLabel: '助记码',
			anchor: '90%',
			maxLength: 20
		});

	///上级供应商
	var parField = new Ext.ux.VendorComboBox({
			id: 'parField',
			fieldLabel: '上一级供应商',
			anchor: '90%',
			width: 143,
			listWidth: 250,
			allowBlank: true,
			triggerAction: 'all',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			listeners: {
				'beforeselect': function (c, rec, index) {
					if (rec.get('Description') == Ext.getCmp('nameField').getValue()) {
						Msg.info("error", "与当前供应商相同，不允许!");
						return false;
					}
				}
			}
		});

	//业务员姓名
	var bussPersonField = new Ext.form.TextField({
			id: 'bussPersonField',
			fieldLabel: '姓名',
			allowBlank: true,
			anchor: '95%',
			selectOnFocus: true
		});

	//业务员证书有效期
	var validDate = new Ext.ux.DateField({
			id: 'validDate',
			fieldLabel: '授权书效期',
			allowBlank: true,
			anchor: '95%'
		});

	var salsLicPicAddButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传业务员授权书',
			handler: function () {
				addpicAPCVendor("salesLic");
			}
		});

	//业务员授权书
	var salsLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照业务员授权书',
			handler: function () {
				take_pic("salesLic", "业务员授权书");
			}
		});

	//业务员电话
	var phoneField = new Ext.form.TextField({
			id: 'phoneField',
			fieldLabel: '电话',
			anchor: '95%',
			allowBlank: true
		});

	//业务员身份证
	var salesIDField = new Ext.form.TextField({
			id: 'salesIDField',
			anchor: '95%',
			fieldLabel: '身份证',
			allowBlank: true
		});

	var salesIDButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传身份证复印件',
			handler: function () {
				addpicAPCVendor("salesID");
			}
		});

	var salesIDButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照身份证复印件',
			handler: function () {
				take_pic("salesID", "身份证复印件");
			}
		});

	var salsPhotoButton = new Ext.Toolbar.Button({
			text: '上传照片',
			tooltip: '上传业务员照片',
			handler: function () {
				addpicAPCVendor("salsPhoto");
			}
		});

	//业务员邮箱
	var emailField = new Ext.form.TextField({
			id: 'emailField',
			anchor: '95%',
			fieldLabel: '邮箱',
			allowBlank: true
		});

	//业务员配送电话(配送手机号)
	var salesCarrTelField = new Ext.form.TextField({
			id: 'salesCarrTelField',
			anchor: '95%',
			fieldLabel: '配送手机号',
			allowBlank: true
		});

	//业务员传真
	var salesFaxField = new Ext.form.TextField({
			id: 'salesFaxField',
			anchor: '95%',
			fieldLabel: '传真',
			allowBlank: true
		});

	//供应商代码
	var addressField = new Ext.form.TextField({
			id: 'addressField',
			fieldLabel: '供应商地址',
			allowBlank: true,
			anchor: '95.5%',
			selectOnFocus: true
		});

	//供应商电话
	var telField = new Ext.form.TextField({
			id: 'telField',
			fieldLabel: '供应商电话',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//分类
	var categoryField = new Ext.form.ComboBox({
			id: 'categoryField',
			fieldLabel: '分类',
			anchor: '90%',
			listWidth: 250,
			allowBlank: true,
			store: GetVendorCatStore,
			valueField: 'RowId',
			displayField: 'Description',
			triggerAction: 'all',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: true,
			editable: true
		});

	//账户
	var ctrlAcctField = new Ext.form.TextField({
			id: 'ctrlAcctField',
			fieldLabel: '账户',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//开户银行
	var bankField = new Ext.form.TextField({
			id: 'bankField',
			fieldLabel: '开户银行',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//注册资金
	var crAvailField = new Ext.form.NumberField({
			id: 'crAvailField',
			fieldLabel: '注册资金',
			allowBlank: true,
			allowNegative: false,
			anchor: '90%',
			selectOnFocus: true
		});

	//采购金额
	var feeField = new Ext.form.NumberField({
			id: 'feeField',
			fieldLabel: '采购金额',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//合同截止日期
	var lstPoDate = new Ext.ux.DateField({
			id: 'lstPoDate',
			fieldLabel: '合同截止日期',
			allowBlank: true,
			disabled: false,
			anchor: '90%'
		});

	//最后业务日期
	var lstBsDate = new Ext.ux.DateField({
			id: 'lstBsDate',
			fieldLabel: '最后业务日期',
			allowBlank: true,
			disabled: true,
			anchor: '90%'
		});

	//传真
	var faxField = new Ext.form.TextField({
			id: 'faxField',
			fieldLabel: '传真',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//法人
	var corporationField = new Ext.form.TextField({
			id: 'corporationField',
			fieldLabel: '法人(联系人)',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//法人身份证
	var presidentField = new Ext.form.TextField({
			id: 'presidentField',
			fieldLabel: '法人身份证',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//法人联系电话
	var presidentTelField = new Ext.form.TextField({
			id: 'presidentTelField',
			fieldLabel: '法人联系电话',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//状态
	var stateStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [["A", '使用'], ["S", '停用']]
		});

	var stateField = new Ext.form.ComboBox({
			id: 'stateField',
			fieldLabel: '使用状态',
			allowBlank: true,
			store: stateStore,
			value: 'A', // 默认值"使用"
			valueField: 'key',
			displayField: 'keyValue',
			triggerAction: 'all',
			anchor: '90%',
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			mode: 'local'
		});

	//限制供应
	var limitSupplyField = new Ext.form.Checkbox({
			id: 'limitSupplyField',
			boxLabel: '限制供应(中间商)',
			// fieldLabel:'限制供应(中间商)',
			hideLabel: true,
			allowBlank: true
		});

	var SmsField = new Ext.form.Checkbox({
			id: 'SmsField',
			boxLabel: '短信通知',
			hideLabel: true,
			allowBlank: true
		});

	var PurchPlatField = new Ext.form.Checkbox({
			id: 'PurchPlatField',
			boxLabel: '平台通知',
			hideLabel: true,
			allowBlank: true
		});

	var Universal = new Ext.form.Checkbox({
			id: 'Universal',
			boxLabel: '通用标志',
			hideLabel: true,
			checked: true,
			allowBlank: true
		});

	//工商执照
	var comLicText = new Ext.form.TextField({
			id: 'comLicText',
			fieldLabel: '工商执照',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var comLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传工商执照',
			handler: function () {
				addpicAPCVendor("comLic");
			}
		});
	var comLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照工商执照',
			handler: function () {
				take_pic("comLic", "工商执照");
			}
		});

	//工商执照有效期
	var comLicDateTo = new Ext.ux.DateField({
			id: 'comLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});
	//税务执照
	var taxLicText = new Ext.form.TextField({
			id: 'taxLicText',
			fieldLabel: '税务执照',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var taxLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传税务执照',
			handler: function () {
				addpicAPCVendor("taxLic")
			}
		});
	var taxLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照税务执照',
			handler: function () {
				take_pic("taxLic", "税务执照");
			}
		});
	//税务执照有效期
	var taxLicDateTo = new Ext.ux.DateField({
			id: 'taxLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//机构代码
	var orgCodeText = new Ext.form.TextField({
			id: 'orgCodeText',
			fieldLabel: '机构代码',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var orgCodeButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传机构代码',
			handler: function () {
				addpicAPCVendor("orgCode")
			}
		});
	var orgCodeButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照机构代码',
			handler: function () {
				take_pic("orgCode", "机构代码");
			}
		});
	//机构代码有效期
	var orgCodeDateTo = new Ext.ux.DateField({
			id: 'orgCodeDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//药品经营许可证
	var drugBusLicText = new Ext.form.TextField({
			id: 'drugBusLicText',
			fieldLabel: '药品经营许可证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var drugBusLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传药品经营许可证',
			handler: function () {
				addpicAPCVendor("drugBusLic")
			}
		});
	var drugBusLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照药品经营许可证',
			handler: function () {
				take_pic("drugBusLic", "药品经营许可证");
			}
		});
	//药品经营许可证有效期
	var drugBusLicDateTo = new Ext.ux.DateField({
			id: 'drugBusLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//器械经营许可证
	var insBusLicText = new Ext.form.TextField({
			id: 'insBusLicText',
			fieldLabel: '器械经营许可证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var insBusLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传器械经营许可证',
			handler: function () {
				addpicAPCVendor("insBusLic")
			}
		});

	var insBusLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照器械经营许可证',
			handler: function () {
				take_pic("insBusLic", "器械经营许可证");
			}
		});
	//器械经营许可证有效期
	var insBusLicDateTo = new Ext.ux.DateField({
			id: 'insBusLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//器械生产许可证
	var insProLicText = new Ext.form.TextField({
			id: 'insProLicText',
			fieldLabel: '器械生产许可证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var insProLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传器械生产许可证',
			handler: function () {
				addpicAPCVendor("insProLic")
			}
		});
	var insProLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照器械生产许可证',
			handler: function () {
				take_pic("insProLic", "器械生产许可证");
			}
		});
	//器械生产许可证有效期
	var insProLicDateTo = new Ext.ux.DateField({
			id: 'insProLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//质量承诺书
	var qualityCommText = new Ext.form.TextField({
			id: 'qualityCommText',
			fieldLabel: '质量承诺书',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var qualityCommButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传质量承诺书',
			handler: function () {
				addpicAPCVendor("qualityCommText")
			}
		});
	var qualityCommButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照质量承诺书',
			handler: function () {
				take_pic("qualityCommText", "质量承诺书");
			}
		});
	//质量承诺书有效期
	var qualityCommDateTo = new Ext.ux.DateField({
			id: 'qualityCommDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//供应商协议
	var vendorAgreementText = new Ext.form.TextField({
			id: 'vendorAgreementText',
			fieldLabel: '供应商协议',
			width: 90,
			allowBlank: true,
			selectOnFocus: true,
			hidden: true
		});

	//供应商协议上传
	var agreementButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传供应商协议',
			handler: function () {
				addpicAPCVendor("vendorAgreement")
			}
		});

	var agreementButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照供应商协议',
			handler: function () {
				take_pic("vendorAgreement", "供应商协议");
			}
		});

	//代理授权书
	var agentAuthText = new Ext.form.TextField({
			id: 'agentAuthText',
			fieldLabel: '代理授权书',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var agentAuthButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传代理授权书',
			handler: function () {
				addpicAPCVendor("agentAuth")
			}
		});

	var agentAuthButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照代理授权书',
			handler: function () {
				take_pic("agentAuth", "代理授权书");
			}
		});
	//代理授权书有效期
	var agentAuthDateTo = new Ext.ux.DateField({
			id: 'agentAuthDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//售后服务承诺书
	var saleServCommText = new Ext.form.TextField({
			id: 'saleServCommText',
			fieldLabel: '售后服务承诺书',
			width: 200,
			allowBlank: true,
			selectOnFocus: true
		});
	var saleServCommButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传售后服务承诺书',
			handler: function () {
				addpicAPCVendor("saleServComm")
			}
		});
	var saleServCommButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照售后服务承诺书',
			handler: function () {
				take_pic("saleServComm", "售后服务承诺书");
			}
		});
	//法人委托书
	var legalCommText = new Ext.form.TextField({
			id: 'legalCommText',
			fieldLabel: '法人委托书',
			width: 200,
			allowBlank: true,
			selectOnFocus: true
		});
	var legalCommButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传法人委托书',
			handler: function () {
				addpicAPCVendor("legalComm");
			}
		});
	var legalCommButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照法人委托书',
			handler: function () {
				take_pic("legalComm", "法人委托书");
			}
		});

	//药品生产许可证
	var drugProLicText = new Ext.form.TextField({
			id: 'drugProLicText',
			fieldLabel: '药品生产许可证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var drugProLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传药品生产许可证',
			handler: function () {
				addpicAPCVendor("drugProLic")
			}
		});
	var drugProLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照药品生产许可证',
			handler: function () {
				take_pic("drugProLic", "药品生产许可证");
			}
		});
	//药品生产许可证有效期
	var drugProLicDateTo = new Ext.ux.DateField({
			id: 'drugProLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//药品注册批件
	var drugRegLicText = new Ext.form.TextField({
			id: 'drugRegLicText',
			fieldLabel: '药品注册批件',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var drugRegLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传药品注册批件',
			handler: function () {
				addpicAPCVendor("drugRegLic")
			}
		});
	var drugRegLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照药品注册批件',
			handler: function () {
				take_pic("drugRegLic", "药品注册批件");
			}
		});
	//药品注册批件有效期
	var drugRegLicDateTo = new Ext.ux.DateField({
			id: 'drugRegLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//GSP认证
	var gspLicText = new Ext.form.TextField({
			id: 'gspLicText',
			fieldLabel: 'GSP认证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var gspLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传GSP认证',
			handler: function () {
				addpicAPCVendor("gspLic")
			}
		});
	var gspLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照GSP认证',
			handler: function () {
				take_pic("gspLic", "GSP认证");
			}
		});
	//GSP认证有效期
	var gspLicDateTo = new Ext.ux.DateField({
			id: 'gspLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//器械注册证
	var insRegLicText = new Ext.form.TextField({
			id: 'insRegLicText',
			fieldLabel: '器械注册证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var insRegLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传器械注册证',
			handler: function () {
				addpicAPCVendor("insRegLic")
			}
		});
	var insRegLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照器械注册证',
			handler: function () {
				take_pic("insRegLic", "器械注册证");
			}
		});
	//器械注册证有效期
	var insRegLicDateTo = new Ext.ux.DateField({
			id: 'insRegLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//进口注册登记表
	var inletRegLicText = new Ext.form.TextField({
			id: 'inletRegLicText',
			fieldLabel: '进口注册登记表',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var inletRegLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传进口注册登记表',
			handler: function () {
				addpicAPCVendor("inletRegLic")
			}
		});
	var inletRegLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照进口注册登记表',
			handler: function () {
				take_pic("inletRegLic", "进口注册登记表");
			}
		});
	//进口注册登记表有效期
	var inletRegLicDateTo = new Ext.ux.DateField({
			id: 'inletRegLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//进口注册证
	var inletRLicText = new Ext.form.TextField({
			id: 'inletRLicText',
			fieldLabel: '进口注册证',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var inletRLicButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传进口注册证',
			handler: function () {
				addpicAPCVendor("inletRLic")
			}
		});
	var inletRLicButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照进口注册证',
			handler: function () {
				take_pic("inletRLic", "进口注册证");
			}
		});
	//进口注册证有效期
	var inletRLicDateTo = new Ext.ux.DateField({
			id: 'inletRLicDateTo',
			fieldLabel: '有效期',
			allowBlank: true
		});

	var bankLicApprovalNo = new Ext.form.TextField({
			id: 'bankLicApprovalNo',
			fieldLabel: '许可证核准号',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var bankLicNo = new Ext.form.TextField({
			id: 'bankLicNo',
			fieldLabel: '许可证编号',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var socialCreditCommText = new Ext.form.TextField({
			id: 'socialCreditCommText',
			fieldLabel: '社会信用码',
			width: 90,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var socialCreditCommDateTo = new Ext.ux.DateField({
			id: 'socialCreditCommDateTo',
			fieldLabel: '有效期',
			allowBlank: true,
			anchor: '90%'
		});
	
	var socialCreditCommButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传社会信用码',
			handler: function () {
				addpicAPCVendor("socialCreditComm")
			}
		});
	var socialCreditCommButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照社会信用码',
			handler: function () {
				take_pic("socialCreditComm", "社会信用码");
			}
		});

	var businessTerm = new Ext.ux.DateField({
			id: 'businessTerm',
			fieldLabel: '营业期限',
			allowBlank: true,
			anchor: '90%'
		});

	var establishedDate = new Ext.ux.DateField({
			id: 'establishedDate',
			fieldLabel: '成立日期',
			allowBlank: true,
			anchor: '90%'
		});

	var vendorEmail = new Ext.form.TextField({
			id: 'vendorEmail',
			fieldLabel: '邮箱',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var coRenameFlag = new Ext.form.Checkbox({
			id: 'coRenameFlag',
			boxLabel: '公司更名标志',
			hideLabel: true,
			checked: false,
			allowBlank: true
		});

	var carryFlag = new Ext.form.Checkbox({
			id: 'carryFlag',
			boxLabel: '转配送标志',
			hideLabel: true,
			checked: false,
			allowBlank: true
		});

	var regAddress = new Ext.form.TextField({
			id: 'regAddress',
			fieldLabel: '注册地址',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var responsiblePerson = new Ext.form.TextField({
			id: 'responsiblePerson',
			fieldLabel: '企业负责人',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var qualityManager = new Ext.form.TextField({
			id: 'qualityManager',
			fieldLabel: '质量管理人',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var depotAddress = new Ext.form.TextField({
			id: 'depotAddress',
			fieldLabel: '仓库地址',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var filingVoucher = new Ext.form.TextField({
			id: 'filingVoucher',
			fieldLabel: '备案凭证',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var matCatOfficial = new Ext.ux.MatCatComboBox({
			fieldLabel: '官方分类',
			id: 'matCatOfficial',
			url: 'dhcstm.mulmatcataction.csp?actiontype=GetChildNode',
			rootId: 'AllMCO',
			rootParam: 'NodeId',
			anchor: '90%'
		});
	//工商执照
	var comLicIssuedDate = new Ext.ux.DateField({
			id: 'comLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var comLicIssuedDept = new Ext.form.TextField({
			id: 'comLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//税务登记证
	var taxLicIssuedDate = new Ext.ux.DateField({
			id: 'taxLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var taxLicIssuedDept = new Ext.form.TextField({
			id: 'taxLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//机构代码
	var orgCodeIssuedDate = new Ext.ux.DateField({
			id: 'orgCodeIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var orgCodeIssuedDept = new Ext.form.TextField({
			id: 'orgCodeIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//药品经营许可证
	var drugBusLicIssuedDate = new Ext.ux.DateField({
			id: 'drugBusLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var drugBusLicIssuedDept = new Ext.form.TextField({
			id: 'drugBusLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//器械经营许可证
	var insBusLicIssuedDate = new Ext.ux.DateField({
			id: 'insBusLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var insBusLicIssuedDept = new Ext.form.TextField({
			id: 'insBusLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//器械生产许可证
	var insProLicIssuedDate = new Ext.ux.DateField({
			id: 'insProLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var insProLicIssuedDept = new Ext.form.TextField({
			id: 'insProLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//GSP认证
	var gspLicIssuedDate = new Ext.ux.DateField({
			id: 'gspLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var gspLicIssuedDept = new Ext.form.TextField({
			id: 'gspLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//药品生产许可证
	var drugProLicIssuedDate = new Ext.ux.DateField({
			id: 'drugProLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var drugProLicIssuedDept = new Ext.form.TextField({
			id: 'drugProLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	var MatQuaAgrement = new Ext.form.Checkbox({
			id: 'MatQuaAgrement',
			boxLabel: '医疗器械质量保证协议书',
			hideLabel: true,
			allowBlank: true
		});

	var SealRecordTable = new Ext.form.Checkbox({
			id: 'SealRecordTable',
			boxLabel: '供应商印章备案',
			hideLabel: true,
			allowBlank: true
		});
	// 账期
	var AccountPeriod = new Ext.form.NumberField({
			id: 'AccountPeriod',
			fieldLabel: '账期',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//初始化添加按钮
	var okButton = new Ext.Toolbar.Button({
			text: '保存',
			iconCls: 'page_save',
			handler: function () {
				var ss = getVendorDataStr();
				var qualityss = getVendorQualityDataStr();
				if (typeof(ss) == 'undefined' || ss == "") {
					return;
				}
				if (typeof(qualityss) == 'undefined' || qualityss == "") {
					return;
				}
				if (currVendorRowId != '') {
					ss = currVendorRowId + '^' + ss;
					UpdVendorInfo(ss,qualityss); //执行更新}
				} else {
					InsVendorInfo(ss,qualityss); //执行插入
				}

			}
		});

	//初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({
			text: '关闭',
			iconCls: 'page_close',
			handler: function () {
				if (win) {
					win.hide();
				}
			}
		});
	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
			labelWidth: 90,
			labelAlign: 'right',
			frame: true,
			autoScroll: true,
			bodyStyle: 'padding:5px;',
			items: [{
					xtype: 'fieldset',
					title: '基本信息',
					autoHeight: true,
					items: [{
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [codeField]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [nameField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [barcodePrefix]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [categoryField]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [lstBsDate]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [VendorAlias]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [corporationField]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [presidentField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [presidentTelField]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [ctrlAcctField]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [crAvailField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [feeField]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [bankField]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [bankLicApprovalNo]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [bankLicNo]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [businessTerm]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [establishedDate]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [lstPoDate]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [abbrevField]
								}, {
									columnWidth: .65,
									layout: 'form',
									labelWidth: 100,
									items: [addressField]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [telField]
								}, {
									columnWidth: .35,
									layout: 'form',
									labelWidth: 100,
									items: [faxField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [vendorEmail]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [AccountPeriod]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .2,
									layout: 'form',
									items: [stateField]
								}, {
									columnWidth: .17,
									layout: 'form',
									items: [limitSupplyField]
								}, {
									columnWidth: .11,
									layout: 'form',
									items: [SmsField]
								}, {
									columnWidth: .11,
									layout: 'form',
									items: [PurchPlatField]
								}, {
									columnWidth: .11,
									layout: 'form',
									items: [Universal]
								}, {
									columnWidth: .15,
									layout: 'form',
									items: [coRenameFlag]
								}, {
									columnWidth: .13,
									layout: 'form',
									items: [carryFlag]
								}
							]
						}
					]
				}, {
					xtype: 'fieldset',
					title: '资质信息',
					autoHeight: true,
					items: [{
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [comLicText, comLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [comLicIssuedDate, comLicIssuedDept, comLicButton, comLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [taxLicText, taxLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [taxLicIssuedDate, taxLicIssuedDept, taxLicButton, taxLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [orgCodeText, orgCodeDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [orgCodeIssuedDate, orgCodeIssuedDept, orgCodeButton, orgCodeButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [drugBusLicText, drugBusLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [drugBusLicIssuedDate, drugBusLicIssuedDept, drugBusLicButton, drugBusLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [insBusLicText, insBusLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [insBusLicIssuedDate, insBusLicIssuedDept, insBusLicButton, insBusLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [insProLicText, insProLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [insProLicIssuedDate, insProLicIssuedDept, insProLicButton, insProLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [drugProLicText, drugProLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [drugProLicIssuedDate, drugProLicIssuedDept, drugProLicButton, drugProLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .42,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [gspLicText, gspLicDateTo]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [gspLicIssuedDate, gspLicIssuedDept, gspLicButton, gspLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [socialCreditCommText, socialCreditCommDateTo, socialCreditCommButton, socialCreditCommButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 146,
									items: [{
											xtype: 'compositefield',
											items: [qualityCommText, qualityCommDateTo, qualityCommButton, qualityCommButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [saleServCommText, saleServCommButton, saleServCommButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 146,
									items: [{
											xtype: 'compositefield',
											items: [legalCommText, legalCommButton, legalCommButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							hidden: true, //2016-06-27 把不需要显示的暂时设置hide,放在一起(否则getValue获取到undefined)
							items: [{
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [vendorAgreementText, agreementButton, agreementButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [inletRegLicText, inletRegLicDateTo, inletRegLicButton, inletRegLicButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [inletRLicText, inletRLicDateTo, inletRLicButton, inletRLicButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [agentAuthText, agentAuthDateTo, agentAuthButton, agentAuthButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [drugRegLicText, drugRegLicDateTo, drugRegLicButton, drugRegLicButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [insRegLicText, insRegLicDateTo, insRegLicButton, insRegLicButtonTP]
										}
									]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [regAddress]
								}, {
									columnWidth: .35,
									layout: 'form',
									items: [responsiblePerson]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [qualityManager]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [depotAddress]
								}, {
									columnWidth: .35,
									layout: 'form',
									items: [filingVoucher]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [matCatOfficial]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .35,
									layout: 'form',
									items: [MatQuaAgrement]
								}, {
									columnWidth: .35,
									layout: 'form',
									items: [SealRecordTable]
								}
							]
						}
					]
				}, {
					autoHeight: true,
					xtype: 'fieldset',
					title: '业务员授权书信息',
					labelWidth: 70,
					items: [{
							layout: 'column',
							items: [{
									columnWidth: .21,
									layout: 'form',
									items: [bussPersonField]
								}, {
									columnWidth: .09,
									xtype: 'compositefield',
									items: [salsPhotoButton]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [phoneField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [salesIDField]
								}, {
									columnWidth: .1,
									xtype: 'compositefield',
									items: [salesIDButton, salesIDButtonTP]
								}
							]
						},{
							layout: 'column',
							items: [{
									columnWidth: .3,
									layout: 'form',
									items: [emailField,salesFaxField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [salesCarrTelField]
								}, {
									columnWidth: .3,
									layout: 'form',
									items: [validDate]
								}, {
									columnWidth: .1,
									xtype: 'compositefield',
									items: [salsLicPicAddButton, salsLicButtonTP]
								}
							]
						}
					]
				}
			]
		});

	//初始化窗口
	win = new Ext.Window({
			title: '供应商信息维护',
			width: gWinWidth,
			height: gWinHeight,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'right',
			items: vendorPanel,
			closeAction: 'hide',
			buttons: [okButton, cancelButton],
			listeners: {
				'show': function () {
					if (currVendorRowId != '') {
						SetVendorInfo(currVendorRowId);
					}else{
						Ext.getCmp('stateField').setValue("A");
					}
				},
				'beforehide': function (e) {
					clearPanel(vendorPanel);
					Ext.getCmp('Universal').setValue('Y');
				}
			}
		});

	win.show();

	//显示供应商信息
	function SetVendorInfo(rowid) {
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=queryByRowId&rowid=' + rowid,
			failure: function (result, request) {
				Msg.info('error', '失败！');
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var value = jsonData.info;
					var AllArr=value.split("&");
					var arr = AllArr[0].split("^");
					var QualityStr = AllArr[1];
					//基础信息
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('categoryField').setValue(arr[10]);
					Ext.getCmp('categoryField').setRawValue(arr[11]);
					Ext.getCmp('corporationField').setValue(arr[7]);
					Ext.getCmp('presidentField').setValue(arr[8]);
					Ext.getCmp('ctrlAcctField').setValue(arr[4]);
					Ext.getCmp('bankField').setValue(arr[3]);
					Ext.getCmp('crAvailField').setValue(arr[12]);
					Ext.getCmp('lstPoDate').setValue(arr[13]);
					Ext.getCmp('addressField').setValue(arr[14]);
					Ext.getCmp('telField').setValue(arr[2]);
					Ext.getCmp('faxField').setValue(arr[6]);
					Ext.getCmp('limitSupplyField').setValue(arr[15] == "Y" ? true : false);
					Ext.getCmp('feeField').setValue(arr[5]);
					var stateField = (arr[9] == 'A') || (arr[9] == 'Active') ? 'A' : 'S';
					Ext.getCmp('stateField').setValue(stateField);
					addComboData(Ext.getCmp('matCatOfficial').getStore(), arr[44], arr[47], matCatOfficial);
					Ext.getCmp('matCatOfficial').setValue(arr[44]);
					Ext.getCmp('SealRecordTable').setValue(arr[49]);
					Ext.getCmp('MatQuaAgrement').setValue(arr[45]);
					Ext.getCmp('AccountPeriod').setValue(arr[46]);
					
					//业务员授权信息
					Ext.getCmp('bussPersonField').setValue(arr[16]);
					Ext.getCmp('validDate').setValue(arr[17]);
					Ext.getCmp('phoneField').setValue(arr[18]);
					Ext.getCmp('salesIDField').setValue(arr[19]);
					addComboData(Ext.getCmp("parField").getStore(), arr[20], arr[21]);
					Ext.getCmp("parField").setValue(arr[20]);
					Ext.getCmp("abbrevField").setValue(arr[22]);
					Ext.getCmp('presidentTelField').setValue(arr[23]); //法人电话
					Ext.getCmp('emailField').setValue(arr[24]); //邮箱
					Ext.getCmp('salesCarrTelField').setValue(arr[25]);
					Ext.getCmp('SmsField').setValue(arr[26] == "Y" ? true : false);
					Ext.getCmp('PurchPlatField').setValue(arr[27] == "Y" ? true : false);
					Ext.getCmp('Universal').setValue(arr[28] == "Y" ? true : false);
					Ext.getCmp('barcodePrefix').setValue(arr[29]);
					Ext.getCmp('lstBsDate').setValue(arr[30]);
					Ext.getCmp('salesFaxField').setValue(arr[48]);
					//新增信息
					Ext.getCmp('VendorAlias').setValue(arr[31]);
					Ext.getCmp('bankLicApprovalNo').setValue(arr[32]);
					Ext.getCmp('bankLicNo').setValue(arr[33]);
					//Ext.getCmp('socialCreditCommText').setValue(arr[34]);
					Ext.getCmp('businessTerm').setValue(arr[34]);
					Ext.getCmp('establishedDate').setValue(arr[34]);
					Ext.getCmp('vendorEmail').setValue(arr[36]);
					Ext.getCmp('coRenameFlag').setValue(arr[37] == "Y" ? true : false);
					Ext.getCmp('carryFlag').setValue(arr[38] == "Y" ? true : false);
					Ext.getCmp('regAddress').setValue(arr[39]);
					Ext.getCmp('responsiblePerson').setValue(arr[40]);
					Ext.getCmp('qualityManager').setValue(arr[41]);
					Ext.getCmp('depotAddress').setValue(arr[42]);
					Ext.getCmp('filingVoucher').setValue(arr[43]);

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
				}
			},
			scope: this
		});
	}

	//取得供应商基本信息串
	function getVendorDataStr() {
		var code = codeField.getValue();
		var name = nameField.getValue();
		/*if (code.trim() == "") {
			Msg.info("warning", "供应商代码为空!");
			return;
		}*/
		if (name.trim() == "") {
			Msg.info("warning", "供应商名称为空!");
			return;
		}
		//简称
		var abbrev = abbrevField.getValue();

		//上一级供应商
		var parVendor = parField.getValue();

		//供应商分类
		var categoryId = categoryField.getValue();
		//法人(联系人 )
		var President = corporationField.getValue();
		//法人身份证
		var president = presidentField.getValue();

		var presidentTel = presidentTelField.getValue();
		//账户
		var ctrlAcct = ctrlAcctField.getValue();
		//开户行
		var ConPerson = bankField.getValue();
		//注册资金
		var crAvail = crAvailField.getValue();
		if ((crAvail != "" && crAvail < 1) || crAvail === 0) {
			Msg.info("warning", "注册资金最少为1元!");
			return;
		}
		//合同截止日期
		var lstPoDate = Ext.getCmp('lstPoDate').getValue();
		if ((lstPoDate != "") && (lstPoDate != null)) {
			lstPoDate = lstPoDate.format(ARG_DATEFORMAT);
		}
		//地址
		var address = addressField.getValue();
		//供应商电话
		var tel = telField.getValue();
		//供应商传真
		var fax = faxField.getValue();
		//限制供应
		var isLimitSupply = (limitSupplyField.getValue() == true) ? 'Y' : 'N';
		//采购金额
		var fee = feeField.getValue();
		//使用状态
		var state = stateField.getValue();

		

		//业务员授权信息
		//业务员姓名
		var bussPerson = bussPersonField.getValue();
		//证书有效期
		var validDate = Ext.getCmp('validDate').getValue();
		if ((validDate != "") && (validDate != null)) {
			validDate = validDate.format(ARG_DATEFORMAT);
		}
		//业务员电话
		var phone = phoneField.getValue();
		//业务员身份证
		var salseID = salesIDField.getValue();
		var email = emailField.getValue();

		var salesCarrTel = salesCarrTelField.getValue();
		var Sms = (SmsField.getValue() == true) ? 'Y' : 'N';
		var PurchPlat = (PurchPlatField.getValue() == true) ? 'Y' : 'N';
		var universal = (Universal.getValue() == true) ? 'Y' : 'N';
		var barcodePre = Ext.getCmp('barcodePrefix').getValue();

		//最后业务日期
		var lstbsDate = Ext.getCmp('lstBsDate').getValue();
		if ((lstbsDate != "") && (lstbsDate != null)) {
			lstbsDate = lstbsDate.format(ARG_DATEFORMAT);
		}
		var VendorAlias = Ext.getCmp('VendorAlias').getValue();

		var bankLicApprovalNo = Ext.getCmp('bankLicApprovalNo').getValue();
		var bankLicNo = Ext.getCmp('bankLicNo').getValue();
		
		var businessTerm = Ext.getCmp('businessTerm').getValue();
		if ((businessTerm != "") && (businessTerm != null)) {
			businessTerm = businessTerm.format(ARG_DATEFORMAT);
		}
		var establishedDate = Ext.getCmp('establishedDate').getValue();
		if ((establishedDate != "") && (establishedDate != null)) {
			establishedDate = establishedDate.format(ARG_DATEFORMAT);
		}
		var vendorEmail = Ext.getCmp('vendorEmail').getValue();
		var coRenameFlag = (Ext.getCmp('coRenameFlag').getValue() == true) ? 'Y' : 'N';
		var carryFlag = (Ext.getCmp('carryFlag').getValue() == true) ? 'Y' : 'N';
		var regAddress = Ext.getCmp('regAddress').getValue();
		var responsiblePerson = Ext.getCmp('responsiblePerson').getValue();
		var qualityManager = Ext.getCmp('qualityManager').getValue();
		var depotAddress = Ext.getCmp('depotAddress').getValue();
		var filingVoucher = Ext.getCmp('filingVoucher').getValue();
		var matCatOfficial = Ext.getCmp('matCatOfficial').getValue();
		var salesFaxField = Ext.getCmp('salesFaxField').getValue();
		var SealRecordTable = Ext.getCmp('SealRecordTable').getValue()? 'Y' : 'N';
		var MatQuaAgrement = Ext.getCmp('MatQuaAgrement').getValue()? 'Y' : 'N';
		var AccountPeriod = Ext.getCmp("AccountPeriod").getValue(); ///账期
		
		//拼data字符串
		var data = code + "^" + name + "^" + tel + "^" + ConPerson + "^" + ctrlAcct + "^" + fee + "^" + fax + "^" + President + "^" + president + "^" + state + "^" + categoryId + "^" + crAvail + "^" + lstPoDate + "^" + address + "^" + isLimitSupply
			+ "^" + bussPerson + "^" + validDate + "^" + phone + "^" + salseID + "^" + parVendor + "^" + abbrev + "^" + presidentTel+ "^" + email + "^" + salesCarrTel + "^" + Sms + "^" + PurchPlat + "^" + universal + "^" + barcodePre 
			+ "^" + lstbsDate + "^" + VendorAlias + "^" + bankLicApprovalNo + "^" + bankLicNo + "^" + businessTerm + "^" + establishedDate + "^" + vendorEmail + "^" + coRenameFlag + "^" + carryFlag + "^" + regAddress + "^" + responsiblePerson + "^" + qualityManager + "^" + depotAddress + "^" + filingVoucher + "^" + matCatOfficial
			+ "^" + salesFaxField + "^" + SealRecordTable + "^" + MatQuaAgrement + "^" + AccountPeriod;
		return data;
	}
	//取得供应商资质信息串
	function getVendorQualityDataStr() {
		/*资质信息
			严格按照以下顺序
			每个资质组成串顺序：资质类型^资质有效期^资质发证日期^资质发证机关^效期长期标志^延期标志^延期日期
		*/
		//工商执照
		var comLicText = Ext.getCmp('comLicText').getValue();
		//工商执照有效期
		var comLicDateTo = Ext.getCmp('comLicDateTo').getValue();
		if ((comLicDateTo != "") && (comLicDateTo != null)) {
			comLicDateTo = comLicDateTo.format(ARG_DATEFORMAT);
		}
		var comLicIssuedDate = Ext.getCmp('comLicIssuedDate').getValue();
		if ((comLicIssuedDate != "") && (comLicIssuedDate != null)) {
			comLicIssuedDate = comLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var comLicIssuedDept = Ext.getCmp('comLicIssuedDept').getValue();
		var comLicType="comLic";
		var comLicStr=comLicType+"^"+comLicText+"^"+comLicDateTo+"^"+comLicIssuedDate+"^"+comLicIssuedDept;
		
		//税务执照
		var taxLicText = Ext.getCmp('taxLicText').getValue();
		//税务执照有效期
		var taxLicDateTo = Ext.getCmp('taxLicDateTo').getValue();
		if ((taxLicDateTo != "") && (taxLicDateTo != null)) {
			taxLicDateTo = taxLicDateTo.format(ARG_DATEFORMAT);
		}
		var taxLicIssuedDate = Ext.getCmp('taxLicIssuedDate').getValue();
		if ((taxLicIssuedDate != "") && (taxLicIssuedDate != null)) {
			taxLicIssuedDate = taxLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var taxLicIssuedDept = Ext.getCmp('taxLicIssuedDept').getValue();
		var taxLicType="taxLic";
		var taxLicStr=taxLicType+"^"+taxLicText+"^"+taxLicDateTo+"^"+taxLicIssuedDate+"^"+taxLicIssuedDept;
		
		//机构代码
		var orgCodeText = Ext.getCmp('orgCodeText').getValue();
		//机构代码有效期
		var orgCodeDateTo = Ext.getCmp('orgCodeDateTo').getValue();
		if ((orgCodeDateTo != "") && (orgCodeDateTo != null)) {
			orgCodeDateTo = orgCodeDateTo.format(ARG_DATEFORMAT);
		}
		var orgCodeIssuedDate = Ext.getCmp('orgCodeIssuedDate').getValue();
		if ((orgCodeIssuedDate != "") && (orgCodeIssuedDate != null)) {
			orgCodeIssuedDate = orgCodeIssuedDate.format(ARG_DATEFORMAT);
		}
		var orgCodeIssuedDept = Ext.getCmp('orgCodeIssuedDept').getValue();
		var orgCodeType="orgCode";
		var orgCodeStr=orgCodeType+"^"+orgCodeText+"^"+orgCodeDateTo+"^"+orgCodeIssuedDate+"^"+orgCodeIssuedDept;
		
		//药品经营许可证
		var drugBusLicText = Ext.getCmp('drugBusLicText').getValue();
		//药品经营许可证有效期
		var drugBusLicDateTo = Ext.getCmp('drugBusLicDateTo').getValue();
		if ((drugBusLicDateTo != "") && (drugBusLicDateTo != null)) {
			drugBusLicDateTo = drugBusLicDateTo.format(ARG_DATEFORMAT);
		}
		var drugBusLicIssuedDate = Ext.getCmp('drugBusLicIssuedDate').getValue();
		if ((drugBusLicIssuedDate != "") && (drugBusLicIssuedDate != null)) {
			drugBusLicIssuedDate = drugBusLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var drugBusLicIssuedDept = Ext.getCmp('drugBusLicIssuedDept').getValue();
		var drugBusLicType="drugBusLic";
		var drugBusLicStr=drugBusLicType+"^"+drugBusLicText+"^"+drugBusLicDateTo+"^"+drugBusLicIssuedDate+"^"+drugBusLicIssuedDept;
		
		//器械经营许可证
		var insBusLicText = Ext.getCmp('insBusLicText').getValue();
		//器械经营许可证有效期
		var insBusLicDateTo = Ext.getCmp('insBusLicDateTo').getValue();
		if ((insBusLicDateTo != "") && (insBusLicDateTo != null)) {
			insBusLicDateTo = insBusLicDateTo.format(ARG_DATEFORMAT);
		}
		var insBusLicIssuedDate = Ext.getCmp('insBusLicIssuedDate').getValue();
		if ((insBusLicIssuedDate != "") && (insBusLicIssuedDate != null)) {
			insBusLicIssuedDate = insBusLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var insBusLicIssuedDept = Ext.getCmp('insBusLicIssuedDept').getValue();
		var insBusLicType="insBusLic";
		var insBusLicStr=insBusLicType+"^"+insBusLicText+"^"+insBusLicDateTo+"^"+insBusLicIssuedDate+"^"+insBusLicIssuedDept;
		
		//器械生产许可证
		var insProLicText = Ext.getCmp('insProLicText').getValue();
		//器械生产许可证有效期
		var insProLicDateTo = Ext.getCmp('insProLicDateTo').getValue();
		if ((insProLicDateTo != "") && (insProLicDateTo != null)) {
			insProLicDateTo = insProLicDateTo.format(ARG_DATEFORMAT);
		}
		var insProLicIssuedDate = Ext.getCmp('insProLicIssuedDate').getValue();
		if ((insProLicIssuedDate != "") && (insProLicIssuedDate != null)) {
			insProLicIssuedDate = insProLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var insProLicIssuedDept = Ext.getCmp('insProLicIssuedDept').getValue();
		var insProLicType="insProLic";
		var insProLicStr=insProLicType+"^"+insProLicText+"^"+insProLicDateTo+"^"+insProLicIssuedDate+"^"+insProLicIssuedDept;
		
		//质量承诺书
		var qualityCommText = Ext.getCmp('qualityCommText').getValue();
		//质量承诺书有效期
		var qualityCommDateTo = Ext.getCmp('qualityCommDateTo').getValue();
		if ((qualityCommDateTo != "") && (qualityCommDateTo != null)) {
			qualityCommDateTo = qualityCommDateTo.format(ARG_DATEFORMAT);
		}
		var qualityCommType="qualityComm";
		var qualityCommStr=qualityCommType+"^"+qualityCommText+"^"+qualityCommDateTo;
		
		//代理授权书
		var agentAuthText = Ext.getCmp('agentAuthText').getValue();
		//代理授权书有效期
		var agentAuthDateTo = Ext.getCmp('agentAuthDateTo').getValue();
		if ((agentAuthDateTo != "") && (agentAuthDateTo != null)) {
			agentAuthDateTo = agentAuthDateTo.format(ARG_DATEFORMAT);
		}
		var agentAuthType="agentAuth";
		var agentAuthStr=agentAuthType+"^"+agentAuthText+"^"+agentAuthDateTo;
		
		//药品生产许可证
		var drugProLicText = Ext.getCmp('drugProLicText').getValue();
		//药品生产许可证有效期
		var drugProLicDateTo = Ext.getCmp('drugProLicDateTo').getValue();
		if ((drugProLicDateTo != "") && (drugProLicDateTo != null)) {
			drugProLicDateTo = drugProLicDateTo.format(ARG_DATEFORMAT);
		}
		var drugProLicIssuedDate = Ext.getCmp('drugProLicIssuedDate').getValue();
		if ((drugProLicIssuedDate != "") && (drugProLicIssuedDate != null)) {
			drugProLicIssuedDate = drugProLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var drugProLicIssuedDept = Ext.getCmp('drugProLicIssuedDept').getValue();
		var drugProLicType="drugProLic";
		var drugProLicStr=drugProLicType+"^"+drugProLicText+"^"+drugProLicDateTo+"^"+drugProLicIssuedDate+"^"+drugProLicIssuedDept;
		
		//药品注册批件
		var drugRegLicText = Ext.getCmp('drugRegLicText').getValue();
		//药品注册批件有效期
		var drugRegLicDateTo = Ext.getCmp('drugRegLicDateTo').getValue();
		if ((drugRegLicDateTo != "") && (drugRegLicDateTo != null)) {
			drugRegLicDateTo = drugRegLicDateTo.format(ARG_DATEFORMAT);
		}
		var drugRegLicType="drugRegLic";
		var drugRegLicStr=drugRegLicType+"^"+drugRegLicText+"^"+drugRegLicDateTo;
		
		
		//GSP认证
		var gspLicText = Ext.getCmp('gspLicText').getValue();
		//GSP认证有效期
		var gspLicDateTo = Ext.getCmp('gspLicDateTo').getValue();
		if ((gspLicDateTo != "") && (gspLicDateTo != null)) {
			gspLicDateTo = gspLicDateTo.format(ARG_DATEFORMAT);
		}
		var gspLicIssuedDate = Ext.getCmp('gspLicIssuedDate').getValue();
		if ((gspLicIssuedDate != "") && (gspLicIssuedDate != null)) {
			gspLicIssuedDate = gspLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var gspLicIssuedDept = Ext.getCmp('gspLicIssuedDept').getValue();
		var gspLicType="gspLic";
		var gspLicStr=gspLicType+"^"+gspLicText+"^"+gspLicDateTo+"^"+gspLicIssuedDate+"^"+gspLicIssuedDept;
		
		//社会信用码
		var socialCreditCommText = Ext.getCmp('socialCreditCommText').getValue();
		var socialCreditCommDateTo = Ext.getCmp('socialCreditCommDateTo').getValue();
		if ((socialCreditCommDateTo != "") && (socialCreditCommDateTo != null)) {
			socialCreditCommDateTo = socialCreditCommDateTo.format(ARG_DATEFORMAT);
		}
		var socialCreditCommType="socialCreditComm";
		var socialCreditCommStr=socialCreditCommType+"^"+socialCreditCommText+"^"+socialCreditCommDateTo;
		
		
		//器械注册证
		var insRegLicText = Ext.getCmp('insRegLicText').getValue();
		//器械注册证有效期
		var insRegLicDateTo = Ext.getCmp('insRegLicDateTo').getValue();
		if ((insRegLicDateTo != "") && (insRegLicDateTo != null)) {
			insRegLicDateTo = insRegLicDateTo.format(ARG_DATEFORMAT);
		}
		var insRegLicType="insRegLic";
		var insRegLicStr=insRegLicType+"^"+insRegLicText+"^"+insRegLicDateTo;
		
		
		//进口注册登记表
		var inletRegLicText = Ext.getCmp('inletRegLicText').getValue();
		//进口注册登记表有效期
		var inletRegLicDateTo = Ext.getCmp('inletRegLicDateTo').getValue();
		if ((inletRegLicDateTo != "") && (inletRegLicDateTo != null)) {
			inletRegLicDateTo = inletRegLicDateTo.format(ARG_DATEFORMAT);
		}
		var inletRegLicType="inletRegLic";
		var inletRegLicStr=inletRegLicType+"^"+inletRegLicText+"^"+inletRegLicDateTo;
		
		//进口注册证
		var inletRLicText = Ext.getCmp('inletRLicText').getValue();
		//进口注册证
		var inletRLicDateTo = Ext.getCmp('inletRLicDateTo').getValue();
		if ((inletRLicDateTo != "") && (inletRLicDateTo != null)) {
			inletRLicDateTo = inletRLicDateTo.format(ARG_DATEFORMAT);
		}
		var inletRLicType="inletRLic";
		var inletRLicStr=inletRLicType+"^"+inletRLicText+"^"+inletRLicDateTo;
		
		//售后服务承诺书
		var saleServCommText = Ext.getCmp('saleServCommText').getValue();
		var saleServCommType="saleServComm";
		var saleServCommStr=saleServCommType+"^"+saleServCommText;
		//法人委托书
		var legalCommText =  Ext.getCmp('legalCommText').getValue();
		var legalCommType="legalComm";
		var legalCommStr=legalCommType+"^"+legalCommText;
		
		var data = comLicStr+"&"+taxLicStr+"&"+orgCodeStr+"&"+drugBusLicStr+"&"+insBusLicStr
					+"&"+insProLicStr+"&"+qualityCommStr+"&"+agentAuthStr+"&"+drugProLicStr+"&"+drugRegLicStr
					+"&"+gspLicStr+"&"+socialCreditCommStr+"&"+insRegLicStr+"&"+inletRegLicStr+"&"+inletRLicStr
					+"&"+saleServCommStr+"&"+legalCommStr;
		return data;
	}

	//插入供应商
	function InsVendorInfo(data,qualitydata) {
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=insert',
			params: {
				data: data,
				qualitydata :qualitydata
			},
			method: 'post',
			waitMsg: '处理中...',
			failure: function (result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					var newRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					win.hide();
					APCVendorGridDs.load({
						params: {
							start: 0,
							limit: APCVendorPagingToolbar.pageSize
						}
					});
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "名称和代码重复!");
					} else if (jsonData.info == -2) {
						Msg.info("error", "代码重复!");
					} else if (jsonData.info == -3) {
						Msg.info("error", "名称重复!");
					} else if (jsonData.info == -6) {
						Msg.info("error", "此代码已存在于药房药库,可置成通用!");
					} else if (jsonData.info == -7) {
						Msg.info("error", "此名称已存在于药房药库,可置成通用!");
					} else {
						Msg.info("error", "保存失败:" + jsonData.info);
					}
				}
			},
			scope: this
		});
	}
	//更新供应商
	function UpdVendorInfo(data,qualitydata) {
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=update',
			params: {
				data: data,
				qualitydata :qualitydata
			},
			waitMsg: '更新中...',
			failure: function (result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "更新成功!");
					APCVendorGridDs.load({
						params: {
							start: APCVendorPagingToolbar.cursor,
							limit: APCVendorPagingToolbar.pageSize
						}
					});
					win.hide();
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "名称和代码重复!");
					} else if (jsonData.info == -2) {
						Msg.info("error", "代码重复!");
					} else if (jsonData.info == -3) {
						Msg.info("error", "名称重复!");
					} else {
						Msg.info("error", "更新错误:" + jsonData.info);
					}
				}
			},
			scope: this
		});
	}
}

function addpicAPCVendor(type) {
	if (currVendorRowId == "") {
		Msg.info("warning", "请先保存供应商信息,再上传图片!");
		return;
	}
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.apcvendornewaction.csp?actiontype=Upload&rowid=' + currVendorRowId, ///全局rowid
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp','pdf'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '上传供应商资质图片',
			base_params: {
				'type': type
			}
		});
	dialog.show();
};

function take_pic(typeCode, typeDesc) {
	if (currVendorRowId == "") {
		Msg.info("warning", "请先保存供应商信息,再拍照!");
		return;
	}
	var AppName = 'DHCSTVENDORMTM';
	if ((!VendorTakePicWindow) || (VendorTakePicWindow.closed)) {
		var lnk = 'dhcstm.takepiccommon.csp';
		lnk = lnk + "?AppName=" + AppName;
		lnk = lnk + "&RowId=" + currVendorRowId;
		lnk = lnk + "&typeCode=" + typeCode;
		lnk = lnk + "&typeDesc=" + typeDesc;
		lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
		lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
		lnk = lnk + "&UserId=" + session['LOGON.USERID'];
		VendorTakePicWindow = window.open(lnk, "take_photo", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
	} else {
		VendorTakePicWindow.SetType(AppName, currVendorRowId, typeCode, typeDesc, session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
		VendorTakePicWindow.focus();
	}
}

function setVendorParam() {

	var userId = session['LOGON.USERID'];
	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	var hospId = session['LOGON.HOSPID'];

	var url = 'dhcstm.apcvendornewaction.csp?actiontype=GetVendorParamP&GroupId=' + groupId + '&LocId=' + locId + '&UserId=' + userId + '&HospId=' + hospId;
	var response = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(response);

	if (jsonData.length < 0)
		return;
	gVendorPara.length = jsonData.length;
	for (var i = 0; i < jsonData.length; i++) {
		var ss = jsonData[i];
		gVendorPara[ss.APCode] = ss.APValue;
	}
}

function getVendorParamValue(apcode) {
	return gVendorPara[apcode]
}
