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
	var comLicField = new Ext.form.TextField({
			id: 'comLicField',
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
	var comLicValidDate = new Ext.ux.DateField({
			id: 'comLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});
	//税务执照
	var taxLicField = new Ext.form.TextField({
			id: 'taxLicField',
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
	var taxLicValidDate = new Ext.ux.DateField({
			id: 'taxLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//机构代码
	var orgCodeField = new Ext.form.TextField({
			id: 'orgCodeField',
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
	var orgCodeValidDate = new Ext.ux.DateField({
			id: 'orgCodeValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//药品经营许可证
	var drugBusLicField = new Ext.form.TextField({
			id: 'drugBusLicField',
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
	var drugBusLicValidDate = new Ext.ux.DateField({
			id: 'drugBusLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//器械经营许可证
	var insBusLicField = new Ext.form.TextField({
			id: 'insBusLicField',
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
	var insBusLicValidDate = new Ext.ux.DateField({
			id: 'insBusLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//器械生产许可证
	var insProLicField = new Ext.form.TextField({
			id: 'insProLicField',
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
	var insProLicValidDate = new Ext.ux.DateField({
			id: 'insProLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//质量承诺书
	var qualityCommField = new Ext.form.TextField({
			id: 'qualityCommField',
			fieldLabel: '质量承诺书',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var qualityCommButton = new Ext.Toolbar.Button({
			text: '上传',
			tooltip: '上传质量承诺书',
			handler: function () {
				addpicAPCVendor("qualityComm")
			}
		});
	var qualityCommButtonTP = new Ext.Toolbar.Button({
			text: '拍照',
			tooltip: '拍照质量承诺书',
			handler: function () {
				take_pic("qualityComm", "质量承诺书");
			}
		});
	//质量承诺书有效期
	var qualityCommValidDate = new Ext.ux.DateField({
			id: 'qualityCommValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//供应商协议
	var agreementField = new Ext.form.TextField({
			id: 'agreementField',
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
	var agentAuthField = new Ext.form.TextField({
			id: 'agentAuthField',
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
	var agentAuthValidDate = new Ext.ux.DateField({
			id: 'agentAuthValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//售后服务承诺书
	var saleServCommField = new Ext.form.TextField({
			id: 'saleServCommField',
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
	var legalCommField = new Ext.form.TextField({
			id: 'legalCommField',
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
	var drugProLicField = new Ext.form.TextField({
			id: 'drugProLicField',
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
	var drugProLicValidDate = new Ext.ux.DateField({
			id: 'drugProLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//药品注册批件
	var drugRegLicField = new Ext.form.TextField({
			id: 'drugRegLicField',
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
	var drugRegLicValidDate = new Ext.ux.DateField({
			id: 'drugRegLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//GSP认证
	var gspLicField = new Ext.form.TextField({
			id: 'gspLicField',
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
	var gspLicValidDate = new Ext.ux.DateField({
			id: 'gspLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//器械注册证
	var insRegLicField = new Ext.form.TextField({
			id: 'insRegLicField',
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
	var insRegLicValidDate = new Ext.ux.DateField({
			id: 'insRegLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//进口注册登记表
	var inletRegLicField = new Ext.form.TextField({
			id: 'inletRegLicField',
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
	var inletRegLicValidDate = new Ext.ux.DateField({
			id: 'inletRegLicValidDate',
			fieldLabel: '有效期',
			allowBlank: true
		});

	//进口注册证
	var inletRLicField = new Ext.form.TextField({
			id: 'inletRLicField',
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
	var inletRLicValidDate = new Ext.ux.DateField({
			id: 'inletRLicValidDate',
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

	var registration = new Ext.form.TextField({
			id: 'registration',
			fieldLabel: '社会信用码',
			width: 90,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var socialCreditExpDate = new Ext.ux.DateField({
			id: 'socialCreditExpDate',
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

	var ComLicIssuedDate = new Ext.ux.DateField({
			id: 'ComLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var ComLicIssuedDept = new Ext.form.TextField({
			id: 'ComLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var RevRegIssuedDate = new Ext.ux.DateField({
			id: 'RevRegIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var RevRegIssuedDept = new Ext.form.TextField({
			id: 'RevRegIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var OrgCodeIssuedDate = new Ext.ux.DateField({
			id: 'OrgCodeIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var OrgCodeIssuedDept = new Ext.form.TextField({
			id: 'OrgCodeIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var DrugManLicIssuedDate = new Ext.ux.DateField({
			id: 'DrugManLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var DrugManLicIssuedDept = new Ext.form.TextField({
			id: 'DrugManLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var MatManLicIssuedDate = new Ext.ux.DateField({
			id: 'MatManLicIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var MatManLicIssuedDept = new Ext.form.TextField({
			id: 'MatManLicIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var MatProIssuedDate = new Ext.ux.DateField({
			id: 'MatProIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var MatProIssuedDept = new Ext.form.TextField({
			id: 'MatProIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var GspIssuedDate = new Ext.ux.DateField({
			id: 'GspIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var GspIssuedDept = new Ext.form.TextField({
			id: 'GspIssuedDept',
			fieldLabel: '机关',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var DrugProIssuedDate = new Ext.ux.DateField({
			id: 'DrugProIssuedDate',
			fieldLabel: '发证日期',
			allowBlank: true
		});

	var DrugProIssuedDept = new Ext.form.TextField({
			id: 'DrugProIssuedDept',
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
				if (typeof(ss) == 'undefined' || ss == "") {
					return;
				}
				if (currVendorRowId != '') {
					ss = currVendorRowId + '^' + ss;
					UpdVendorInfo(ss); //执行更新}
				} else {
					InsVendorInfo(ss); //执行插入
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
											items: [comLicField, comLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [ComLicIssuedDate, ComLicIssuedDept, comLicButton, comLicButtonTP]
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
											items: [taxLicField, taxLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [RevRegIssuedDate, RevRegIssuedDept, taxLicButton, taxLicButtonTP]
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
											items: [orgCodeField, orgCodeValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [OrgCodeIssuedDate, OrgCodeIssuedDept, orgCodeButton, orgCodeButtonTP]
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
											items: [drugBusLicField, drugBusLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [DrugManLicIssuedDate, DrugManLicIssuedDept, drugBusLicButton, drugBusLicButtonTP]
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
											items: [insBusLicField, insBusLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [MatManLicIssuedDate, MatManLicIssuedDept, insBusLicButton, insBusLicButtonTP]
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
											items: [insProLicField, insProLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [MatProIssuedDate, MatProIssuedDept, insProLicButton, insProLicButtonTP]
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
											items: [drugProLicField, drugProLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [DrugProIssuedDate, DrugProIssuedDept, drugProLicButton, drugProLicButtonTP]
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
											items: [gspLicField, gspLicValidDate]
										}
									]
								}, {
									columnWidth: .58,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [GspIssuedDate, GspIssuedDept, gspLicButton, gspLicButtonTP]
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
											items: [registration, socialCreditExpDate, socialCreditCommButton, socialCreditCommButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 146,
									items: [{
											xtype: 'compositefield',
											items: [qualityCommField, qualityCommValidDate, qualityCommButton, qualityCommButtonTP]
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
											items: [saleServCommField, saleServCommButton, saleServCommButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 146,
									items: [{
											xtype: 'compositefield',
											items: [legalCommField, legalCommButton, legalCommButtonTP]
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
											items: [agreementField, agreementButton, agreementButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [inletRegLicField, inletRegLicValidDate, inletRegLicButton, inletRegLicButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [inletRLicField, inletRLicValidDate, inletRLicButton, inletRLicButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [agentAuthField, agentAuthValidDate, agentAuthButton, agentAuthButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [drugRegLicField, drugRegLicValidDate, drugRegLicButton, drugRegLicButtonTP]
										}
									]
								}, {
									columnWidth: .5,
									layout: 'form',
									labelWidth: 150,
									items: [{
											xtype: 'compositefield',
											items: [insRegLicField, insRegLicValidDate, insRegLicButton, insRegLicButtonTP]
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
					var arr = value.split("^");
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
					//资质信息
					Ext.getCmp('comLicField').setValue(arr[16]);
					Ext.getCmp('taxLicField').setValue(arr[38]);
					Ext.getCmp('orgCodeField').setValue(arr[33]);
					Ext.getCmp('drugBusLicField').setValue(arr[19]);
					Ext.getCmp('comLicValidDate').setValue(arr[17]);
					Ext.getCmp('taxLicValidDate').setValue(arr[39]);
					Ext.getCmp('orgCodeValidDate').setValue(arr[34]);
					Ext.getCmp('drugBusLicValidDate').setValue(arr[20]);
					Ext.getCmp('insBusLicField').setValue(arr[29]);
					Ext.getCmp('insProLicField').setValue(arr[31]);
					Ext.getCmp('qualityCommField').setValue(arr[43]);
					Ext.getCmp('agentAuthField').setValue(arr[18]);
					Ext.getCmp('insBusLicValidDate').setValue(arr[30]);
					Ext.getCmp('insProLicValidDate').setValue(arr[32]);
					Ext.getCmp('qualityCommValidDate').setValue(arr[44]);
					Ext.getCmp('agentAuthValidDate').setValue(arr[45]);
					Ext.getCmp('saleServCommField').setValue(arr[35]);
					Ext.getCmp('drugProLicField').setValue(arr[36]);
					Ext.getCmp('drugRegLicField').setValue(arr[40]);
					Ext.getCmp('gspLicField').setValue(arr[21]);
					Ext.getCmp('legalCommField').setValue(arr[42]);
					Ext.getCmp('drugProLicValidDate').setValue(arr[37]);
					Ext.getCmp('drugRegLicValidDate').setValue(arr[41]);
					Ext.getCmp('gspLicValidDate').setValue(arr[22]);
					Ext.getCmp('insRegLicField').setValue(arr[27]);
					Ext.getCmp('inletRegLicField').setValue(arr[25]);
					Ext.getCmp('inletRLicField').setValue(arr[23]);
					Ext.getCmp('insRegLicValidDate').setValue(arr[28]);
					Ext.getCmp('inletRegLicValidDate').setValue(arr[26]);
					Ext.getCmp('inletRLicValidDate').setValue(arr[24]);
					//业务员授权信息
					Ext.getCmp('bussPersonField').setValue(arr[46]);
					Ext.getCmp('validDate').setValue(arr[47]);
					Ext.getCmp('phoneField').setValue(arr[48]);
					Ext.getCmp('salesIDField').setValue(arr[49]);
					addComboData(Ext.getCmp("parField").getStore(), arr[50], arr[51]);
					Ext.getCmp("parField").setValue(arr[50]);
					Ext.getCmp("abbrevField").setValue(arr[52]);
					Ext.getCmp('presidentTelField').setValue(arr[53]); //法人电话
					Ext.getCmp('emailField').setValue(arr[54]); //邮箱
					Ext.getCmp('salesCarrTelField').setValue(arr[55]);
					Ext.getCmp('SmsField').setValue(arr[56] == "Y" ? true : false);
					Ext.getCmp('PurchPlatField').setValue(arr[57] == "Y" ? true : false);
					Ext.getCmp('Universal').setValue(arr[58] == "Y" ? true : false);
					Ext.getCmp('barcodePrefix').setValue(arr[59]);
					Ext.getCmp('lstBsDate').setValue(arr[60]);
					//新增信息
					Ext.getCmp('VendorAlias').setValue(arr[61]);
					Ext.getCmp('bankLicApprovalNo').setValue(arr[62]);
					Ext.getCmp('bankLicNo').setValue(arr[63]);
					Ext.getCmp('registration').setValue(arr[64]);
					Ext.getCmp('businessTerm').setValue(arr[65]);
					Ext.getCmp('establishedDate').setValue(arr[66]);
					Ext.getCmp('vendorEmail').setValue(arr[67]);
					Ext.getCmp('coRenameFlag').setValue(arr[68] == "Y" ? true : false);
					Ext.getCmp('carryFlag').setValue(arr[69] == "Y" ? true : false);
					Ext.getCmp('regAddress').setValue(arr[70]);
					Ext.getCmp('responsiblePerson').setValue(arr[71]);
					Ext.getCmp('qualityManager').setValue(arr[72]);
					Ext.getCmp('depotAddress').setValue(arr[73]);
					Ext.getCmp('filingVoucher').setValue(arr[74]);
					addComboData(Ext.getCmp('matCatOfficial').getStore(), arr[75], arr[92], matCatOfficial);
					Ext.getCmp('matCatOfficial').setValue(arr[75]);
					Ext.getCmp('ComLicIssuedDate').setValue(arr[76]);
					Ext.getCmp('ComLicIssuedDept').setValue(arr[77]);
					Ext.getCmp('RevRegIssuedDate').setValue(arr[78]);
					Ext.getCmp('RevRegIssuedDept').setValue(arr[79]);
					Ext.getCmp('OrgCodeIssuedDate').setValue(arr[80]);
					Ext.getCmp('OrgCodeIssuedDept').setValue(arr[81]);
					Ext.getCmp('DrugManLicIssuedDate').setValue(arr[82]);
					Ext.getCmp('DrugManLicIssuedDept').setValue(arr[83]);
					Ext.getCmp('MatManLicIssuedDate').setValue(arr[84]);
					Ext.getCmp('MatManLicIssuedDept').setValue(arr[85]);
					Ext.getCmp('MatProIssuedDate').setValue(arr[86]);
					Ext.getCmp('MatProIssuedDept').setValue(arr[87]);
					Ext.getCmp('GspIssuedDate').setValue(arr[88]);
					Ext.getCmp('GspIssuedDept').setValue(arr[89]);
					Ext.getCmp('DrugProIssuedDate').setValue(arr[90]);
					Ext.getCmp('DrugProIssuedDept').setValue(arr[91]);
					Ext.getCmp('socialCreditExpDate').setValue(arr[93]);
					Ext.getCmp('salesFaxField').setValue(arr[94]);
					Ext.getCmp('SealRecordTable').setValue(arr[95]);
					Ext.getCmp('MatQuaAgrement').setValue(arr[96]);
					Ext.getCmp('AccountPeriod').setValue(arr[97]);
				}
			},
			scope: this
		});
	}

	//取得供应商串
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
		var corporation = corporationField.getValue();
		//法人身份证
		var president = presidentField.getValue();

		var presidentTel = presidentTelField.getValue();
		//账户
		var ctrlAcct = ctrlAcctField.getValue();
		//开户行
		var bankName = bankField.getValue();
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

		//资质信息
		//工商执照
		var comLic = comLicField.getValue();
		//工商执照有效期
		var comLicValidDate = Ext.getCmp('comLicValidDate').getValue();
		if ((comLicValidDate != "") && (comLicValidDate != null)) {
			comLicValidDate = comLicValidDate.format(ARG_DATEFORMAT);
		}
		//税务执照
		var taxLic = taxLicField.getValue();
		//税务执照有效期
		var taxLicValidDate = Ext.getCmp('taxLicValidDate').getValue();
		if ((taxLicValidDate != "") && (taxLicValidDate != null)) {
			taxLicValidDate = taxLicValidDate.format(ARG_DATEFORMAT);
		}
		//机构代码
		var orgCode = orgCodeField.getValue();
		//税务执照有效期
		var orgCodeValidDate = Ext.getCmp('orgCodeValidDate').getValue();
		if ((orgCodeValidDate != "") && (orgCodeValidDate != null)) {
			orgCodeValidDate = orgCodeValidDate.format(ARG_DATEFORMAT);
		}
		//药品经营许可证
		var drugBusLic = drugBusLicField.getValue();
		//药品经营许可证有效期
		var drugBusLicValidDate = Ext.getCmp('drugBusLicValidDate').getValue();
		if ((drugBusLicValidDate != "") && (drugBusLicValidDate != null)) {
			drugBusLicValidDate = drugBusLicValidDate.format(ARG_DATEFORMAT);
		}

		//器械经营许可证
		var insBusLic = insBusLicField.getValue();
		//器械经营许可证有效期
		var insBusLicValidDate = Ext.getCmp('insBusLicValidDate').getValue();
		if ((insBusLicValidDate != "") && (insBusLicValidDate != null)) {
			insBusLicValidDate = insBusLicValidDate.format(ARG_DATEFORMAT);
		}
		//器械生产许可证
		var insProLic = insProLicField.getValue();
		//器械生产许可证有效期
		var insProLicValidDate = Ext.getCmp('insProLicValidDate').getValue();
		if ((insProLicValidDate != "") && (insProLicValidDate != null)) {
			insProLicValidDate = insProLicValidDate.format(ARG_DATEFORMAT);
		}
		//质量承诺书
		var qualityComm = qualityCommField.getValue();
		//质量承诺书有效期
		var qualityCommValidDate = Ext.getCmp('qualityCommValidDate').getValue();
		if ((qualityCommValidDate != "") && (qualityCommValidDate != null)) {
			qualityCommValidDate = qualityCommValidDate.format(ARG_DATEFORMAT);
		}
		//代理授权书
		var agentAuth = agentAuthField.getValue();
		//代理授权书有效期
		var agentAuthValidDate = Ext.getCmp('agentAuthValidDate').getValue();
		if ((agentAuthValidDate != "") && (agentAuthValidDate != null)) {
			agentAuthValidDate = agentAuthValidDate.format(ARG_DATEFORMAT);
		}

		//售后服务承诺书
		var saleServComm = saleServCommField.getValue();
		//法人委托书
		var legalComm = legalCommField.getValue();
		//药品生产许可证
		var drugProLic = drugProLicField.getValue();
		//药品生产许可证有效期
		var drugProLicValidDate = Ext.getCmp('drugProLicValidDate').getValue();
		if ((drugProLicValidDate != "") && (drugProLicValidDate != null)) {
			drugProLicValidDate = drugProLicValidDate.format(ARG_DATEFORMAT);
		}
		//药品注册批件
		var drugRegLic = drugRegLicField.getValue();
		//药品注册批件有效期
		var drugRegLicValidDate = Ext.getCmp('drugRegLicValidDate').getValue();
		if ((drugRegLicValidDate != "") && (drugRegLicValidDate != null)) {
			drugRegLicValidDate = drugRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//GSP认证
		var gspLic = gspLicField.getValue();
		//GSP认证有效期
		var gspLicValidDate = Ext.getCmp('gspLicValidDate').getValue();
		if ((gspLicValidDate != "") && (gspLicValidDate != null)) {
			gspLicValidDate = gspLicValidDate.format(ARG_DATEFORMAT);
		}

		//器械注册证
		var insRegLic = insRegLicField.getValue();
		//器械注册证有效期
		var insRegLicValidDate = Ext.getCmp('insRegLicValidDate').getValue();
		if ((insRegLicValidDate != "") && (insRegLicValidDate != null)) {
			insRegLicValidDate = insRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//进口注册登记表
		var inletRegLic = inletRegLicField.getValue();
		//进口注册登记表有效期
		var inletRegLicValidDate = Ext.getCmp('inletRegLicValidDate').getValue();
		if ((inletRegLicValidDate != "") && (inletRegLicValidDate != null)) {
			inletRegLicValidDate = inletRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//进口注册证
		var inletRLic = inletRLicField.getValue();
		//进口注册证
		var inletRLicValidDate = Ext.getCmp('inletRLicValidDate').getValue();
		if ((inletRLicValidDate != "") && (inletRLicValidDate != null)) {
			inletRLicValidDate = inletRLicValidDate.format(ARG_DATEFORMAT);
		}

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
		var registration = Ext.getCmp('registration').getValue();
		var socialCreditExpDate = Ext.getCmp('socialCreditExpDate').getValue();
		if ((socialCreditExpDate != "") && (socialCreditExpDate != null)) {
			socialCreditExpDate = socialCreditExpDate.format(ARG_DATEFORMAT);
		}
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
		var ComLicIssuedDate = Ext.getCmp('ComLicIssuedDate').getValue();
		if ((ComLicIssuedDate != "") && (ComLicIssuedDate != null)) {
			ComLicIssuedDate = ComLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var ComLicIssuedDept = Ext.getCmp('ComLicIssuedDept').getValue();
		var RevRegIssuedDate = Ext.getCmp('RevRegIssuedDate').getValue();
		if ((RevRegIssuedDate != "") && (RevRegIssuedDate != null)) {
			RevRegIssuedDate = RevRegIssuedDate.format(ARG_DATEFORMAT);
		}
		var RevRegIssuedDept = Ext.getCmp('RevRegIssuedDept').getValue();
		var OrgCodeIssuedDate = Ext.getCmp('OrgCodeIssuedDate').getValue();
		if ((OrgCodeIssuedDate != "") && (OrgCodeIssuedDate != null)) {
			OrgCodeIssuedDate = OrgCodeIssuedDate.format(ARG_DATEFORMAT);
		}
		var OrgCodeIssuedDept = Ext.getCmp('OrgCodeIssuedDept').getValue();
		var DrugManLicIssuedDate = Ext.getCmp('DrugManLicIssuedDate').getValue();
		if ((DrugManLicIssuedDate != "") && (DrugManLicIssuedDate != null)) {
			DrugManLicIssuedDate = DrugManLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var DrugManLicIssuedDept = Ext.getCmp('DrugManLicIssuedDept').getValue();
		var MatManLicIssuedDate = Ext.getCmp('MatManLicIssuedDate').getValue();
		if ((MatManLicIssuedDate != "") && (MatManLicIssuedDate != null)) {
			MatManLicIssuedDate = MatManLicIssuedDate.format(ARG_DATEFORMAT);
		}
		var MatManLicIssuedDept = Ext.getCmp('MatManLicIssuedDept').getValue();
		var MatProIssuedDate = Ext.getCmp('MatProIssuedDate').getValue();
		if ((MatProIssuedDate != "") && (MatProIssuedDate != null)) {
			MatProIssuedDate = MatProIssuedDate.format(ARG_DATEFORMAT);
		}
		var MatProIssuedDept = Ext.getCmp('MatProIssuedDept').getValue();
		var GspIssuedDate = Ext.getCmp('GspIssuedDate').getValue();
		if ((GspIssuedDate != "") && (GspIssuedDate != null)) {
			GspIssuedDate = GspIssuedDate.format(ARG_DATEFORMAT);
		}
		var GspIssuedDept = Ext.getCmp('GspIssuedDept').getValue();
		var DrugProIssuedDate = Ext.getCmp('DrugProIssuedDate').getValue();
		if ((DrugProIssuedDate != "") && (DrugProIssuedDate != null)) {
			DrugProIssuedDate = DrugProIssuedDate.format(ARG_DATEFORMAT);
		}
		var DrugProIssuedDept = Ext.getCmp('DrugProIssuedDept').getValue();
		var salesFaxField = Ext.getCmp('salesFaxField').getValue();
		
		var SealRecordTable = Ext.getCmp('SealRecordTable').getValue()? 'Y' : 'N';
		var MatQuaAgrement = Ext.getCmp('MatQuaAgrement').getValue()? 'Y' : 'N';
		var AccountPeriod = Ext.getCmp("AccountPeriod").getValue(); ///账期
		
		/*
		供应商代码^名称^电话^开户行^账户^采购限额^传真^法人^法人id^使用标志^分类id^注册资金^合同截止日期^地址^限制供应标志^工商执照^工商执照效期^代理授权书^药品经营许可证^药品经营许可证有效期
		^Gsp认证^Gsp认证有效期^进口注册证^进口注册证有效期^进口注册登记表^进口注册登记表有效期^器械注册证^器械注册证有效期^器械经营许可证^器械经营许可证有效期^器械生产许可证^器械生产许可证有效期
		^组织机构代码^组织机构有效期^售后服务承诺书^药品生产许可证^药品生产许可证有效期^税务登记^税务登记有效期^药品注册批件^药品注册批件有效期^法人委托书^质量承诺书^质量承诺书有效期^代理授权书有效期^业务员姓名^业务员授权书有效期^业务员电话^业务员身份证^法人联系电话
		^email^中间商^短信通知^平台通知^通用标志^高值条码前缀^最后业务日期^助记码
		 */
		//拼data字符串
		var data = code + "^" + name + "^" + tel + "^" + bankName + "^" + ctrlAcct + "^" + fee + "^" + fax + "^" + corporation + "^" + president + "^" + state + "^" + categoryId + "^" + crAvail + "^" + lstPoDate + "^" + address + "^" + isLimitSupply
			+ "^" + comLic + "^" + comLicValidDate + "^" + agentAuth + "^" + drugBusLic + "^" + drugBusLicValidDate
			+ "^" + gspLic + "^" + gspLicValidDate + "^" + inletRLic + "^" + inletRLicValidDate + "^" + inletRegLic + "^" + inletRegLicValidDate
			+ "^" + insRegLic + "^" + insRegLicValidDate + "^" + insBusLic + "^" + insBusLicValidDate + "^" + insProLic + "^" + insProLicValidDate
			+ "^" + orgCode + "^" + orgCodeValidDate + "^" + saleServComm + "^" + drugProLic + "^" + drugProLicValidDate + "^" + taxLic + "^" + taxLicValidDate
			+ "^" + drugRegLic + "^" + drugRegLicValidDate + "^" + legalComm + "^" + qualityComm + "^" + qualityCommValidDate
			+ "^" + agentAuthValidDate + "^" + bussPerson + "^" + validDate + "^" + phone + "^" + salseID + "^" + parVendor + "^" + abbrev + "^" + presidentTel
			+ "^" + email + "^" + salesCarrTel + "^" + Sms + "^" + PurchPlat + "^" + universal + "^" + barcodePre + "^" + lstbsDate + "^" + VendorAlias
			+ "^" + bankLicApprovalNo + "^" + bankLicNo + "^" + registration + "^" + businessTerm + "^" + establishedDate + "^" + vendorEmail + "^" + coRenameFlag + "^" + carryFlag
			+ "^" + regAddress + "^" + responsiblePerson + "^" + qualityManager + "^" + depotAddress + "^" + filingVoucher + "^" + matCatOfficial + "^" + ComLicIssuedDate + "^" + ComLicIssuedDept
			+ "^" + RevRegIssuedDate + "^" + RevRegIssuedDept + "^" + OrgCodeIssuedDate + "^" + OrgCodeIssuedDept + "^" + DrugManLicIssuedDate + "^" + DrugManLicIssuedDept + "^" + MatManLicIssuedDate + "^" + MatManLicIssuedDept
			+ "^" + MatProIssuedDate + "^" + MatProIssuedDept + "^" + GspIssuedDate + "^" + GspIssuedDept + "^" + DrugProIssuedDate + "^" + DrugProIssuedDept + "^" + socialCreditExpDate + "^" + salesFaxField + "^" + SealRecordTable + "^" + MatQuaAgrement
			+ "^" + AccountPeriod;
		return data;
	}

	//插入供应商
	function InsVendorInfo(data) {
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=insert',
			params: {
				data: data
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
	function UpdVendorInfo(data) {
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=update', //&data='+data,
			params: {
				data: data
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
			url: 'dhcstm.apcvendoraction.csp?actiontype=Upload&rowid=' + currVendorRowId, ///全局rowid
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

	var url = 'dhcstm.apcvendoraction.csp?actiontype=GetVendorParamP&GroupId=' + groupId + '&LocId=' + locId + '&UserId=' + userId + '&HospId=' + hospId;
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
