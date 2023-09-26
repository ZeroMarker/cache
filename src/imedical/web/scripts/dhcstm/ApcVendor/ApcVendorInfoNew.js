// ����:��Ӧ�̹���
// ��д����:2012-05-14

//�����༭����(����)
//rowid :��Ӧ��rowid
var VendorTakePicWindow;
var gVendorPara = [];
function CreateEditWin() {
	setVendorParam();
	if (win) {
		win.show();
		return;
	}
	//��Ӧ�̴���
	var codeField = new Ext.form.TextField({
			id: 'codeField',
			fieldLabel: '<font color=red>*��Ӧ�̴���</font>',
			allowBlank: false,
			anchor: '90%',
			emptyText:'�½�ʱ����Ϊ��,��ϵͳ�Զ�����...',
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
			fieldLabel: '��ֵ����ǰ׺',
			anchor: '90%'
		});

	//��Ӧ������
	var nameField = new Ext.form.TextField({
			id: 'nameField',
			fieldLabel: '<font color=red>*��Ӧ������</font>',
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

	//��Ӧ�̼��
	var abbrevField = new Ext.form.TextField({
			id: 'abbrevField',
			fieldLabel: '��Ӧ�̼��',
			anchor: '90%',
			selectOnFocus: true
		});

	var VendorAlias = new Ext.form.TextField({
			id: 'VendorAlias',
			fieldLabel: '������',
			anchor: '90%',
			maxLength: 20
		});

	///�ϼ���Ӧ��
	var parField = new Ext.ux.VendorComboBox({
			id: 'parField',
			fieldLabel: '��һ����Ӧ��',
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
						Msg.info("error", "�뵱ǰ��Ӧ����ͬ��������!");
						return false;
					}
				}
			}
		});

	//ҵ��Ա����
	var bussPersonField = new Ext.form.TextField({
			id: 'bussPersonField',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '95%',
			selectOnFocus: true
		});

	//ҵ��Ա֤����Ч��
	var validDate = new Ext.ux.DateField({
			id: 'validDate',
			fieldLabel: '��Ȩ��Ч��',
			allowBlank: true,
			anchor: '95%'
		});

	var salsLicPicAddButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�ҵ��Ա��Ȩ��',
			handler: function () {
				addpicAPCVendor("salesLic");
			}
		});

	//ҵ��Ա��Ȩ��
	var salsLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����ҵ��Ա��Ȩ��',
			handler: function () {
				take_pic("salesLic", "ҵ��Ա��Ȩ��");
			}
		});

	//ҵ��Ա�绰
	var phoneField = new Ext.form.TextField({
			id: 'phoneField',
			fieldLabel: '�绰',
			anchor: '95%',
			allowBlank: true
		});

	//ҵ��Ա���֤
	var salesIDField = new Ext.form.TextField({
			id: 'salesIDField',
			anchor: '95%',
			fieldLabel: '���֤',
			allowBlank: true
		});

	var salesIDButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ����֤��ӡ��',
			handler: function () {
				addpicAPCVendor("salesID");
			}
		});

	var salesIDButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '�������֤��ӡ��',
			handler: function () {
				take_pic("salesID", "���֤��ӡ��");
			}
		});

	var salsPhotoButton = new Ext.Toolbar.Button({
			text: '�ϴ���Ƭ',
			tooltip: '�ϴ�ҵ��Ա��Ƭ',
			handler: function () {
				addpicAPCVendor("salsPhoto");
			}
		});

	//ҵ��Ա����
	var emailField = new Ext.form.TextField({
			id: 'emailField',
			anchor: '95%',
			fieldLabel: '����',
			allowBlank: true
		});

	//ҵ��Ա���͵绰(�����ֻ���)
	var salesCarrTelField = new Ext.form.TextField({
			id: 'salesCarrTelField',
			anchor: '95%',
			fieldLabel: '�����ֻ���',
			allowBlank: true
		});

	//ҵ��Ա����
	var salesFaxField = new Ext.form.TextField({
			id: 'salesFaxField',
			anchor: '95%',
			fieldLabel: '����',
			allowBlank: true
		});

	//��Ӧ�̴���
	var addressField = new Ext.form.TextField({
			id: 'addressField',
			fieldLabel: '��Ӧ�̵�ַ',
			allowBlank: true,
			anchor: '95.5%',
			selectOnFocus: true
		});

	//��Ӧ�̵绰
	var telField = new Ext.form.TextField({
			id: 'telField',
			fieldLabel: '��Ӧ�̵绰',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//����
	var categoryField = new Ext.form.ComboBox({
			id: 'categoryField',
			fieldLabel: '����',
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

	//�˻�
	var ctrlAcctField = new Ext.form.TextField({
			id: 'ctrlAcctField',
			fieldLabel: '�˻�',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//��������
	var bankField = new Ext.form.TextField({
			id: 'bankField',
			fieldLabel: '��������',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//ע���ʽ�
	var crAvailField = new Ext.form.NumberField({
			id: 'crAvailField',
			fieldLabel: 'ע���ʽ�',
			allowBlank: true,
			allowNegative: false,
			anchor: '90%',
			selectOnFocus: true
		});

	//�ɹ����
	var feeField = new Ext.form.NumberField({
			id: 'feeField',
			fieldLabel: '�ɹ����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//��ͬ��ֹ����
	var lstPoDate = new Ext.ux.DateField({
			id: 'lstPoDate',
			fieldLabel: '��ͬ��ֹ����',
			allowBlank: true,
			disabled: false,
			anchor: '90%'
		});

	//���ҵ������
	var lstBsDate = new Ext.ux.DateField({
			id: 'lstBsDate',
			fieldLabel: '���ҵ������',
			allowBlank: true,
			disabled: true,
			anchor: '90%'
		});

	//����
	var faxField = new Ext.form.TextField({
			id: 'faxField',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//����
	var corporationField = new Ext.form.TextField({
			id: 'corporationField',
			fieldLabel: '����(��ϵ��)',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//�������֤
	var presidentField = new Ext.form.TextField({
			id: 'presidentField',
			fieldLabel: '�������֤',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//������ϵ�绰
	var presidentTelField = new Ext.form.TextField({
			id: 'presidentTelField',
			fieldLabel: '������ϵ�绰',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	//״̬
	var stateStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [["A", 'ʹ��'], ["S", 'ͣ��']]
		});

	var stateField = new Ext.form.ComboBox({
			id: 'stateField',
			fieldLabel: 'ʹ��״̬',
			allowBlank: true,
			store: stateStore,
			value: 'A', // Ĭ��ֵ"ʹ��"
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

	//���ƹ�Ӧ
	var limitSupplyField = new Ext.form.Checkbox({
			id: 'limitSupplyField',
			boxLabel: '���ƹ�Ӧ(�м���)',
			// fieldLabel:'���ƹ�Ӧ(�м���)',
			hideLabel: true,
			allowBlank: true
		});

	var SmsField = new Ext.form.Checkbox({
			id: 'SmsField',
			boxLabel: '����֪ͨ',
			hideLabel: true,
			allowBlank: true
		});

	var PurchPlatField = new Ext.form.Checkbox({
			id: 'PurchPlatField',
			boxLabel: 'ƽ̨֪ͨ',
			hideLabel: true,
			allowBlank: true
		});

	var Universal = new Ext.form.Checkbox({
			id: 'Universal',
			boxLabel: 'ͨ�ñ�־',
			hideLabel: true,
			checked: true,
			allowBlank: true
		});

	//����ִ��
	var comLicText = new Ext.form.TextField({
			id: 'comLicText',
			fieldLabel: '����ִ��',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var comLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�����ִ��',
			handler: function () {
				addpicAPCVendor("comLic");
			}
		});
	var comLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���չ���ִ��',
			handler: function () {
				take_pic("comLic", "����ִ��");
			}
		});

	//����ִ����Ч��
	var comLicDateTo = new Ext.ux.DateField({
			id: 'comLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});
	//˰��ִ��
	var taxLicText = new Ext.form.TextField({
			id: 'taxLicText',
			fieldLabel: '˰��ִ��',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var taxLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�˰��ִ��',
			handler: function () {
				addpicAPCVendor("taxLic")
			}
		});
	var taxLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����˰��ִ��',
			handler: function () {
				take_pic("taxLic", "˰��ִ��");
			}
		});
	//˰��ִ����Ч��
	var taxLicDateTo = new Ext.ux.DateField({
			id: 'taxLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��������
	var orgCodeText = new Ext.form.TextField({
			id: 'orgCodeText',
			fieldLabel: '��������',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var orgCodeButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ���������',
			handler: function () {
				addpicAPCVendor("orgCode")
			}
		});
	var orgCodeButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���ջ�������',
			handler: function () {
				take_pic("orgCode", "��������");
			}
		});
	//����������Ч��
	var orgCodeDateTo = new Ext.ux.DateField({
			id: 'orgCodeDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//ҩƷ��Ӫ���֤
	var drugBusLicText = new Ext.form.TextField({
			id: 'drugBusLicText',
			fieldLabel: 'ҩƷ��Ӫ���֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var drugBusLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�ҩƷ��Ӫ���֤',
			handler: function () {
				addpicAPCVendor("drugBusLic")
			}
		});
	var drugBusLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����ҩƷ��Ӫ���֤',
			handler: function () {
				take_pic("drugBusLic", "ҩƷ��Ӫ���֤");
			}
		});
	//ҩƷ��Ӫ���֤��Ч��
	var drugBusLicDateTo = new Ext.ux.DateField({
			id: 'drugBusLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��е��Ӫ���֤
	var insBusLicText = new Ext.form.TextField({
			id: 'insBusLicText',
			fieldLabel: '��е��Ӫ���֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var insBusLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ���е��Ӫ���֤',
			handler: function () {
				addpicAPCVendor("insBusLic")
			}
		});

	var insBusLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '������е��Ӫ���֤',
			handler: function () {
				take_pic("insBusLic", "��е��Ӫ���֤");
			}
		});
	//��е��Ӫ���֤��Ч��
	var insBusLicDateTo = new Ext.ux.DateField({
			id: 'insBusLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��е�������֤
	var insProLicText = new Ext.form.TextField({
			id: 'insProLicText',
			fieldLabel: '��е�������֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var insProLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ���е�������֤',
			handler: function () {
				addpicAPCVendor("insProLic")
			}
		});
	var insProLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '������е�������֤',
			handler: function () {
				take_pic("insProLic", "��е�������֤");
			}
		});
	//��е�������֤��Ч��
	var insProLicDateTo = new Ext.ux.DateField({
			id: 'insProLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//������ŵ��
	var qualityCommText = new Ext.form.TextField({
			id: 'qualityCommText',
			fieldLabel: '������ŵ��',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var qualityCommButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�������ŵ��',
			handler: function () {
				addpicAPCVendor("qualityCommText")
			}
		});
	var qualityCommButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����������ŵ��',
			handler: function () {
				take_pic("qualityCommText", "������ŵ��");
			}
		});
	//������ŵ����Ч��
	var qualityCommDateTo = new Ext.ux.DateField({
			id: 'qualityCommDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��Ӧ��Э��
	var vendorAgreementText = new Ext.form.TextField({
			id: 'vendorAgreementText',
			fieldLabel: '��Ӧ��Э��',
			width: 90,
			allowBlank: true,
			selectOnFocus: true,
			hidden: true
		});

	//��Ӧ��Э���ϴ�
	var agreementButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ���Ӧ��Э��',
			handler: function () {
				addpicAPCVendor("vendorAgreement")
			}
		});

	var agreementButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���չ�Ӧ��Э��',
			handler: function () {
				take_pic("vendorAgreement", "��Ӧ��Э��");
			}
		});

	//������Ȩ��
	var agentAuthText = new Ext.form.TextField({
			id: 'agentAuthText',
			fieldLabel: '������Ȩ��',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var agentAuthButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�������Ȩ��',
			handler: function () {
				addpicAPCVendor("agentAuth")
			}
		});

	var agentAuthButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���մ�����Ȩ��',
			handler: function () {
				take_pic("agentAuth", "������Ȩ��");
			}
		});
	//������Ȩ����Ч��
	var agentAuthDateTo = new Ext.ux.DateField({
			id: 'agentAuthDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//�ۺ�����ŵ��
	var saleServCommText = new Ext.form.TextField({
			id: 'saleServCommText',
			fieldLabel: '�ۺ�����ŵ��',
			width: 200,
			allowBlank: true,
			selectOnFocus: true
		});
	var saleServCommButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ��ۺ�����ŵ��',
			handler: function () {
				addpicAPCVendor("saleServComm")
			}
		});
	var saleServCommButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '�����ۺ�����ŵ��',
			handler: function () {
				take_pic("saleServComm", "�ۺ�����ŵ��");
			}
		});
	//����ί����
	var legalCommText = new Ext.form.TextField({
			id: 'legalCommText',
			fieldLabel: '����ί����',
			width: 200,
			allowBlank: true,
			selectOnFocus: true
		});
	var legalCommButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�����ί����',
			handler: function () {
				addpicAPCVendor("legalComm");
			}
		});
	var legalCommButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���շ���ί����',
			handler: function () {
				take_pic("legalComm", "����ί����");
			}
		});

	//ҩƷ�������֤
	var drugProLicText = new Ext.form.TextField({
			id: 'drugProLicText',
			fieldLabel: 'ҩƷ�������֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var drugProLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�ҩƷ�������֤',
			handler: function () {
				addpicAPCVendor("drugProLic")
			}
		});
	var drugProLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����ҩƷ�������֤',
			handler: function () {
				take_pic("drugProLic", "ҩƷ�������֤");
			}
		});
	//ҩƷ�������֤��Ч��
	var drugProLicDateTo = new Ext.ux.DateField({
			id: 'drugProLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//ҩƷע������
	var drugRegLicText = new Ext.form.TextField({
			id: 'drugRegLicText',
			fieldLabel: 'ҩƷע������',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var drugRegLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�ҩƷע������',
			handler: function () {
				addpicAPCVendor("drugRegLic")
			}
		});
	var drugRegLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����ҩƷע������',
			handler: function () {
				take_pic("drugRegLic", "ҩƷע������");
			}
		});
	//ҩƷע��������Ч��
	var drugRegLicDateTo = new Ext.ux.DateField({
			id: 'drugRegLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//GSP��֤
	var gspLicText = new Ext.form.TextField({
			id: 'gspLicText',
			fieldLabel: 'GSP��֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var gspLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�GSP��֤',
			handler: function () {
				addpicAPCVendor("gspLic")
			}
		});
	var gspLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����GSP��֤',
			handler: function () {
				take_pic("gspLic", "GSP��֤");
			}
		});
	//GSP��֤��Ч��
	var gspLicDateTo = new Ext.ux.DateField({
			id: 'gspLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��еע��֤
	var insRegLicText = new Ext.form.TextField({
			id: 'insRegLicText',
			fieldLabel: '��еע��֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var insRegLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ���еע��֤',
			handler: function () {
				addpicAPCVendor("insRegLic")
			}
		});
	var insRegLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '������еע��֤',
			handler: function () {
				take_pic("insRegLic", "��еע��֤");
			}
		});
	//��еע��֤��Ч��
	var insRegLicDateTo = new Ext.ux.DateField({
			id: 'insRegLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//����ע��ǼǱ�
	var inletRegLicText = new Ext.form.TextField({
			id: 'inletRegLicText',
			fieldLabel: '����ע��ǼǱ�',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var inletRegLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�����ע��ǼǱ�',
			handler: function () {
				addpicAPCVendor("inletRegLic")
			}
		});
	var inletRegLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���ս���ע��ǼǱ�',
			handler: function () {
				take_pic("inletRegLic", "����ע��ǼǱ�");
			}
		});
	//����ע��ǼǱ���Ч��
	var inletRegLicDateTo = new Ext.ux.DateField({
			id: 'inletRegLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//����ע��֤
	var inletRLicText = new Ext.form.TextField({
			id: 'inletRLicText',
			fieldLabel: '����ע��֤',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var inletRLicButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�����ע��֤',
			handler: function () {
				addpicAPCVendor("inletRLic")
			}
		});
	var inletRLicButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '���ս���ע��֤',
			handler: function () {
				take_pic("inletRLic", "����ע��֤");
			}
		});
	//����ע��֤��Ч��
	var inletRLicDateTo = new Ext.ux.DateField({
			id: 'inletRLicDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	var bankLicApprovalNo = new Ext.form.TextField({
			id: 'bankLicApprovalNo',
			fieldLabel: '���֤��׼��',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var bankLicNo = new Ext.form.TextField({
			id: 'bankLicNo',
			fieldLabel: '���֤���',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var socialCreditCommText = new Ext.form.TextField({
			id: 'socialCreditCommText',
			fieldLabel: '���������',
			width: 90,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var socialCreditCommDateTo = new Ext.ux.DateField({
			id: 'socialCreditCommDateTo',
			fieldLabel: '��Ч��',
			allowBlank: true,
			anchor: '90%'
		});
	
	var socialCreditCommButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ����������',
			handler: function () {
				addpicAPCVendor("socialCreditComm")
			}
		});
	var socialCreditCommButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '�������������',
			handler: function () {
				take_pic("socialCreditComm", "���������");
			}
		});

	var businessTerm = new Ext.ux.DateField({
			id: 'businessTerm',
			fieldLabel: 'Ӫҵ����',
			allowBlank: true,
			anchor: '90%'
		});

	var establishedDate = new Ext.ux.DateField({
			id: 'establishedDate',
			fieldLabel: '��������',
			allowBlank: true,
			anchor: '90%'
		});

	var vendorEmail = new Ext.form.TextField({
			id: 'vendorEmail',
			fieldLabel: '����',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var coRenameFlag = new Ext.form.Checkbox({
			id: 'coRenameFlag',
			boxLabel: '��˾������־',
			hideLabel: true,
			checked: false,
			allowBlank: true
		});

	var carryFlag = new Ext.form.Checkbox({
			id: 'carryFlag',
			boxLabel: 'ת���ͱ�־',
			hideLabel: true,
			checked: false,
			allowBlank: true
		});

	var regAddress = new Ext.form.TextField({
			id: 'regAddress',
			fieldLabel: 'ע���ַ',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var responsiblePerson = new Ext.form.TextField({
			id: 'responsiblePerson',
			fieldLabel: '��ҵ������',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var qualityManager = new Ext.form.TextField({
			id: 'qualityManager',
			fieldLabel: '����������',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var depotAddress = new Ext.form.TextField({
			id: 'depotAddress',
			fieldLabel: '�ֿ��ַ',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var filingVoucher = new Ext.form.TextField({
			id: 'filingVoucher',
			fieldLabel: '����ƾ֤',
			labelWidth: 100,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var matCatOfficial = new Ext.ux.MatCatComboBox({
			fieldLabel: '�ٷ�����',
			id: 'matCatOfficial',
			url: 'dhcstm.mulmatcataction.csp?actiontype=GetChildNode',
			rootId: 'AllMCO',
			rootParam: 'NodeId',
			anchor: '90%'
		});
	//����ִ��
	var comLicIssuedDate = new Ext.ux.DateField({
			id: 'comLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var comLicIssuedDept = new Ext.form.TextField({
			id: 'comLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//˰��Ǽ�֤
	var taxLicIssuedDate = new Ext.ux.DateField({
			id: 'taxLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var taxLicIssuedDept = new Ext.form.TextField({
			id: 'taxLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//��������
	var orgCodeIssuedDate = new Ext.ux.DateField({
			id: 'orgCodeIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var orgCodeIssuedDept = new Ext.form.TextField({
			id: 'orgCodeIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//ҩƷ��Ӫ���֤
	var drugBusLicIssuedDate = new Ext.ux.DateField({
			id: 'drugBusLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var drugBusLicIssuedDept = new Ext.form.TextField({
			id: 'drugBusLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//��е��Ӫ���֤
	var insBusLicIssuedDate = new Ext.ux.DateField({
			id: 'insBusLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var insBusLicIssuedDept = new Ext.form.TextField({
			id: 'insBusLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//��е�������֤
	var insProLicIssuedDate = new Ext.ux.DateField({
			id: 'insProLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var insProLicIssuedDept = new Ext.form.TextField({
			id: 'insProLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//GSP��֤
	var gspLicIssuedDate = new Ext.ux.DateField({
			id: 'gspLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var gspLicIssuedDept = new Ext.form.TextField({
			id: 'gspLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//ҩƷ�������֤
	var drugProLicIssuedDate = new Ext.ux.DateField({
			id: 'drugProLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var drugProLicIssuedDept = new Ext.form.TextField({
			id: 'drugProLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	var MatQuaAgrement = new Ext.form.Checkbox({
			id: 'MatQuaAgrement',
			boxLabel: 'ҽ����е������֤Э����',
			hideLabel: true,
			allowBlank: true
		});

	var SealRecordTable = new Ext.form.Checkbox({
			id: 'SealRecordTable',
			boxLabel: '��Ӧ��ӡ�±���',
			hideLabel: true,
			allowBlank: true
		});
	// ����
	var AccountPeriod = new Ext.form.NumberField({
			id: 'AccountPeriod',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	//��ʼ����Ӱ�ť
	var okButton = new Ext.Toolbar.Button({
			text: '����',
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
					UpdVendorInfo(ss,qualityss); //ִ�и���}
				} else {
					InsVendorInfo(ss,qualityss); //ִ�в���
				}

			}
		});

	//��ʼ��ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
			text: '�ر�',
			iconCls: 'page_close',
			handler: function () {
				if (win) {
					win.hide();
				}
			}
		});
	//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
			labelWidth: 90,
			labelAlign: 'right',
			frame: true,
			autoScroll: true,
			bodyStyle: 'padding:5px;',
			items: [{
					xtype: 'fieldset',
					title: '������Ϣ',
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
					title: '������Ϣ',
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
							hidden: true, //2016-06-27 �Ѳ���Ҫ��ʾ����ʱ����hide,����һ��(����getValue��ȡ��undefined)
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
					title: 'ҵ��Ա��Ȩ����Ϣ',
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

	//��ʼ������
	win = new Ext.Window({
			title: '��Ӧ����Ϣά��',
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

	//��ʾ��Ӧ����Ϣ
	function SetVendorInfo(rowid) {
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=queryByRowId&rowid=' + rowid,
			failure: function (result, request) {
				Msg.info('error', 'ʧ�ܣ�');
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var value = jsonData.info;
					var AllArr=value.split("&");
					var arr = AllArr[0].split("^");
					var QualityStr = AllArr[1];
					//������Ϣ
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
					
					//ҵ��Ա��Ȩ��Ϣ
					Ext.getCmp('bussPersonField').setValue(arr[16]);
					Ext.getCmp('validDate').setValue(arr[17]);
					Ext.getCmp('phoneField').setValue(arr[18]);
					Ext.getCmp('salesIDField').setValue(arr[19]);
					addComboData(Ext.getCmp("parField").getStore(), arr[20], arr[21]);
					Ext.getCmp("parField").setValue(arr[20]);
					Ext.getCmp("abbrevField").setValue(arr[22]);
					Ext.getCmp('presidentTelField').setValue(arr[23]); //���˵绰
					Ext.getCmp('emailField').setValue(arr[24]); //����
					Ext.getCmp('salesCarrTelField').setValue(arr[25]);
					Ext.getCmp('SmsField').setValue(arr[26] == "Y" ? true : false);
					Ext.getCmp('PurchPlatField').setValue(arr[27] == "Y" ? true : false);
					Ext.getCmp('Universal').setValue(arr[28] == "Y" ? true : false);
					Ext.getCmp('barcodePrefix').setValue(arr[29]);
					Ext.getCmp('lstBsDate').setValue(arr[30]);
					Ext.getCmp('salesFaxField').setValue(arr[48]);
					//������Ϣ
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

	//ȡ�ù�Ӧ�̻�����Ϣ��
	function getVendorDataStr() {
		var code = codeField.getValue();
		var name = nameField.getValue();
		/*if (code.trim() == "") {
			Msg.info("warning", "��Ӧ�̴���Ϊ��!");
			return;
		}*/
		if (name.trim() == "") {
			Msg.info("warning", "��Ӧ������Ϊ��!");
			return;
		}
		//���
		var abbrev = abbrevField.getValue();

		//��һ����Ӧ��
		var parVendor = parField.getValue();

		//��Ӧ�̷���
		var categoryId = categoryField.getValue();
		//����(��ϵ�� )
		var President = corporationField.getValue();
		//�������֤
		var president = presidentField.getValue();

		var presidentTel = presidentTelField.getValue();
		//�˻�
		var ctrlAcct = ctrlAcctField.getValue();
		//������
		var ConPerson = bankField.getValue();
		//ע���ʽ�
		var crAvail = crAvailField.getValue();
		if ((crAvail != "" && crAvail < 1) || crAvail === 0) {
			Msg.info("warning", "ע���ʽ�����Ϊ1Ԫ!");
			return;
		}
		//��ͬ��ֹ����
		var lstPoDate = Ext.getCmp('lstPoDate').getValue();
		if ((lstPoDate != "") && (lstPoDate != null)) {
			lstPoDate = lstPoDate.format(ARG_DATEFORMAT);
		}
		//��ַ
		var address = addressField.getValue();
		//��Ӧ�̵绰
		var tel = telField.getValue();
		//��Ӧ�̴���
		var fax = faxField.getValue();
		//���ƹ�Ӧ
		var isLimitSupply = (limitSupplyField.getValue() == true) ? 'Y' : 'N';
		//�ɹ����
		var fee = feeField.getValue();
		//ʹ��״̬
		var state = stateField.getValue();

		

		//ҵ��Ա��Ȩ��Ϣ
		//ҵ��Ա����
		var bussPerson = bussPersonField.getValue();
		//֤����Ч��
		var validDate = Ext.getCmp('validDate').getValue();
		if ((validDate != "") && (validDate != null)) {
			validDate = validDate.format(ARG_DATEFORMAT);
		}
		//ҵ��Ա�绰
		var phone = phoneField.getValue();
		//ҵ��Ա���֤
		var salseID = salesIDField.getValue();
		var email = emailField.getValue();

		var salesCarrTel = salesCarrTelField.getValue();
		var Sms = (SmsField.getValue() == true) ? 'Y' : 'N';
		var PurchPlat = (PurchPlatField.getValue() == true) ? 'Y' : 'N';
		var universal = (Universal.getValue() == true) ? 'Y' : 'N';
		var barcodePre = Ext.getCmp('barcodePrefix').getValue();

		//���ҵ������
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
		var AccountPeriod = Ext.getCmp("AccountPeriod").getValue(); ///����
		
		//ƴdata�ַ���
		var data = code + "^" + name + "^" + tel + "^" + ConPerson + "^" + ctrlAcct + "^" + fee + "^" + fax + "^" + President + "^" + president + "^" + state + "^" + categoryId + "^" + crAvail + "^" + lstPoDate + "^" + address + "^" + isLimitSupply
			+ "^" + bussPerson + "^" + validDate + "^" + phone + "^" + salseID + "^" + parVendor + "^" + abbrev + "^" + presidentTel+ "^" + email + "^" + salesCarrTel + "^" + Sms + "^" + PurchPlat + "^" + universal + "^" + barcodePre 
			+ "^" + lstbsDate + "^" + VendorAlias + "^" + bankLicApprovalNo + "^" + bankLicNo + "^" + businessTerm + "^" + establishedDate + "^" + vendorEmail + "^" + coRenameFlag + "^" + carryFlag + "^" + regAddress + "^" + responsiblePerson + "^" + qualityManager + "^" + depotAddress + "^" + filingVoucher + "^" + matCatOfficial
			+ "^" + salesFaxField + "^" + SealRecordTable + "^" + MatQuaAgrement + "^" + AccountPeriod;
		return data;
	}
	//ȡ�ù�Ӧ��������Ϣ��
	function getVendorQualityDataStr() {
		/*������Ϣ
			�ϸ�������˳��
			ÿ��������ɴ�˳����������^������Ч��^���ʷ�֤����^���ʷ�֤����^Ч�ڳ��ڱ�־^���ڱ�־^��������
		*/
		//����ִ��
		var comLicText = Ext.getCmp('comLicText').getValue();
		//����ִ����Ч��
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
		
		//˰��ִ��
		var taxLicText = Ext.getCmp('taxLicText').getValue();
		//˰��ִ����Ч��
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
		
		//��������
		var orgCodeText = Ext.getCmp('orgCodeText').getValue();
		//����������Ч��
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
		
		//ҩƷ��Ӫ���֤
		var drugBusLicText = Ext.getCmp('drugBusLicText').getValue();
		//ҩƷ��Ӫ���֤��Ч��
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
		
		//��е��Ӫ���֤
		var insBusLicText = Ext.getCmp('insBusLicText').getValue();
		//��е��Ӫ���֤��Ч��
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
		
		//��е�������֤
		var insProLicText = Ext.getCmp('insProLicText').getValue();
		//��е�������֤��Ч��
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
		
		//������ŵ��
		var qualityCommText = Ext.getCmp('qualityCommText').getValue();
		//������ŵ����Ч��
		var qualityCommDateTo = Ext.getCmp('qualityCommDateTo').getValue();
		if ((qualityCommDateTo != "") && (qualityCommDateTo != null)) {
			qualityCommDateTo = qualityCommDateTo.format(ARG_DATEFORMAT);
		}
		var qualityCommType="qualityComm";
		var qualityCommStr=qualityCommType+"^"+qualityCommText+"^"+qualityCommDateTo;
		
		//������Ȩ��
		var agentAuthText = Ext.getCmp('agentAuthText').getValue();
		//������Ȩ����Ч��
		var agentAuthDateTo = Ext.getCmp('agentAuthDateTo').getValue();
		if ((agentAuthDateTo != "") && (agentAuthDateTo != null)) {
			agentAuthDateTo = agentAuthDateTo.format(ARG_DATEFORMAT);
		}
		var agentAuthType="agentAuth";
		var agentAuthStr=agentAuthType+"^"+agentAuthText+"^"+agentAuthDateTo;
		
		//ҩƷ�������֤
		var drugProLicText = Ext.getCmp('drugProLicText').getValue();
		//ҩƷ�������֤��Ч��
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
		
		//ҩƷע������
		var drugRegLicText = Ext.getCmp('drugRegLicText').getValue();
		//ҩƷע��������Ч��
		var drugRegLicDateTo = Ext.getCmp('drugRegLicDateTo').getValue();
		if ((drugRegLicDateTo != "") && (drugRegLicDateTo != null)) {
			drugRegLicDateTo = drugRegLicDateTo.format(ARG_DATEFORMAT);
		}
		var drugRegLicType="drugRegLic";
		var drugRegLicStr=drugRegLicType+"^"+drugRegLicText+"^"+drugRegLicDateTo;
		
		
		//GSP��֤
		var gspLicText = Ext.getCmp('gspLicText').getValue();
		//GSP��֤��Ч��
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
		
		//���������
		var socialCreditCommText = Ext.getCmp('socialCreditCommText').getValue();
		var socialCreditCommDateTo = Ext.getCmp('socialCreditCommDateTo').getValue();
		if ((socialCreditCommDateTo != "") && (socialCreditCommDateTo != null)) {
			socialCreditCommDateTo = socialCreditCommDateTo.format(ARG_DATEFORMAT);
		}
		var socialCreditCommType="socialCreditComm";
		var socialCreditCommStr=socialCreditCommType+"^"+socialCreditCommText+"^"+socialCreditCommDateTo;
		
		
		//��еע��֤
		var insRegLicText = Ext.getCmp('insRegLicText').getValue();
		//��еע��֤��Ч��
		var insRegLicDateTo = Ext.getCmp('insRegLicDateTo').getValue();
		if ((insRegLicDateTo != "") && (insRegLicDateTo != null)) {
			insRegLicDateTo = insRegLicDateTo.format(ARG_DATEFORMAT);
		}
		var insRegLicType="insRegLic";
		var insRegLicStr=insRegLicType+"^"+insRegLicText+"^"+insRegLicDateTo;
		
		
		//����ע��ǼǱ�
		var inletRegLicText = Ext.getCmp('inletRegLicText').getValue();
		//����ע��ǼǱ���Ч��
		var inletRegLicDateTo = Ext.getCmp('inletRegLicDateTo').getValue();
		if ((inletRegLicDateTo != "") && (inletRegLicDateTo != null)) {
			inletRegLicDateTo = inletRegLicDateTo.format(ARG_DATEFORMAT);
		}
		var inletRegLicType="inletRegLic";
		var inletRegLicStr=inletRegLicType+"^"+inletRegLicText+"^"+inletRegLicDateTo;
		
		//����ע��֤
		var inletRLicText = Ext.getCmp('inletRLicText').getValue();
		//����ע��֤
		var inletRLicDateTo = Ext.getCmp('inletRLicDateTo').getValue();
		if ((inletRLicDateTo != "") && (inletRLicDateTo != null)) {
			inletRLicDateTo = inletRLicDateTo.format(ARG_DATEFORMAT);
		}
		var inletRLicType="inletRLic";
		var inletRLicStr=inletRLicType+"^"+inletRLicText+"^"+inletRLicDateTo;
		
		//�ۺ�����ŵ��
		var saleServCommText = Ext.getCmp('saleServCommText').getValue();
		var saleServCommType="saleServComm";
		var saleServCommStr=saleServCommType+"^"+saleServCommText;
		//����ί����
		var legalCommText =  Ext.getCmp('legalCommText').getValue();
		var legalCommType="legalComm";
		var legalCommStr=legalCommType+"^"+legalCommText;
		
		var data = comLicStr+"&"+taxLicStr+"&"+orgCodeStr+"&"+drugBusLicStr+"&"+insBusLicStr
					+"&"+insProLicStr+"&"+qualityCommStr+"&"+agentAuthStr+"&"+drugProLicStr+"&"+drugRegLicStr
					+"&"+gspLicStr+"&"+socialCreditCommStr+"&"+insRegLicStr+"&"+inletRegLicStr+"&"+inletRLicStr
					+"&"+saleServCommStr+"&"+legalCommStr;
		return data;
	}

	//���빩Ӧ��
	function InsVendorInfo(data,qualitydata) {
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=insert',
			params: {
				data: data,
				qualitydata :qualitydata
			},
			method: 'post',
			waitMsg: '������...',
			failure: function (result, request) {
				Msg.info("error", "������������!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					var newRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					win.hide();
					APCVendorGridDs.load({
						params: {
							start: 0,
							limit: APCVendorPagingToolbar.pageSize
						}
					});
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "���ƺʹ����ظ�!");
					} else if (jsonData.info == -2) {
						Msg.info("error", "�����ظ�!");
					} else if (jsonData.info == -3) {
						Msg.info("error", "�����ظ�!");
					} else if (jsonData.info == -6) {
						Msg.info("error", "�˴����Ѵ�����ҩ��ҩ��,���ó�ͨ��!");
					} else if (jsonData.info == -7) {
						Msg.info("error", "�������Ѵ�����ҩ��ҩ��,���ó�ͨ��!");
					} else {
						Msg.info("error", "����ʧ��:" + jsonData.info);
					}
				}
			},
			scope: this
		});
	}
	//���¹�Ӧ��
	function UpdVendorInfo(data,qualitydata) {
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=update',
			params: {
				data: data,
				qualitydata :qualitydata
			},
			waitMsg: '������...',
			failure: function (result, request) {
				Msg.info("error", "������������!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "���³ɹ�!");
					APCVendorGridDs.load({
						params: {
							start: APCVendorPagingToolbar.cursor,
							limit: APCVendorPagingToolbar.pageSize
						}
					});
					win.hide();
				} else {
					if (jsonData.info == -1) {
						Msg.info("error", "���ƺʹ����ظ�!");
					} else if (jsonData.info == -2) {
						Msg.info("error", "�����ظ�!");
					} else if (jsonData.info == -3) {
						Msg.info("error", "�����ظ�!");
					} else {
						Msg.info("error", "���´���:" + jsonData.info);
					}
				}
			},
			scope: this
		});
	}
}

function addpicAPCVendor(type) {
	if (currVendorRowId == "") {
		Msg.info("warning", "���ȱ��湩Ӧ����Ϣ,���ϴ�ͼƬ!");
		return;
	}
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.apcvendornewaction.csp?actiontype=Upload&rowid=' + currVendorRowId, ///ȫ��rowid
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp','pdf'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '�ϴ���Ӧ������ͼƬ',
			base_params: {
				'type': type
			}
		});
	dialog.show();
};

function take_pic(typeCode, typeDesc) {
	if (currVendorRowId == "") {
		Msg.info("warning", "���ȱ��湩Ӧ����Ϣ,������!");
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
