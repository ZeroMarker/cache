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
	var comLicField = new Ext.form.TextField({
			id: 'comLicField',
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
	var comLicValidDate = new Ext.ux.DateField({
			id: 'comLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});
	//˰��ִ��
	var taxLicField = new Ext.form.TextField({
			id: 'taxLicField',
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
	var taxLicValidDate = new Ext.ux.DateField({
			id: 'taxLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��������
	var orgCodeField = new Ext.form.TextField({
			id: 'orgCodeField',
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
	var orgCodeValidDate = new Ext.ux.DateField({
			id: 'orgCodeValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//ҩƷ��Ӫ���֤
	var drugBusLicField = new Ext.form.TextField({
			id: 'drugBusLicField',
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
	var drugBusLicValidDate = new Ext.ux.DateField({
			id: 'drugBusLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��е��Ӫ���֤
	var insBusLicField = new Ext.form.TextField({
			id: 'insBusLicField',
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
	var insBusLicValidDate = new Ext.ux.DateField({
			id: 'insBusLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��е�������֤
	var insProLicField = new Ext.form.TextField({
			id: 'insProLicField',
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
	var insProLicValidDate = new Ext.ux.DateField({
			id: 'insProLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//������ŵ��
	var qualityCommField = new Ext.form.TextField({
			id: 'qualityCommField',
			fieldLabel: '������ŵ��',
			width: 90,
			allowBlank: true,
			selectOnFocus: true
		});
	var qualityCommButton = new Ext.Toolbar.Button({
			text: '�ϴ�',
			tooltip: '�ϴ�������ŵ��',
			handler: function () {
				addpicAPCVendor("qualityComm")
			}
		});
	var qualityCommButtonTP = new Ext.Toolbar.Button({
			text: '����',
			tooltip: '����������ŵ��',
			handler: function () {
				take_pic("qualityComm", "������ŵ��");
			}
		});
	//������ŵ����Ч��
	var qualityCommValidDate = new Ext.ux.DateField({
			id: 'qualityCommValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��Ӧ��Э��
	var agreementField = new Ext.form.TextField({
			id: 'agreementField',
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
	var agentAuthField = new Ext.form.TextField({
			id: 'agentAuthField',
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
	var agentAuthValidDate = new Ext.ux.DateField({
			id: 'agentAuthValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//�ۺ�����ŵ��
	var saleServCommField = new Ext.form.TextField({
			id: 'saleServCommField',
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
	var legalCommField = new Ext.form.TextField({
			id: 'legalCommField',
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
	var drugProLicField = new Ext.form.TextField({
			id: 'drugProLicField',
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
	var drugProLicValidDate = new Ext.ux.DateField({
			id: 'drugProLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//ҩƷע������
	var drugRegLicField = new Ext.form.TextField({
			id: 'drugRegLicField',
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
	var drugRegLicValidDate = new Ext.ux.DateField({
			id: 'drugRegLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//GSP��֤
	var gspLicField = new Ext.form.TextField({
			id: 'gspLicField',
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
	var gspLicValidDate = new Ext.ux.DateField({
			id: 'gspLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//��еע��֤
	var insRegLicField = new Ext.form.TextField({
			id: 'insRegLicField',
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
	var insRegLicValidDate = new Ext.ux.DateField({
			id: 'insRegLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//����ע��ǼǱ�
	var inletRegLicField = new Ext.form.TextField({
			id: 'inletRegLicField',
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
	var inletRegLicValidDate = new Ext.ux.DateField({
			id: 'inletRegLicValidDate',
			fieldLabel: '��Ч��',
			allowBlank: true
		});

	//����ע��֤
	var inletRLicField = new Ext.form.TextField({
			id: 'inletRLicField',
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
	var inletRLicValidDate = new Ext.ux.DateField({
			id: 'inletRLicValidDate',
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

	var registration = new Ext.form.TextField({
			id: 'registration',
			fieldLabel: '���������',
			width: 90,
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var socialCreditExpDate = new Ext.ux.DateField({
			id: 'socialCreditExpDate',
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

	var ComLicIssuedDate = new Ext.ux.DateField({
			id: 'ComLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var ComLicIssuedDept = new Ext.form.TextField({
			id: 'ComLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var RevRegIssuedDate = new Ext.ux.DateField({
			id: 'RevRegIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var RevRegIssuedDept = new Ext.form.TextField({
			id: 'RevRegIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var OrgCodeIssuedDate = new Ext.ux.DateField({
			id: 'OrgCodeIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var OrgCodeIssuedDept = new Ext.form.TextField({
			id: 'OrgCodeIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var DrugManLicIssuedDate = new Ext.ux.DateField({
			id: 'DrugManLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var DrugManLicIssuedDept = new Ext.form.TextField({
			id: 'DrugManLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var MatManLicIssuedDate = new Ext.ux.DateField({
			id: 'MatManLicIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var MatManLicIssuedDept = new Ext.form.TextField({
			id: 'MatManLicIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var MatProIssuedDate = new Ext.ux.DateField({
			id: 'MatProIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var MatProIssuedDept = new Ext.form.TextField({
			id: 'MatProIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var GspIssuedDate = new Ext.ux.DateField({
			id: 'GspIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var GspIssuedDept = new Ext.form.TextField({
			id: 'GspIssuedDept',
			fieldLabel: '����',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var DrugProIssuedDate = new Ext.ux.DateField({
			id: 'DrugProIssuedDate',
			fieldLabel: '��֤����',
			allowBlank: true
		});

	var DrugProIssuedDept = new Ext.form.TextField({
			id: 'DrugProIssuedDept',
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
				if (typeof(ss) == 'undefined' || ss == "") {
					return;
				}
				if (currVendorRowId != '') {
					ss = currVendorRowId + '^' + ss;
					UpdVendorInfo(ss); //ִ�и���}
				} else {
					InsVendorInfo(ss); //ִ�в���
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
							hidden: true, //2016-06-27 �Ѳ���Ҫ��ʾ����ʱ����hide,����һ��(����getValue��ȡ��undefined)
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
					var arr = value.split("^");
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
					//������Ϣ
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
					//ҵ��Ա��Ȩ��Ϣ
					Ext.getCmp('bussPersonField').setValue(arr[46]);
					Ext.getCmp('validDate').setValue(arr[47]);
					Ext.getCmp('phoneField').setValue(arr[48]);
					Ext.getCmp('salesIDField').setValue(arr[49]);
					addComboData(Ext.getCmp("parField").getStore(), arr[50], arr[51]);
					Ext.getCmp("parField").setValue(arr[50]);
					Ext.getCmp("abbrevField").setValue(arr[52]);
					Ext.getCmp('presidentTelField').setValue(arr[53]); //���˵绰
					Ext.getCmp('emailField').setValue(arr[54]); //����
					Ext.getCmp('salesCarrTelField').setValue(arr[55]);
					Ext.getCmp('SmsField').setValue(arr[56] == "Y" ? true : false);
					Ext.getCmp('PurchPlatField').setValue(arr[57] == "Y" ? true : false);
					Ext.getCmp('Universal').setValue(arr[58] == "Y" ? true : false);
					Ext.getCmp('barcodePrefix').setValue(arr[59]);
					Ext.getCmp('lstBsDate').setValue(arr[60]);
					//������Ϣ
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

	//ȡ�ù�Ӧ�̴�
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
		var corporation = corporationField.getValue();
		//�������֤
		var president = presidentField.getValue();

		var presidentTel = presidentTelField.getValue();
		//�˻�
		var ctrlAcct = ctrlAcctField.getValue();
		//������
		var bankName = bankField.getValue();
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

		//������Ϣ
		//����ִ��
		var comLic = comLicField.getValue();
		//����ִ����Ч��
		var comLicValidDate = Ext.getCmp('comLicValidDate').getValue();
		if ((comLicValidDate != "") && (comLicValidDate != null)) {
			comLicValidDate = comLicValidDate.format(ARG_DATEFORMAT);
		}
		//˰��ִ��
		var taxLic = taxLicField.getValue();
		//˰��ִ����Ч��
		var taxLicValidDate = Ext.getCmp('taxLicValidDate').getValue();
		if ((taxLicValidDate != "") && (taxLicValidDate != null)) {
			taxLicValidDate = taxLicValidDate.format(ARG_DATEFORMAT);
		}
		//��������
		var orgCode = orgCodeField.getValue();
		//˰��ִ����Ч��
		var orgCodeValidDate = Ext.getCmp('orgCodeValidDate').getValue();
		if ((orgCodeValidDate != "") && (orgCodeValidDate != null)) {
			orgCodeValidDate = orgCodeValidDate.format(ARG_DATEFORMAT);
		}
		//ҩƷ��Ӫ���֤
		var drugBusLic = drugBusLicField.getValue();
		//ҩƷ��Ӫ���֤��Ч��
		var drugBusLicValidDate = Ext.getCmp('drugBusLicValidDate').getValue();
		if ((drugBusLicValidDate != "") && (drugBusLicValidDate != null)) {
			drugBusLicValidDate = drugBusLicValidDate.format(ARG_DATEFORMAT);
		}

		//��е��Ӫ���֤
		var insBusLic = insBusLicField.getValue();
		//��е��Ӫ���֤��Ч��
		var insBusLicValidDate = Ext.getCmp('insBusLicValidDate').getValue();
		if ((insBusLicValidDate != "") && (insBusLicValidDate != null)) {
			insBusLicValidDate = insBusLicValidDate.format(ARG_DATEFORMAT);
		}
		//��е�������֤
		var insProLic = insProLicField.getValue();
		//��е�������֤��Ч��
		var insProLicValidDate = Ext.getCmp('insProLicValidDate').getValue();
		if ((insProLicValidDate != "") && (insProLicValidDate != null)) {
			insProLicValidDate = insProLicValidDate.format(ARG_DATEFORMAT);
		}
		//������ŵ��
		var qualityComm = qualityCommField.getValue();
		//������ŵ����Ч��
		var qualityCommValidDate = Ext.getCmp('qualityCommValidDate').getValue();
		if ((qualityCommValidDate != "") && (qualityCommValidDate != null)) {
			qualityCommValidDate = qualityCommValidDate.format(ARG_DATEFORMAT);
		}
		//������Ȩ��
		var agentAuth = agentAuthField.getValue();
		//������Ȩ����Ч��
		var agentAuthValidDate = Ext.getCmp('agentAuthValidDate').getValue();
		if ((agentAuthValidDate != "") && (agentAuthValidDate != null)) {
			agentAuthValidDate = agentAuthValidDate.format(ARG_DATEFORMAT);
		}

		//�ۺ�����ŵ��
		var saleServComm = saleServCommField.getValue();
		//����ί����
		var legalComm = legalCommField.getValue();
		//ҩƷ�������֤
		var drugProLic = drugProLicField.getValue();
		//ҩƷ�������֤��Ч��
		var drugProLicValidDate = Ext.getCmp('drugProLicValidDate').getValue();
		if ((drugProLicValidDate != "") && (drugProLicValidDate != null)) {
			drugProLicValidDate = drugProLicValidDate.format(ARG_DATEFORMAT);
		}
		//ҩƷע������
		var drugRegLic = drugRegLicField.getValue();
		//ҩƷע��������Ч��
		var drugRegLicValidDate = Ext.getCmp('drugRegLicValidDate').getValue();
		if ((drugRegLicValidDate != "") && (drugRegLicValidDate != null)) {
			drugRegLicValidDate = drugRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//GSP��֤
		var gspLic = gspLicField.getValue();
		//GSP��֤��Ч��
		var gspLicValidDate = Ext.getCmp('gspLicValidDate').getValue();
		if ((gspLicValidDate != "") && (gspLicValidDate != null)) {
			gspLicValidDate = gspLicValidDate.format(ARG_DATEFORMAT);
		}

		//��еע��֤
		var insRegLic = insRegLicField.getValue();
		//��еע��֤��Ч��
		var insRegLicValidDate = Ext.getCmp('insRegLicValidDate').getValue();
		if ((insRegLicValidDate != "") && (insRegLicValidDate != null)) {
			insRegLicValidDate = insRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//����ע��ǼǱ�
		var inletRegLic = inletRegLicField.getValue();
		//����ע��ǼǱ���Ч��
		var inletRegLicValidDate = Ext.getCmp('inletRegLicValidDate').getValue();
		if ((inletRegLicValidDate != "") && (inletRegLicValidDate != null)) {
			inletRegLicValidDate = inletRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//����ע��֤
		var inletRLic = inletRLicField.getValue();
		//����ע��֤
		var inletRLicValidDate = Ext.getCmp('inletRLicValidDate').getValue();
		if ((inletRLicValidDate != "") && (inletRLicValidDate != null)) {
			inletRLicValidDate = inletRLicValidDate.format(ARG_DATEFORMAT);
		}

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
		var AccountPeriod = Ext.getCmp("AccountPeriod").getValue(); ///����
		
		/*
		��Ӧ�̴���^����^�绰^������^�˻�^�ɹ��޶�^����^����^����id^ʹ�ñ�־^����id^ע���ʽ�^��ͬ��ֹ����^��ַ^���ƹ�Ӧ��־^����ִ��^����ִ��Ч��^������Ȩ��^ҩƷ��Ӫ���֤^ҩƷ��Ӫ���֤��Ч��
		^Gsp��֤^Gsp��֤��Ч��^����ע��֤^����ע��֤��Ч��^����ע��ǼǱ�^����ע��ǼǱ���Ч��^��еע��֤^��еע��֤��Ч��^��е��Ӫ���֤^��е��Ӫ���֤��Ч��^��е�������֤^��е�������֤��Ч��
		^��֯��������^��֯������Ч��^�ۺ�����ŵ��^ҩƷ�������֤^ҩƷ�������֤��Ч��^˰��Ǽ�^˰��Ǽ���Ч��^ҩƷע������^ҩƷע��������Ч��^����ί����^������ŵ��^������ŵ����Ч��^������Ȩ����Ч��^ҵ��Ա����^ҵ��Ա��Ȩ����Ч��^ҵ��Ա�绰^ҵ��Ա���֤^������ϵ�绰
		^email^�м���^����֪ͨ^ƽ̨֪ͨ^ͨ�ñ�־^��ֵ����ǰ׺^���ҵ������^������
		 */
		//ƴdata�ַ���
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

	//���빩Ӧ��
	function InsVendorInfo(data) {
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=insert',
			params: {
				data: data
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
	function UpdVendorInfo(data) {
		var mask = ShowLoadMask(win.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: APCVendorGridUrl + '?actiontype=update', //&data='+data,
			params: {
				data: data
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
			url: 'dhcstm.apcvendoraction.csp?actiontype=Upload&rowid=' + currVendorRowId, ///ȫ��rowid
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
